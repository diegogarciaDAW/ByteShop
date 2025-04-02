$(document).ready(function () {
    let initialFormData = $("#formEdicion").serialize();

    function checkFormChanges() {
        let currentFormData = $("#formEdicion").serialize();
        $("#saveButton").prop("disabled", initialFormData === currentFormData);
    }

    $("#username").on("input", function () {
        let username = $(this).val().trim();
        let usuarioActual = $("#usuarioActual").val().trim();

        // Verificación de espacios en el nombre de usuario
        if (/\s/.test(username)) {
            $("#usernameFeedback").text("No se pueden poner espacios en el nombre de usuario.").addClass("text-danger").show();
            $("#saveButton").prop("disabled", true);
            return;
        }

        // Validación de usuario
        if (username === "") {
            $("#usernameFeedback").text("El usuario no puede estar vacío.").addClass("text-danger").show();
            $("#saveButton").prop("disabled", true);
            return;
        }

        $.ajax({
            url: "pagesJSP/verificarUsuarioBD.jsp",
            method: "GET",
            data: {username: username, usuarioActual: usuarioActual},
            success: function (response) {
                response = response.trim();
                if (response === "EXISTE") {
                    $("#usernameFeedback").text("Nombre de usuario ya existente.").addClass("text-danger").show();
                    $("#saveButton").prop("disabled", true);
                } else if (response === "NO_CAMBIO") {
                    $("#usernameFeedback").text("El nombre de usuario no ha cambiado.").addClass("text-info").show();
                    checkFormChanges();
                } else {
                    $("#usernameFeedback").text("Nombre de usuario válido.").addClass("text-success").show();
                    checkFormChanges();
                }
            }
        });
    });

    $("#formEdicion input, #formEdicion select").on("input change", function () {
        checkFormChanges();
    });
});