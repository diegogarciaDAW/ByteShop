<%-- 
    Document   : modificarDatos
    Created on : 20 mar 2025, 16:27:26
    Author     : diego
--%>

<%@page import="utils.ConexionDB"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.DriverManager"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>


<%
    String idBoton = request.getParameter("id");
    String[] divididoBoton = idBoton.split("-");

    try {
        Connection con = ConexionDB.getConnection();
        Statement stmt = con.createStatement();

        if (divididoBoton[1].equals("A")) {
            stmt.executeUpdate("UPDATE `login` SET `idAB` = '1' WHERE `login`.id = " + Integer.parseInt(divididoBoton[0]));
            response.sendRedirect(request.getHeader("Referer"));  // Redirige a la página anterior

        } else if (divididoBoton[1].equals("B")) {
            stmt.executeUpdate("UPDATE `login` SET `idAB` = '0' WHERE `login`.id = " + Integer.parseInt(divididoBoton[0]));
            response.sendRedirect(request.getHeader("Referer"));  // Redirige a la página anterior

        } else if (divididoBoton[1].equals("M")) {
            // Acción de modificar, redirige a la página de cambio de información
            ResultSet rs = stmt.executeQuery("SELECT * FROM login WHERE id=" + Integer.parseInt(divididoBoton[0]));
            if (rs.next()) {
                response.sendRedirect("../cambiarInfo.jsp?id=" + rs.getInt("info"));
            }

        } else if (divididoBoton[1].equals("BR")) {
            ResultSet rs = stmt.executeQuery("SELECT * FROM login WHERE login.id= " + Integer.parseInt(divididoBoton[0]));
            if (rs.next()) {
                stmt.executeUpdate("DELETE FROM usuarios WHERE usuarios.id= " + rs.getInt("login.info"));
                stmt.executeUpdate("DELETE FROM login WHERE `login`.id= " + Integer.parseInt(divididoBoton[0]));
            }
            response.sendRedirect(request.getHeader("Referer"));  // Redirige a la página anterior

        }

    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect(request.getHeader("Referer"));  // Si ocurre un error, redirige a la página anterior
    }
%>


