<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Volando.uy | Crear reserva</title>

<script src="https://cdn.tailwindcss.com"></script>   <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/globals.css"/>
    <link rel="icon" href="${pageContext.request.contextPath}/favicon.ico?v=2" type="image/x-icon">
</head>

<body class="bg-gray-50 text-gray-800 min-h-screen">
<jsp:include page="../components/header.jsp"/>

<main class="max-w-7xl mx-auto py-10 px-4 sm:px-6 lg:px-8">
    <div class="grid grid-cols-1 md:grid-cols-4 gap-28">
        <aside class="md:col-span-1">
            <jsp:include page="../components/miPerfil.jsp"/>
        </aside>

        <section class="md:col-span-3">
            <div class="bg-white rounded-2xl shadow p-6">
                <h2 class="text-2xl font-semibold mb-6 border-b pb-2">Crear Nueva Reserva</h2>

                <form id="form-reserva" class="space-y-8">
                    <!-- Selección de vuelo -->
                    <div>
                        <h3 class="text-lg font-semibold mb-3">Selecciona tu Vuelo</h3>
                        <div class="grid grid-cols-1 sm:grid-cols-3 gap-4">
                            <!-- Aerolínea -->
                            <div>
                                <label class="block font-medium mb-1">Aerolínea</label>
                                <select class="w-full border border-gray-300 rounded-lg px-3 py-2 focus:ring-2 focus:ring-blue-500"
                                        name="aerolinea"
                                        onchange="window.location.href='?aerolinea=' + this.value;">
                                    <option value="" disabled ${empty aerolineaId ? "selected" : ""}>
                                        Seleccione una aerolínea *
                                    </option>
                                    <c:forEach var="a" items="${aerolineas}">
                                        <option value="${a.nickname}" ${a.nickname eq aerolineaId ? "selected" : ""}>
                                                ${a.nombre}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <!-- Ruta -->
                            <div>
                                <label class="block font-medium mb-1">Ruta</label>
                                <select class="w-full border border-gray-300 rounded-lg px-3 py-2 focus:ring-2 focus:ring-blue-500"
                                        name="ruta"
                                ${empty rutas ? "disabled" : ""}
                                        onchange="window.location.href='?aerolinea=${aerolineaId}&ruta=' + this.value;">
                                    <option value="" disabled ${empty rutaId ? "selected" : ""}>
                                        Seleccione una ruta de vuelo *
                                    </option>
                                    <c:forEach var="r" items="${rutas}">
                                        <option value="${r.nombre}" ${r.nombre eq rutaId ? "selected" : ""}>${r.nombre}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <!-- Vuelo -->
                            <div>
                                <label class="block font-medium mb-1">Vuelo</label>
                                <select class="w-full border border-gray-300 rounded-lg px-3 py-2 focus:ring-2 focus:ring-blue-500"
                                        name="vuelo"
                                ${empty vuelos ? "disabled" : ""}>
                                    <option value="" disabled ${empty vueloId ? "selected" : ""}>
                                        Seleccione un vuelo *
                                    </option>
                                    <c:forEach var="v" items="${vuelos}">
                                        <option value="${v.nombre}">${v.nombre}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                    </div>

                    <!-- Datos de los pasajeros -->
                    <div>
                        <h3 class="text-lg font-semibold mb-3">Datos de los Pasajeros</h3>
                        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                            <div>
                                <label for="cantidad-pasajes" class="block font-medium mb-1">Cantidad de pasajes</label>
                                <input type="number" id="cantidad-pasajes" name="cantidad-pasajes" min="1" value="1"
                                       class="w-full border border-gray-300 rounded-lg px-3 py-2 focus:ring-2 focus:ring-blue-500">
                            </div>
                            <div>
                                <label for="tipo-asiento" class="block font-medium mb-1">Tipo de asiento</label>
                                <select id="tipo-asiento" name="tipo-asiento"
                                        class="w-full border border-gray-300 rounded-lg px-3 py-2 focus:ring-2 focus:ring-blue-500">
                                    <option value="turista">Turista - USD ${precioTurista}</option>
                                    <option value="ejecutivo">Ejecutivo - USD ${precioEjecutivo}</option>
                                </select>
                            </div>
                        </div>

                        <div class="mt-4">
                            <label for="equipaje-extra" class="block font-medium mb-1">Unidades de equipaje extra</label>
                            <input type="number" id="equipaje-extra" name="equipaje-extra" min="0" max="5" value="0"
                                   required
                                   class="w-full border border-gray-300 rounded-lg px-3 py-2 focus:ring-2 focus:ring-blue-500">
                            <p class="text-sm text-gray-500 mt-1">Costo por unidad: ${precioEquipaje}</p>
                        </div>

                        <div id="nombres-pasajeros" class="mt-4 space-y-4"></div>
                    </div>

                    <!-- Método de pago -->
                    <div>
                        <h3 class="text-lg font-semibold mb-3">Método de Pago</h3>

                        <div class="space-y-2">
                            <label class="flex items-center gap-2">
                                <input type="radio" name="metodo-pago" id="pago-general" value="pago-general"
                                       class="text-blue-600 focus:ring-blue-500" checked required>
                                <span>Pago general</span>
                            </label>

                            <label class="flex items-center gap-2">
                                <input type="radio" name="metodo-pago" id="pago-paquete" value="pago-paquete"
                                       class="text-blue-600 focus:ring-blue-500" required>
                                <span>Pago con paquete</span>
                            </label>
                        </div>

                        <div id="selector-paquete" class="mt-3 hidden">
                            <label for="paquete" class="block font-medium mb-1">Selecciona un paquete</label>
                            <select id="paquete" name="paquete"
                                    class="w-full border border-gray-300 rounded-lg px-3 py-2 focus:ring-2 focus:ring-blue-500">
                                <option value="" disabled ${empty paqueteId ? "selected" : ""}>
                                    Seleccione un paquete *
                                </option>
                                <c:forEach var="p" items="${paquetes}">
                                    <option value="${p.nombre}">${p.nombre}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <!-- Botones -->
                    <div class="flex justify-between items-center mt-6">
                        <button type="button"
                                class="px-4 py-2 rounded-lg border border-gray-400 text-gray-700 hover:bg-gray-100 transition"
                                onclick="window.location.href='${pageContext.request.contextPath}/vuelos/consultar'">
                            ← Volver a Consultar Vuelos
                        </button>

                        <button type="submit"
                                class="px-6 py-2 rounded-lg text-white bg-blue-800 hover:bg-blue-900 transition">
                            Confirmar Reserva
                        </button>
                    </div>
                </form>

                <!-- Mensajes -->
                <p id="error-msg"
                   class="hidden text-red-600 text-base text-center mt-4 transition-all duration-300 transform origin-top -translate-y-1">
                </p>

                <p id="success-msg"
                   class="hidden text-green-600 text-base text-center mt-4 transition-all duration-300 transform origin-top -translate-y-1">
                    Reserva creada con éxito!
                </p>
            </div>
        </section>
    </div>
