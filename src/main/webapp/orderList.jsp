<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="model.OrderDTO, java.util.List"%>
<%
List<OrderDTO> orderList = (List<OrderDTO>) request.getAttribute("orderList");
%>
<%@ include file="header.jsp"%>

<main class="max-w-7xl mx-auto px-4 sm:px-6 py-10">
  <div class="max-w-3xl mx-auto">
    <div class="mb-8">
      <h1 class="text-2xl font-bold text-[#f0ede8] tracking-tight">주문 내역</h1>
      <p class="text-sm text-[#8a8790] mt-1">
        총 <span class="text-[#c8a96e] font-semibold"><%= (orderList != null) ? orderList.size() : 0 %></span>건
      </p>
    </div>

    <% if (orderList != null && !orderList.isEmpty()) {
         for (OrderDTO order : orderList) {
           String status = order.getStatus();
    %>
    <div class="bg-[#18181c] border border-[rgba(255,255,255,0.07)] rounded-2xl p-5 mb-4
                hover:border-[rgba(200,169,110,0.2)] transition-all">
      <div class="flex items-center justify-between mb-4">
        <div class="flex items-center gap-3 flex-wrap">
          <span class="text-xs text-[#4a4850] font-mono">#<%= order.getOrderId() %></span>
          <span class="text-xs text-[#4a4850]"><%= order.getOrderDate() %></span>
        </div>
        <%
          String badgeCls, statusColor;
          if ("배송완료".equals(status)) {
            badgeCls = "bg-[rgba(133,192,64,0.12)] text-[#85c040] border-[rgba(133,192,64,0.25)]";
          } else if ("배송중".equals(status)) {
            badgeCls = "bg-[rgba(200,169,110,0.12)] text-[#c8a96e] border-[rgba(200,169,110,0.25)]";
          } else {
            badgeCls = "bg-[rgba(255,255,255,0.05)] text-[#8a8790] border-[rgba(255,255,255,0.07)]";
          }
        %>
        <span class="px-2.5 py-1 rounded text-[10px] font-bold tracking-wider uppercase border <%= badgeCls %>">
          <%= status %>
        </span>
      </div>

      <div class="flex items-end justify-between">
        <div>
          <p class="text-sm font-medium text-[#f0ede8]">주문 #<%= order.getOrderId() %></p>
          <p class="text-xs text-[#8a8790] mt-1">배송지: <%= order.getAddress() %></p>
        </div>
        <div class="text-right">
          <p class="text-lg font-bold text-[#c8a96e]"><%= String.format("%,d", order.getTotalPrice()) %>원</p>
          <button onclick="location.href='orderDetail.jsp?orderId=<%= order.getOrderId() %>'"
                  class="mt-2 px-4 py-1.5 rounded-lg text-xs border border-[rgba(255,255,255,0.07)] text-[#8a8790] hover:text-[#f0ede8] hover:border-[rgba(255,255,255,0.15)] transition-all"
                  style="background:none; cursor:pointer;">
            상세보기
          </button>
        </div>
      </div>
    </div>
    <% } } else { %>
    <div class="text-center py-24 text-[#4a4850]">
      <p class="text-5xl mb-4">📝</p>
      <p class="text-base text-[#8a8790]">최근 주문한 내역이 없습니다.</p>
      <a href="list" class="inline-block mt-6 px-6 py-2.5 rounded-lg text-sm bg-[#c8a96e] text-[#0a0a0b] font-semibold hover:bg-[#d4b87e] transition-colors">상품 보러가기</a>
    </div>
    <% } %>
  </div>
</main>

<%@ include file="footer.jsp"%>
