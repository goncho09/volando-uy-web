package uy.volando.servlets.RutasDeVuelo;

import uy.volando.soap.ControladorWS;
import uy.volando.soap.client.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

@MultipartConfig
@WebServlet(name = "CrearRutaServlet", urlPatterns = {"/ruta-de-vuelo/crear"})
public class CrearRutaServlet extends HttpServlet {

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


        if (session.getAttribute("usuarioTipo") == null || session.getAttribute("usuarioNickname") == null) {
            request.getRequestDispatcher("/WEB-INF/jsp/401.jsp").forward(request, response);
            return;
        }

        if (!session.getAttribute("usuarioTipo").equals("aerolinea")) {
            request.getRequestDispatcher("/WEB-INF/jsp/401.jsp").forward(request, response);
            return;
        }

        try {
            // Obtener datos para formulario
            List<DtCiudad> dtCiudades = ws.listarCiudades();
            List<DtCategoria> dtCategorias = getCategoriasDisponibles();

            request.setAttribute("ciudades", dtCiudades);
            request.setAttribute("categorias", dtCategorias);

            request.getRequestDispatcher("/WEB-INF/jsp/rutaDeVuelo/crear.jsp").forward(request, response);

        } catch (Exception ex) {
            System.err.println("Error en CrearRutaServlet (GET): " + ex.getMessage());
            ex.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Error del servidor: " + ex.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String userAgent = request.getHeader("User-Agent");

        boolean esMobile = userAgent != null && (
                userAgent.contains("Mobile") ||
                        userAgent.contains("Android") ||
                        userAgent.contains("iPhone") ||
                        userAgent.contains("iPad")
        );

        if (esMobile) {
            request.setAttribute("error", "Acceso no autorizado desde dispositivos móviles.");
            request.getRequestDispatcher("/WEB-INF/jsp/401.jsp").forward(request, response);
            return;
        }

        response.setContentType("text/plain;charset=UTF-8");
        try {
            HttpSession session = request.getSession(false);
            if (session == null || !"aerolinea".equals(session.getAttribute("usuarioTipo"))) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.getWriter().write("No autorizado");
                return;
            }

            // Obtener parámetros
            String nombre = request.getParameter("nombre");
            String descripcionCorta = request.getParameter("descripcionCorta");
            String descripcion = request.getParameter("descripcion");
            String horaStr = request.getParameter("hora");
            String costoTuristaStr = request.getParameter("costoTurista");
            String costoEjecutivoStr = request.getParameter("costoEjecutivo");
            String costoEquipajeExtraStr = request.getParameter("costoEquipajeExtra");
            String ciudadOrigenStr = request.getParameter("ciudadOrigen");
            String ciudadDestinoStr = request.getParameter("ciudadDestino");
            String[] categoriasArray = request.getParameterValues("categorias");
            Part filePart = request.getPart("image");

            // Validar campos obligatorios
            if (nombre == null || descripcionCorta == null || descripcion == null || horaStr == null ||
                    costoTuristaStr == null || costoEjecutivoStr == null || costoEquipajeExtraStr == null ||
                    ciudadOrigenStr == null || ciudadDestinoStr == null || categoriasArray == null) {

                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Por favor, complete todos los campos obligatorios.");
                return;
            }

            // Validar que el nombre sea único
            if (ws.existeRuta(nombre)) {
                response.setStatus(HttpServletResponse.SC_CONFLICT);
                response.getWriter().write("Ya existe una ruta de vuelo con ese nombre.");
                return;
            }

            // Convertir y validar tipos de datos
            float costoTurista, costoEjecutivo, costoEquipajeExtra;
            try {
                costoTurista = Float.parseFloat(costoTuristaStr);
                costoEjecutivo = Float.parseFloat(costoEjecutivoStr);
                costoEquipajeExtra = Float.parseFloat(costoEquipajeExtraStr);

                if (costoTurista <= 0 || costoEjecutivo <= 0 || costoEquipajeExtra < 0) {
                    throw new NumberFormatException("Los costos deben ser positivos");
                }
            } catch (NumberFormatException e) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Formato de costo inválido. Use números positivos.");
                return;
            }

