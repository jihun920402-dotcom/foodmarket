<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="model.MarketInfoDAO, model.MarketInfoDTO"%>
<%@ page import="model.MemberDTO"%>
<%@ include file="header.jsp"%>

<%
if (loginUser == null) {
    response.sendRedirect("login.jsp");
    return;
}

boolean isAdmin = "admin".equals(userRole);
MarketInfoDAO infoDao = new MarketInfoDAO();
MarketInfoDTO mInfo = infoDao.getInfo();

String bank = (mInfo != null) ? mInfo.getBankName() : "우리은행";
String account = (mInfo != null) ? mInfo.getAccountNumber() : "1002-123-456789";
String holder = (mInfo != null) ? mInfo.getAccountHolder() : "종합마켓";
%>

<main class="max-w-7xl mx-auto px-4 sm:px-6 py-10">
  <div class="max-w-2xl mx-auto">

    <!-- 알림 메시지 -->
    <% if ("1".equals(request.getParameter("success"))) { %>
    <div class="mb-6 px-5 py-4 rounded-xl bg-[rgba(133,192,64,0.1)] border border-[rgba(133,192,64,0.25)] text-sm text-[#85c040]">
      신청 완료! 입금 확인 신청이 접수되었습니다. 관리자 승인 후 충전됩니다.
    </div>
    <% } %>
    <% if ("1".equals(request.getParameter("updateSuccess"))) { %>
    <div class="mb-6 px-5 py-4 rounded-xl bg-[rgba(200,169,110,0.1)] border border-[rgba(200,169,110,0.25)] text-sm text-[#c8a96e]">
      회원 정보가 성공적으로 수정되었습니다.
    </div>
    <% } %>

    <!-- 프로필 카드 -->
    <div class="bg-[#18181c] border border-[rgba(255,255,255,0.07)] rounded-2xl overflow-hidden mb-6">
      <div class="flex items-center justify-between px-6 py-4 border-b border-[rgba(255,255,255,0.07)]">
        <h2 class="text-base font-bold text-[#f0ede8]">내 정보 관리</h2>
        <a href="list" class="text-xs text-[#8a8790] hover:text-[#f0ede8] transition-colors">쇼핑 계속하기</a>
      </div>

      <div class="p-6">
        <div class="flex flex-col md:flex-row gap-8 items-start">
          <!-- 아바타 + 역할 -->
          <div class="flex flex-col items-center gap-3 md:w-40 shrink-0">
            <div class="w-20 h-20 rounded-full bg-[#1a1a20] border border-[rgba(255,255,255,0.07)] flex items-center justify-center">
              <span class="text-3xl">👤</span>
            </div>
            <div class="text-center">
              <p class="text-base font-bold text-[#f0ede8]"><%= loginUser.getName() %>님</p>
              <span class="inline-block mt-1 px-3 py-1 rounded-full text-[10px] font-bold tracking-wider uppercase bg-[rgba(200,169,110,0.12)] text-[#c8a96e] border border-[rgba(200,169,110,0.25)]">
                <%= loginUser.getRole().toUpperCase() %>
              </span>
            </div>
          </div>

          <!-- 마일리지 + 버튼 -->
          <div class="flex-1">
            <div class="bg-gradient-to-br from-[#18161a] to-[#201d25] border border-[rgba(200,169,110,0.25)] rounded-xl p-5 mb-4">
              <p class="text-[10px] font-medium tracking-[0.12em] uppercase text-[#4a4850] mb-2">보유 마일리지</p>
              <p class="text-3xl font-bold text-[#c8a96e] tracking-tight">
                <%= String.format("%,d", loginUser.getMileage()) %>
                <span class="text-sm font-normal text-[#8a8790] ml-1">M</span>
              </p>
            </div>

            <% if (!isAdmin) { %>
            <div class="grid grid-cols-2 gap-3">
              <button onclick="openModal('chargeModal')"
                      class="py-3 rounded-xl bg-[#c8a96e] text-[#0a0a0b] text-sm font-bold hover:bg-[#d4b87e] transition-colors"
                      style="border:none; cursor:pointer;">
                마일리지 충전
              </button>
              <a href="chargeList.jsp"
                 class="flex items-center justify-center py-3 rounded-xl border border-[rgba(200,169,110,0.35)] text-[#c8a96e] text-sm hover:bg-[rgba(200,169,110,0.1)] transition-all">
                충전 내역
              </a>
            </div>
            <% } %>
          </div>
        </div>

        <div class="border-t border-[rgba(255,255,255,0.07)] mt-6 pt-6">
          <p class="text-[10px] font-medium tracking-[0.12em] uppercase text-[#4a4850] mb-4">배송 및 계좌 정보</p>
          <div class="space-y-3">
            <div class="flex items-start justify-between py-2 border-b border-[rgba(255,255,255,0.05)]">
              <span class="text-xs text-[#8a8790] w-28 shrink-0">전화번호</span>
              <span class="text-sm text-[#f0ede8] text-right"><%= (loginUser.getPhone() != null) ? loginUser.getPhone() : "미등록" %></span>
            </div>
            <div class="flex items-start justify-between py-2 border-b border-[rgba(255,255,255,0.05)]">
              <span class="text-xs text-[#8a8790] w-28 shrink-0">배송지 주소</span>
              <span class="text-sm text-[#f0ede8] text-right"><%= (loginUser.getAddress() != null) ? loginUser.getAddress() : "미등록" %></span>
            </div>
            <div class="flex items-start justify-between py-2">
              <span class="text-xs text-[#8a8790] w-28 shrink-0">환불 계좌</span>
              <span class="text-sm text-[#f0ede8] text-right"><%= (loginUser.getAccountNumber() != null) ? loginUser.getAccountNumber() : "미등록" %></span>
            </div>
          </div>
        </div>

        <div class="flex flex-col sm:flex-row gap-3 mt-6">
          <% if (!isAdmin) { %>
          <a href="orderList"
             class="flex-1 flex items-center justify-center py-3 rounded-xl border border-[rgba(200,169,110,0.25)] text-[#c8a96e] text-sm hover:bg-[rgba(200,169,110,0.1)] transition-all">
            주문 기록 보기
          </a>
          <% } %>
          <button onclick="openModal('editProfileModal')"
                  class="flex-1 py-3 rounded-xl border border-[rgba(255,255,255,0.1)] text-[#f0ede8] text-sm hover:bg-[rgba(255,255,255,0.05)] transition-all"
                  style="background:transparent; cursor:pointer;">
            정보 수정하기
          </button>
        </div>
      </div>
    </div>

  </div>
