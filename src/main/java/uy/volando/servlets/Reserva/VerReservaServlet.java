package uy.volando.servlets.Reserva;

import uy.volando.soap.ControladorWS;
import uy.volando.soap.client.DtAerolinea;
import uy.volando.soap.client.DtCliente;
import uy.volando.soap.client.VolandoServicePort;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet (name = "VerReservaServlet", urlPatterns = {"/reservas/ver"})
public class VerReservaServlet extends HttpServlet {

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
            String usuarioTipo = (String) request.getSession().getAttribute("usuarioTipo");
            String nicknameCliente = (String) request.getSession().getAttribute("usuarioNickname");

            if (usuarioTipo.equals("cliente")) {
                DtCliente cliente = ws.getCliente(nicknameCliente);
                request.setAttribute("reservas", ws.listarReservasCliente(cliente.getNickname()));
            }
            else{
                DtAerolinea aerolinea = ws.getAerolinea(nicknameCliente);
                request.setAttribute("reservas", ws.listarReservasAerolinea(aerolinea.getNickname()));
            }

            request.getRequestDispatcher("/WEB-INF/jsp/reservas/ver.jsp").forward(request, response);
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Error al obtener la lista de reservas: " + e.getMessage());
            System.out.println(e.getMessage());
            request.getRequestDispatcher("/WEB-INF/jsp/error.jsp").forward(request, response);
        }

    }
}
