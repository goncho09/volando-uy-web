package uy.volando.servlets;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import uy.volando.soap.ControladorWS;
import uy.volando.soap.client.*;
import uy.volando.utils.ListaResultados;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

@WebServlet(name = "HomeServlet", urlPatterns = {"/home"})
public class HomeServlet extends HttpServlet {

    VolandoServicePort ws = ControladorWS.getPort();

    private String obtenerAerolineaDeRuta(DtRuta ruta) {
        try {
            List<DtAerolinea> aerolineas = ws.listarAerolineas();
            for (DtAerolinea a : aerolineas) {
                for (DtRuta r : a.getRutasDeVuelo()) {
                    if (r.getNombre().equals(ruta.getNombre())) {
                        return a.getNombre();
                    }
                }
            }
        } catch (Exception ignored) {}
        return null;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String userAgent = request.getHeader("User-Agent");

        boolean esMobile = userAgent != null && (
                userAgent.contains("Mobile") ||
                        userAgent.contains("Android") ||
                        userAgent.contains("iPhone") ||
                        userAgent.contains("iPad")
        );

        HttpSession session = request.getSession();
        session.setAttribute("esMobile", esMobile);

        try {

            String busqueda = request.getParameter("busqueda");
            String orden = request.getParameter("orden");
            String nombreFiltro = request.getParameter("nombre");
            String airline = request.getParameter("airline");

            List<ListaResultados> resultados = new ArrayList<>();

            String contextPath = request.getContextPath();


            if (busqueda != null && !busqueda.isEmpty()) {

                List<DtRuta> rutas = ws.buscarRutaDeVuelos(busqueda);
                List<DtPaquete> paquetes = ws.buscarPaquetes(busqueda);

                rutas.removeIf(r -> r.getEstado() != EstadoRuta.APROBADA);

                if (airline != null && !airline.isEmpty()) {
                    rutas.removeIf(r -> {
                        String nomAerolinea = obtenerAerolineaDeRuta(r);
                        return nomAerolinea == null || !nomAerolinea.equals(airline);
                    });
                }

                for (DtPaquete p : paquetes) {
                    List<DtRutaEnPaquete> rutasPaquete = p.getRutaEnPaquete();
                    rutasPaquete.removeIf(rp -> rp.getRutaDeVuelo().getEstado() != EstadoRuta.APROBADA);
                    if (nombreFiltro != null && !nombreFiltro.isEmpty()) {
                        rutasPaquete.removeIf(rp -> !ws.rutaContieneCategoria(rp.getRutaDeVuelo(), nombreFiltro));
                    }
                }

                paquetes.removeIf(p -> p.getRutaEnPaquete() == null || p.getRutaEnPaquete().isEmpty());
                paquetes.removeIf(ws::estaPaqueteComprado);

                if (airline != null && !airline.isEmpty()) {
                    paquetes.removeIf(p ->
                            p.getRutaEnPaquete().stream()
                                    .map(DtRutaEnPaquete::getRutaDeVuelo)
                                    .noneMatch(r -> airline.equals(obtenerAerolineaDeRuta(r)))
                    );
                }

                if (rutas != null && !rutas.isEmpty()) {
                    for (DtRuta ruta : rutas) {

                        String urlImagen = ruta.getUrlImagen();
                        boolean invalida = (urlImagen == null || urlImagen.isEmpty());

                        if (invalida) {
                            ruta.setUrlImagen(contextPath + "/assets/rutaDefault.png");
                        } else {
                            ruta.setUrlImagen(contextPath + "/imagen?nombre=" + urlImagen + "&tipo=Ruta");
                        }

                        resultados.add(new ListaResultados(
                                ruta.getNombre(),
                                "Ruta",
                                ruta
                        ));
                    }
                }

                if (paquetes != null && !paquetes.isEmpty()) {
                    for (DtPaquete paquete : paquetes) {
                        resultados.add(new ListaResultados(
                                paquete.getNombre(),
                                "Paquete",
                                paquete
                        ));
                    }
                }
                request.setAttribute("esHome", false);
            } else {
                request.getSession().setAttribute("usuario", null);

                List<DtRuta> listaRuta = ws.listarRutasDeVuelo();
                List<DtPaquete> listaPaquete = ws.listarPaquetesNoComprados();

                listaRuta.removeIf(r -> r.getEstado() != EstadoRuta.APROBADA);

                if (airline != null && !airline.isEmpty()) {
                    listaRuta.removeIf(r -> {
                        String nomAerolinea = obtenerAerolineaDeRuta(r);
                        return nomAerolinea == null || !nomAerolinea.equals(airline);
                    });
                }

                for (DtPaquete p : listaPaquete) {
                    List<DtRutaEnPaquete> rutasPaquete = p.getRutaEnPaquete();
                    rutasPaquete.removeIf(rp -> rp.getRutaDeVuelo().getEstado() != EstadoRuta.APROBADA);

                    if (nombreFiltro != null && !nombreFiltro.isEmpty()) {
                        rutasPaquete.removeIf(rp -> !ws.rutaContieneCategoria(rp.getRutaDeVuelo(), nombreFiltro));
                    }
                }

                listaPaquete.removeIf(p -> p.getRutaEnPaquete() == null || p.getRutaEnPaquete().isEmpty());

                if (airline != null && !airline.isEmpty()) {
                    listaPaquete.removeIf(p ->
                            p.getRutaEnPaquete().stream()
                                    .map(DtRutaEnPaquete::getRutaDeVuelo)
                                    .noneMatch(r -> airline.equals(obtenerAerolineaDeRuta(r)))
                    );
                }

                for (DtRuta r : listaRuta) {
                    String urlImagen = r.getUrlImagen();
                    boolean invalida = (urlImagen == null || urlImagen.isEmpty());

                    if (invalida) {
                        r.setUrlImagen(contextPath + "/assets/rutaDefault.png");
                    } else {
                        r.setUrlImagen(contextPath + "/imagen?nombre=" + urlImagen + "&tipo=Ruta");
                    }
                }

                resultados = Stream.concat(
                                listaRuta.stream().map(r -> new ListaResultados(
                                        r.getNombre(),
                                        "Ruta",
                                        r
                                )),
                                listaPaquete.stream().map(p -> new ListaResultados(
                                        p.getNombre(),
                                        "Paquete",
                                        p
                                ))
                        )
                        .sorted(Comparator.comparing(o -> o.nombre.toLowerCase()))
                        .collect(Collectors.toList());

                request.setAttribute("esHome", true);
            }

            Comparator<ListaResultados> comparator = Comparator.comparing(o -> o.nombre.toLowerCase());

            if ("desc".equals(orden)) {
                comparator = comparator.reversed();
            }

            resultados.sort(comparator);

            request.setAttribute("resultados", resultados);

            List<String> aerolineas = ws.listarAerolineas()
                    .stream()
                    .map(DtAerolinea::getNombre)
                    .collect(Collectors.toList());

            request.setAttribute("listaAerolineas", aerolineas);


            request.getRequestDispatcher("/WEB-INF/jsp/home.jsp").forward(request, response);


        } catch (Exception e) {
            System.out.println(e.getMessage());
            request.setAttribute("error", "Error al cargar la página de inicio.");
            request.getRequestDispatcher("/WEB-INF/jsp/error.jsp").forward(request, response);
        }
    }
}
