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
    //Este metodo es  para sacar el id de aquella persona que esta conectada 
    if (idResult.next()) {
        int idLogin = idResult.getInt("login.id");
        ResultSet rs = statem.executeQuery("SELECT CodigoPedido FROM pedidos where id= " + idLogin + " AND  estado= 4");
        //Este metodo es para  sacar el codigo pedido por donde despues vamos a referenciar e introducir
        if (rs.next()) {
            int codigoPedido = rs.getInt("CodigoPedido");
            int idProducto = Integer.parseInt(idBoton);

            // Verificar si el producto ya existe en la tabla detalle_pedido para el mismo idPedido
            ResultSet rs2 = statem.executeQuery("SELECT * FROM `detalle_pedido` WHERE `idPedido` = '" + codigoPedido + "' AND `idProducto` = '" + idProducto + "'");
            if (rs2.next()) {
                // El producto ya existe, actualizar la columna cantidad incrementándola en 1
                int cantidad = rs2.getInt("cantidad") + 1;
                statem.executeUpdate("UPDATE `detalle_pedido` SET `cantidad` = '" + cantidad + "' WHERE `idPedido` = '" + codigoPedido + "' AND `idProducto` = '" + idProducto + "'");
            } else {
                // El producto no existe, insertar una nueva fila con cantidad = 1
                statem.executeUpdate("INSERT INTO `detalle_pedido` (`idDetalle`, `idPedido`, `idProducto`, `cantidad`) VALUES (NULL, '" + codigoPedido + "', '" + idProducto + "', 1)");
            }

        } else {
            statem.executeUpdate("INSERT INTO `pedidos` (`CodigoPedido`, `id`, `fecha`, `estado`) VALUES (NULL, '" + idLogin + "', '" + d1 + "', '" + 4 + "')");
            rs = statem.executeQuery("SELECT CodigoPedido FROM pedidos where id= " + idLogin + " AND  estado= 4");
            if (rs.next()) {
                int codigoPedido = rs.getInt("CodigoPedido");
                statem.executeUpdate("INSERT INTO `detalle_pedido` (`idDetalle`, `idPedido`, `idProducto`, `cantidad`) VALUES (NULL, '" + codigoPedido + "', '" + Integer.parseInt(idBoton) + "', 1)");

            }
        }%>
<script>
    alert("Añadido Correctamente");
    setTimeout(function () {
        var paginaAnterior = '<%= request.getHeader("Referer")%>';
        window.location.href = paginaAnterior;
    }, 1000); // espera 2 segundos antes de redirigir
</script>

<%}


%>
