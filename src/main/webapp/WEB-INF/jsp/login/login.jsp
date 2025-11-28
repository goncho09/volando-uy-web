<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Volando.uy | Iniciar sesión</title>

    <link rel="icon" href="${pageContext.request.contextPath}/favicon.ico?v=2" type="image/x-icon">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/globals.css">
</head>
<body>
<div class=" h-screen flex justify-center items-center bg-[var(--azul-oscuro)]">
    <form id="login-form" class="flex flex-col items-center gap-4 py-6  rounded-lg shadow-lg bg-white w-[85%] md:w-128 ">
        <a href="${pageContext.request.contextPath}/home" class="space-x-1 text-left w-full px-6">
            <i class="fa fa-arrow-left text-[var(--azul-oscuro)]"></i>
            <span class="decoration-[var(--azul-claro)] underline-offset-5 hover:underline">Volver al inicio</span>
        </a>
        <h1 class="text-center text-3xl font-semibold text-[var(--azul-oscuro)]">Iniciar sesión</h1>
        <div
                class="flex w-[90%] md:w-2/3 items-center border-b border-gray-300 py-2 space-x-3 focus-within:border-[var(--azul-oscuro)]">
            <i class="fa fa-user icon text-[var(--azul-oscuro)]"></i>
            <input type="text" name="name" id="name" placeholder="Ingrese su nickname" required
                   class="flex-grow outline-none">
        </div>
        <div
                class="flex w-[90%] md:w-2/3 items-center border-b border-gray-300 py-2 space-x-3 focus-within:border-[var(--azul-oscuro)]">
            <i class="fa fa-lock icon text-[var(--azul-oscuro)]"></i>
            <input type="password" id="password" name="password" placeholder="Ingrese su contraseña" required
                   class="flex-grow outline-none">
        </div>

        <p id="error-msg"
           class="hidden text-red-600 text-sm transition-all duration-300 transform origin-top -translate-y-1">
        </p>

        <button type="submit"
                class="hover:bg-[var(--azul-claro)] w-2/3 text-white py-2 rounded-lg duration-400 bg-[var(--azul-oscuro)]">Iniciar
            sesión</button>

        <div class="flex items-center space-x-1">
            <p class="text-center">¿No tienes una cuenta? </p>
            <a href="${pageContext.request.contextPath}/register" class="">
                <p class="hover:text-[var(--azul-claro)] hover:underline m-0">Regístrate</p>
            </a>
        </div>
    </form>
</div>

<script defer>
    const loginForm = document.getElementById('login-form')
    loginForm.addEventListener('submit',async(e) => {
        e.preventDefault();

        const params = new URLSearchParams();
        params.append("name", document.getElementById("name").value);
        params.append("password", document.getElementById("password").value);


        const errorMsg = document.getElementById("error-msg");
        const button = e.target.querySelector('button[type="submit"]');
        button.disabled = true;
        button.textContent = "Iniciando sesión...";

        errorMsg.textContent = "";
        errorMsg.classList.add("hidden");
        errorMsg.classList.remove("translate-y-0");

        const response = await fetch('${pageContext.request.contextPath}/login', {
            method: 'POST',
            body: params,
        });

        const text = await response.text();

        if (response.ok) {
            window.location.href = '${pageContext.request.contextPath}/home';
        } else {
            errorMsg.textContent = text;
            errorMsg.classList.remove("hidden");
            errorMsg.classList.add("translate-y-0");
            button.disabled = false;
            button.textContent = "Iniciar sesión";
        }
    });
</script>
</body>
</html>