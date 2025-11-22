
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Volando.uy | Perfil</title>

    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/globals.css"/>
</head>

<body>

<c:set var="usuarioNickname" value="${sessionScope.usuarioNickname}"/>

<jsp:include page="../components/header.jsp"/>

<main class="flex flex-col mt-5 bg-white mx-auto w-3/4 p-5 rounded shadow">




    <c:if test="${not empty usuarioPerfil}">
        <div class="w-full flex items-center justify-between mb-3">
            <h3 class="text-3xl text-black font-bold">Mi perfil</h3>
            <c:if test="${modificar == true}">
                <button id="modificarButton"><i
                        class="text-3xl fa fa-edit text-green-500 cursor-pointer hover:text-green-700"></i></button>
            </c:if>

            <c:if test="${usuarioNickname != null && modificar != true && sigue == false}">
                <form id="seguir-usuario">
                <button
                        type="submit"
                        class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded">
                    Seguir
                </button>
                </form>
            </c:if>

            <c:if test="${usuarioNickname != null && modificar != true && sigue == true}">
                <form id="dejar-de-seguir-usuario">
                    <button
                            type="submit"
                            class="bg-red-500 hover:bg-red-700 text-white font-bold py-2 px-4 rounded">
                        Dejar de seguir
                    </button>
                </form>

            </c:if>
        </div>

        <form id="formModificar" class="flex flex-col bg-white w-full">
            <section class="flex flex-col rounded shadow p-4 items-center">
                <div class="flex flex-col items-center space-y-2">
                    <img id="previewImagen"
                         src="${empty usuarioImagenPerfil ? pageContext.request.contextPath + '/assets/userDefault.png' : usuarioImagenPerfil}"
                         alt="Foto de perfil"
                         class="rounded-full max-w-xs w-48 h-auto object-cover"/>
                    <div class="hidden space-x-2" id="seleccionarImagenContainer">
                        <label for="inputImagen" class="flex items-center mt-2 text-gray-500 cursor-pointer">
                            <i class="fa fa-upload text-blue-500 mr-2"></i>
                            Editar foto
                        </label>
                        <input type="file" id="inputImagen" name="image" accept="image/*" class="sr-only">
                    </div>
                </div>

                <div class="flex flex-col mt-3 space-y-2 text-black text-center">
                    <p>${usuarioPerfil.nickname}</p>
                    <p>${usuarioPerfil.email}</p>
                </div>
            </section>

            <div class="bg-white w-full rounded shadow p-4 mb-5 text-black flex flex-col">


                <div class="flex flex-col w-full space-y-1 mt-2">
                    <div class="flex justify-center space-x-2">
                        <div class="flex space-x-2">
                            <span><i class="fa fa-user"></i></span>
                            <label for="nombre">Nombre:</label>
                        </div>
                        <input type="text" class="flex-1 bg-transparent"
                               id="nombre" name="nombre" readonly value="${usuarioPerfil.nombre}"/>
                    </div>
                    <c:choose>
                        <c:when test="${usuarioTipoPerfil == 'cliente' && cliente != null}">

                            <div class="flex space-x-2">
                                <div class="flex space-x-2">
                                    <span><i class="fa fa-user"></i></span>
                                    <label for="apellido">Apellido:</label>
                                </div>
                                <input type="text" class="flex-1 bg-transparent"
                                       id="apellido" name="apellido" readonly value="${cliente.apellido}"/>
                            </div>

                            <div class="flex space-x-2">
                                <div class="flex space-x-2">
                                    <span><i class="fa fa-calendar"></i></span>
                                    <label for="fechaNacimiento">Fecha de nacimiento:</label>
                                </div>
                                <input type="date" id="fechaNacimiento" name="fechaNacimiento"
                                       value="${cliente.fechaNacimiento}" readonly
                                       class="flex-1 bg-transparent"/>
                            </div>

                            <div class="flex  space-x-2">
                                <div class="flex space-x-2">
                                    <span><i class="fa fa-flag"></i></span>
                                    <label for="nacionalidad">Nacionalidad:</label>
                                </div>
                                <input type="text" class="flex-1 bg-transparent" id="nacionalidad" name="nacionalidad"
                                       readonly
                                       value="${cliente.nacionalidad}"/>
                            </div>

                            <div class="flex  space-x-2 items-center">
                                <div class="flex space-x-2">
                                    <span><i class="fa fa-passport"></i></span>
                                    <label for="tipoDocumento">Tipo de documento:</label>
                                </div>

                                <select name="tipoDocumento" aria-label="Seleccione tipo de documento *" disabled
                                        id="selectTipoDocumento"
                                        class="flex-grow outline-none bg-transparent text-gray-700 py-2 px-2 rounded focus:bg-gray-100"
                                >
                                    <option value="CÉDULA DE IDENTIDAD" ${cliente.tipoDocumento == 'CEDULA' ? 'selected' : ''}>
                                        CÉDULA DE IDENTIDAD
                                    </option>
                                    <option value="PASAPORTE" ${cliente.tipoDocumento == 'PASAPORTE' ? 'selected' : ''}>
                                        PASAPORTE
                                    </option>
                                </select>
                            </div>

                            <div class="flex  space-x-2">
                                <div class="flex space-x-2">
                                    <span><i class="fa fa-id-card"></i></span>
                                    <label for="numeroDocumento">Número de documento:</label>
                                </div>
                                <input type="text" class="flex-1 bg-transparent" id="numeroDocumento"
                                       name="numeroDocumento" readonly
                                       value="${cliente.numeroDocumento}"/>
                            </div>

                            <div class="hidden w-full" id="buttonModificarClienteContainer">
                                <button type="submit"
                                        class="!mt-5 hover:bg-[var(--azul-claro)] w-48 text-white py-2 rounded-lg duration-400 bg-[var(--azul-oscuro)]">
                                    Guardar cambios
                                </button>

                            </div>

                            <c:if test="${modificar == true}">
                                <div class="flex space-x-3">
                                    <button type="button"
                                            onclick="window.location.href='${pageContext.request.contextPath}/reservas/ver'"
                                            class="!mt-5 hover:bg-[var(--azul-claro)] w-48 text-white py-2 rounded-lg duration-400 bg-[var(--azul-oscuro)]">
                                        Ver mis reservas
                                        <i class="fa fa-arrow-right ml-2"></i>
                                    </button>

                                    <button type="button"
                                            onclick="window.location.href='${pageContext.request.contextPath}/paquete/ver'"
                                            class="!mt-5 hover:bg-[var(--azul-claro)] w-48 text-white py-2 rounded-lg duration-400 bg-[var(--azul-oscuro)]">
                                        Ver mis paquetes
                                        <i class="fa fa-arrow-right ml-2"></i>
                                    </button>
                                </div>
                            </c:if>


                        </c:when>
                        <c:when test="${usuarioTipoPerfil == 'aerolinea' && aerolinea != null}">
                            <div class="flex  space-x-2">
                                <div class="flex space-x-2">
                                    <span><i class="fa fa-comment"></i></span>
                                    <label for="descripcion">Descripción:</label>
                                </div>
                                <input type="text" class="flex-1 bg-transparent break-words truncate max-w-full"
                                       id="descripcion" name="descripcion"
                                       readonly
                                       value="${aerolinea.descripcion}"/>
                            </div>

                            <div class="flex space-x-2">
                                <div class="flex space-x-2">
                                    <span><i class="fa fa-globe"></i></span>
                                    <label for="linkWeb">Link web:</label>
                                </div>
                                <input type="text" class="flex-1 bg-transparent break-words truncate max-w-full"
                                       id="linkWeb" name="linkWeb" readonly
                                       value="${empty aerolinea.linkWeb ? '-' : aerolinea.linkWeb}"/>
                            </div>

                            <div class="hidden w-full" id="buttonModificarAerolineaContainer">
                                <button type="submit"
                                        class="!mt-5 hover:bg-[var(--azul-claro)] w-48 text-white py-2 rounded-lg duration-400 bg-[var(--azul-oscuro)]">
                                    Guardar cambios
                                </button>

                            </div>
                            <c:if test="${modificar == true}">


                                <div class="flex space-x-3">
                                    <button type="button"
                                            onclick="window.location.href='${pageContext.request.contextPath}/reservas/ver'"
                                            class="!mt-5 hover:bg-[var(--azul-claro)] w-48 text-white py-2 rounded-lg duration-400 bg-[var(--azul-oscuro)]">
                                        Ver mis reservas
                                        <i class="fa fa-arrow-right ml-2"></i>
                                    </button>

                                    <button type="button"
                                            onclick="window.location.href='${pageContext.request.contextPath}/paquete/ver'"
                                            class="!mt-5 hover:bg-[var(--azul-claro)] w-48 text-white py-2 rounded-lg duration-400 bg-[var(--azul-oscuro)]">
                                        Ver mis paquetes
                                        <i class="fa fa-arrow-right ml-2"></i>
                                    </button>

                                    <button type="button"
                                            onclick="window.location.href='${pageContext.request.contextPath}/ruta-de-vuelo/ver'"
                                            class="!mt-5 hover:bg-[var(--azul-claro)] w-48 text-white py-2 rounded-lg duration-400 bg-[var(--azul-oscuro)]">
                                        Ver mis rutas
                                        <i class="fa fa-arrow-right ml-2"></i>
                                    </button>
                                </div>
                            </c:if>
                        </c:when>

                    </c:choose>
                </div>

            </div>
        </form>
        <div id="error-msg" class="text-red-500 text-lg my-2 text-center justify-center hidden">
        </div>

        <div id="success-msg" class="text-green-500 text-lg my-2 text-center justify-center hidden">
            Perfil actualizado con éxito.
        </div>
        <c:if test="${modificar == true}">
           <div class="flex flex-col w-full space-y-2">
               <label>Lista de seguidos:</label>
               <div class="flex w-full space-x-3">
                   <select class="flex-1 border border-gray-300 rounded px-2 py-1" id="selectSeguidos">
                       <option value="" disabled selected>Seleccione un seguido</option>
                       <c:forEach var="seguido" items="${listaSeguidos}">
                           <option value="${seguido.nickname}">${seguido.nickname} - ${seguido.nombre}</option>
                       </c:forEach>
                   </select>
                   <button id="verPerfilSeguidoBtn"
                           class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded">
                       <i class="fa fa-eye"></i>
                   </button>
               </div>

               <label>Lista de seguidores:</label>
               <div class="flex w-full space-x-3">
                   <select class="flex-1 border border-gray-300 rounded px-2 py-1" id="selectSeguidores">
                       <option value="" disabled selected>Seleccione un seguidor</option>
                       <c:forEach var="seguidor" items="${listaSeguidores}">
                           <option value="${seguidor.nickname}">${seguidor.nickname} - ${seguidor.nombre}</option>
                       </c:forEach>
                   </select>
                   <button id="verPerfilSeguidorBtn"
                           class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded">
                       <i class="fa fa-eye"></i>
                   </button>
               </div>
           </div>
        </c:if>

    </c:if>

