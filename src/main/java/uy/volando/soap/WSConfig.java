package uy.volando.soap;

import javax.servlet.ServletContext;

public class WSConfig {

    private static String wsUrl;

    public static void init(ServletContext ctx) {
        wsUrl = ctx.getInitParameter("ws.url");
        if (wsUrl == null) {
            throw new RuntimeException("No está configurado ws.url en web.xml");
        }
    }

    public static String getServiceURL() {
        return wsUrl;
    }
}