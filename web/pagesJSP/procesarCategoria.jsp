<%-- 
    Document   : procesarCategoria
    Created on : 14 abr 2025, 13:53:56
    Author     : diego
--%>

<%@page import="utils.ConexionDB"%>
<%@page import="java.sql.*"%>
<%@page import="java.net.URLEncoder"%>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>

<%
    String nombre = request.getParameter("nombreCategoria");

    try {
        Connection con = ConexionDB.getConnection();
        String sql = "INSERT INTO categoria (nombreCategoria) VALUES (?)";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, nombre);
        ps.executeUpdate();

        ps.close();
        con.close();

        String mensaje = URLEncoder.encode("Categoría añadida correctamente", "UTF-8");
        response.sendRedirect("../aniadirCategoria.jsp?mensaje=" + mensaje + "&tipo=success");
    } catch (Exception e) {
        String error = URLEncoder.encode("Error al añadir categoría", "UTF-8");
        response.sendRedirect("../aniadirCategoria.jsp?mensaje=" + error + "&tipo=error");
    }
%>

