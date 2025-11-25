<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Rutas de vuelo</title>

    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/globals.css"/>

</head>

<body>

<jsp:include page="../components/header.jsp"/>

<div class="container mx-auto px-4 py-8">
    <div class="flex flex-col lg:flex-row gap-6">

        <!-- Sidebar -->
        <jsp:include page="../components/miPerfil.jsp"/>

        <main class="flex-1">
            <div class="bg-white rounded-xl shadow-2xl overflow-hidden mb-8">
                <div class="flex flex-col lg:flex-row">
                    <div class="lg:w-2/5">
                        <img src="${ruta.urlImagen}"
                             alt="Rio de Janeiro"
                             class="w-full h-64 lg:h-full object-cover">
                    </div>

                    <div class="lg:w-3/5 p-6 lg:p-8">
                        <h5 class="text-xl font-bold text-[#0c2636] mb-2 flex items-center">
                            <i class="fas fa-route mr-2 text-[#1d6e86]"></i>
                            Ruta de vuelo
                        </h5>
                        <h2 class="text-2xl font-bold text-[#12445d] mb-4">${ruta.nombre}</h2>
                        <p class="text-gray-700 mb-4">${ruta.descripcion}</p>

                        <div class="grid grid-cols-1 gap-4 mb-4">
                            <div class="flex items-center">
                                <i class="fas fa-map-marker-alt text-[#1d6e86] mr-2"></i>
                                <span class="font-semibold text-[#0c2636]">Origen:</span>
                                <span class="ml-2 text-gray-700">${ruta.ciudadOrigen.nombre}</span>
                            </div>
                            <div class="flex items-center">
                                <i class="fas fa-map-marker-alt text-[#1d6e86] mr-2"></i>
                                <span class="font-semibold text-[#0c2636]">Destino:</span>
                                <span class="ml-2 text-gray-700">${ruta.ciudadDestino.nombre}</span>
                            </div>
                            <div class="flex items-center">
                                <i class="fas fa-clock text-[#1d6e86] mr-2"></i>
                                <span class="font-semibold text-[#0c2636]">Duración:</span>
                                <span class="ml-2 text-gray-700">${ruta.duracion} hrs</span>
                            </div>
                            <div class="flex items-center">
                                <i class="fas fa-calendar-alt text-[#1d6e86] mr-2"></i>
                                <span class="font-semibold text-[#0c2636]">Fecha de alta:</span>
                                <span class="ml-2 text-gray-700">${ruta.fechaAlta}</span>
                            </div>
                        </div>

                       <!-- Video de la ruta (si existe) -->
                       <!-- Video de la ruta (si existe) -->
                       <c:if test="${not empty ruta.urlVideo}">
                           <div class="border-t border-gray-200 pt-4 mb-4">
                               <h6 class="font-bold text-[#0c2636] mb-3 flex items-center">
                                   <i class="fas fa-video mr-2 text-[#1d6e86]"></i>
                                   Video de la Ruta
                               </h6>
                               <div class="relative pb-[56.25%] h-0 overflow-hidden rounded-lg shadow-md">
                                   <%
                                       String urlVideo = ((uy.volando.soap.client.DtRuta)request.getAttribute("ruta")).getUrlVideo();
                                       if (urlVideo != null && urlVideo.contains("youtube.com/watch?v=")) {
                                           urlVideo = urlVideo.replace("watch?v=", "embed/");
                                       } else if (urlVideo != null && urlVideo.contains("youtu.be/")) {
                                           urlVideo = urlVideo.replace("youtu.be/", "youtube.com/embed/");
                                       }
                                   %>
                                   <iframe
                                       class="absolute top-0 left-0 w-full h-full"
                                       src="<%= urlVideo %>"
                                       frameborder="0"
                                       allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                                       allowfullscreen>
                                   </iframe>
                               </div>
                           </div>
                       </c:if>

                        <div class="border-t border-gray-200 pt-4 mb-4">
                            <h6 class="font-bold text-[#0c2636] mb-2">Costos (USD):</h6>
                            <div class="grid grid-cols-1 md:grid-cols-3 gap-3">
                                <div class="bg-blue-50 rounded-lg p-3 text-center">
                                    <p class="text-sm text-[#12445d]">Turista</p>
                                    <p class="font-bold text-lg text-[#0c2636]">$${ruta.costoTurista}</p>
                                </div>
                                <div class="bg-blue-100 rounded-lg p-3 text-center">
                                    <p class="text-sm text-[#12445d]">Ejecutivo</p>
                                    <p class="font-bold text-lg text-[#0c2636]">$${ruta.costoEjecutivo}</p>
                                </div>
                                <div class="bg-blue-50 rounded-lg p-3 text-center">
                                    <p class="text-sm text-[#12445d]">Equipaje Extra</p>
                                    <p class="font-bold text-lg text-[#0c2636]">$${ruta.equipajeExtra}</p>
                                </div>
                            </div>
                        </div>

                        <div class="flex items-center mb-4">
                            <span class="font-semibold text-[#0c2636] mr-2">Estado:</span>
                            <span class="px-3 py-1 bg-green-100 text-green-800 rounded-full text-sm font-medium">${ruta.estado}</span>
                        </div>

                        <div class="flex flex-wrap gap-2">
                            <span class="font-semibold text-[#0c2636]">Categorías:</span>
                            <c:if test="${not empty ruta.categorias}">
                                <c:forEach var="categoria" items="${ruta.categorias}">
                                    <a href="${pageContext.request.contextPath}/home?nombre=${categoria.nombre}" class="px-3 py-1 bg-[#e8f7ff] text-[#1d6e86] rounded-full text-sm hover:bg-[#2bc8c8] hover:text-white transition-colors">${categoria.nombre}</a>
                                </c:forEach>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>

            <section class="vuelos">
                <div class="bg-white rounded-xl shadow-2xl p-6 mb-8">
                    <h5 class="text-xl font-bold text-[#0c2636] mb-6 flex items-center">
                        <i class="fas fa-plane mr-2 text-[#1d6e86]"></i>
                        VUELOS DISPONIBLES
                    </h5>
                    <c:choose>
                        <c:when test="${not empty vuelos}">
                            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mb-6">
                                <c:forEach var="vuelo" items="${vuelos}">
                                    <div class="bg-white rounded-lg shadow-md overflow-hidden border border-gray-200 hover:shadow-lg transition-shadow duration-300">
                                        <img src="${vuelo.urlImage}"
                                             alt="Esto es una imagen de vuelo"
                                             class="w-full h-40 object-cover">
                                        <div class="p-4">
                                            <h6 class="font-bold text-[#0c2636] mb-2">${vuelo.nombre}</h6>
                                            <p class="text-gray-600 text-sm">Fecha: ${vuelo.fecha}</p>
                                            <p class="text-gray-600 text-sm mb-4">Hora de Salida: ${vuelo.duracion} hrs</p>
                                            <button class="w-full bg-gradient-to-r from-[#1d6e86] to-[#2bc8c8] text-white py-2 rounded-lg font-medium hover:from-[#12445d] hover:to-[#269fb8] transition-all duration-300"
                                                    onclick="window.location.href='${pageContext.request.contextPath}/vuelo/consulta?nombre=${vuelo.nombre}'">
                                                Ver vuelo
                                            </button>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-8">
                                <i class="fas fa-plane-slash text-4xl text-gray-400 mb-4"></i>
                                <p class="text-gray-600">Esta ruta no tiene vuelos disponibles</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                    <c:if test="${rutaOwner}">
                        <div class="text-center mt-6">
                            <button class="bg-gradient-to-r from-[#12445d] to-[#0c2636] text-white px-6 py-3 rounded-lg font-medium hover:from-[#0c2636] hover:to-[#12445d] transition-all duration-300 flex items-center justify-center mx-auto"
                                onclick="window.location.href='${pageContext.request.contextPath}/vuelo/crear?ruta=${ruta.nombre}'">
                                <i class="fas fa-plus-circle mr-2"></i>
                                Agregar Vuelo
                            </button>
                        </div>
                    </c:if>
                </div>
            </section>

            <section class="paquetes">
                <div class="bg-white rounded-xl shadow-2xl p-6">
                    <h5 class="text-xl font-bold text-[#0c2636] mb-6 flex items-center">
                        <i class="fa-solid fa-boxes-packing mr-2 text-[#1d6e86]"></i>
                        PAQUETES DISPONIBLES
                    </h5>
                    <c:choose>
                        <c:when test="${not empty paquetes}">
                            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mb-6">
                                <c:forEach var="paquete" items="${paquetes}">
                                    <div class="bg-white rounded-lg shadow-md overflow-hidden border border-gray-200 hover:shadow-lg transition-shadow duration-300">
                                        <img src="${pageContext.request.contextPath}/assets/packageDefault.png"
                                             alt="Esto es una imagen de paquete"
                                             class="w-full h-40 object-cover">
                                        <div class="p-4">
                                            <h6 class="font-bold text-[#0c2636] mb-2">${paquete.nombre}</h6>
                                            <c:choose>
                                                <c:when test="${paquete.descuento > 0}">
                                                    <b class="text-[#960018] text-xs">Ahorra
                                                        un ${paquete.descuento}%</b>
                                                    <p class="text-gray-600 text-sm">
                                                        Costo (USD):
                                                        <b class="text-[#960018] text-sm">
                                                            $${paquete.costo - (paquete.costo * (paquete.descuento / 100))}
                                                        </b>
                                                        <span class="line-through text-gray-400 text-[0.6rem]">
                                                            $${paquete.costo}
                                                        </span>
                                                    </p>
                                                </c:when>
                                                <c:otherwise>
                                                    <p class="text-gray-600 text-sm">Costo (USD): $${paquete.costo}</p>
                                                </c:otherwise>
                                            </c:choose>

                                            <button class="w-full bg-gradient-to-r from-[#1d6e86] to-[#2bc8c8] text-white py-2 rounded-lg font-medium hover:from-[#12445d] hover:to-[#269fb8] transition-all duration-300"
                                                    onclick="window.location.href='${pageContext.request.contextPath}/paquete/consulta?nombre=${paquete.nombre}'">
                                                Ver paquete
                                            </button>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-8">
                                <i class="fa-solid fa-square-xmark text-4xl text-gray-400 mb-4"></i>
                                <p class="text-gray-600">Esta ruta no tiene paquetes disponibles</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                    <c:if test="${rutaOwner}">
                        <div class="text-center mt-6">
                            <button class="bg-gradient-to-r from-[#12445d] to-[#0c2636] text-white px-6 py-3 rounded-lg font-medium hover:from-[#0c2636] hover:to-[#12445d] transition-all duration-300 flex items-center justify-center mx-auto">
                                <i class="fas fa-plus-circle mr-2"></i>
                                Crear Paquete
                            </button>
                        </div>
                    </c:if>
                </div>
            </section>
        </main>
    </div>
</div>
</body>

</html>