<%-- 
    Document   : enviarCorreos
    Created on : 21 mar 2025, 17:31:13
    Author     : diego
--%>

<%@page import="send.Correos"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">

    <head>
        <meta charset="UTF-8">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Enviando Correo</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet" />
        <script src="https://kit.fontawesome.com/5c9ae03052.js" crossorigin="anonymous"></script>
        <link rel="stylesheet" href="../assets/css/enviarCorreo.css"/>
    </head>

    <body class="bg-light">

        <div class="container py-5">
            <div class="row justify-content-center">
                <div class="col-lg-6 col-md-8 col-12">
                    <div class="card card-contact shadow-lg p-4">
                        <h3 class="text-center">Enviando Correo...</h3>

                        <!-- Mensaje de tipo máquina de escribir -->
                        <div class="typewriter">
                            <div class="slide"></div>
                            <div class="keyboard">Enviando mensaje...</div>
                        </div>

                        <!-- Contenedor para el mensaje de éxito -->
                        <div id="mensajeExito" class="alert-custom hidden mt-4 fade-in">
                            <p>¡Mensaje enviado correctamente!</p>
                            <p>Serás redirigido a la página principal en breve...</p>
                        </div>

                        <%
                            request.setCharacterEncoding("UTF-8");
                            String correo = request.getParameter("correo");
                            String nombre = request.getParameter("nombre");
                            String asunto = request.getParameter("asunto");

                            try {
                                // Llamada al método de envío de correo
                                Correos c1 = new Correos();
                                c1.enviarCorreo(nombre, correo, asunto);
                        %>

                        <script>
                            // Mostrar mensaje de éxito y redirigir
                            setTimeout(function () {
                                // Ocultar mensaje de "Enviando..."
                                document.querySelector('.typewriter').classList.add('hidden');
                                // Mostrar mensaje de éxito
                                document.getElementById('mensajeExito').classList.remove('hidden');

                                // Redirigir después de 4 segundos
                                setTimeout(function () {
                            <%-- Redirección condicional dependiendo del estado de sesión --%>
                            <%
                                String destino = (session.getAttribute("usuario") != null) ? "../inicio.jsp" : "../index.html";
                            %>
                                    window.location.href = "<%= destino%>";
                                }, 4000); // Espera 4 segundos antes de redirigir
                            }, 1000); // Demora de 1 segundo antes de mostrar el mensaje de éxito
                        </script>


                        <%
                            } catch (Exception ex) {
                                out.println("<div class='alert alert-danger text-center'>¡Error al enviar el mensaje!</div>");
                                out.println("<p class='text-center'>" + ex.getLocalizedMessage() + "</p>");
                                ex.printStackTrace();
                            }
                        %>

                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
