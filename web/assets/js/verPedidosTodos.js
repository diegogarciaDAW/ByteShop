document.addEventListener("DOMContentLoaded", () => {
    document.querySelectorAll(".btn-accion").forEach((button) => {
        button.addEventListener("click", (event) => {
            const pedidoId = event.target.dataset.pedidoId;
            const estado = event.target.dataset.estado;
            window.location.href = `pagesJSP/edicion.jsp?id=${pedidoId}-${estado}`;
        });
    });
});