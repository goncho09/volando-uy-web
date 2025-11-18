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
    <svg aria-hidden="true" class="w-8 h-8 text-gray-200 animate-spin dark:text-gray-600 fill-blue-600" viewBox="0 0 100 101" fill="none" xmlns="http://www.w3.org/2000/svg">
        <path d="M100 50.5908C100 78.2051 77.6142 100.591 50 100.591C22.3858 100.591 0 78.2051 0 50.5908C0 22.9766 22.3858 0.59082 50 0.59082C77.6142 0.59082 100 22.9766 100 50.5908ZM9.08144 50.5908C9.08144 73.1895 27.4013 91.5094 50 91.5094C72.5987 91.5094 90.9186 73.1895 90.9186 50.5908C90.9186 27.9921 72.5987 9.67226 50 9.67226C27.4013 9.67226 9.08144 27.9921 9.08144 50.5908Z" fill="currentColor"/>
        <path d="M93.9676 39.0409C96.393 38.4038 97.8624 35.9116 97.0079 33.5539C95.2932 28.8227 92.871 24.3692 89.8167 20.348C85.8452 15.1192 80.8826 10.7238 75.2124 7.41289C69.5422 4.10194 63.2754 1.94025 56.7698 1.05124C51.7666 0.367541 46.6976 0.446843 41.7345 1.27873C39.2613 1.69328 37.813 4.19778 38.4501 6.62326C39.0873 9.04874 41.5694 10.4717 44.0505 10.1071C47.8511 9.54855 51.7191 9.52689 55.5402 10.0491C60.8642 10.7766 65.9928 12.5457 70.6331 15.2552C75.2735 17.9648 79.3347 21.5619 82.5849 25.841C84.9175 28.9121 86.7997 32.2913 88.1811 35.8758C89.083 38.2158 91.5421 39.6781 93.9676 39.0409Z" fill="currentFill"/>
    </svg>
    <span class="sr-only">Loading...</span>
</div>

