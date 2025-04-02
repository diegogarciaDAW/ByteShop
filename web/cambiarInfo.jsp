<%-- 
    Document   : cambiarInfo.jsp
    Created on : 20 mar 2025, 17:50:05
    Author     : diego
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Editar Información</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://kit.fontawesome.com/5c9ae03052.js" crossorigin="anonymous"></script>

        <link rel="stylesheet" href="assets/css/cambiarInfo.css"/>
    </head>
    <body>
        <jsp:include page="assets/layout/header.jsp"/>

        <div class="containerUser">
            <div class="card">
                <h2 class="text-center mb-4">Editar Información</h2>
                <%
                    String id = request.getParameter("id").trim();
                    Class.forName("com.mysql.jdbc.Driver");
                    Connection miConexion = DriverManager.getConnection("jdbc:mysql://localhost:3306/byteShop", "root", "");

                    PreparedStatement stmt = miConexion.prepareStatement(
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
                            <input type="text" name="nombre" class="form-control" value="<%=rs1.getString("Nombre")%>" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Apellido</label>
                            <input type="text" name="apellido" class="form-control" value="<%=rs1.getString("Apellido")%>" required>
                        </div>
                    </div>

                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label class="form-label">Dirección</label>
                            <input type="text" name="direccion" class="form-control" value="<%=rs1.getString("direccion")%>" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Fecha de Nacimiento</label>
                            <input type="date" name="fechaNac" class="form-control" value="<%=rs1.getDate("FechadeNacimiento")%>" required>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Rol</label>
                        <select name="spinner" class="form-select">
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
                    miConexion.close();
                %>
            </div>
        </div>

        <jsp:include page="/assets/layout/footer.jsp"/>

        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="assets/js/cambiarInfo.js"></script> <!-- Archivo JS separado -->
    </body>
</html>
