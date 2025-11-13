package uy.volando.servlets.Sesion;

import com.app.clases.Factory;
import com.app.clases.ISistema;
import com.app.datatypes.DtAerolinea;
import com.app.datatypes.DtCliente;
import com.app.datatypes.DtUsuario;
import com.app.enums.TipoDocumento;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.File;
import java.time.LocalDate;

@WebServlet (name = "RegistrarUsuarioFinal", urlPatterns = {"/register/final","/signup/final"})
public class RegistrarUsuarioFinalServlet extends HttpServlet {

    @Override
    protected void doGet(jakarta.servlet.http.HttpServletRequest request, HttpServletResponse response)
            throws jakarta.servlet.ServletException, java.io.IOException {

        request.getRequestDispatcher("/WEB-INF/jsp/signup/registrarUsuarioFinal.jsp").forward(request, response);
    }

    @Override
    protected void doPost(jakarta.servlet.http.HttpServletRequest request, HttpServletResponse response)
            throws jakarta.servlet.ServletException, java.io.IOException {

        response.setContentType("text/plain;charset=UTF-8");

        try {
            HttpSession session = request.getSession(false);
            if (session == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("No se ha iniciado el registro correctamente.");
                return;
            }

            String tipoUsuario = (String) session.getAttribute("tipoUsuario");
            DtUsuario dtUsuarioTemp = (DtUsuario) session.getAttribute("datosUsuario");
            if (tipoUsuario == null || dtUsuarioTemp == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Datos de registro incompletos.");
                return;
            }

            ISistema sistema = Factory.getSistema();

            String nickname = dtUsuarioTemp.getNickname();  // Para auto-login después

            if (tipoUsuario.equals("aerolinea")) {
                String descripcion = request.getParameter("descripcion");
                String urlSitioWeb = request.getParameter("pagina-web");

                if (descripcion == null || descripcion.trim().isEmpty()) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("Por favor, complete todos los campos obligatorios.");
                    return;  // <-- AGREGADO: Sale aquí
                }

                if (urlSitioWeb != null && !urlSitioWeb.trim().isEmpty()) {
                    if (!urlSitioWeb.startsWith("http://") && !urlSitioWeb.startsWith("https://")) {
                        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                        response.getWriter().write("La URL del sitio web debe comenzar con http:// o https://");
                        return;
                    }
                } else {
                    urlSitioWeb = "";  // Permite empty
                }

                sistema.registrarAerolinea(new DtAerolinea(dtUsuarioTemp.getNickname(), dtUsuarioTemp.getNombre(), dtUsuarioTemp.getEmail(),
                        dtUsuarioTemp.getPassword(), dtUsuarioTemp.getUrlImage(), descripcion, urlSitioWeb));

            } else {  // Asume "cliente"
                String apellido = request.getParameter("apellido");
                String fechaNacimiento = request.getParameter("fecha-nacimiento");
                String nacionalidad = request.getParameter("nacionalidad");
                String numeroDocumento = request.getParameter("numero-documento");
                String tipoDocumentoStr = request.getParameter("tipo-documento");

                // Chequeo early de empty
                if (apellido == null || apellido.trim().isEmpty() ||
                        fechaNacimiento == null || fechaNacimiento.trim().isEmpty() ||
                        nacionalidad == null || nacionalidad.trim().isEmpty() ||
                        numeroDocumento == null || numeroDocumento.trim().isEmpty() ||
                        tipoDocumentoStr == null || tipoDocumentoStr.trim().isEmpty()) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("Por favor, complete todos los campos obligatorios.");
                    return;
                }

                LocalDate fechaNac;
                try {
                    fechaNac = LocalDate.parse(fechaNacimiento);
                } catch (Exception e) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("El formato de la fecha de nacimiento es inválido.");
                    return;
                }

                int numDocumento;
                try {
                    numDocumento = Integer.parseInt(numeroDocumento);
                } catch (NumberFormatException e) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("El número de documento debe ser un valor numérico.");
                    return;
                }

                if (fechaNac.isAfter(LocalDate.now())) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("La fecha de nacimiento no puede ser en el futuro.");
                    return;
                }

                TipoDocumento tipoDocumento;
                try {
                    tipoDocumento = TipoDocumento.valueOf(tipoDocumentoStr);
                } catch (IllegalArgumentException e) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("Tipo de documento inválido.");
                    return;
                }

                sistema.registrarCliente(new DtCliente(dtUsuarioTemp.getNickname(), dtUsuarioTemp.getNombre(), dtUsuarioTemp.getEmail(),
                        dtUsuarioTemp.getPassword(), dtUsuarioTemp.getUrlImage(), apellido, fechaNac, nacionalidad, tipoDocumento, numDocumento));
            }

            // <-- NUEVO: Auto-login después de registrar
            // Recarga el usuario recién creado (ajusta si elegirUsuario usa email en vez de nick)
            DtUsuario usuario = sistema.getUsuario(nickname);

            // Crea nueva sesión y setea atributos (copia de LogInServlet)
            HttpSession newSession = request.getSession(true);
            newSession.setAttribute("usuarioNickname", usuario.getNickname());
            newSession.setAttribute("usuarioTipo", tipoUsuario);
            newSession.setAttribute("usuario", usuario);  // Para perfil JSP

            // Actualiza urlImage como en login (si hace falta)
            String basePath = request.getServletContext().getRealPath("/pictures/users");
            String contextPath = request.getContextPath();
            String urlImagen = usuario.getUrlImage();
            if (urlImagen == null || urlImagen.isEmpty() || !new File(basePath, urlImagen).exists()) {
                usuario.setUrlImage(contextPath + "/assets/userDefault.png");
            } else {
                usuario.setUrlImage(contextPath + "/pictures/users/" + urlImagen);
            }
            newSession.setAttribute("usuarioImagen", usuario.getUrlImage());


            // Limpia atributos temporales viejos (opcional)
            session.removeAttribute("datosUsuario");
            session.removeAttribute("tipoUsuario");
            session.invalidate();  // Borra la sesión temporal

            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write("Registro exitoso. Redirigiendo...");  // Mensaje para frontend

        } catch (Exception e) {
            e.printStackTrace();  // Log
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Error en registro: " + e.getMessage());
            // Opcional: request.setAttribute("errorMessage", e.getMessage()); request.getRequestDispatcher("/WEB-INF/jsp/signup/registrarUsuarioFinal.jsp").forward(request, response);
        }
    }
}
