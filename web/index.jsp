<%-- 
    Document   : index
    Created on : 16 mar 2025, 14:33:55
    Author     : diego
--%>

<%@page import="utils.ConexionDB"%>
<%@page import="java.sql.*"%>

<%@page import="java.sql.*"%>

<%
    String usuario = (String) session.getAttribute("usuario");

    if (usuario != null) {
        Connection con = ConexionDB.getConnection();

        PreparedStatement stmt = con.prepareStatement("UPDATE login SET idEstado = 0 WHERE user = ?");
        stmt.setString(1, usuario);
        stmt.executeUpdate();

        con.close();
    }

    session.invalidate();
    response.sendRedirect("index.html");
%>
