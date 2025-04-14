package model;

import entities.Pedido;
import entities.ProductoPedido;
import utils.ConexionDB;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PedidoDAO {

    public List<Pedido> obtenerPedidosActivos() throws SQLException {
        List<Pedido> pedidos = new ArrayList<>();

        String sql = "SELECT pe.CodigoPedido, pe.fecha, ep.Descripcion as estado_pedido " +
                     "FROM pedidos pe " +
                     "JOIN estadopedido ep ON ep.idEstadoPedido = pe.estado " +
                     "JOIN login l ON l.id = pe.id " +
                     "WHERE pe.estado != 4 AND l.idEstado = 1 " +
                     "ORDER BY pe.fecha ASC";

        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Pedido pedido = new Pedido();
                pedido.setCodigo(rs.getInt("CodigoPedido"));
                pedido.setFecha(rs.getDate("fecha"));
                pedido.setEstado(rs.getString("estado_pedido"));
                pedido.setProductos(obtenerProductosDelPedido(pedido.getCodigo()));
                pedidos.add(pedido);
            }
        }

        return pedidos;
    }

    private List<ProductoPedido> obtenerProductosDelPedido(int idPedido) throws SQLException {
        List<ProductoPedido> productos = new ArrayList<>();

        String sql = "SELECT p.Nombre, dp.cantidad FROM productos p " +
                     "JOIN detalle_pedido dp ON dp.idProducto = p.id " +
                     "WHERE dp.idPedido = ?";

        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idPedido);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    productos.add(new ProductoPedido(rs.getString("Nombre"), rs.getInt("cantidad")));
                }
            }
        }

        return productos;
    }
}
