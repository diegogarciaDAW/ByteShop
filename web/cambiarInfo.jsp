<%-- 
    Document   : cambiarInfo.jsp
    Created on : 20 mar 2025, 17:50:05
    Author     : diego
--%>

<%@page import="utils.ConexionDB"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@ include file="security/verificaAdmin.jspf" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Editar Información</title>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script> <!-- Asegúrate de tener esto -->
        <script src="https://kit.fontawesome.com/5c9ae03052.js" crossorigin="anonymous"></script>
        <link rel="stylesheet" href="assets/css/cambiarInfo.css"/>
        <script src="assets/js/cambiarInfo.js"></script>
    </head>
    <body>
        <jsp:include page="assets/layout/header.jsp"/>

        <div class="containerUser">
            <div class="card">
                <h2 class="text-center mb-4">Editar Información</h2>
                <%                    String id = request.getParameter("id").trim();
                    Connection con = ConexionDB.getConnection();

                    PreparedStatement stmt = con.prepareStatement(
                            "SELECT u.*, l.id as login_id, l.user, l.info as usuario_id, l.rol "
                            + "FROM usuarios u "
                            + "INNER JOIN login l ON l.info = u.id "
                            + "WHERE u.id = ?"
                    );
                    stmt.setInt(1, Integer.parseInt(id));

                    ResultSet rs1 = stmt.executeQuery();
                    if (rs1.next()) {
                        int rolActual = rs1.getInt("rol");
                        String usuarioActual = rs1.getString("user");
                %>

                <form action="pagesJSP/cambiosRealizados.jsp" method="POST" id="formEdicion">
                    <input type="hidden" name="id" value="<%=rs1.getInt("usuario_id")%>">
                    <input type="hidden" id="usuarioActual" value="<%=usuarioActual%>">

                    <div class="mb-3">
                        <label class="form-label">Nombre de Usuario</label>
                        <input type="text" id="username" name="username" class="form-control" value="<%=usuarioActual%>" required>
                        <div id="usernameFeedback" class="mt-1"></div>
                    </div>

                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label class="form-label">Nombre</label>
                            <input type="text" id="nombre" name="nombre" class="form-control" value="<%= new String(rs1.getString("Nombre").getBytes("ISO-8859-1"), "UTF-8")%>" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Apellido</label>
                            <input type="text" id="apellido" name="apellido" class="form-control" value="<%= new String(rs1.getString("Apellido").getBytes("ISO-8859-1"), "UTF-8") %>" required>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Correo Electrónico</label>
                        <input type="email" id="email" name="email" class="form-control" value="<%=rs1.getString("email")%>" required>
                    </div>

                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label class="form-label">Dirección</label>
                            <input type="text" id="direccion" name="direccion" class="form-control" value="<%= new String(rs1.getString("direccion").getBytes("ISO-8859-1"), "UTF-8") %>" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Fecha de Nacimiento</label>
                            <input type="date" id="fechaNac" name="fechaNac" class="form-control" value="<%=rs1.getDate("FechadeNacimiento")%>" required>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Rol</label>
                        <select id="rol" name="spinner" class="form-select">
                            <option value="1" <%= (rolActual == 1) ? "selected" : ""%>>Administrador</option>
                            <option value="2" <%= (rolActual == 2) ? "selected" : ""%>>Gestor</option>
                            <option value="3" <%= (rolActual == 3) ? "selected" : ""%>>Cliente</option>
                        </select>
                    </div>

                    <button type="submit" id="saveButton" name="buton" class="btn btn-success btn-custom" disabled>
                        <i class="fas fa-save"></i> Guardar Cambios
                    </button>
                </form>

                <%
                    }
                    rs1.close();
                    stmt.close();
                    con.close();
                %>
            </div>
        </div>

        <jsp:include page="/assets/layout/footer.jsp"/>

    </body>
</html>
