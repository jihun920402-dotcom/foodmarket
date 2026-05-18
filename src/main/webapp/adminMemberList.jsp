<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="model.MemberDAO, model.MemberDTO, java.util.List"%>
<%@ include file="header.jsp"%>
<%
if (!"admin".equals(userRole)) {
    out.println("<script>alert('권한이 없습니다.'); location.href='list';</script>");
    return;
}

MemberDAO dao = new MemberDAO();
List<MemberDTO> memberList = dao.getAllMembers();
%>

<main class="max-w-7xl mx-auto px-4 sm:px-6 py-10">
  <div class="mb-8 flex items-center justify-between">
    <div>
      <h1 class="text-2xl font-bold text-[#f0ede8] tracking-tight">회원 정보 관리</h1>
      <p class="text-sm text-[#8a8790] mt-1">총 <span class="text-[#c8a96e] font-semibold"><%= memberList.size() %></span>명</p>
    </div>
  </div>

  <div class="bg-[#18181c] border border-[rgba(255,255,255,0.07)] rounded-2xl overflow-hidden">
    <div class="overflow-x-auto">
      <table class="w-full text-sm" style="min-width: 760px;">
        <thead>
          <tr class="border-b border-[rgba(255,255,255,0.07)]">
            <th class="px-5 py-3.5 text-left text-[10px] font-medium tracking-[0.1em] uppercase text-[#8a8790]">아이디</th>
            <th class="px-5 py-3.5 text-left text-[10px] font-medium tracking-[0.1em] uppercase text-[#8a8790]">이름</th>
            <th class="px-5 py-3.5 text-left text-[10px] font-medium tracking-[0.1em] uppercase text-[#8a8790]">전화번호</th>
            <th class="px-5 py-3.5 text-left text-[10px] font-medium tracking-[0.1em] uppercase text-[#8a8790]">주소</th>
            <th class="px-5 py-3.5 text-left text-[10px] font-medium tracking-[0.1em] uppercase text-[#8a8790]">마일리지</th>
            <th class="px-5 py-3.5 text-left text-[10px] font-medium tracking-[0.1em] uppercase text-[#8a8790]">권한</th>
            <th class="px-5 py-3.5 text-left text-[10px] font-medium tracking-[0.1em] uppercase text-[#8a8790]">관리</th>
          </tr>
        </thead>
        <tbody>
          <% for (MemberDTO m : memberList) { %>
          <tr class="border-b border-[rgba(255,255,255,0.05)] hover:bg-[rgba(255,255,255,0.02)] transition-colors">
            <td class="px-5 py-4 font-medium text-[#f0ede8] font-mono text-xs"><%= m.getUserid() %></td>
            <td class="px-5 py-4 text-[#f0ede8]"><%= m.getName() %></td>
            <td class="px-5 py-4 text-[#8a8790]"><%= (m.getPhone() != null && !m.getPhone().isEmpty()) ? m.getPhone() : "—" %></td>
            <td class="px-5 py-4 text-[#8a8790] text-xs max-w-[180px] truncate"><%= (m.getAddress() != null && !m.getAddress().isEmpty()) ? m.getAddress() : "미등록" %></td>
            <td class="px-5 py-4 text-[#c8a96e] font-semibold"><%= String.format("%,d", m.getMileage()) %>원</td>
            <td class="px-5 py-4">
              <% if ("admin".equals(m.getRole())) { %>
              <span class="px-2.5 py-1 rounded text-[10px] font-bold tracking-wider uppercase bg-[rgba(226,75,74,0.12)] text-[#e24b4a] border border-[rgba(226,75,74,0.25)]">ADMIN</span>
              <% } else { %>
              <span class="px-2.5 py-1 rounded text-[10px] font-bold tracking-wider uppercase bg-[rgba(255,255,255,0.05)] text-[#8a8790] border border-[rgba(255,255,255,0.07)]">USER</span>
              <% } %>
            </td>
            <td class="px-5 py-4">
              <button onclick="openModal('editModal_<%= m.getUserid() %>')"
                      class="px-3 py-1.5 rounded-lg text-xs border border-[rgba(200,169,110,0.35)] text-[#c8a96e] hover:bg-[rgba(200,169,110,0.1)] transition-all"
                      style="background:none; cursor:pointer;">수정</button>
            </td>
          </tr>
          <% } %>
        </tbody>
      </table>
    </div>
  </div>
