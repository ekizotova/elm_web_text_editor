function setupEditorInterop(app) {
    app.ports.applyFormat.subscribe(function (formatType) {
        const sel = window.getSelection();
        if (!sel.rangeCount) return;

        const range = sel.getRangeAt(0);
        const el = document.createElement(formatType === "bold" ? "b" : "i");
        el.appendChild(range.extractContents());
        range.insertNode(el);

        const content = document.getElementById("editor").innerHTML;
        app.ports.receiveUpdatedText.send(content);
    });
}
