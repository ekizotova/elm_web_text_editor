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
}
