<%-- 
    Document   : CrearCuenta
    Created on : 16 mar 2025, 14:36:06
    Author     : diego
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Crear Cuenta</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
        <script src="https://kit.fontawesome.com/5c9ae03052.js" crossorigin="anonymous"></script>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <link rel="stylesheet" href="assets/css/crearCuenta.css"/>
        <script src="assets/js/crearCuenta.js" defer></script>
    </head>
    <body>
        <% String str = request.getParameter("id");
            if (str == null) { %>
        <jsp:include page="assets/layout/headerSinFuncion.jsp"/>
        <% } else { %>
        <jsp:include page="assets/layout/header.jsp"/>
        <% }%>

        <div id="web1">
            <div class="register-container">
                <h1>Crear Cuenta</h1>
                <form action="pagesJSP/creadorUser.jsp" method="POST">
                    <div class="row g-2">
                        <div class="col-6">
                            <label class="form-label">Nombre</label>
                            <input type="text" name="nombre" class="form-control" required>
                        </div>
                        <div class="col-6">
                            <label class="form-label">Apellido</label>
                            <input type="text" name="apellido" class="form-control" required>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Dirección</label>
                        <input type="text" name="direccion" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Email</label>
                        <input type="email" name="email" class="form-control" required>

                    </div>
                    <div class="row g-2">
                        <div class="col-6">
                            <label class="form-label">Usuario</label>
                            <input type="text" name="user" id="user" class="form-control" required">
                            <div id="availabilityMessage" class="availability-message"></div>
                        </div>
                        <div class="col-6">
                            <label class="form-label">Fecha de Nacimiento</label>
                            <input type="date" name="fechaNac" class="form-control" required>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Contraseña</label>
                        <div class="input-group">
                            <input type="password" id="password1" name="password" class="form-control" required>
                            <button type="button" class="btn btn-outline-secondary" onclick="showPassword()">
                                <span class="material-icons">visibility</span>
                            </button>
                        </div>
                    </div>
                    <button type="submit" class="btn btn-custom" id="registerButton" disabled>
                        <i class="fas fa-user-plus"></i> Registrar
                    </button>
                    <% if (request.getParameter("id") != null) {%>
                    <input type="hidden" name="id" value="<%= request.getParameter("id")%>">
                    <% }%>
                </form>
            </div>
        </div>

        <jsp:include page="assets/layout/footer.jsp" />
    </body>
</html>
