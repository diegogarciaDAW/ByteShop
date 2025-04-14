<%-- 
    Document   : incrDism
    Created on : 24 mar 2025, 23:16:05
    Author     : diego
--%>

<%@page import="utils.ConexionDB"%>
<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    String s1 = request.getParameter("id");
    String[] opciones = s1.split("-");

    Connection con = ConexionDB.getConnection();
    Statement statem = con.createStatement();
    ResultSet rs1 = statem.executeQuery("SELECT dp.cantidad, dp.idDetalle FROM pedidos pe "
            + "INNER JOIN login l on l.id = pe.id "
            + "INNER JOIN detalle_pedido dp on dp.idPedido = pe.CodigoPedido "
            + "WHERE l.idEstado = 1 AND pe.estado = 4 AND dp.idProducto = " + opciones[0]);

    if (rs1.next()) {
        int id = rs1.getInt("dp.idDetalle");
        int valor = rs1.getInt("dp.cantidad");

        if (opciones[1].equalsIgnoreCase("D")) {
            valor--;

            if (valor == 0) {
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Confirmar eliminación</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet"/>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <style>
            body {
                background-color: #f8f9fa;
            }
            .modal-content {
                border-radius: 1rem;
                box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.1);
            }
            .modal-header {
                border-bottom: none;
                justify-content: center;
            }
            .modal-footer {
                border-top: none;
                justify-content: center;
            }
            .icon-box {
                font-size: 3rem;
                color: #dc3545;
            }
        </style>
    </head>
    <body class="modal-open">
        <div class="modal fade show" id="confirmDeleteModal" tabindex="-1" style="display: block;" aria-modal="true" role="dialog">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content text-center p-4">
                    <div class="modal-header">
                        <div class="w-100">
                            <div class="icon-box mb-3">
                                <i class="fa-solid fa-circle-exclamation"></i>
                            </div>
                            <h5 class="modal-title fw-bold">¿Eliminar producto?</h5>
                        </div>
                    </div>
                    <div class="modal-body">
                        <p class="mb-0">La cantidad llegó a cero. ¿Deseas eliminar este producto del carrito?</p>
                    </div>
                    <div class="modal-footer">
                        <a href="eliminar.jsp?id=<%=id%>" class="btn btn-danger">
                            <i class="fa-solid fa-trash"></i> Eliminar
                        </a>
                        <a href="../carrito.jsp" class="btn btn-outline-secondary">
                            Cancelar
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
<%
            } else {
                statem.executeUpdate("UPDATE detalle_pedido SET cantidad = '" + valor + "' WHERE idDetalle = " + id);
                response.sendRedirect("../carrito.jsp");
                con.close();
            }
        } else if (opciones[1].equalsIgnoreCase("I")) {
            valor++;
            statem.executeUpdate("UPDATE detalle_pedido SET cantidad = '" + valor + "' WHERE idDetalle = " + id);
            response.sendRedirect("../carrito.jsp");
            con.close();
        }

    } else {
        out.println("ok");
    }
%>
