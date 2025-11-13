<%@ page isErrorPage="true" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Volando.uy | 404</title>

    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/globals.css">
</head>
<body>
<main class="min-h-screen flex items-center justify-center bg-gray-100">
    <div class="bg-white p-8 rounded shadow-md text-center">
        <h1 class="text-4xl font-bold mb-4 text-red-600">
            ¡Error!
        </h1>
        <p class="text-lg mb-6">
            ${error}
        </p>
        <a href="${pageContext.request.contextPath}/home" class="hover:bg-[var(--azul-claro)]  !text-white p-4 rounded-lg duration-400 bg-[var(--azul-oscuro)]">Volver al Inicio</a>
    </div>
</main>
</body>
</html>