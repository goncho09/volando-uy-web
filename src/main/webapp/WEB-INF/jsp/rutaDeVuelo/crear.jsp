<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Volando.uy | Crear Ruta de Vuelo</title>

    <!-- Librerias Header -->
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/daisyui@5" rel="stylesheet" type="text/css" />

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/globals.css"/>

</head>
<body>
<jsp:include page="../components/header.jsp" />

<main class="flex flex-col items-center p-4 min-h-screen">

<section class="flex flex-col items-center w-full max-w-3xl bg-white p-6 rounded-lg shadow-xl mt-2">        <h2 class="text-2xl font-bold mb-6 text-center text-[#12445d]">Nueva Ruta de Vuelo</h2>

        <form id="formCrearRuta" class="space-y-4 flex flex-col items-center w-full" enctype="multipart/form-data">
             <!-- Nombre -->
                        <!-- Nombre -->
                        <div class="flex w-full items-center border-b border-gray-300 py-2 space-x-3 focus-within:border-[var(--azul-oscuro)]">
                <input type="text" name="nombre" required class="flex-grow outline-none bg-transparent text-gray-700 py-2 px-2 rounded focus:bg-gray-100"
                       placeholder="Nombre único de la ruta *" maxlength="100">
            </div>

              <!-- Descripción Corta -->
                        <div class="flex w-full items-center border-b border-gray-300 py-2 space-x-3 focus-within:border-[var(--azul-oscuro)]">
                <input type="text" name="descripcionCorta" required class="flex-grow outline-none bg-transparent text-gray-700 py-2 px-2 rounded focus:bg-gray-100"
                       placeholder="Descripción corta *" maxlength="200">
            </div>

            <!-- Descripción Completa -->
            <div class="flex w-full items-start border-b border-gray-300 py-2 space-x-3 focus-within:border-[var(--azul-oscuro)]">
                <i class="fa fa-align-left text-[var(--azul-oscuro)] mt-2"></i>
                <textarea name="descripcion" required rows="4" class="flex-grow outline-none bg-transparent text-gray-700 py-2 px-2 rounded focus:bg-gray-100 resize-none"
                          placeholder="Descripción completa *" style="resize: none;" maxlength="1000"></textarea>
            </div>

            <!-- Hora de Salida -->
            <div class="flex w-full items-center border-b border-gray-300 py-2 space-x-3 focus-within:border-[var(--azul-oscuro)]">
                <i class="fa fa-clock text-[var(--azul-oscuro)]"></i>
                <label class="text-gray-500 mr-2">Duración del viaje:</label>
                <input type="time" name="hora" required class="flex-grow outline-none bg-transparent text-gray-700 py-2 px-2 rounded focus:bg-gray-100">
            </div>

            <!-- Costos -->
            <div class="grid grid-cols-1 md:grid-cols-3 gap-4 w-full">
                <div class="flex items-center border-b border-gray-300 py-2 space-x-3 focus-within:border-[var(--azul-oscuro)]">
                    <i class="fa fa-dollar-sign text-[var(--azul-oscuro)]"></i>
                    <input type="number" name="costoTurista" required min="1" step="0.01"
                           class="flex-grow outline-none bg-transparent text-gray-700 py-2 px-2 rounded focus:bg-gray-100"
                           placeholder="Turista (USD) *">
                </div>

                <div class="flex items-center border-b border-gray-300 py-2 space-x-3 focus-within:border-[var(--azul-oscuro)]">
                    <i class="fa fa-dollar-sign text-[var(--azul-oscuro)]"></i>
                    <input type="number" name="costoEjecutivo" required min="1" step="0.01"
                           class="flex-grow outline-none bg-transparent text-gray-700 py-2 px-2 rounded focus:bg-gray-100"
                           placeholder="Ejecutivo (USD) *">
                </div>

                <div class="flex items-center border-b border-gray-300 py-2 space-x-3 focus-within:border-[var(--azul-oscuro)]">
                    <i class="fa fa-suitcase text-[var(--azul-oscuro)]"></i>
                    <input type="number" name="costoEquipajeExtra" required min="0" step="0.01"
                           class="flex-grow outline-none bg-transparent text-gray-700 py-2 px-2 rounded focus:bg-gray-100"
                           placeholder="Equipaje extra (USD) *">
                </div>
            </div>

            <!-- Ciudades -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4 w-full">
                <div class="flex flex-col">
                    <label class="block mb-2 font-medium text-gray-700">Ciudad Origen *</label>
                    <div class="flex items-center border-b border-gray-300 py-2 space-x-3 focus-within:border-[var(--azul-oscuro)]">
                        <i class="fa fa-plane-departure text-[var(--azul-oscuro)]"></i>
                        <select name="ciudadOrigen" required class="flex-grow outline-none bg-transparent text-gray-700 py-2 px-2 rounded focus:bg-gray-100">
                            <option value="" disabled selected>Seleccione ciudad origen</option>
                            <c:forEach var="ciudad" items="${ciudades}">
                                <option value="${ciudad.nombre}, ${ciudad.pais}">${ciudad.nombre}, ${ciudad.pais}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <div class="flex flex-col">
                    <label class="block mb-2 font-medium text-gray-700">Ciudad Destino *</label>
                    <div class="flex items-center border-b border-gray-300 py-2 space-x-3 focus-within:border-[var(--azul-oscuro)]">
                        <i class="fa fa-plane-arrival text-[var(--azul-oscuro)]"></i>
                        <select name="ciudadDestino" required class="flex-grow outline-none bg-transparent text-gray-700 py-2 px-2 rounded focus:bg-gray-100">
                            <option value="" disabled selected>Seleccione ciudad destino</option>
                            <c:forEach var="ciudad" items="${ciudades}">
                                <option value="${ciudad.nombre}, ${ciudad.pais}">${ciudad.nombre}, ${ciudad.pais}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>
            </div>

            <!-- Categorías -->
            <div class="flex flex-col w-full">
                <label class="block mb-2 font-medium text-gray-700">Categorías *</label>
                <div class="flex items-center border-b border-gray-300 py-2 space-x-3 focus-within:border-[var(--azul-oscuro)]">
                    <i class="fa fa-tags text-[var(--azul-oscuro)]"></i>
                    <select name="categorias" multiple required class="flex-grow outline-none bg-transparent text-gray-700 py-2 px-2 rounded focus:bg-gray-100 h-32">
                        <c:forEach var="categoria" items="${categorias}">
                            <option value="${categoria.nombre}">${categoria.nombre}</option>
                        </c:forEach>
                    </select>
                </div>
                <small class="text-gray-500 mt-1">Mantén Ctrl (Cmd en Mac) para seleccionar múltiples categorías</small>
            </div>

            <!-- Imagen -->
            <div class="flex w-full items-center border-b border-gray-300 py-2 space-x-3 focus-within:border-[var(--azul-oscuro)]">
                <i class="fa fa-image text-[var(--azul-oscuro)]"></i>
                <label for="image" class="flex-grow text-gray-500 cursor-pointer">
                    <span id="file-name" class="block">Seleccione una imagen para la ruta (opcional)</span>
                    <input type="file" id="image" name="image" accept="image/*" class="sr-only">
                </label>
            </div>

            <!-- URL Video (opcional) -->
            <div class="flex w-full items-center border-b border-gray-300 py-2 space-x-3 focus-within:border-[var(--azul-oscuro)]">
                <i class="fa fa-video text-[var(--azul-oscuro)]"></i>
                <input type="url" name="urlVideo" class="flex-grow outline-none bg-transparent text-gray-700 py-2 px-2 rounded focus:bg-gray-100"
                       placeholder="URL del video (opcional)" pattern="https?://.+">
            </div>

            <!-- Mensajes de error y éxito -->
            <p id="error-msg" class="hidden text-red-600 text-base text-center transition-all duration-300 transform origin-top -translate-y-1 w-full"></p>
            <p id="success-msg" class="hidden text-green-600 text-base text-center transition-all duration-300 transform origin-top -translate-y-1 w-full ">
                Ruta de vuelo creada con éxito! Redirigiendo...
            </p>

            <!-- Botón de envío -->
            <button type="submit" class="w-full px-4 py-2 font-semibold cursor-pointer text-white bg-[var(--azul-oscuro)] rounded-md hover:bg-[var(--azul-medio)] focus:outline-none focus:ring-2 focus:ring-[var(--azul-claro)] transition duration-300">
                <i class="fas fa-plus-circle mr-2"></i>Crear Ruta de Vuelo
            </button>
        </form>
    </section>
