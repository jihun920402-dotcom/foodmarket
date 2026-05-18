<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="model.MemberDTO"%>
<%@ include file="header.jsp"%>

<main class="max-w-7xl mx-auto px-4 sm:px-6 py-10">
  <div class="max-w-md mx-auto">

    <div class="bg-gradient-to-br from-[#18161a] to-[#201d25] border border-[rgba(200,169,110,0.2)] rounded-2xl p-8 text-center mb-8">
      <h2 class="text-2xl font-bold text-[#f0ede8]">마일리지 충전 신청</h2>
      <p class="text-sm text-[#8a8790] mt-1">원하시는 충전 금액을 입력해 주세요</p>
    </div>

    <div class="bg-[#18181c] border border-[rgba(255,255,255,0.07)] rounded-2xl p-8">
      <form action="requestCharge" method="post" id="chargeForm">

        <div class="mb-6">
          <p class="text-xs font-medium tracking-[0.08em] uppercase text-[#8a8790] mb-3">빠른 금액 선택</p>
          <div class="grid grid-cols-3 gap-2">
            <button type="button" onclick="addAmount(10000)"
                    class="py-3 rounded-xl border border-[rgba(255,255,255,0.07)] text-sm text-[#8a8790] hover:text-[#c8a96e] hover:border-[rgba(200,169,110,0.35)] hover:bg-[rgba(200,169,110,0.05)] transition-all"
                    style="background:none; cursor:pointer;">+ 1만</button>
            <button type="button" onclick="addAmount(30000)"
                    class="py-3 rounded-xl border border-[rgba(255,255,255,0.07)] text-sm text-[#8a8790] hover:text-[#c8a96e] hover:border-[rgba(200,169,110,0.35)] hover:bg-[rgba(200,169,110,0.05)] transition-all"
                    style="background:none; cursor:pointer;">+ 3만</button>
            <button type="button" onclick="addAmount(50000)"
                    class="py-3 rounded-xl border border-[rgba(255,255,255,0.07)] text-sm text-[#8a8790] hover:text-[#c8a96e] hover:border-[rgba(200,169,110,0.35)] hover:bg-[rgba(200,169,110,0.05)] transition-all"
                    style="background:none; cursor:pointer;">+ 5만</button>
            <button type="button" onclick="addAmount(100000)"
                    class="py-3 rounded-xl border border-[rgba(255,255,255,0.07)] text-sm text-[#8a8790] hover:text-[#c8a96e] hover:border-[rgba(200,169,110,0.35)] hover:bg-[rgba(200,169,110,0.05)] transition-all"
                    style="background:none; cursor:pointer;">+ 10만</button>
            <button type="button" onclick="addAmount(500000)"
                    class="py-3 rounded-xl border border-[rgba(255,255,255,0.07)] text-sm text-[#8a8790] hover:text-[#c8a96e] hover:border-[rgba(200,169,110,0.35)] hover:bg-[rgba(200,169,110,0.05)] transition-all"
                    style="background:none; cursor:pointer;">+ 50만</button>
            <button type="button" onclick="resetAmount()"
                    class="py-3 rounded-xl border border-[rgba(226,75,74,0.25)] text-sm text-[#e24b4a] hover:bg-[rgba(226,75,74,0.08)] transition-all"
                    style="background:none; cursor:pointer;">초기화</button>
          </div>
        </div>

        <div class="mb-8">
          <label class="block text-xs font-medium tracking-[0.08em] uppercase text-[#8a8790] mb-2">충전 신청 금액</label>
          <div class="relative">
            <input type="number" name="amount" id="amount"
                   placeholder="0" required min="1000" step="1000"
                   style="width:100%; text-align:right; font-size:28px; font-weight:800; color:#c8a96e; padding-right:48px; height:64px; border-color:rgba(200,169,110,0.3);">
            <span class="absolute right-4 top-1/2 -translate-y-1/2 text-lg font-bold text-[#8a8790]" style="pointer-events:none;">원</span>
          </div>
        </div>

        <div class="flex gap-3">
          <a href="chargeList.jsp"
             class="flex-none flex items-center justify-center px-6 py-3.5 rounded-xl border border-[rgba(255,255,255,0.07)] text-sm text-[#8a8790] hover:text-[#f0ede8] hover:border-[rgba(255,255,255,0.15)] transition-all">
            목록으로
          </a>
          <button type="submit"
                  class="flex-1 py-3.5 rounded-xl bg-[#c8a96e] text-[#0a0a0b] text-sm font-bold hover:bg-[#d4b87e] transition-colors"
                  style="border:none; cursor:pointer;">
            충전 신청하기
          </button>
        </div>
      </form>
    </div>

  </div>
</main>

<script>
const amountInput = document.getElementById('amount');

function addAmount(val) {
  amountInput.value = (parseInt(amountInput.value) || 0) + val;
}

function resetAmount() {
  amountInput.value = '';
  amountInput.focus();
}

document.getElementById('chargeForm').onsubmit = function() {
  const val = parseInt(amountInput.value);
  if (val < 1000) {
    alert("최소 1,000원부터 충전이 가능합니다.");
    return false;
  }
  return confirm(val.toLocaleString() + "원을 충전 신청하시겠습니까?");
};
</script>

<%@ include file="footer.jsp"%>
