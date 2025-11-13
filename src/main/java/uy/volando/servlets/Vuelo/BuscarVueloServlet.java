package uy.volando.servlets.Vuelo;

import com.app.clases.Factory;
import com.app.clases.ISistema;
import com.app.datatypes.DtAerolinea;
import com.app.datatypes.DtRuta;
import com.app.datatypes.DtVuelo;
import com.app.enums.EstadoRuta;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "BuscarVueloServlet", urlPatterns = {"/vuelo/buscar"})
public class BuscarVueloServlet extends HttpServlet {
    ISistema sistema = Factory.getSistema();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {

            System.out.println("entrado al servlet buscar vuelo");
            List<DtAerolinea> aerolineas = sistema.listarAerolineas();

            aerolineas.removeIf(aerolinea -> {
                List<DtRuta> rutas = aerolinea.listarRutasDeVuelo();
                if (rutas == null || rutas.isEmpty()) {
                    return true;
                }
                for (DtRuta ruta : rutas) {
                    if (ruta.getEstado() == EstadoRuta.APROBADA) {
                        List<DtVuelo> vuelos = sistema.listarVuelosRuta(ruta.getNombre());
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
                DtAerolinea aerolinea = sistema.getAerolinea(idAerolinea);
                List<DtRuta> rutasAerolinea = aerolinea.listarRutasDeVuelo();

                rutasAerolinea.removeIf(ruta -> (ruta.getEstado() != EstadoRuta.APROBADA));
                rutasAerolinea.removeIf(ruta -> (sistema.listarVuelosRuta(ruta.getNombre()).isEmpty()));

                request.setAttribute("rutas", rutasAerolinea);
                request.setAttribute("aerolineaId", idAerolinea);
            }

            if (idRuta != null && idAerolinea != null) {
                DtAerolinea aerolinea = sistema.getAerolinea(idAerolinea);

                request.setAttribute("aerolineaId", idAerolinea);
                request.setAttribute("rutaId", idRuta);
                request.setAttribute("rutas", aerolinea.listarRutasDeVuelo());

                LocalDate fechaVuelo = fecha != null && !fecha.isEmpty() ? LocalDate.parse(fecha) : null;
                List<DtVuelo> vuelos = sistema.listarVuelosRutaFecha(idRuta, fechaVuelo);
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
