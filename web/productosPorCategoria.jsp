<%-- 
    Document   : productosPorCategoria
    Created on : 19 mar 2025, 19:35:08
    Author     : diego
--%>

<%@page import="java.util.ArrayList"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.Base64"%>
<%@page import="java.util.Date"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // Detectamos si la solicitud es AJAX
    boolean isAjax = "true".equals(request.getParameter("ajax"));
    String searchQuery = request.getParameter("search");

    String query = "SELECT imagen, id, Nombre, Descripcion, Precio, nombreCategoria "
            + "FROM productos JOIN categoria ON productos.categoria = categoria.categoria";

    if (searchQuery != null && !searchQuery.trim().isEmpty()) {
        query += " WHERE Nombre LIKE ? OR Descripcion LIKE ?";
    }

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/byteshop", "dam2", "1234");
        stmt = conn.prepareStatement(query);

        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            String likeQuery = "%" + searchQuery + "%";
            stmt.setString(1, likeQuery);
            stmt.setString(2, likeQuery);
        }

        rs = stmt.executeQuery();

        if (!isAjax) {
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Productos por Categoría</title>
        <script src="assets/js/productosPorCategoria.js"></script>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    </head>
    <body>
        <jsp:include page="assets/layout/header.jsp"/>

        <div class="container py-4">
            <!-- Barra de búsqueda -->
            <div class="row mb-4">
                <div class="col-12">
                    <input id="search" class="form-control" type="search" placeholder="Buscar productos..." name="search">
                </div>
            </div>

            <div class="row" id="productos-list">
                <%
                    } // Cierre de verificación AJAX
                %>

                <%
                    String categoriaActual = "";
                    while (rs.next()) {
                        Blob b = rs.getBlob("imagen");
                        byte[] bdata = b.getBytes(1, (int) b.length());
                        String imageBase64 = Base64.getEncoder().encodeToString(bdata);

                        // Si cambia de categoría, mostramos un título
                        if (!rs.getString("nombreCategoria").equals(categoriaActual)) {
                            categoriaActual = rs.getString("nombreCategoria");
                %>
                <div class="col-12">
                    <h2 class="mt-4 text-primary"><%= categoriaActual%></h2>
                </div>
                <%
                    }
                %>
                <div class="col-md-4 mb-4">
                    <div class="card h-100 shadow-sm">
                        <img src='data:image/png;base64,<%= imageBase64%>' class="card-img-top" alt="Imagen del producto">
                        <div class="card-body d-flex flex-column">
                            <h5 class="card-title"><%= new String(rs.getString("Nombre").getBytes("ISO-8859-1"), "UTF-8")%></h5>
                            <p class="card-text"><%= new String(rs.getString("Descripcion").getBytes("ISO-8859-1"), "UTF-8")%></p>
                            <p class="text-danger text-center"><b>Precio:</b> <%= rs.getDouble("Precio")%>€</p>
                            <button class="btn btn-primary w-100 mt-auto add-to-cart" data-id="<%= rs.getInt("id")%>">
                                <i class="fa-solid fa-cart-shopping"></i> Agregar
                            </button>
                        </div>
                    </div>
                </div>
                <%
                        }
                    } catch (SQLException | ClassNotFoundException ex) {
                        out.println("<div class='alert alert-danger'>Error: " + ex.getMessage() + "</div>");
                    } finally {
                        if (rs != null) {
                            rs.close();
                        }
                        if (stmt != null) {
                            stmt.close();
                        }
                        if (conn != null) {
                            conn.close();
                        }
                    }
                %>

                <% // Si NO es una solicitud AJAX, cerramos el HTML %>
                <%
                    if (!isAjax) {
                %>
            </div> <!-- Cierre de productos-list -->
        </div> <!-- Cierre de container -->

        <jsp:include page="assets/layout/footer.jsp"/>
    </body>
</html>
<%
    } // Cierre de verificación AJAX
%>

