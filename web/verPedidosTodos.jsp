<%-- 
    Document   : VerPedidosTodos
    Created on : 25 mar 2025, 19:04:33
    Author     : diego
--%>

<%@page import="utils.ConexionDB"%>
<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="security/verificaGestor.jspf" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Ver Pedidos</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <script src="https://kit.fontawesome.com/5c9ae03052.js" crossorigin="anonymous"></script>
        <script src="assets/js/verPedidosTodos.js"></script>
    </head>
    <body class="bg-light">
        <jsp:include page="assets/layout/header.jsp"/>

        <div class="container my-5">
            <h1 class="text-center mb-4">📦 Pedidos Realizados</h1>

            <%                boolean rsut = false;
                Connection con = ConexionDB.getConnection();
                String query = "SELECT pe.*, ep.Descripcion as estado_pedido, c.nombre, c.apellido "
                        + "FROM pedidos pe "
                        + "JOIN estadopedido ep ON ep.idEstadoPedido = pe.estado "
                        + "JOIN usuarios c ON pe.id = c.id "
                        + "WHERE pe.estado != 4";
                Statement stmt = con.createStatement();
                ResultSet result = stmt.executeQuery("SELECT * FROM login WHERE idEstado = 1");
                if (result.next() && result.getInt("Rol") == 2) {
                    rsut = true;
                }

                ResultSet rs = stmt.executeQuery(query);
                if (!rs.next()) {
            %>
            <div class="alert alert-danger text-center p-4">
                🚫 No se han realizado compras.
            </div>
            <% } else { %>
            <div class="table-responsive">
                <table class="table table-bordered table-hover table-striped">
                    <thead class="table-dark text-center">
                        <tr>
                            <th>Referencia Pedido</th>
                            <th>Cliente</th>
                            <th>Estado</th>
                            <th>Fecha de Realización</th>
                            <th>Productos</th>
                                <% if (rsut) { %>
                            <th>Acciones</th>
                                <% } %>
                        </tr>
                    </thead>
                    <tbody>
                        <% do {%>
                        <tr>
                            <td class="text-center"><strong>#<%= rs.getString("CodigoPedido")%></strong></td>
                            <td class="text-center">
                                <%
                                    String nombreCliente = new String(rs.getString("nombre").getBytes("ISO-8859-1"), "UTF-8");
                                    String apellidoCliente = new String(rs.getString("apellido").getBytes("ISO-8859-1"), "UTF-8");
                                %>
                                <%= nombreCliente + " " + apellidoCliente%>
                            </td>

                            <td class="text-center"><%= rs.getString("estado_pedido")%></td>
                            <td class="text-center"><%= rs.getDate("fecha")%></td>
                            <td>
                                <%

                                    Statement statem = con.createStatement();
                                    ResultSet rst = statem.executeQuery("SELECT p.Nombre, dp.cantidad FROM productos p JOIN detalle_pedido dp ON dp.idProducto = p.id WHERE idPedido=" + rs.getInt("CodigoPedido"));
                                    while (rst.next()) {
                                        String nombreProducto = new String(rst.getString("Nombre").getBytes("ISO-8859-1"), "UTF-8");
                                        out.print("<b>" + rst.getInt("cantidad") + "x</b> " + nombreProducto + "<br>");
                                    }
                                    rst.close();
                                %>
                            </td>
                            <% if (rsut) {%>
                            <td class="text-center">
                                <%
                                    String estadoPedido = rs.getString("estado_pedido");
                                    int pedidoId = rs.getInt("CodigoPedido");

                                    if ("Enviado".equals(estadoPedido)) {
                                %>
                                <button class="btn btn-warning btn-sm m-1 btn-accion" data-pedido-id="<%= pedidoId%>" data-estado="EC">🚕 En Camino</button>
                                <button class="btn btn-success btn-sm m-1 btn-accion" data-pedido-id="<%= pedidoId%>" data-estado="ET">🏠 Entregado</button>
                                <%
                                } else if ("En Camino".equals(estadoPedido)) {
                                %>
                                <button class="btn btn-success btn-sm m-1 btn-accion" data-pedido-id="<%= pedidoId%>" data-estado="ET">🏠 Entregado</button>
                                <%
                                } else if ("Entregado".equals(estadoPedido)) {
                                %>
                                <span class="badge bg-success">✅ El pedido ya ha sido entregado</span>
                                <%
                                    }
                                %>
                            </td>
                            <% } %>
                        </tr>
                        <% } while (rs.next()); %>
                    </tbody>
                </table>
            </div>
            <% }%>
        </div>

        <jsp:include page="assets/layout/footer.jsp"/>
    </body>
</html>

