<%-- 
    Document   : generarFactura
    Created on : 7 abr 2025, 9:20:11
    Author     : diego
--%>

<%@ page import="utils.ConexionDB" %>
<%@ page import="java.sql.*, java.text.*, java.util.*" %>
<%@ page import="utils.FacturaGenerator" %>
<%@ page import="com.itextpdf.text.*, com.itextpdf.text.pdf.*, com.itextpdf.text.pdf.BarcodeQRCode" %>
<%@ page contentType="application/pdf; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8" %>

<%
    int codigoPedido = Integer.parseInt(request.getParameter("codigoPedido"));

    // Configurar la cabecera de respuesta como PDF
    response.setHeader("Content-Disposition", "attachment; filename=Factura_" + codigoPedido + ".pdf");
    response.setContentType("application/pdf");

    // Llamar al generador de la factura
    try {
        FacturaGenerator.generarFactura(codigoPedido, request, response);
    } catch (Exception e) {
        out.println("Error al generar la factura: " + e.getMessage());
    }
%>
