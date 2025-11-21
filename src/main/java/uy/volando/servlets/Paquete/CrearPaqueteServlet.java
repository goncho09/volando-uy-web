package uy.volando.servlets.Paquete;




import uy.volando.soap.ControladorWS;
import uy.volando.soap.client.DtPaquete;
import uy.volando.soap.client.VolandoServicePort;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet (name = "CrearPaqueteServlet", urlPatterns = {"/paquete/crear"})
public class CrearPaqueteServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
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

        HttpSession session = request.getSession(false);

        if (session == null) {
            request.getRequestDispatcher("/WEB-INF/jsp/401.jsp").forward(request, response);
            return;
        }

        if(session.getAttribute("usuarioTipo") == null || session.getAttribute("usuarioNickname") == null ){
            request.getRequestDispatcher("/WEB-INF/jsp/401.jsp").forward(request, response);
            return;
        }

        if(!session.getAttribute("usuarioTipo").equals("aerolinea")){
            request.getRequestDispatcher("/WEB-INF/jsp/401.jsp").forward(request, response);
            return;
        }

        request.getRequestDispatcher("/WEB-INF/jsp/paquete/crear.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Boolean esMobile = (Boolean) request.getSession(false).getAttribute("esMobile");

        if (esMobile) {
            request.setAttribute("error", "Acceso no autorizado desde dispositivos móviles.");
            request.getRequestDispatcher("/WEB-INF/jsp/401.jsp").forward(request, response);
            return;
        }

        try {
            VolandoServicePort ws = ControladorWS.getPort();

            String nombre = request.getParameter("nombre");
            String descripcion = request.getParameter("descripcion");
            String validezStr = request.getParameter("validez");
            String descuentoStr = request.getParameter("descuento");

            if (nombre == null || descripcion == null || validezStr == null || descuentoStr == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Faltan campos obligatorios");
                return;
            }

            if (ws.existePaquete(nombre)) {
                response.setStatus(HttpServletResponse.SC_CONFLICT);
                response.getWriter().write("Ya existe un paquete con ese nombre");
                return;
            }

            int validezDias = Integer.parseInt(validezStr);
            int descuento = Integer.parseInt(descuentoStr);


            if (descripcion.isEmpty() || validezDias <= 0 || descuento < 0 || descuento > 100) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Datos inválidos. Por favor, verifique e intente nuevamente.");
                return;
            }

            DtPaquete paquete = new DtPaquete();

            paquete.setNombre(nombre);
            paquete.setDescripcion(descripcion);
            paquete.setValidezDias(validezDias);
            paquete.setDescuento(descuento);

            ws.altaPaquete(paquete);

            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write("Paquete creado con éxito");

        } catch (Exception ex) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Error del servidor: " + ex.getMessage());
        }


    }

}
