<%-- 
    Document   : login
    Created on : 16 mar 2025, 14:35:05
    Author     : diego
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Login</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
        <script src="https://kit.fontawesome.com/5c9ae03052.js" crossorigin="anonymous"></script>
        <link rel="stylesheet" href="assets/css/login.css"/>
    </head>
    <body>
        <!-- Incluir el header -->
        <jsp:include page="assets/layout/headerSinFuncion.jsp" />

        <div id="web1">
            <div class="login-container">
                <h1>Iniciar sesión</h1>
                <form id="Formulario" method="post" action="pagesJSP/compruebaLogin.jsp">
                    <div class="mb-3">
                        <label class="form-label">Usuario</label>
                        <input type="text" name="usuario" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Contraseña</label>
                        <input type="password" name="password" class="form-control" required>
                    </div>
                    <button type="submit" class="btn btn-custom">Ingresar</button>

                    <%-- Mensaje de error si las credenciales son incorrectas --%>
                    <%
                        String valido = request.getParameter("valido");
                        if (valido != null) {
                    %>
                    <p class="error-message">El usuario o la contraseña no son correctos o la cuenta fue dada de baja.</p>
                    <% }%>

                </form>

                <div class="register-link">
                    <p>¿Eres nuevo cliente? <a href="crearCuenta.jsp">Crear cuenta</a></p>
                </div>
            </div>
        </div>
        <!-- Incluir el footer -->
        <jsp:include page="assets/layout/footer.jsp" />
    </body>
</html>