<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="model.MarketInfoDAO, model.MarketInfoDTO"%>
<%@ include file="header.jsp"%>
<%
if (loginUser == null || !"admin".equals(loginUser.getRole())) {
    out.println("<script>alert('관리자만 접근 가능한 페이지입니다.'); location.href='list';</script>");
    return;
}

MarketInfoDAO infoDao = new MarketInfoDAO();
MarketInfoDTO info = infoDao.getInfo();
%>

<main class="max-w-7xl mx-auto px-4 sm:px-6 py-10">
  <div class="max-w-lg mx-auto">
    <div class="mb-8">
      <h1 class="text-2xl font-bold text-[#f0ede8] tracking-tight">시스템 설정</h1>
      <p class="text-sm text-[#8a8790] mt-1">마켓 입금 계좌 정보를 관리합니다</p>
    </div>

    <% if ("1".equals(request.getParameter("success"))) { %>
    <div class="mb-6 px-5 py-4 rounded-xl bg-[rgba(133,192,64,0.1)] border border-[rgba(133,192,64,0.25)] text-sm text-[#85c040]">
      계좌 정보가 성공적으로 업데이트되었습니다!
    </div>
    <% } %>

    <div class="bg-[#18181c] border border-[rgba(255,255,255,0.07)] rounded-2xl overflow-hidden">
      <div class="px-6 py-4 border-b border-[rgba(255,255,255,0.07)]">
        <h2 class="text-sm font-bold text-[#f0ede8]">입금 계좌 관리</h2>
        <p class="text-xs text-[#8a8790] mt-1">변경사항은 모든 고객의 마이페이지 충전 화면에 즉시 반영됩니다.</p>
      </div>
      <div class="p-6">
        <form action="updateMarketInfo" method="post" class="space-y-5">
          <div>
            <label class="block text-xs font-medium tracking-[0.08em] uppercase text-[#8a8790] mb-2">은행명</label>
            <input type="text" name="bankName"
                   value="<%= (info != null) ? info.getBankName() : "" %>"
                   required style="width:100%;">
          </div>
          <div>
            <label class="block text-xs font-medium tracking-[0.08em] uppercase text-[#8a8790] mb-2">계좌번호</label>
            <input type="text" name="accountNumber"
                   value="<%= (info != null) ? info.getAccountNumber() : "" %>"
                   required style="width:100%;">
          </div>
          <div>
            <label class="block text-xs font-medium tracking-[0.08em] uppercase text-[#8a8790] mb-2">예금주 (회사명)</label>
            <input type="text" name="accountHolder"
                   value="<%= (info != null) ? info.getAccountHolder() : "" %>"
                   required style="width:100%;">
          </div>
          <div class="flex flex-col gap-3 pt-2">
            <button type="submit"
                    class="w-full py-3 rounded-xl bg-[#c8a96e] text-[#0a0a0b] text-sm font-bold hover:bg-[#d4b87e] transition-colors"
                    style="width:100%; border:none; cursor:pointer;">
              정보 업데이트
            </button>
            <a href="list"
               class="flex items-center justify-center w-full py-3 rounded-xl border border-[rgba(255,255,255,0.07)] text-[#8a8790] text-sm hover:text-[#f0ede8] hover:border-[rgba(255,255,255,0.15)] transition-all">
              돌아가기
            </a>
          </div>
        </form>
      </div>
    </div>
  </div>
</main>

<%@ include file="footer.jsp"%>
