<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="header.jsp"%>

<%
String orderId = request.getParameter("orderId");
String totalPriceParam = request.getParameter("totalPrice");
String pName = request.getParameter("pName");

if (orderId == null) orderId = "확인중";
if (pName == null) pName = "선택 상품";

int displayPrice = 0;
if (totalPriceParam != null && !totalPriceParam.isEmpty()) {
    try { displayPrice = Integer.parseInt(totalPriceParam); } catch (NumberFormatException e) {}
}
%>

<main class="max-w-7xl mx-auto px-4 sm:px-6 py-16 flex items-center justify-center min-h-[70vh]">
  <div class="w-full max-w-lg text-center">

    <div class="w-20 h-20 rounded-full bg-[rgba(133,192,64,0.12)] border border-[rgba(133,192,64,0.25)] flex items-center justify-center mx-auto mb-6">
      <span class="text-4xl">✓</span>
    </div>

    <h1 class="text-2xl font-bold text-[#f0ede8] mb-2">주문 완료!</h1>
    <p class="text-sm text-[#8a8790] mb-8">저희 마켓을 이용해 주셔서 진심으로 감사합니다.</p>

    <div class="bg-[#18181c] border border-[rgba(255,255,255,0.07)] rounded-2xl p-6 text-left mb-8">
      <p class="text-[10px] font-medium tracking-[0.12em] uppercase text-[#4a4850] mb-4">주문 상세 내역</p>
      <div class="space-y-3">
        <div class="flex justify-between py-2 border-b border-[rgba(255,255,255,0.05)]">
          <span class="text-xs text-[#8a8790]">주문 번호</span>
          <span class="text-sm font-mono font-semibold text-[#f0ede8]"><%= orderId %></span>
        </div>
        <div class="flex justify-between py-2 border-b border-[rgba(255,255,255,0.05)]">
          <span class="text-xs text-[#8a8790]">주문 상품</span>
          <span class="text-sm font-medium text-[#f0ede8] text-right max-w-xs"><%= pName %></span>
        </div>
        <div class="flex justify-between py-2">
          <span class="text-xs text-[#8a8790]">총 결제 금액</span>
          <span class="text-base font-bold text-[#c8a96e]"><%= String.format("%,d", displayPrice) %>원</span>
        </div>
      </div>
    </div>

    <div class="flex flex-col sm:flex-row gap-3 justify-center">
      <a href="list"
         class="flex items-center justify-center px-8 py-3 rounded-xl border border-[rgba(255,255,255,0.07)] text-sm text-[#8a8790] hover:text-[#f0ede8] hover:border-[rgba(255,255,255,0.15)] transition-all">
        계속 쇼핑하기
      </a>
      <a href="orderList"
         class="flex items-center justify-center px-8 py-3 rounded-xl bg-[#c8a96e] text-[#0a0a0b] text-sm font-bold hover:bg-[#d4b87e] transition-colors">
        나의 주문목록
      </a>
    </div>

  </div>
</main>

<%@ include file="footer.jsp"%>
