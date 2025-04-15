document.addEventListener("DOMContentLoaded", () => {
    const eliminarModal = document.getElementById('confirmarEliminarModal');
    if (eliminarModal) {
        eliminarModal.addEventListener('show.bs.modal', event => {
            const button = event.relatedTarget;
            const categoriaId = button.getAttribute('data-id');
            console.log('ID de la categoría:', categoriaId);
            const confirmBtn = document.getElementById('btnConfirmarEliminar');
            if (confirmBtn && categoriaId) {
                confirmBtn.href = `CategoriaServlet?action=delete&id=${categoriaId}`;
            }
        });
    }
});
