<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Volando.uy | Buscar vuelo</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet"/>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/globals.css"/>
</head>
<body>

<jsp:include page="../components/header.jsp"/>

<div role="status" id="spinner" class="w-full h-[80vh] flex justify-center items-center bg-white">
    <svg aria-hidden="true" class="w-8 h-8 text-gray-200 animate-spin dark:text-gray-600 fill-blue-600" viewBox="0 0 100 101" fill="none" xmlns="http://www.w3.org/2000/svg">
        <path d="M100 50.5908C100 78.2051 77.6142 100.591 50 100.591C22.3858 100.591 0 78.2051 0 50.5908C0 22.9766 22.3858 0.59082 50 0.59082C77.6142 0.59082 100 22.9766 100 50.5908ZM9.08144 50.5908C9.08144 73.1895 27.4013 91.5094 50 91.5094C72.5987 91.5094 90.9186 73.1895 90.9186 50.5908C90.9186 27.9921 72.5987 9.67226 50 9.67226C27.4013 9.67226 9.08144 27.9921 9.08144 50.5908Z" fill="currentColor"/>
        <path d="M93.9676 39.0409C96.393 38.4038 97.8624 35.9116 97.0079 33.5539C95.2932 28.8227 92.871 24.3692 89.8167 20.348C85.8452 15.1192 80.8826 10.7238 75.2124 7.41289C69.5422 4.10194 63.2754 1.94025 56.7698 1.05124C51.7666 0.367541 46.6976 0.446843 41.7345 1.27873C39.2613 1.69328 37.813 4.19778 38.4501 6.62326C39.0873 9.04874 41.5694 10.4717 44.0505 10.1071C47.8511 9.54855 51.7191 9.52689 55.5402 10.0491C60.8642 10.7766 65.9928 12.5457 70.6331 15.2552C75.2735 17.9648 79.3347 21.5619 82.5849 25.841C84.9175 28.9121 86.7997 32.2913 88.1811 35.8758C89.083 38.2158 91.5421 39.6781 93.9676 39.0409Z" fill="currentFill"/>
    </svg>
    <span class="sr-only">Loading...</span>
</div>


