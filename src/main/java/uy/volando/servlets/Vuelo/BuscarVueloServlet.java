package uy.volando.servlets.Vuelo;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import uy.volando.soap.ControladorWS;
import uy.volando.soap.client.*;

        import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

@WebServlet(name = "BuscarVueloServlet", urlPatterns = {"/vuelo/buscar"})
public class BuscarVueloServlet extends HttpServlet {

    VolandoServicePort ws = ControladorWS.getPort();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {

            List<DtAerolinea> aerolineas = ws.listarAerolineas();

            aerolineas.removeIf(aerolinea -> {
                List<DtRuta> rutas = aerolinea.getRutasDeVuelo();
                if (rutas == null || rutas.isEmpty()) {
                    return true;
                }
                for (DtRuta ruta : rutas) {
                    if (ruta.getEstado() == EstadoRuta.APROBADA) {
                        List<DtVuelo> vuelos = ws.listarVuelosRuta(ruta.getNombre());
                        if (vuelos != null && !vuelos.isEmpty()) {
                            return false;
                        }
                    }
                }

                return true;
            });

            request.setAttribute("aerolineas", aerolineas);

            String idAerolinea = request.getParameter("aerolinea");
            String idRuta = request.getParameter("ruta");
            String fecha = request.getParameter("fecha");

            if (idAerolinea != null && idRuta == null) {
                DtAerolinea aerolinea = ws.getAerolinea(idAerolinea);
                List<DtRuta> rutasAerolinea = aerolinea.getRutasDeVuelo();

                rutasAerolinea.removeIf(ruta -> (ruta.getEstado() != EstadoRuta.APROBADA));
                rutasAerolinea.removeIf(ruta -> (ws.listarVuelosRuta(ruta.getNombre()).isEmpty()));

                request.setAttribute("rutas", rutasAerolinea);
                request.setAttribute("aerolineaId", idAerolinea);
            }

            if (idRuta != null && idAerolinea != null) {
                DtAerolinea aerolinea = ws.getAerolinea(idAerolinea);

                request.setAttribute("aerolineaId", idAerolinea);
                request.setAttribute("rutaId", idRuta);
                request.setAttribute("rutas", aerolinea.getRutasDeVuelo());

                LocalDate fechaVuelo = fecha != null && !fecha.isEmpty() ? LocalDate.parse(fecha) : null;
                List<DtVuelo> vuelos;
                if (fechaVuelo != null) {
                    vuelos = ws.listarVuelosRutaFecha(idRuta, fechaVuelo.toString());
                } else {
                    vuelos = ws.listarVuelosRuta(idRuta);
                }
                request.setAttribute("vuelos", vuelos);
            }

            request.getRequestDispatcher("/WEB-INF/jsp/vuelo/buscar.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("Error en BuscarVueloServlet: " + e.getMessage());
            request.setAttribute("error", "Error al cargar la búsqueda de vuelos");
            request.getRequestDispatcher("/WEB-INF/jsp/vuelo/buscar.jsp").forward(request, response);
        }
    }

}