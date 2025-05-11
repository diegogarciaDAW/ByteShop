package controller;

import entities.Producto;
import model.ProductoDAO;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/loMasVendido")
public class LoMasVendidoServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ProductoDAO dao = new ProductoDAO();
        try {
            List<Producto> productos = dao.obtenerProductosMasVendidos();
            request.setAttribute("productos", productos);
            request.getRequestDispatcher("loMasVendido.jsp").forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("error", "Error al obtener productos: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }
}