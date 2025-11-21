package uy.volando.servlets.Perfil;

import uy.volando.soap.ControladorWS;
import uy.volando.soap.client.DtUsuario;
import uy.volando.soap.client.VolandoServicePort;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "BuscarPerfilServlet", urlPatterns = {"/perfil/buscar"})
public class BuscarPerfilServlet extends HttpServlet {
    VolandoServicePort ws = ControladorWS.getPort();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Boolean esMobile = (Boolean) request.getSession(false).getAttribute("esMobile");

        if (esMobile) {
            request.setAttribute("error", "Acceso no autorizado desde dispositivos móviles.");
            request.getRequestDispatcher("/WEB-INF/jsp/401.jsp").forward(request, response);
            return;
        }

        try {
            List<DtUsuario> usuarios = ws.listarUsuarios();

            request.setAttribute("usuarios", usuarios);

            request.getRequestDispatcher("/WEB-INF/jsp/perfil/buscar.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("Error en BuscarUsuarioServlet: " + e.getMessage());
            request.setAttribute("error", "Error al cargar la búsqueda de usuarios");
            request.getRequestDispatcher("/WEB-INF/jsp/usuarios/buscar.jsp").forward(request, response);
        }
    }

}