<main id="main-content" class="flex flex-col items-center md:items-start md:flex-row max-w-7xl md:mx-auto px-4 sm:px-6 lg:px-8 justify-center  mt-5 hidden">
        <!-- Sidebar -->
        <jsp:include page="components/miPerfil.jsp"/>

        <div class="max-w-5xl grid gap-6 grid-cols-1 mt-2 md:m-0 sm:grid-cols-2 lg:grid-cols-4 px-4 py-2">
            <c:if test="${paquete != null}">
                    <div class="p-4 flex flex-col justify-between h-40 rounded-2xl shadow-md hover:shadow-xl transition-shadow duration-300 bg-gray-300 border border-gray-100">
                            <img src="${pageContext.request.contextPath}/assets/packageDefault.png" alt="${paquete.nombre}"
                                 class="w-full h-32 object-cover rounded-lg mb-3"/>
                            <h5 class="text-lg font-semibold text-gray-800 mb-1 truncate">${paquete.nombre}</h5>
                            <p class="text-sm text-black line-clamp-3">${paquete.descripcion}</p>
                            <p class="text-sm text-gray-600 mt-2">Precio: $${paquete.costo}</p>
                            <p class="text-sm text-gray-600">Duración: ${paquete.validezDias} días</p>
                    </div>
            </c:if>
            <c:if test="${ruta != null}">
                <div class="bg-gradient-to-b from-[#fff] to-[#e8f7ff] rounded-2xl p-2 shadow-md overflow-hidden hover:shadow-xl transition-shadow duration-300 bg-gray-300 border border-gray-100">
                    <div class="relative h-48 overflow-hidden">
                        <img src="${ruta.urlImagen}" alt="${ruta.nombre}"
                             class="w-full h-full object-cover transform hover:scale-105 transition-transform duration-300"/>
                    </div>

                    <div class="p-4 flex flex-col justify-between h-40">
                        <div>
                            <h5 class="text-lg font-semibold text-gray-800 mb-1 truncate">${ruta.nombre}</h5>
                            <p class="text-sm text-black line-clamp-3">${ruta.descripcionCorta}</p>
                        </div>

                        <button onclick="window.location.href='${pageContext.request.contextPath}/ruta-de-vuelo/buscar?nombre=${ruta.nombre}'" type="submit" class="hover:bg-[var(--azul-claro)] w-full text-white py-2 rounded-lg duration-400 bg-[var(--azul-oscuro)]">Ver Ruta de Vuelo</button>
                    </div>
                </div>
            </c:if>
            <c:if test="${rutas != null}">
                <c:forEach var="ruta" items="${rutas}">
                    <div class="bg-gradient-to-b from-[#fff] to-[#e8f7ff] rounded-2xl p-2 shadow-md overflow-hidden hover:shadow-xl transition-shadow duration-300 bg-gray-300 border border-gray-100">
                        <div class="relative h-48 overflow-hidden">
                            <img src="${ruta.urlImagen}" alt="${ruta.nombre}"
                                 class="w-full h-full object-cover transform hover:scale-105 transition-transform duration-300"/>
                        </div>

                        <div class="p-4 flex flex-col justify-between h-40">
                            <div>
                                <h5 class="text-lg font-semibold text-gray-800 mb-1 truncate">${ruta.nombre}</h5>
                                <p class="text-sm text-black line-clamp-3">${ruta.descripcionCorta}</p>
                            </div>

                            <button onclick="window.location.href='${pageContext.request.contextPath}/ruta-de-vuelo/buscar?nombre=${ruta.nombre}'" type="submit" class="hover:bg-[var(--azul-claro)] w-full text-white py-2 rounded-lg duration-400 bg-[var(--azul-oscuro)]">Ver Ruta de Vuelo</button>
                        </div>
                    </div>
                </c:forEach>
            </c:if>
            <c:if test="${paquetes != null}">
                <c:forEach var="paquete" items="${paquetes}">
                    <div class="bg-gradient-to-b from-[#fff] to-[#e8f7ff] rounded-2xl p-2 shadow-md overflow-hidden hover:shadow-xl transition-shadow duration-300 bg-gray-300 border border-gray-100">
                        <div class="relative h-48 overflow-hidden">
                            <img src="${pageContext.request.contextPath}/assets/packageDefault.png" alt="${paquete.nombre}"
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
                                            <span class="line-through text-gray-400 text-[0.6rem]">
                                                    $${paquete.costo}
                                            </span>
                                        </p>
                                    </c:when>
                                    <c:otherwise>
                                        <p class="text-gray-600 text-sm">$${paquete.costo}</p>
                                    </c:otherwise>
                                </c:choose>
                                <p class="text-gray-600 text-sm mb-3">CantRutas: ${paquete.rutaEnPaquete.size()}</p>
                            </div>

                            <button onclick="window.location.href='${pageContext.request.contextPath}/paquete/consulta?nombre=${paquete.nombre}'" type="submit" class="hover:bg-[var(--azul-claro)] w-full text-white py-2 rounded-lg duration-400 bg-[var(--azul-oscuro)]">Ver Paquete</button>
                        </div>
                    </div>
                </c:forEach>
            </c:if>
        </div>

    <c:if test="${paquete == null && ruta == null && rutas == null}">
        <div class="p-4 flex flex-col mb-5 justify-between rounded-2xl shadow-md hover:shadow-xl transition-shadow duration-300 bg-gray-300 border border-gray-100">
            <h5 class="text-lg font-semibold text-gray-800 mb-1 truncate">No se encontró ninguna búsqueda.</h5>
        </div>
    </c:if>

</main>
    <script>
        window.onload = ()=>{
            const spinner = document.getElementById('spinner');
            const mainContent = document.getElementById('main-content');
            spinner.classList.add('hidden');
            mainContent.classList.remove('hidden');
        }
    </script>
</body>
</html>