</main>

<!-- 수정 모달 (각 회원별) -->
<% for (MemberDTO m : memberList) { %>
<div id="editModal_<%= m.getUserid() %>" class="hidden fixed inset-0 z-50 flex items-center justify-center px-4">
  <div class="absolute inset-0 bg-black/70" onclick="closeModal('editModal_<%= m.getUserid() %>')"></div>
  <div class="relative w-full max-w-md bg-[#18181c] border border-[rgba(255,255,255,0.07)] rounded-2xl overflow-hidden z-10">
    <div class="flex items-center justify-between px-6 py-4 border-b border-[rgba(255,255,255,0.07)]">
      <h3 class="text-base font-bold text-[#f0ede8]">회원 정보 수정 (<%= m.getUserid() %>)</h3>
      <button onclick="closeModal('editModal_<%= m.getUserid() %>')" class="text-[#4a4850] hover:text-[#f0ede8] transition-colors" style="background:none; border:none; cursor:pointer; font-size:20px;">✕</button>
    </div>
    <form action="adminUpdateMember" method="post">
      <input type="hidden" name="userid" value="<%= m.getUserid() %>">
      <div class="p-6 space-y-4">
        <div>
          <label class="block text-xs font-medium tracking-[0.08em] uppercase text-[#8a8790] mb-2">이름</label>
          <input type="text" name="name" value="<%= m.getName() %>" required style="width:100%;">
        </div>
        <div>
          <label class="block text-xs font-medium tracking-[0.08em] uppercase text-[#8a8790] mb-2">전화번호</label>
          <input type="text" name="phone" value="<%= (m.getPhone() != null) ? m.getPhone() : "" %>" style="width:100%;">
        </div>
        <div>
          <label class="block text-xs font-medium tracking-[0.08em] uppercase text-[#8a8790] mb-2">주소</label>
          <input type="text" name="address" value="<%= (m.getAddress() != null) ? m.getAddress() : "" %>" style="width:100%;">
        </div>
        <div>
          <label class="block text-xs font-medium tracking-[0.08em] uppercase text-[#8a8790] mb-2">마일리지 (원)</label>
          <input type="number" name="mileage" value="<%= m.getMileage() %>" style="width:100%;">
        </div>
        <div>
          <label class="block text-xs font-medium tracking-[0.08em] uppercase text-[#8a8790] mb-2 text-[#e24b4a]">권한 설정</label>
          <select name="role" style="width:100%;">
            <option value="user" <%= "user".equals(m.getRole()) ? "selected" : "" %>>일반 사용자 (USER)</option>
            <option value="admin" <%= "admin".equals(m.getRole()) ? "selected" : "" %>>관리자 (ADMIN)</option>
          </select>
        </div>
      </div>
      <div class="flex items-center justify-end gap-3 px-6 py-4 border-t border-[rgba(255,255,255,0.07)]">
        <button type="button" onclick="closeModal('editModal_<%= m.getUserid() %>')"
                class="px-4 py-2.5 text-sm text-[#8a8790] hover:text-[#f0ede8] transition-colors"
                style="background:none; border:none; cursor:pointer;">취소</button>
        <button type="submit"
                class="px-6 py-2.5 rounded-lg bg-[#c8a96e] text-[#0a0a0b] text-sm font-bold hover:bg-[#d4b87e] transition-colors"
                style="border:none; cursor:pointer;">
          변경사항 저장
        </button>
      </div>
    </form>
  </div>
</div>
<% } %>

<%@ include file="footer.jsp"%>
