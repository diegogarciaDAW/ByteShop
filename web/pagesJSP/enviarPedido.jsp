<%-- 
    Document   : enviarPedido
    Created on : 25 mar 2025, 17:34:03
    Author     : diego
--%>

<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Procesando Pedido</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">
    </head>
    <body class="bg-light">
        <div class="container d-flex flex-column align-items-center justify-content-center vh-100">
            <div class="card shadow-lg p-4 text-center">
                <h1 class="text-primary mb-4">
                    <i class="bi bi-box-seam"></i> Procesando tu pedido...
                </h1>
                <div class="spinner-border text-primary" role="status" style="width: 4rem; height: 4rem;">
                    <span class="visually-hidden">Cargando...</span>
                </div>
                <p class="mt-3 text-muted">Por favor, espera mientras preparamos y enviamos tu pedido.</p>
            </div>
        </div>

        <%
            // Obtener parámetros pasados desde el formulario
            String rq = request.getParameter("idPedido");
            String totalParam = request.getParameter("total");

            if (rq == null || rq.isEmpty() || totalParam == null || totalParam.isEmpty()) {
                out.print("<script>alert('Error: Datos insuficientes.'); window.history.back();</script>");
                return;
            }

            int id = Integer.parseInt(rq);
            double totalCompra = Double.parseDouble(totalParam);
            Connection miConexion = null;
            PreparedStatement stmt = null;
            ResultSet rst = null;
            boolean hayStock = true;

            try {
                // Conectar a la base de datos
                Class.forName("com.mysql.cj.jdbc.Driver");
                miConexion = DriverManager.getConnection("jdbc:mysql://localhost:3306/byteshop", "root", "");

                // Verificar stock y actualizarlo
                String queryStock = "SELECT pr.id, pr.CantidadDisponible, dp.cantidad "
                        + "FROM detalle_pedido dp "
                        + "INNER JOIN productos pr ON pr.id = dp.idProducto "
                        + "WHERE dp.idPedido = ?";

                stmt = miConexion.prepareStatement(queryStock);
                stmt.setInt(1, id);
                rst = stmt.executeQuery();

                while (rst.next()) {
                    int idPr = rst.getInt("id");
                    int cantidadDisponible = rst.getInt("CantidadDisponible");
                    int cantidadComprado = rst.getInt("cantidad");

                    if (cantidadDisponible < cantidadComprado) {
                        hayStock = false;
                        out.print("<script>alert('No hay suficiente stock. Disponibles: " + cantidadDisponible + "'); window.location.href = '../productos.jsp';</script>");
                        break;
                    } else {
                        // Actualizar el stock en la base de datos
                        PreparedStatement updateStock = miConexion.prepareStatement("UPDATE productos SET cantidadDisponible = cantidadDisponible - ? WHERE id = ?");
                        updateStock.setInt(1, cantidadComprado);
                        updateStock.setInt(2, idPr);
                        updateStock.executeUpdate();
                        updateStock.close();
                    }
                }
                rst.close();
                stmt.close();

                if (hayStock) {
                    // Cambiar el estado del pedido a "pagado" (estado 1)
                    PreparedStatement updatePedido = miConexion.prepareStatement("UPDATE pedidos SET estado = 1 WHERE CodigoPedido = ?");
                    updatePedido.setInt(1, id);
                    int filasActualizadas = updatePedido.executeUpdate();
                    updatePedido.close();

                    if (filasActualizadas > 0) {
        %>
        <script>
            console.log("Pedido procesado correctamente. Redirigiendo...");
            setTimeout(function () {
                window.location.href = "../verPedidos.jsp";
            }, 2000);
        </script>
        <%
                    } else {
                        out.print("<script>alert('Error al actualizar estado del pedido.'); window.location.href = '../productos.jsp';</script>");
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
                out.print("<script>alert('Error interno.'); window.location.href = '../productos.jsp';</script>");
            } finally {
                if (rst != null) {
                    rst.close();
                }
                if (stmt != null) {
                    stmt.close();
                }
                if (miConexion != null) {
                    miConexion.close();
                }
            }
        %>
    </body>
</html>
