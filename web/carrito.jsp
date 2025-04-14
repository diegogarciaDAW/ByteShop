<%-- 
    Document   : Carrito
    Created on : 24 mar 2025, 21:06:02
    Author     : diego
--%>

<%@page import="utils.ConexionDB"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.util.Base64"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.Date"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="security/verificaLogin.jspf" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Carrito</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://kit.fontawesome.com/5c9ae03052.js" crossorigin="anonymous"></script>
        <script src="assets/js/carrito.js" defer></script>
    </head>
    <body class="d-flex flex-column min-vh-100 bg-light">

        <!-- Header -->
        <jsp:include page="assets/layout/header.jsp"/>

        <!-- Contenido Principal -->
        <div class="container my-4 flex-grow-1">
            <div class="row">
                <!-- Sección de productos en el carrito -->
                <div class="col-lg-8">
                    <%                        String idDP = "";
                        int id = 0;
                        boolean hayProductos = false;
                        Connection con = ConexionDB.getConnection();
                        Statement stmt2 = con.createStatement();
                        ResultSet rs3 = stmt2.executeQuery("SELECT id FROM login WHERE idEstado=1");

                        if (rs3.next()) {
                            id = rs3.getInt("id");
                            PreparedStatement statement = con.prepareStatement(
                                    "SELECT dp.*, pr.*, pe.fecha FROM detalle_pedido dp "
                                    + "INNER JOIN productos pr ON pr.id = dp.idProducto "
                                    + "INNER JOIN pedidos pe ON pe.CodigoPedido = dp.idPedido "
                                    + "WHERE pe.estado = 4 AND pe.id = ?");
                            statement.setInt(1, id);
                            ResultSet rs = statement.executeQuery();

                            if (!rs.isBeforeFirst()) { // Si no hay productos
                    %>
                    <div class="alert alert-danger text-center p-4 fw-bold" role="alert">
                        🛑 Primero debes añadir productos al carrito.
                    </div>
                    <%
                    } else {
                        hayProductos = true;
                        while (rs.next()) {
                            idDP = String.valueOf(rs.getInt("idPedido"));
                    %>
                    <div class="card mb-3 shadow-lg border-0">
                        <div class="row g-0 align-items-center">
                            <div class="col-md-4 text-center p-2">
                                <%
                                    Blob b = rs.getBlob("pr.imagen");
                                    byte[] bdata = b.getBytes(1, (int) b.length());
                                    String imageBase64 = Base64.getEncoder().encodeToString(bdata);
                                %>
                                <img src="data:image/png;base64,<%=imageBase64%>" class="img-fluid rounded" alt="Imagen del producto">
                            </div>
                            <div class="col-md-8">
                                <div class="card-body">
                                    <h5 class="card-title fw-bold">
                                        <%= new String(rs.getString("pr.Nombre").getBytes("ISO-8859-1"), "UTF-8")%>
                                    </h5>
                                    <p class="card-text">Precio: <span class="fw-bold text-success"><%= rs.getDouble("pr.Precio")%> €</span></p>
                                    <div class="input-group w-50">
                                        <button class="btn btn-outline-danger btn-actualizar" data-url="pagesJSP/incrDism.jsp?id=<%= rs.getInt("pr.id")%>-D">-</button>
                                        <input type="text" class="form-control text-center" value="<%= rs.getInt("dp.cantidad")%>" readonly>
                                        <button class="btn btn-outline-success btn-actualizar" data-url="pagesJSP/incrDism.jsp?id=<%= rs.getInt("pr.id")%>-I">+</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <%
                                }
                            }
                            rs.close();
                            statement.close();
                        }
                        rs3.close();
                        stmt2.close();
                        con.close();
                    %>

                </div>

                <!-- Sección de resumen del carrito -->
                <div class="col-lg-4">
                    <div class="card p-4 shadow-lg border-0">
                        <h4 class="text-center fw-bold">🧾 Resumen</h4>
                        <%
                            Connection resumenConexion = ConexionDB.getConnection();
                            PreparedStatement resumenStmt = resumenConexion.prepareStatement(
                                    "SELECT SUM(dp.cantidad * p.precio) AS total_general FROM productos p "
                                    + "JOIN detalle_pedido dp ON p.id = dp.idProducto "
                                    + "JOIN pedidos pe ON dp.idPedido = pe.CodigoPedido "
                                    + "JOIN login l ON pe.id = l.id "
                                    + "WHERE l.idEstado = 1 AND pe.estado = 4");
                            ResultSet elResult = resumenStmt.executeQuery();
                            double precioProductos = 0;
                            if (elResult.next()) {
                                precioProductos = elResult.getDouble("total_general");
                            }
                            elResult.close();
                            resumenStmt.close();
                            resumenConexion.close();
                        %>
                        <p class="fs-5">Subtotal: <span class="fw-bold text-primary"><%= precioProductos%>€</span></p>
                        <p class="fs-5">Mano de obra: <span class="fw-bold text-warning">16€</span></p>
                        <hr>
                        <h5 class="fs-4">Total: <span class="fw-bold text-danger"><%= precioProductos + 16%>€</span></h5>

                        <form action="crearPago" method="post">
                            <input type="hidden" name="idPedido" value="<%= idDP%>">
                            <input type="hidden" name="total" value="<%= precioProductos + 16%>">
                            <button type="submit" class="btn btn-success w-100 mt-3" <%= hayProductos ? "" : "disabled"%>>
                                ✅ Pagar con Stripe
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
        <footer class="py-3">
            <jsp:include page="assets/layout/footer.jsp"/>
        </footer>
    </body>
</html>