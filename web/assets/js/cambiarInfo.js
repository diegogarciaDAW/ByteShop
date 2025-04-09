$(document).ready(function () {
    let initialFormData = $("#formEdicion").serialize();
    let usernameValido = true;

    function checkFormChanges() {
        let currentFormData = $("#formEdicion").serialize();
        let cambios = initialFormData !== currentFormData;
        console.log("Cambios detectados:", cambios, "Username válido:", usernameValido);
        $("#saveButton").prop("disabled", !(cambios && usernameValido));
    }

    $("#username").on("input", function () {
        let username = $(this).val().trim();
        let usuarioActual = $("#usuarioActual").val().trim();

        if (/\s/.test(username)) {
            $("#usernameFeedback").text("No se pueden poner espacios en el nombre de usuario.").removeClass().addClass("text-danger").show();
            usernameValido = false;
            checkFormChanges();
            return;
        }

        if (username === "") {
            $("#usernameFeedback").text("El usuario no puede estar vacío.").removeClass().addClass("text-danger").show();
            usernameValido = false;
            checkFormChanges();
            return;
        }

        $.ajax({
            url: "pagesJSP/verificarUsuarioBD.jsp",
            method: "GET",
            data: {username: username, usuarioActual: usuarioActual},
            success: function (response) {
                response = response.trim();
                if (response === "EXISTE") {
                    $("#usernameFeedback").text("Nombre de usuario ya existente.").removeClass().addClass("text-danger").show();
                    usernameValido = false;
                } else {
                    usernameValido = true;
                    if (response === "NO_CAMBIO") {
                        $("#usernameFeedback").text("El nombre de usuario no ha cambiado.").removeClass().addClass("text-info").show();
                    } else {
                        $("#usernameFeedback").text("Nombre de usuario válido.").removeClass().addClass("text-success").show();
                    }
                }
                checkFormChanges();
            }
        });
    });

    // Detectar cambios en cualquier campo
    $("#formEdicion input, #formEdicion select").on("input change", function () {
        checkFormChanges();
    });

    // Hacer la primera validación por si el usuario modifica algo de entrada
    checkFormChanges();
});