</main>

<!-- 마일리지 충전 모달 -->
<div id="chargeModal" class="hidden fixed inset-0 z-50 flex items-center justify-center px-4">
  <div class="absolute inset-0 bg-black/70" onclick="closeModal('chargeModal')"></div>
  <div class="relative w-full max-w-md bg-[#18181c] border border-[rgba(255,255,255,0.07)] rounded-2xl overflow-hidden z-10">
    <div class="flex items-center justify-between px-6 py-4 border-b border-[rgba(255,255,255,0.07)]">
      <h3 class="text-base font-bold text-[#f0ede8]">마일리지 충전 신청</h3>
      <button onclick="closeModal('chargeModal')" class="text-[#4a4850] hover:text-[#f0ede8] transition-colors" style="background:none; border:none; cursor:pointer; font-size:20px;">✕</button>
    </div>
    <div class="p-6">
      <div class="bg-[rgba(200,169,110,0.08)] border border-[rgba(200,169,110,0.2)] rounded-xl p-4 mb-5 text-sm text-[#8a8790]">
        <strong class="text-[#c8a96e]">[필독] 입금 안내</strong><br>
        아래의 마켓 전용 계좌로 입금해 주셔야 확인 후 충전됩니다.
      </div>
      <div class="bg-[#141418] border border-[rgba(255,255,255,0.07)] rounded-xl p-6 text-center mb-5">
        <p class="text-xs text-[#4a4850] mb-2">입금하실 계좌 (예금주: <%= holder %>)</p>
        <p class="text-lg font-bold text-[#f0ede8]"><%= bank %></p>
        <p class="text-2xl font-bold text-[#c8a96e] mt-1"><%= account %></p>
        <p class="text-sm text-[#8a8790] mt-2">입금자명: <strong class="text-[#f0ede8]"><%= loginUser.getName() %></strong></p>
      </div>
      <div>
        <label class="block text-xs font-medium tracking-[0.08em] uppercase text-[#8a8790] mb-2">충전 희망 금액 선택</label>
        <select id="chargeAmount" style="width:100%;">
          <option value="10000">10,000원</option>
          <option value="50000">50,000원</option>
          <option value="100000">100,000원</option>
          <option value="300000">300,000원</option>
          <option value="500000">500,000원</option>
        </select>
      </div>
    </div>
    <div class="flex items-center justify-end gap-3 px-6 py-4 border-t border-[rgba(255,255,255,0.07)]">
      <button onclick="closeModal('chargeModal')"
              class="px-4 py-2.5 text-sm text-[#8a8790] hover:text-[#f0ede8] transition-colors"
              style="background:none; border:none; cursor:pointer;">취소</button>
      <button onclick="requestCharge()"
              class="px-6 py-2.5 rounded-lg bg-[#c8a96e] text-[#0a0a0b] text-sm font-bold hover:bg-[#d4b87e] transition-colors"
              style="border:none; cursor:pointer;">
        입금 완료 및 신청
      </button>
    </div>
  </div>
