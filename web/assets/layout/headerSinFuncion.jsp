<%-- 
    Document   : HeaderSinFuncion
    Created on : 16 mar 2025, 14:37:13
    Author     : diego
--%>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title></title>
        <!-- Agregar el CSS de Bootstrap -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Agregar los iconos de Google -->
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
        <!-- Agregar el JS de Bootstrap (bundle incluye Popper.js) -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </head>
    <body>

        <header class="navbar navbar-expand-lg navbar-light bg-light">
            <div class="container">
                <a class="navbar-brand" href="#">
                    <img src="assets/img/logo.png" alt="logo" height="50">
                </a>
                <!-- Botón de hamburguesa para pantallas pequeñas -->
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <!-- Menú que se despliega en pantallas pequeñas -->
                <div class="collapse navbar-collapse justify-content-center" id="navbarNav">
                    <ul class="navbar-nav">
                        <li class="nav-item">
                            <a class="nav-link" href="index.html">INICIO</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#">LO + VENDIDO</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#">PRODUCTOS</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="contactar.jsp">CONTACTO</a>
                        </li>
                    </ul>
                </div>
                <!-- Icono de inicio de sesión en la parte derecha -->
                <a href="login.jsp" class="ms-auto text-dark">
                    <span class="material-icons">person</span>
                </a>
            </div>
        </header>