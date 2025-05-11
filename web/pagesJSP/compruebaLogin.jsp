<%-- 
    Document   : CompruebaLogin
    Created on : 16 mar 2025, 14:44:27
    Author     : diego
--%>

<%@page import="utils.ConexionDB"%>
<%@page import="java.sql.*"%>
<%@page import="java.security.MessageDigest"%>
<%@page import="java.security.NoSuchAlgorithmException"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="../assets/css/compruebaLogin.css"/>
    </head>
    <body>
        <main>
            <div id="wifi-loader">
                <svg class="circle-outer" viewBox="0 0 86 86">
                <circle class="back" cx="43" cy="43" r="40"></circle>
                <circle class="front" cx="43" cy="43" r="40"></circle>
                <circle class="new" cx="43" cy="43" r="40"></circle>
                </svg>
                <svg class="circle-middle" viewBox="0 0 60 60">
                <circle class="back" cx="30" cy="30" r="27"></circle>
                <circle class="front" cx="30" cy="30" r="27"></circle>
                </svg>
                <svg class="circle-inner" viewBox="0 0 34 34">
                <circle class="back" cx="17" cy="17" r="14"></circle>
                <circle class="front" cx="17" cy="17" r="14"></circle>
                </svg>
                <div class="text" data-text="Searching"></div>
            </div>
        </main>

        <%
            // Obtener los valores de usuario y contraseña del formulario de inicio de sesión
            String usuario = request.getParameter("usuario");
            String contraseña = request.getParameter("password");

            // Encriptar la contraseña con SHA-256, igual que en el registro
            try {
                MessageDigest md = MessageDigest.getInstance("SHA-256");
                byte[] hash = md.digest(contraseña.getBytes("UTF-8"));
                StringBuilder hexString = new StringBuilder();
                for (byte b : hash) {
                    String hex = Integer.toHexString(0xff & b);
                    if (hex.length() == 1) {
                        hexString.append('0');
                    }
                    hexString.append(hex);
                }
                String contraseñaEncriptada = hexString.toString();

                // Usamos ConexionDB para obtener la conexión
                Connection con = ConexionDB.getConnection();

                // Realizar la consulta para obtener el rol, estado e idAB del usuario
                PreparedStatement stmt = con.prepareStatement("SELECT Rol, idEstado, idAB FROM login WHERE user = ? AND passwd = ?");
                stmt.setString(1, usuario);
                stmt.setString(2, contraseñaEncriptada);  // Comparar con la contraseña encriptada
                ResultSet rs = stmt.executeQuery();

                if (rs.next()) {
                    // Si el usuario tiene idAB(Alta/Baja) = 1 (activo), actualizar el estado a 1, es decir, esta conectado
                    if (rs.getInt("idAB") == 1) {
                        PreparedStatement stmtUpdate = con.prepareStatement("UPDATE login SET idEstado = 1 WHERE user = ? AND passwd = ?");
                        stmtUpdate.setString(1, usuario);
                        stmtUpdate.setString(2, contraseñaEncriptada); // Usar la contraseña encriptada aquí también
                        stmtUpdate.executeUpdate();

                        // Crear sesión de usuario
                        HttpSession sesion = request.getSession();
                        sesion.setAttribute("usuario", usuario);
                        sesion.setAttribute("rol", rs.getInt("Rol"));
        %>
        <script>
            setTimeout(function () {
                window.location.href = "../inicio.jsp";
            }, 2000);
        </script>
        <%
        } else {
        %>
        <script>
            setTimeout(function () {
                window.location.href = "../login.jsp?valido=false";
            }, 2000);
        </script>
        <%
            }
        } else {
        %>
        <script>
            setTimeout(function () {
                window.location.href = "../login.jsp?valido=false";
            }, 2000);
        </script>
        <%
                }

                // Cerrar la conexión con la base de datos
                if (con != null) {
                    try {
                        con.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }

            } catch (NoSuchAlgorithmException e) {
                e.printStackTrace();
            } catch (SQLException e) {
                // Si se produce una excepción al conectar con la base de datos, imprimir la información de la excepción
                out.println(e.getLocalizedMessage());
                e.printStackTrace();
            }
        %>
    </body>
</html>
