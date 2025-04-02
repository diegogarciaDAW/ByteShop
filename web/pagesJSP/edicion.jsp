<%-- 
    Document   : edicion
    Created on : 25 mar 2025, 19:05:46
    Author     : diego
--%>

<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>


<%
    Class.forName(
            "com.mysql.jdbc.Driver");
    Connection miConexion = DriverManager.getConnection("jdbc:mysql://localhost:3306/byteshop", "dam2", "1234");

    Statement stmt = miConexion.createStatement();

    String st = request.getParameter("id");
    String[] division = st.split("-");
    if (division[1].equalsIgnoreCase("E")) {
        stmt.executeUpdate("UPDATE `pedidos` SET `estado` = '1' WHERE `pedidos`.`CodigoPedido` =" + Integer.parseInt(division[0]));
%>
<script>
    alert("El pedido saldra de almacenes en 15 dias");
    setTimeout(function () {
        window.location.href = "../verPedidosTodos.jsp";
    }, 1000); // espera 2 segundos antes de redirigir
</script>
<%
} else if (division[1].equalsIgnoreCase("EC")) {
    stmt.executeUpdate("UPDATE `pedidos` SET `estado` = '2' WHERE `pedidos`.`CodigoPedido` =" + Integer.parseInt(division[0]));
%>
<script>
    alert("El pedido esta en Camino");
    setTimeout(function () {
        window.location.href = "../verPedidosTodos.jsp";
    }, 1000); // espera 2 segundos antes de redirigir
</script>
<%
} else if (division[1].equalsIgnoreCase("ET")) {
    stmt.executeUpdate("UPDATE `pedidos` SET `estado` = '3' WHERE `pedidos`.`CodigoPedido` =" + Integer.parseInt(division[0]));
%>
<script>
    alert("El pedido ha llegado a su destino");
    setTimeout(function () {
        window.location.href = "../verPedidosTodos.jsp";
    }, 1000); // espera 2 segundos antes de redirigir
</script>
<%
    }
%>


