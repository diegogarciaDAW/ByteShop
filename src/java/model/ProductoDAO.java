package model;

import entities.Producto;
import utils.ConexionDB;
import java.sql.*;
import java.util.*;

public class ProductoDAO {

    public List<Producto> obtenerProductosMasVendidos() throws SQLException {
        List<Producto> productos = new ArrayList<>();
        String query = "SELECT p.imagen, p.id, p.Nombre, p.Descripcion, p.Precio, c.nombreCategoria, p.CantidadDisponible, SUM(dp.cantidad) AS total_vendido "
                     + "FROM productos p "
                     + "JOIN categoria c ON p.categoria = c.categoria "
                     + "LEFT JOIN detalle_pedido dp ON p.id = dp.idProducto "
                     + "GROUP BY p.id "
                     + "ORDER BY total_vendido DESC LIMIT 6";

        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Producto producto = new Producto();
                producto.setId(rs.getInt("id"));
                producto.setNombre(rs.getString("Nombre"));
                producto.setDescripcion(rs.getString("Descripcion"));
                producto.setPrecio(rs.getDouble("Precio"));
                producto.setCategoria(rs.getString("nombreCategoria"));
                producto.setCantidadDisponible(rs.getInt("CantidadDisponible"));
                producto.setTotalVendido(rs.getInt("total_vendido"));

                Blob b = rs.getBlob("imagen");
                byte[] bdata = b.getBytes(1, (int) b.length());
                String imageBase64 = Base64.getEncoder().encodeToString(bdata);
                producto.setImagenBase64(imageBase64);

                productos.add(producto);
            }
        }
        return productos;
    }
}
