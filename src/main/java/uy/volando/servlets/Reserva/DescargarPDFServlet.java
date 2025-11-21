package uy.volando.servlets.Reserva;

import uy.volando.soap.ControladorWS;
import uy.volando.soap.client.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;

@WebServlet("/reservas/descargar-pdf")
public class DescargarPDFServlet extends HttpServlet {

    private final VolandoServicePort ws = ControladorWS.getPort();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String nombreVuelo = request.getParameter("vuelo");
        String fecha = request.getParameter("fecha");
        String nickname = (String) request.getSession().getAttribute("usuarioNickname");

        try {
            DtVuelo vuelo = ws.getVuelo(nombreVuelo);
            DtCliente cliente = ws.getCliente(nickname);
            DtReserva reserva = ws.getReservaCliente(vuelo, cliente, fecha);

            // Llamamos al central → nos devuelve los bytes directamente
            byte[] pdfBytes = ws.crearPDFReserva(reserva);

            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition",
                    "attachment; filename=\"BoardingPass_" + nombreVuelo + ".pdf\"");
            response.getOutputStream().write(pdfBytes);

        } catch (Exception e) {
            response.sendError(500, "Error: " + e.getMessage());
        }
    }
}