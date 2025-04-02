document.addEventListener("DOMContentLoaded", function () {
    const searchInput = document.getElementById("search");

    searchInput.addEventListener("keyup", function () {
        const query = searchInput.value.trim();
        fetchProducts(query);
    });

    function fetchProducts(query) {
        fetch("productosPorCategoria.jsp?search=" + query + "&ajax=true")
                .then(response => response.text())
                .then(data => {
                    document.getElementById("productos-list").innerHTML = data;
                })
                .catch(error => console.error("Error en la búsqueda:", error));
    }
});

document.addEventListener("click", function (e) {
    if (e.target.classList.contains("add-to-cart")) {
        window.location.href = "pagesJSP/addProduct.jsp?id=" + e.target.dataset.id;
    }
});