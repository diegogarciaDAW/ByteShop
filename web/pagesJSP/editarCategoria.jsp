<%-- 
    Document   : editarCategoria
    Created on : 14 abr 2025, 14:06:58
    Author     : diego
--%>

<%@page import="utils.ConexionDB"%>
<%@page import="java.sql.*"%>
<%@page import="java.net.URLEncoder"%>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>

<%
    String idCategoria = request.getParameter("idCategoria");
    String nuevoNombre = request.getParameter("nombreCategoria");

    try {
        Connection con = ConexionDB.getConnection();
        String sql = "UPDATE categoria SET nombreCategoria = ? WHERE Categoria = ?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, nuevoNombre);
        ps.setInt(2, Integer.parseInt(idCategoria));
        ps.executeUpdate();

        ps.close();
        con.close();

        String mensaje = URLEncoder.encode("Categoría editada correctamente", "UTF-8");
        response.sendRedirect("../aniadirCategoria.jsp?mensaje=" + mensaje + "&tipo=success");
    } catch (Exception e) {
        String error = URLEncoder.encode("Error al editar categoría", "UTF-8");
        response.sendRedirect("../aniadirCategoria.jsp?mensaje=" + error + "&tipo=error");
    }
%>