<main id="main-content" class="flex flex-col items-center md:items-start md:flex-row max-w-7xl md:mx-auto px-4 sm:px-6 lg:px-8 justify-center  mt-5 hidden">

    <!-- Sidebar -->
    <jsp:include page="../components/miPerfil.jsp"/>


    <section class="flex flex-col items-center w-full max-w-3xl bg-white p-6 rounded-lg shadow-lg mt-5 md:mt-0 md:ml-5">
        <h2 class="text-2xl font-bold mb-6 text-center text-[#12445d]">Buscar Vuelo</h2>
        <form id="formBuscarVuelo" class="space-y-4 flex flex-col items-center w-full">

            <div class="flex w-full md:w-1/2 items-center border-b border-gray-300 py-2 space-x-3 focus-within:border-[var(--azul-oscuro)]">
                <i class="fa fa-plane icon text-[var(--azul-oscuro)]"></i>
                <select class="flex-grow outline-none bg-transparent text-gray-700 py-2 px-2 rounded focus:bg-gray-100 whitespace-nowrap"
                        id="aerolinea" name="aerolinea" aria-label="Seleccione su aerolinea *" required>
                    <option class="whitespace-nowrap" value="" disabled ${empty aerolineaId ? "selected" : ""}>
                        Seleccione una aerolínea *
                    </option>
                    <c:forEach var="a" items="${aerolineas}">
                        <option value="${a.nickname}" ${a.nickname eq aerolineaId ? "selected" : ""}>
                                ${a.nombre}
                        </option>
                    </c:forEach>
                </select>
            </div>


            <div class="flex w-full md:w-1/2 items-center border-b border-gray-300 py-2 space-x-3 focus-within:border-[var(--azul-oscuro)]">
                <i class="fa fa-route icon text-[var(--azul-oscuro)]"></i>
                <select class="flex-grow outline-none bg-transparent text-gray-700 py-2 px-2 rounded focus:bg-gray-100"
                        id="ruta" name="ruta" aria-label="Seleccione una ruta de vuelo *" required>
                    <option value="" disabled ${empty rutaId ? "selected" : ""}>
                        Seleccione una ruta de vuelo *
                    </option>
                    <c:forEach var="r" items="${rutas}">
                    <option value="${r.nombre}" ${r.nombre eq rutaId ? "selected" : ""}>
                            ${r.nombre}
                    </option>
                    </c:forEach>
                </select>
            </div>

            <div class="flex flex-col w-full md:w-1/2 items-center">
                <label for="fecha" class="block text-base font-medium text-gray-700">Fecha (Opcional)</label>
                <input type="date" name="fecha"
                       class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500 sm:text-sm"/>
            </div>

            <button type="submit"
                    class="hover:bg-[var(--azul-claro)] w-full md:w-1/2 text-white py-2 rounded-lg duration-400 bg-[var(--azul-oscuro)] mt-2">
                <i class="fa fa-search mr-2"></i> Ver Vuelos
            </button>

        </form>

        <c:if test="${aerolineaId != null && rutaId != null && empty vuelos}">
            <p class="text-sm text-center text-red-600 mb-1 mt-2">No se encontraron vuelos para la aerolínea y ruta seleccionadas.</p>
        </c:if>

        <div id="vuelosContainer" class="flex flex-col w-full md:w-1/2 items-center border-b border-gray-300 mt-3 py-2 space-x-3 ${empty vuelos ? "hidden" : ""}">
            <div class="flex space-x-1 w-full items-center">
                <i class="fa fa-route icon text-[var(--azul-oscuro)]"></i>
            <select class="flex-grow max-w-full outline-none bg-transparent text-gray-700 py-2 px-2 rounded focus:bg-gray-100"
                    id="vuelos" name="vuelos" aria-label="Seleccione un vuelo" required>
                <option value="" disabled selected>Seleccione un vuelo para ver su información </option>

                <c:forEach var="vuelo" items="${vuelos}">
                    <option value="${vuelo.nombre}">${vuelo.nombre}</option>
                </c:forEach>
            </select>
            </div>


            <button id="verInfoBtn" type="submit" onclick="window.location.href='${pageContext.request.contextPath}/vuelo/consulta?nombre=' + document.getElementById('vuelos').value"
                    class="mt-2 hover:bg-[var(--azul-claro)] w-full  text-white py-2 rounded-lg duration-400 hidden bg-[var(--azul-oscuro)] mt-2 ${empty vuelos ? "hidden" : ""}">
                <i class="fa fa-info mr-2"></i> Ver información del vuelo
            </button>
        </div>
    </section>
</main>
</body>

<script>
    document.addEventListener('DOMContentLoaded', () => {
        const spinner = document.getElementById('spinner');
        const mainContent = document.getElementById('main-content');
        const vuelosSelect = document.getElementById('vuelos');
        spinner.classList.add('hidden');
        mainContent.classList.remove('hidden');

        const form = document.getElementById('formBuscarVuelo');
        const aerolineaSelect = document.getElementById('aerolinea');

        aerolineaSelect.addEventListener('change', function(e) {
            const aerolinea = e.target.value;
            if (aerolinea) {
                window.location.href = '${pageContext.request.contextPath}/vuelo/buscar?aerolinea=' + aerolinea;
            }
        });

        form.addEventListener('submit', function(event) {
            const ruta = document.getElementById('ruta').value;
            const fecha = document.querySelector('input[name="fecha"]').value;
            const aerolinea = document.getElementById('aerolinea').value;

            if (!aerolinea || !ruta) {
                event.preventDefault();
                alert("Debes completar todos los campos antes de buscar vuelos.");
                return;
            }

            window.location.href = '${pageContext.request.contextPath}/vuelo/buscar?aerolinea='
                + aerolinea + '&ruta=' + ruta + '&fecha=' + fecha;
        });

        vuelosSelect.addEventListener('change', function() {
            const verInfoBtn = document.getElementById('verInfoBtn');
            if (vuelosSelect.value) {
                verInfoBtn.classList.remove('hidden');
            } else {
                verInfoBtn.classList.add('hidden');
            }
        });
    });
</script>
</html>
