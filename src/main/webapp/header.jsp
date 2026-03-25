<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="model.MemberDTO"%>
<%
MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
String userRole = (loginUser != null) ? loginUser.getRole() : "";
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<meta name="viewport" content="width=device-width, initial-scale=1.0">

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
	overflow-x: hidden; /* 가로 스크롤 방지 치트키 */
}

.navbar {
	background-color: #004d99;
	padding: 12px 0; /* 높이 살짝 조절 */
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

/* --- [강력 보완] 모바일 반응형 통합 설정 --- */
@media ( max-width : 991px) {
	/* 1. 네비게이션바 정렬 */
	.navbar-brand {
		font-size: 19px; /* 모바일에서 로고 크기 살짝 축소 */
	}

	/* 2. 메뉴 펼침 시 스타일 */
	.navbar-collapse {
		background: #004d99; /* 메뉴 배경색 통일 */
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
		font-size: 15px;
	}

	/* 장바구니 버튼 모바일 최적화 */
	.ms-3 {
		margin-left: 0 !important;
		margin-top: 15px;
		width: 100%;
		display: block;
		text-align: center;
		padding: 12px !important;
		font-size: 16px !important;
	}

	/* 3. 공통 컨테이너 쏠림 방지 */
	.container, .shop-container, .main-container {
		width: 100% !important;
		max-width: 100% !important;
		padding-left: 15px !important;
		padding-right: 15px !important;
		box-sizing: border-box !important;
	}

	/* 4. 테이블(주문목록 등) 대응 - 가로 스크롤 허용 */
	.table-responsive {
		border: 0;
		margin-bottom: 0;
	}

	/* 5. 입력 필드 모바일 가독성 (터치하기 쉽게) */
	input, select, textarea, .form-control {
		font-size: 16px !important; /* 아이폰 자동 줌 방지 */
		height: auto !important;
		padding: 10px !important;
	}

	/* 제목 크기 모바일 최적화 */
	h2 {
		font-size: 1.4rem !important;
	}
	h4 {
		font-size: 1.1rem !important;
	}
}
</style>
</head>
<body>
	<nav class="navbar navbar-expand-lg sticky-top shadow-sm">
		<div class="container">
			<a class="navbar-brand" href="list">🌊 종합 마켓</a>

			<button class="navbar-toggler" type="button"
				data-bs-toggle="collapse" data-bs-target="#navbarNav"
				style="background-color: white;">
				<span class="navbar-toggler-icon"></span>
			</button>

			<div class="collapse navbar-collapse" id="navbarNav">
				<ul class="navbar-nav ms-auto align-items-center">
					<%
					if (loginUser != null) {
					%>
					<li class="nav-item"><span class="nav-link">환영합니다, <a
							href="mypage.jsp" class="user-name-link"><%=loginUser.getName()%></a>님!
					</span></li>
					<%
					}
					%>

					<%
					if (loginUser == null) {
					%>
					<li class="nav-item"><a class="nav-link" href="login.jsp">로그인</a></li>
					<li class="nav-item"><a class="nav-link" href="join.jsp">회원가입</a></li>
					<%
					} else {
					%>
					<%
					if ("admin".equals(userRole)) {
					%>
					<li class="nav-item"><a class="nav-link"
						href="adminMemberList.jsp">👥 회원관리</a></li>
					<li class="nav-item"><a class="nav-link" href="adminOrderList">📦
							주문 관리</a></li>
					<li class="nav-item"><a class="nav-link"
						href="adminConfig.jsp">⚙️ 시스템 설정</a></li>
					<li class="nav-item"><a class="nav-link"
						href="adminCharge.jsp">💳 충전 승인</a></li>
					<%
					}
					%>

					<%
					if (!"admin".equals(userRole)) {
					%>
					<li class="nav-item"><a href="cartList"
						class="btn btn-warning btn-sm ms-3 text-dark fw-bold">🛒 장바구니</a></li>
					<%
					}
					%>

					<li class="nav-item"><a class="nav-link" href="logout"
						onclick="return confirm('로그아웃 하시겠습니까?')">로그아웃</a></li>
					<%
					}
					%>
				</ul>
			</div>
		</div>
	</nav>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

	<div style="padding-top: 20px;"></div>