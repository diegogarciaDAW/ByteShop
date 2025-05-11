<%-- 
    Document   : VerPedidos
    Created on : 24 mar 2025, 23:27:59
    Author     : diego
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="entities.Pedido" %>
<%@ page import="entities.ProductoPedido" %>
<%@ include file="security/verificaLogin.jspf" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>📦 Pedidos Realizados</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    </head>
    <body class="d-flex flex-column min-vh-100 bg-light">

        <!-- Incluimos el header -->
        <jsp:include page="assets/layout/header.jsp"/>

        <!-- Contenedor principal para los pedidos -->
        <div class="container my-4 flex-grow-1">
            <h2 class="text-center mb-4 text-primary fw-bold">📦 Pedidos Realizados</h2>

            <%        List<Pedido> pedidos = (List<Pedido>) request.getAttribute("pedidos");
                if (pedidos == null || pedidos.isEmpty()) {
            %>
            <div class="alert alert-warning text-center">
                <h4 class="alert-heading">⚠️ ¡Atención!</h4>
                <p>No tienes pedidos realizados. ¡Haz una compra ahora!</p>
            </div>
            <%
            } else {
            %>

            <div class="table-responsive shadow-sm rounded">
                <table class="table table-hover text-center align-middle">
                    <thead class="table-dark">
                        <tr>
                            <th>ID Pedido</th>
                            <th>Estado</th>
                            <th>Fecha</th>
                            <th>Productos</th>
                            <th>Factura</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Pedido p : pedidos) {
                                String claseEstado = "bg-secondary";
                                String emoji = "❓";
                                switch (p.getEstado().toLowerCase()) {
                                    case "pendiente":
                                        claseEstado = "bg-warning text-dark";
                                        emoji = "🟡";
                                        break;
                                    case "enviado":
                                        claseEstado = "bg-primary text-white";
                                        emoji = "📤";
                                        break;
                                    case "en tránsito":
                                        claseEstado = "bg-orange text-white";
                                        emoji = "🚚";
                                        break;
                                    case "entregado":
                                        claseEstado = "bg-success text-white";
                                        emoji = "🏠";
                                        break;
                                }
                        %>
                        <tr>
                            <td>#<%= p.getCodigo()%></td>
                            <td><span class="badge <%= claseEstado%> px-3 py-2"><%= emoji%> <%= p.getEstado()%></span></td>
                            <td><%= p.getFecha()%></td>
                            <td class="text-start">
                                <ul class="list-unstyled m-0">
                                    <% for (ProductoPedido prod : p.getProductos()) {%>
                                    <%
                                        String nombreUTF8 = new String(prod.getNombre().getBytes("ISO-8859-1"), "UTF-8");
                                    %>
                                    <li>✅ <strong><%= prod.getCantidad()%>x</strong> <%= nombreUTF8%></li>

                                    <% }%>
                                </ul>
                            </td>
                            <td>
                                <form action="generarFactura.jsp" method="post" target="_blank">
                                    <input type="hidden" name="codigoPedido" value="<%= p.getCodigo()%>">
                                    <button class="btn btn-outline-primary">📄 Descargar</button>
                                </form>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
            <% }%>
        </div>
        <jsp:include page="assets/layout/footer.jsp"/>

    </body>
</html>
