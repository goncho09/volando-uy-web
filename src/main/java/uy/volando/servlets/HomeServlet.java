package uy.volando.servlets;

import com.app.clases.Factory;
import com.app.clases.ISistema;
import com.app.clases.RutaEnPaquete;
import com.app.datatypes.DtPaquete;
import com.app.datatypes.DtRuta;
import com.app.datatypes.DtRutaEnPaquete;
import com.app.enums.EstadoRuta;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.File;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "HomeServlet", urlPatterns = {"/home"})
public class HomeServlet extends HttpServlet {

    ISistema s = Factory.getSistema();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {

            String busqueda = request.getParameter("busqueda");

            if (busqueda != null && !busqueda.isEmpty()) {

                if (s.existeRuta(busqueda)) {
                    DtRuta ruta = s.getRutaDeVuelo(busqueda);
                    String basePath = request.getServletContext().getRealPath("/pictures/rutas");
                    String contextPath = request.getContextPath();

                    String urlImagen = ruta.getUrlImagen();
                    File rutaImg = null;

                    if (urlImagen != null && !urlImagen.isEmpty()) {
                        rutaImg = new File(basePath, urlImagen);
                    }

                    if (urlImagen == null || urlImagen.isEmpty() || !rutaImg.exists()) {
                        ruta.setUrlImagen(contextPath + "/assets/rutaDefault.png");
                    } else {
                        ruta.setUrlImagen(contextPath + "/pictures/rutas/" + urlImagen);
                    }
                    request.setAttribute("ruta", ruta);

                }

                if (s.existePaquete(busqueda)) {
                    DtPaquete paquete = s.getPaquete(busqueda);
                    request.setAttribute("paquete", paquete);
                }
            } else {
                request.getSession().setAttribute("usuario", null);

                List<DtRuta> listaRuta = s.listarRutasDeVuelo();
                List<DtPaquete> listaPaquete = s.listarPaquetesNoComprados();

                listaRuta.removeIf(ruta -> ruta.getEstado() != EstadoRuta.APROBADA);

                for(DtPaquete p : listaPaquete){
                    List<DtRutaEnPaquete> listaRutasPaquete = p.getRutaEnPaquete();
                    listaRutasPaquete.removeIf(rutaEnPaquete -> rutaEnPaquete.getRutaDeVuelo().getEstado() != EstadoRuta.APROBADA);
                }

                listaPaquete.removeIf(paquete -> paquete.getRutaEnPaquete() == null || paquete.getRutaEnPaquete().isEmpty());

                if(request.getParameter("nombre") != null && !request.getParameter("nombre").isEmpty()){
                    listaRuta.removeIf(ruta -> !s.rutaContieneCategoria(ruta, request.getParameter("nombre")));
                }

                for (DtRuta ruta : listaRuta) {
                    String basePath = request.getServletContext().getRealPath("/pictures/rutas");
                    String contextPath = request.getContextPath();

                    String urlImagen = ruta.getUrlImagen();
                    File rutaImg = null;

                    if (urlImagen != null && !urlImagen.isEmpty()) {
                        rutaImg = new File(basePath, urlImagen);
                    }

                    if (urlImagen == null || urlImagen.isEmpty() || !rutaImg.exists()) {
                        ruta.setUrlImagen(contextPath + "/assets/rutaDefault.png");
                    } else {
                        ruta.setUrlImagen(contextPath + "/pictures/rutas/" + urlImagen);
                    }
                }

                request.setAttribute("rutas", listaRuta);
                request.setAttribute("paquetes", listaPaquete);
            }

            // Forward to JSP page
            request.getRequestDispatcher("/WEB-INF/jsp/home.jsp").forward(request, response);

        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "An error occurred while processing your request.");
            System.out.println(e.getMessage());
            request.getRequestDispatcher("/WEB-INF/jsp/error.jsp").forward(request, response);
        }
    }
}
