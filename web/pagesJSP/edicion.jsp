<%-- 
    Document   : edicion
    Created on : 25 mar 2025, 19:05:46
    Author     : diego
--%>

<%@page import="utils.ConexionDB"%>
<%@page import="send.EmailSender"%>
<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Gestión de Pedidos</title>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet">
        <style>
            body {
                background: linear-gradient(135deg, #f8fafc, #e2e8f0);
                font-family: 'Inter', sans-serif;
                display: flex;
                align-items: center;
                justify-content: center;
                height: 100vh;
            }
        </style>
    </head>
    <body>
        <%
            Connection con = null;
            Statement stmt = null;
            PreparedStatement pstmtCorreo = null;
            ResultSet rsCorreo = null;

            String mensajeEstado = "";
            String mensajeModal = "";
            String icono = "info";
            String subject = "";

            try {
                con = ConexionDB.getConnection();
                stmt = con.createStatement();

                String st = request.getParameter("id");
                String[] division = st.split("-");

                String correoUsuario = "";
                String nombreUsuario = "";
                String idPedido = division[0];
                String nuevoEstado = division[1];

                String queryCorreo = "SELECT u.Nombre, u.email FROM usuarios u JOIN pedidos p ON u.id = p.id WHERE p.CodigoPedido = ?";
                pstmtCorreo = con.prepareStatement(queryCorreo);
                pstmtCorreo.setInt(1, Integer.parseInt(idPedido));
                rsCorreo = pstmtCorreo.executeQuery();

                if (rsCorreo.next()) {
                    correoUsuario = rsCorreo.getString("email");
                    nombreUsuario = rsCorreo.getString("Nombre");
                }

                if (nuevoEstado.equalsIgnoreCase("EC")) {
                    stmt.executeUpdate("UPDATE pedidos SET estado = 2 WHERE CodigoPedido = " + Integer.parseInt(idPedido));
                    subject = "🚚 Tu pedido #" + idPedido + " está en camino";
                    mensajeEstado = "Estimado/a " + nombreUsuario + ",\n\n"
                            + "Nos complace informarte que tu pedido con el código #" + idPedido + " ha sido procesado y se encuentra actualmente en camino hacia la dirección indicada.\n\n"
                            + "Muy pronto lo recibirás y esperamos que cumpla con tus expectativas.\n\n"
                            + "Gracias por tu preferencia.\n\n"
                            + "Atentamente,\nServicio de Atención al Cliente";
                    mensajeModal = "El pedido <strong>#" + idPedido + "</strong> ha sido actualizado al estado <strong>En camino</strong>. Se notificó al cliente por correo electrónico.";
                    icono = "info";
                } else if (nuevoEstado.equalsIgnoreCase("ET")) {
                    stmt.executeUpdate("UPDATE pedidos SET estado = 3 WHERE CodigoPedido = " + Integer.parseInt(idPedido));
                    subject = "✅ Tu pedido #" + idPedido + " ha sido entregado";
                    mensajeEstado = "Estimado/a " + nombreUsuario + ",\n\n"
                            + "Te confirmamos que tu pedido con el código #" + idPedido + " ha sido entregado con éxito.\n\n"
                            + "Esperamos que estés satisfecho/a con tu compra. Si tienes alguna duda o comentario, no dudes en contactarnos.\n\n"
                            + "Gracias por confiar en nosotros.\n\n"
                            + "Atentamente,\nServicio de Atención al Cliente";
                    mensajeModal = "El pedido <strong>#" + idPedido + "</strong> ha sido marcado como <strong>Entregado</strong>. Se ha enviado la confirmación al cliente por correo electrónico.";
                    icono = "success";
                } else {
                    mensajeModal = "El estado del pedido fue actualizado.";
                }

                if (!correoUsuario.isEmpty()) {
                    try {
                        EmailSender.sendEmail(correoUsuario, subject, mensajeEstado);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
        %>

        <script>
            Swal.fire({
                title: 'Estado actualizado',
                html: '<div style="font-size: 1.1em;"><%= mensajeModal%></div>',
                icon: '<%= icono%>',
                confirmButtonText: 'Continuar',
                confirmButtonColor: '#3085d6',
                background: '#fff',
                didClose: () => {
                    window.location.href = '../verPedidosTodos.jsp';
                }
            });

            setTimeout(() => {
                window.location.href = '../verPedidosTodos.jsp';
            }, 5000);
        </script>

        <%
        } catch (Exception e) {
            e.printStackTrace();
        %>
        <script>
            Swal.fire({
                title: '❌ Error al actualizar',
                text: 'Hubo un problema actualizando el estado del pedido.',
                icon: 'error',
                confirmButtonText: 'Aceptar',
                confirmButtonColor: '#d33',
                didClose: () => {
                    window.location.href = '../verPedidosTodos.jsp';
                }
            });
        </script>
        <%
            } finally {
                if (rsCorreo != null) {
                    rsCorreo.close();
                }
                if (pstmtCorreo != null) {
                    pstmtCorreo.close();
                }
                if (stmt != null) {
                    stmt.close();
                }
                if (con != null) {
                    con.close();
                }
            }
        %>
    </body>
</html>
