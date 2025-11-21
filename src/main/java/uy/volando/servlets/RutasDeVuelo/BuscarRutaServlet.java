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

        Boolean esMobile = (Boolean) session.getAttribute("esMobile");

        if (esMobile) {
            request.setAttribute("error", "Acceso no autorizado desde dispositivos móviles.");
            request.getRequestDispatcher("/WEB-INF/jsp/401.jsp").forward(request, response);
            return;
        }

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
            String basePath = getServletContext().getRealPath("/pictures/rutas");
            String contextPath = request.getContextPath();
            String urlImagen = ruta.getUrlImagen();
            File rutaImg = null;

            if (urlImagen != null && !urlImagen.isEmpty()) {
                rutaImg = new File(basePath, urlImagen);
            }

            if (urlImagen == null || urlImagen.isEmpty() || !rutaImg.exists()) {
                ruta.setUrlImagen(contextPath + "/assets/rutaDefault.png");
            } else {
                ruta.setUrlImagen(contextPath + "/pictures/rutas/" + urlImagen);
            }

            // Procesar vuelos
            List<DtVuelo> vueloList = ws.getVuelosRutaDeVuelo(ruta);
            vueloList.removeIf(vuelo -> LocalDate.parse(vuelo.getFecha().toString()).isBefore(LocalDate.now()));

            for (DtVuelo vuelo : vueloList) {
                basePath = getServletContext().getRealPath("/pictures/vuelos");  // Reasigna basePath

                String urlImage = vuelo.getUrlImage();
                File vueloImg = null;

                if (urlImage != null && !urlImage.isEmpty()) {
                    vueloImg = new File(basePath, urlImage);
                }

                if (urlImage == null || urlImage.isEmpty() || !vueloImg.exists()) {
                    vuelo.setUrlImage(contextPath + "/assets/vueloDefault.jpg");
                } else {
                    vuelo.setUrlImage(contextPath + "/pictures/vuelos/" + urlImage);
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