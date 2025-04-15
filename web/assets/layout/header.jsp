<%-- 
    Document   : Header
    Created on : 16 mar 2025, 14:36:37
    Author     : diego
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page language="java" import="java.sql.*" %>
<%@ page import="java.sql.*, utils.UserSessionHelper, utils.ConexionDB" %>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title></title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    </head>
    <body>
        <header class="navbar navbar-expand-lg navbar-light bg-light">
            <div class="container">
                <a class="navbar-brand" href="inicio.jsp">
                    <img src="assets/img/logo.png" alt="logo" height="50">
                </a>

                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav"
                        aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                </button>

                <div class="collapse navbar-collapse justify-content-center" id="navbarNav">
                    <ul class="navbar-nav">
                        <li class="nav-item"><a class="nav-link" href="inicio.jsp">INICIO</a></li>
                        <li class="nav-item"><a class="nav-link" href="productos.jsp">PRODUCTOS</a></li>

                        <%
                            try (Connection con = ConexionDB.getConnection()) {
                                if (UserSessionHelper.isUserLoggedIn(con)) {
                                    int rol = UserSessionHelper.getActiveUserRole(con);

                                    if (rol == 1) {
                                        out.println("<li class='nav-item'><a class='nav-link' href='edicionProductos.jsp'>EDITAR PRODUCTOS</a></li>");
                                        out.println("<li class='nav-item'><a class='nav-link' href='CategoriaServlet'>AÑADIR CATEGORÍA</a></li>");
                                        out.println("<li class='nav-item'><a class='nav-link' href='usuariosAltaBaja.jsp'>USUARIOS</a></li>");
                                    } else if (rol == 2) {
                                        out.println("<li class='nav-item'><a class='nav-link' href='verPedidosTodos.jsp'>ESTADO TODOS LOS PEDIDOS</a></li>");
                                    } else if (rol == 3) {
                                        out.println("<li class='nav-item'><a class='nav-link' href='loMasVendido'>LO + VENDIDO</a></li>");
                                    }

                                    out.println("<li class='nav-item'><a class='nav-link' href='verPedidos'>MIS PEDIDOS</a></li>");
                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                        %>
                    </ul>
                </div>

                <div class="d-flex ms-auto">
                    <%
                        try (Connection con = ConexionDB.getConnection()) {
                            String user = UserSessionHelper.getActiveUsername(con);
                            if (user != null) {
                                out.println("<a href='DatoUsuarioServlet' class='nav-link text-dark'><span class='material-icons'>person</span> " + user + "</a>");
                            } else {
                                response.sendRedirect("login.jsp");
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    %>

                    <a href="carrito.jsp" class="btn btn-outline-dark ms-3">
                        <span class="material-icons">shopping_cart</span>
                    </a>

                    <a href="index.jsp" class="btn btn-outline-danger ms-3">
                        <span class="material-icons">logout</span>
                    </a>
                </div>
            </div>
        </header>
    </body>
</html>