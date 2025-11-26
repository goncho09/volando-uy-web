package uy.volando.soap;

import uy.volando.soap.VolandoConfig;

import javax.servlet.ServletContext;

public class WSConfig {

    private static String wsUrl;

    public static void init(ServletContext ctx) {
        String ip = VolandoConfig.get("soap.ip");
        String port = VolandoConfig.get("soap.port");
        String path = VolandoConfig.get("soap.path");

        if (ip == null || port == null || path == null) {
            throw new RuntimeException("No están configuradas todas las propiedades SOAP en app.config");
        }

        wsUrl = "http://" + ip + ":" + port + path;
    }

    public static String getServiceURL() {
        if (wsUrl == null) {
            throw new IllegalStateException("WSConfig no fue inicializado");
        }
        return wsUrl;
    }
}