</main>

<script defer>
    const errorMsg   = document.getElementById("error-msg");
    const successMsg = document.getElementById("success-msg");

    // Modificar Perfil
    const formModificar                = document.getElementById("formModificar");
    const modificarButton              = document.getElementById("modificarButton");
    const seleccionarImagenContainer   = document.getElementById("seleccionarImagenContainer");
    const inputImagen                  = document.getElementById("inputImagen");
    const previewImagen                = document.getElementById("previewImagen");
    const buttonModificarClienteContainer   = document.getElementById("buttonModificarClienteContainer");
    const buttonModificarAerolineaContainer = document.getElementById("buttonModificarAerolineaContainer");
    const buttonGuardarContainer       = buttonModificarClienteContainer || buttonModificarAerolineaContainer;
    const selectTipoDocumento          = document.getElementById("selectTipoDocumento");

    let modificando = false;

    // --- Preview imagen ---
    inputImagen?.addEventListener("change", ({ target }) => {
        const file = target.files?.[0];
        if (file) {
            const reader = new FileReader();
            reader.onload = e => previewImagen.src = e.target.result;
            reader.readAsDataURL(file);
        }
    });

    // Mostrar para editar
    modificarButton?.addEventListener("click", () => {
        modificando = !modificando;

        seleccionarImagenContainer?.classList.toggle("!flex", modificando);
        buttonGuardarContainer?.classList.toggle("!flex", modificando);

        if (selectTipoDocumento) selectTipoDocumento.disabled = !modificando;

        const inputs = formModificar.querySelectorAll("input, select");
        const spans = formModificar.querySelectorAll("span");

        inputs.forEach(inpt => {
            inpt.readOnly = !modificando;
            inpt.classList.toggle("bg-green-100", modificando);
        });

        spans.forEach(sp => sp.classList.toggle("text-green-600", modificando));
    });

    // Form modificar
    formModificar?.addEventListener("submit", async e => {
        e.preventDefault();

        if (!modificando) {
            errorMsg.textContent = 'Debes realizar modificaciones antes de guardar.';
            errorMsg.classList.remove('hidden');
            return;
        }

        const formData = new FormData(formModificar);

        try {
            const response = await fetch(`${pageContext.request.contextPath}/perfil?nickname=${usuarioNickname}`, {
                method: "POST",
                body: formData
            });

            if (response.ok) {
                successMsg.classList.remove("hidden");
                setTimeout(() => window.location.reload(), 1200);
            } else {
                const errorText = await response.text();
                errorMsg.textContent = errorText || "Error al actualizar el perfil.";
                errorMsg.classList.remove("hidden");
            }
        } catch {
            errorMsg.textContent = "Error en la conexión con el servidor.";
            errorMsg.classList.remove("hidden");
        }
    });

    // Seguidos y Seguidores
    const botonSeguido    = document.getElementById("verPerfilSeguidoBtn");
    const botonSeguidor   = document.getElementById("verPerfilSeguidorBtn");
    const selectSeguidos  = document.getElementById("selectSeguidos");
    const selectSeguidores = document.getElementById("selectSeguidores");

    const irAPerfil = nickname => {
        if (nickname)
            window.location.href = `${pageContext.request.contextPath}/perfil?nickname=` + nickname;
        else
            alert("Seleccione un usuario primero.");
    };

    botonSeguido?.addEventListener("click", () => irAPerfil(selectSeguidos.value));
    botonSeguidor?.addEventListener("click", () => irAPerfil(selectSeguidores.value));

    const formSeguir          = document.getElementById("seguir-usuario");
    const formDejarDeSeguir   = document.getElementById("dejar-de-seguir-usuario");

    const enviarAccion = async url => {
        try {
            const response = await fetch(url, { method: "POST" });
            if (response.ok) {
                window.location.reload();
            } else {
                errorMsg.textContent = "Error en la operación.";
                errorMsg.classList.remove("hidden");
            }
        } catch {
            errorMsg.textContent = "Error en la conexión con el servidor.";
            errorMsg.classList.remove("hidden");
        }
    };

    formSeguir?.addEventListener("submit", e => {
        e.preventDefault();
        enviarAccion(`${pageContext.request.contextPath}/seguir?nickname=${usuarioPerfil.nickname}`);
    });

    formDejarDeSeguir?.addEventListener("submit", e => {
        e.preventDefault();
        enviarAccion(`${pageContext.request.contextPath}/dejar-de-seguir?nickname=${usuarioPerfil.nickname}`);
    });

</script>


</body>
</html>