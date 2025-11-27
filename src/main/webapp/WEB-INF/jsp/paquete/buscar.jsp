<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Volando.uy | Buscar ruta en paquete</title>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet"/>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/globals.css"/>
</head>
<body>

<jsp:include page="../components/header.jsp"/>


<main id="main-content" class="flex flex-col items-center md:items-start md:flex-row max-w-7xl md:mx-auto px-4 sm:px-6 lg:px-8 justify-center  mt-5">

    <!-- Sidebar -->
    <jsp:include page="../components/miPerfil.jsp"/>

    <section class="flex flex-col items-center w-full max-w-3xl bg-white p-6 rounded-lg shadow-lg mt-5 md:mt-0 md:ml-5">
        <h2 class="text-2xl font-bold mb-6 text-center text-[#12445d]">Buscar Paquete</h2>

            <div class="flex w-full md:w-1/2 items-center border-b border-gray-300 py-2 space-x-3 focus-within:border-[var(--azul-oscuro)]">
                <i class="fa fa-box icon text-[var(--azul-oscuro)]"></i>
                <select class="flex-grow outline-none bg-transparent text-gray-700 py-2 px-2 rounded focus:bg-gray-100 whitespace-nowrap"
                        id="paquetesSelect" name="paquete" aria-label="Seleccione su paquete *" required>
                    <option class="whitespace-nowrap" value="" disabled selected>
                        Seleccione un paquete *
                    </option>
                    <c:forEach var="p" items="${paquetes}">
                        <option value="${p.nombre}" ${p.nombre}>
                                ${p.nombre}
                        </option>
                    </c:forEach>
                </select>
            </div>

            <button id="verInfoBtn" type="submit"
                    class="mt-2 hover:bg-[var(--azul-claro)] w-full md:w-1/2  text-white py-2 rounded-lg duration-400 hidden bg-[var(--azul-oscuro)] mt-3 hidden">
                <i class="fa fa-info mr-2"></i> Ver información del paquete
            </button>
    </section>
</main>
</body>
<script defer>
    const paquetesSelect = document.getElementById('paquetesSelect');
    const verInfoPaqueteBtn = document.getElementById('verInfoBtn');

    paquetesSelect.addEventListener('change', function () {
        if (paquetesSelect.value) {
            verInfoPaqueteBtn.classList.remove('hidden');
        } else {
            verInfoPaqueteBtn.classList.add('hidden');
        }
    });

    verInfoPaqueteBtn.addEventListener('click', function () {
        const selectedPaquete = paquetesSelect.value;
        if (selectedPaquete) {
            window.location.href = '${pageContext.request.contextPath}/paquete/consulta?nombre=' + selectedPaquete;
        }
    });
</script>
</html>
