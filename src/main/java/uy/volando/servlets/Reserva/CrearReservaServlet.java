package uy.volando.servlets.Reserva;










import com.sun.xml.ws.fault.ServerSOAPFaultException;
import uy.volando.soap.ControladorWS;
import uy.volando.soap.client.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "Crear", urlPatterns = {"/reservas/crear"})

public class CrearReservaServlet extends HttpServlet {

    VolandoServicePort ws = ControladorWS.getPort();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        HttpSession session = request.getSession(false);

        Boolean esMobile = (Boolean) session.getAttribute("esMobile");

        if (esMobile) {
            request.setAttribute("error", "Acceso no autorizado desde dispositivos móviles.");
            request.getRequestDispatcher("/WEB-INF/jsp/401.jsp").forward(request, response);
            return;
        }

        if (session.getAttribute("usuarioTipo") == null || session.getAttribute("usuarioNickname") == null) {
            request.getRequestDispatcher("/WEB-INF/jsp/401.jsp").forward(request, response);
            return;
        }

        if (!session.getAttribute("usuarioTipo").equals("cliente")) {
            request.getRequestDispatcher("/WEB-INF/jsp/401.jsp").forward(request, response);
            return;
        }

        try {
            String nicknameCliente = (String) session.getAttribute("usuarioNickname");
            DtCliente cliente = ws.getCliente(nicknameCliente);

            String idAerolinea = request.getParameter("aerolinea");
            String idRuta = request.getParameter("ruta");

            List<DtAerolinea> aerolineas = ws.listarAerolineas();

            aerolineas.removeIf(aerolinea -> {
                List<DtRuta> rutas = aerolinea.getRutasDeVuelo();
                if (rutas == null || rutas.isEmpty()) {
                    return true;
                }
                for (DtRuta ruta : rutas) {
                    if (ruta.getEstado() == EstadoRuta.APROBADA) {
                        List<DtVuelo> vuelos = ws.listarVuelosRuta(ruta.getNombre());
                        if (vuelos != null && !vuelos.isEmpty()) {
                            return false;
                        }
                    }
                }

                return true;
            });

            request.setAttribute("aerolineas", aerolineas);

            if (idAerolinea != null) {
                DtAerolinea aerolinea = ws.getAerolinea(idAerolinea);
                List<DtRuta> rutasAerolinea = aerolinea.getRutasDeVuelo();

                rutasAerolinea.removeIf(ruta -> (ruta.getEstado() != EstadoRuta.APROBADA));
                rutasAerolinea.removeIf(ruta -> (ws.listarVuelosRuta(ruta.getNombre()).isEmpty()));

                request.setAttribute("rutas", rutasAerolinea);
                request.setAttribute("aerolineaId", idAerolinea);
            }

            if (idRuta != null) {
                DtRuta ruta = ws.getRutaDeVuelo(idRuta);
                if (ruta != null) {
                    double precioTurista = ruta.getCostoTurista();
                    double precioEjecutivo = ruta.getCostoEjecutivo();
                    double precioEquipaje = ruta.getEquipajeExtra();

                    request.setAttribute("precioTurista", precioTurista);
                    request.setAttribute("precioEjecutivo", precioEjecutivo);
                    request.setAttribute("precioEquipaje", precioEquipaje);
                }
            }

            if (idRuta != null && idAerolinea != null) {
                DtAerolinea aerolinea = ws.getAerolinea(idAerolinea);
                request.setAttribute("aerolineaId", idAerolinea);
                request.setAttribute("rutaId", idRuta);
                request.setAttribute("rutas", aerolinea.getRutasDeVuelo());
                request.setAttribute("vuelos", ws.listarVuelosRuta(idRuta));
            }

            List<DtPaquete> paquetesCliente = ws.listarPaquetesCliente(cliente.getNickname());
            List<DtPaquete> paquetesFiltrados = new ArrayList<>();
            LocalDate hoy = LocalDate.now();

            if (idRuta != null) {
                for (DtPaquete paquete : paquetesCliente) {
                    for (DtRutaEnPaquete rep : paquete.getRutaEnPaquete()) {
                        if (rep.getRutaDeVuelo() != null && rep.getRutaDeVuelo().getNombre().equals(idRuta)) {
                            paquetesFiltrados.add(paquete);
                            break;
                        }
                    }
                }
            } else {
                paquetesFiltrados.addAll(paquetesCliente);
            }
            request.setAttribute("paquetes", paquetesFiltrados);

            request.getRequestDispatcher("/WEB-INF/jsp/reservas/crear.jsp").forward(request, response);
        } catch (Exception ex) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            System.out.println("Error en CrearReservaServlet: " + ex.getMessage());
            request.getRequestDispatcher("/WEB-INF/jsp/reservas/crear.jsp").forward(request, response);
        }
    }

        @Override
        protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
            String userAgent = request.getHeader("User-Agent");
            request.setCharacterEncoding("UTF-8");
            response.setContentType("text/html; charset=UTF-8");

            boolean esMobile = userAgent != null && (
                    userAgent.contains("Mobile") ||
                            userAgent.contains("Android") ||
                            userAgent.contains("iPhone") ||
                            userAgent.contains("iPad")
            );

            if (esMobile) {
                request.setAttribute("error", "Acceso no autorizado desde dispositivos móviles.");
                request.getRequestDispatcher("/WEB-INF/jsp/401.jsp").forward(request, response);
                return;
            }

            HttpSession session = request.getSession(false);

            if (session == null || session.getAttribute("usuarioTipo") == null || session.getAttribute("usuarioNickname") == null) {
                request.getRequestDispatcher("/WEB-INF/jsp/401.jsp").forward(request, response);
                return;
            }

            if (!"cliente".equals(session.getAttribute("usuarioTipo"))) {
                request.getRequestDispatcher("/WEB-INF/jsp/401.jsp").forward(request, response);
                return;
            }

            try {
                String nicknameCliente = (String) session.getAttribute("usuarioNickname");
                DtCliente clienteLogueado = ws.getCliente(nicknameCliente);

                String aerolinea = request.getParameter("aerolinea");
                String vuelo = request.getParameter("vuelo");
                String cantidad = request.getParameter("cantidad-pasajes");
                String tipoAsientoStr = request.getParameter("tipo-asiento");
                String equipajeExtra = request.getParameter("equipaje-extra");
                String metodoPagoStr = request.getParameter("metodo-pago");
                String paqueteNombre = request.getParameter("paquete");

                String[] nombres = request.getParameterValues("nombrePasajero");
                String[] apellidos = request.getParameterValues("apellidoPasajero");


                if (aerolinea == null || vuelo == null || tipoAsientoStr == null || cantidad == null || equipajeExtra == null) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("Faltan datos obligatorios");
                    return;
                }

                int cantPasajes = Integer.parseInt(cantidad);
                int equipaje = Integer.parseInt(equipajeExtra);
                TipoAsiento tipo = TipoAsiento.valueOf(tipoAsientoStr.toUpperCase());

                List<DtPasajero> pasajeros = new ArrayList<>();
                if (nombres != null && apellidos != null) {
                    for (int i = 0; i < Math.min(nombres.length, apellidos.length); i++) {
                        DtPasajero pasajero = new DtPasajero();
                        pasajero.setNombre(nombres[i]);
                        pasajero.setApellido(apellidos[i]);
                        pasajeros.add(pasajero);
                    }
                }

                if (pasajeros.size() != cantPasajes) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("La cantidad de pasajeros no coincide con la cantidad indicada");
                    return;
                }


                DtVuelo vueloSeleccionado = ws.getVuelo(vuelo);
                if (vueloSeleccionado == null) {
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    response.getWriter().write("Vuelo no encontrado");
                    return;
                }

                MetodoPago metodoPago;
                DtPaquete paqueteSeleccionado = null;

                if ("pago-paquete".equals(metodoPagoStr)) {
                    metodoPago = MetodoPago.PAQUETE;
                    if (paqueteNombre == null || paqueteNombre.isEmpty()) {
                        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                        response.getWriter().write("Debe seleccionar un paquete");
                        return;
                    }

                    List<DtPaquete> paquetesCliente = ws.listarPaquetesCliente(clienteLogueado.getNickname());
                    for (DtPaquete p : paquetesCliente) {
                        if (p.getNombre().equals(paqueteNombre)) {
                            paqueteSeleccionado = p;
                            break;
                        }
                    }

                    if (paqueteSeleccionado == null) {
                        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                        response.getWriter().write("Paquete inválido");
                        return;
                    }

                } else if ("pago-general".equals(metodoPagoStr)) {
                    metodoPago = MetodoPago.GENERAL;
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("Debe seleccionar un método de pago");
                    return;
                }

                DtReserva reserva = new DtReserva();
                LocalDate fecha = LocalDate.now();

                reserva.setFecha(fecha.toString());
                reserva.setTipoAsiento(tipo);
                reserva.setCantPasajes(cantPasajes);
                reserva.setMetodoPago(metodoPago);
                reserva.setEquipajeExtra(equipaje);
                reserva.setCosto(0);
                reserva.getPasajeros().clear();
                reserva.getPasajeros().addAll(pasajeros);
                reserva.setCliente(clienteLogueado);
                reserva.setVuelo(vueloSeleccionado);
                reserva.setMetodoPago(metodoPago);

                if (metodoPago == MetodoPago.PAQUETE) {
                    reserva.setPaquetePago(paqueteSeleccionado);
                }

                try {
                    ws.altaReserva(reserva);
                } catch (ServerSOAPFaultException ex) {

                    String msg = ex.getFault().getFaultString(); // mensaje real del SOAP Fault

                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write(msg);
                    return;
                }


                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write("Reserva creada con éxito");
                request.setAttribute("exito", "Reserva creada con éxito");
                request.getRequestDispatcher("/WEB-INF/jsp/reservas/crear.jsp").forward(request, response);

            } catch (IllegalArgumentException ex) {
                System.out.println(ex.getMessage());
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Error en los datos proporcionados");
                request.getRequestDispatcher("/WEB-INF/jsp/reservas/crear.jsp").forward(request, response);
            } catch (Exception ex) {
                System.out.println("Error en CrearReservaServlet (POST): " + ex.getMessage());
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("Error del servidor");
                ex.printStackTrace();
            }
        }




}
