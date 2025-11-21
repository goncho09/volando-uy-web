package uy.volando.servlets.Paquete;

import uy.volando.soap.ControladorWS;
import uy.volando.soap.client.DtPaquete;
import uy.volando.soap.client.DtRutaEnPaquete;
import uy.volando.soap.client.EstadoRuta;
import uy.volando.soap.client.VolandoServicePort;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet (name = "BuscarPaqueteServlet", urlPatterns = {"/paquete/buscar"})
public class BuscarPaqueteServlet extends HttpServlet {

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

        try{
            List<DtPaquete> listaPaquete = ws.listarPaquetesNoComprados();

            for(DtPaquete p : listaPaquete){
                List<DtRutaEnPaquete> listaRutasPaquete = p.getRutaEnPaquete();
                listaRutasPaquete.removeIf(rutaEnPaquete -> rutaEnPaquete.getRutaDeVuelo().getEstado() != EstadoRuta.APROBADA);
            }

            listaPaquete.removeIf(paquete -> paquete.getRutaEnPaquete() == null || paquete.getRutaEnPaquete().isEmpty());
            request.setAttribute("paquetes", listaPaquete);

            request.getRequestDispatcher("/WEB-INF/jsp/paquete/buscar.jsp").forward(request, response);
        } catch (Exception ex) {
            request.setAttribute("error", ex.getMessage());
            request.getRequestDispatcher("/WEB-INF/jsp/error.jsp").forward(request, response);
        }
    }
}
