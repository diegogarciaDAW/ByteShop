package utils;

import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.OutputStream;
import java.sql.*;
import java.text.SimpleDateFormat;

public class FacturaGenerator {

    public static void generarFactura(int codigoPedido, HttpServletRequest request, HttpServletResponse response) throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        Document document = new Document(PageSize.A4, 50, 50, 50, 50);

        try {
            conn = ConexionDB.getConnection();
            OutputStream out = response.getOutputStream();
            PdfWriter.getInstance(document, out);
            document.open();

            // Cargar fuentes
            BaseFont baseFont = BaseFont.createFont("c:/windows/fonts/arial.ttf", BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
            Font tituloFont = new Font(baseFont, 22, Font.BOLD, BaseColor.BLACK);
            Font subTituloFont = new Font(baseFont, 12, Font.NORMAL, BaseColor.DARK_GRAY);
            Font tableHeaderFont = new Font(baseFont, 12, Font.BOLD, BaseColor.WHITE);
            Font cellFont = new Font(baseFont, 11, Font.NORMAL);
            Font totalFont = new Font(baseFont, 14, Font.BOLD, BaseColor.DARK_GRAY);

            // Header con título y QR
            PdfPTable headerTable = PDFUtils.crearEncabezado(codigoPedido, request, tituloFont);
            document.add(headerTable);
            document.add(Chunk.NEWLINE);

            // Datos del pedido
            String pedidoQuery = "SELECT pe.fecha, ep.Descripcion AS estado_pedido "
                               + "FROM pedidos pe "
                               + "JOIN estadopedido ep ON ep.idEstadoPedido = pe.estado "
                               + "WHERE pe.CodigoPedido = ?";
            stmt = conn.prepareStatement(pedidoQuery);
            stmt.setInt(1, codigoPedido);
            rs = stmt.executeQuery();

            if (rs.next()) {
                String fecha = new SimpleDateFormat("dd/MM/yyyy").format(rs.getDate("fecha"));
                String estado = rs.getString("estado_pedido");

                document.add(new Paragraph("Fecha del Pedido: " + fecha, subTituloFont));
                document.add(new Paragraph("Estado del Pedido: " + estado, subTituloFont));
                document.add(Chunk.NEWLINE);

                PdfPTable tablaProductos = PDFUtils.crearTablaProductos(conn, codigoPedido, cellFont, tableHeaderFont);
                document.add(tablaProductos);

                float totalProducto = PDFUtils.calcularTotal(conn, codigoPedido);
                float manoDeObra = 16f;
                float totalFactura = totalProducto + manoDeObra;

                Paragraph mo = new Paragraph("Mano de obra: " + String.format("%.2f €", manoDeObra), subTituloFont);
                mo.setAlignment(Element.ALIGN_RIGHT);
                document.add(mo);

                Paragraph total = new Paragraph("Total a pagar: " + String.format("%.2f €", totalFactura), totalFont);
                total.setAlignment(Element.ALIGN_RIGHT);
                total.setSpacingBefore(15);
                document.add(total);

                Paragraph gracias = new Paragraph("Gracias por su compra.", new Font(Font.FontFamily.HELVETICA, 11, Font.ITALIC, BaseColor.GRAY));
                gracias.setAlignment(Element.ALIGN_CENTER);
                gracias.setSpacingBefore(25);
                document.add(gracias);

            } else {
                document.add(new Paragraph("No se encontró el pedido con el código especificado."));
            }

        } finally {
            if (rs != null) try { rs.close(); } catch (Exception ignored) {}
            if (stmt != null) try { stmt.close(); } catch (Exception ignored) {}
            if (conn != null) try { conn.close(); } catch (Exception ignored) {}
            document.close();
        }
    }
}
