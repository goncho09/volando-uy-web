<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Volando.uy | Ver reservas</title>

<script src="https://cdn.tailwindcss.com"></script>   <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/globals.css"/>
    <link rel="icon" href="${pageContext.request.contextPath}/favicon.ico?v=2" type="image/x-icon">

</head>

<body>

<jsp:include page="../components/header.jsp"/>

<c:set var="tipoUsuario" value="${sessionScope.tipoUsuario}"/>

<main class="flex flex-col items-center md:items-start md:flex-row max-w-7xl md:mx-auto px-4 sm:px-6 lg:px-8 justify-center  mt-5">

    <section class="flex flex-col w-full bg-white p-6 rounded-lg shadow-lg mt-5 md:mt-0 md:ml-5">

        <c:if test="${empty reservas}">
            <div class="mb-4 p-4 rounded-lg text-white bg-red-500">
                <p class="text-center">No hay reservas.</p>
            </div>
        </c:if>

        <c:if test="${not empty reservas}">
            <div class="w-full overflow-x-auto">
                <table class="min-w-full border border-gray-200 rounded-lg shadow-sm text-sm md:text-base">
                    <thead class="bg-[var(--azul-oscuro)] text-white">
                    <tr>
                        <th class="px-4 py-2 text-center">Cantidad pasajes</th>
                        <th class="px-4 py-2 text-center">Costo total</th>
                        <th class="px-4 py-2 text-center">Fecha de reserva</th>
                        <th class="px-4 py-2 text-center">Equipaje extra</th>
                        <th class="px-4 py-2 text-center">Tipo de asiento</th>
                        <th class="px-4 py-2 text-center">Vuelo</th>
                        <th class="px-4 py-2 text-center">Método de pago</th>

                        <c:if test="${usuarioTipo != null && usuarioTipo == 'aerolinea'}">
                            <th class="px-4 py-2 text-center">Cliente</th>
                        </c:if>

                        <th class="px-4 py-2 text-center">Acciones</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="reserva" items="${reservas}">
                        <tr class="border-t border-[var(--azul-oscuro)] cursor-pointer hover:bg-blue-200"
                            onclick="window.location='${pageContext.request.contextPath}/reservas/consulta?vuelo=${reserva.vuelo.nombre}&fecha=${reserva.fecha}'">
                            <td class="px-4 py-2 text-center">${reserva.cantPasajes}</td>
                            <td class="px-4 py-2 text-center">$${reserva.costo}</td>
                            <td class="px-4 py-2 text-center">${reserva.fecha}</td>
                            <td class="px-4 py-2 text-center">${reserva.equipajeExtra}</td>
                            <td class="px-4 py-2 text-center">${reserva.tipoAsiento}</td>
                            <td class="px-4 py-2 text-center">${reserva.vuelo.nombre}</td>
                            <td class="px-4 py-2 text-center">${reserva.metodoPago}</td>

                            <c:if test="${usuarioTipo != null && usuarioTipo == 'aerolinea'}">
                                <th class="px-4 py-2 text-center">${reserva.cliente}</th>
                            </c:if>

                            <td class="text-center px-4 py-2" onclick="event.stopPropagation();">
                                <c:choose>
                                    <c:when test="${reserva.checkin}">
                                        <!-- Ya tiene check-in hecho → solo icono de confirmado (verde o rojo, vos elegís) -->
                                        <span class="inline-block" title="Check-in realizado">
                <i class="fa-solid fa-file-circle-check" style="color: #e23c12;" class="text-2xl"></i>
            </span>
                                    </c:when>
                                    <c:otherwise>
                                        <!-- Aún no tiene check-in → solo el ojo para entrar y hacerlo -->
                                        <a href="${pageContext.request.contextPath}/reservas/consulta?vuelo=${reserva.vuelo.nombre}&fecha=${reserva.fecha}"
                                           class="hover:scale-110 transition-transform inline-block"
                                           title="Realizar check-in">
                                            <i class="fa-solid fa-eye" style="color: #74C0FC;" class="text-2xl"></i>
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:if>


    </section>
</main>

<style>
    :root {
        --azul-oscuro: #0c2636;
        --azul-medio: #12445d;
        --azul-claro: #1d6e86;
        --celeste: #269fb8;
        --celeste-claro: #2bc8c8;
    }
</style>

</body>
</html>
