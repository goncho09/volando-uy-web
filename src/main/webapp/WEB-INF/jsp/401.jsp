<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Volando.uy | 401</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/globals.css"/>
</head>
<body>
    <section class="flex flex-col items-center justify-center min-h-screen bg-gray-100">
        <div class="bg-white p-8 rounded-lg shadow-lg text-center">
            <h1 class="text-6xl font-bold text-red-600 mb-4">401</h1>
            <h2 class="text-2xl font-semibold mb-4">Acceso no autorizado</h2>
            <p class="text-gray-700 mb-6">
                ${error ? error : 'No tienes permiso para acceder a esta página.'} </p>
            <a href="${pageContext.request.contextPath}/home" class="inline-block bg-[var(--azul-oscuro)] !text-white px-6 py-3 rounded-lg hover:bg-[var(--azul-claro)] transition-colors">
                Volver al inicio
            </a>
        </div>
    </section>
</body>
</html>
