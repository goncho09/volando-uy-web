package uy.volando.servlets.Sesion;

import com.app.clases.Factory;
import com.app.clases.ISistema;
import com.app.datatypes.DtUsuario;
import com.app.enums.TipoImagen;
import com.app.utils.AuxiliarFunctions;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;

@MultipartConfig
@WebServlet(name = "RegistrarUsuario", urlPatterns = {"/register","/signup","/registrar"})
public class RegistrarUsuarioServlet extends HttpServlet {

    @Override
    protected void doGet(jakarta.servlet.http.HttpServletRequest request, HttpServletResponse response)
            throws jakarta.servlet.ServletException, java.io.IOException {

        request.getRequestDispatcher("/WEB-INF/jsp/signup/registrarUsuario.jsp").forward(request, response);
    }

    @Override
    protected void doPost(jakarta.servlet.http.HttpServletRequest request, HttpServletResponse response)
            throws jakarta.servlet.ServletException, java.io.IOException {

        response.setContentType("text/plain;charset=UTF-8");

        try {
            ISistema sistema = Factory.getSistema();

            String nickname = request.getParameter("nickname");
            if (nickname == null || nickname.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Nickname requerido.");
                return;
            }

            if (sistema.existeUsuario(nickname)) {
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
            if (sistema.existeUsuarioEmail(email)) {
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

            // Crear archivo temporal
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            File tempFile = File.createTempFile("upload-", "-" + fileName);

            try (InputStream input = filePart.getInputStream()) {
                Files.copy(input, tempFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
            }

            File imagenGuardada = AuxiliarFunctions.guardarImagen(tempFile, TipoImagen.USUARIO);

            String fotoPerfil = imagenGuardada.getName();

            HttpSession session = request.getSession(true);
            session.setAttribute("datosUsuario", new DtUsuario(nickname,nombre, email, password, fotoPerfil,new ArrayList<>(), new ArrayList<>()));
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

