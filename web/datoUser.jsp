<%-- 
    Document   : datoUser
    Created on : 18 mar 2025, 20:27:49
    Author     : diego
--%>

<%@page import="utils.ConexionDB"%>
<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Mis Datos</title>
        <!-- Bootstrap CSS -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    </head>
    <body class="d-flex flex-column vh-100">

        <jsp:include page="assets/layout/header.jsp"/>

        <main class="d-flex flex-grow-1 justify-content-center align-items-center">
            <div class="container p-4 rounded shadow bg-light" style="max-width: 600px;">
                <h2 class="text-center mb-4">Mis Datos</h2>
                <table class="table table-bordered rounded-3 overflow-hidden">
                    <%
                        String query;
                        String st = request.getParameter("id");
                        if (st == null) {
                            query = "SELECT usuarios.Nombre, usuarios.Apellido, usuarios.FechadeNacimiento, usuarios.direccion, usuarios.email, login.user, login.Rol "
                                    + "FROM usuarios "
                                    + "JOIN login ON usuarios.id = login.info "
                                    + "WHERE login.idEstado = 1 LIMIT 1";
                        } else {
                            query = "SELECT usuarios.Nombre, usuarios.Apellido, usuarios.FechadeNacimiento, usuarios.direccion, usuarios.email, login.user, login.Rol "
                                    + "FROM usuarios "
                                    + "JOIN login ON usuarios.id = login.info "
                                    + "WHERE login.id = " + Integer.parseInt(st) + " LIMIT 1";
                        }

                        Connection con = ConexionDB.getConnection();
                        Statement stmt = con.createStatement();
                        ResultSet rs = stmt.executeQuery(query);

                        if (rs.next()) {
                    %>
                    <tr><th class="table-primary">Nombre</th><td><%= rs.getString("Nombre")%></td></tr>
                    <tr><th class="table-primary">Apellido</th><td><%= rs.getString("Apellido")%></td></tr>
                    <tr><th class="table-primary">Nombre de Usuario</th><td><%= rs.getString("user")%></td></tr>
                    <tr><th class="table-primary">Dirección</th><td><%= rs.getString("direccion")%></td></tr>
                    <tr><th class="table-primary">Fecha de Nacimiento</th><td><%= new java.text.SimpleDateFormat("dd/MM/yyyy").format(rs.getDate("FechadeNacimiento"))%></td></tr>
                    <tr><th class="table-primary">Email</th><td><%= rs.getString("email")%></td></tr>
                            <%
                                int rol = rs.getInt("Rol");
                                String rolTexto = (rol == 1) ? "Administrador" : (rol == 2) ? "Gestor" : "Cliente";
                            %>
                    <tr><th class="table-primary">Rol</th><td><%= rolTexto%></td></tr>
                            <% }%>
                </table>
            </div>
        </main>

        <jsp:include page="assets/layout/footer.jsp"/>
    </body>
</html>
