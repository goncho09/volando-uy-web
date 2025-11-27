<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Volando.uy | Detalle de Reserva</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/globals.css"/>
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
</head>
<body class="bg-gradient-to-b from-blue-900 to-blue-700 min-h-screen">

<jsp:include page="../components/header.jsp"/>

<main class="flex justify-center mt-10 px-4">
    <section class="bg-white rounded-2xl shadow-2xl p-8 w-full max-w-3xl">

        <c:if test="${empty reserva}">
            <div class="text-center py-10">
                <p class="text-3xl text-red-600 font-bold">Reserva no encontrada</p>
            </div>
        </c:if>

        <c:if test="${not empty reserva}">
            <h2 class="text-4xl font-bold text-center mb-8 text-[var(--azul-oscuro)]">
                <i class="fas fa-ticket-alt mr-3"></i>Detalle de Reserva
            </h2>

            <div class="space-y-6 text-lg">
                <div class="flex items-center space-x-3">
                    <i class="fas fa-plane-departure text-2xl text-[var(--azul-oscuro)]"></i>
                    <p><strong>Vuelo:</strong> <a href="${pageContext.request.contextPath}/vuelo/consulta?nombre=${reserva.vuelo.nombre}"
                                                  class="text-blue-600 hover:underline">${reserva.vuelo.nombre}</a></p>
                </div>

                <div class="flex items-center space-x-3">
                    <i class="fas fa-chair text-2xl text-[var(--azul-oscuro)]"></i>
                    <p><strong>Tipo de asiento:</strong> ${reserva.tipoAsiento}</p>
                </div>

                <div class="flex items-center space-x-3">
                    <i class="fas fa-dollar-sign text-2xl text-[var(--azul-oscuro)]"></i>
                    <p><strong>Costo total:</strong> $${reserva.costo}</p>
                </div>

                <div class="flex items-center space-x-3">
                    <i class="fas fa-calendar text-2xl text-[var(--azul-oscuro)]"></i>
                    <p><strong>Fecha reserva:</strong> ${reserva.fecha}</p>
                </div>

                <div class="flex items-center space-x-3">
                    <i class="fas fa-users text-2xl text-[var(--azul-oscuro)]"></i>
                    <p><strong>Pasajeros (${reserva.cantPasajes}):</strong></p>
                </div>
                <div class="ml-12 space-y-2">
                    <c:forEach var="pasajero" items="${reserva.pasajeros}">
                        <div class="flex items-center space-x-2">
                            <i class="fas fa-user text-gray-600"></i>
                            <span>${pasajero.nombre} ${pasajero.apellido}</span>
                        </div>
                    </c:forEach>
                </div>

                <c:if test="${reserva.equipajeExtra > 0}">
                    <div class="flex items-center space-x-3">
                        <i class="fas fa-suitcase-rolling text-2xl text-[var(--azul-oscuro)]"></i>
                        <p><strong>Equipaje extra:</strong> ${reserva.equipajeExtra} valijas</p>
                    </div>
                </c:if>
            </div>

            <!-- BOTONES SEGÚN CHECK-IN -->
            <div class="mt-12 text-center">
                <c:choose>
                    <c:when test="${reserva.checkin}">
                        <div class="mb-6">
                            <p class="text-2xl font-bold text-green-600">
                                <i class="fas fa-check-circle mr-2"></i>¡Check-in realizado!
                            </p>
                        </div>
                        <form action="${pageContext.request.contextPath}/reservas/descargar-pdf" method="get">
                            <input type="hidden" name="vuelo" value="${reserva.vuelo.nombre}">
                            <input type="hidden" name="fecha" value="${reserva.fecha}">
                            <button id="descargar" type="submit">Descargar PDF</button>
                        </form>
                    </c:when>
                    <c:otherwise>
                        <p class="text-2xl text-orange-600 mb-8 font-semibold">
                            <i class="fas fa-clock mr-3"></i> Check-in pendiente
                        </p>

                        <form action="${pageContext.request.contextPath}/reservas/consulta" method="post" class="inline">
                            <input type="hidden" name="vuelo" value="${reserva.vuelo.nombre}">
                            <input type="hidden" name="fecha" value="${reserva.fecha}">
                            <button type="submit"
                                    onclick="return confirm('¿Confirmar check-in para esta reserva?');"
                                    class="bg-[var(--azul-oscuro)] hover:bg-blue-900 text-white font-bold text-xl py-5 px-12 rounded-xl shadow-2xl transition transform hover:scale-105">
                                <i class="fas fa-plane-arrival mr-3"></i>
                                Hacer Check-In Ahora
                            </button>
                        </form>
                    </c:otherwise>
                </c:choose>
            </div>
        </c:if>
    </section>
</main>
</body>
</html>


<style>
    :root {
        --azul-oscuro: #0c2636;
        --azul-medio: #12445d;
        --azul-claro: #1d6e86;
        --celeste: #269fb8;
        --celeste-claro: #2bc8c8;
    }

    #descargar {
        color: white;
        background-color: #bf041b;
        font-weight: bold;
        font-size: 1.25rem;
        padding: 1.25rem 3rem;
        border-radius: 1.5rem;
        box-shadow: 0 10px 15px -3px rgba(175, 30, 47, 0.4), 0 4px 6px -2px rgba(175, 30, 47, 0.1);
        transition: transform 0.2s, background-color 0.2s;
    }
</style>