</div>

<!-- 정보 수정 모달 -->
<div id="editProfileModal" class="hidden fixed inset-0 z-50 flex items-center justify-center px-4">
  <div class="absolute inset-0 bg-black/70" onclick="closeModal('editProfileModal')"></div>
  <div class="relative w-full max-w-md bg-[#18181c] border border-[rgba(255,255,255,0.07)] rounded-2xl overflow-hidden z-10">
    <div class="flex items-center justify-between px-6 py-4 border-b border-[rgba(255,255,255,0.07)]">
      <h3 class="text-base font-bold text-[#f0ede8]">내 정보 수정</h3>
      <button onclick="closeModal('editProfileModal')" class="text-[#4a4850] hover:text-[#f0ede8] transition-colors" style="background:none; border:none; cursor:pointer; font-size:20px;">✕</button>
    </div>
    <form action="updateMember" method="post">
      <div class="p-6 space-y-4">
        <div>
          <label class="block text-xs font-medium tracking-[0.08em] uppercase text-[#8a8790] mb-2">아이디 (변경불가)</label>
          <input type="text" value="<%= loginUser.getUserid() %>" readonly style="width:100%; opacity:0.5; cursor:not-allowed;">
        </div>
        <div>
          <label class="block text-xs font-medium tracking-[0.08em] uppercase text-[#8a8790] mb-2">새 비밀번호</label>
          <input type="password" name="password" placeholder="새 비밀번호를 입력하세요" required style="width:100%;">
        </div>
        <div>
          <label class="block text-xs font-medium tracking-[0.08em] uppercase text-[#8a8790] mb-2">이름</label>
          <input type="text" name="name" value="<%= loginUser.getName() %>" required style="width:100%;">
        </div>
        <div>
          <label class="block text-xs font-medium tracking-[0.08em] uppercase text-[#8a8790] mb-2">전화번호</label>
          <input type="text" name="phone" value="<%= (loginUser.getPhone() != null) ? loginUser.getPhone() : "" %>" style="width:100%;">
        </div>
        <div>
          <label class="block text-xs font-medium tracking-[0.08em] uppercase text-[#8a8790] mb-2">배송지 주소</label>
          <input type="text" name="address" value="<%= (loginUser.getAddress() != null) ? loginUser.getAddress() : "" %>" style="width:100%;">
        </div>
        <div>
          <label class="block text-xs font-medium tracking-[0.08em] uppercase text-[#8a8790] mb-2">환불 계좌번호</label>
          <input type="text" name="accountNumber" value="<%= (loginUser.getAccountNumber() != null) ? loginUser.getAccountNumber() : "" %>" style="width:100%;">
        </div>
      </div>
      <div class="flex items-center justify-end gap-3 px-6 py-4 border-t border-[rgba(255,255,255,0.07)]">
        <button type="button" onclick="closeModal('editProfileModal')"
                class="px-4 py-2.5 text-sm text-[#8a8790] hover:text-[#f0ede8] transition-colors"
                style="background:none; border:none; cursor:pointer;">닫기</button>
        <button type="submit"
                class="px-6 py-2.5 rounded-lg bg-[#c8a96e] text-[#0a0a0b] text-sm font-bold hover:bg-[#d4b87e] transition-colors"
                style="border:none; cursor:pointer;">
          수정 완료
        </button>
      </div>
    </form>
  </div>
</div>

<script>
function requestCharge() {
  const amount = document.getElementById('chargeAmount').value;
  const formatted = parseInt(amount).toLocaleString();
  if (confirm(formatted + "원을 입금하셨습니까?\n확인을 누르면 신청이 완료됩니다.")) {
    location.href = "requestCharge?amount=" + amount;
  }
}
</script>

<%@ include file="footer.jsp"%>
