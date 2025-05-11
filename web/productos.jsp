<%-- 
    Document   : productos
    Created on : 17 mar 2025, 16:58:53
    Author     : diego
--%>

<%@ page import="utils.ConexionDB"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.Base64"%>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="security/verificaLogin.jspf" %>

<%
    boolean isAjax = "true".equals(request.getParameter("ajax"));
    String searchQuery = request.getParameter("search");
    String filtroCategoria = request.getParameter("categoria");
    String filtroPrecio = request.getParameter("precio");

    // Obtener las categorías para el filtro
    ArrayList<String> categorias = new ArrayList<>();
    try (Connection catConn = ConexionDB.getConnection(); PreparedStatement catStmt = catConn.prepareStatement("SELECT nombreCategoria FROM categoria"); ResultSet catRs = catStmt.executeQuery()) {
        while (catRs.next()) {
            categorias.add(catRs.getString("nombreCategoria"));
        }
    } catch (SQLException e) {
        out.println("<div class='alert alert-warning'>No se pudieron cargar las categorías.</div>");
    }

    // Construcción de la consulta SQL
    String query = "SELECT imagen, id, Nombre, Descripcion, Precio, nombreCategoria, CantidadDisponible "
            + "FROM productos, categoria "
            + "WHERE productos.categoria = categoria.categoria";

    if (searchQuery != null && !searchQuery.trim().isEmpty()) {
        query += " AND (Nombre LIKE ? OR Descripcion LIKE ?)";
    }

    if (filtroCategoria != null && !filtroCategoria.isEmpty()) {
        query += " AND nombreCategoria = ?";
    }

    if (filtroPrecio != null && !filtroPrecio.isEmpty()) {
        query += " AND Precio <= ?";
    }

    // Ejecutar la consulta con parámetros
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        conn = ConexionDB.getConnection();
        stmt = conn.prepareStatement(query);

        int paramIndex = 1;
        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            String likeQuery = "%" + searchQuery + "%";
            stmt.setString(paramIndex++, likeQuery);
            stmt.setString(paramIndex++, likeQuery);
        }

        if (filtroCategoria != null && !filtroCategoria.isEmpty()) {
            stmt.setString(paramIndex++, filtroCategoria);
        }

        if (filtroPrecio != null && !filtroPrecio.isEmpty()) {
            stmt.setDouble(paramIndex++, Double.parseDouble(filtroPrecio));
        }

        rs = stmt.executeQuery();

        if (!isAjax) {
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Productos</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
        <script src="assets/js/productos.js" defer></script>
    </head>
    <body>
        <jsp:include page="assets/layout/header.jsp"/>

        <div class="container py-4">
            <div class="row mb-4">
                <!-- Sidebar de filtros -->
                <div class="col-lg-3 mb-3">
                    <div class="card shadow-sm">
                        <div class="card-body">
                            <h5 class="card-title"><i class="fa-solid fa-filter"></i> Filtros</h5>

                            <!-- Categoría -->
                            <div class="mb-3">
                                <label for="categoriaFiltro" class="form-label">Categoría</label>
                                <select id="categoriaFiltro" class="form-select">
                                    <option value="">Todas</option>
                                    <% for (String cat : categorias) { %>
                                        <option value="<%= cat %>"><%= cat %></option>
                                    <% } %>
                                </select>
                            </div>

                            <!-- Precio máximo con slider estilizado -->
                            <div class="mb-3">
                                <label for="precioFiltro" class="form-label">Precio máximo (€)</label>
                                <input type="range" class="form-range" id="precioFiltro" min="0" max="1000" step="0.01"
                                       value="<%= filtroPrecio != null && !filtroPrecio.trim().isEmpty() ? filtroPrecio : "1000" %>"
                                       onchange="updatePrecioMax()" />
                                <div class="d-flex justify-content-between">
                                    <span>0€</span>
                                    <span>1000€</span>
                                </div>
                                <!-- Mostrar el valor seleccionado -->
                                <div class="text-center mt-2">
                                    <span class="fw-bold">Precio máximo: <span id="precioMaxDisplay"><%= filtroPrecio != null && !filtroPrecio.trim().isEmpty() ? filtroPrecio : "1000" %>€</span></span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Buscador + productos -->
                <div class="col-lg-9">
                    <input id="search" class="form-control mb-3" type="search" placeholder="Buscar productos..." name="search">
                    <div class="row" id="productos-list">
                        <%
                            } // Fin if !isAjax
                        %>

                        <%
                            while (rs.next()) {
                                Blob b = rs.getBlob("imagen");
                                byte[] bdata = b.getBytes(1, (int) b.length());
                                String imageBase64 = Base64.getEncoder().encodeToString(bdata);

                                int stock = rs.getInt("CantidadDisponible");
                                boolean hayStock = stock > 0;
                        %>
                        <div class="col-md-6 col-xl-4 mb-4">
                            <div class="card h-100">
                                <img src='data:image/png;base64,<%= imageBase64 %>' class="card-img-top" alt="Imagen del producto">
                                <div class="card-body d-flex flex-column">
                                    <h5 class="card-title"><%= new String(rs.getString("Nombre").getBytes("ISO-8859-1"), "UTF-8")%></h5>
                                    <p class="card-text"><%= new String(rs.getString("Descripcion").getBytes("ISO-8859-1"), "UTF-8")%></p>
                                    <p class="text-danger text-center"><b>Precio:</b> <%= rs.getDouble("Precio") %>€</p>
                                    <button class="btn btn-primary w-100 mt-auto add-to-cart" data-id="<%= rs.getInt("id") %>"
                                            <%= hayStock ? "" : "disabled" %>>
                                        <i class="fa-solid fa-cart-shopping"></i> 
                                        <%= hayStock ? "Agregar" : "Sin stock" %>
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

                            if (!isAjax) {
                        %>
                    </div> <!-- productos-list -->
                </div> <!-- col-lg-9 -->
            </div> <!-- row -->
        </div> <!-- container -->

        <jsp:include page="assets/layout/footer.jsp"/>
    </body>
    <script>
        // Función para actualizar el valor del precio máximo mostrado
        function updatePrecioMax() {
            var precioFiltro = document.getElementById("precioFiltro");
            var precioMaxDisplay = document.getElementById("precioMaxDisplay");
            precioMaxDisplay.textContent = precioFiltro.value + "€";
        }
    </script>
</html>
<%
    }
%>
