<%-- 
    Document   : footerJSP
    Created on : 16 mar 2025, 14:38:00
    Author     : diego
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<link rel="stylesheet" href="assets/css/index.css"/>
<!-- Footer -->
<footer class="bg-light py-4 mt-auto">
    <div class="container">
        <div class="row text-center text-md-start">
            <!-- Sección de contacto -->
            <div class="col-md-4 mb-3">
                <h5>Contacto</h5>
                <a href="contactar.jsp" class="btn btn-dark btn-sm">Contáctanos</a>
            </div>

            <!-- Sección de información -->
            <div class="col-md-4 mb-3">
                <h5>Sobre Nosotros</h5>
                <p class="text-muted small">
                    Ofrecemos productos de informática de calidad a precios competitivos y brindamos asesoría de expertos para garantizar la satisfacción del cliente.
                </p>
            </div>

            <!-- Sección de redes sociales -->
            <div class="col-md-4 mb-3">
                <h5>Síguenos</h5>
                <div class="d-flex justify-content-center justify-content-md-start">
                    <a href="https://www.instagram.com/" class="btn btn-outline-dark btn-sm me-2 social-icon">
                        <i class="fab fa-instagram"></i>
                    </a>
                    <a href="https://github.com/" class="btn btn-outline-dark btn-sm me-2 social-icon">
                        <i class="fab fa-github"></i>
                    </a>
                    <!-- Cambié el tercer icono de 'fa-blog' a 'fa-twitter' -->
                    <a href="https://twitter.com/" class="btn btn-outline-dark btn-sm me-2 social-icon">
                        <i class="fab fa-twitter"></i>
                    </a>
                    <a href="https://www.youtube.com/" class="btn btn-outline-dark btn-sm social-icon">
                        <i class="fab fa-youtube"></i>
                    </a>
                </div>
            </div>
        </div>

        <!-- Línea separadora -->
        <hr class="my-3">

        <!-- Derechos de autor -->
        <div class="text-center text-muted small">
            &copy; 2025 <b>Byte-Shop</b> - Todos los Derechos Reservados
        </div>
    </div>
</footer>

<!-- Cargar FontAwesome desde CDN -->
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css" rel="stylesheet">
