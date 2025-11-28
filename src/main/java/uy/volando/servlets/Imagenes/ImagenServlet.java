package uy.volando.servlets.Imagenes;

import uy.volando.soap.ControladorWS;
import uy.volando.soap.client.TipoImagen;
import uy.volando.soap.client.VolandoServicePort;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "imagenServlet", urlPatterns = {"/imagen"})
public class ImagenServlet extends HttpServlet {

    VolandoServicePort ws = ControladorWS.getPort();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        String nombre = req.getParameter("nombre");
        String tipo = req.getParameter("tipo");
        TipoImagen tipoEnum = null;

        if (nombre == null) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        TipoImagen tipoImagen = null;

        if (tipo != null) {
            switch (tipo) {
                case "User":
                    tipoImagen = TipoImagen.USUARIO;
                    break;

                case "Ruta":
                    tipoImagen = TipoImagen.RUTA;
                    break;

                case "Vuelo":
                    tipoImagen = TipoImagen.VUELO;
                    break;

                default:
                    resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
                    return;
            }
        } else {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        byte[] data = ws.obtenerImagen(nombre, tipoImagen);

        resp.setContentLength(data.length);
        resp.getOutputStream().write(data);
    }
}
