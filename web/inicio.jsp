<%-- 
    Document   : inicio
    Created on : 16 mar 2025, 14:34:22
    Author     : diego
--%>

<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Inicio</title>
        <link rel="stylesheet" href="assets/css/index.css"/>
    </head>
    <body>
        <jsp:include page="assets/layout/header.jsp"/>
        <!-- Slider con Bootstrap -->
        <div class="slider-container">
            <div id="sliderBootstrap" class="carousel slide" data-bs-ride="carousel">
                <!-- Indicadores (puntos debajo del slider) -->
                <div class="carousel-indicators">
                    <button type="button" data-bs-target="#sliderBootstrap" data-bs-slide-to="0" class="active"></button>
                    <button type="button" data-bs-target="#sliderBootstrap" data-bs-slide-to="1"></button>
                    <button type="button" data-bs-target="#sliderBootstrap" data-bs-slide-to="2"></button>
                    <button type="button" data-bs-target="#sliderBootstrap" data-bs-slide-to="3"></button>
                    <button type="button" data-bs-target="#sliderBootstrap" data-bs-slide-to="4"></button>
                </div>

                <!-- Contenido del Slider -->
                <div class="carousel-inner">
                    <div class="carousel-item active">
                        <img src="assets/img/camaras.jpg" class="d-block w-100" alt="camara">
                        <div class="carousel-caption">
                            <h2>Foto y Video</h2>
                            <p>Captura cada momento con claridad y detalle gracias a nuestras cámaras de alta calidad.</p>
                        </div>
                    </div>
                    <div class="carousel-item">
                        <img src="assets/img/componentes.jpg" class="d-block w-100" alt="componentes">
                        <div class="carousel-caption">
                            <h2>Componentes</h2>
                            <p>Construye y mejora tu ordenador a medida con nuestros componentes de alta calidad.</p>
                        </div>
                    </div>
                    <div class="carousel-item">
                        <img src="assets/img/ordenador.jpg" class="d-block w-100" alt="Ordenadores">
                        <div class="carousel-caption">
                            <h2>Ordenadores</h2>
                            <p>Potencia tu productividad y disfruta de un rendimiento óptimo con nuestros ordenadores ya montados.</p>
                        </div>
                    </div>
                    <div class="carousel-item">
                        <img src="assets/img/moviles.jpg" class="d-block w-100" alt="moviles">
                        <div class="carousel-caption">
                            <h2>Smartphones</h2>
                            <p>Transforma tu forma de conectarte con el mundo a través de nuestros Smartphones de vanguardia.</p>
                        </div>
                    </div>
                    <div class="carousel-item">
                        <img src="assets/img/sonido.jpg" class="d-block w-100" alt="Sonido">
                        <div class="carousel-caption">
                            <h2>Sonido</h2>
                            <p>Eleva tu experiencia auditiva con nuestros dispositivos de sonido de alta calidad.</p>
                        </div>
                    </div>
                </div>

                <!-- Botones de navegación -->
                <button class="carousel-control-prev" type="button" data-bs-target="#sliderBootstrap" data-bs-slide="prev">
                    <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                    <span class="visually-hidden">Anterior</span>
                </button>
                <button class="carousel-control-next" type="button" data-bs-target="#sliderBootstrap" data-bs-slide="next">
                    <span class="carousel-control-next-icon" aria-hidden="true"></span>
                    <span class="visually-hidden">Siguiente</span>
                </button>
            </div>
        </div>
        <jsp:include page="assets/layout/footer.jsp"/>
    </body>
</html>