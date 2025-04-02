document.addEventListener("DOMContentLoaded", () => {
    const userInput = document.getElementById("user");
    const registerButton = document.getElementById("registerButton");
    const messageDiv = document.getElementById("availabilityMessage");
    const passwordInput = document.getElementById("password1");

    if (userInput) {
        userInput.addEventListener("keyup", checkUsernameAvailability);
    }

    function checkUsernameAvailability() {
        let username = userInput.value.trim();

        if (username.length > 0) {
            $.ajax({
                url: 'pagesJSP/verificarUsuarioBD.jsp',
                method: 'GET',
                data: {username: username},
                success: function (response) {
                    response = response.trim();

                    if (response === "EXISTE") {
                        messageDiv.textContent = "Usuario existente";
                        messageDiv.classList.remove("available-message");
                        messageDiv.classList.add("unavailable-message");
                        registerButton.disabled = true;
                    } else if (response === "DISPONIBLE") {
                        messageDiv.textContent = "Usuario válido";
                        messageDiv.classList.remove("unavailable-message");
                        messageDiv.classList.add("available-message");
                        registerButton.disabled = false;
                    } else {
                        messageDiv.textContent = "Error en la verificación del usuario";
                        messageDiv.classList.remove("available-message", "unavailable-message");
                        registerButton.disabled = false;
                    }
                },
                error: function () {
                    messageDiv.textContent = "Error en la verificación del usuario";
                    messageDiv.classList.remove("available-message", "unavailable-message");
                    registerButton.disabled = false;
                }
            });
        } else {
            messageDiv.textContent = "";
            registerButton.disabled = false;
        }
    }

    window.showPassword = function () {
        passwordInput.type = passwordInput.type === "password" ? "text" : "password";
    };
});