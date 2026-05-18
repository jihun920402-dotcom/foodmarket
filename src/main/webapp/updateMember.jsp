<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="header.jsp"%>

<%
if (loginUser == null) {
    response.sendRedirect("login.jsp");
    return;
}
%>

<main class="max-w-7xl mx-auto px-4 sm:px-6 py-10">
  <div class="max-w-lg mx-auto">
    <div class="mb-8">
      <h1 class="text-2xl font-bold text-[#f0ede8] tracking-tight">내 정보 수정</h1>
      <p class="text-sm text-[#8a8790] mt-1">개인 정보를 업데이트합니다</p>
    </div>

    <div class="bg-[#18181c] border border-[rgba(255,255,255,0.07)] rounded-2xl p-8">
      <form action="updateMember" method="post" class="space-y-5">

        <div>
          <label class="block text-xs font-medium tracking-[0.08em] uppercase text-[#8a8790] mb-2">아이디 (변경불가)</label>
          <input type="text" name="userid" value="<%= loginUser.getUserid() %>" readonly
                 style="width:100%; opacity:0.5; cursor:not-allowed;">
          <p class="text-xs text-[#4a4850] mt-1">아이디는 변경할 수 없습니다.</p>
        </div>

        <div>
          <label class="block text-xs font-medium tracking-[0.08em] uppercase text-[#8a8790] mb-2">새 비밀번호</label>
          <input type="password" name="password"
                 placeholder="새 비밀번호를 입력하세요" required style="width:100%;">
        </div>

        <div>
          <label class="block text-xs font-medium tracking-[0.08em] uppercase text-[#8a8790] mb-2">이름</label>
          <input type="text" name="name" value="<%= loginUser.getName() %>"
                 required style="width:100%;">
        </div>

        <div>
          <label class="block text-xs font-medium tracking-[0.08em] uppercase text-[#8a8790] mb-2">전화번호</label>
          <input type="text" name="phone"
                 value="<%= (loginUser.getPhone() != null) ? loginUser.getPhone() : "" %>"
                 placeholder="010-0000-0000" style="width:100%;">
        </div>

        <div>
          <label class="block text-xs font-medium tracking-[0.08em] uppercase text-[#8a8790] mb-2">배송지 주소</label>
          <input type="text" name="address"
                 value="<%= (loginUser.getAddress() != null) ? loginUser.getAddress() : "" %>"
                 placeholder="배송 상세 주소" style="width:100%;">
        </div>

        <div>
          <label class="block text-xs font-medium tracking-[0.08em] uppercase text-[#8a8790] mb-2">충전/환불 계좌번호</label>
          <input type="text" name="accountNumber"
                 value="<%= (loginUser.getAccountNumber() != null) ? loginUser.getAccountNumber() : "" %>"
                 required style="width:100%;">
        </div>

        <div class="flex flex-col gap-3 pt-2">
          <button type="submit"
                  class="w-full py-3 rounded-xl bg-[#c8a96e] text-[#0a0a0b] text-sm font-bold hover:bg-[#d4b87e] transition-colors"
                  style="width:100%; border:none; cursor:pointer;">
            수정 완료
          </button>
          <a href="mypage.jsp"
             class="flex items-center justify-center w-full py-3 rounded-xl border border-[rgba(255,255,255,0.07)] text-[#8a8790] text-sm hover:text-[#f0ede8] hover:border-[rgba(255,255,255,0.15)] transition-all">
            취소하고 돌아가기
          </a>
        </div>
      </form>
    </div>
  </div>
</main>

<%@ include file="footer.jsp"%>
