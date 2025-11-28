package uy.volando.servlets.Perfil;

import uy.volando.soap.ControladorWS;
import uy.volando.soap.client.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;


@MultipartConfig
        (
                fileSizeThreshold = 1024 * 1024, // 1 MB
                maxFileSize = 1024 * 1024 * 10,      //
                maxRequestSize = 1024 * 1024 * 15    // 15 MB
        )
@WebServlet(name = "PerfilServlet", urlPatterns = {"/perfil"})
public class PerfilServlet extends HttpServlet {
    VolandoServicePort ws = ControladorWS.getPort();

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

        if (esMobile) {
            request.setAttribute("error", "Acceso no autorizado desde dispositivos móviles.");
            request.getRequestDispatcher("/WEB-INF/jsp/401.jsp").forward(request, response);
            return;
        }

        HttpSession session = request.getSession(false);
        String nickname = request.getParameter("nickname");

        if (nickname == null || nickname.isEmpty()) {
            request.setAttribute("error", "Error al cargar el perfil. Se necesita un nickname.");
            request.getRequestDispatcher("/WEB-INF/jsp/error.jsp").forward(request, response);
            return;
        }

        try {
            DtUsuario usuario = ws.getUsuario(nickname);

            String contextPath = request.getContextPath();
            String urlImagen = usuario.getUrlImage();

            boolean invalida = (urlImagen == null || urlImagen.isEmpty());

            if (invalida) {
                usuario.setUrlImage(contextPath + "/assets/rutaDefault.png");
            } else {
                usuario.setUrlImage(contextPath + "/imagen?nombre=" + urlImagen + "&tipo=User");
            }

            boolean modificar = false;
            boolean sigue = false;
            if (session != null && session.getAttribute("usuarioNickname") != null && session.getAttribute("usuarioTipo") !=null){
                String userNickname = (String) session.getAttribute("usuarioNickname");
                DtUsuario user = ws.getUsuario(userNickname);
                for (DtUsuario u : user.getSeguidos()) {
                    if (u.getNickname().equals(nickname)) {
                        sigue = true;
                        break;
                    }
                }
                if (userNickname.equals(nickname)) {
                    modificar = true;
                }
            }

            String tipoUsuario = ws.getTipoUsuario(nickname);

            if (tipoUsuario.equals("Aerolinea")) {
                DtAerolinea aerolinea = ws.getAerolinea(nickname);
                request.setAttribute("aerolinea", aerolinea);
                request.setAttribute("usuarioTipoPerfil","aerolinea");
            } else if (tipoUsuario.equals("Cliente")){
                DtCliente cliente = ws.getCliente(nickname);
                request.setAttribute("cliente", cliente);
                request.setAttribute("usuarioTipoPerfil","cliente");
            }

            request.setAttribute("listaSeguidores", usuario.getSeguidores());
            request.setAttribute("listaSeguidos",usuario.getSeguidos());
            request.setAttribute("usuarioImagenPerfil", usuario.getUrlImage());
            request.setAttribute("usuarioPerfil", usuario);
            request.setAttribute("modificar", modificar);
            request.setAttribute("sigue",sigue);

            request.getRequestDispatcher("/WEB-INF/jsp/perfil/perfil.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Error al cargar el perfil.");
            request.getRequestDispatcher("/WEB-INF/jsp/error.jsp").forward(request, response);
            System.out.println(">>> PerfilServlet: Error = " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);


        Boolean esMobile = (Boolean) session.getAttribute("esMobile");

        if (esMobile) {
            request.setAttribute("error", "Acceso no autorizado desde dispositivos móviles.");
            request.getRequestDispatcher("/WEB-INF/jsp/401.jsp").forward(request, response);
            return;
        }

        if (session.getAttribute("usuarioTipo") == null || session.getAttribute("usuarioNickname") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        try {
            String usuarioTipo = (String) session.getAttribute("usuarioTipo");
            String nickname = (String) session.getAttribute("usuarioNickname");
            DtUsuario usuario = ws.getUsuario(nickname);

            Part imagePart = request.getPart("image");
            String nombre = request.getParameter("nombre");

            if(imagePart != null && imagePart.getSize() > 0){
                InputStream inputStream = imagePart.getInputStream();
                ByteArrayOutputStream buffer = new ByteArrayOutputStream();
                int nRead;
                byte[] temp = new byte[1024];
                while ((nRead = inputStream.read(temp, 0, temp.length)) != -1) {
                    buffer.write(temp, 0, nRead);
                }
                buffer.flush();
                byte[] data = buffer.toByteArray();
                inputStream.close();

                String fotoPerfil = ws.guardarImagen(data, TipoImagen.USUARIO);
                usuario.setUrlImage(fotoPerfil);
                ws.modificarUsuarioImagen(usuario, usuario.getUrlImage());
            }

            usuario.setNombre(nombre);

            if (usuarioTipo.equals("cliente")) {
                String apellido = request.getParameter("apellido");
                String fechaNacimiento = request.getParameter("fechaNacimiento");
                String nacionalidad = request.getParameter("nacionalidad");
                String tipoDocumento = request.getParameter("tipoDocumento");
                String numeroDocumento = request.getParameter("numeroDocumento");

                TipoDocumento tipoDocumentoEnum;
                int numDoc;
                try {
                    tipoDocumentoEnum = TipoDocumento.valueOf(tipoDocumento);
                    numDoc = Integer.parseInt(numeroDocumento);
                } catch (Exception e) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    request.setAttribute("error", "Tipo o número de documento inválido");
                    System.out.println(">>> PerfilServlet POST: Error al setear datos usuario = " + e.getMessage());
                    return;
                }

                DtCliente clienteModify = new DtCliente();

                clienteModify.setNickname(usuario.getNickname());
                clienteModify.setNombre(usuario.getNombre());
                clienteModify.setEmail(usuario.getEmail());
                clienteModify.setUrlImage(usuario.getUrlImage());
                clienteModify.setApellido(apellido);
                clienteModify.setFechaNacimiento(fechaNacimiento);
                clienteModify.setNacionalidad(nacionalidad);
                clienteModify.setTipoDocumento(tipoDocumentoEnum);
                clienteModify.setNumeroDocumento(numDoc);

                ws.modificarCliente(clienteModify);
            } else if (usuarioTipo.equals("aerolinea")) {
                String descripcion = request.getParameter("descripcion");
                String linkWeb = request.getParameter("linkWeb");
                DtAerolinea aerolineaModify = new DtAerolinea();

                aerolineaModify.setNickname(usuario.getNickname());
                aerolineaModify.setNombre(usuario.getNombre());
                aerolineaModify.setEmail(usuario.getEmail());
                aerolineaModify.setUrlImage(usuario.getUrlImage());
                aerolineaModify.setDescripcion(descripcion);
                aerolineaModify.setLinkWeb(linkWeb);

                ws.modificarAerolinea(aerolineaModify);
            }

            // Actualiza session usuario
            DtUsuario updatedUsuario = ws.getUsuario(nickname);

            String contextPath = request.getContextPath();
            String urlImagenActualizado = updatedUsuario.getUrlImage();

            boolean invalida = (urlImagenActualizado == null || urlImagenActualizado.isEmpty());

            if (invalida) {
                updatedUsuario.setUrlImage(contextPath + "/assets/rutaDefault.png");
            } else {
                updatedUsuario.setUrlImage(contextPath + "/imagen?nombre=" + urlImagenActualizado + "&tipo=User");
            }

            session.setAttribute("usuario", updatedUsuario);
            session.setAttribute("usuarioImagen", updatedUsuario.getUrlImage());
            response.setStatus(HttpServletResponse.SC_OK);
        } catch (Exception e) {
            System.out.println(">>> PerfilServlet POST: Error = " + e.getMessage());
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("Error al actualizar perfil.");
        }

    }

}