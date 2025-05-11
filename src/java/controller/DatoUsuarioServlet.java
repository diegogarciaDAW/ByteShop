package controller;

import utils.ConexionDB;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/DatoUsuarioServlet")
public class DatoUsuarioServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String idParam = request.getParameter("id");

        String query;
        if (idParam == null) {
            query = "SELECT usuarios.Nombre, usuarios.Apellido, usuarios.FechadeNacimiento, usuarios.direccion, usuarios.email, login.user, login.Rol " +
                    "FROM usuarios " +
                    "JOIN login ON usuarios.id = login.info " +
                    "WHERE login.idEstado = 1 LIMIT 1";
        } else {
            query = "SELECT usuarios.Nombre, usuarios.Apellido, usuarios.FechadeNacimiento, usuarios.direccion, usuarios.email, login.user, login.Rol " +
                    "FROM usuarios " +
                    "JOIN login ON usuarios.id = login.info " +
                    "WHERE login.id = ? LIMIT 1";
        }

        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = idParam == null ? con.prepareStatement(query)
                                                    : prepareStatementWithId(con, query, idParam);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                Map<String, String> datos = new HashMap<>();
                datos.put("Nombre", rs.getString("Nombre"));
                datos.put("Apellido", rs.getString("Apellido"));
                datos.put("user", rs.getString("user"));
                datos.put("direccion", rs.getString("direccion"));

                Date fecha = rs.getDate("FechadeNacimiento");
                String fechaFormateada = new SimpleDateFormat("dd/MM/yyyy").format(fecha);
                datos.put("FechadeNacimiento", fechaFormateada);

                datos.put("email", rs.getString("email"));

                int rol = rs.getInt("Rol");
                String rolTexto = switch (rol) {
                    case 1 -> "Administrador";
                    case 2 -> "Gestor";
                    default -> "Cliente";
                };
                datos.put("rolTexto", rolTexto);

                request.setAttribute("datosUsuario", datos);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        request.getRequestDispatcher("datoUser.jsp").forward(request, response);
    }

    private PreparedStatement prepareStatementWithId(Connection con, String query, String idParam) throws SQLException {
        PreparedStatement ps = con.prepareStatement(query);
        ps.setInt(1, Integer.parseInt(idParam));
        return ps;
    }
}
