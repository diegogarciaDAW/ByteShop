<%-- 
    Document   : edicion
    Created on : 25 mar 2025, 19:05:46
    Author     : diego
--%>

<%@page import="utils.ConexionDB"%>
<%@page import="send.EmailSender"%>
<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="javax.mail.*"%>
<%@page import="javax.mail.internet.*"%>
<%@page import="java.util.Properties"%>
<!DOCTYPE html>

<%
    Connection con = ConexionDB.getConnection();
    Statement stmt = con.createStatement();

    String st = request.getParameter("id");
    String[] division = st.split("-");

    String mensajeEstado = "";
    String subject = "";
    String correoUsuario = "";
    String nombreUsuario = "";
    String idPedido = division[0];

    String queryCorreo = "SELECT u.Nombre, u.email FROM usuarios u JOIN pedidos p ON u.id = p.id WHERE p.CodigoPedido = ?";
    PreparedStatement pstmtCorreo = con.prepareStatement(queryCorreo);
    pstmtCorreo.setInt(1, Integer.parseInt(idPedido));
    ResultSet rsCorreo = pstmtCorreo.executeQuery();

    if (rsCorreo.next()) {
        correoUsuario = rsCorreo.getString("email");
        nombreUsuario = rsCorreo.getString("Nombre");
    }

    if (division[1].equalsIgnoreCase("EC")) {
        stmt.executeUpdate("UPDATE `pedidos` SET `estado` = '2' WHERE `pedidos`.`CodigoPedido` = " + Integer.parseInt(idPedido));
        subject = "🚚 Tu pedido #" + idPedido + " está en camino";
        mensajeEstado = "🚚 ¡Tu pedido está en camino!\n\n"
                + "Hola " + nombreUsuario + ",\n\n"
                + "Tu pedido con código #" + idPedido + " ha salido de nuestros almacenes y está en ruta hacia tu dirección.\n"
                + "🔍 Recibirás otra notificación cuando sea entregado.\n\n"
                + "Gracias por confiar en nosotros.\n\n"
                + "El equipo de Atención al Cliente";
    } else if (division[1].equalsIgnoreCase("ET")) {
        stmt.executeUpdate("UPDATE `pedidos` SET `estado` = '3' WHERE `pedidos`.`CodigoPedido` = " + Integer.parseInt(idPedido));
        subject = "✅ Tu pedido #" + idPedido + " ha sido entregado";
        mensajeEstado = "✅ ¡Pedido entregado con éxito!\n\n"
                + "Hola " + nombreUsuario + ",\n\n"
                + "Tu pedido con código #" + idPedido + " ha sido entregado satisfactoriamente en la dirección proporcionada.\n"
                + "🎁 Esperamos que estés feliz con tu compra. ¡Nos encantará saber tu opinión!\n\n"
                + "Gracias por elegirnos.\n\n"
                + "El equipo de Atención al Cliente";
    }

    if (!correoUsuario.isEmpty()) {
        try {
            EmailSender.sendEmail(correoUsuario, subject, mensajeEstado); // Usa método HTML
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>



<script>
    // Mostrar una alerta al usuario según el estado actualizado
    <%
        if (division[1].equalsIgnoreCase("E")) {
            out.print("alert('El pedido saldrá de almacenes en 15 días.');");
        } else if (division[1].equalsIgnoreCase("EC")) {
            out.print("alert('El pedido está en camino.');");
        } else if (division[1].equalsIgnoreCase("ET")) {
            out.print("alert('El pedido ha llegado a su destino.');");
        }
    %>
    // Redirigir a la página de "VerPedidosTodos.jsp" después de la alerta
    setTimeout(function () {
        window.location.href = "../verPedidosTodos.jsp";
    }, 2000); // espera 2 segundos antes de redirigir
</script>

<%
    // Cerrar las conexiones y demás recursos
    rsCorreo.close();
    pstmtCorreo.close();
    stmt.close();
    con.close();
%>

