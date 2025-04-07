<%-- 
    Document   : accesoDenegado
    Created on : 6 abr 2025, 22:42:23
    Author     : diego
--%>

<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%
    // Verificar si el usuario tiene sesión activa
    Integer rol = (Integer) session.getAttribute("rol");
    String redirectUrl = "/index.html";  // Valor por defecto para los que no están logueados
    
    if (rol != null) {
        // Si tiene sesión activa, redirigir a inicio.jsp
        redirectUrl = "/inicio.jsp";
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Acceso Denegado</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container d-flex justify-content-center align-items-center vh-100">
        <div class="text-center">
            <div class="alert alert-danger text-center" role="alert">
                <h1 class="display-4">🚫 Acceso Denegado</h1>
                <p class="lead">Lo sentimos, no tienes permisos para acceder a esta página.</p>
                <hr>
                <p>Si crees que esto es un error, por favor contacta con el administrador.</p>
                <a href="<%= request.getContextPath() + redirectUrl %>" class="btn btn-primary">Volver al inicio</a>
            </div>
        </div>
    </div>
</body>
</html>
