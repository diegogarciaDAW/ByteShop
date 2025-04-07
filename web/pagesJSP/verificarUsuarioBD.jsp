<%-- 
    Document   : verificarUsuarioBD
    Created on : 20 mar 2025, 23:57:15
    Author     : diego
--%>

<%@page import="utils.ConexionDB"%>
<%@page import="java.sql.*"%>
<%@page contentType="text/plain" pageEncoding="UTF-8"%>

<%
    String username = request.getParameter("username").trim();
    String usuarioActual = request.getParameter("usuarioActual"); // Puede ser nulo

    if (username == null || username.isEmpty()) {
        out.print("ERROR");
        return;
    }

    Connection con = ConexionDB.getConnection();

    // Verificar si el usuario ya existe, ignorando si es el mismo usuario que se está editando
    PreparedStatement stmt = con.prepareStatement("SELECT user FROM login WHERE user = ?");
    stmt.setString(1, username);
    ResultSet rs = stmt.executeQuery();

    if (rs.next()) {
        if (usuarioActual != null && username.equalsIgnoreCase(usuarioActual)) {
            out.print("NO_CAMBIO"); // El usuario es el mismo que ya tenía
        } else {
            out.print("EXISTE"); // El usuario ya existe en otro registro
        }
    } else {
        out.print("DISPONIBLE"); // El usuario está disponible
    }

    rs.close();
    stmt.close();
    con.close();
%>
