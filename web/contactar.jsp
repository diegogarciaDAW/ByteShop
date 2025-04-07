<%-- 
    Document   : contactar
    Created on : 21 mar 2025, 17:20:35
    Author     : diego
--%>

<%@page import="utils.ConexionDB"%>
<%@page import="java.util.Properties"%>
<%@page import="java.util.Base64"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.Date"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Contactar</title>

        <!-- Bootstrap 5 CDN -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet" />
        <script src="https://kit.fontawesome.com/5c9ae03052.js" crossorigin="anonymous"></script>

        <link rel="stylesheet" href="assets/css/contactar.css"/>
    </head>
    <body>
        <%
            // Lógica para verificación del estado del login
            Connection con = ConexionDB.getConnection();
            Statement stmt = con.createStatement();
            ResultSet rs1 = stmt.executeQuery("SELECT * FROM login WHERE idEstado=" + 1);
            if (rs1.next()) {%>
        <jsp:include page='assets/layout/header.jsp'/>
        <%} else {%>
        <jsp:include page='assets/layout/headerSinFuncion.jsp'/>
        <%}
        %>

        <div class="container py-5">
            <form action="pagesJSP/enviarCorreos.jsp" method="post">
                <div class="row justify-content-center">
                    <div class="col-lg-6 col-md-8 col-12">
                        <div class="card-contact">
                            <h3 class="text-center singup">Contáctanos</h3>

                            <div class="mb-3">
                                <label for="correo" class="form-label">Email</label>
                                <input type="email" id="correo" class="form-control" name="correo" required>
                            </div>

                            <div class="mb-3">
                                <label for="nombre" class="form-label">Nombre</label>
                                <input type="text" id="nombre" class="form-control" name="nombre" required>
                            </div>

                            <div class="mb-3">
                                <label for="asunto" class="form-label">Asunto</label>
                                <textarea id="asunto" class="form-control" name="asunto" required></textarea>
                            </div>

                            <button type="submit" class="btn btn-contact">
                                <i class="fas fa-paper-plane"></i> Enviar
                            </button>
                        </div>
                    </div>
                </div>
            </form>
        </div>

        <jsp:include page="assets/layout/footer.jsp"/>
    </body>
</html>
