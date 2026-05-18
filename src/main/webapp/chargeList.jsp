<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="model.*"%>
<%@ page import="java.util.*"%>
<%@ include file="header.jsp"%>

<%
MemberDTO currentUser = (MemberDTO) session.getAttribute("loginUser");

if (currentUser == null) {
    response.sendRedirect("login.jsp");
    return;
}

ChargeDAO dao = new ChargeDAO();
List<ChargeDTO> list = dao.getChargeList(currentUser.getUserid());
%>

<main class="max-w-7xl mx-auto px-4 sm:px-6 py-10">
  <div class="max-w-2xl mx-auto">

    <!-- 마일리지 배너 -->
    <div class="bg-gradient-to-br from-[#18161a] to-[#201d25] border border-[rgba(200,169,110,0.2)] rounded-2xl p-8 text-center mb-8">
      <p class="text-[11px] font-medium tracking-[0.2em] uppercase text-[#c8a96e] mb-2">Mileage Center</p>
      <h2 class="text-2xl font-bold text-[#f0ede8]">마일리지 충전 내역</h2>
      <p class="text-sm text-[#8a8790] mt-1">안전하고 빠른 마일리지 충전 시스템</p>
    </div>

    <div class="flex items-center justify-between mb-6">
      <h3 class="text-base font-bold text-[#f0ede8]">충전 내역</h3>
      <a href="chargeRequest.jsp"
         class="px-4 py-2 rounded-lg text-sm bg-[#c8a96e] text-[#0a0a0b] font-semibold hover:bg-[#d4b87e] transition-colors">
        + 충전 신청
      </a>
    </div>

    <div class="bg-[#18181c] border border-[rgba(255,255,255,0.07)] rounded-2xl overflow-hidden mb-8">
      <div class="overflow-x-auto">
        <table class="w-full text-sm" style="min-width: 400px;">
          <thead>
            <tr class="border-b border-[rgba(255,255,255,0.07)]">
              <th class="px-5 py-3.5 text-left text-[10px] font-medium tracking-[0.1em] uppercase text-[#8a8790]">신청 번호</th>
              <th class="px-5 py-3.5 text-left text-[10px] font-medium tracking-[0.1em] uppercase text-[#8a8790]">신청 금액</th>
              <th class="px-5 py-3.5 text-left text-[10px] font-medium tracking-[0.1em] uppercase text-[#8a8790]">신청 일시</th>
              <th class="px-5 py-3.5 text-left text-[10px] font-medium tracking-[0.1em] uppercase text-[#8a8790]">처리 상태</th>
            </tr>
          </thead>
          <tbody>
            <% if (list != null && !list.isEmpty()) {
                 for (ChargeDTO c : list) { %>
            <tr class="border-b border-[rgba(255,255,255,0.05)] hover:bg-[rgba(255,255,255,0.02)] transition-colors">
              <td class="px-5 py-4 font-mono text-xs text-[#8a8790]">#<%= c.getRequestId() %></td>
              <td class="px-5 py-4 text-base font-bold text-[#f0ede8]"><%= String.format("%,d", c.getAmount()) %>원</td>
              <td class="px-5 py-4 text-xs text-[#8a8790]"><%= c.getRequestDate() %></td>
              <td class="px-5 py-4">
                <% if ("pending".equalsIgnoreCase(c.getStatus())) { %>
                <span class="px-2.5 py-1 rounded text-[10px] font-bold tracking-wider uppercase bg-[rgba(200,169,110,0.12)] text-[#c8a96e] border border-[rgba(200,169,110,0.25)]">승인 대기</span>
                <% } else if ("success".equalsIgnoreCase(c.getStatus())) { %>
                <span class="px-2.5 py-1 rounded text-[10px] font-bold tracking-wider uppercase bg-[rgba(133,192,64,0.12)] text-[#85c040] border border-[rgba(133,192,64,0.25)]">충전 완료</span>
                <% } else { %>
                <span class="px-2.5 py-1 rounded text-[10px] font-bold tracking-wider uppercase bg-[rgba(255,255,255,0.05)] text-[#8a8790] border border-[rgba(255,255,255,0.07)]"><%= c.getStatus() %></span>
                <% } %>
              </td>
            </tr>
            <% } } else { %>
            <tr>
              <td colspan="4" class="text-center py-16 text-[#4a4850]">충전 신청 내역이 존재하지 않습니다.</td>
            </tr>
            <% } %>
          </tbody>
        </table>
      </div>
    </div>

    <div class="flex justify-center">
      <a href="mypage.jsp"
         class="inline-flex items-center gap-2 px-6 py-2.5 rounded-lg border border-[rgba(255,255,255,0.07)] text-sm text-[#8a8790] hover:text-[#f0ede8] hover:border-[rgba(255,255,255,0.15)] transition-all">
        ← 마이페이지로
      </a>
    </div>

  </div>
</main>

<%@ include file="footer.jsp"%>
