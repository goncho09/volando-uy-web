package uy.volando.servlets.RutasDeVuelo;




import uy.volando.soap.ControladorWS;
import uy.volando.soap.client.DtAerolinea;
import uy.volando.soap.client.VolandoServicePort;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet (name = "VerRutasServlet", urlPatterns = {"/ruta-de-vuelo/ver"})
public class VerRutasServlet extends HttpServlet {

    VolandoServicePort ws = ControladorWS.getPort();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {


        HttpSession session = request.getSession(false);

        if (session.getAttribute("usuarioTipo") == null || session.getAttribute("usuarioNickname") == null) {
            request.getRequestDispatcher("/WEB-INF/jsp/401.jsp").forward(request, response);
            return;
        }

        if (!session.getAttribute("usuarioTipo").equals("aerolinea")) {
            request.getRequestDispatcher("/WEB-INF/jsp/401.jsp").forward(request, response);
            return;
        }

        try{

            DtAerolinea aerolineaIniciada = (DtAerolinea) ws.getAerolinea(session.getAttribute("usuarioNickname").toString());
            request.setAttribute("rutas", aerolineaIniciada.getRutasDeVuelo());

            request.getRequestDispatcher("/WEB-INF/jsp/rutaDeVuelo/ver.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println(e.getMessage());
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Error al obtener la lista de rutas de vuelo: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/jsp/error.jsp").forward(request, response);
        }
    }
}
