package uy.volando.servlets.Perfil;

import uy.volando.soap.ControladorWS;
import uy.volando.soap.client.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.time.LocalDate;


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

        HttpSession session = request.getSession(false);
        String nickname = request.getParameter("nickname");

        if (nickname == null || nickname.isEmpty()) {
            request.setAttribute("error", "Error al cargar el perfil. Se necesita un nickname.");
            request.getRequestDispatcher("/WEB-INF/jsp/error.jsp").forward(request, response);
            return;
        }

        try {
            DtUsuario usuario = ws.getUsuario(nickname);

            String basePath = getServletContext().getRealPath("/pictures/users");
            String contextPath = request.getContextPath();

            String urlImagen = usuario.getUrlImage();
            File userImg = null;
            if (urlImagen != null && !urlImagen.isEmpty()) {
                userImg = new File(basePath, urlImagen);
            }

            if (urlImagen == null || urlImagen.isEmpty() || !userImg.exists()) {
                usuario.setUrlImage(contextPath + "/assets/userDefault.png");
            } else {
                usuario.setUrlImage(contextPath + "/pictures/users/" + urlImagen);
            }

            boolean modificar = false;
            boolean sigue = false;
            if (session != null && session.getAttribute("usuarioNickname") != null && session.getAttribute("usuarioTipo") !=null){
                String userNickname = (String) session.getAttribute("usuarioNickname");
                DtUsuario user = ws.getUsuario(userNickname);
                for (Usuario u : user.getSeguidos()) {
                    if (u.getNickname().equals(nickname)) {
                        sigue = true;
                        break;
                    }
                }
                System.out.println(sigue);
                if (userNickname.equals(nickname)) {
                    modificar = true;
                }
            }

            DtAerolinea aerolinea = null;
            try{
                aerolinea = ws.getAerolinea(nickname);
            }  catch (Exception ignored) {}

            if (aerolinea != null) {
                request.setAttribute("aerolinea", aerolinea);
                request.setAttribute("usuarioTipoPerfil","aerolinea");
            } else {
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

        if (session == null || session.getAttribute("usuarioTipo") == null || session.getAttribute("usuarioNickname") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            String usuarioTipo = (String) session.getAttribute("usuarioTipo");
            String nickname = (String) session.getAttribute("usuarioNickname");
            DtUsuario usuario = ws.getUsuario(nickname);

            Part imagePart = request.getPart("image");
            String nombre = request.getParameter("nombre");

            byte[] data = imagePart.getInputStream().readAllBytes();

            String fotoPerfil = ws.guardarImagen(data, TipoImagen.USUARIO);
            usuario.setNombre(nombre);
            usuario.setUrlImage(fotoPerfil);

            if (usuarioTipo.equals("cliente")) {

                String apellido = request.getParameter("apellido");
                String fechaNacimiento = request.getParameter("fechaNacimiento");
                String nacionalidad = request.getParameter("nacionalidad");
                String tipoDocumento = request.getParameter("tipoDocumento");
                String numeroDocumento = request.getParameter("numeroDocumento");

                LocalDate fechaNacDate = null;
                try {
                    fechaNacDate = LocalDate.parse(fechaNacimiento);
                } catch (Exception e) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("ERROR: Fecha de nacimiento inválida");
                    request.setAttribute("error", "Fecha de nacimiento inválida");
                    System.out.println(">>> PerfilServlet POST: Error al setear datos usuario = " + e.getMessage());
                }

                TipoDocumento tipoDocumentoEnum = null;
                int numDoc = 0;
                try {
                    tipoDocumentoEnum = TipoDocumento.valueOf(tipoDocumento);
                    numDoc = Integer.parseInt(numeroDocumento);
                } catch (Exception e) {
                    request.setAttribute("error", "Tipo o número de documento inválido");
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("ERROR: Tipo o número de documento inválido");
                    System.out.println(">>> PerfilServlet POST: Error al setear datos usuario = " + e.getMessage());
                }

                DtCliente clienteModify = new DtCliente();

                clienteModify.setNickname(usuario.getNickname());
                clienteModify.setNombre(usuario.getNombre());
                clienteModify.setEmail(usuario.getEmail());
                clienteModify.setUrlImage(usuario.getUrlImage());
                clienteModify.setApellido(apellido);
                clienteModify.setFechaNacimiento(fechaNacDate.toString());
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
            session.setAttribute("usuario", updatedUsuario);
            session.setAttribute("usuarioImagen", updatedUsuario.getUrlImage());
            request.setAttribute("success", "Perfil actualizado correctamente");

            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write("OK");
            request.getRequestDispatcher("/WEB-INF/jsp/perfil/perfil.jsp").forward(request, response);

        } catch (Exception e) {
            System.out.println(">>> PerfilServlet POST: Error = " + e.getMessage());
            request.setAttribute("error", "Error del servidor");
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            request.setAttribute("error", "Error al actualizar perfil");
            request.getRequestDispatcher("/WEB-INF/jsp/perfil/perfil.jsp").forward(request, response);
        }

    }

}