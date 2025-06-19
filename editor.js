function setupEditorInterop(app) {
    app.ports.applyFormat.subscribe(function (formatType) {
        const sel = window.getSelection();
        const editor = document.getElementById("editor");

        if (!sel.rangeCount) return;

        const range = sel.getRangeAt(0);

        switch (formatType) {
            case "bold":
            case "italic": {
                const tag = formatType === "bold" ? "b" : "i";
                const el = document.createElement(tag);
                el.appendChild(range.extractContents());
                range.insertNode(el);
                break;
            }

            case "clear": {
                const plainText = range.toString();
                range.deleteContents();
                range.insertNode(document.createTextNode(plainText));
                break;
            }

            case "align-left":
            case "align-center":
            case "align-right": {
                const align = formatType.split("-")[1];
                const wrapper = document.createElement("div");
                wrapper.style.textAlign = align;
                wrapper.appendChild(range.extractContents());
                range.insertNode(wrapper);
                break;
            }

            case "tab": {
                range.deleteContents();
                range.insertNode(document.createTextNode("\u00A0\u00A0\u00A0\u00A0")); // 4 non-breaking spaces
                break;
            }

            case "em-dash": {
                if (sel.isCollapsed) {
                    editor.innerHTML = editor.innerHTML.replace(/--/g, "—");
                } else {
                    const fragment = range.extractContents();
                    const text = fragment.textContent.replace(/--/g, "—");
                    range.insertNode(document.createTextNode(text));
                }
                break;
            }
        }

        // Update content back in Elm
        app.ports.receiveUpdatedText.send(editor.innerHTML);
    });

    app.ports.exportContent.subscribe(function (data) {
        const [format, content] = data.split("::", 2);

        let mime = "text/plain";
        let ext = "txt";
        let output = content;

        if (format === "html") {
            mime = "text/html";
            ext = "html";
            output = content;
        } else if (format === "md") {
            mime = "text/markdown";
            ext = "md";
            output = content;
        }

        const blob = new Blob([output], { type: mime });
        const url = URL.createObjectURL(blob);

        const a = document.createElement("a");
        a.href = url;
        a.download = `export.${ext}`;
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
        URL.revokeObjectURL(url);
    });

    app.ports.highlightText.subscribe(function (term) {
        const editor = document.getElementById("editor");
        if (!editor) return;

        const walk = (node) => {
            if (node.nodeType === Node.TEXT_NODE) {
                const idx = node.nodeValue.toLowerCase().indexOf(term.toLowerCase());
                if (idx >= 0 && term.length > 0) {
                    const mark = document.createElement("mark");
                    mark.textContent = node.nodeValue.substr(idx, term.length);

                    const after = node.splitText(idx);
                    after.nodeValue = after.nodeValue.substring(term.length);
                    node.parentNode.insertBefore(mark, after);
                }
            } else if (node.nodeType === Node.ELEMENT_NODE && node.childNodes) {
                for (let i = node.childNodes.length - 1; i >= 0; i--) {
                    walk(node.childNodes[i]);
                }
            }
        };

        editor.querySelectorAll("mark").forEach(m => {
            const text = document.createTextNode(m.textContent);
            m.parentNode.replaceChild(text, m);
        });

        walk(editor);
        app.ports.receiveUpdatedText.send(editor.innerHTML);
    });
}
