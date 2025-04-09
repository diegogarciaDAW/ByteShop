<%-- 
    Document   : cambiosRealizados
    Created on : 20 mar 2025, 19:04:02
    Author     : diego
--%>

<%@page import="utils.ConexionDB"%>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%
    String id = request.getParameter("id");
    String nombre = request.getParameter("nombre");
    String apellido = request.getParameter("apellido");
    String direccion = request.getParameter("direccion");
    String fechaNac = request.getParameter("fechaNac");
    String username = request.getParameter("username"); // Obtener el nombre de usuario
    String email = request.getParameter("email"); // Obtener el nombre de usuario
    String rol = request.getParameter("spinner");

    if (username == null || username.trim().isEmpty()) {
        out.println("El nombre de usuario no puede estar vacío.");
        return; // Detener ejecución si el nombre de usuario es vacío
    }

    try {
        Connection con = ConexionDB.getConnection();

        // Verificar si ya existe un usuario con el mismo nombre de usuario
        PreparedStatement checkStmt = con.prepareStatement(
                "SELECT COUNT(*) FROM login WHERE user = ? AND info != ?"
        );
        checkStmt.setString(1, username);
        checkStmt.setInt(2, Integer.parseInt(id));
        ResultSet rsCheck = checkStmt.executeQuery();
        rsCheck.next();
        int count = rsCheck.getInt(1);

        if (count > 0) {
            out.println("Nombre de usuario ya existente.");
            return;
        }

        // Si el nombre de usuario es válido, proceder con la actualización
        String query = "UPDATE usuarios u INNER JOIN login l ON l.info = u.id "
                + "SET u.Nombre = ?, u.Apellido = ?, u.email = ?, u.direccion = ?, u.FechadeNacimiento = ?, "
                + "l.user = ?, l.rol = ? WHERE u.id = ?";

        PreparedStatement stmt = con.prepareStatement(query);
        stmt.setString(1, nombre);
        stmt.setString(2, apellido);
        stmt.setString(3, email);
        stmt.setString(4, direccion);
        stmt.setDate(5, Date.valueOf(fechaNac));
        stmt.setString(6, username);
        stmt.setInt(7, Integer.parseInt(rol));
        stmt.setInt(8, Integer.parseInt(id));

        int rowsUpdated = stmt.executeUpdate();
        if (rowsUpdated > 0) {
            // Si se actualizó correctamente, redirigir a usuariosAltaBaja.jsp
            out.println("<script>");
            out.println("window.location.href = '../usuariosAltaBaja.jsp';");
            out.println("</script>");
        } else {
            out.println("Error al actualizar la base de datos.");
        }

        stmt.close();
        con.close();
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>
