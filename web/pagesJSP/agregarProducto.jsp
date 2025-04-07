<%-- 
    Document   : agragarProducto
    Created on : 24 mar 2025, 13:42:10
    Author     : diego
--%>

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
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Añadir/Actualizar Producto</title>
    </head>
    <body>
        <%
            // Obtener parámetros del formulario
            String s1 = request.getParameter("id");
            String nombre = request.getParameter("name");
            String descripcion = request.getParameter("descripcion");
            double precio = Double.parseDouble(request.getParameter("precio"));
            int cantidad = Integer.parseInt(request.getParameter("cant"));
            int categoria = Integer.parseInt(request.getParameter("categoria"));
            String imagenURL = request.getParameter("imagen");

            byte[] imageBytes = null;

            // Si se proporciona una URL de imagen, tratar de cargarla
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

            try {
                // Establecer conexión con la base de datos
                Connection con = ConexionDB.getConnection();

                if (s1 == null || s1.isEmpty()) {
                    // Insertar nuevo producto
                    PreparedStatement stmt = con.prepareStatement("INSERT INTO productos (Nombre, Descripcion, Precio, Categoria, CantidadDisponible, imagen) VALUES (?, ?, ?, ?, ?, ?)");
                    stmt.setString(1, nombre);
                    stmt.setString(2, descripcion);
                    stmt.setDouble(3, precio);
                    stmt.setInt(4, categoria);
                    stmt.setInt(5, cantidad);

                    // Si hay una nueva imagen, usarla; si no, pasar un arreglo de bytes vacío
                    stmt.setBytes(6, imageBytes != null ? imageBytes : new byte[0]);
                    stmt.executeUpdate();
        %>
        <script>
            alert("Producto creado correctamente.");
            window.location.href = "../edicionProductos.jsp"; // Redirigir a la página de edición de productos
        </script>
        <%
        } else {
            // Si estamos actualizando, obtener el ID del producto
            int id = Integer.parseInt(s1);

            // Preparar la actualización
            PreparedStatement stmt;
            if (imageBytes != null) {
                // Si hay una nueva imagen, actualizar la imagen también
                stmt = con.prepareStatement("UPDATE productos SET Nombre = ?, Descripcion = ?, Precio = ?, Categoria = ?, CantidadDisponible = ?, imagen = ? WHERE id = ?");
                stmt.setBytes(6, imageBytes); // Nueva imagen
            } else {
                // Si no se proporciona nueva imagen, mantener la imagen existente
                stmt = con.prepareStatement("UPDATE productos SET Nombre = ?, Descripcion = ?, Precio = ?, Categoria = ?, CantidadDisponible = ? WHERE id = ?");
            }
            stmt.setString(1, nombre);
            stmt.setString(2, descripcion);
            stmt.setDouble(3, precio);
            stmt.setInt(4, categoria);
            stmt.setInt(5, cantidad);
            stmt.setInt(7, id); // Asegurarse de actualizar el producto correcto
            stmt.executeUpdate();
        %>
        <script>
            alert("Producto actualizado correctamente.");
            window.location.href = "../edicionProductos.jsp"; // Redirigir a la página de edición de productos
        </script>
        <%
            }
            con.close(); // Cerrar la conexión
        } catch (Exception e) {
            e.printStackTrace();
        %>
        <script>
            alert("Error al procesar el producto. Verifica los datos ingresados.");
            window.history.back(); // Volver a la página anterior si hay error
        </script>
        <%
            }
        %>
    </body>
</html>
