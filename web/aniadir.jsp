<%-- 
    Document   : aniadir
    Created on : 23 mar 2025, 22:42:01
    Author     : diego
--%>

<%@page import="java.sql.*"%>
<%@page import="img.MostrarImagen"%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Añadir/Editar Producto</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    </head>
    <body>        
        <jsp:include page="assets/layout/header.jsp" />
        <div class="container mt-5">
            <%
                String s1 = request.getParameter("id"); // ID del producto (si existe)
                String nombre = "";
                String descripcion = "";
                double precio = 0.0;
                int cantidad = 0;
                int categoriaId = 1;
                String imagenURL = "";
                boolean isEdit = (s1 != null && !s1.trim().isEmpty());

                if (isEdit) {
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/byteshop?useUnicode=true&characterEncoding=UTF-8", "root", "");
                        PreparedStatement stmt = conn.prepareStatement("SELECT * FROM productos WHERE id = ?");
                        stmt.setInt(1, Integer.parseInt(s1));
                        ResultSet rs = stmt.executeQuery();
                        if (rs.next()) {
                            nombre = new String(rs.getString("Nombre").getBytes("ISO-8859-1"), "UTF-8");
                            descripcion = new String(rs.getString("Descripcion").getBytes("ISO-8859-1"), "UTF-8");

                            // Validar precio para evitar errores de conversión
                            String precioStr = rs.getString("Precio");
                            if (precioStr != null && !precioStr.trim().isEmpty()) {
                                precio = Double.parseDouble(precioStr);
                            }

                            // Validar cantidad
                            String cantidadStr = rs.getString("CantidadDisponible");
                            if (cantidadStr != null && !cantidadStr.trim().isEmpty()) {
                                cantidad = Integer.parseInt(cantidadStr);
                            }

                            categoriaId = rs.getInt("categoria");

                            // Obtener la URL de la imagen
                            imagenURL = rs.getString("ImagenURL"); // Usar la URL en lugar del BLOB
                            if (imagenURL == null) {
                                imagenURL = "";
                            }
                        }
                        conn.close();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            %>
            <h2 class="mb-4"><%= isEdit ? "Editar Producto" : "Añadir Producto"%></h2>
            <form action="pagesJSP/agregarProducto.jsp" method="post">
                <input type="hidden" name="id" value="<%= s1 != null ? s1 : ""%>">

                <div class="mb-3">
                    <label for="nombre" class="form-label">Nombre:</label>
                    <input type="text" class="form-control" name="name" value="<%= nombre%>" required>
                </div>

                <div class="mb-3">
                    <label for="descripcion" class="form-label">Descripción:</label>
                    <textarea class="form-control" name="descripcion" rows="6" required><%= descripcion%></textarea>
                </div>

                <div class="mb-3">
                    <label for="precio" class="form-label">Precio:</label>
                    <input type="number" step="0.01" class="form-control" name="precio" value="<%= precio%>" required>
                </div>

                <div class="mb-3">
                    <label for="cantidad" class="form-label">Cantidad Disponible:</label>
                    <input type="number" class="form-control" name="cant" value="<%= cantidad%>">
                </div>

                <div class="mb-3">
                    <label for="imagen" class="form-label">Imagen:</label>
                    <% if (isEdit) {%>
                    <img src="MostrarImagen?id=<%= s1%>" class="img-fluid mb-2" alt="Imagen del producto" style="max-width: 150px; height: auto;">
                    <% }%>
                    <input type="text" class="form-control" name="imagen" placeholder="URL de imagen (opcional)">
                </div>


                <div class="mb-3">
                    <label for="categoria" class="form-label">Categoría:</label>
                    <select class="form-control" name="categoria" required>
                        <option value="1" <%= categoriaId == 1 ? "selected" : ""%>>Componentes</option>
                        <option value="2" <%= categoriaId == 2 ? "selected" : ""%>>Ordenadores</option>
                        <option value="3" <%= categoriaId == 3 ? "selected" : ""%>>Smartphones</option>
                        <option value="4" <%= categoriaId == 4 ? "selected" : ""%>>Audio, foto y video</option>
                        <option value="5" <%= categoriaId == 5 ? "selected" : ""%>>Sonido</option>
                    </select>
                </div>

                <button type="submit" class="btn btn-primary w-100">
                    <%= isEdit ? "Actualizar Producto" : "Añadir Producto"%>
                </button>
            </form>
        </div>

        <jsp:include page="assets/layout/footer.jsp"/>
    </body>
</html>
