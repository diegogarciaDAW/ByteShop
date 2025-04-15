package controller;

import entities.Categoria;
import model.CategoriaDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/CategoriaServlet")
public class CategoriaServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String action = request.getParameter("action");
        CategoriaDAO dao = new CategoriaDAO();

        try {
            if (action != null) {
                switch (action) {
                    case "delete":
                        int idDel = Integer.parseInt(request.getParameter("id"));
                        dao.eliminarCategoria(idDel);
                        String mensaje = java.net.URLEncoder.encode("Categoría eliminada correctamente", "UTF-8");
                        response.sendRedirect("CategoriaServlet?mensaje=" + mensaje);

                        return;

                    case "edit":
                        int idEdit = Integer.parseInt(request.getParameter("id"));
                        Categoria catEdit = dao.obtenerPorId(idEdit);
                        request.setAttribute("categoriaEditar", catEdit);
                        break;
                }
            }

            List<Categoria> lista = dao.listarCategorias();
            request.setAttribute("categorias", lista);
            request.getRequestDispatcher("aniadirCategoria.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("mensaje", "Error: " + e.getMessage());
            request.getRequestDispatcher("aniadirCategoria.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String action = request.getParameter("action");
        CategoriaDAO dao = new CategoriaDAO();

        try {
            String nombre = request.getParameter("nombre").trim();
            List<Categoria> lista = null; // <-- declarar aquí sin inicializar aún

            if ("add".equals(action)) {
                if (dao.existeCategoriaPorNombre(nombre)) {
                    request.setAttribute("mensaje", "La categoría ya existe.");
                    lista = dao.listarCategorias(); // cargar aquí
                    request.setAttribute("categorias", lista);
                    request.getRequestDispatcher("aniadirCategoria.jsp").forward(request, response);
                    return;
                }

                Categoria nueva = new Categoria(nombre);
                dao.agregarCategoria(nueva);

                lista = dao.listarCategorias(); // actualizar después de agregar
                request.setAttribute("categorias", lista);
                request.setAttribute("mensaje", "Categoría añadida correctamente");
                request.getRequestDispatcher("aniadirCategoria.jsp").forward(request, response);
                return;

            } else if ("update".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                Categoria actual = dao.obtenerPorId(id);

                if (actual != null && !actual.getNombre().equalsIgnoreCase(nombre) && dao.existeCategoriaPorNombre(nombre)) {
                    request.setAttribute("mensaje", "Ya existe otra categoría con ese nombre.");
                    request.setAttribute("categoriaEditar", actual);
                    lista = dao.listarCategorias(); // actualizar la lista aquí también
                    request.setAttribute("categorias", lista);
                    request.getRequestDispatcher("aniadirCategoria.jsp").forward(request, response);
                    return;
                }

                Categoria actualizada = new Categoria(id, nombre);
                dao.editarCategoria(actualizada);

                lista = dao.listarCategorias(); // cargar después de editar
                request.setAttribute("categorias", lista);
                request.setAttribute("mensaje", "Categoría actualizada correctamente");
                request.getRequestDispatcher("aniadirCategoria.jsp").forward(request, response);
                return;
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("mensaje", "Error al procesar la solicitud: " + e.getMessage());
            try {
                List<Categoria> lista = new CategoriaDAO().listarCategorias();
                request.setAttribute("categorias", lista);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            request.getRequestDispatcher("aniadirCategoria.jsp").forward(request, response);
        }
    }

}
