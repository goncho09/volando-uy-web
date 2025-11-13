package uy.volando.servlets.Perfil;

import com.app.clases.Factory;
import com.app.clases.ISistema;
import com.app.datatypes.DtUsuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "BuscarVueloServlet", urlPatterns = {"/perfil/buscar"})
public class BuscarPerfilServlet extends HttpServlet {
    ISistema sistema = Factory.getSistema();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            List<DtUsuario> usuarios = sistema.listarUsuarios();

            request.setAttribute("usuarios", usuarios);

            request.getRequestDispatcher("/WEB-INF/jsp/perfil/buscar.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("Error en BuscarUsuarioServlet: " + e.getMessage());
            request.setAttribute("error", "Error al cargar la búsqueda de usuarios");
            request.getRequestDispatcher("/WEB-INF/jsp/usuarios/buscar.jsp").forward(request, response);
        }
    }

}
