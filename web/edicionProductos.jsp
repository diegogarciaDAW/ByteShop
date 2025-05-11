<%-- 
    Document   : edicionProductos
    Created on : 23 mar 2025, 13:09:20
    Author     : diego
--%>

<%@page import="utils.ConexionDB"%>
<%@page import="java.util.Base64"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="security/verificaAdmin.jspf" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <script src="https://kit.fontawesome.com/5c9ae03052.js" crossorigin="anonymous"></script>
        <title>Edición de Productos</title>
        <script src="assets/js/edicionProductos.js"></script>
    </head>
    <body>
        <jsp:include page="assets/layout/header.jsp" />
        <div class="container mt-4">
            <div class="d-flex justify-content-end align-items-center mb-4">
                <h2 class="text-black me-3">Añadir Producto</h2>
                <a href="aniadir.jsp" class="btn btn-dark rounded-circle d-flex align-items-center justify-content-center" style="width: 50px; height: 50px; font-size: 24px;">
                    <i class="fas fa-plus"></i>
                </a>
            </div>


            <%                try {
                    // Usamos ConexionDB para obtener la conexión
                    Connection conn = ConexionDB.getConnection();

                    Statement stmt = conn.createStatement();
                    ResultSet rs = stmt.executeQuery("SELECT imagen, id, Nombre, Descripcion, Precio, nombreCategoria FROM productos, categoria WHERE Productos.categoria = Categoria.categoria;");
                    String categoria = "";
                    while (rs.next()) {
                        Blob b = rs.getBlob("imagen");
                        byte[] bdata = b.getBytes(1, (int) b.length());
                        String imageBase64 = Base64.getEncoder().encodeToString(bdata);
                        if (!rs.getString("nombreCategoria").equals(categoria)) {
                            categoria = rs.getString("nombreCategoria");
            %>
            <h2 class="mt-5 text-secondary"><%= rs.getString("nombreCategoria")%></h2>
            <div class="row">
                <% }
                %>
                <div class="col-md-4 mb-4">
                    <div class="card h-100 shadow-sm">
                        <img src='data:image/png;base64,<%= imageBase64%>' class="card-img-top img-fluid" alt="Imagen del producto">
                        <div class="card-body">
                            <h5 class="card-title"><%= new String(rs.getString("Nombre").getBytes("ISO-8859-1"), "UTF-8")%></h5>
                            <p class="card-text"><%= new String(rs.getString("Descripcion").getBytes("ISO-8859-1"), "UTF-8")%></p>

                            <p class="text-danger fw-bold">Precio: <%= rs.getDouble("Precio")%>€</p>
                            <div class="d-flex justify-content-between">
                                <button id="<%= rs.getInt("id")%>-E" class="btn btn-outline-warning d-flex align-items-center">
                                    <i class="fas fa-edit me-2"></i> Editar
                                </button>
                                <button id="<%= rs.getInt("id")%>-D" class="btn btn-outline-danger d-flex align-items-center">
                                    <i class="fas fa-trash-alt me-2"></i> Eliminar
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
                <% } %>
            </div>
            <%
                } catch (Exception e) {
                    e.printStackTrace();
                }
            %>
        </div>
        <jsp:include page="assets/layout/footer.jsp"/>
    </body>
</html>

