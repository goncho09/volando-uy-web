<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Volando.uy | Ver paquete</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet"/>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/globals.css"/>
</head>
<body>

<jsp:include page="../components/header.jsp"/>


<main id="main-content"
      class="flex flex-col items-center md:items-start md:flex-row max-w-7xl md:mx-auto px-4 sm:px-6 lg:px-8 justify-center  mt-5">

    <!-- Sidebar -->
    <jsp:include page="../components/miPerfil.jsp"/>

    <section class="flex flex-col items-center w-full max-w-3xl bg-white p-6 rounded-lg shadow-lg mt-5 md:mt-0 md:ml-5">
        <!-- Carta de Paquete -->
        <div class="bg-white rounded-2xl shadow-xl overflow-hidden card-hover border border-gray-100">
            <!-- Encabezado con imagen y título -->
            <div class="relative">
                <div class="h-28 bg-gradient-to-r from-[#0c2636] to-[#12445d] flex flex-col items-center justify-center text-center text-white p-4">
                    <h1 class="text-3xl font-bold mb-2">Paquete de Viaje</h1>
                    <p class="text-lg opacity-90">Disfruta de una experiencia única con nuestras rutas seleccionadas</p>
                </div>
            </div>

            <!-- Contenido principal -->
            <div class="p-6 md:p-8">
                <h2 class="text-xl font-bold text-[#12445d] mb-4 flex items-center">
                    <i class="fas fa-info-circle mr-2"></i> Información del Paquete
                </h2>
                <!-- Información general del paquete -->
                <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
                    <!-- Columna 1: Detalles principales -->
                    <div class="md:col-span-2">
                        <div class="mb-6">
                            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                                <div class="bg-gray-50 p-4 rounded-lg">
                                    <p class="text-sm text-gray-500">Nombre</p>
                                    <p class="font-semibold text-[#0c2636]">${paquete.nombre}</p>
                                </div>
                                <div class="bg-gray-50 p-4 rounded-lg">
                                    <p class="text-sm text-gray-500">Días de Validez</p>
                                    <p class="font-semibold text-[#0c2636]">${paquete.validezDias} días</p>
                                </div>
                                <c:choose>
                                    <c:when test="${paquete.descuento > 0}">
                                        <div class="bg-gray-50 p-4 rounded-lg">
                                            <p class="text-sm text-gray-500">Costo Original</p>
                                            <p class="font-semibold text-gray-400 line-through">$${paquete.costo} USD</p>
                                        </div>
                                        <div class="bg-gray-50 p-4 rounded-lg">
                                            <p class="text-sm text-gray-500">Precio con Descuento</p>
                                            <p class="font-semibold text-[#960018] text-lg">$${paquete.costo - (paquete.costo * (paquete.descuento / 100))} (-${paquete.descuento}%)</p>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="bg-gray-50 p-4 rounded-lg col-span-2">
                                            <p class="text-sm text-gray-500">Costo</p>
                                            <p class="font-semibold text-gray-400">$${paquete.costo} USD</p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <div>
                            <h2 class="text-xl font-bold text-[#12445d] mb-4 flex items-center">
                                <i class="fas fa-map-marked-alt mr-2"></i> Descripción
                            </h2>
                            <p class="text-gray-600 bg-gray-50 p-4 rounded-lg">
                                ${paquete.descripcion}
                            </p>
                        </div>
                    </div>

                    <!-- Columna 2: Resumen de precios -->
                    <div class="bg-[#f8fafc] border border-gray-200 rounded-xl p-5 h-fit">
                        <h3 class="text-lg font-bold text-[#12445d] mb-4 text-center">Resumen de Precios</h3>
                        <c:choose>
                            <c:when test="${paquete.descuento > 0}">
                                <div class="space-y-3 mb-4">
                                    <div class="flex justify-between">
                                        <span class="text-gray-600">Precio base:</span>
                                        <span class="font-medium">$${paquete.costo}</span>
                                    </div>
                                    <div class="flex justify-between text-[#960018]">
                                        <span>Descuento:</span>
                                        <span class="font-medium">-$${String.format("%.2f", (paquete.costo * (paquete.descuento / 100)))}</span>
                                    </div>
                                    <div class="border-t border-gray-300 pt-2 flex flex-col items-center font-bold text-lg">
                                        <span class="text-[#12445d]">Total:</span>
                                        <span class="text-[#960018]">$${paquete.costo - (paquete.costo * (paquete.descuento / 100))} USD</span>
                                    </div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="space-y-3 mb-4">
                                    <div class="flex justify-between">
                                        <span class="text-gray-600">Precio:</span>
                                        <span class="font-medium">$${paquete.costo}</span>
                                    </div>
                                    <div class="flex justify-between">
                                    </div>
                                    <div class="border-t border-gray-300 pt-2 flex flex-col items-center font-bold text-base">
                                        <span class="text-[#12445d]">Total:</span>
                                        <span>$${paquete.costo} USD</span>
                                    </div>
                                </div>
                            </c:otherwise>
                        </c:choose>
                        <div class="text-center mt-6">
                        <c:choose>
                            <c:when test="${not empty sessionScope.usuarioTipo && sessionScope.usuarioTipo eq 'cliente'}">
                                <c:choose>
                                    <c:when test="${comprado}">
                                        <button class="bg-gray-400 text-white font-bold p-3 rounded-lg w-full justify-around transition-colors duration-300 flex items-center justify-center disabled">
                                            <i class="fa-solid fa-circle-xmark"></i> Paquete no disponible
                                        </button>
                                    </c:when>
                                    <c:otherwise>
                                        <button class="bg-[#12445d] hover:bg-[#0c2636] text-white font-bold p-3 rounded-lg w-full transition-colors duration-300 flex items-center justify-center"
                                        onclick="window.location.href='${pageContext.request.contextPath}/paquete/comprar?nombre=${paquete.nombre}'">
                                            <i class="fas fa-shopping-cart mr-2"></i> Comprar
                                        </button>
                                        <p class="text-xs text-gray-500 mt-2">Compra segura · Sin devoluciones.</p>
                                    </c:otherwise>
                                </c:choose>

                            </c:when>
                            <c:when test="${not empty sessionScope.usuarioTipo && sessionScope.usuarioTipo eq 'aerolinea'}">
                                    <p class="text-base text-gray-500 mt-2">Inicia sesion como cliente para comprar un paquete.</p>
                            </c:when>
                            <c:otherwise>
                                    <p class="text-base text-gray-500 mt-2">Debes iniciar sesion para comprar un paquete.</p>
                            </c:otherwise>
                        </c:choose>
                        </div>
                    </div>
                </div>

                <!-- Rutas incluidas -->
                <div class="mt-8">
                    <h2 class="text-2xl font-bold mb-6 text-[#12445d] text-center flex items-center justify-center">
                        <i class="fas fa-route mr-3"></i> Rutas Incluidas en el Paquete
                    </h2>

                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
                        <c:forEach var="ruta" items="${paquete.rutaEnPaquete}">
                            <!-- Ruta 1 -->
                            <div class="bg-white border border-gray-200 rounded-xl overflow-hidden shadow-md hover:shadow-lg transition-all duration-300 card-hover cursor-pointer"
                                 onclick="window.location.href='${pageContext.request.contextPath}/ruta-de-vuelo/buscar?nombre=${ruta.rutaDeVuelo.nombre}'">
                                <div class="h-40 flex items-center justify-center">
                                    <img src="${ruta.rutaDeVuelo.urlImagen}" alt="${ruta.rutaDeVuelo.nombre}"
                                         class="w-full h-full object-cover transform hover:scale-105 transition-transform duration-300"/>
                                </div>
                                <div class="p-4">
                                    <h3 class="font-bold text-[#0c2636] mb-2">${ruta.rutaDeVuelo.nombre}</h3>
                                    <c:choose>
                                        <c:when test="${ruta.tipoAsiento.toString() eq 'EJECUTIVO'}">
                                            <div class="flex items-center text-sm text-gray-600 mb-2">
                                                <i class="fa fa-couch text-[var(--azul-oscuro)] mr-2"></i>
                                                <span>Clase Ejecutiva</span>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="flex items-center text-sm text-gray-600 mb-2">
                                                <i class="fas fa-chair text-[var(--azul-oscuro)] mr-2"></i>
                                                <span>Clase Turista</span>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                    <div class="flex items-center text-sm text-gray-600">
                                        <i class="fas fa-ticket-alt mr-2"></i>
                                        <span>${ruta.cantidad} pasajes incluidos</span>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </div>
    </section>
</main>
</body>
</html>
