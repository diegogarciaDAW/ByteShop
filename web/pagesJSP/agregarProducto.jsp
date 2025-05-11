<%@page import="utils.ConexionDB"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.net.URL" %>
<%@ page import="java.net.URLConnection" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Añadir/Actualizar Producto</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </head>
    <body>
        <%
            String mensaje = "";
            boolean exito = false;

            try {
                String s1 = request.getParameter("id");
                String nombre = request.getParameter("name");
                String descripcion = request.getParameter("descripcion");
                double precio = Double.parseDouble(request.getParameter("precio"));
                int cantidad = Integer.parseInt(request.getParameter("cant"));
                int categoria = Integer.parseInt(request.getParameter("categoria"));
                String imagenURL = request.getParameter("imagen");

                byte[] imageBytes = null;
                if (imagenURL != null && !imagenURL.trim().isEmpty()) {
                    try {
                        URL url = new URL(imagenURL);
                        URLConnection connection = url.openConnection();
                        InputStream inputStream = connection.getInputStream();
                        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
                        byte[] buffer = new byte[4096];
                        int bytesRead;
                        while ((bytesRead = inputStream.read(buffer)) != -1) {
                            outputStream.write(buffer, 0, bytesRead);
                        }
                        imageBytes = outputStream.toByteArray();
                        inputStream.close();
                        outputStream.close();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }

                Connection con = ConexionDB.getConnection();
                if (s1 == null || s1.isEmpty()) {
                    PreparedStatement stmt = con.prepareStatement("INSERT INTO productos (Nombre, Descripcion, Precio, Categoria, CantidadDisponible, imagen) VALUES (?, ?, ?, ?, ?, ?)");
                    stmt.setString(1, nombre);
                    stmt.setString(2, descripcion);
                    stmt.setDouble(3, precio);
                    stmt.setInt(4, categoria);
                    stmt.setInt(5, cantidad);
                    stmt.setBytes(6, imageBytes != null ? imageBytes : new byte[0]);
                    stmt.executeUpdate();
                    mensaje = "Producto creado correctamente.";
                } else {
                    int id = Integer.parseInt(s1);
                    PreparedStatement stmt;
                    if (imageBytes != null) {
                        stmt = con.prepareStatement("UPDATE productos SET Nombre = ?, Descripcion = ?, Precio = ?, Categoria = ?, CantidadDisponible = ?, imagen = ? WHERE id = ?");
                        stmt.setString(1, nombre);
                        stmt.setString(2, descripcion);
                        stmt.setDouble(3, precio);
                        stmt.setInt(4, categoria);
                        stmt.setInt(5, cantidad);
                        stmt.setBytes(6, imageBytes);
                        stmt.setInt(7, id);
                    } else {
                        stmt = con.prepareStatement("UPDATE productos SET Nombre = ?, Descripcion = ?, Precio = ?, Categoria = ?, CantidadDisponible = ? WHERE id = ?");
                        stmt.setString(1, nombre);
                        stmt.setString(2, descripcion);
                        stmt.setDouble(3, precio);
                        stmt.setInt(4, categoria);
                        stmt.setInt(5, cantidad);
                        stmt.setInt(6, id);
                    }
                    stmt.executeUpdate();
                    mensaje = "Producto actualizado correctamente.";
                }
                con.close();
                exito = true;
            } catch (Exception e) {
                e.printStackTrace();
                mensaje = "Error al procesar el producto. Verifica los datos ingresados.";
            }
        %>

        <!-- Modal Bootstrap -->
        <div class="modal fade" id="resultadoModal" tabindex="-1" aria-labelledby="resultadoLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header <%=(exito ? "bg-success" : "bg-danger")%> text-white">
                        <h5 class="modal-title" id="resultadoLabel"><%= exito ? "Éxito" : "Error"%></h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                    </div>
                    <div class="modal-body">
                        <%= mensaje%>
                    </div>
                    <div class="modal-footer">
                        <% if (exito) { %>
                        <a href="../edicionProductos.jsp" class="btn btn-primary">Aceptar</a>
                        <% } else { %>
                        <a href="javascript:history.back()" class="btn btn-secondary">Volver</a>
                        <% }%>
                    </div>
                </div>
            </div>
        </div>
        <script>
            var modal = new bootstrap.Modal(document.getElementById('resultadoModal'));
            window.addEventListener('load', function () {
                modal.show();
            });
        </script>
    </body>
</html>