</main>
</body>

<script>

const formCrearRuta = document.getElementById('formCrearRuta');

const fileInput = document.getElementById('image');
const fileNameSpan = document.getElementById('file-name');
const errorMsg = document.getElementById('error-msg');
const successMsg = document.getElementById('success-msg');

fileInput.addEventListener('change', () => {
    const file = fileInput.files[0];
    fileNameSpan.textContent = file ? file.name : 'Seleccione una imagen para la ruta (opcional)';
});

    formCrearRuta.addEventListener('submit', async (e) => {
        e.preventDefault();

        const formData = new FormData(formCrearRuta);

        try {
            const response = await fetch('${pageContext.request.contextPath}/ruta-de-vuelo/crear', {
                method: 'POST',
                body: formData,
            });

            const text = await response.text();

            if (response.ok) {
                mostrarExito();
                formCrearRuta.reset();
                fileNameSpan.textContent = 'Seleccione una imagen para la ruta (opcional)';

                // Redirigir después de 2 segundos
                setTimeout(() => {
                    window.location.href = '${pageContext.request.contextPath}/home';
                }, 2000);
            } else {
                mostrarError(text);
            }
        } catch (error) {
            mostrarError('Error de conexión. Intente nuevamente.');
        }
    });

    // Función para mostrar error
    function mostrarError(mensaje) {
        errorMsg.textContent = mensaje;
        errorMsg.classList.remove('hidden');
        errorMsg.classList.add('translate-y-0');
        successMsg.classList.add('hidden');
    }

    // Función para mostrar éxito
    function mostrarExito() {
        successMsg.classList.remove('hidden');
        successMsg.classList.add('translate-y-0');
        errorMsg.classList.add('hidden');
    }

    // Función para ocultar mensajes
    function ocultarMensajes() {
        errorMsg.classList.add('hidden');
        successMsg.classList.add('hidden');
        errorMsg.classList.remove('translate-y-0');
        successMsg.classList.remove('translate-y-0');
    }

    // Validación en tiempo real para ciudades iguales
    document.querySelectorAll('select[name="ciudadOrigen"], select[name="ciudadDestino"]').forEach(select => {
        select.addEventListener('change', function() {
            const origen = document.querySelector('select[name="ciudadOrigen"]');
            const destino = document.querySelector('select[name="ciudadDestino"]');

            if (origen.value === destino.value && origen.value !== '' && destino.value !== '') {
                mostrarError('La ciudad origen y destino no pueden ser la misma.');
            } else {
                ocultarMensajes();
            }
        });
    });

    // Validación en tiempo real para costos
    document.querySelectorAll('input[type="number"]').forEach(input => {
        input.addEventListener('input', function() {
            const value = parseFloat(this.value);
            if (this.name.includes('costo') && value < 0) {
                this.value = '';
                mostrarError('Los costos no pueden ser negativos.');
            } else {
                ocultarMensajes();
            }
        });
    });
</script>

</html>