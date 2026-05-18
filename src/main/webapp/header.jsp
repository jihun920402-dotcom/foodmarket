<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="model.MemberDTO"%>
<%
    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
    String userRole = (loginUser != null) ? loginUser.getRole() : "";
%>
<!DOCTYPE html>
<html lang="ko" class="dark">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<title>푸드마켓</title>

<!-- Tailwind CDN -->
<script src="https://cdn.tailwindcss.com"></script>
<script>
  tailwind.config = {
    darkMode: 'class',
    theme: {
      extend: {
        colors: {
          gold: {
            DEFAULT: '#c8a96e',
            dim:     '#a8894e',
            glow:    'rgba(200,169,110,0.12)',
          },
          dark: {
            base:    '#0a0a0b',
            surface: '#111113',
            card:    '#18181c',
            hover:   '#1e1e24',
            input:   '#1a1a20',
          },
        },
        fontFamily: {
          sans: ['Pretendard', 'system-ui', 'sans-serif'],
        },
        borderColor: {
          subtle:  'rgba(255,255,255,0.07)',
          accent:  'rgba(200,169,110,0.30)',
        },
      },
    },
  }
</script>

<!-- Pretendard 폰트 -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css" />

<style>
  body {
    background-color: #0a0a0b;
    color: #f0ede8;
    font-family: 'Pretendard', system-ui, sans-serif;
    -webkit-font-smoothing: antialiased;
  }
  ::-webkit-scrollbar { width: 6px; }
  ::-webkit-scrollbar-track { background: #111113; }
  ::-webkit-scrollbar-thumb { background: #2a2830; border-radius: 3px; }
  ::-webkit-scrollbar-thumb:hover { background: #3a3848; }
  *:focus-visible { outline: 2px solid #c8a96e; outline-offset: 2px; }

  input, select, textarea {
    background-color: #1a1a20;
    border: 1px solid rgba(255,255,255,0.07);
    color: #f0ede8;
    border-radius: 8px;
    padding: 10px 14px;
    font-family: 'Pretendard', sans-serif;
    font-size: 14px;
    transition: border-color 0.2s;
    box-sizing: border-box;
  }
  input:focus, select:focus, textarea:focus {
    outline: none;
    border-color: #a8894e;
  }
  input::placeholder, textarea::placeholder { color: #4a4850; }
  input[type="checkbox"], input[type="radio"] {
    width: 16px !important;
    height: 16px !important;
    padding: 0 !important;
    background: none !important;
    border: 1px solid rgba(255,255,255,0.2) !important;
    border-radius: 3px !important;
    accent-color: #c8a96e;
    cursor: pointer;
    flex-shrink: 0;
  }
  input[type="file"] {
    padding: 8px 12px;
    cursor: pointer;
  }
  select option { background-color: #1a1a20; }

  .btn-gold { display: inline-flex; align-items: center; justify-content: center; padding: 10px 24px; border-radius: 8px; background: #c8a96e; color: #0a0a0b; font-size: 14px; font-weight: 600; transition: background 0.2s; border: none; cursor: pointer; }
  .btn-gold:hover { background: #d4b87e; }
  .btn-outline { display: inline-flex; align-items: center; justify-content: center; padding: 10px 24px; border-radius: 8px; border: 1px solid rgba(200,169,110,0.35); color: #c8a96e; font-size: 14px; background: transparent; transition: all 0.2s; cursor: pointer; text-decoration: none; }
  .btn-outline:hover { background: rgba(200,169,110,0.1); }
  .btn-ghost { display: inline-flex; align-items: center; justify-content: center; padding: 10px 24px; border-radius: 8px; border: 1px solid rgba(255,255,255,0.07); color: #8a8790; font-size: 14px; background: transparent; transition: all 0.2s; cursor: pointer; text-decoration: none; }
  .btn-ghost:hover { color: #f0ede8; border-color: rgba(255,255,255,0.15); }
  .btn-danger { display: inline-flex; align-items: center; justify-content: center; padding: 10px 24px; border-radius: 8px; border: 1px solid rgba(226,75,74,0.3); color: #e24b4a; font-size: 14px; background: rgba(226,75,74,0.08); transition: all 0.2s; cursor: pointer; text-decoration: none; }
  .btn-danger:hover { background: rgba(226,75,74,0.15); }
</style>
</head>
<body class="bg-[#0a0a0b] text-[#f0ede8] min-h-screen">

<header class="bg-[#111113] border-b border-[rgba(255,255,255,0.07)] sticky top-0 z-50">
  <div class="max-w-7xl mx-auto px-4 sm:px-6 h-16 flex items-center justify-between gap-4">

    <!-- 로고 -->
    <a href="list" class="text-[#c8a96e] font-bold text-xl tracking-tight shrink-0">
      푸드<span class="text-[#f0ede8] font-light">마켓</span>
    </a>

    <!-- 데스크탑 네비게이션 -->
    <nav class="hidden lg:flex items-center gap-8 flex-1 justify-center">
      <a href="list" class="text-sm text-[#8a8790] hover:text-[#f0ede8] transition-colors">전체상품</a>
      <% if ("admin".equals(userRole)) { %>
        <a href="adminMemberList.jsp" class="text-sm text-[#8a8790] hover:text-[#f0ede8] transition-colors">회원관리</a>
        <a href="adminOrderList" class="text-sm text-[#8a8790] hover:text-[#f0ede8] transition-colors">주문관리</a>
        <a href="adminConfig.jsp" class="text-sm text-[#8a8790] hover:text-[#f0ede8] transition-colors">시스템설정</a>
        <a href="adminCharge.jsp" class="text-sm text-[#8a8790] hover:text-[#f0ede8] transition-colors">충전승인</a>
      <% } %>
    </nav>

    <!-- 데스크탑 우측 메뉴 -->
    <div class="hidden lg:flex items-center gap-3 shrink-0">
      <% if (loginUser != null) { %>
        <a href="mypage.jsp" class="text-sm text-[#c8a96e] font-medium hover:text-[#d4b87e] transition-colors"><%= loginUser.getName() %>님</a>
        <% if (!"admin".equals(userRole)) { %>
        <a href="cartList"
           class="flex items-center gap-1.5 px-4 py-2 rounded-lg text-[#c8a96e] text-sm
                  bg-[rgba(200,169,110,0.08)] border border-[rgba(200,169,110,0.25)]
                  hover:bg-[rgba(200,169,110,0.15)] transition-all">
          장바구니
        </a>
        <% } %>
        <a href="logout"
           onclick="return confirm('로그아웃 하시겠습니까?')"
           class="px-4 py-2 rounded-lg text-sm text-[#8a8790] border border-[rgba(255,255,255,0.07)]
                  hover:text-[#f0ede8] hover:border-[rgba(255,255,255,0.15)] transition-all">
          로그아웃
        </a>
      <% } else { %>
        <a href="login.jsp"
           class="px-4 py-2 rounded-lg text-sm text-[#8a8790] border border-[rgba(255,255,255,0.07)]
                  hover:text-[#f0ede8] hover:border-[rgba(255,255,255,0.15)] transition-all">
          로그인
        </a>
        <a href="join.jsp"
           class="px-4 py-2 rounded-lg text-sm bg-[#c8a96e] text-[#0a0a0b] font-semibold
                  hover:bg-[#d4b87e] transition-colors">
          회원가입
        </a>
      <% } %>
    </div>

    <!-- 모바일: 장바구니 + 햄버거 -->
    <div class="flex lg:hidden items-center gap-2">
      <% if (loginUser != null && !"admin".equals(userRole)) { %>
      <a href="cartList" class="px-3 py-2 rounded-lg text-xs text-[#c8a96e] bg-[rgba(200,169,110,0.08)] border border-[rgba(200,169,110,0.25)]">장바구니</a>
      <% } %>
      <button onclick="toggleMobileMenu()"
              class="p-2 rounded-lg text-[#8a8790] hover:text-[#f0ede8] hover:bg-[rgba(255,255,255,0.07)] transition-all">
        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"/>
        </svg>
      </button>
    </div>
  </div>

  <!-- 모바일 드롭다운 -->
  <div id="mobileMenu" class="hidden lg:hidden border-t border-[rgba(255,255,255,0.07)] bg-[#111113]">
    <div class="max-w-7xl mx-auto px-4 py-3 flex flex-col gap-1">
      <a href="list" class="px-4 py-3 text-sm text-[#8a8790] hover:text-[#f0ede8] hover:bg-[rgba(255,255,255,0.05)] rounded-lg transition-all">전체상품</a>
      <% if (loginUser != null) { %>
        <a href="mypage.jsp" class="px-4 py-3 text-sm text-[#c8a96e] hover:bg-[rgba(255,255,255,0.05)] rounded-lg transition-all"><%= loginUser.getName() %>님의 마이페이지</a>
        <% if ("admin".equals(userRole)) { %>
          <a href="adminMemberList.jsp" class="px-4 py-3 text-sm text-[#8a8790] hover:text-[#f0ede8] hover:bg-[rgba(255,255,255,0.05)] rounded-lg transition-all">회원관리</a>
          <a href="adminOrderList" class="px-4 py-3 text-sm text-[#8a8790] hover:text-[#f0ede8] hover:bg-[rgba(255,255,255,0.05)] rounded-lg transition-all">주문관리</a>
          <a href="adminConfig.jsp" class="px-4 py-3 text-sm text-[#8a8790] hover:text-[#f0ede8] hover:bg-[rgba(255,255,255,0.05)] rounded-lg transition-all">시스템설정</a>
          <a href="adminCharge.jsp" class="px-4 py-3 text-sm text-[#8a8790] hover:text-[#f0ede8] hover:bg-[rgba(255,255,255,0.05)] rounded-lg transition-all">충전승인</a>
        <% } %>
        <div class="border-t border-[rgba(255,255,255,0.07)] my-1"></div>
        <a href="logout" onclick="return confirm('로그아웃 하시겠습니까?')"
           class="px-4 py-3 text-sm text-[#8a8790] hover:text-[#f0ede8] hover:bg-[rgba(255,255,255,0.05)] rounded-lg transition-all">로그아웃</a>
      <% } else { %>
        <a href="login.jsp" class="px-4 py-3 text-sm text-[#8a8790] hover:text-[#f0ede8] hover:bg-[rgba(255,255,255,0.05)] rounded-lg transition-all">로그인</a>
        <a href="join.jsp" class="px-4 py-3 text-sm text-[#8a8790] hover:text-[#f0ede8] hover:bg-[rgba(255,255,255,0.05)] rounded-lg transition-all">회원가입</a>
      <% } %>
    </div>
  </div>
</header>

<script>
function toggleMobileMenu() {
  document.getElementById('mobileMenu').classList.toggle('hidden');
}
function openModal(id) {
  document.getElementById(id).classList.remove('hidden');
  document.body.style.overflow = 'hidden';
}
function closeModal(id) {
  document.getElementById(id).classList.add('hidden');
  document.body.style.overflow = '';
}
</script>
