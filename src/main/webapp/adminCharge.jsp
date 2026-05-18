<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.ChargeDTO, model.ChargeDAO"%>
<%@ include file="header.jsp"%>

<%
if (loginUser == null || !"admin".equals(loginUser.getRole())) {
    out.println("<script>alert('관리자만 접근 가능합니다.'); location.href='list';</script>");
    return;
}

ChargeDAO dao = new ChargeDAO();
List<ChargeDTO> list = dao.getPendingRequests();
%>

<main class="max-w-7xl mx-auto px-4 sm:px-6 py-10">
  <div class="mb-8">
    <h1 class="text-2xl font-bold text-[#f0ede8] tracking-tight">마일리지 충전 승인</h1>
    <p class="text-sm text-[#8a8790] mt-1">대기 중인 충전 신청을 확인하고 승인합니다</p>
  </div>

  <% if ("1".equals(request.getParameter("approveSuccess"))) { %>
  <div class="mb-6 px-5 py-4 rounded-xl bg-[rgba(133,192,64,0.1)] border border-[rgba(133,192,64,0.25)] text-sm text-[#85c040]">
    충전 승인이 완료되어 마일리지가 지급되었습니다.
  </div>
  <% } %>

  <div class="bg-[#18181c] border border-[rgba(255,255,255,0.07)] rounded-2xl overflow-hidden">
    <div class="overflow-x-auto">
      <table class="w-full text-sm" style="min-width: 580px;">
        <thead>
          <tr class="border-b border-[rgba(255,255,255,0.07)]">
            <th class="px-5 py-3.5 text-left text-[10px] font-medium tracking-[0.1em] uppercase text-[#8a8790]">신청번호</th>
            <th class="px-5 py-3.5 text-left text-[10px] font-medium tracking-[0.1em] uppercase text-[#8a8790]">아이디</th>
            <th class="px-5 py-3.5 text-left text-[10px] font-medium tracking-[0.1em] uppercase text-[#8a8790]">신청금액</th>
            <th class="px-5 py-3.5 text-left text-[10px] font-medium tracking-[0.1em] uppercase text-[#8a8790]">신청일시</th>
            <th class="px-5 py-3.5 text-left text-[10px] font-medium tracking-[0.1em] uppercase text-[#8a8790]">상태</th>
            <th class="px-5 py-3.5 text-left text-[10px] font-medium tracking-[0.1em] uppercase text-[#8a8790]">관리</th>
          </tr>
        </thead>
        <tbody>
          <% if (list.isEmpty()) { %>
          <tr>
            <td colspan="6" class="text-center py-16 text-[#4a4850]">대기 중인 신청 건이 없습니다.</td>
          </tr>
          <% } else {
               for (ChargeDTO req : list) { %>
          <tr class="border-b border-[rgba(255,255,255,0.05)] hover:bg-[rgba(255,255,255,0.02)] transition-colors">
            <td class="px-5 py-4 font-mono text-xs text-[#8a8790]">#<%= req.getRequestId() %></td>
            <td class="px-5 py-4 text-sm font-medium text-[#f0ede8]"><%= req.getUserid() %></td>
            <td class="px-5 py-4 text-sm font-semibold text-[#c8a96e]"><%= String.format("%,d", req.getAmount()) %>원</td>
            <td class="px-5 py-4 text-xs text-[#8a8790]"><%= req.getRequestDate() %></td>
            <td class="px-5 py-4">
              <span class="px-2.5 py-1 rounded text-[10px] font-bold tracking-wider uppercase bg-[rgba(200,169,110,0.12)] text-[#c8a96e] border border-[rgba(200,169,110,0.25)]">대기중</span>
            </td>
            <td class="px-5 py-4">
              <a href="approveCharge?requestId=<%= req.getRequestId() %>&userid=<%= req.getUserid() %>&amount=<%= req.getAmount() %>"
                 onclick="return confirm('<%= req.getUserid() %>님의 <%= String.format("%,d", req.getAmount()) %>원 충전을 승인하시겠습니까?')"
                 class="px-3 py-1.5 rounded-lg text-xs bg-[rgba(133,192,64,0.1)] text-[#85c040] border border-[rgba(133,192,64,0.25)] hover:bg-[rgba(133,192,64,0.2)] transition-all">
                승인하기
              </a>
            </td>
          </tr>
          <% } } %>
        </tbody>
      </table>
    </div>
  </div>

  <div class="mt-6">
    <a href="list"
       class="inline-flex items-center gap-2 px-5 py-2.5 rounded-lg border border-[rgba(255,255,255,0.07)] text-sm text-[#8a8790] hover:text-[#f0ede8] hover:border-[rgba(255,255,255,0.15)] transition-all">
      메인으로 돌아가기
    </a>
  </div>
</main>

<%@ include file="footer.jsp"%>
