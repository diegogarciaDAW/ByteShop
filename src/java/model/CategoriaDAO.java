package model;

import entities.Categoria;
import utils.ConexionDB;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CategoriaDAO {

    public List<Categoria> listarCategorias() throws Exception {
        List<Categoria> lista = new ArrayList<>();
        Connection con = ConexionDB.getConnection();
        String sql = "SELECT * FROM categoria ORDER BY Categoria ASC";
        PreparedStatement ps = con.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            Categoria cat = new Categoria(rs.getInt("Categoria"), rs.getString("nombreCategoria"));
            lista.add(cat);
        }

        rs.close();
        ps.close();
        con.close();
        return lista;
    }

    public void agregarCategoria(Categoria cat) throws Exception {
        Connection con = ConexionDB.getConnection();
        String sql = "INSERT INTO categoria (nombreCategoria) VALUES (?)";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, cat.getNombre());
        ps.executeUpdate();

        ps.close();
        con.close();
    }

    public void editarCategoria(Categoria cat) throws Exception {
        Connection con = ConexionDB.getConnection();
        String sql = "UPDATE categoria SET nombreCategoria = ? WHERE Categoria = ?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, cat.getNombre());
        ps.setInt(2, cat.getId());
        ps.executeUpdate();

        ps.close();
        con.close();
    }

    public void eliminarCategoria(int idCategoria) throws Exception {
        Connection con = ConexionDB.getConnection();
        String sql = "DELETE FROM categoria WHERE Categoria = ?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, idCategoria);
        ps.executeUpdate();
        ps.close();
        con.close();
    }

    public Categoria obtenerPorId(int id) throws Exception {
        Connection con = ConexionDB.getConnection();
        String sql = "SELECT * FROM categoria WHERE Categoria = ?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, id);
        ResultSet rs = ps.executeQuery();

        Categoria cat = null;
        if (rs.next()) {
            cat = new Categoria(rs.getInt("Categoria"), rs.getString("nombreCategoria"));
        }

        rs.close();
        ps.close();
        con.close();
        return cat;
    }

    public boolean existeCategoriaPorNombre(String nombre) throws Exception {
        Connection con = ConexionDB.getConnection();
        String sql = "SELECT COUNT(*) FROM categoria WHERE LOWER(nombreCategoria) = LOWER(?)";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, nombre.trim());
        ResultSet rs = ps.executeQuery();

        boolean existe = false;
        if (rs.next()) {
            existe = rs.getInt(1) > 0;
        }

        rs.close();
        ps.close();
        con.close();
        return existe;
    }
}
