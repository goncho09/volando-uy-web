package uy.volando.soap;

import uy.volando.soap.client.VolandoServicePort;
import uy.volando.soap.client.VolandoService;

import javax.xml.namespace.QName;
import java.net.URL;
import uy.volando.soap.WSConfig;

public class ControladorWS {

    private static volatile VolandoServicePort port;

    public static VolandoServicePort getPort() {
        if (port == null) {
            synchronized (ControladorWS.class) {
                if (port == null) {
                    try{
                        String wsdl = WSConfig.getServiceURL();
                        if (wsdl == null) {
                            throw new IllegalStateException("WS URL no inicializada");
                        }

                        VolandoService service = new VolandoService(
                                new URL(wsdl),
                                new QName("http://soap.app.com/", "VolandoService")
                        );

                        port = service.getVolandoPort();
                    } catch (Exception e) {
                        throw new RuntimeException("No se pudo inicializar el cliente SOAP", e);
                    }
                }
            }
        }
        return port;
    }
}

