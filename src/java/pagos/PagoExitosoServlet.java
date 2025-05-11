package pagos;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/pagoExitoso")
public class PagoExitosoServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Obtener el ID del pedido
        int idPedido = Integer.parseInt(request.getParameter("idPedido"));

        try {
            Connection conexion = DriverManager.getConnection("jdbc:mysql://localhost:3306/byteShop", "root", "");
            PreparedStatement stmt = conexion.prepareStatement("UPDATE pedidos SET estado = 1 WHERE CodigoPedido = ?");
            stmt.setInt(1, idPedido);
            stmt.executeUpdate();
            stmt.close();
            conexion.close();
            response.sendRedirect("verPedidos");
        } catch (SQLException e) {
            throw new ServletException("Error al actualizar el estado del pedido en la base de datos.", e);
        }

    }
}