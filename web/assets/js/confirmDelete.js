document.addEventListener("DOMContentLoaded", function () {
    const deleteModal = document.getElementById('confirmDeleteModal');
    if (deleteModal) {
        deleteModal.addEventListener('show.bs.modal', function (event) {
            const button = event.relatedTarget;
            const id = button.getAttribute('data-id');
            const nombre = button.getAttribute('data-nombre');

            const inputId = deleteModal.querySelector('#categoryId');
            const spanNombre = deleteModal.querySelector('#categoryName');

            inputId.value = id;
            spanNombre.textContent = nombre;
        });
    }

    // Mostrar automáticamente el modal de mensaje si existe
    const mensajeModal = document.getElementById('mensajeModal');
    if (mensajeModal) {
        const modal = new bootstrap.Modal(mensajeModal);
        modal.show();
    }
});
F