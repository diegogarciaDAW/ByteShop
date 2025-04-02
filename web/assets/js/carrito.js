document.addEventListener("DOMContentLoaded", () => {
    restaurarPosicionScroll();

    // Guardar la posición del scroll antes de actualizar la página
    function guardarPosicionScroll() {
        localStorage.setItem('posicionScroll', window.scrollY);
    }

    // Restaurar la posición del scroll después de recargar la página
    function restaurarPosicionScroll() {
        const posicionScroll = localStorage.getItem('posicionScroll');
        if (posicionScroll !== null) {
            window.scrollTo(0, posicionScroll);
            localStorage.removeItem('posicionScroll');
        }
    }

    // Agregar evento a los botones de incrementar y disminuir
    document.querySelectorAll(".btn-actualizar").forEach(boton => {
        boton.addEventListener("click", function () {
            guardarPosicionScroll();
            window.location.href = this.dataset.url;
        });
    });
});