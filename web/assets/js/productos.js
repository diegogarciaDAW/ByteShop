document.addEventListener("DOMContentLoaded", function () {
    const searchInput = document.getElementById("search");
    const productosList = document.getElementById("productos-list");
    const categoriaFiltro = document.getElementById("categoriaFiltro");
    const precioFiltro = document.getElementById("precioFiltro");

    function cargarProductos() {
        const query = searchInput.value.trim();
        const categoria = categoriaFiltro.value;
        const precio = precioFiltro.value;

        // Construir los parámetros para la URL
        const params = new URLSearchParams({
            ajax: "true",
            search: query,
            categoria: categoria,
            precio: precio
        });

        // Realizar la solicitud AJAX para obtener los productos filtrados
        fetch("productos.jsp?" + params.toString())
            .then(response => {
                if (!response.ok) {
                    throw new Error("Error en la respuesta del servidor");
                }
                return response.text();
            })
            .then(data => {
                productosList.innerHTML = data;  // Actualizar la lista de productos
            })
            .catch(error => {
                console.error("Error al cargar productos:", error);
            });
    }

    // Detectar cambios en la búsqueda
    if (searchInput) {
        searchInput.addEventListener("input", function () {
            cargarProductos();
        });
    }

    // Detectar cambios en el filtro de categoría
    if (categoriaFiltro) {
        categoriaFiltro.addEventListener("change", function () {
            cargarProductos();
        });
    }

    // Detectar cambios en el filtro de precio
    if (precioFiltro) {
        precioFiltro.addEventListener("input", function () {
            cargarProductos();
        });
    }

    // Detectar clic en los botones de agregar al carrito
    document.addEventListener("click", function (e) {
        const btn = e.target.closest(".add-to-cart");
        if (btn) {
            window.location.href = "pagesJSP/addProduct.jsp?id=" + btn.dataset.id;
        }
    });
});