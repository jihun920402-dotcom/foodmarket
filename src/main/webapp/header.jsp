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
body {
	font-family: 'Noto Sans KR', sans-serif;
}

.navbar {
	background-color: #004d99;
	padding: 15px 0;
}

.navbar-brand {
	font-size: 24px;
	font-weight: 700;
	color: white !important;
}

.nav-link {
	color: rgba(255, 255, 255, 0.9) !important;
	font-weight: 500;
	margin-left: 15px;
}

.nav-link:hover {
	color: white !important;
}

.user-name-link {
	color: #ffcc00 !important;
	font-weight: 700;
	text-decoration: none;
}

.admin-link, .admin-charge-link, .admin-member-link {
	color: rgba(255, 255, 255, 0.9) !important;
	font-weight: 500;
}

/* --- [합체 및 보완] 모바일 반응형 통합 설정 --- */
@media ( max-width : 991px) {
	/* 1. 메뉴 스타일 (기존꺼 그대로) */
	.nav-link {
		margin-left: 0;
		padding: 10px 0;
		border-bottom: 1px solid rgba(255, 255, 255, 0.1);
	}
	.ms-3 {
		margin-left: 0 !important;
		margin-top: 10px;
		width: 100%;
	}
	.navbar-nav {
		padding-top: 15px;
	}

	/* 2. 모든 페이지 공통 최적화 (새로 추가된 치트키) */
	.container, .shop-container, .main-container {
		width: 100% !important;
		padding-left: 15px !important;
		padding-right: 15px !important;
	}

	/* 표(Table)가 들어가는 모든 페이지(주문내역, 충전내역 등) 대응 */
	.card-body, .table-responsive {
		overflow-x: auto !important;
		-webkit-overflow-scrolling: touch;
	}
	table {
		min-width: 600px; /* 표가 찌그러지지 않게 보호 */
	}

	/* 입력창과 버튼을 큼직하게 (회원수정, 충전신청 등 대응) */
	input[type="text"], input[type="password"], input[type="number"],
		.form-control {
		height: 48px !important;
		font-size: 16px !important;
	}

	/* 제목 크기 조절 */
	h2 {
		font-size: 1.6rem !important;
	}
	h4 {
		font-size: 1.3rem !important;
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