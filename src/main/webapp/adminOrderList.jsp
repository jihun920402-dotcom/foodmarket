<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="model.OrderDAO, model.OrderDTO, java.util.List"%>
<%@ page import="model.MemberDTO"%>
<%@ include file="header.jsp"%>

<%
if (!"admin".equals(userRole)) {
    out.println("<script>alert('관리자만 접근 가능합니다.'); location.href='list';</script>");
    return;
}

OrderDAO dao = new OrderDAO();
List<OrderDTO> list = dao.getAllOrders();
%>

<main class="max-w-7xl mx-auto px-4 sm:px-6 py-10">
  <div class="mb-8 flex items-center justify-between">
    <div>
      <h1 class="text-2xl font-bold text-[#f0ede8] tracking-tight">전체 주문 관리</h1>
      <p class="text-sm text-[#8a8790] mt-1">총 <span class="text-[#c8a96e] font-semibold"><%= list != null ? list.size() : 0 %></span>건</p>
    </div>
  </div>

  <div class="bg-[#18181c] border border-[rgba(255,255,255,0.07)] rounded-2xl overflow-hidden">
    <div class="overflow-x-auto">
      <table class="w-full text-sm" style="min-width: 860px;">
        <thead>
          <tr class="border-b border-[rgba(255,255,255,0.07)]">
            <th class="px-5 py-3.5 text-left text-[10px] font-medium tracking-[0.1em] uppercase text-[#8a8790]">주문번호</th>
            <th class="px-5 py-3.5 text-left text-[10px] font-medium tracking-[0.1em] uppercase text-[#8a8790]">주문자 ID</th>
            <th class="px-5 py-3.5 text-left text-[10px] font-medium tracking-[0.1em] uppercase text-[#8a8790]">결제금액</th>
            <th class="px-5 py-3.5 text-left text-[10px] font-medium tracking-[0.1em] uppercase text-[#8a8790]">주문일시</th>
            <th class="px-5 py-3.5 text-left text-[10px] font-medium tracking-[0.1em] uppercase text-[#8a8790]">배송지</th>
            <th class="px-5 py-3.5 text-left text-[10px] font-medium tracking-[0.1em] uppercase text-[#8a8790]">상태</th>
            <th class="px-5 py-3.5 text-left text-[10px] font-medium tracking-[0.1em] uppercase text-[#8a8790]">관리</th>
          </tr>
        </thead>
        <tbody>
          <% if (list != null && !list.isEmpty()) {
               for (OrderDTO order : list) {
                 String cs = order.getStatus();
                 String badgeCls;
                 if ("배송완료".equals(cs)) badgeCls = "bg-[rgba(133,192,64,0.12)] text-[#85c040] border-[rgba(133,192,64,0.25)]";
                 else if ("배송중".equals(cs)) badgeCls = "bg-[rgba(200,169,110,0.12)] text-[#c8a96e] border-[rgba(200,169,110,0.25)]";
                 else badgeCls = "bg-[rgba(255,255,255,0.05)] text-[#8a8790] border-[rgba(255,255,255,0.07)]";
          %>
          <tr class="border-b border-[rgba(255,255,255,0.05)] hover:bg-[rgba(255,255,255,0.02)] transition-colors">
            <td class="px-5 py-4 font-mono text-xs text-[#8a8790]">#<%= order.getOrderId() %></td>
            <td class="px-5 py-4 text-sm font-medium text-[#f0ede8]"><%= order.getUserid() %></td>
            <td class="px-5 py-4 text-sm font-semibold text-[#c8a96e]"><%= String.format("%,d", order.getTotalPrice()) %>원</td>
            <td class="px-5 py-4 text-xs text-[#8a8790]"><%= order.getOrderDate() %></td>
            <td class="px-5 py-4 text-xs text-[#8a8790] max-w-[160px] truncate" title="<%= order.getAddress() %>"><%= order.getAddress() %></td>
            <td class="px-5 py-4">
              <span class="px-2.5 py-1 rounded text-[10px] font-bold tracking-wider uppercase border <%= badgeCls %>"><%= cs %></span>
            </td>
            <td class="px-5 py-4">
              <div class="flex items-center gap-2">
                <form action="updateOrderStatus" method="get" class="flex items-center gap-1">
                  <input type="hidden" name="orderId" value="<%= order.getOrderId() %>">
                  <select name="status" style="width:auto; padding:6px 10px; font-size:12px;">
                    <option value="결제완료" <%= "결제완료".equals(cs) ? "selected" : "" %>>결제완료</option>
                    <option value="배송중" <%= "배송중".equals(cs) ? "selected" : "" %>>배송중</option>
                    <option value="배송완료" <%= "배송완료".equals(cs) ? "selected" : "" %>>배송완료</option>
                  </select>
                  <button type="submit"
                          class="px-2.5 py-1.5 rounded-lg text-xs bg-[rgba(133,192,64,0.1)] text-[#85c040] border border-[rgba(133,192,64,0.25)] hover:bg-[rgba(133,192,64,0.2)] transition-all"
                          style="width:auto; border:1px solid rgba(133,192,64,0.25); cursor:pointer;">변경</button>
                </form>
                <button onclick="if(confirm('주문을 취소하시겠습니까?')) location.href='deleteOrder?orderId=<%= order.getOrderId() %>'"
                        class="px-2.5 py-1.5 rounded-lg text-xs text-[#e24b4a] border border-[rgba(226,75,74,0.25)] hover:bg-[rgba(226,75,74,0.08)] transition-all"
                        style="background:none; cursor:pointer;">취소</button>
              </div>
            </td>
          </tr>
          <% } } else { %>
          <tr>
            <td colspan="7" class="text-center py-16 text-[#4a4850]">현재 들어온 주문이 없습니다.</td>
          </tr>
          <% } %>
        </tbody>
      </table>
    </div>
  </div>
</main>

<%@ include file="footer.jsp"%>
