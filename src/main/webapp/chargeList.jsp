<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="model.*"%>
<%@ page import="java.util.*"%>
<%@ include file="header.jsp"%>

<%
MemberDTO currentUser = (MemberDTO) session.getAttribute("loginUser");

if (currentUser == null) {
	response.sendRedirect("login.jsp");
	return;
}

ChargeDAO dao = new ChargeDAO();
List<ChargeDTO> list = dao.getChargeList(currentUser.getUserid());
%>

<style>
.shop-container {
	max-width: 1000px;
	margin: 0 auto;
	padding: 20px;
}

.main-banner {
	background: #e0f2fe;
	padding: 40px;
	text-align: center;
	border-radius: 15px;
	margin-bottom: 30px;
	color: #0369a1;
}

.banner-title {
	font-size: 24px;
	font-weight: bold;
	margin-bottom: 10px;
}

.content-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 25px;
}

.charge-card {
	background: #fff;
	border-radius: 15px;
	box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
	border: 1px solid #eef2f6;
	overflow: hidden;
}

.table {
	margin-bottom: 0;
	vertical-align: middle;
}

.table thead th {
	background: #f8fafc;
	color: #64748b;
	font-weight: 600;
	padding: 15px;
	border-bottom: 1px solid #f1f5f9;
}

.table tbody td {
	padding: 18px 15px;
	color: #334155;
	border-bottom: 1px solid #f1f5f9;
}

.status-badge {
	padding: 6px 14px;
	border-radius: 20px;
	font-size: 12px;
	font-weight: bold;
}

.status-pending {
	background: #fef3c7;
	color: #92400e;
}

.status-success {
	background: #dcfce7;
	color: #166534;
}

.btn-charge {
	background: #3b82f6;
	color: white;
	padding: 10px 25px;
	border-radius: 8px;
	text-decoration: none;
	font-weight: bold;
}

.amount-text {
	font-size: 16px;
	font-weight: 800;
	color: #1e293b;
}

/* ⭐ 하단 버튼 영역 추가 스타일 */
.action-area {
	margin-top: 30px;
	display: flex;
	justify-content: center;
}

.btn-list-back {
	display: inline-flex;
	align-items: center;
	justify-content: center;
	width: 180px;
	height: 50px;
	background: white;
	color: #64748b;
	border: 1px solid #e2e8f0;
	border-radius: 10px;
	text-decoration: none;
	font-weight: 600;
	transition: 0.3s;
}

.btn-list-back:hover {
	background: #f8fafc;
	color: #1e293b;
	border-color: #cbd5e1;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
}
</style>

<div class="shop-container">
	<div class="main-banner">
		<div class="banner-title">💰 MILEAGE CENTER</div>
		<div style="font-size: 16px; opacity: 0.8;">안전하고 빠른 마일리지 충전 시스템</div>
	</div>

	<div class="content-header">
		<h2 style="font-weight: 800; color: #334155;">마일리지 충전 내역</h2>
		<a href="chargeRequest.jsp" class="btn-charge">+ 충전 신청하기</a>
	</div>

	<div class="charge-card">
		<div class="table-responsive">
			<table class="table text-center">
				<thead>
					<tr>
						<th>신청 번호</th>
						<th>신청 금액</th>
						<th>신청 일시</th>
						<th>처리 상태</th>
					</tr>
				</thead>
				<tbody>
					<%
					if (list != null && !list.isEmpty()) {
						for (ChargeDTO c : list) {
					%>
					<tr>
						<td style="color: #94a3b8; font-weight: bold;">#<%=c.getRequestId()%></td>
						<td class="amount-text"><%=String.format("%,d", c.getAmount())%>원</td>
						<td style="color: #64748b; font-size: 14px;"><%=c.getRequestDate()%></td>
						<td>
							<%
							if ("pending".equalsIgnoreCase(c.getStatus())) {
							%> <span
							class="status-badge status-pending">승인 대기</span> <%
 } else if ("success".equalsIgnoreCase(c.getStatus())) {
 %>
							<span class="status-badge status-success">충전 완료</span> <%
 } else {
 %>
							<span class="status-badge bg-light text-muted"><%=c.getStatus()%></span>
							<%
							}
							%>
						</td>
					</tr>
					<%
					}
					} else {
					%>
					<tr>
						<td colspan="4" style="padding: 100px; color: #94a3b8;">충전 신청
							내역이 존재하지 않습니다.</td>
					</tr>
					<%
					}
					%>
				</tbody>
			</table>
		</div>
	</div>

	<div class="action-area">
		<a href="mypage.jsp" class="btn-list-back"> <i
			class="bi bi-arrow-left me-2"></i> 마이페이지로
		</a>
	</div>
</div>

<%@ include file="footer.jsp"%>