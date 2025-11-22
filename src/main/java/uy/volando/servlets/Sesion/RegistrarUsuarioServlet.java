package uy.volando.servlets.Sesion;

import uy.volando.soap.ControladorWS;
import uy.volando.soap.client.DtUsuario;
import uy.volando.soap.client.TipoImagen;
import uy.volando.soap.client.VolandoServicePort;

import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import java.io.ByteArrayOutputStream;
import java.io.InputStream;

@MultipartConfig
@WebServlet(name = "RegistrarUsuario", urlPatterns = {"/register","/signup","/registrar"})
public class RegistrarUsuarioServlet extends HttpServlet {

    @Override
    protected void doGet(javax.servlet.http.HttpServletRequest request, HttpServletResponse response)
            throws javax.servlet.ServletException, java.io.IOException {

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

        request.getRequestDispatcher("/WEB-INF/jsp/signup/registrarUsuario.jsp").forward(request, response);
    }

    @Override
    protected void doPost(javax.servlet.http.HttpServletRequest request, HttpServletResponse response)
            throws javax.servlet.ServletException, java.io.IOException {


        Boolean esMobile = (Boolean) request.getSession(false).getAttribute("esMobile");

        if (esMobile) {
            request.setAttribute("error", "Acceso no autorizado desde dispositivos móviles.");
            request.getRequestDispatcher("/WEB-INF/jsp/401.jsp").forward(request, response);
            return;
        }

        response.setContentType("text/plain;charset=UTF-8");

        try {
            VolandoServicePort ws = ControladorWS.getPort();

            String nickname = request.getParameter("nickname");
            if (nickname == null || nickname.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Nickname requerido.");
                return;
            }

            if (ws.existeUsuario(nickname)) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Ya existe un usuario con ese nickname.");
                return;
            }

            String email = request.getParameter("email");
            if (email == null || email.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Email requerido.");
                return;
            }
            if (ws.existeUsuarioEmail(email)) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Ya existe un usuario con ese email.");
                return;
            }

            String password = request.getParameter("password");
            String confirmPassword = request.getParameter("confirm-password");
            if (!password.equals(confirmPassword)) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Las contraseñas no coinciden.");
                return;
            }

            Part filePart = request.getPart("image");
            String nombre = request.getParameter("name");
            String tipoUsuario = request.getParameter("role");

            if (nombre == null || nombre.trim().isEmpty() || tipoUsuario == null || tipoUsuario.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Nombre y tipo de usuario requeridos.");
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

            String fotoPerfil = ws.guardarImagen(data, TipoImagen.USUARIO);


            HttpSession session = request.getSession(true);

            DtUsuario datosUsuario = new DtUsuario();

            datosUsuario.setNickname(nickname);
            datosUsuario.setNombre(nombre);
            datosUsuario.setEmail(email);
            datosUsuario.setPassword(password);
            datosUsuario.setUrlImage(fotoPerfil);
            datosUsuario.getSeguidos();
            datosUsuario.getSeguidores();

            session.setAttribute("datosUsuario", datosUsuario);
            session.setAttribute("tipoUsuario", tipoUsuario);

            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write("Datos iniciales guardados. Continúe al siguiente paso.");

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Error: " + e.getMessage());
            // Opcional: request.setAttribute("errorMessage", e.getMessage()); request.getRequestDispatcher("/WEB-INF/jsp/signup/registrarUsuario.jsp").forward(request, response);
        }
    }
}

