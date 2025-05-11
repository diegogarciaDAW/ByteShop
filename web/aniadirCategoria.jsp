<%-- 
    Document   : aniadirCategoria
    Created on : 14 abr 2025
    Author     : diego
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="entities.Categoria" %>

<%
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");

    List<Categoria> categorias = (List<Categoria>) request.getAttribute("categorias");
    Categoria categoriaEditar = (Categoria) request.getAttribute("categoriaEditar");

    String mensaje = (String) request.getAttribute("mensaje");
    if (mensaje == null) {
        mensaje = request.getParameter("mensaje");
    }
%>


<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Gestión de Categorías</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    </head>
    <body>
        <jsp:include page="assets/layout/header.jsp"/>

        <div class="container mt-5">
            <h2 class="text-center mb-4">Gestión de Categorías</h2>

            <% if (mensaje != null) {%>
            <div class="alert alert-info alert-dismissible fade show text-center" role="alert">
                <%= mensaje%>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Cerrar"></button>
            </div>
            <% } %>

            <div class="row">
                <!-- Tabla -->
                <div class="col-md-7 mb-5">
                    <div class="card shadow-sm rounded-3">
                        <div class="card-header bg-primary text-white">
                            Categorías existentes
                        </div>
                        <div class="card-body p-0">
                            <table class="table table-hover m-0">
                                <thead class="table-light">
                                    <tr>
                                        <th>Nombre</th>
                                        <th class="text-end">Acciones</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% if (categorias != null && !categorias.isEmpty()) {
                                            for (Categoria c : categorias) {%>
                                    <tr>
                                        <td><%= c.getNombre()%></td>
                                        <td class="text-end">
                                            <a href="CategoriaServlet?action=edit&id=<%= c.getId()%>" class="btn btn-sm btn-warning">
                                                <i class="fas fa-edit"></i> Editar
                                            </a>
                                            <!-- Botón que lanza el modal -->
                                            <button type="button"
                                                    class="btn btn-sm btn-danger"
                                                    data-bs-toggle="modal"
                                                    data-bs-target="#confirmarEliminarModal"
                                                    data-id="<%= c.getId()%>">
                                                <i class="fas fa-trash"></i> Eliminar
                                            </button>

                                        </td>
                                    </tr>
                                    <%  }
                                    } else { %>
                                    <tr>
                                        <td colspan="3" class="text-center">No hay categorías registradas</td>
                                    </tr>
                                    <% }%>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Formulario -->
                <div class="col-md-5 mt-4 mt-md-0">
                    <div class="card shadow-sm rounded-3">
                        <div class="card-header <%= categoriaEditar != null ? "bg-warning" : "bg-success"%> text-white">
                            <%= categoriaEditar != null ? "Editar Categoría" : "Añadir Categoría"%>
                        </div>
                        <div class="card-body">
                            <form action="CategoriaServlet" method="post" accept-charset="UTF-8">
                                <div class="mb-3">
                                    <label for="nombre" class="form-label">Nombre de categoría</label>
                                    <input type="text" class="form-control" name="nombre" id="nombre"
                                           value="<%= categoriaEditar != null ? categoriaEditar.getNombre() : ""%>" required>
                                </div>
                                <% if (categoriaEditar != null) {%>
                                <input type="hidden" name="id" value="<%= categoriaEditar.getId()%>">
                                <input type="hidden" name="action" value="update">
                                <button type="submit" class="btn btn-warning w-100">
                                    <i class="fas fa-save"></i> Guardar Cambios
                                </button>
                                <% } else { %>
                                <input type="hidden" name="action" value="add">
                                <button type="submit" class="btn btn-success w-100">
                                    <i class="fas fa-plus"></i> Añadir Categoría
                                </button>
                                <% }%>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal -->
        <div class="modal fade" id="confirmarEliminarModal" tabindex="-1" aria-labelledby="confirmarEliminarModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Confirmar eliminación</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        ¿Estás seguro de que deseas eliminar esta categoría?
                    </div>
                    <div class="modal-footer">
                        <a id="btnConfirmarEliminar" href="#" class="btn btn-danger">Eliminar</a>
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    </div>
                </div>
            </div>
        </div>
        <jsp:include page="assets/layout/footer.jsp"/>
        <script src="assets/js/confirmDelete.js"></script>
    </body>
</html>
