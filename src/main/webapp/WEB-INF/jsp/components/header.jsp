<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<head>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/globals.css"/>
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet"/>
</head>

<header id="header" class="flex flex-col px-4 py-2 text-white w-[100vw] bg-[var(--azul-oscuro)]">
    <div class="flex items-center flex-col justify-between p-2 space-y-2 w-full header-top md:flex-row md:space-y-0">
        <a href="${pageContext.request.contextPath}/home" class="text-3xl font-bold uppercase">Volando.uy</a>

        <c:set var="usuarioNickname" value="${sessionScope.usuarioNickname}"/>
        <c:set var="usuarioTipo" value="${sessionScope.usuarioTipo}"/>
        <c:set var="usuarioImagen" value="${sessionScope.usuarioImagen}"/>
        <c:set var="esMobile" value="${sessionScope.esMobile}"/>

        <c:choose>
            <c:when test="${usuarioNickname != null}">
                <div class="flex flex-col items-center space-x-3 md:flex-row" id="user-info">
                    <a class="flex items-center" href="${pageContext.request.contextPath}/perfil?nickname=${usuarioNickname}">
                        <img src="${usuarioImagen}" class="w-12 h-12 rounded-full mr-2"
                             alt=${usuarioNickname}/>
                        <p class="m-0" id="nickname">${usuarioNickname}</p>
                    </a>
                    <p class="decoration-[var(--celeste-claro)] cursor-pointer underline-offset-5 m-0 hover:underline"
                       onclick="window.location.href='${pageContext.request.contextPath}/logout'">Cerrar sesión</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="flex space-x-2">
                    <a href="${pageContext.request.contextPath}/signin">
                        <p class="decoration-[var(--celeste-claro)] underline-offset-5 m-0 hover:underline">Iniciar sesión</p>
                    </a>
                    <div class="border-l border-1 h-6"></div>
                    <a href="${pageContext.request.contextPath}/signup">
                        <p class="decoration-[var(--celeste-claro)] underline-offset-5 m-0 hover:underline">
                            Registrarme</p>
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Barra de búsqueda -->
    <form id="formBuscar" class="flex items-center justify-center w-full !bg-transparent !space-x-2 self-center text-white border-b border-white p-2
                focus-within:border-[var(--celeste-claro)] duration-200 ease-in md:w-1/2">
        <button type="submit"><i class="fa-solid fa-magnifying-glass text-xl"></i></button>
        <input type="text" placeholder="Buscar paquete, ruta de vuelo ..." name="busqueda" id="busqueda"
               class="outline-none border-0  bg-transparent w-[95%] text-lg"/>
    </form>

    <!-- Navbar -->
    <nav class="shadow-sm flex items-center justify-center">
        <!-- Navbar Start (Hamburguesa solo en móvil) -->
        <div class="relative flex p-4 md:hidden w-full">
            <button id="btn-mobile-menu" class="flex">
                <i class="fa-solid fa-bars text-xl text-center"></i>
            </button>

            <div id="mobile-menu"
                 class="hidden absolute top-full left-0 w-72 z-[100] bg-[var(--azul-oscuro)] text-white p-3 rounded shadow animate-fade">

                <!-- Vuelos -->
                <div class="menu-section">
                    <button class="menu-title flex items-center justify-between w-full">
                        Vuelos
                        <i class="fa-solid fa-chevron-down text-xs"></i>
                    </button>
                    <ul class="submenu hidden pl-4 transition-all duration-200">
                        <li><a class="block py-2" href="${pageContext.request.contextPath}/vuelo/buscar">Buscar vuelo</a></li>
                    </ul>
                </div>

                <!-- Rutas (solo aerolínea) -->
                <c:if test="${usuarioTipo!= null && usuarioTipo == 'aerolinea'}">
                <div class="menu-section">
                    <button class="menu-title flex items-center justify-between w-full">
                        Rutas de vuelo
                        <i class="fa-solid fa-chevron-down text-xs"></i>
                    </button>
                    <ul class="submenu hidden pl-4 transition-all duration-200">
                        <li><a class="block py-2" href="${pageContext.request.contextPath}/ruta-de-vuelo/ver">Ver rutas</a></li>
                    </ul>
                </div>
                </c:if>

                <!-- Reservas -->
                <c:if test="${usuarioTipo!= null}">
                    <div class="menu-section">
                        <button class="menu-title flex items-center justify-between w-full">
                            Reservas
                            <i class="fa-solid fa-chevron-down text-xs"></i>
                        </button>
                        <ul class="submenu hidden pl-4 transition-all duration-200">
                            <li><a class="block py-2" href="${pageContext.request.contextPath}/reservas/ver">Ver mis reservas</a></li>
                        </ul>
                    </div>
                </c:if>

            </div>
        </div>

        <!-- Navbar Center (solo escritorio) -->
        <div class="hidden md:flex w-full items-center z-10 justify-center p-4" id="navbar-center">
            <ul class="menu menu-horizontal flex m-0 text-white">

                <!-- Vuelos -->
                <li class="relative px-2 desktop-section">
                    <button class="desktop-title flex items-center gap-1">
                        Vuelos
                        <i class="fa-solid fa-chevron-down text-xs arrow"></i>
                    </button>

                    <ul class="desktop-submenu absolute hidden flex-col bg-[var(--azul-oscuro)] p-2 w-40 rounded shadow">
                        <c:if test="${usuarioTipo != null && usuarioTipo== 'aerolinea'}">
                            <li><a class="block p-3" href="${pageContext.request.contextPath}/vuelo/crear">Crear vuelo</a></li>
                        </c:if>
                        <li><a class="block p-3" href="${pageContext.request.contextPath}/vuelo/buscar">Buscar vuelo</a></li>
                    </ul>
                </li>

                <!-- Paquetes -->
                <li class="relative px-2 desktop-section">
                    <button class="desktop-title flex items-center gap-1">
                        Paquetes
                        <i class="fa-solid fa-chevron-down text-xs arrow"></i>
                    </button>

                    <ul class="desktop-submenu absolute hidden flex-col bg-[var(--azul-oscuro)] p-2 w-52 rounded shadow">

                        <c:if test="${usuarioTipo!= null}">
                            <c:if test="${usuarioTipo=='aerolinea'}">
                                <li><a class="block p-3" href="${pageContext.request.contextPath}/paquete/crear">Crear paquete</a></li>
                            </c:if>
                            <li><a class="block p-3" href="${pageContext.request.contextPath}/paquete/ver">Ver mis paquetes</a></li>
                        </c:if>

                        <li><a class="block p-3" href="${pageContext.request.contextPath}/paquete/buscar">Consultar paquetes</a></li>

                        <c:if test="${usuarioTipo!=null && usuarioTipo=='cliente'}">
                            <li><a class="block p-3" href="${pageContext.request.contextPath}/paquete/comprar">Comprar paquete</a></li>
                        </c:if>
                    </ul>
                </li>

                <!-- Rutas (solo aerolínea) -->
                <c:if test="${usuarioTipo!= null && usuarioTipo=='aerolinea'}">
                    <li class="relative px-2 desktop-section">
                        <button class="desktop-title flex items-center gap-1">
                            Rutas de vuelo
                            <i class="fa-solid fa-chevron-down text-xs arrow"></i>
                        </button>

                        <ul class="desktop-submenu absolute hidden flex-col bg-[var(--azul-oscuro)] p-2 w-44 rounded shadow">
                            <li><a class="block p-3" href="${pageContext.request.contextPath}/ruta-de-vuelo/crear">Crear ruta</a></li>
                            <li><a class="block p-3" href="${pageContext.request.contextPath}/ruta-de-vuelo/ver">Ver rutas</a></li>
                        </ul>
                    </li>
                </c:if>

                <!-- Reservas -->
                <c:if test="${usuarioTipo!= null}">
                    <li class="relative px-2 desktop-section">
                        <button class="desktop-title flex items-center gap-1">
                            Reservas
                            <i class="fa-solid fa-chevron-down text-xs arrow"></i>
                        </button>

                        <ul class="desktop-submenu absolute hidden flex-col bg-[var(--azul-oscuro)] p-2 w-44 rounded shadow">

                            <c:if test="${usuarioTipo=='cliente'}">
                                <li><a class="block p-3" href="${pageContext.request.contextPath}/reservas/crear">Crear reserva</a></li>
                            </c:if>
                            <li><a class="block p-3" href="${pageContext.request.contextPath}/reservas/ver">Ver mis reservas</a></li>
                        </ul>
                    </li>
                </c:if>

                <!-- Usuarios -->
                <li class="relative px-2 desktop-section">
                    <button class="desktop-title flex items-center gap-1">
                        Usuarios
                        <i class="fa-solid fa-chevron-down text-xs arrow"></i>
                    </button>

                    <ul class="desktop-submenu absolute hidden flex-col bg-[var(--azul-oscuro)] p-2 w-40 rounded shadow">
                        <li><a class="block p-3" href="${pageContext.request.contextPath}/perfil/buscar">Buscar usuario</a></li>
                    </ul>
                </li>

            </ul>
        </div>
    </nav>

