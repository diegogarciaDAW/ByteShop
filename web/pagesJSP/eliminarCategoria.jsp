<%-- 
    Document   : eliminarCategoria
    Created on : 14 abr 2025, 14:27:07
    Author     : diego
--%>

<%@page import="utils.ConexionDB"%>
<%@page import="java.sql.*"%>
<%@page import="java.net.URLEncoder"%>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>

<%
    String idCategoria = request.getParameter("idCategoria");

    try {
        Connection con = ConexionDB.getConnection();
        String sql = "DELETE FROM categoria WHERE Categoria = ?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, Integer.parseInt(idCategoria));
        ps.executeUpdate();

        ps.close();
        con.close();

        String mensaje = URLEncoder.encode("Categoría eliminada correctamente", "UTF-8");
        response.sendRedirect("../aniadirCategoria.jsp?mensaje=" + mensaje + "&tipo=success");
    } catch (Exception e) {
        String error = URLEncoder.encode("Error al eliminar categoría", "UTF-8");
        response.sendRedirect("../aniadirCategoria.jsp?mensaje=" + error + "&tipo=error");
    }
%>

