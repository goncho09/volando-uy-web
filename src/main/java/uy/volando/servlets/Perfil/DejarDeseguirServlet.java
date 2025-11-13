package uy.volando.servlets.Perfil;

import com.app.clases.Factory;
import com.app.clases.ISistema;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "DejarDeseguirServlet", urlPatterns = {"/dejar-de-seguir","/unfollow"})
public class DejarDeseguirServlet extends HttpServlet {
    ISistema sistema = Factory.getSistema();

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
            sistema.dejarDeSeguirUsuario(nickname,nicknameSeguir);

            response.sendRedirect(request.getContextPath() + "/perfil?nickname=" + nicknameSeguir);
        } catch (Exception e) {
            request.setAttribute("error", "Error al dejar de seguir el usuario.");
            System.out.println(e.getMessage());
            request.getRequestDispatcher("/WEB-INF/jsp/error.jsp").forward(request, response);
        }
    }
}
