<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="header.jsp"%>

<main class="max-w-7xl mx-auto px-4 sm:px-6 py-12">
  <div class="max-w-lg mx-auto">
    <div class="text-center mb-8">
      <h2 class="text-2xl font-bold text-[#f0ede8] tracking-tight">회원가입</h2>
      <p class="text-sm text-[#8a8790] mt-1">상세 정보를 입력하여 가입을 완료하세요</p>
    </div>

    <div class="bg-[#18181c] border border-[rgba(255,255,255,0.07)] rounded-2xl p-5 sm:p-8">
      <form action="join" method="post" onsubmit="return validateForm()">

        <!-- 계정 정보 -->
        <div class="mb-6">
          <p class="text-[10px] font-medium tracking-[0.15em] uppercase text-[#c8a96e] mb-4">계정 정보</p>

          <div class="space-y-4">
            <div>
              <label class="block text-xs font-medium tracking-[0.08em] uppercase text-[#8a8790] mb-2">아이디</label>
              <div class="flex gap-2">
                <input type="text" name="userid" id="userid"
                       placeholder="아이디를 입력하세요" required style="flex:1; width:auto;">
                <button type="button" onclick="checkDuplicate()"
                        class="shrink-0 px-4 py-2.5 rounded-lg border border-[rgba(200,169,110,0.35)] text-[#c8a96e] text-sm hover:bg-[rgba(200,169,110,0.1)] transition-all"
                        style="width:auto; border:1px solid rgba(200,169,110,0.35); background:transparent;">중복 확인</button>
              </div>
              <div id="id_msg" class="text-xs mt-1.5"></div>
              <input type="hidden" id="id_checked" value="false">
            </div>

            <div>
              <label class="block text-xs font-medium tracking-[0.08em] uppercase text-[#8a8790] mb-2">비밀번호</label>
              <input type="password" name="password" id="password"
                     placeholder="비밀번호를 입력하세요" required style="width:100%;">
            </div>

            <div>
              <label class="block text-xs font-medium tracking-[0.08em] uppercase text-[#8a8790] mb-2">비밀번호 확인</label>
              <input type="password" id="password_check"
                     placeholder="비밀번호를 한 번 더 입력하세요" required style="width:100%;">
              <div id="pw_msg" class="text-xs mt-1.5"></div>
            </div>
          </div>
        </div>

        <div class="border-t border-[rgba(255,255,255,0.07)] my-6"></div>

        <!-- 배송 및 충전 정보 -->
        <div class="mb-6">
          <p class="text-[10px] font-medium tracking-[0.15em] uppercase text-[#c8a96e] mb-4">배송 및 충전 정보</p>

          <div class="space-y-4">
            <div class="grid grid-cols-2 gap-3">
              <div>
                <label class="block text-xs font-medium tracking-[0.08em] uppercase text-[#8a8790] mb-2">이름</label>
                <input type="text" name="name" placeholder="성함" required style="width:100%;">
              </div>
              <div>
                <label class="block text-xs font-medium tracking-[0.08em] uppercase text-[#8a8790] mb-2">나이</label>
                <input type="number" name="age" placeholder="나이" required style="width:100%;">
              </div>
            </div>

            <div>
              <label class="block text-xs font-medium tracking-[0.08em] uppercase text-[#8a8790] mb-2">전화번호</label>
              <input type="text" name="phone" placeholder="010-0000-0000" required style="width:100%;">
            </div>

            <div>
              <label class="block text-xs font-medium tracking-[0.08em] uppercase text-[#8a8790] mb-2">배송지 주소</label>
              <input type="text" name="address" placeholder="배송 받으실 상세 주소를 입력하세요" required style="width:100%;">
            </div>

            <div>
              <label class="block text-xs font-medium tracking-[0.08em] uppercase text-[#8a8790] mb-2">마일리지 충전 계좌번호</label>
              <input type="text" name="accountNumber" placeholder="환불 및 충전용 계좌번호" required style="width:100%;">
            </div>
          </div>
        </div>

        <div class="space-y-3">
          <button type="submit"
                  class="w-full py-3 rounded-xl bg-[#c8a96e] text-[#0a0a0b] text-sm font-bold hover:bg-[#d4b87e] transition-colors"
                  style="width:100%; border:none;">
            가입 완료
          </button>
          <button type="button" onclick="history.back()"
                  class="w-full py-3 rounded-xl border border-[rgba(255,255,255,0.07)] text-[#8a8790] text-sm hover:text-[#f0ede8] hover:border-[rgba(255,255,255,0.15)] transition-all"
                  style="width:100%; background:transparent;">
            취소
          </button>
        </div>
      </form>
    </div>
  </div>
</main>

<script>
function checkDuplicate() {
  const userid = document.getElementById("userid").value;
  const idMsg = document.getElementById("id_msg");
  const idChecked = document.getElementById("id_checked");
  if (userid === "") { alert("아이디를 입력해주세요."); document.getElementById("userid").focus(); return; }
  fetch("checkId?userid=" + userid)
    .then(res => res.text())
    .then(data => {
      if (data === "success") {
        idMsg.innerHTML = "✅ 사용 가능한 아이디입니다.";
        idMsg.style.color = "#85c040";
        idChecked.value = "true";
      } else {
        idMsg.innerHTML = "❌ 이미 사용 중인 아이디입니다.";
        idMsg.style.color = "#e24b4a";
        idChecked.value = "false";
      }
    })
    .catch(() => alert("서버 연결에 실패했습니다."));
}

document.getElementById("userid").addEventListener("input", function() {
  document.getElementById("id_checked").value = "false";
  document.getElementById("id_msg").innerHTML = "";
});

const pw = document.getElementById("password");
const pwCheck = document.getElementById("password_check");
const msg = document.getElementById("pw_msg");

function checkPw() {
  if (pwCheck.value === "") { msg.innerHTML = ""; return; }
  if (pw.value === pwCheck.value) {
    msg.innerHTML = "✅ 비밀번호가 일치합니다.";
    msg.style.color = "#85c040";
  } else {
    msg.innerHTML = "❌ 비밀번호가 일치하지 않습니다.";
    msg.style.color = "#e24b4a";
  }
}
pw.addEventListener("keyup", checkPw);
pwCheck.addEventListener("keyup", checkPw);

function validateForm() {
  if (document.getElementById("id_checked").value !== "true") {
    alert("아이디 중복 확인을 먼저 해주세요!"); return false;
  }
  if (pw.value !== pwCheck.value) {
    alert("비밀번호가 일치하지 않습니다. 다시 확인해주세요!"); pwCheck.focus(); return false;
  }
  return true;
}
</script>

<%@ include file="footer.jsp"%>
