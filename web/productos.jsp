<%-- 
    Document   : productos
    Created on : 17 mar 2025, 16:58:53
    Author     : diego
--%>

<%@page import="utils.ConexionDB"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.Base64"%>
<%@page import="java.util.Date"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="security/verificaLogin.jspf" %>

<%    // Verificamos si la solicitud es AJAX
    boolean isAjax = "true".equals(request.getParameter("ajax"));
    String searchQuery = request.getParameter("search");

    String query = "SELECT imagen, id, Nombre, Descripcion, Precio, nombreCategoria, CantidadDisponible "
            + "FROM productos, categoria "
            + "WHERE Productos.categoria = Categoria.categoria";

    if (searchQuery != null && !searchQuery.trim().isEmpty()) {
        query += " AND (Nombre LIKE ? OR Descripcion LIKE ?)";
    }

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        // Usamos ConexionDB para obtener la conexión
        conn = ConexionDB.getConnection();
        stmt = conn.prepareStatement(query);

        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            String likeQuery = "%" + searchQuery + "%";
            stmt.setString(1, likeQuery);
            stmt.setString(2, likeQuery);
        }

        rs = stmt.executeQuery();

        // Si NO es una solicitud AJAX, mostramos el header y la barra de búsqueda
        if (!isAjax) {
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Productos</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined" rel="stylesheet">
        <script src="assets/js/productos.js"></script>
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

                <% // Aquí empieza la parte que se actualizará dinámicamente con AJAX %>
                <%
                    while (rs.next()) {
                        Blob b = rs.getBlob("imagen");
                        byte[] bdata = b.getBytes(1, (int) b.length());
                        String imageBase64 = Base64.getEncoder().encodeToString(bdata);

                        int stock = rs.getInt("CantidadDisponible");
                        boolean hayStock = stock > 0;
                %>
                <div class="col-md-4 mb-4">
                    <div class="card h-100">
                        <img src='data:image/png;base64,<%= imageBase64%>' class="card-img-top" alt="Imagen del producto">
                        <div class="card-body d-flex flex-column">
                            <h5 class="card-title"><%= new String(rs.getString("Nombre").getBytes("ISO-8859-1"), "UTF-8")%></h5>
                            <p class="card-text"><%= new String(rs.getString("Descripcion").getBytes("ISO-8859-1"), "UTF-8")%></p>
                            <p class="text-danger text-center"><b>Precio:</b> <%= rs.getDouble("Precio")%>€</p>
                            <button class="btn btn-primary w-100 mt-auto add-to-cart" data-id="<%= rs.getInt("id")%>" 
                                    <%= hayStock ? "" : "disabled"%>>
                                <i class="fa-solid fa-cart-shopping"></i> 
                                <%= hayStock ? "Agregar" : "Sin stock"%>
                            </button>
                        </div>
                    </div>
                </div>
                <%
                        }
                    } catch (SQLException ex) {
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
