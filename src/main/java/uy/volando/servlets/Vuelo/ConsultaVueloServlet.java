package uy.volando.servlets.Vuelo;

import uy.volando.soap.ControladorWS;
import uy.volando.soap.client.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.File;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "ConsultaVueloServlet", urlPatterns = {"/vuelo/consulta"})
public class ConsultaVueloServlet extends HttpServlet {
    VolandoServicePort ws = ControladorWS.getPort();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String idVuelo = request.getParameter("nombre");

            DtVuelo vuelo = ws.getVuelo(idVuelo);
            DtRuta ruta = vuelo.getRutaDeVuelo();

            String contextPath = request.getContextPath();

            String urlImagen = vuelo.getUrlImage();
            boolean invalida = (urlImagen == null || urlImagen.isEmpty());

            if (invalida) {
                vuelo.setUrlImage(contextPath + "/assets/rutaDefault.png");
            } else {
                vuelo.setUrlImage(contextPath + "/imagen?nombre=" + urlImagen + "&tipo=Vuelo");
            }

            request.setAttribute("ruta", ruta);
            request.setAttribute("vuelo", vuelo);

            HttpSession session = request.getSession(false);

            if(session.getAttribute("usuarioNickname") != null && session.getAttribute("usuarioTipo") != null) {
                String tipo = session.getAttribute("usuarioTipo").toString();
                if(tipo.equals("aerolinea")) {
                    DtAerolinea aerolineaObj = ws.getAerolinea(session.getAttribute("usuarioNickname").toString());
                    for (DtRuta r : aerolineaObj.getRutasDeVuelo()) {
                        if (r.getNombre().equals(ruta.getNombre())) {
                            request.setAttribute("esDeLaAerolinea", true);
                            break;
                        }
                    }
                }else{
                    DtCliente cliente = ws.getCliente(session.getAttribute("usuarioNickname").toString());
                    List<DtReserva> reservas = ws.listarReservasClienteVuelo(cliente,vuelo);
                    if(!reservas.isEmpty()) {
                        request.setAttribute("tieneReserva", true);
                    }
                }

            }
            request.getRequestDispatcher("/WEB-INF/jsp/vuelo/consulta.jsp").forward(request, response);

        } catch (Exception ex) {
            request.setAttribute("error", "Error al cargar la consulta de vuelos");
            request.getRequestDispatcher("/WEB-INF/jsp/vuelo/buscar.jsp").forward(request, response);
            System.err.println("Error al obtener parametros: " + ex.getMessage());
        }
    }
}