<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Volando.uy | Registrar usuario</title>

    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    <link rel="icon" href="${pageContext.request.contextPath}/favicon.ico?v=2" type="image/x-icon">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/globals.css">
</head>

<body>
<div class=" h-screen flex justify-center items-center bg-[var(--azul-oscuro)]">
    <form id="formRegistrarUsuarioFinal" class="flex flex-col items-center gap-4 py-6  rounded-lg shadow-lg bg-white w-[85%] md:w-128 ">
        <h1 class="text-center text-3xl font-semibold text-[var(--azul-oscuro)]">Registrar</h1>


        <c:set var="usuario" value="${sessionScope.datosUsuario}" />
        <c:set var="tipoUsuario" value="${sessionScope.tipoUsuario}" />

        <c:choose>
            <c:when test="${tipoUsuario == 'aerolinea'}">
                <div class="w-[90%] md:w-2/3 flex items-center flex-col gap-4 space-y-2">
                    <div
                            class="flex  w-full items-center border-b border-gray-300 py-2 space-x-3 focus-within:border-[var(--azul-oscuro)]">
                        <i class="fa fa-comment icon text-[var(--azul-oscuro)]"></i>
                        <input type="text" name="descripcion" placeholder="Ingrese la descripción de la aerolínea *" required
                               class="flex-grow outline-none">
                    </div>

                        <div
                                class="flex  w-full items-center border-b border-gray-300 py-2 space-x-3 focus-within:border-[var(--azul-oscuro)]">
                            <i class="fa fa-globe icon text-[var(--azul-oscuro)]"></i>
                            <input type="text" name="pagina-web" placeholder="Ingrese la página web de la aerolínea"
                                   class="flex-grow outline-none">
                        </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="w-[90%] md:w-2/3 flex items-center flex-col gap-4 space-y-2">
                    <div
                            class="flex  w-full items-center border-b border-gray-300 py-2 space-x-3 focus-within:border-[var(--azul-oscuro)]">
                        <i class="fa fa-user icon text-[var(--azul-oscuro)]"></i>
                        <input type="text" name="apellido" placeholder="Ingrese su apellido *" required
                               class="flex-grow outline-none">
                    </div>

                    <div
                            class="flex  w-full items-center border-b border-gray-300 py-2 space-x-3 focus-within:border-[var(--azul-oscuro)]">
                        <i class="fa fa-calendar icon text-[var(--azul-oscuro)]"></i>
                        <input type="date" name="fecha-nacimiento" placeholder="Ingrese su fecha de nacimiento *" required
                               class="flex-grow outline-none">
                    </div>

                    <div
                            class="flex  w-full items-center border-b border-gray-300 py-2 space-x-3 focus-within:border-[var(--azul-oscuro)]">
                        <i class="fa fa-flag icon text-[var(--azul-oscuro)]"></i>
                        <input type="text" name="nacionalidad" placeholder="Ingrese su nacionalidad *" required
                               class="flex-grow outline-none">
                    </div>

                    <div
                            class="flex w-full  items-center border-b border-gray-300 py-2 space-x-3 focus-within:border-[var(--azul-oscuro)]">
                        <i class="fa fa-passport icon text-[var(--azul-oscuro)]"></i>
                        <select name="tipo-documento" aria-label="Seleccione tipo de documento *"
                                class="flex-grow outline-none bg-transparent text-gray-700 py-2 px-2 rounded focus:bg-gray-100" required>
                            <option value="" disabled selected>Seleccione tipo de documento</option>
                            <option value="RUT">RUT</option>
                            <option value="PASAPORTE">Pasaporte</option>
                            <option value="CEDULA">Cédula de identidad</option>
                        </select>
                    </div>

                    <div
                            class="flex  w-full items-center border-b border-gray-300 py-2 space-x-3 focus-within:border-[var(--azul-oscuro)]">
                        <i class="fa fa-id-card icon text-[var(--azul-oscuro)]"></i>
                        <input type="text" name="numero-documento" placeholder="Ingrese número de documento *" required
                               class="flex-grow outline-none">
                    </div>

                </div>
            </c:otherwise>
        </c:choose>

        <p id="error-msg"
           class="hidden text-red-600 text-base text-center transition-all duration-300 text-base transform origin-top -translate-y-1">
        </p>

        <p id="success-msg"
           class="hidden text-green-600 text-base text-center transition-all duration-300 text-base transform origin-top -translate-y-1">
            Usuario registrado con éxito. Redirigiendo al login...
        </p>

        <button type="submit"
                class="hover:bg-[var(--azul-claro)] w-2/3 text-white py-2 rounded-lg duration-400 bg-[var(--azul-oscuro)] mt-2">Registrar</button>
    </form>
</div>


</body>

<script>
    document.getElementById('formRegistrarUsuarioFinal').addEventListener('submit',async(e) => {
        e.preventDefault();
        const formData = new FormData(e.target);
        const params = new URLSearchParams(formData);
        const errorMsg = document.getElementById("error-msg");
        const successMsg = document.getElementById("success-msg");

        errorMsg.textContent = "";
        errorMsg.classList.add("hidden");
        errorMsg.classList.remove("translate-y-0");

        successMsg.classList.add("hidden");
        successMsg.classList.remove("translate-y-0");

        const response = await fetch('${pageContext.request.contextPath}/register/final', {
            method: 'POST',
            body: params,
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            }
        });

        const text = await response.text();

        if (response.ok) {
            successMsg.classList.remove("hidden");
            successMsg.classList.add("translate-y-0");
            setTimeout(()=>{
                window.location.href = '${pageContext.request.contextPath}/login';
            },2500);

        } else {
            errorMsg.textContent = text;
            errorMsg.classList.remove("hidden");
            errorMsg.classList.add("translate-y-0");
        }
    });
</script>
</html>
