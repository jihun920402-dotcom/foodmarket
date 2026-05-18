<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="model.*, java.util.List"%>
<%
String orderIdStr = request.getParameter("orderId");
int orderId = 0;

if (orderIdStr == null || orderIdStr.trim().isEmpty()) {
    response.sendRedirect("orderList");
    return;
} else {
    try {
        orderId = Integer.parseInt(orderIdStr);
    } catch (NumberFormatException e) {
        response.sendRedirect("orderList");
        return;
    }
}

OrderDAO dao = new OrderDAO();
OrderDTO order = dao.getOrderById(orderId);
List<CartDTO> itemList = dao.getOrderDetailItems(orderId);

if (order == null) {
    response.sendRedirect("orderList");
    return;
}
%>
<%@ include file="header.jsp"%>

<main class="max-w-7xl mx-auto px-4 sm:px-6 py-10">
  <div class="max-w-2xl mx-auto">

    <div class="mb-8 flex items-center justify-between">
      <div>
        <h1 class="text-2xl font-bold text-[#f0ede8] tracking-tight">주문 상세</h1>
        <p class="text-sm text-[#8a8790] mt-1">주문번호 #<%= order.getOrderId() %></p>
      </div>
      <%
        String st = order.getStatus();
        String badgeCls;
        if ("배송완료".equals(st)) badgeCls = "bg-[rgba(133,192,64,0.12)] text-[#85c040] border-[rgba(133,192,64,0.25)]";
        else if ("배송중".equals(st)) badgeCls = "bg-[rgba(200,169,110,0.12)] text-[#c8a96e] border-[rgba(200,169,110,0.25)]";
        else badgeCls = "bg-[rgba(255,255,255,0.05)] text-[#8a8790] border-[rgba(255,255,255,0.07)]";
      %>
      <span class="px-3 py-1.5 rounded text-[10px] font-bold tracking-wider uppercase border <%= badgeCls %>">
        <%= st %>
      </span>
    </div>

    <!-- 주문 요약 -->
    <div class="bg-[#18181c] border border-[rgba(255,255,255,0.07)] rounded-2xl p-5 mb-6">
      <div class="flex justify-between py-2 border-b border-[rgba(255,255,255,0.05)]">
        <span class="text-xs text-[#8a8790]">주문번호</span>
        <span class="text-sm font-mono text-[#f0ede8]">#<%= order.getOrderId() %></span>
      </div>
      <div class="flex justify-between py-2">
        <span class="text-xs text-[#8a8790]">주문일시</span>
        <span class="text-sm text-[#f0ede8]"><%= order.getOrderDate() %></span>
      </div>
    </div>

    <!-- 구매 상품 -->
    <div class="bg-[#18181c] border border-[rgba(255,255,255,0.07)] rounded-2xl overflow-hidden mb-6">
      <div class="px-5 py-4 border-b border-[rgba(255,255,255,0.07)]">
        <h2 class="text-sm font-bold text-[#f0ede8]">구매 상품</h2>
      </div>
      <div class="overflow-x-auto">
        <table class="w-full text-sm" style="min-width: 400px;">
          <thead>
            <tr class="border-b border-[rgba(255,255,255,0.07)]">
              <th colspan="2" class="px-5 py-3 text-left text-[10px] font-medium tracking-[0.1em] uppercase text-[#8a8790]">상품 정보</th>
              <th class="px-5 py-3 text-center text-[10px] font-medium tracking-[0.1em] uppercase text-[#8a8790]">수량</th>
              <th class="px-5 py-3 text-right text-[10px] font-medium tracking-[0.1em] uppercase text-[#8a8790]">금액</th>
            </tr>
          </thead>
          <tbody>
            <% if (itemList != null) {
                 for (CartDTO item : itemList) { %>
            <tr class="border-b border-[rgba(255,255,255,0.05)]">
              <td class="px-5 py-4 w-20">
                <img src="<%= item.getImgUrl() %>" alt=""
                     style="width:64px; height:64px; object-fit:cover; border-radius:8px; border:1px solid rgba(255,255,255,0.07);">
              </td>
              <td class="px-3 py-4">
                <p class="text-sm font-medium text-[#f0ede8]"><%= item.getProductName() %></p>
                <p class="text-xs text-[#8a8790] mt-0.5">단가: <%= String.format("%,d", item.getProductPrice()) %>원</p>
              </td>
              <td class="px-5 py-4 text-center text-sm text-[#8a8790]"><%= item.getCount() %>개</td>
              <td class="px-5 py-4 text-right text-sm font-semibold text-[#f0ede8]"><%= String.format("%,d", item.getProductPrice() * item.getCount()) %>원</td>
            </tr>
            <% } } %>
          </tbody>
          <tfoot>
            <tr class="border-t border-[rgba(255,255,255,0.1)]">
              <td colspan="3" class="px-5 py-4 text-right text-sm text-[#8a8790]">총 결제 금액</td>
              <td class="px-5 py-4 text-right text-lg font-bold text-[#c8a96e]"><%= String.format("%,d", order.getTotalPrice()) %>원</td>
            </tr>
          </tfoot>
        </table>
      </div>
    </div>

    <!-- 배송 정보 -->
    <div class="bg-[#18181c] border border-[rgba(255,255,255,0.07)] rounded-2xl p-5 mb-8">
      <h2 class="text-sm font-bold text-[#f0ede8] mb-4">배송 정보</h2>
      <div class="space-y-3">
        <div class="flex justify-between py-2 border-b border-[rgba(255,255,255,0.05)]">
          <span class="text-xs text-[#8a8790]">수령인</span>
          <span class="text-sm text-[#f0ede8]"><%= order.getReceiverName() %></span>
        </div>
        <div class="flex justify-between py-2 border-b border-[rgba(255,255,255,0.05)]">
          <span class="text-xs text-[#8a8790]">연락처</span>
          <span class="text-sm text-[#f0ede8]"><%= order.getReceiverPhone() != null ? order.getReceiverPhone() : "정보없음" %></span>
        </div>
        <div class="flex justify-between py-2">
          <span class="text-xs text-[#8a8790]">배송지 주소</span>
          <span class="text-sm text-[#f0ede8] text-right max-w-xs"><%= order.getAddress() %></span>
        </div>
      </div>
    </div>

    <div class="flex justify-center">
      <a href="orderList"
         class="px-8 py-3 rounded-xl border border-[rgba(255,255,255,0.07)] text-sm text-[#8a8790] hover:text-[#f0ede8] hover:border-[rgba(255,255,255,0.15)] transition-all">
        목록으로
      </a>
    </div>

  </div>
</main>

<%@ include file="footer.jsp"%>
