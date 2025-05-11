package controller;

import entities.Pedido;
import model.PedidoDAO;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/verPedidos")
public class VerPedidosServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        PedidoDAO dao = new PedidoDAO();
        try {
            List<Pedido> pedidos = dao.obtenerPedidosActivos();
            request.setAttribute("pedidos", pedidos);
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("verPedidos.jsp");
        dispatcher.forward(request, response);
    }
}
