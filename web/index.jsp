<%-- 
    Document   : index
    Created on : 16 mar 2025, 14:33:55
    Author     : diego
--%>

<%@page import="java.sql.*"%>

<%
    Class.forName("com.mysql.jdbc.Driver");
    Connection miConexion = DriverManager.getConnection("jdbc:mysql://localhost:3306/byteshop", "root", "");

    Statement stmt = miConexion.createStatement();

    stmt.executeUpdate("UPDATE login SET idEstado = 0 WHERE idEstado=1");
    response.sendRedirect("index.html");
%>