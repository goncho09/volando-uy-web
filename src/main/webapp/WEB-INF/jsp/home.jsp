<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Volando.uy | Home</title>

    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/globals.css"/>
</head>

<body>

<jsp:include page="components/header.jsp"/>

<div role="status" id="spinner" class="w-full h-[80vh] flex justify-center items-center bg-white">
    <!-- Spinner code -->
</div>

<main id="main-content"
      class="flex flex-col lg:flex-row max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 mt-5 gap-8 hidden">

    <aside class="w-full lg:w-80 space-y-6">
        <jsp:include page="components/miPerfil.jsp"/>

        <div class="px-4">
            <div class="bg-gradient-to-r from-[#1d6e86] to-[#2bc8c8] rounded-2xl shadow-lg p-4 text-white
                        hover:shadow-2xl transition-all duration-300 border border-white/20">

                <div class="flex items-center justify-between">
                    <div class="flex items-center gap-2">
                        <i class="fas fa-sort-alpha-down text-lg"></i>
                        <span class="text-sm font-semibold">Ordenar Alfabéticamente:</span>
                    </div>

                    <a href="?orden=${param.orden == 'desc' ? 'asc' : 'desc'}"
                       class="group relative inline-flex items-center gap-2 bg-gradient-to-r from-[#1e40af] to-[#7c3aed]
          hover:from-[#7c3aed] hover:to-[#1e40af] text-white font-bold px-6 py-3 rounded-xl
          shadow-lg hover:shadow-2xl transform hover:scale-110 transition-all duration-300
          border-2 border-white/30">

                        <c:choose>
                            <c:when test="${param.orden == 'desc'}">
                                <span class="text-lg">Z</span>
                                <i class="fas fa-arrow-down text-sm animate-bounce"></i>
                                <span class="text-lg">A</span>
                            </c:when>
                            <c:otherwise>
                                <span class="text-lg">A</span>
                                <i class="fas fa-arrow-up text-sm animate-bounce"></i>
                                <span class="text-lg">Z</span>
                            </c:otherwise>
                        </c:choose>

                        <!-- Efectito de brillo al pasar el mouse -->
                        <span class="absolute inset-0 rounded-xl bg-white opacity-0 group-hover:opacity-20 transition-opacity duration-300"></span>
                    </a>
                </div>

                <p class="text-xs text-white/90 text-center mt-3 font-medium">
                    Actualmente ordenado:
                    <strong class="text-white">
                        ${param.orden == 'desc' ? 'Z a A' : 'A a Z'}
                    </strong>
                </p>
            </div>
        </div>
    </aside>

    <div class="flex-1">
        <div class="max-w-5xl grid gap-6 grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 mx-auto">
            <c:forEach var="item" items="${resultados}">
                <c:choose>
                    <c:when test="${item.tipo == 'Paquete'}">
                        <c:set var="paquete" value="${item.getPaquete()}" />
                        <!-- TU CÓDIGO DE PAQUETE EXACTO (no lo toco) -->
                        <div class="bg-gradient-to-b from-[#fff] to-[#e8f7ff] rounded-2xl p-2 shadow-md overflow-hidden hover:shadow-xl transition-shadow duration-300 border border-gray-100">
                            <div class="relative h-48 overflow-hidden">
                                <img src="${pageContext.request.contextPath}/assets/packageDefault.png"
                                     alt="${paquete.nombre}"
                                     class="w-full h-full object-cover transform hover:scale-105 transition-transform duration-300"/>
                            </div>
                            <div class="p-4 flex flex-col justify-between h-40">
                                <div>
                                    <h5 class="text-lg font-semibold text-gray-800 mb-1 truncate">${paquete.nombre}</h5>
                                    <c:choose>
                                        <c:when test="${paquete.descuento > 0}">
                                            <b class="text-[#960018] text-xs">Ahorra un ${paquete.descuento}%</b>
                                            <p class="text-gray-600 text-sm">
                                                <b class="text-[#960018] text-sm">
                                                    $${paquete.costo - (paquete.costo * (paquete.descuento / 100))}
                                                </b>
                                                <span class="line-through text-gray-400 text-[0.6rem]">$${paquete.costo}</span>
                                            </p>
                                        </c:when>
                                        <c:otherwise>
                                            <p class="text-gray-600 text-sm">$${paquete.costo}</p>
                                        </c:otherwise>
                                    </c:choose>
                                    <p class="text-gray-600 text-sm mb-3">CantRutas: ${paquete.rutaEnPaquete.size()}</p>
                                </div>
                                <button onclick="window.location.href='${pageContext.request.contextPath}/paquete/consulta?nombre=${paquete.nombre}'"
                                        class="hover:bg-[var(--azul-claro)] w-full text-white py-2 rounded-lg duration-400 bg-[var(--azul-oscuro)]">
                                    Ver Paquete
                                </button>
                            </div>
                        </div>
                    </c:when>
                    <c:when test="${item.tipo == 'Ruta'}">
                        <c:set var="ruta" value="${item.getRuta()}" />
                        <!-- TU CÓDIGO DE RUTA EXACTO (no lo toco) -->
                        <div class="bg-gradient-to-b from-[#fff] to-[#e8f7ff] rounded-2xl p-2 shadow-md overflow-hidden hover:shadow-xl transition-shadow duration-300 border border-gray-100">
                            <div class="relative h-48 overflow-hidden">
                                <img src="${ruta.urlImagen}"
                                     alt="${ruta.nombre}"
                                     class="w-full h-full object-cover transform hover:scale-105 transition-transform duration-300"/>
                            </div>
                            <div class="p-4 flex flex-col justify-between h-40">
                                <div>
                                    <h5 class="text-lg font-semibold text-gray-800 mb-1 truncate">${ruta.nombre}</h5>
                                    <p class="text-sm text-black line-clamp-3">${ruta.descripcionCorta}</p>
                                </div>
                                <button onclick="window.location.href='${pageContext.request.contextPath}/ruta-de-vuelo/buscar?nombre=${ruta.nombre}'"
                                        class="hover:bg-[var(--azul-claro)] w-full text-white py-2 rounded-lg duration-400 bg-[var(--azul-oscuro)]">
                                    Ver Ruta de Vuelo
                                </button>
                            </div>
                        </div>
                    </c:when>
                </c:choose>
            </c:forEach>

            <c:if test="${empty resultados}">
                <div class="col-span-full p-8 text-center">
                    <div class="p-6 rounded-2xl shadow-md bg-gray-100 border border-gray-200 inline-block">
                        <h5 class="text-xl font-semibold text-gray-700">No se encontró ninguna oferta</h5>
                        <p class="text-gray-500 mt-2">Probá con otro término de búsqueda</p>
                    </div>
                </div>
            </c:if>
        </div>
    </div>
</main>

<script>
    window.onload = () => {
        const spinner = document.getElementById('spinner');
        const mainContent = document.getElementById('main-content');
        spinner.classList.add('hidden');
        mainContent.classList.remove('hidden');
    }
</script>

</body>
</html>
