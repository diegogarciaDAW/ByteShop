<%-- 
    Document   : creadorUser
    Created on : 16 mar 2025, 23:21:25
    Author     : diego
--%>

<%@page import="java.sql.*"%>
<%@page import="java.security.MessageDigest"%>
<%@page import="java.security.NoSuchAlgorithmException"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" href="../assets/css/creadorUser.css"/>

</head>
<body>
    <main>
        <h1>CREANDO USUARIO</h1>
        <div class="loader"></div>
    </main>
</body>
</html>
<%
    try {
        request.setCharacterEncoding("UTF-8"); // Asegurar que los datos se lean en UTF-8
        
        String nombre = request.getParameter("nombre");
        String apellido = request.getParameter("apellido");
        String direccion = request.getParameter("direccion");
        String fecha = request.getParameter("fechaNac");
        String email = request.getParameter("email");
        String user = request.getParameter("user");
        String password = request.getParameter("password");

        // Método para encriptar la contraseña con SHA-256
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        byte[] hash = md.digest(password.getBytes("UTF-8"));
        StringBuilder hexString = new StringBuilder();
        for (byte b : hash) {
            String hex = Integer.toHexString(0xff & b);
            if (hex.length() == 1) hexString.append('0');
            hexString.append(hex);
        }
        String passwordEncriptada = hexString.toString();

        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection miConexion = DriverManager.getConnection("jdbc:mysql://localhost:3306/byteshop?useUnicode=true&characterEncoding=UTF-8", "root", "");
        
        PreparedStatement stmt = miConexion.prepareStatement("INSERT INTO usuarios (Nombre, Apellido, FechadeNacimiento, email, direccion) VALUES (?, ?, ?, ?, ?)", Statement.RETURN_GENERATED_KEYS);
        stmt.setString(1, nombre);
        stmt.setString(2, apellido);
        stmt.setString(3, fecha);
        stmt.setString(4, email);
        stmt.setString(5, direccion);
        stmt.executeUpdate();
        
        ResultSet rs = stmt.getGeneratedKeys();
        if (rs.next()) {
            int id = rs.getInt(1);
            PreparedStatement stmtLogin = miConexion.prepareStatement("INSERT INTO login (user, passwd, info, Rol, idEstado, idAB) VALUES (?, ?, ?, 3, 1, 1)");
            stmtLogin.setString(1, user);
            stmtLogin.setString(2, passwordEncriptada);
            stmtLogin.setInt(3, id);
            stmtLogin.executeUpdate();
%>
<script>
    setTimeout(function () {
        window.location.href = "../inicio.jsp";
    }, 5000);
</script>
<%
        }
    } catch (SQLException e) {
        out.println("Error SQL: " + e.getMessage());
    } catch (Exception e) {
        out.println("Error General: " + e.getMessage());
    }
%>