<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<aside class="w-[90%] sm:w-2/3 md:w-80 bg-white rounded-xl shadow-2xl overflow-hidden transform transition-all duration-300 h-fit">
    <div class="p-5 bg-gradient-to-br from-[#f8fdff] to-[#e8f7ff] border-b border-[#2bc8c8]/20">
        <div class="bg-white rounded-lg p-4 shadow-sm border border-[#269fb8]/20">
            <p class="font-bold text-[#0c2636] text-lg mb-3 flex items-center">
                <i class="fas fa-user-circle mr-2 text-[#1d6e86]"></i>
                MI PERFIL
            </p>
            <div class="space-y-2">
                <c:choose>
                    <c:when test="${not empty sessionScope.usuarioNickname}">
                        <c:if test="${sessionScope.usuarioTipo == 'aerolinea'}">
                            <a href="${pageContext.request.contextPath}/ruta-de-vuelo/crear"
                               class="flex items-center py-2 px-3 rounded-lg hover:bg-[#e8f7ff] transition-all duration-200 text-[#12445d] group border border-transparent hover:border-[#2bc8c8]/30">
                                <i class="fas fa-route mr-2 text-[#1d6e86] group-hover:text-[#2bc8c8]"></i>
                                Nueva Ruta
                            </a>
                            <a href="${pageContext.request.contextPath}/vuelo/crear"
                               class="flex items-center py-2 px-3 rounded-lg hover:bg-[#e8f7ff] transition-all duration-200 text-[#12445d] group border border-transparent hover:border-[#2bc8c8]/30">
                                <i class="fas fa-plane mr-2 text-[#1d6e86] group-hover:text-[#2bc8c8]"></i>
                                Nuevo Vuelo
                            </a>
                        </c:if>
                        <c:if test="${sessionScope.usuarioTipo == 'cliente'}">
                            <a href="${pageContext.request.contextPath}/reservas/crear"
                               class="flex items-center py-2 px-3 rounded-lg hover:bg-[#e8f7ff] transition-all duration-200 text-[#12445d] group border border-transparent hover:border-[#2bc8c8]/30">
                                <i class="fas fa-plane mr-2 text-[#1d6e86] group-hover:text-[#2bc8c8]"></i>
                                Reservar un Vuelo
                            </a>
                            <a href="${pageContext.request.contextPath}/paquete/comprar"
                               class="flex items-center py-2 px-3 rounded-lg hover:bg-[#e8f7ff] transition-all duration-200 text-[#12445d] group border border-transparent hover:border-[#2bc8c8]/30">
                                <i class="fa-solid fa-boxes-packing mr-2 text-[#1d6e86] group-hover:text-[#2bc8c8]"></i>
                                Comprar un Paquete
                            </a>
                        </c:if>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/login"
                           class="flex items-center py-2 px-3 rounded-lg hover:bg-[#e8f7ff] transition-all duration-200 text-[#12445d] group border border-transparent hover:border-[#2bc8c8]/30">
                            <i class="fa-solid fa-user mr-2 text-[#1d6e86] group-hover:text-[#2bc8c8]"></i>
                            Iniciar Sesion
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <div class="p-5">
        <h3 class="text-lg font-semibold text-[#0c2636] mb-4 flex items-center">
            <i class="fas fa-tags mr-2 text-[#1d6e86]"></i>
            CATEGORÍAS
        </h3>
        <div class="h-px bg-gradient-to-r from-transparent via-[#269fb8] to-transparent mb-4"></div>
        <ul class="space-y-2 max-h-96 overflow-y-auto">
            <c:if test="${not empty applicationScope.categorias}">
                <c:forEach var="categoria" items="${applicationScope.categorias}">
                    <li class="group">
                        <a href="${pageContext.request.contextPath}/home?nombre=${categoria}" class="flex items-center py-2 px-3 mx-2 rounded-lg text-[#12445d] hover:bg-[#e8f7ff] transition-all duration-200 hover:translate-x-1 border border-transparent hover:border-[#2bc8c8]/20">
                            <i class="fas fa-chevron-right mr-2 text-[#1d6e86] text-xs group-hover:text-[#2bc8c8]"></i>
                                ${categoria.nombre}
                        </a>
                    </li>
                </c:forEach>
            </c:if>
        </ul>
    </div>

    <div class="bg-gradient-to-r from-[#1d6e86] to-[#2bc8c8] h-1.5 w-full"></div>
</aside>