</header>

<script defer>

    /* DESKTOP DROPDOWNS */
    document.querySelectorAll(".desktop-section").forEach(section => {

        const title = section.querySelector(".desktop-title");
        const submenu = section.querySelector(".desktop-submenu");
        const arrow = section.querySelector(".arrow");

        title.addEventListener("click", () => {
            const open = submenu.classList.contains("open");

            document.querySelectorAll(".desktop-submenu").forEach(s => {
                s.classList.add("hidden");
                s.classList.remove("open");
            });
            document.querySelectorAll(".desktop-section .arrow").forEach(a => {
                a.style.transform = "rotate(0deg)";
            });

            if (!open) {
                submenu.classList.remove("hidden");
                submenu.classList.add("open");
                arrow.style.transform = "rotate(180deg)";
            }
        });
    });

    /* MOBILE MENU GENERAL */
    const btnMobileMenu = document.getElementById("btn-mobile-menu");
    const mobileMenu = document.getElementById("mobile-menu");

    btnMobileMenu.addEventListener("click", () => {
        mobileMenu.classList.toggle("hidden");
    });

    /* MOBILE SUBMENUS */
    document.querySelectorAll(".menu-title").forEach(btn => {
        btn.addEventListener("click", () => {
            const submenu = btn.nextElementSibling;

            submenu.classList.toggle("hidden");
        });
    });

    const formHeader = document.getElementById('formBuscar');

    formHeader.addEventListener('submit', (e) => {
        e.preventDefault();
        const palabraBuscar = document.getElementById("busqueda");
        if (palabraBuscar) {
            window.location.href = '${pageContext.request.contextPath}/home?busqueda=' + palabraBuscar.value;
        }
    });

</script>

<style>
    .desktop-submenu {
        opacity: 0;
        transform: translateY(-6px);
        transition: all 0.22s ease;
    }

    .desktop-submenu.open {
        opacity: 1;
        transform: translateY(0);
    }

    .animate-fade {
        animation: fadeIn 0.25s ease;
    }

    @keyframes fadeIn {
        from { opacity: 0; transform: translateY(-6px); }
        to   { opacity: 1; transform: translateY(0); }
    }
</style>
