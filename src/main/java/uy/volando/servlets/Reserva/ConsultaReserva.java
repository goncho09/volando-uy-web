package uy.volando.servlets.Reserva;






import uy.volando.soap.ControladorWS;
import uy.volando.soap.client.DtAerolinea;
import uy.volando.soap.client.DtCliente;
import uy.volando.soap.client.DtVuelo;
import uy.volando.soap.client.VolandoServicePort;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDate;

@WebServlet(name = "ConsultaReserva", urlPatterns = {"/reservas/consulta"})
public class ConsultaReserva extends HttpServlet {
    VolandoServicePort ws = ControladorWS.getPort();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null) {
            request.getRequestDispatcher("/WEB-INF/jsp/401.jsp").forward(request, response);
            return;
        }

        if (session.getAttribute("usuarioTipo") == null || session.getAttribute("usuarioNickname") == null) {
            request.getRequestDispatcher("/WEB-INF/jsp/401.jsp").forward(request, response);
            return;
        }

        try{
            String nickname = (String) request.getSession().getAttribute("usuarioNickname");
            String usuarioTipo = (String) request.getSession().getAttribute("usuarioTipo");
            String fechaReserva = request.getParameter("fecha");
            LocalDate fechaReservaDate = LocalDate.parse(fechaReserva);
            DtVuelo vuelo = ws.getVuelo(request.getParameter("vuelo"));

            if (usuarioTipo.equals("cliente")) {
                DtCliente cliente = ws.getCliente(nickname);
                request.setAttribute("reserva", ws.getReservaCliente(vuelo, cliente, fechaReservaDate.toString()));
            }
            else{
                DtAerolinea aerolinea = ws.getAerolinea(nickname);
                request.setAttribute("reserva", ws.getReservaAerolinea(vuelo, aerolinea, fechaReservaDate.toString()));
            }

            request.getRequestDispatcher("/WEB-INF/jsp/reservas/consulta.jsp").forward(request, response);
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            System.out.println(e.getMessage());
            response.getWriter().write("Error al obtener la lista de reservas: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/jsp/error.jsp").forward(request, response);
        }

    }
}




