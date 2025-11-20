package uy.volando.servlets;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import uy.volando.soap.ControladorWS;
import uy.volando.soap.client.*;

import java.io.File;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "HomeServlet", urlPatterns = {"/home"})
public class HomeServlet extends HttpServlet {

    VolandoServicePort ws = ControladorWS.getPort();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {

            String busqueda = request.getParameter("busqueda");

            if (busqueda != null && !busqueda.isEmpty()) {

                if (ws.existeRuta(busqueda)) {
                    DtRuta ruta = ws.getRutaDeVuelo(busqueda);
                    String basePath = getServletContext().getRealPath("/pictures/rutas");
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

                if (ws.existePaquete(busqueda)) {
                    DtPaquete paquete = ws.getPaquete(busqueda);
                    request.setAttribute("paquete", paquete);
                }
            } else {
                request.getSession().setAttribute("usuario", null);

                List<DtRuta> listaRuta = ws.listarRutasDeVuelo();
                List<DtPaquete> listaPaquete = ws.listarPaquetesNoComprados();

                listaRuta.removeIf(ruta -> ruta.getEstado() != EstadoRuta.APROBADA);

                for(DtPaquete p : listaPaquete){
                    List<DtRutaEnPaquete> listaRutasPaquete = p.getRutaEnPaquete();
                    listaRutasPaquete.removeIf(rutaEnPaquete -> rutaEnPaquete.getRutaDeVuelo().getEstado() != EstadoRuta.APROBADA);
                }

                listaPaquete.removeIf(paquete -> paquete.getRutaEnPaquete() == null || paquete.getRutaEnPaquete().isEmpty());

                if(request.getParameter("nombre") != null && !request.getParameter("nombre").isEmpty()){
                    listaRuta.removeIf(ruta -> !ws.rutaContieneCategoria(ruta, request.getParameter("nombre")));
                }

                for (DtRuta ruta : listaRuta) {
                    String basePath = getServletContext().getRealPath("/pictures/rutas");
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
            System.out.println(e.getMessage());
            request.setAttribute("error", "Error al cargar la página de inicio.");
            request.getRequestDispatcher("/WEB-INF/jsp/error.jsp").forward(request, response);

        }
    }
}
