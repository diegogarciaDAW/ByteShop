<%-- 
    Document   : VerPedidos
    Created on : 24 mar 2025, 23:27:59
    Author     : diego
--%>

<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>📦 Pedidos Realizados</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

        <!-- Iconos Bootstrap -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">
    </head>
    <body class="d-flex flex-column min-vh-100 bg-light">

        <!-- Header -->
        <jsp:include page="assets/layout/header.jsp"/>

        <div class="container my-4 flex-grow-1">
            <h2 class="text-center mb-4 text-primary fw-bold text-black">📦 Pedidos Realizados</h2>

            <%
                Connection miConexion = null;
                PreparedStatement stmt = null;
                ResultSet rs = null;

                try {
                    miConexion = DriverManager.getConnection("jdbc:mysql://localhost:3306/byteshop", "dam2", "1234");
                    String query = "SELECT pe.CodigoPedido, pe.fecha, ep.Descripcion as estado_pedido "
                            + "FROM pedidos pe "
                            + "JOIN estadopedido ep ON ep.idEstadoPedido = pe.estado "
                            + "JOIN login l ON l.id = pe.id "
                            + "WHERE pe.estado != 4 AND l.idEstado = 1 "
                            + "ORDER BY pe.fecha ASC";

                    stmt = miConexion.prepareStatement(query);
                    rs = stmt.executeQuery();

                    if (!rs.next()) {
            %>
            <div class="alert alert-warning text-center">
                <h4 class="alert-heading">⚠️ ¡Atención!</h4>
                <p>No tienes pedidos realizados. ¡Haz una compra ahora!</p>
            </div>
            <%
            } else {
            %>

            <div class="table-responsive mx-auto shadow-lg rounded">
                <table class="table table-hover table-striped border text-center">
                    <thead class="table-dark">
                        <tr>
                            <th>ID Pedido</th>
                            <th>Estado</th>
                            <th>Fecha</th>
                            <th>Productos</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            do {
                                // Definir el emoji y badge según el estado del pedido
                                String estado = rs.getString("estado_pedido");
                                String claseEstado = "bg-secondary";
                                String emoji = "❓";

                                switch (estado.toLowerCase()) {
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
                            <td class="align-middle"><strong>#<%= rs.getInt("CodigoPedido")%></strong></td>
                            <td class="align-middle">
                                <span class="badge <%= claseEstado%> px-3 py-2"><%= emoji%> <%= estado%></span>
                            </td>
                            <td class="align-middle"><%= rs.getDate("fecha")%></td>
                            <td class="align-middle">
                                <ul class="list-unstyled m-0 p-0 text-start">
                                    <%
                                        try (PreparedStatement statem = miConexion.prepareStatement(
                                                "SELECT p.Nombre, dp.cantidad FROM productos p "
                                                + "JOIN detalle_pedido dp ON dp.idProducto = p.id "
                                                + "WHERE dp.idPedido = ?")) {
                                            statem.setInt(1, rs.getInt("CodigoPedido"));
                                            try (ResultSet rst = statem.executeQuery()) {
                                                while (rst.next()) {
                                    %>
                                    <li>✅ <strong><%= rst.getInt("cantidad")%>x</strong> <%= rst.getString("Nombre")%></li>
                                        <%
                                                    }
                                                }
                                            }
                                        %>
                                </ul>
                            </td>
                        </tr>
                        <%
                            } while (rs.next());
                        %>
                    </tbody>
                </table>
            </div>
            <%
                    }
                } catch (Exception e) {
                    out.println("<div class='alert alert-danger text-center'>❌ Error: " + e.getMessage() + "</div>");
                } finally {
                    if (rs != null) {
                        rs.close();
                    }
                    if (stmt != null) {
                        stmt.close();
                    }
                    if (miConexion != null) {
                        miConexion.close();
                    }
                }
            %>
        </div>

        <!-- Footer -->
        <footer class="py-3">
            <jsp:include page="assets/layout/footer.jsp"/>
        </footer>

    </body>
</html>
