package uy.volando.servlets.Vuelo;











import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import uy.volando.servlets.RutasDeVuelo.BuscarRutaServlet;
import uy.volando.soap.ControladorWS;
import uy.volando.soap.client.*;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@MultipartConfig
@WebServlet (name = "CrearVueloServlet", urlPatterns = {"/vuelo/crear"})
public class CrearVueloServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(CrearVueloServlet.class.getName());
    VolandoServicePort ws = ControladorWS.getPort();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null) {
            request.getRequestDispatcher("/WEB-INF/jsp/401.jsp").forward(request, response);
            return;
        }

        if(session.getAttribute("usuarioTipo") == null || session.getAttribute("usuarioNickname") == null || !"aerolinea".equals(session.getAttribute("usuarioTipo"))) {
            request.getRequestDispatcher("/WEB-INF/jsp/401.jsp").forward(request, response);
            return;
        }

        try{
            DtAerolinea aerolinea = ws.getAerolinea(session.getAttribute("usuarioNickname").toString());

            if (aerolinea == null || !aerolinea.getNickname().equals(session.getAttribute("usuarioNickname").toString())) {
                response.sendRedirect(request.getContextPath() + "/home");
                return;
            }

            if(request.getParameter("ruta") != null){
                DtRuta ruta = ws.getRutaDeVuelo(request.getParameter("ruta"));
                request.setAttribute("seleccionarRuta", ruta);
            }

            List<DtRuta> rutas = aerolinea.getRutasDeVuelo();

            rutas.removeIf(ruta -> ruta.getEstado() != EstadoRuta.APROBADA);

            request.setAttribute("rutas", rutas);


            request.getRequestDispatcher("/WEB-INF/jsp/vuelo/crear.jsp").forward(request, response);
        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "Error: ", ex.getMessage());
            request.getRequestDispatcher("/WEB-INF/jsp/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/plain;charset=UTF-8");
        try {

            String nombre = request.getParameter("nombre");
            String duracionStr = request.getParameter("duracion");
            String fechaStr = request.getParameter("fecha");
            String maxEjecutivosStr = request.getParameter("max-ejecutivos");
            String maxTuristasStr = request.getParameter("max-turistas");
            String rutaStr = request.getParameter("ruta");
            Part filePart = request.getPart("image");

            if (nombre == null || duracionStr == null || fechaStr == null || maxEjecutivosStr == null || maxTuristasStr == null || rutaStr == null ||
                nombre.isEmpty() || duracionStr.isEmpty() || fechaStr.isEmpty() || maxEjecutivosStr.isEmpty() || maxTuristasStr.isEmpty() || rutaStr.isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Por favor, complete todos los campos obligatorios.");
                return;
            }

            if (ws.existeVuelo(nombre)) {
                response.setStatus(HttpServletResponse.SC_CONFLICT);
                response.getWriter().write("Ya existe un vuelo con ese nombre");
                return;
            }

            int maxEjecutivos = Integer.parseInt(maxEjecutivosStr);
            int maxTuristas = Integer.parseInt(maxTuristasStr);

            if (maxEjecutivos == 0 && maxTuristas == 0) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("El vuelo debe tener al menos una plaza disponible");
                return;
            }

            LocalTime duracion;
            try{
                duracion = LocalTime.parse(duracionStr);
            } catch (Exception e) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Formato de duración inválido. Use HH:MM");
                return;
            }

            LocalDate fecha;
            try{
                fecha = LocalDate.parse(fechaStr);
            } catch (Exception e) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Formato de fecha inválido. Use AAAA-MM-DD");
                return;
            }

            if (fecha.isBefore(LocalDate.now())) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("La fecha del vuelo no puede ser en el pasado.");
                return;
            }

            if (filePart == null || filePart.getSize() == 0) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Debe seleccionar una imagen");
                return;
            }

            byte[] data = filePart.getInputStream().readAllBytes();

            String imagen = ws.guardarImagen(data, TipoImagen.VUELO);

            DtVuelo nuevoVuelo = new DtVuelo();

            nuevoVuelo.setNombre(nombre);
            nuevoVuelo.setFecha(fecha.toString());
            nuevoVuelo.setDuracion(duracion.toString());
            nuevoVuelo.setMaxTuristas(maxTuristas);
            nuevoVuelo.setMaxEjecutivos(maxEjecutivos);
            nuevoVuelo.setUrlImage(imagen);
            nuevoVuelo.setFechaAlta(LocalDate.now().toString());
            nuevoVuelo.setRutaDeVuelo(ws.getRutaDeVuelo(rutaStr));
            nuevoVuelo.setCantReservas(0);

            ws.altaVuelo(nuevoVuelo);

            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write("Vuelo creado con éxito");

        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "Error: ", ex.getMessage());
            request.getRequestDispatcher("/WEB-INF/jsp/error.jsp").forward(request, response);
        }
    }
}
