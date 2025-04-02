<%-- 
    Document   : Header
    Created on : 16 mar 2025, 14:36:37
    Author     : diego
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page language="java" import="java.sql.*" %>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title></title>

        <!-- Agregar el CSS de Bootstrap -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Agregar los iconos de Google -->
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    </head>
    <body>

        <header class="navbar navbar-expand-lg navbar-light bg-light">
            <div class="container">
                <!-- Logo -->
                <a class="navbar-brand" href="">
                    <img src="assets/img/logo.png" alt="logo" height="50">
                </a>

                <!-- Botón de hamburguesa para pantallas pequeñas -->
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav"
                        aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                </button>

                <!-- Menú que se despliega en pantallas pequeñas -->
                <div class="collapse navbar-collapse justify-content-center" id="navbarNav">
                    <ul class="navbar-nav">
                        <li class="nav-item">
                            <a class="nav-link" href="inicio.jsp">INICIO</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="productosPorCategoria.jsp">CATEGORÍAS</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="productos.jsp">PRODUCTOS</a>
                        </li>
                        <%
                            Connection miConexion = null;
                            try {
                                Class.forName("com.mysql.jdbc.Driver");
                                miConexion = DriverManager.getConnection("jdbc:mysql://localhost:3306/byteshop", "root", "");
                                PreparedStatement stmt = miConexion.prepareStatement("SELECT Rol FROM login WHERE idEstado=1");
                                ResultSet rs = stmt.executeQuery();

                                if (rs.next()) {
                                    int rol = rs.getInt("Rol");
                                    if (rol == 1) {
                                        out.println("<li class='nav-item'><a class='nav-link' href='edicionProductos.jsp'>EDITAR PRODUCTOS</a></li>");
                                        out.println("<li class='nav-item'><a class='nav-link' href='usuariosAltaBaja.jsp'>USUARIOS</a></li>");
                                    } else if (rol == 2) {
                                        out.println("<li class='nav-item'><a class='nav-link' href='verPedidosTodos.jsp'>ESTADO TODOS LOS PEDIDOS</a></li>");
                                    }
                                }
                                out.println("<li class='nav-item'><a class='nav-link' href='verPedidos.jsp'>MIS PEDIDOS</a></li>");
                                out.println("<li class='nav-item'><a class='nav-link' href='datoUser.jsp'>MIS DATOS</a></li>");
                            } catch (Exception e) {
                                out.println(e.getMessage());
                                e.printStackTrace();
                            } finally {
                                if (miConexion != null) {
                                    try {
                                        miConexion.close();
                                    } catch (SQLException e) {
                                        out.println(e.getMessage());
                                        e.printStackTrace();
                                    }
                                }
                            }
                        %>
                    </ul>
                </div>

                <!-- User Info, Cart, and Logout (Aligned to Left) -->
                <div class="d-flex ms-auto">
                    <%
                        try {
                            Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/byteshop", "root", "");
                            String activeUser = getActiveUser(connection);
                            if (activeUser != null) {
                                out.println("<a href='#' class='nav-link text-dark'><span class='material-icons'>person</span> " + activeUser + "</a>");
                            } else {
                                out.println("<a href='login.jsp' class='nav-link text-dark'><span class='material-icons'>person</span></a>");
                                response.sendRedirect("login.jsp");
                            }
                        } catch (SQLException e) {
                            e.printStackTrace();
                        }
                    %>

                    <!-- Icono del carrito -->
                    <a href="carrito.jsp" class="btn btn-outline-dark ms-3">
                        <span class="material-icons">shopping_cart</span>
                    </a>

                    <!-- Icono de logout -->
                    <a href="index.jsp" class="btn btn-outline-danger ms-3">
                        <span class="material-icons">logout</span>
                    </a>
                </div>
            </div>
        </header>

        <!-- Agregar el JS de Bootstrap (bundle incluye Popper.js) -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

        <%!
            private String getActiveUser(Connection connection) throws SQLException {
                String user = null;
                String sql = "SELECT user FROM login WHERE idEstado=1 LIMIT 1";
                try (PreparedStatement stmt = connection.prepareStatement(sql)) {
                    try (ResultSet rs = stmt.executeQuery()) {
                        if (rs.next()) {
                            user = rs.getString("user");
                        }
                    }
                }
                return user;
            }
        %>

    </body>
</html>