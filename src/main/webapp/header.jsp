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

/* 관리자 메뉴 색상 통일 */
.admin-link, .admin-charge-link, .admin-member-link {
	color: rgba(255, 255, 255, 0.9) !important;
	font-weight: 500;
}
</style>
</head>
<body>
	<nav class="navbar navbar-expand-lg sticky-top shadow-sm">
		<div class="container">
			<a class="navbar-brand" href="list">🌊 종합 마켓</a>
			<button class="navbar-toggler" type="button"
				data-bs-toggle="collapse" data-bs-target="#navbarNav">
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
	<div style="padding-top: 20px;"></div>