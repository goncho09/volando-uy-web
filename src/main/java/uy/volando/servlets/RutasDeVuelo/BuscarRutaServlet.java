package uy.volando.servlets.RutasDeVuelo;

import uy.volando.soap.ControladorWS;
import uy.volando.soap.client.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.File;
import java.io.IOException;

import java.time.LocalDate;

import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "RutaServlet", urlPatterns = {"/ruta-de-vuelo/buscar"})
public class BuscarRutaServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(BuscarRutaServlet.class.getName());
    VolandoServicePort ws = ControladorWS.getPort();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        try {
            String nombreRuta = request.getParameter("nombre");
            if (nombreRuta == null || nombreRuta.trim().isEmpty()) {
                throw new IllegalArgumentException("Nombre de ruta requerido");
            }

            DtRuta ruta = ws.getRutaDeVuelo(nombreRuta);
            if (ruta == null) {
                throw new Exception("Ruta no encontrada");
            }
            if (ruta.getEstado() != EstadoRuta.APROBADA) {
                throw new Exception("Ruta no disponible");
            }

            // Procesar imagen de ruta
            String contextPath = request.getContextPath();

            String urlImagen = ruta.getUrlImagen();
            boolean invalida = (urlImagen == null || urlImagen.isEmpty());

            if (invalida) {
                ruta.setUrlImagen(contextPath + "/assets/rutaDefault.png");
            } else {
                ruta.setUrlImagen(contextPath + "/imagen?nombre=" + urlImagen + "&tipo=Ruta");
            }

            // Procesar vuelos
            List<DtVuelo> vueloList = ws.getVuelosRutaDeVuelo(ruta);
            vueloList.removeIf(vuelo -> LocalDate.parse(vuelo.getFecha().toString()).isBefore(LocalDate.now()));

            for (DtVuelo vuelo : vueloList) {
                String urlImagenVuelo = vuelo.getUrlImage();
                boolean invalidaVuelo = (urlImagenVuelo == null || urlImagenVuelo.isEmpty());

                if (invalidaVuelo) {
                    vuelo.setUrlImage(contextPath + "/assets/rutaDefault.png");
                } else {
                    vuelo.setUrlImage(contextPath + "/imagen?nombre=" + urlImagenVuelo + "&tipo=Vuelo");
                }
            }

            // Procesar paquetes
            List<DtPaquete> paqueteList = ws.listarPaquetesNoComprados();
            paqueteList.removeIf(paquete -> {
                List<DtRutaEnPaquete> rutaList = paquete.getRutaEnPaquete();
                if (rutaList == null || rutaList.isEmpty()) return true;
                for (DtRutaEnPaquete rep : rutaList){
                    if (!rep.getRutaDeVuelo().getNombre().equals(ruta.getNombre())) return true;
                }
                return false;
            });

            // Check de owner (solo si hay sesión)
            boolean allowed = false;
            if (session != null &&  // <-- FIX: Check null aquí
                    session.getAttribute("usuarioTipo") != null &&
                    session.getAttribute("usuarioNickname") != null &&
                    "aerolinea".equals(session.getAttribute("usuarioTipo"))) {

                String nickname = session.getAttribute("usuarioNickname").toString();
                System.out.println(">>> BuscarRuta: Chequeando owner para " + nickname);  // Debug

                DtAerolinea a = ws.getAerolinea(nickname);
                if (a != null) {
                    List<DtRuta> rutasAerolinea = a.getRutasDeVuelo();
                    if (!rutasAerolinea.isEmpty()) {
                        for (DtRuta r : rutasAerolinea) {
                            if (r.getNombre().equals(nombreRuta)) {
                                allowed = true;
                                break;
                            }
                        }
                    }
                }
            }

            // Setear atributos
            request.setAttribute("ruta", ruta);
            request.setAttribute("vuelos", vueloList);
            request.setAttribute("paquetes", paqueteList);
            request.setAttribute("rutaOwner", allowed);

            request.getRequestDispatcher("/WEB-INF/jsp/rutaDeVuelo/buscar.jsp").forward(request, response);

        } catch (Exception e) {
            System.out.println(">>> BuscarRutaServlet: Excepción = " + e.getMessage());  // Debug
            LOGGER.log(Level.SEVERE, "Error en BuscarRutaServlet: ", e);
            request.setAttribute("error", e.getMessage());  // Para mostrar en error.jsp
            request.getRequestDispatcher("/WEB-INF/jsp/error.jsp").forward(request, response);
        }
    }
}