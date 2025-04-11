<%-- 
    Document   : creadorUser
    Created on : 16 mar 2025, 23:21:25
    Author     : diego
--%>

<%@page import="utils.ConexionDB"%>
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
        // Obtener parámetros del formulario
        String nombre = request.getParameter("nombre");
        String apellido = request.getParameter("apellido");
        String direccion = request.getParameter("direccion");
        String fecha = request.getParameter("fechaNac");
        String email = request.getParameter("email");
        String user = request.getParameter("user");
        String password = request.getParameter("password");

// Encriptar la contraseña con SHA-256
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        byte[] hash = md.digest(password.getBytes("UTF-8"));
        StringBuilder hexString = new StringBuilder();
        for (byte b : hash) {
            String hex = Integer.toHexString(0xff & b);
            if (hex.length() == 1) {
                hexString.append('0');
            }
            hexString.append(hex);
        }
        String passwordEncriptada = hexString.toString();

// Establecer conexión a la BD
        Connection con = ConexionDB.getConnection();

// Insertar en la tabla usuarios
        PreparedStatement stmt = con.prepareStatement(
                "INSERT INTO usuarios (Nombre, Apellido, FechadeNacimiento, email, direccion) VALUES (?, ?, ?, ?, ?)",
                Statement.RETURN_GENERATED_KEYS
        );
        stmt.setString(1, nombre);
        stmt.setString(2, apellido);
        stmt.setString(3, fecha);
        stmt.setString(4, email);
        stmt.setString(5, direccion);
        stmt.executeUpdate();

// Obtener el ID generado
        ResultSet rs = stmt.getGeneratedKeys();
        if (rs.next()) {
            int id = rs.getInt(1);

            // 👇 Esta es la línea que determina el estado
            int idEstado = (request.getParameter("id") == null) ? 1 : 0;

            // Insertar en la tabla login
            PreparedStatement stmtLogin = con.prepareStatement(
                    "INSERT INTO login (user, passwd, info, Rol, idEstado, idAB) VALUES (?, ?, ?, 3, ?, 1)"
            );
            stmtLogin.setString(1, user);
            stmtLogin.setString(2, passwordEncriptada);
            stmtLogin.setInt(3, id);
            stmtLogin.setInt(4, idEstado);
            stmtLogin.executeUpdate();

            if (request.getParameter("id") == null) {
                HttpSession sesion = request.getSession();
                sesion.setAttribute("usuario", user);
                sesion.setAttribute("rol", 3);
            }

%>
<script>
    setTimeout(function () {
        window.location.href = "../inicio.jsp";
    }, 5000);
</script>
<%        }
    } catch (SQLException e) {
        out.println("Error SQL: " + e.getMessage());
    } catch (Exception e) {
        out.println("Error General: " + e.getMessage());
    }
%>