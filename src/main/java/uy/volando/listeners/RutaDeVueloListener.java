package uy.volando.listeners;

import uy.volando.soap.ControladorWS;
import uy.volando.soap.client.VolandoServicePort;

import javax.servlet.ServletRequest;
import javax.servlet.ServletRequestEvent;
import javax.servlet.ServletRequestListener;
import javax.servlet.annotation.WebListener;
import javax.servlet.http.HttpServletRequest;

@WebListener
public class RutaDeVueloListener implements ServletRequestListener {

    @Override
    public void requestInitialized(ServletRequestEvent sre) {
        ServletRequest req = sre.getServletRequest();
        VolandoServicePort ws = ControladorWS.getPort();

        if (req instanceof HttpServletRequest) {
            HttpServletRequest http = (HttpServletRequest) req;
            String uri = http.getRequestURI();
            if (uri != null && uri.contains("ruta-de-vuelo/buscar")) {
                String nombre = http.getParameter("nombre");
                if ((nombre == null || nombre.isEmpty()) && http.getAttribute("nombre") instanceof String) {
                    nombre = (String) http.getAttribute("nombre");
                }
                if (nombre != null && !nombre.isEmpty()) {
                    ws.aumentarVisita(nombre);
                }
            }
        }
    }

    @Override
    public void requestDestroyed(ServletRequestEvent sre) {}
}

