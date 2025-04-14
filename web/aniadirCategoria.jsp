<%-- 
    Document   : aniadirCategoria
    Created on : 14 abr 2025
    Author     : diego
--%>

<%@page import="utils.ConexionDB"%>
<%@page import="java.sql.*"%>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="security/verificaAdmin.jspf" %>

<%    
    String idEditar = request.getParameter("idEditar");
    String nombreEditar = request.getParameter("nombreEditar");
    String mensaje = request.getParameter("mensaje");
    String tipo = request.getParameter("tipo"); // "success" o "error"
%>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Gestión de Categorías</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body class="d-flex flex-column min-vh-100">

        <jsp:include page="assets/layout/header.jsp"/>

        <main class="container py-5 flex-grow-1">
            <div class="row">
                <!-- Tabla de Categorías -->
                <div class="col-md-7 mb-4">
                    <div class="card shadow-sm">
                        <div class="card-header bg-primary text-white">Categorías Existentes</div>
                        <div class="card-body">
                            <table class="table table-hover table-bordered">
                                <thead class="table-light">
                                    <tr>
                                        <th>Nombre</th>
                                        <th>Acciones</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        try {
                                            Connection con = ConexionDB.getConnection();
                                            String sql = "SELECT * FROM categoria ORDER BY Categoria ASC";
                                            PreparedStatement ps = con.prepareStatement(sql);
                                            ResultSet rs = ps.executeQuery();

                                            while (rs.next()) {
                                                String nombre = rs.getString("nombreCategoria");
                                                int idCategoria = rs.getInt("Categoria");
                                    %>
                                    <tr>
                                        <td><%= nombre%></td>
                                        <td>
                                            <a href="aniadirCategoria.jsp?idEditar=<%= idCategoria%>&nombreEditar=<%= java.net.URLEncoder.encode(nombre, "UTF-8")%>" class="btn btn-sm btn-warning me-1">Editar</a>
                                            <button type="button" class="btn btn-sm btn-danger me-1" data-bs-toggle="modal" data-bs-target="#confirmDeleteModal" data-id="<%= idCategoria%>" data-nombre="<%= nombre%>">
                                                Eliminar
                                            </button>
                                        </td>
                                    </tr>
                                    <%
                                        }
                                        rs.close();
                                        ps.close();
                                        con.close();
                                    } catch (Exception e) {
                                    %>
                                    <tr>
                                        <td colspan="2" class="text-danger text-center">Error: <%= e.getMessage()%></td>
                                    </tr>
                                    <% }%>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Formulario de Añadir/Editar -->
                <div class="col-md-5">
                    <div class="card shadow-sm">
                        <div class="card-body">
                            <h5 class="card-title text-center mb-4">
                                <%= (idEditar != null) ? "Editar Categoría" : "Añadir Nueva Categoría"%>
                            </h5>
                            <form action="<%= (idEditar != null) ? "pagesJSP/editarCategoria.jsp" : "pagesJSP/procesarCategoria.jsp"%>" method="post">
                                <% if (idEditar != null) {%>
                                <input type="hidden" name="idCategoria" value="<%= idEditar%>">
                                <% }%>
                                <div class="mb-3">
                                    <label class="form-label">Nombre de la Categoría</label>
                                    <input type="text" name="nombreCategoria" class="form-control" maxlength="20" required
                                           value="<%= (nombreEditar != null) ? nombreEditar : ""%>">
                                </div>
                                <div class="d-grid">
                                    <button type="submit" class="btn <%= (idEditar != null) ? "btn-warning" : "btn-primary"%>">
                                        <%= (idEditar != null) ? "Actualizar" : "Agregar"%>
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </main>

        <!-- Modal de Confirmación de Eliminación -->
        <div class="modal fade" id="confirmDeleteModal" tabindex="-1" aria-labelledby="confirmDeleteModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header bg-danger text-white">
                        <h5 class="modal-title" id="confirmDeleteModalLabel">Confirmación de Eliminación</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                    </div>
                    <div class="modal-body text-center">
                        ¿Estás seguro de que deseas eliminar la categoría "<span id="categoryName"></span>"?
                    </div>
                    <div class="modal-footer">
                        <form id="deleteForm" action="pagesJSP/eliminarCategoria.jsp" method="get">
                            <input type="hidden" name="idCategoria" id="categoryId" value="">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                            <button type="submit" class="btn btn-danger">Eliminar</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal de mensaje -->
        <% if (mensaje != null && tipo != null) {%>
        <div class="modal fade" id="mensajeModal" tabindex="-1" aria-labelledby="mensajeModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                     <div class="modal-header <%=tipo.equals("success") ? "bg-success text-white"
                            : tipo.equals("error") ? "bg-danger text-white" : "bg-secondary text-white"%>">
                        <h5 class="modal-title" id="mensajeModalLabel">Información</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                    </div>
                    <div class="modal-body text-center">
                        <%= mensaje%>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Aceptar</button>
                    </div>
                </div>
            </div>
        </div>
        <% }%>

        <script src="assets/js/confirmDelete.js"></script>
        <jsp:include page="assets/layout/footer.jsp"/>
    </body>
</html>
