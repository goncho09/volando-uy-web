package uy.volando.servlets.Sesion;






import uy.volando.soap.ControladorWS;
import uy.volando.soap.client.DtAerolinea;
import uy.volando.soap.client.DtCliente;
import uy.volando.soap.client.DtUsuario;
import uy.volando.soap.client.VolandoServicePort;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.File;
import java.io.IOException;



@WebServlet (name = "LogInServlet", urlPatterns = {"/login","/signin"})
public class LogInServlet extends HttpServlet {
    VolandoServicePort ws = ControladorWS.getPort();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("usuarioNickname") != null) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        request.getRequestDispatcher("/WEB-INF/jsp/login/login.jsp").forward(request, response);

    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String name = request.getParameter("name");
            String password = request.getParameter("password");

            if (ws.validarUsuario(name, password)) {
                DtUsuario usuario = ws.getUsuario(name);

                // Crea sesión aquí, solo si válido
                HttpSession session = request.getSession(true);

                session.setAttribute("usuarioNickname", usuario.getNickname());

                String basePath = getServletContext().getRealPath("/pictures/users");
                String contextPath = request.getContextPath();

                String urlImagen = usuario.getUrlImage();
                File userImg = null;

                if (urlImagen != null && !urlImagen.isEmpty()) {
                    userImg = new File(basePath, urlImagen);
                }

                if (urlImagen == null || urlImagen.isEmpty() || !userImg.exists()) {
                    usuario.setUrlImage(contextPath + "/assets/userDefault.png");
                } else {
                    usuario.setUrlImage(contextPath + "/pictures/users/" + urlImagen);
                }


                session.setAttribute("usuarioImagen", usuario.getUrlImage());

                if (usuario instanceof DtCliente) {
                    session.setAttribute("usuarioTipo", "cliente");
                } else if (usuario instanceof DtAerolinea) {
                    session.setAttribute("usuarioTipo", "aerolinea");
                } else {
                    session.invalidate();  // Safe check
                    request.setAttribute("error", "Ha ocurrido un error.");
                    request.getRequestDispatcher("/WEB-INF/jsp/login/login.jsp").forward(request, response);
                    return;
                }

                session.setAttribute("usuario", usuario);

                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write("OK");
            } else {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.getWriter().write("Nombre de usuario o contraseña incorrectos");
                request.setAttribute("error", "Nombre de usuario o contraseña incorrectos");
            }

        } catch (Exception ex) {
            request.setAttribute("error", "Error en el servidor");
            System.out.println(">>> LogIn doPost: Excepción = " + ex.getMessage());  // Debug
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}