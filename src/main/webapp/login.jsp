<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="header.jsp"%>

<main class="max-w-7xl mx-auto px-4 sm:px-6 py-16 flex items-center justify-center min-h-[70vh]">
  <div class="w-full max-w-sm">
    <!-- 로고 헤더 -->
    <div class="text-center mb-8">
      <h2 class="text-2xl font-bold text-[#f0ede8] tracking-tight">로그인</h2>
      <p class="text-sm text-[#8a8790] mt-1">계정에 로그인하여 쇼핑을 시작하세요</p>
    </div>

    <div class="bg-[#18181c] border border-[rgba(255,255,255,0.07)] rounded-2xl p-8">
      <form action="login" method="post" class="space-y-5">

        <div>
          <label class="block text-xs font-medium tracking-[0.08em] uppercase text-[#8a8790] mb-2">아이디</label>
          <input type="text" name="userid" id="userid"
                 class="w-full" placeholder="아이디를 입력하세요" required style="width:100%;">
        </div>

        <div>
          <label class="block text-xs font-medium tracking-[0.08em] uppercase text-[#8a8790] mb-2">비밀번호</label>
          <input type="password" name="password" id="password"
                 class="w-full" placeholder="비밀번호를 입력하세요" required style="width:100%;">
        </div>

        <div class="pt-2 space-y-3">
          <button type="submit"
                  class="w-full py-3 rounded-xl bg-[#c8a96e] text-[#0a0a0b] text-sm font-bold hover:bg-[#d4b87e] transition-colors"
                  style="width:100%; border:none;">
            로그인하기
          </button>
          <a href="join.jsp"
             class="flex items-center justify-center w-full py-3 rounded-xl border border-[rgba(255,255,255,0.07)] text-[#8a8790] text-sm hover:text-[#f0ede8] hover:border-[rgba(255,255,255,0.15)] transition-all">
            회원가입
          </a>
        </div>
      </form>
    </div>
  </div>
</main>

<%@ include file="footer.jsp"%>
