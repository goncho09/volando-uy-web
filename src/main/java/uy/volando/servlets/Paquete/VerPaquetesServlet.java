package uy.volando.servlets.Paquete;

import uy.volando.soap.ControladorWS;
import uy.volando.soap.client.DtPaquete;
import uy.volando.soap.client.VolandoServicePort;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet (name = "VerPaquetesServlet", urlPatterns = {"/paquete/ver"})
public class VerPaquetesServlet extends HttpServlet {

    VolandoServicePort ws = ControladorWS.getPort();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        Boolean esMobile = (Boolean) session.getAttribute("esMobile");

        if (esMobile) {
            request.setAttribute("error", "Acceso no autorizado desde dispositivos móviles.");
            request.getRequestDispatcher("/WEB-INF/jsp/401.jsp").forward(request, response);
            return;
        }

        if(session.getAttribute("usuarioTipo") == null || session.getAttribute("usuarioNickname") == null ){
            request.getRequestDispatcher("/WEB-INF/jsp/401.jsp").forward(request, response);
            return;
        }

        try {
            String tipoUsuario = session.getAttribute("usuarioTipo").toString();
            String nickname = (String) session.getAttribute("usuarioNickname");
            List<DtPaquete> paqueteList = null;
            if (tipoUsuario.equals("aerolinea")) {
                paqueteList = ws.listarPaquetesAerolinea(nickname);
            }else{
                paqueteList = ws.listarPaquetesCliente(nickname);
            }
            request.setAttribute("paquetes", paqueteList);

            request.getRequestDispatcher("/WEB-INF/jsp/paquete/ver.jsp").forward(request, response);
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Error al obtener la lista de paquetes: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/jsp/error.jsp").forward(request, response);
        }

    }

}