            // Validar hora y convertir a duración (LocalTime)
            LocalTime duracion;
            try {
                duracion = LocalTime.parse(horaStr);
            } catch (Exception e) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Formato de hora inválido. Use HH:MM");
                return;
            }

            // Validar ciudades
            if (ciudadOrigenStr.equals(ciudadDestinoStr)) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("La ciudad origen y destino no pueden ser la misma.");
                return;
            }

            // Obtener objetos Ciudad desde los strings
            DtCiudad ciudadOrigen = obtenerCiudadDesdeString(ciudadOrigenStr);
            DtCiudad ciudadDestino = obtenerCiudadDesdeString(ciudadDestinoStr);

            if (ciudadOrigen == null || ciudadDestino == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Ciudad origen o destino no válida.");
                return;
            }

            // Obtener categorías
            List<String> nombresCategorias = new ArrayList<>();
            for (String catNombre : categoriasArray) {
                nombresCategorias.add(catNombre);
            }
            List<DtCategoria> categoriasSeleccionadas = ws.buscarCategoriasPorNombre(nombresCategorias);

            if (categoriasSeleccionadas.isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("No se encontraron las categorías seleccionadas.");
                return;
            }

            // Obtener aerolínea desde la sesión
            String nicknameAerolinea = (String) session.getAttribute("usuarioNickname");
            DtAerolinea aerolinea = ws.getAerolinea(nicknameAerolinea);

            if (aerolinea == null) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.getWriter().write("Aerolínea no encontrada.");
                return;
            }

            if (filePart == null || filePart.getSize() == 0) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Debe seleccionar una imagen");
                return;
            }

            InputStream inputStream = filePart.getInputStream();
            ByteArrayOutputStream buffer = new ByteArrayOutputStream();
            int nRead;
            byte[] temp = new byte[1024];
            while ((nRead = inputStream.read(temp, 0, temp.length)) != -1) {
                buffer.write(temp, 0, nRead);
            }
            buffer.flush();
            byte[] data = buffer.toByteArray();
            inputStream.close();

            String imagen = ws.guardarImagen(data, TipoImagen.RUTA);

            LocalDate fechaAlta = LocalDate.now();

            DtRuta ruta = new DtRuta();
//                      nombre,
//                    descripcion,
//                    descripcionCorta,
//                    duracion,
//                    costoTurista,
//                    costoEjecutivo,
//                    costoEquipajeExtra,
//                    fechaAlta,
//                    imagen,
//                    categoriasSeleccionadas,
//                    ciudadOrigen,
//                    ciudadDestino

            ruta.setNombre(nombre);
            ruta.setDescripcion(descripcion);
            ruta.setDescripcionCorta(descripcionCorta);
            ruta.setDuracion(duracion.toString());
            ruta.setCostoTurista(costoTurista);
            ruta.setCostoEjecutivo(costoEjecutivo);
            ruta.setEquipajeExtra(costoEquipajeExtra);
            ruta.setFechaAlta(fechaAlta.toString());
            ruta.setUrlImagen(imagen);
            ruta.getCategorias().clear();
            ruta.getCategorias().addAll(categoriasSeleccionadas);
            ruta.setCiudadOrigen(ciudadOrigen);
            ruta.setCiudadDestino(ciudadDestino);


            // Usar el método del sistema para crear la ruta
            ws.altaRutaDeVuelo(nicknameAerolinea, ruta);

            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write("Ruta de vuelo creada con éxito");

        } catch (Exception ex) {
        System.err.println("Error en CrearRutaServlet (POST): " + ex.getMessage());
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        response.getWriter().write("Error: " + ex.getMessage());
    }
    }

    // Auxiliar para obtener Ciudad desde string
    private DtCiudad obtenerCiudadDesdeString(String ciudadStr) {
        try {
            // Asumiendo que el formato es "Nombre, País" o solo "Nombre"
            String[] partes = ciudadStr.split(",");
            String nombreCiudad = partes[0].trim();
            String pais = partes.length > 1 ? partes[1].trim() : "Uruguay"; // País por defecto

            return ws.getCiudad(nombreCiudad, pais);
        } catch (Exception e) {
            System.err.println("Error al obtener ciudad: " + ciudadStr + " - " + e.getMessage());
            return null;
        }
    }

    // Auxiliar para obtener categorías disponibles
    private List<DtCategoria> getCategoriasDisponibles() {
        List<DtCategoria> dtCategorias = new ArrayList<>();
        try {
            dtCategorias = ws.listarCategorias();
        } catch (Exception e) {
            System.err.println("Error al obtener categorías: " + e.getMessage());
        }
        return dtCategorias;
    }
}