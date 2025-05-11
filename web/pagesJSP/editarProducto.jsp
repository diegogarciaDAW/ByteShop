<%-- 
    Document   : editarProducto.jsp
    Created on : 23 mar 2025, 19:17:50
    Author     : diego
--%>

<%@page import="utils.ConexionDB"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <title>Editar Producto</title>
    </head>
    <body>
        <div class="container mt-5">
            <div class="row justify-content-center">
                <div class="col-md-6">
                    <%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
                    <%@ page import="java.sql.*" %>
                    <%
                        String stri = request.getParameter("id");
                        String[] elString = stri.split("-");
                        if (elString[1].equalsIgnoreCase("E")) {
                            response.sendRedirect("../aniadir.jsp?id=" + elString[0]);
                        } else if (elString[1].equalsIgnoreCase("D")) {
                            Connection con = ConexionDB.getConnection();
                            Statement stmt = con.createStatement();
                            stmt.executeUpdate("DELETE FROM detalle_pedido WHERE idProducto= " + Integer.parseInt(elString[0]));
                            stmt.executeUpdate("DELETE FROM productos WHERE id= " + Integer.parseInt(elString[0]));
                    %>
                    <div class="alert alert-danger text-center" role="alert">
                        <strong>Eliminando producto...</strong>
                    </div>
                    <script>
                        setTimeout(function () {
                            window.location.href = "../edicionProductos.jsp";
                        }, 3000);
                    </script>
                    <% }%>
                </div>
            </div>
        </div>
    </body>
</html>
