<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Volando.uy | Ver vuelo</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="icon" href="${pageContext.request.contextPath}/favicon.ico?v=2" type="image/x-icon">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/globals.css">
</head>

<body>

<c:set var="tipoUsuario" value="${sessionScope.tipoUsuario}" />

 <jsp:include page="../components/header.jsp" />

 <main class="flex flex-col items-center md:items-start md:flex-row max-w-7xl md:mx-auto px-4 sm:px-6 lg:px-8 justify-center  mt-5">
     <!-- Sidebar -->
     <jsp:include page="../components/miPerfil.jsp"/>


     <section class="flex flex-col md:flex-row bg-white w-full my-5 md:m-0 md:ml-8 justify-center md:justify-center md:space-x-2  rounded-xl shadow-2xl">
             <div class="lg:w-2/5 w-full md:w-1/2">
                 <img src="${vuelo.urlImage}"
                      alt="Imagen del vuelo"
                      class="w-full h-64 lg:h-full object-cover">
             </div>

             <div class="flex items-center w-full md:w-1/2 flex-col py-3 mb-2">
                 <h5 class="text-xl font-bold text-[#0c2636] mb-2 flex items-center">
                     <i class="fas fa-plane-departure mr-2 text-[#1d6e86]"></i>
                     Detalles del vuelo
                 </h5>

                 <h2 class="text-2xl font-bold text-[#12445d] mb-4">${vuelo.nombre}</h2>

                 <div class="grid grid-cols-1 gap-4 mb-4">
                     <div class="flex items-center">
                         <i class="fas fa-calendar-alt text-[#1d6e86] mr-2"></i>
                         <span class="font-semibold text-[#0c2636]">Fecha:</span>
                         <span class="ml-2 text-gray-700">${vuelo.fecha}</span>
                     </div>
                     <div class="flex items-center">
                         <i class="fas fa-clock text-[#1d6e86] mr-2"></i>
                         <span class="font-semibold text-[#0c2636]">Hora de salida:</span>
                         <span class="ml-2 text-gray-700">${vuelo.duracion} hrs</span>
                     </div>
                     <div class="flex items-center">
                         <i class="fas fa-users text-[#1d6e86] mr-2"></i>
                         <span class="font-semibold text-[#0c2636]">Capacidad Turista:</span>
                         <span class="ml-2 text-gray-700">${vuelo.maxTuristas}</span>
                     </div>
                     <div class="flex items-center">
                         <i class="fas fa-briefcase text-[#1d6e86] mr-2"></i>
                         <span class="font-semibold text-[#0c2636]">Capacidad Ejecutiva:</span>
                         <span class="ml-2 text-gray-700">${vuelo.maxEjecutivos}</span>
                     </div>
                     <div class="flex items-center">
                         <i class="fas fa-ticket-alt text-[#1d6e86] mr-2"></i>
                         <span class="font-semibold text-[#0c2636]">Cantidad reservas:</span>
                         <span class="ml-2 text-gray-700">${vuelo.cantReservas}</span>
                     </div>

                     <c:if test="${usuarioTipo == 'aerolinea' && esDeLaAerolinea}">
                         <button onclick="window.location.href='${pageContext.request.contextPath}/reservas/ver'" type="submit" class="hover:bg-[var(--azul-claro)] w-full text-white py-2 rounded-lg duration-400 bg-[var(--azul-oscuro)]">Ver reservas del vuelo</button>
                     </c:if>

                     <c:if test="${usuarioTipo == 'cliente' && tieneReserva}">
                         <button onclick="window.location.href='${pageContext.request.contextPath}/reservas/ver'" type="submit" class="hover:bg-[var(--azul-claro)] w-full text-white py-2 rounded-lg duration-400 bg-[var(--azul-oscuro)]">Ver mis reservas</button>
                     </c:if>

                     <c:if test="${usuarioTipo == 'cliente'}">
                         <button onclick="window.location.href='${pageContext.request.contextPath}/reservas/crear'" type="submit" class="hover:bg-[var(--azul-claro)] w-full text-white py-2 rounded-lg duration-400 bg-[var(--azul-oscuro)]">Hacer reserva</button>
                     </c:if>

                     <button onclick="window.location.href='${pageContext.request.contextPath}/ruta-de-vuelo/buscar?nombre=${ruta.nombre}'" type="submit" class="hover:bg-[var(--azul-claro)] w-full text-white p-2 rounded-lg duration-400 bg-[var(--azul-oscuro)]"><i class="fa fa-info mr-2"></i> Ver información de la ruta de vuelo</button>
                 </div>
             </div>
     </section>
 </main>
</body>
</html>
