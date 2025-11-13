<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Volando.uy | Buscar usuario</title>

    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/globals.css"/>
</head>

<body>
<jsp:include page="../components/header.jsp"/>

<main id="main-content" class="flex flex-col items-center md:items-start md:flex-row max-w-7xl md:mx-auto px-4 sm:px-6 lg:px-8 justify-center  mt-5">
    <section class="flex flex-col items-center w-full max-w-3xl bg-white p-6 rounded-lg shadow-lg mt-5 md:mt-0 md:ml-5">
        <h2 class="text-2xl font-bold mb-6 text-center text-[#12445d]">Buscar usuario</h2>
    <select class="flex-grow outline-none bg-transparent text-gray-700 py-2 px-2 rounded focus:bg-gray-100 whitespace-nowrap mt-3"
            id="usuario" name="usuario" aria-label="Seleccione un usuario *" required>
        <option class="whitespace-nowrap" value="" disabled selected>
            Seleccione un usuario *
        </option>
        <c:forEach var="u" items="${usuarios}">
            <option value="${u.nickname}">
                    ${u.nombre}
            </option>
        </c:forEach>
    </select>
    <button
            class=" bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded mt-3"
            onclick="location.href='${pageContext.request.contextPath}/perfil?nickname=' + document.getElementById('usuario').value">
        Buscar
    </button>
    </section>
</main>
</body>
</html>
