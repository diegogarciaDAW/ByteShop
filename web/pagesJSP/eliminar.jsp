<%-- 
    Document   : eliminar
    Created on : 25 mar 2025, 17:20:41
    Author     : diego
--%>

<%@page import="utils.ConexionDB"%>
<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Connection con = ConexionDB.getConnection();
    Statement statem = con.createStatement();
    String id = request.getParameter("id");

    // Eliminar el producto de la base de datos
    statem.executeUpdate("DELETE FROM `detalle_pedido` WHERE `detalle_pedido`.`idDetalle` = " + id);
%>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Eliminando producto...</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <script>
            // Guardar la posición del scroll antes de redirigir
            localStorage.setItem('posicionScroll', window.scrollY);

            // Redirigir al carrito después de 3 segundos
            setTimeout(function () {
                window.location.href = "../carrito.jsp";
            }, 3000);
        </script>
    </head>
    <body class="d-flex justify-content-center align-items-center vh-100 bg-light">
        <div class="text-center">
            <h3 class="mb-4">⏳ Eliminando producto...</h3>
            <div class="spinner-border text-primary" role="status">
                <span class="visually-hidden">Eliminando...</span>
            </div>
            <p class="mt-3 text-muted">Serás redirigido en unos segundos.</p>
            <button class="btn btn-secondary mt-3" onclick="window.location.href = '../Carrito.jsp'">Cancelar</button>
        </div>
    </body>
</html>