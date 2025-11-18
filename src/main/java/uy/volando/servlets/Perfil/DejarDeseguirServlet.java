package uy.volando.servlets.Perfil;

import uy.volando.soap.ControladorWS;
import uy.volando.soap.client.VolandoServicePort;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "DejarDeseguirServlet", urlPatterns = {"/dejar-de-seguir","/unfollow"})
public class DejarDeseguirServlet extends HttpServlet {
    VolandoServicePort ws = ControladorWS.getPort();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("usuarioNickname") == null || session.getAttribute("usuarioTipo") == null) {
            request.getRequestDispatcher("/WEB-INF/jsp/401.jsp").forward(request, response);
            return;
        }

        try {
            String nicknameSeguir = request.getParameter("nickname");
            String nickname = (String) session.getAttribute("usuarioNickname");
            ws.dejarDeSeguirUsuario(nickname,nicknameSeguir);

            response.sendRedirect(request.getContextPath() + "/perfil?nickname=" + nicknameSeguir);
        } catch (Exception e) {
            request.setAttribute("error", "Error al dejar de seguir el usuario.");
            System.out.println(e.getMessage());
            request.getRequestDispatcher("/WEB-INF/jsp/error.jsp").forward(request, response);
        }
    }
}
