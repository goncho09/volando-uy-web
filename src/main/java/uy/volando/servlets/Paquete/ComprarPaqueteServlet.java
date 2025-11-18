package uy.volando.servlets.Paquete;

import uy.volando.soap.ControladorWS;
import uy.volando.soap.client.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ComprarPaqueteServlet", urlPatterns = {"/paquete/comprar"})
public class ComprarPaqueteServlet extends HttpServlet {

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

        if (!session.getAttribute("usuarioTipo").equals("cliente")) {
            request.getRequestDispatcher("/WEB-INF/jsp/401.jsp").forward(request, response);
            return;
        }

        try {
            List<DtPaquete> listaPaquete = ws.listarPaquetesNoComprados();

            for(DtPaquete p : listaPaquete){
                List<DtRutaEnPaquete> listaRutasPaquete = p.getRutaEnPaquete();
                listaRutasPaquete.removeIf(rutaEnPaquete -> rutaEnPaquete.getRutaDeVuelo().getEstado() != EstadoRuta.APROBADA);
            }

            listaPaquete.removeIf(paquete -> paquete.getRutaEnPaquete() == null || paquete.getRutaEnPaquete().isEmpty());

            request.setAttribute("paquetes", listaPaquete);

            request.getRequestDispatcher("/WEB-INF/jsp/paquete/comprar.jsp").forward(request, response);

        } catch (Exception ex) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            System.out.println("Error en ComprarPaqueteServlet (GET): " + ex.getMessage());
            request.getRequestDispatcher("/WEB-INF/jsp/401.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
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

        try {
            String paqueteNombre = request.getParameter("paquete");
            System.out.println("Nombre paquete recibido: " + paqueteNombre);

            if (paqueteNombre == null || paqueteNombre.isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Debe seleccionar un paquete para comprar.");
                return;
            }

            String nicknameCliente = (String) session.getAttribute("usuarioNickname");
            DtCliente clienteLogueado = ws.getCliente(nicknameCliente);
            DtPaquete paqueteSelect = ws.getPaquete(paqueteNombre);

            if (paqueteSelect == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("El paquete seleccionado no existe.");
                return;
            }

            ws.compraPaquete(paqueteSelect, clienteLogueado);

            List<DtPaquete> paquetes = ws.listarPaquetesNoComprados();
            request.setAttribute("paquetes", paquetes);

            response.setStatus(HttpServletResponse.SC_OK);
            request.getRequestDispatcher("/WEB-INF/jsp/paquete/comprar.jsp").forward(request, response);

        } catch (Exception ex) {
            System.out.println("Error en ComprarPaqueteServlet (POST): " + ex.getMessage());
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Error del servidor");
        }
    }
}
