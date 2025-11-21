package uy.volando.listeners;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import java.util.List;

import uy.volando.soap.ControladorWS;
import uy.volando.soap.WSConfig;
import uy.volando.soap.client.DtAerolinea;
import uy.volando.soap.client.VolandoServicePort;

@WebListener
public class AppStartupListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        try {
            WSConfig.init(sce.getServletContext());

            VolandoServicePort ws = ControladorWS.getPort();



            sce.getServletContext().setAttribute("categorias", ws.listarCategorias());

        } catch (Exception e) {
            System.err.println("¡Error al cargar los datos iniciales!");
            e.printStackTrace();
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
    }

}
