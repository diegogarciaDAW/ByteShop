<%-- 
    Document   : addProduct
    Created on : 24 mar 2025, 20:47:26
    Author     : diego
--%>

<%@page import="utils.ConexionDB"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.sql.*"%>
<%
    String idBoton = request.getParameter("id");
    LocalDate d1 = LocalDate.now();
    Connection con = ConexionDB.getConnection();
    Statement statem = con.createStatement();
    ResultSet idResult = statem.executeQuery("SELECT login.id FROM login WHERE idEstado=1");

    boolean productoAnadido = false;

    if (idResult.next()) {
        int idLogin = idResult.getInt("login.id");
        ResultSet rs = statem.executeQuery("SELECT CodigoPedido FROM pedidos WHERE id= " + idLogin + " AND estado = 4");

        if (rs.next()) {
            int codigoPedido = rs.getInt("CodigoPedido");
            int idProducto = Integer.parseInt(idBoton);

            ResultSet rs2 = statem.executeQuery("SELECT * FROM detalle_pedido WHERE idPedido = '" + codigoPedido + "' AND idProducto = '" + idProducto + "'");
            if (rs2.next()) {
                int cantidad = rs2.getInt("cantidad") + 1;
                statem.executeUpdate("UPDATE detalle_pedido SET cantidad = '" + cantidad + "' WHERE idPedido = '" + codigoPedido + "' AND idProducto = '" + idProducto + "'");
            } else {
                statem.executeUpdate("INSERT INTO detalle_pedido (idDetalle, idPedido, idProducto, cantidad) VALUES (NULL, '" + codigoPedido + "', '" + idProducto + "', 1)");
            }
            productoAnadido = true;
        } else {
            statem.executeUpdate("INSERT INTO pedidos (CodigoPedido, id, fecha, estado) VALUES (NULL, '" + idLogin + "', '" + d1 + "', 4)");
            rs = statem.executeQuery("SELECT CodigoPedido FROM pedidos WHERE id = " + idLogin + " AND estado = 4");
            if (rs.next()) {
                int codigoPedido = rs.getInt("CodigoPedido");
                statem.executeUpdate("INSERT INTO detalle_pedido (idDetalle, idPedido, idProducto, cantidad) VALUES (NULL, '" + codigoPedido + "', '" + Integer.parseInt(idBoton) + "', 1)");
                productoAnadido = true;
            }
        }
    }
%>

<% if (productoAnadido) {%>
<!-- Bootstrap y FontAwesome -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

<!-- Modal de confirmación -->
<div class="modal fade" id="confirmModal" tabindex="-1" aria-labelledby="confirmModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header bg-success text-white">
                <h5 class="modal-title" id="confirmModalLabel">Producto Añadido</h5>
            </div>
            <div class="modal-body text-center">
                <i class="fa-solid fa-circle-check fa-3x text-success mb-3"></i>
                <p>¡Producto añadido correctamente al carrito!</p>
            </div>
        </div>
    </div>
</div>

<script>
    // Mostrar el modal y redirigir
    window.addEventListener('DOMContentLoaded', function () {
        var myModal = new bootstrap.Modal(document.getElementById('confirmModal'), {
            backdrop: 'static',
            keyboard: false
        });
        myModal.show();

        // Redirigir después de 2 segundos
        setTimeout(function () {
            var paginaAnterior = '<%= request.getHeader("Referer")%>';
            window.location.href = paginaAnterior;
        }, 2000);
    });
</script>
<% } else { %>
<div class="alert alert-danger m-5 text-center">
    <strong>Error:</strong> No se pudo añadir el producto al carrito.
</div>
<% }%>
