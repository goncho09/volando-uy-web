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

        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("usuarioNickname") != null) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        request.getRequestDispatcher("/WEB-INF/jsp/login/login.jsp").forward(request, response);

    }



    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        try {
            String name = request.getParameter("name");
            String password = request.getParameter("password");

            System.out.println("1");

            System.out.println("nombre " + name + " pass " + password);
            System.out.println("valida " + ws.validarUsuario(name, password));
            if (ws.validarUsuario(name, password)) {
                System.out.println("1.5");
                DtUsuario usuario = ws.getUsuario(name);
                System.out.println("1.8");
                // Crea sesión aquí, solo si válido
                HttpSession session = request.getSession(true);

                System.out.println("2");

                session.setAttribute("usuarioNickname", usuario.getNickname());

                String basePath = getServletContext().getRealPath("/pictures/users");
                String contextPath = request.getContextPath();

                String urlImagen = usuario.getUrlImage();
                File userImg = null;

                System.out.println("3");

                if (urlImagen != null && !urlImagen.isEmpty()) {
                    userImg = new File(basePath, urlImagen);
                }

                if (urlImagen == null || urlImagen.isEmpty() || !userImg.exists()) {
                    usuario.setUrlImage(contextPath + "/assets/userDefault.png");
                } else {
                    usuario.setUrlImage(contextPath + "/pictures/users/" + urlImagen);
                }
                System.out.println("4");

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

                System.out.println("5");

                session.setAttribute("usuario", usuario);

                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write("OK");
            } else {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.getWriter().write("Nombre de usuario o contraseña incorrectos");
                request.setAttribute("error", "Nombre de usuario o contraseña incorrectos");
            }

        } catch (Exception ex) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Error al iniciar sesión. Inténtelo de nuevo más tarde.");
            System.out.println(">>> LogIn doPost: Excepción = " + ex.getMessage());  // Debug
        }
    }
}