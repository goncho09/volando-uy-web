package uy.volando.servlets.RutasDeVuelo;

import uy.volando.soap.ControladorWS;
import uy.volando.soap.client.DtAerolinea;
import uy.volando.soap.client.DtRuta;
import uy.volando.soap.client.VolandoServicePort;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

        Boolean esMobile = (Boolean) session.getAttribute("esMobile");

        if (esMobile) {
            request.setAttribute("error", "Acceso no autorizado desde dispositivos móviles.");
            request.getRequestDispatcher("/WEB-INF/jsp/401.jsp").forward(request, response);
            return;
        }

        try{

            String nicknameAerolinea = session.getAttribute("usuarioNickname").toString();
            DtAerolinea aerolineaIniciada = ws.getAerolinea(nicknameAerolinea);
            List<DtRuta> rutas = aerolineaIniciada.getRutasDeVuelo();
            Map<String, Boolean> puedeFinalizarMap = new HashMap<>();

            for (DtRuta ruta : rutas) {
                boolean puede = ws.puedeFinalizar(ruta.getNombre());
                puedeFinalizarMap.put(ruta.getNombre(), puede);
            }

            request.setAttribute("rutas", rutas);
            request.setAttribute("puedeFinalizarMap", puedeFinalizarMap);

            request.getRequestDispatcher("/WEB-INF/jsp/rutaDeVuelo/ver.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println(e.getMessage());
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Error al obtener la lista de rutas de vuelo: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/jsp/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
                session.getAttribute("usuarioTipo") == null ||
                session.getAttribute("usuarioNickname") == null ||
                !session.getAttribute("usuarioTipo").equals("aerolinea")) {

            response.sendRedirect(request.getContextPath() + "/401.jsp");
            return;
        }

        String action = request.getParameter("action");
        String nombreRuta = request.getParameter("nombre");

        if ("finalizar".equals(action)) {

            if (nombreRuta == null || nombreRuta.isEmpty()) {
                response.sendRedirect(request.getContextPath()
                        + "/ruta-de-vuelo/ver?error=Nombre inválido");
                return;
            }

            try {
                DtRuta dto = ws.getRutaDeVuelo(nombreRuta);

                ws.finalizarRuta(dto);

                response.sendRedirect(request.getContextPath()
                        + "/ruta-de-vuelo/ver?success=Ruta finalizada correctamente");
            } catch (Exception e) {
                response.sendRedirect(request.getContextPath()
                        + "/ruta-de-vuelo/ver?error=" + e.getMessage());
            }
        }
    }
}
