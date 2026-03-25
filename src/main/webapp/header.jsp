<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="model.MemberDTO"%>
<%
    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
    String userRole = (loginUser != null) ? loginUser.getRole() : "";
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<%-- 1. 모바일 뷰포트 및 자동 줌 방지 설정 --%>
<meta name="viewport"
	content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">

<title>🌊 종합 마켓</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link
	href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;700&display=swap"
	rel="stylesheet">
<style>
/* 1. 기본 폰트 및 배경 설정 */
body {
	font-family: 'Noto Sans KR', sans-serif;
	margin: 0;
	padding: 0;
	width: 100%;
	overflow-x: hidden;
}

.navbar {
	background-color: #004d99;
	padding: 12px 0;
}

.navbar-brand {
	font-size: 22px;
	font-weight: 700;
	color: white !important;
	letter-spacing: -0.5px;
}

.nav-link {
	color: rgba(255, 255, 255, 0.9) !important;
	font-weight: 500;
	margin-left: 10px;
}

.user-name-link {
	color: #ffcc00 !important;
	font-weight: 700;
	text-decoration: underline;
}

/* --- [신규] 모바일 상단 퀵 버튼 스타일 --- */
.mobile-quick-nav {
	display: none;
} /* 기본 숨김 */

/* --- 모바일 반응형 통합 설정 --- */
@media ( max-width : 991px) {
	.navbar-brand {
		font-size: 19px;
	}

	/* 로고 옆 퀵 버튼 노출 */
	.mobile-quick-nav {
		display: flex !important;
		align-items: center;
		gap: 5px;
		margin-left: auto; /* 로고와 버튼 사이 간격 */
		margin-right: 10px;
	}
	.quick-btn {
		font-size: 11px !important;
		padding: 4px 8px !important;
		border-radius: 20px !important;
		white-space: nowrap;
		text-decoration: none;
		font-weight: bold;
	}
	.btn-user {
		background: rgba(255, 255, 255, 0.2);
		color: white;
		border: 1px solid rgba(255, 255, 255, 0.3);
	}
	.btn-cart {
		background: #ffcc00;
		color: #004d99;
		border: none;
	}
	.navbar-collapse {
		background: #004d99;
		padding: 15px;
		border-radius: 0 0 10px 10px;
		margin-top: 10px;
	}
	.nav-item {
		width: 100%;
		text-align: left;
	}
	.nav-link {
		margin-left: 0;
		padding: 12px 5px !important;
		border-bottom: 1px solid rgba(255, 255, 255, 0.1);
		font-size: 14px; /* 글자 크기 살짝 줄여서 깨짐 방지 */
	}

	/* 장바구니 버튼 (메뉴 안쪽) */
	.ms-3 {
		margin-left: 0 !important;
		margin-top: 10px;
		width: 100%;
		display: block;
		text-align: center;
	}
	.container {
		padding-left: 15px !important;
		padding-right: 15px !important;
	}

	/* 입력필드 자동 줌 방지 */
	input, select, textarea, .form-control {
		font-size: 16px !important;
	}
}
</style>
</head>
<body>
	<nav class="navbar navbar-expand-lg sticky-top shadow-sm">
		<div class="container d-flex align-items-center">
			<%-- 로고 --%>
			<a class="navbar-brand" href="list">🌊 종합 마켓</a>

			<%-- [추가] 모바일 상단 퀵 버튼 (로그인 상태일 때만 노출) --%>
			<div class="mobile-quick-nav">
				<% if (loginUser != null) { %>
				<a href="mypage.jsp" class="quick-btn btn-user"><%= loginUser.getName() %>님</a>
				<% if (!"admin".equals(userRole)) { %>
				<a href="cartList" class="quick-btn btn-cart">🛒 장바구니</a>
				<% } %>
				<% } else { %>
				<a href="login.jsp" class="quick-btn btn-user">로그인</a>
				<% } %>
			</div>

			<%-- 세 줄 메뉴 버튼 --%>
			<button class="navbar-toggler" type="button"
				data-bs-toggle="collapse" data-bs-target="#navbarNav"
				style="background-color: white; border: none; padding: 5px;">
				<span class="navbar-toggler-icon" style="width: 20px; height: 20px;"></span>
			</button>

			<%-- 메뉴 리스트 --%>
			<div class="collapse navbar-collapse" id="navbarNav">
				<ul class="navbar-nav ms-auto align-items-center">
					<% if (loginUser != null) { %>
					<li class="nav-item"><span class="nav-link">환영합니다, <a
							href="mypage.jsp" class="user-name-link"><%=loginUser.getName()%></a>님!
					</span></li>
					<% } %>

					<% if (loginUser == null) { %>
					<li class="nav-item"><a class="nav-link" href="login.jsp">로그인</a></li>
					<li class="nav-item"><a class="nav-link" href="join.jsp">회원가입</a></li>
					<% } else { %>
					<% if ("admin".equals(userRole)) { %>
					<li class="nav-item"><a class="nav-link"
						href="adminMemberList.jsp">👥 회원관리</a></li>
					<li class="nav-item"><a class="nav-link" href="adminOrderList">📦
							주문 관리</a></li>
					<li class="nav-item"><a class="nav-link"
						href="adminConfig.jsp">⚙️ 시스템 설정</a></li>
					<li class="nav-item"><a class="nav-link"
						href="adminCharge.jsp">💳 충전 승인</a></li>
					<% } %>

					<% if (!"admin".equals(userRole)) { %>
					<li class="nav-item"><a href="cartList"
						class="btn btn-warning btn-sm ms-3 text-dark fw-bold d-none d-lg-inline-block">🛒
							장바구니</a></li>
					<li class="nav-item d-lg-none"><a class="nav-link"
						href="cartList">🛒 장바구니 이동</a></li>
					<% } %>

					<li class="nav-item"><a class="nav-link" href="logout"
						onclick="return confirm('로그아웃 하시겠습니까?')">로그아웃</a></li>
					<% } %>
				</ul>
			</div>
		</div>
	</nav>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

	<%-- 상단바 고정으로 인한 본문 겹침 방지 여백 --%>
	<div style="padding-top: 15px;"></div>