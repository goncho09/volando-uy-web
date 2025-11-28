
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Volando.uy | Registrar usuario </title>

    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    <link rel="icon" href="${pageContext.request.contextPath}/favicon.ico?v=2" type="image/x-icon">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/globals.css">
</head>

<body>
<div class=" h-screen flex justify-center items-center bg-[var(--azul-oscuro)]">
    <form id="form" class="flex flex-col items-center gap-4 py-6  rounded-lg shadow-lg bg-white w-[85%] md:w-128" enctype="multipart/form-data">
        <a href="${pageContext.request.contextPath}/home" class="space-x-1 text-left w-full px-6">
            <i class="fa fa-arrow-left text-[var(--azul-oscuro)]"></i>
            <span class="decoration-[var(--azul-claro)] underline-offset-5 hover:underline">Volver al inicio</span>
        </a>
        <h1 class="text-center text-3xl font-semibold text-[var(--azul-oscuro)]">Registrar usuario</h1>

        <div
                class="flex w-[90%] md:w-2/3 items-center border-b border-gray-300 py-2 space-x-3 focus-within:border-[var(--azul-oscuro)]">
            <i class="fa fa-user icon text-[var(--azul-oscuro)]"></i>
            <input type="text" name="nickname" placeholder="Ingrese su nickname *" required
                   class="flex-grow outline-none">
        </div>

        <div class="flex w-[90%] md:w-2/3 items-center border-b border-gray-300 py-2 space-x-3 focus-within:border-[var(--azul-oscuro)]">
            <i class="fa fa-signature icon text-[var(--azul-oscuro)]"></i>
            <input type="text" name="name" placeholder="Ingrese su nombre *" required
                   class="flex-grow outline-none">
        </div>

        <div
                class="flex w-[90%] md:w-2/3 items-center border-b border-gray-300 py-2 space-x-3 focus-within:border-[var(--azul-oscuro)]">
            <i class="fa fa-envelope icon text-[var(--azul-oscuro)]"></i>
            <input type="email" name="email" placeholder="Ingrese su correo electrónico *" required
                   class="flex-grow outline-none">
        </div>


        <div class="flex w-[90%] md:w-2/3 items-center border-b border-gray-300 py-2 space-x-3 focus-within:border-[var(--azul-oscuro)]">
            <i class="fa fa-image icon text-[var(--azul-oscuro)]"></i>
            <label for="image" class="flex-grow text-gray-500 cursor-pointer">
                <span id="file-name" class="block">Seleccione una foto de perfil *</span>
                <input type="file" id="image" name="image" accept="image/*" class="sr-only" required>
            </label>
        </div>

        <div class="flex w-[90%] md:w-2/3 items-center border-b border-gray-300 py-2 space-x-3 focus-within:border-[var(--azul-oscuro)]">
            <i class="fa fa-lock icon text-[var(--azul-oscuro)]"></i>
            <input type="password" name="password" placeholder="Ingrese su contraseña *" required
                   class="flex-grow outline-none">
        </div>

        <div
                class="flex w-[90%] md:w-2/3 items-center border-b border-gray-300 py-2 space-x-3 focus-within:border-[var(--azul-oscuro)]">
            <i class="fa fa-lock icon text-[var(--azul-oscuro)]"></i>
            <input type="password" name="confirm-password" placeholder="Confirme su contraseña *" required
                   class="flex-grow outline-none">
        </div>


        <div
                class="flex w-[90%] md:w-2/3 items-center border-b border-gray-300 py-2 space-x-3 focus-within:border-[var(--azul-oscuro)]">
            <i class="fa fa-user-tag icon text-[var(--azul-oscuro)]"></i>
            <select class="flex-grow outline-none bg-transparent text-gray-700 py-2 px-2 rounded focus:bg-gray-100"
                    name="role" aria-label="Seleccione su rol *" required>
                <option value="" disabled selected>Seleccione su rol</option>
                <option value="cliente">Cliente</option>
                <option value="aerolinea">Aerolínea</option>
            </select>
        </div>

        <p id="error-msg"
           class="hidden text-red-600 text-sm transition-all duration-300 transform origin-top -translate-y-1">
        </p>

        <button type="submit"
                class="hover:bg-[var(--azul-claro)] w-2/3 text-white py-2 rounded-lg duration-400 bg-[var(--azul-oscuro)]">Registrar</button>
    </form>
</div>
</body>

<script>

    const fileInput = document.getElementById('image');
    const fileNameSpan = document.getElementById('file-name');
    const form = document.getElementById('form');
    const errorMsg = document.getElementById('error-msg');

    fileInput.addEventListener('change', () => {
        const file = fileInput.files[0];
        fileNameSpan.textContent = file ? file.name : 'Seleccione una foto de perfil';
    });

    form.addEventListener('submit', async (e) => {
        e.preventDefault();

        const file = fileInput.files[0];
        if (!file) return alert("Seleccione una imagen");

        const formData = new FormData(form);

        errorMsg.textContent = '';
        errorMsg.classList.add('hidden');
        errorMsg.classList.remove('translate-y-0');

        const response = await fetch(`${pageContext.request.contextPath}/register`, {
            method: 'POST',
            body: formData
        });

        const text = await response.text();

        if (!response.ok) {
            errorMsg.textContent = text;
            errorMsg.classList.remove('hidden');
            errorMsg.classList.add('translate-y-0');
        } else {
            window.location.href = '${pageContext.request.contextPath}/register/final';
        }
    });


</script>
</html>
