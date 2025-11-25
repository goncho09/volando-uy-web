<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Volando.uy | Ver rutas</title>

    <!-- Librerias Header -->
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/globals.css"/>

</head>

<body>

<jsp:include page="../components/header.jsp"/>

<main class="flex flex-col items-center md:items-start md:flex-row max-w-7xl md:mx-auto px-4 sm:px-6 lg:px-8 justify-center  mt-5">

    <section class="flex flex-col w-full bg-white p-6 rounded-lg shadow-lg mt-5 md:mt-0 md:ml-5">

        <div class="w-full overflow-x-auto">
            <table class="min-w-full border border-gray-200 rounded-lg shadow-sm text-sm md:text-base">
                <thead class="bg-[var(--azul-oscuro)] text-white">
                <tr>
                    <th class="px-4 py-2 text-center">Nombre</th>
                    <th class="px-4 py-2 text-center">Descripción corta</th>
                    <th class="px-4 py-2 text-center">Duración (min)</th>
                    <th class="px-4 py-2 text-center">Ciudad origen</th>
                    <th class="px-4 py-2 text-center">Ciudad destino</th>
                    <th class="px-4 py-2 text-center">Costo ejecutivo</th>
                    <th class="px-4 py-2 text-center">Costo turista</th>
                    <th class="px-4 py-2 text-center">Costo equipaje adicional</th>
                    <th class="px-4 py-2 text-center">Estado</th>
                    <th class="px-4 py-2 text-center">Acciones</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="ruta" items="${rutas}">
                                <tr class="border-t border-[var(--azul-oscuro)]
                            <c:if test="${ruta.estado eq 'APROBADA'}">
                                cursor-pointer hover:bg-blue-200" onclick="window.location.href='${pageContext.request.contextPath}/ruta-de-vuelo/buscar?nombre=${ruta.nombre}'
                            </c:if>
                                ">
                        <td class="px-4 py-2 text-center">${ruta.nombre}</td>
                        <td class="px-4 py-2 text-center">${ruta.descripcionCorta}</td>
                        <td class="px-4 py-2 text-center">${ruta.duracion}</td>
                        <td class="px-4 py-2 text-center">${ruta.ciudadOrigen.nombre}, ${ruta.ciudadOrigen.pais}</td>
                        <td class="px-4 py-2 text-center">${ruta.ciudadDestino.nombre}, ${ruta.ciudadDestino.pais}</td>
                        <td class="px-4 py-2 text-center">$${ruta.costoEjecutivo}</td>
                        <td class="px-4 py-2 text-center">$${ruta.costoTurista}</td>
                        <td class="px-4 py-2 text-center">$${ruta.equipajeExtra}</td>
                        <td class="px-4 py-2 text-center">${ruta.estado}</td>

                       <td class="text-center px-4 py-2 space-x-3">
                           <a href="#" class="hover:scale-110 transition-transform">
                               <i class="fa fa-edit text-xl text-green-600"></i>
                           </a>
                           <c:if test="${ruta.estado eq 'APROBADA'}">
                               <form method="post"
                                     action="${pageContext.request.contextPath}/ruta-de-vuelo/ver"
                                     class="inline">
                                   <input type="hidden" name="action" value="finalizar">
                                   <input type="hidden" name="nombre" value="${ruta.nombre}">
                                   <button type="submit" class="hover:scale-110 transition-transform" title="Finalizar ruta">
                                       <i class="fa fa-trash text-xl text-red-600"></i>
                                   </button>
                               </form>

                           </c:if>
                       </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>

    </section>
</main>

</body>
</html>
