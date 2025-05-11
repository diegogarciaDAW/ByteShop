<%-- 
    Document   : datoUser
    Created on : 18 mar 2025, 20:27:49
    Author     : diego
--%>

<%@page import="java.util.Map"%>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ include file="security/verificaLogin.jspf" %>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Mis Datos</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    </head>
    <body class="d-flex flex-column vh-100">
        <jsp:include page="assets/layout/header.jsp"/>

        <main class="d-flex flex-grow-1 justify-content-center align-items-center">
            <div class="container p-4 rounded shadow bg-light" style="max-width: 600px;">
                <h2 class="text-center mb-4">Mis Datos</h2>
                <table class="table table-bordered rounded-3 overflow-hidden">
                    <%                Map<String, String> datos = (Map<String, String>) request.getAttribute("datosUsuario");
                        if (datos != null) {
                    %>
                    <tr><th class="table-primary">Nombre</th><td><%= new String(datos.get("Nombre").getBytes("ISO-8859-1"), "UTF-8")%></td></tr>
                    <tr><th class="table-primary">Apellido</th><td><%= new String(datos.get("Apellido").getBytes("ISO-8859-1"), "UTF-8")%></td></tr>
                    <tr><th class="table-primary">Nombre de Usuario</th><td><%= datos.get("user")%></td></tr>
                    <tr><th class="table-primary">Dirección</th><td><%= new String(datos.get("direccion").getBytes("ISO-8859-1"), "UTF-8")%></td></tr>
                    <tr><th class="table-primary">Fecha de Nacimiento</th><td><%= datos.get("FechadeNacimiento")%></td></tr>
                    <tr><th class="table-primary">Email</th><td><%= datos.get("email")%></td></tr>
                    <tr><th class="table-primary">Rol</th><td><%= datos.get("rolTexto")%></td></tr>
                            <%
                            } else {
                            %>
                    <tr>
                        <td colspan="2" class="text-center text-danger">No se pudieron cargar los datos del usuario.</td>
                    </tr>
                    <% }%>
                </table>
            </div>
        </main>

        <jsp:include page="assets/layout/footer.jsp"/>
    </body>
</html>