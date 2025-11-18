<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Volando.uy | Crear vuelo</title>

    <!-- Librerias Header -->
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet"/>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/globals.css"/>

</head>

<body>
<jsp:include page="../components/header.jsp" />

<main class="flex flex-col items-center  p-4 min-h-screen">
    <form id="formCrearVuelo" class="space-y-4 flex flex-col w-full max-w-md p-6 bg-white rounded-lg shadow-xl bg-gray-300 mt-2" enctype="multipart/form-data">
        <h2 class="mb-6 text-2xl font-bold text-center text-black">Nuevo Vuelo</h2>

        <div class="flex w-full items-center border-b border-gray-300  space-x-3 focus-within:border-[var(--azul-oscuro)]">
            <i class="fa fa-plane  text-[var(--azul-oscuro)]"></i>
            <input type="text" name="nombre" required  class="flex-grow p-2" placeholder="Ingrese el nombre del vuelo *">
        </div>

        <div class="flex w-full items-center border-b border-gray-300 py-2 space-x-3 focus-within:border-[var(--azul-oscuro)]">
            <i class="fa fa-clock text-[var(--azul-oscuro)]"></i>
            <input type="time" name="duracion" required  class="flex-grow p-2" placeholder="Ingrese la duración del vuelo *">
        </div>

        <div class="flex w-full items-center border-b border-gray-300 py-2 space-x-3 focus-within:border-[var(--azul-oscuro)]">
            <i class="fa fa-calendar  text-[var(--azul-oscuro)]"></i>
            <input type="date"  name="fecha" required class="flex-grow p-2" placeholder="Ingrese la fecha del vuelo *">
        </div>

        <div class="flex w-full items-center border-b border-gray-300 py-2 space-x-3 focus-within:border-[var(--azul-oscuro)]">
            <i class="fa fa-couch text-[var(--azul-oscuro)]"></i>
            <input type="number" name="max-ejecutivos" required min="0"  placeholder="Ingrese la cantidad máxima de asientos ejecutivos *"
                   class="flex-grow p-2">
        </div>

        <div class="flex w-full items-center border-b border-gray-300 py-2 space-x-3 focus-within:border-[var(--azul-oscuro)]">
            <i class="fa fa-chair text-[var(--azul-oscuro)]"></i>
            <input type="number" name="max-turistas" required min="0"  placeholder="Ingrese la cantidad máxima de asientos turísticos *"
                   class="flex-grow p-2">
        </div>


        <div class="flex w-full  items-center border-b border-gray-300 py-2 space-x-3 focus-within:border-[var(--azul-oscuro)]">
            <i class="fa fa-image icon text-[var(--azul-oscuro)]"></i>
            <label for="image" class="flex-grow text-gray-500 cursor-pointer">
                <span id="file-name" class="block">Seleccione una foto del vuelo *</span>
                <input type="file" id="image" name="image" accept="image/*" class="sr-only" required>
            </label>
        </div>

        <div
                class="flex w-full  items-center border-b border-gray-300 py-2 space-x-3 focus-within:border-[var(--azul-oscuro)]">
            <i class="fa fa-route icon text-[var(--azul-oscuro)]"></i>
            <select class="flex-grow outline-none bg-transparent text-gray-700 py-2 px-2 rounded focus:bg-gray-100"
                    name="ruta" aria-label="Seleccione la ruta de vuelo *" required>
                <option value="" disabled selected>Seleccione la ruta de vuelo *</option>
                <c:forEach var="ruta" items="${rutas}">
                    <c:choose>
                        <c:when test="${not empty seleccionarRuta && ruta.nombre eq seleccionarRuta}">
                            <option value="${ruta.nombre}" selected>${ruta.nombre}</option>
                        </c:when>
                        <c:otherwise>
                            <option value="${ruta.nombre}">${ruta.nombre}</option>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
            </select>
        </div>

        <p id="error-msg"
           class="hidden text-red-600 text-base text-center transition-all duration-300 transform origin-top -translate-y-1">
        </p>

        <p id="success-msg"
           class="hidden text-green-600 text-base text-center transition-all duration-300 transform origin-top -translate-y-1">
            Vuelo creado con éxito!
        </p>

        <button type="submit"
                class="w-full px-4 py-2 font-semibold cursor-pointer text-white bg-[var(--azul-oscuro)] rounded-md hover:bg-[var(--azul-medio)] focus:outline-none focus:ring-2 focus:ring-[var(--azul-claro)]">
            Crear Vuelo
        </button>
    </form>
</main>
</body>

<script>

    const fileInput = document.getElementById('image');
    const fileNameSpan = document.getElementById('file-name');
    const formVuelo = document.getElementById('formCrearVuelo');
    const errorMsg = document.getElementById('error-msg');
    const successMsg = document.getElementById('success-msg');

    fileInput.addEventListener('change', () => {
        const file = fileInput.files[0];
        fileNameSpan.textContent = file ? file.name : 'Seleccione una imagen';
    });

    formVuelo.addEventListener('submit', async (e) => {
        e.preventDefault();

        const formData = new FormData(formVuelo);

        errorMsg.textContent = '';
        errorMsg.classList.add('hidden');
        errorMsg.classList.remove('translate-y-0');

        successMsg.classList.add("hidden");
        successMsg.classList.remove("translate-y-0");

        const response = await fetch(`${pageContext.request.contextPath}/vuelo/crear`, {
            method: 'POST',
            body: formData,
        });

        const text = await response.text();

        if (response.ok) {
            successMsg.classList.remove('hidden');
            successMsg.classList.add('translate-y-0');
            e.target.reset();
            fileNameSpan.textContent = 'Seleccione una foto del vuelo *';
        } else {
            errorMsg.textContent = text;
            errorMsg.classList.remove('hidden');
            errorMsg.classList.add('translate-y-0');
        }
    });

</script>


</html>