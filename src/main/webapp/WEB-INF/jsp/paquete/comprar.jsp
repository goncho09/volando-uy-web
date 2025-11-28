<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Volando.uy | Comprar Paquete</title>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="icon" href="${pageContext.request.contextPath}/favicon.ico?v=2" type="image/x-icon">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet"/>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/globals.css"/>
</head>

<body>

<jsp:include page="../components/header.jsp"/>



<!-- Contenido principal -->
<main id="main-content"
      class="flex flex-col items-center md:items-start md:flex-row max-w-7xl md:mx-auto px-4 sm:px-6 lg:px-8 justify-center mt-5">

    <!-- Sidebar -->
    <jsp:include page="../components/miPerfil.jsp"/>

    <!-- Sección principal -->
    <section class="flex flex-col items-center w-full max-w-3xl bg-white p-6 rounded-lg shadow-lg mt-5 md:mt-0 md:ml-5">
        <h2 class="text-2xl font-bold mb-6 text-center text-[var(--azul-oscuro)]">Comprar Paquete</h2>

        <form id="formCompraPaquete" method="POST" class="space-y-4 flex flex-col items-center w-full">

            <!-- Seleccionar Paquete -->
            <div class="flex w-full md:w-1/2 items-center border-b border-gray-300 py-2 space-x-3 focus-within:border-[var(--azul-oscuro)]">
                <i class="fa fa-box text-[var(--azul-oscuro)]"></i>
                <select id="paquete" name="paquete"
                        class="flex-grow outline-none bg-transparent text-gray-700 py-2 px-2 rounded focus:bg-gray-100"
                        required>
                    <option value="" disabled selected>Seleccione un paquete *</option>
                    <c:forEach var="p" items="${paquetes}">
                        <option value="${p.nombre}">${p.nombre}</option>
                    </c:forEach>
                </select>
            </div>

            <!-- Botón Comprar -->
            <button id="btnComprar" type="submit"
                    class="hover:bg-[var(--azul-claro)] w-full md:w-1/2 text-white py-2 rounded-lg duration-400 bg-[var(--azul-oscuro)] mt-2">
                <i class="fa fa-credit-card mr-2"></i> Comprar
            </button>

            <p id="error-msg"
               class="hidden text-red-600 text-base text-center transition-all duration-300 transform origin-top -translate-y-1">
            </p>

            <p id="success-msg"
               class="hidden text-green-600 text-base text-center transition-all duration-300 transform origin-top -translate-y-1">
                Paquete comprado con éxito!
            </p>
        </form>
    </section>
</main>

<script defer>
        const formComprarPaquete = document.getElementById('formCompraPaquete');
        const errorMsg = document.getElementById('error-msg');
        const successMsg = document.getElementById('success-msg');

        formComprarPaquete.addEventListener('submit',async(e)=>{
            e.preventDefault();
            const formData = new FormData(formComprarPaquete);

            const response = await fetch('${pageContext.request.contextPath}/paquete/comprar', {
                method: 'POST',
                body: formData
            });

            if (response.ok) {
                errorMsg.classList.add('hidden');
                successMsg.classList.remove('hidden');
                formComprarPaquete.reset();
            } else {
                const errorText = await response.text();
                successMsg.classList.add('hidden');
                errorMsg.textContent = errorText || 'Error al comprar el paquete. Intente nuevamente.';
                errorMsg.classList.remove('hidden');
            }
        })

        formComprarPaquete.addEventListener('submit', (e) => {
            const formData = new FormData(formComprarPaquete);
            console.log("Valor paquete: ", formData.get("paquete"));
        });
</script>
</body>
</html>
