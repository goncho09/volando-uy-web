package uy.volando.servlets.Reserva;

import uy.volando.soap.ControladorWS;
import uy.volando.soap.client.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "ConsultaReserva", urlPatterns = {"/reservas/consulta"})
public class ConsultaReserva extends HttpServlet {

    private final VolandoServicePort ws = ControladorWS.getPort();

    // GET: Mostrar detalle de reserva
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        cargarDetalleReserva(request, response);
    }

    // POST: Hacer check-in cuando el usuario pulsa el botón
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String nombreVuelo = request.getParameter("vuelo");      // ej: "Vuelo.1"
        String fechaReserva = request.getParameter("fecha");    // ya viene como String "2025-11-22"
        String nickname = (String) request.getSession().getAttribute("usuarioNickname");

        try {
            // Obtenemos el DtVuelo completo
            DtVuelo vuelo = ws.getVuelo(nombreVuelo);

            // ¡¡EXACTAMENTE como está en tu backend!!
            ws.realizarCheckin(vuelo, fechaReserva, nickname);

            // Redirigimos → ahora muestra check-in hecho sin ningún error
            response.sendRedirect(request.getContextPath() +
                    "/reservas/consulta?vuelo=" + nombreVuelo + "&fecha=" + fechaReserva);

        } catch (Exception e) {
            request.setAttribute("errorCheckin", e.getMessage());
            cargarDetalleReserva(request, response);
        }
    }

    // Método auxiliar para no repetir código
    private void cargarDetalleReserva(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session.getAttribute("usuarioNickname") == null || session.getAttribute("usuarioTipo") == null) {
            request.getRequestDispatcher("/WEB-INF/jsp/401.jsp").forward(request, response);
            return;
        }

        String nickname = (String) session.getAttribute("usuarioNickname");
        String usuarioTipo = (String) session.getAttribute("usuarioTipo");
        String fechaReserva = request.getParameter("fecha");
        String nombreVuelo = request.getParameter("vuelo");

        if (fechaReserva == null || nombreVuelo == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Faltan parámetros");
            return;
        }

        try {
            DtVuelo vuelo = ws.getVuelo(nombreVuelo);

            DtReserva reserva;
            if ("cliente".equals(usuarioTipo)) {
                DtCliente cliente = ws.getCliente(nickname);
                reserva = ws.getReservaCliente(vuelo, cliente, fechaReserva);
            } else {
                DtAerolinea aerolinea = ws.getAerolinea(nickname);
                reserva = ws.getReservaAerolinea(vuelo, aerolinea, fechaReserva);
            }

            request.setAttribute("reserva", reserva);
            request.getRequestDispatcher("/WEB-INF/jsp/reservas/consulta.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "No se pudo cargar la reserva: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/jsp/error.jsp").forward(request, response);
        }
    }
}