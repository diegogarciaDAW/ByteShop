<%-- 
    Document   : generarFactura
    Created on : 7 abr 2025, 9:20:11
    Author     : diego
--%>

<%@page import="utils.ConexionDB"%>
<%@ page import="java.sql.*, java.text.*, java.util.*" %>
<%@ page import="com.itextpdf.text.*, com.itextpdf.text.pdf.*, com.itextpdf.text.pdf.BarcodeQRCode" %>
<%@ page contentType="application/pdf; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8" %>
<%@ include file="security/verificaLogin.jspf" %>

<%
    int codigoPedido = Integer.parseInt(request.getParameter("codigoPedido"));

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    Document document = new Document(PageSize.A4, 50, 50, 50, 50); // Márgenes

    try {
        conn = ConexionDB.getConnection();

        // Configuración del nombre del archivo y descarga directa
        response.setHeader("Content-Disposition", "attachment; filename=Factura_" + codigoPedido + ".pdf");

        // Esto indica que el contenido es un PDF, y el navegador lo descargará
        response.setContentType("application/pdf");

        PdfWriter.getInstance(document, response.getOutputStream());
        document.open();

        // Fuentes y estilos (se usa una fuente TrueType como Arial para mejor soporte de caracteres)
        BaseFont baseFont = BaseFont.createFont("c:/windows/fonts/arial.ttf", BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
        Font tituloFont = new Font(baseFont, 22, Font.BOLD, BaseColor.BLACK);
        Font subTituloFont = new Font(baseFont, 12, Font.NORMAL, BaseColor.DARK_GRAY);
        Font tableHeaderFont = new Font(baseFont, 12, Font.BOLD, BaseColor.WHITE);
        Font cellFont = new Font(baseFont, 11, Font.NORMAL);
        Font totalFont = new Font(baseFont, 14, Font.BOLD, BaseColor.DARK_GRAY);

        // Crear una tabla para el título y el QR
        PdfPTable headerTable = new PdfPTable(2); // Dos columnas: título y QR
        headerTable.setWidthPercentage(100);
        headerTable.setWidths(new float[]{8f, 2f}); // La primera columna más ancha para el título

        // Título
        PdfPCell titleCell = new PdfPCell(new Phrase("Factura de Pedido #" + codigoPedido, tituloFont));
        titleCell.setBorder(Rectangle.NO_BORDER);
        titleCell.setHorizontalAlignment(Element.ALIGN_LEFT);
        titleCell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        titleCell.setPaddingBottom(10);
        headerTable.addCell(titleCell);

        // Generar el código QR
        String qrData = "https://miempresa.com/factura/" + codigoPedido;  // URL de la factura
        BarcodeQRCode barcodeQRCode = new BarcodeQRCode(qrData, 100, 100, null);
        Image qrImage = barcodeQRCode.getImage();
        qrImage.setAlignment(Element.ALIGN_RIGHT);
        qrImage.setSpacingBefore(10);

        // Colocar el QR en la segunda columna
        PdfPCell qrCell = new PdfPCell(qrImage, true);
        qrCell.setBorder(Rectangle.NO_BORDER);
        qrCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
        qrCell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        headerTable.addCell(qrCell);

        // Añadir la tabla de encabezado (título y QR)
        document.add(headerTable);

        // Espaciado después del encabezado
        document.add(Chunk.NEWLINE);

        // Info del pedido
        String pedidoQuery = "SELECT pe.fecha, ep.Descripcion AS estado_pedido " +
                             "FROM pedidos pe " +
                             "JOIN estadopedido ep ON ep.idEstadoPedido = pe.estado " +
                             "WHERE pe.CodigoPedido = ?";
        stmt = conn.prepareStatement(pedidoQuery);
        stmt.setInt(1, codigoPedido);
        rs = stmt.executeQuery();

        if (rs.next()) {
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
            String fecha = sdf.format(rs.getDate("fecha"));
            String estado = rs.getString("estado_pedido");

            // Información del pedido
            document.add(new Paragraph("Fecha del Pedido: " + fecha, subTituloFont));
            document.add(new Paragraph("Estado del Pedido: " + estado, subTituloFont));
            document.add(Chunk.NEWLINE);

            // Tabla de productos
            PdfPTable tabla = new PdfPTable(5); // Producto, Cantidad, Precio, Subtotal, Precio Total
            tabla.setWidthPercentage(100);
            tabla.setSpacingBefore(15);
            tabla.setWidths(new float[]{3f, 2f, 2f, 2f, 2f});

            // Cabecera
            String[] headers = {"Producto", "Cantidad", "Precio Unitario", "Subtotal", "Precio Total"};
            for (String header : headers) {
                PdfPCell headerCell = new PdfPCell(new Phrase(header, tableHeaderFont));
                headerCell.setBackgroundColor(new BaseColor(60, 60, 60));
                headerCell.setHorizontalAlignment(Element.ALIGN_CENTER);
                headerCell.setPadding(8);
                tabla.addCell(headerCell);
            }

            // Productos
            String productosQuery = "SELECT p.Nombre, dp.cantidad, p.Precio " +
                                    "FROM productos p " +
                                    "JOIN detalle_pedido dp ON dp.idProducto = p.id " +
                                    "WHERE dp.idPedido = ?";
            PreparedStatement productosStmt = conn.prepareStatement(productosQuery);
            productosStmt.setInt(1, codigoPedido);
            ResultSet productosRs = productosStmt.executeQuery();

            float totalProducto = 0;

            while (productosRs.next()) {
                String nombre = new String(productosRs.getString("Nombre").getBytes("ISO-8859-1"), "UTF-8");  // Convertir el nombre a UTF-8
                int cantidad = productosRs.getInt("cantidad");
                float precio = productosRs.getFloat("Precio");
                float subtotal = precio * cantidad;
                totalProducto += subtotal;

                // Desglosado: Producto, cantidad, precio unitario, subtotal
                String[] datos = {
                    nombre,
                    String.valueOf(cantidad),
                    String.format("%.2f €", precio),
                    String.format("%.2f €", subtotal),
                    String.format("%.2f €", subtotal)  // Precio Total es el mismo que el subtotal
                };

                for (String dato : datos) {
                    PdfPCell cell = new PdfPCell(new Phrase(dato, cellFont));
                    cell.setHorizontalAlignment(Element.ALIGN_CENTER);
                    cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    cell.setPadding(6);
                    tabla.addCell(cell);
                }
            }

            document.add(tabla);

            // Mano de obra (fijo a 16 €)
            float manoDeObra = 16.00f;
            Paragraph manoDeObraP = new Paragraph("Mano de obra: " + String.format("%.2f €", manoDeObra), subTituloFont);
            manoDeObraP.setAlignment(Element.ALIGN_RIGHT);
            document.add(manoDeObraP);

            // Total
            float totalFactura = totalProducto + manoDeObra;
            Paragraph totalP = new Paragraph("Total a pagar: " + String.format("%.2f €", totalFactura), totalFont);
            totalP.setAlignment(Element.ALIGN_RIGHT);
            totalP.setSpacingBefore(15);
            document.add(totalP);

            // Gracias
            Paragraph gracias = new Paragraph("Gracias por su compra.", new Font(Font.FontFamily.HELVETICA, 11, Font.ITALIC, BaseColor.GRAY));
            gracias.setAlignment(Element.ALIGN_CENTER);
            gracias.setSpacingBefore(25);
            document.add(gracias);

        } else {
            document.add(new Paragraph("No se encontró el pedido con el código especificado."));
        }

    } catch (Exception e) {
        document.add(new Paragraph("Error al generar la factura: " + e.getMessage()));
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception ignored) {}
        try { if (stmt != null) stmt.close(); } catch (Exception ignored) {}
        try { if (conn != null) conn.close(); } catch (Exception ignored) {}
        document.close();
    }
%>
