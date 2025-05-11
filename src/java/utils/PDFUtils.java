package utils;

import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;

import javax.servlet.http.HttpServletRequest;
import java.net.*;
import java.sql.*;

public class PDFUtils {

    public static PdfPTable crearEncabezado(int codigoPedido, HttpServletRequest request, Font tituloFont) throws Exception {
        PdfPTable table = new PdfPTable(2);
        table.setWidthPercentage(100);
        table.setWidths(new float[]{8f, 2f});

        PdfPCell titleCell = new PdfPCell(new Phrase("Factura de Pedido #" + codigoPedido, tituloFont));
        titleCell.setBorder(Rectangle.NO_BORDER);
        titleCell.setHorizontalAlignment(Element.ALIGN_LEFT);
        titleCell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        titleCell.setPaddingBottom(10);
        table.addCell(titleCell);

        InetAddress localHost = InetAddress.getLocalHost();
        String localIP = localHost.getHostAddress(); 
        String qrData = request.getScheme() + "://" + localIP + ":" + request.getServerPort() + request.getContextPath()
                + "/generarFactura.jsp?codigoPedido=" + codigoPedido;

        BarcodeQRCode qrCode = new BarcodeQRCode(qrData, 100, 100, null);
        Image qrImage = qrCode.getImage();
        qrImage.setAlignment(Image.ALIGN_RIGHT);

        PdfPCell qrCell = new PdfPCell(qrImage, true);
        qrCell.setBorder(Rectangle.NO_BORDER);
        qrCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
        qrCell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table.addCell(qrCell);

        return table;
    }

    public static PdfPTable crearTablaProductos(Connection conn, int codigoPedido, Font cellFont, Font headerFont) throws Exception {
        PdfPTable table = new PdfPTable(5);
        table.setWidthPercentage(100);
        table.setSpacingBefore(15);
        table.setWidths(new float[]{3f, 2f, 2f, 2f, 2f});

        String[] headers = {"Producto", "Cantidad", "Precio Unitario", "Subtotal", "Precio Total"};
        for (String h : headers) {
            PdfPCell cell = new PdfPCell(new Phrase(h, headerFont));
            cell.setBackgroundColor(new BaseColor(60, 60, 60));
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            cell.setPadding(8);
            table.addCell(cell);
        }

        String sql = "SELECT p.Nombre, dp.cantidad, p.Precio FROM productos p JOIN detalle_pedido dp ON dp.idProducto = p.id WHERE dp.idPedido = ?";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setInt(1, codigoPedido);
        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            String nombre = new String(rs.getString("Nombre").getBytes("ISO-8859-1"), "UTF-8");
            int cantidad = rs.getInt("cantidad");
            float precio = rs.getFloat("Precio");
            float subtotal = cantidad * precio;

            String[] datos = {
                nombre,
                String.valueOf(cantidad),
                String.format("%.2f €", precio),
                String.format("%.2f €", subtotal),
                String.format("%.2f €", subtotal)
            };

            for (String d : datos) {
                PdfPCell cell = new PdfPCell(new Phrase(d, cellFont));
                cell.setHorizontalAlignment(Element.ALIGN_CENTER);
                cell.setPadding(6);
                table.addCell(cell);
            }
        }

        rs.close();
        stmt.close();

        return table;
    }

    public static float calcularTotal(Connection conn, int codigoPedido) throws SQLException {
        String sql = "SELECT dp.cantidad, p.Precio FROM productos p JOIN detalle_pedido dp ON dp.idProducto = p.id WHERE dp.idPedido = ?";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setInt(1, codigoPedido);
        ResultSet rs = stmt.executeQuery();

        float total = 0;
        while (rs.next()) {
            total += rs.getInt("cantidad") * rs.getFloat("Precio");
        }

        rs.close();
        stmt.close();
        return total;
    }
}
