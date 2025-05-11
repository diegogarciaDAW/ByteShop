document.addEventListener("click", function (e) {
    if (e.target.type === "submit") {
        window.location.href = "pagesJSP/editarProducto.jsp?id=" + e.target.id;
    }
});
