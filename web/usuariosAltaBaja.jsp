<%-- 
    Document   : usuariosAltaBaja
    Created on : 20 mar 2025, 16:18:57
    Author     : diego
--%>

<%@page import="utils.ConexionDB"%>
<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="security/verificaAdmin.jspf" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Gestión de Usuarios</title>

        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="assets/css/usuariosAB.css"/>
    </head>
    <body>
        <jsp:include page="assets/layout/header.jsp"/>

        <div class="containerUser">

            <div class="header-container">
                <h1>Gestión de Usuarios</h1>
                <a href="crearCuenta.jsp?id=al" class="cta" title="Crear nueva cuenta">+</a>
            </div>

            <div class="table-responsive">
                <table class="table table-bordered">
                    <thead class="thead-light">
                        <tr>
                            <th>Nombre de Usuario</th>
                            <th>Acción</th>
                            <th>Modificar Información</th>
                            <th>Borrar Usuario</th>
                            <th>Ver Información</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            try {
                                Connection con = ConexionDB.getConnection();
                                Statement stmt = con.createStatement();
                                ResultSet rs1 = stmt.executeQuery("SELECT id, user, idAB FROM login");

                                while (rs1.next()) {
                                    int userId = rs1.getInt("id");
                                    String userName = rs1.getString("user");
                                    int estado = rs1.getInt("idAB");
                        %>
                        <tr>
                            <td><%= userName%></td>
                            <td>
                                <% if (estado == 1) {%>
                                <!-- Usuario dado de alta, mostrar opción para dar de baja -->
                                <a href="pagesJSP/modificarDatos.jsp?id=<%= userId%>-B" class="btn btn-danger btn-custom">
                                    <i class="fa fa-arrow-down icon-btn"></i>Dar Baja
                                </a>
                                <% } else {%>
                                <!-- Usuario dado de baja, mostrar opción para dar de alta -->
                                <a href="pagesJSP/modificarDatos.jsp?id=<%= userId%>-A" class="btn btn-success btn-custom">
                                    <i class="fa fa-arrow-up icon-btn"></i>Dar Alta
                                </a>
                                <% }%>
                            </td>
                            <td>
                                <a href="pagesJSP/modificarDatos.jsp?id=<%= userId%>-M" class="btn btn-primary btn-custom">
                                    <i class="fa fa-edit icon-btn"></i>Editar
                                </a>
                            </td>
                            <td>
                                <a href="pagesJSP/modificarDatos.jsp?id=<%= userId%>-BR" class="btn btn-warning btn-custom">
                                    <i class="fa fa-trash icon-btn"></i>Eliminar
                                </a>
                            </td>
                            <td>
                                <a href="DatoUsuarioServlet?id=<%= userId%>" class="btn btn-info btn-custom">
                                    <i class="fa fa-eye icon-btn"></i>Ver
                                </a>
                            </td>
                        </tr>
                        <%
                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- FOOTER -->
        <jsp:include page="assets/layout/footer.jsp"/>
    </body>
</html>
