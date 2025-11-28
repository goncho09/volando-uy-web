<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Volando.uy | Ver paquetes</title>


    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="icon" href="${pageContext.request.contextPath}/favicon.ico?v=2" type="image/x-icon">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet"/>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/globals.css"/>
</head>
<body>
<c:set var="usuarioTipo" value="${sessionScope.usuarioTipo}"/>

<jsp:include page="../components/header.jsp"/>

<main class="flex flex-col items-center md:items-start md:flex-row max-w-7xl md:mx-auto px-4 sm:px-6 lg:px-8 justify-center  mt-5">

    <section class="flex flex-col w-full bg-white p-6 rounded-lg shadow-lg mt-5 md:mt-0 md:ml-5">

        <div class="w-full overflow-x-auto">
            <table class="min-w-full border border-gray-200 rounded-lg shadow-sm text-sm md:text-base">
                <thead class="bg-[var(--azul-oscuro)] text-white">
                <tr>
                    <th class="px-4 py-2 text-center">Nombre</th>
                    <th class="px-4 py-2 text-center">Descripción</th>
                    <th class="px-4 py-2 text-center">Precio</th>
                    <th class="px-4 py-2 text-center">Validez (días)</th>
                    <c:if test="${usuarioTipo == 'aerolinea'}">
                    <th class="px-4 py-2 text-center">Acciones</th>
                    </c:if>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="paquete" items="${paquetes}">
                    <tr class="border-t border-[var(--azul-oscuro)] cursor-pointer hover:bg-blue-200" onclick="window.location.href='${pageContext.request.contextPath}/paquete/consulta?nombre=${paquete.nombre}'">
                        <td class="text-center px-4 py-2">${paquete.nombre}</td>
                        <td class="text-center px-4 py-2">${paquete.descripcion}</td>
                        <td class="text-center px-4 py-2">$${paquete.costo}</td>
                        <td class="text-center px-4 py-2">${paquete.validezDias}</td>
                        <c:if test="${usuarioTipo == 'aerolinea'}">
                        <td class="text-center px-4 py-2 flex items-center justify-center space-x-3">
                            <a href="#" class="hover:scale-110 transition-transform">
                                <i class="fa fa-edit text-xl text-green-600"></i>
                            </a>
                            <form class="inline">
                                <input type="hidden" name="id" value="${paquete.nombre}">
                                <button type="submit" class="hover:scale-110 transition-transform">
                                    <i class="fa fa-trash text-xl text-red-600"></i>
                                </button>
                            </form>
                        </td>
                        </c:if>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>

    </section>
</main>

</body>
</html>
