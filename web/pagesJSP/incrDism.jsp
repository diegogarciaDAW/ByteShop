<%-- 
    Document   : incrDism
    Created on : 24 mar 2025, 23:16:05
    Author     : diego
--%>

<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    String s1 = request.getParameter("id");
    String[] opciones = s1.split("-");

    Connection conexion = DriverManager.getConnection("jdbc:mysql://localhost:3306/byteshop", "dam2", "1234");
    Statement statem = conexion.createStatement();
    ResultSet rs1 = statem.executeQuery("SELECT dp.cantidad,dp.idDetalle FROM pedidos pe "
            + "INNER JOIN login l on l.id=pe.id "
            + "INNER JOIN detalle_pedido dp on dp.idPedido=pe.CodigoPedido "
            + "where l.idEstado=1 AND pe.estado=4 AND "
            + "dp.idProducto=" + opciones[0] + ";"
    );
    if (rs1.next()) {
        int id = rs1.getInt("dp.idDetalle");

        int valor = rs1.getInt("dp.cantidad");
        if (opciones[1].equalsIgnoreCase("D")) {
            valor--;
            if (valor == 0) {
%>

<script>
    if (window.confirm("¿Está seguro de eliminar este producto del carrito?")) {
        // Llamar a la página de eliminación con el id del producto
        window.location.href = "eliminar.jsp?id=" +<%=id%>;
    } else {
        window.location.href = "../carrito.jsp";

    }

</script>                  
<%
            } else {
                out.println("ok");

                statem.executeUpdate("UPDATE `detalle_pedido` SET `cantidad` = '" + valor + "' WHERE `detalle_pedido`.`idDetalle` =" + id + ";");
                response.sendRedirect("../carrito.jsp");
                conexion.close();
            }
        } else if (opciones[1].equalsIgnoreCase("I")) {

            valor++;
            statem.executeUpdate("UPDATE `detalle_pedido` SET `cantidad` = '" + valor + "' WHERE `detalle_pedido`.`idDetalle` =" + id + ";");
            response.sendRedirect("../carrito.jsp");
            conexion.close();

        }

    } else {
        out.println("ok");
    }


%>
