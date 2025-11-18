package uy.volando.servlets.Paquete;

import uy.volando.soap.ControladorWS;
import uy.volando.soap.client.DtPaquete;
import uy.volando.soap.client.DtRuta;
import uy.volando.soap.client.DtRutaEnPaquete;
import uy.volando.soap.client.VolandoServicePort;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet (name = "ConsultarPaqueteServlet", urlPatterns = {"/paquete/consulta"})
public class ConsultarPaqueteServlet extends HttpServlet {

    VolandoServicePort ws = ControladorWS.getPort();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try{
            String nombre = request.getParameter("nombre");

            DtPaquete paquete = ws.getPaquete(nombre);

            if (paquete == null) {request.getRequestDispatcher("/WEB-INF/jsp/error.jsp").forward(request, response);}

            List<DtRutaEnPaquete> rutaEnPaqueteList = paquete.getRutaEnPaquete();

            if(rutaEnPaqueteList == null || rutaEnPaqueteList.isEmpty()){request.getRequestDispatcher("/WEB-INF/jsp/error.jsp").forward(request, response);}

            String basePath = getServletContext().getRealPath("/pictures/rutas");
            String contextPath = request.getContextPath();

            for (DtRutaEnPaquete rp : rutaEnPaqueteList) {
                DtRuta rutaPaquete = rp.getRutaDeVuelo();
                String urlImagen = rutaPaquete.getUrlImagen();
                File rutaImg = null;

                if (urlImagen != null && !urlImagen.isEmpty()) {
                    rutaImg = new File(basePath, urlImagen);
                }

                if (urlImagen == null || urlImagen.isEmpty() || !rutaImg.exists()) {
                    rutaPaquete.setUrlImagen(contextPath + "/assets/rutaDefault.png");
                } else {
                    rutaPaquete.setUrlImagen(contextPath + "/pictures/rutas/" + urlImagen);
                }
            }

            boolean comprado = ws.estaPaqueteComprado(paquete);

            request.setAttribute("paquete", paquete);
            request.setAttribute("comprado", comprado);

            request.getRequestDispatcher("/WEB-INF/jsp/paquete/consulta.jsp").forward(request, response);
        } catch (Exception ex) {
            System.out.println("error: " + ex.getMessage());
            request.setAttribute("error", ex.getMessage());
            request.getRequestDispatcher("/WEB-INF/jsp/error.jsp").forward(request, response);
        }
    }
}