</main>

<script>
    document.addEventListener("DOMContentLoaded", () => {
        const cantidadPasajesSelect = document.getElementById("cantidad-pasajes");
        const pasajerosDiv = document.getElementById("nombres-pasajeros");
        const formReserva = document.getElementById("form-reserva");
        const pagoGeneral = document.getElementById("pago-general");
        const pagoPaquete = document.getElementById("pago-paquete");
        const selectorPaquete = document.getElementById("selector-paquete");
        const errorMsg = document.getElementById("error-msg");
        const successMsg = document.getElementById("success-msg");

        const generarCamposPasajeros = () => {
            const cantidad = parseInt(cantidadPasajesSelect.value);
            pasajerosDiv.innerHTML = "";

            for (let i = 1; i <= cantidad; i++) {
                const div = document.createElement("div");
                div.innerHTML = `
                <label class="block font-medium mb-1">Pasajero ${i}</label>
                <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                    <input type="text" name="nombrePasajero" placeholder="Nombre" required
                        class="border border-gray-300 rounded-lg px-3 py-2 focus:ring-2 focus:ring-blue-500">
                    <input type="text" name="apellidoPasajero" placeholder="Apellido" required
                        class="border border-gray-300 rounded-lg px-3 py-2 focus:ring-2 focus:ring-blue-500">
                </div>
            `;
                pasajerosDiv.appendChild(div);
            }
        };

        generarCamposPasajeros();
        cantidadPasajesSelect.addEventListener("change", generarCamposPasajeros);

        const togglePaquete = () => {
            selectorPaquete.classList.toggle("hidden", !pagoPaquete.checked);
        };

        pagoGeneral.addEventListener("change", togglePaquete);
        pagoPaquete.addEventListener("change", togglePaquete);
        togglePaquete();

        formReserva.addEventListener('submit', async (e) => {
            e.preventDefault();

            const formData = new FormData(formReserva);
            const encoded = new URLSearchParams(formData);
            errorMsg.textContent = '';
            errorMsg.classList.add('hidden');
            successMsg.classList.add('hidden');

                const response = await fetch('${pageContext.request.contextPath}/reservas/crear', {
                    method: 'POST',
                    body: encoded
                });
                const result = await response.json();

                if (response.ok) {
                    successMsg.classList.remove('hidden');
                    formReserva.reset();
                    generarCamposPasajeros();
                } else {
                    errorMsg.textContent = result.message || 'Error al crear la reserva.';
                    errorMsg.classList.remove('hidden');
                }
        });
    });
</script>
</body>
</html>
