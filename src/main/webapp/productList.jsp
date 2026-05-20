<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="model.ProductDTO"%>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ include file="header.jsp"%>

<%
List<ProductDTO> displayList = (List<ProductDTO>) request.getAttribute("products");
if (displayList == null) displayList = new java.util.ArrayList<>();
String keyword  = (String) request.getAttribute("keyword");
String category = (String) request.getAttribute("category");
String sort     = (String) request.getAttribute("sort");
if (keyword  == null) keyword  = "";
if (category == null) category = "";
if (sort     == null) sort     = "latest";
%>

<main class="max-w-7xl mx-auto px-4 sm:px-6 py-10">

  <!-- 히어로 배너 -->
  <div class="bg-gradient-to-r from-[#18161a] to-[#201d25] border border-[rgba(200,169,110,0.2)] rounded-2xl p-4 sm:p-8 text-center mb-8">
    <p class="text-[11px] font-medium tracking-[0.2em] uppercase text-[#c8a96e] mb-2">Fresh Food</p>
    <h1 class="text-2xl font-bold text-[#f0ede8]">푸드마켓</h1>
    <p class="text-sm text-[#8a8790] mt-1">신선한 식품을 합리적인 가격으로</p>
  </div>

  <!-- 검색 + 정렬 바 -->
  <div class="flex flex-col sm:flex-row gap-3 mb-6">

    <!-- 검색창 -->
    <form method="get" action="list" class="flex gap-2 flex-1">
      <c:if test="${not empty category}">
        <input type="hidden" name="category" value="${category}" />
      </c:if>
      <input type="hidden" name="sort" value="${sort}" />
      <div class="relative flex-1 flex bg-[#1a1a20] border border-[rgba(255,255,255,0.07)] rounded-xl overflow-hidden focus-within:border-[#a8894e] transition-colors">
        <input type="text" name="keyword" value="${keyword}"
               placeholder="상품명 검색..."
               class="flex-1 bg-transparent border-none text-sm text-[#f0ede8] focus:outline-none"
               style="width:auto; border:none; border-radius:0; padding:10px 16px;">
        <button type="submit"
                class="px-4 text-[#8a8790] hover:text-[#c8a96e] transition-colors flex items-center"
                style="width:auto; border:none; background:none; cursor:pointer;">
          <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="none"
               stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" viewBox="0 0 24 24">
            <circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/>
          </svg>
        </button>
      </div>
    </form>

    <!-- 정렬 드롭다운 -->
    <form method="get" action="list" id="sortForm">
      <c:if test="${not empty keyword}">
        <input type="hidden" name="keyword" value="${keyword}" />
      </c:if>
      <c:if test="${not empty category}">
        <input type="hidden" name="category" value="${category}" />
      </c:if>
      <select name="sort" onchange="document.getElementById('sortForm').submit()"
              style="width:auto; padding:10px 16px; cursor:pointer;">
        <option value="latest"     <%= "latest".equals(sort)     ? "selected" : "" %>>최신순</option>
        <option value="price_asc"  <%= "price_asc".equals(sort)  ? "selected" : "" %>>가격 낮은순</option>
        <option value="price_desc" <%= "price_desc".equals(sort) ? "selected" : "" %>>가격 높은순</option>
      </select>
    </form>

    <% if ("admin".equals(userRole)) { %>
    <a href="insertProduct.jsp"
       class="flex items-center justify-center px-4 py-2.5 rounded-xl bg-[#c8a96e] text-[#0a0a0b] text-sm font-semibold hover:bg-[#d4b87e] transition-colors whitespace-nowrap">
      + 상품 등록
    </a>
    <% } %>
  </div>

  <!-- 검색 결과 안내 -->
  <% if (!keyword.isEmpty()) { %>
  <p class="text-sm text-[#8a8790] mb-6">
    &ldquo;<span class="text-[#c8a96e]"><%= keyword %></span>&rdquo; 검색 결과
    <span class="text-[#4a4850]">— <%= displayList.size() %>개</span>
    <a href="list" class="ml-3 text-xs text-[#4a4850] hover:text-[#8a8790] underline transition-colors">검색 초기화</a>
  </p>
  <% } else { %>
  <p class="text-sm text-[#8a8790] mb-6">
    전체 상품 <span class="text-[#c8a96e] font-semibold"><%= displayList.size() %>개</span>
  </p>
  <% } %>

  <!-- 상품 그리드 -->
  <% if (!displayList.isEmpty()) { %>
  <div class="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4 gap-4 sm:gap-5">
    <% for (ProductDTO p : displayList) {
       String imgPath = (p.getImgUrl() != null && !p.getImgUrl().isEmpty())
           ? p.getImgUrl() : request.getContextPath() + "/images/no-image.png";
    %>
    <div class="bg-[#18181c] border border-[rgba(255,255,255,0.07)] rounded-2xl overflow-hidden
                hover:border-[rgba(200,169,110,0.35)] hover:bg-[#1e1e24]
                transition-all duration-200 group flex flex-col">

      <a href="detail?id=<%= p.getId() %>" class="block flex-1">
        <div class="aspect-square bg-[#141418] overflow-hidden relative">
          <img src="<%= imgPath %>" alt="<%= p.getName() %>"
               class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500"
               onerror="this.src='<%= request.getContextPath() %>/images/no-image.png'; this.onerror=null;">
          <% if (p.getStock() <= 0) { %>
          <div class="absolute inset-0 bg-black/60 flex items-center justify-center">
            <span class="px-3 py-1 rounded text-[10px] font-bold tracking-widest bg-[rgba(226,75,74,0.15)] text-[#e24b4a] border border-[rgba(226,75,74,0.3)] uppercase">품절</span>
          </div>
          <% } %>
        </div>

        <div class="p-4 flex flex-col">
          <p class="text-[10px] font-medium tracking-[0.12em] text-[#a8894e] uppercase mb-1.5">
            <%= (p.getCategory() != null) ? p.getCategory() : "기타" %>
          </p>
          <h3 class="text-sm font-medium text-[#f0ede8] mb-2 leading-snug line-clamp-2">
            <%= (p.getName() != null) ? p.getName() : "이름 없음" %>
          </h3>

          <% if (p.getReviewCount() > 0) { %>
          <div class="flex items-center gap-1 mb-2">
            <span class="text-[#c8a96e] text-xs tracking-wider">
              <% for (int i = 1; i <= 5; i++) { %><%= (i <= p.getAvgRating()) ? "★" : "☆" %><% } %>
            </span>
            <span class="text-[11px] text-[#8a8790]">(<%= p.getReviewCount() %>)</span>
          </div>
          <% } else { %>
          <div class="mb-2"><span class="text-[11px] text-[#4a4850]">리뷰 없음</span></div>
          <% } %>

          <div class="flex items-center justify-between mt-1">
            <p class="text-base font-semibold text-[#c8a96e]">
              <%= String.format("%,d", p.getPrice()) %><span class="text-xs font-normal text-[#8a8790] ml-0.5">원</span>
            </p>
            <p class="text-[11px] text-[#4a4850]"><%= p.getStock() == 1 ? "1개 남음" : "수량 " + p.getStock() + "개" %></p>
          </div>
        </div>
      </a>

      <% if ("admin".equals(userRole)) { %>
      <div class="flex border-t border-[rgba(255,255,255,0.07)]">
        <a href="edit?id=<%= p.getId() %>"
           class="flex-1 py-2.5 text-center text-xs font-medium text-[#8a8790] hover:text-[#f0ede8] hover:bg-[rgba(255,255,255,0.05)] transition-all">수정</a>
        <div class="w-px bg-[rgba(255,255,255,0.07)]"></div>
        <a href="delete?id=<%= p.getId() %>"
           onclick="return confirm('정말 삭제하시겠습니까?')"
           class="flex-1 py-2.5 text-center text-xs font-medium text-[#e24b4a] hover:bg-[rgba(226,75,74,0.08)] transition-all">삭제</a>
      </div>
      <% } %>
    </div>
    <% } %>
  </div>

  <% } else { %>
  <div class="flex flex-col items-center justify-center py-24 text-center">
    <p class="text-5xl mb-4 opacity-20">🔍</p>
    <p class="text-base text-[#f0ede8] font-medium mb-1">
      <% if (!keyword.isEmpty()) { %>검색 결과가 없어요<% } else { %>상품이 없습니다<% } %>
    </p>
    <% if (!keyword.isEmpty()) { %>
    <p class="text-sm text-[#8a8790]">&ldquo;<%= keyword %>&rdquo;에 해당하는 상품을 찾지 못했습니다</p>
    <a href="list"
       class="mt-6 px-5 py-2.5 rounded-lg border border-[rgba(255,255,255,0.07)] text-sm text-[#8a8790] hover:text-[#f0ede8] hover:border-[rgba(255,255,255,0.15)] transition-all">
      전체 상품 보기
    </a>
    <% } %>
  </div>
  <% } %>

</main>

<!-- TOP 버튼 -->
<button id="topBtn"
        onclick="window.scrollTo({top:0, behavior:'smooth'})"
        class="fixed bottom-6 right-6 w-11 h-11 rounded-full bg-[#18181c] border border-[rgba(255,255,255,0.07)] text-[#8a8790] text-xs font-bold flex items-center justify-center hover:border-[rgba(200,169,110,0.35)] hover:text-[#c8a96e] transition-all z-40"
        style="opacity:0; visibility:hidden;">
  TOP
</button>

<script>
window.onscroll = function() {
  const btn = document.getElementById("topBtn");
  if (document.body.scrollTop > 300 || document.documentElement.scrollTop > 300) {
    btn.style.opacity = '1'; btn.style.visibility = 'visible';
  } else {
    btn.style.opacity = '0'; btn.style.visibility = 'hidden';
  }
};
</script>

<%@ include file="footer.jsp"%>
