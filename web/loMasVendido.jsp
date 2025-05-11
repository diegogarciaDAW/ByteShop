<%-- 
    Document   : loMasVendido
    Created on : 13 abr 2025, 17:56:23
    Author     : diego
--%>

<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="entities.Producto" %>
<%@ include file="security/verificaUser.jspf" %>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Productos Más Vendidos</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    </head>
    <body>
        <jsp:include page="assets/layout/header.jsp"/>

        <div class="container py-4">
            <div class="row">
                <div class="col-12">
                    <h2 class="mb-4">Los Productos Más Vendidos</h2>
                    <div class="row row-cols-1 row-cols-md-3 g-4">
                        <%
                            List<Producto> productos = (List<Producto>) request.getAttribute("productos");
                            if (productos != null) {
                                for (Producto producto : productos) {
                        %>
                        <div class="col">
                            <div class="card h-100">
                                <img src="data:image/png;base64,<%= producto.getImagenBase64()%>" class="card-img-top" alt="Imagen del producto">
                                <div class="card-body">
                                    <h5 class="card-title"><%= producto.getNombre()%></h5>
                                    <p class="card-text"><%= producto.getDescripcion()%></p>
                                    <div class="d-flex justify-content-between">
                                        <p class="card-text text-primary">
                                            <i class="fas fa-euro-sign"></i> <%= producto.getPrecio()%> €
                                        </p>
                                        <p class="card-text text-success">
                                            <i class="fas fa-check-circle"></i> <%= producto.getTotalVendido()%> vendidos
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <%
                            }
                        } else {
                        %>
                        <div class="alert alert-warning">No se encontraron productos.</div>
                        <% }%>
                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="assets/layout/footer.jsp"/>
    </body>
</html>