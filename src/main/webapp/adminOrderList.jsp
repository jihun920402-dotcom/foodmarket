<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="model.OrderDAO, model.OrderDTO, java.util.List"%>
<%@ page import="model.MemberDTO"%>
<%
    // 관리자 권한 체크
    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
    if (loginUser == null || !"admin".equals(loginUser.getRole())) {
        out.println("<script>alert('관리자만 접근 가능합니다.'); location.href='list';</script>");
        return;
    }

    // 주문 목록 가져오기
    OrderDAO dao = new OrderDAO();
    List<OrderDTO> list = dao.getAllOrders();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>📦 관리자 - 주문 관리</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">
<style>
body {
	background-color: #f8f9fa;
}

.table-container {
	background: white;
	border-radius: 15px;
	padding: 30px;
	margin-top: 30px;
}

.status-badge {
	padding: 5px 10px;
	border-radius: 20px;
	font-size: 0.85rem;
	font-weight: bold;
}
/* 상태별 색상 */
.status-paid {
	background-color: #e3f2fd;
	color: #0d47a1;
} /* 결제완료 */
.status-ready {
	background-color: #fff3e0;
	color: #e65100;
} /* 배송준비 */
.status-shipping {
	background-color: #f1f8e9;
	color: #33691e;
} /* 배송중 */
.status-done {
	background-color: #eceff1;
	color: #455a64;
} /* 배송완료 */
</style>
</head>
<body>

	<jsp:include page="header.jsp" />

	<div class="container">
		<div class="table-container shadow">
			<h2 class="mb-4">📦 전체 주문 관리</h2>
			<p class="text-muted">고객님들의 주문 내역을 확인하고 배송 상태를 관리합니다.</p>

			<table class="table table-hover mt-4">
				<thead class="table-dark">
					<tr>
						<th>주문번호</th>
						<th>주문자 ID</th>
						<th>결제금액</th>
						<th>주문일시</th>
						<th>배송지</th>
						<th>상태</th>
						<th>관리</th>
					</tr>
				</thead>
				<tbody>
					<% if (list != null && !list.isEmpty()) { 
                        for (OrderDTO order : list) { 
                            String currentStatus = order.getStatus();
                            String badgeClass = "status-paid";
                            if(currentStatus.equals("배송준비")) badgeClass = "status-ready";
                            else if(currentStatus.equals("배송중")) badgeClass = "status-shipping";
                            else if(currentStatus.equals("배송완료")) badgeClass = "status-done";
                    %>
					<tr>
						<td><strong>#<%= order.getOrderId() %></strong></td>
						<td><%= order.getUserid() %></td>
						<td class="text-primary fw-bold"><%= String.format("%,d", order.getTotalPrice()) %>원</td>
						<td><%= order.getOrderDate() %></td>
						<td><small><%= order.getAddress() %></small></td>
						<td><span class="status-badge <%= badgeClass %>"><%= currentStatus %></span></td>
						<td>
							<div class="btn-group">
								<button type="button"
									class="btn btn-sm btn-outline-success dropdown-toggle"
									data-bs-toggle="dropdown">상태변경</button>
								<ul class="dropdown-menu">
									<li><a class="dropdown-item"
										href="updateOrderStatus?orderId=<%= order.getOrderId() %>&status=결제완료">결제완료</a></li>
									<li><a class="dropdown-item"
										href="updateOrderStatus?orderId=<%= order.getOrderId() %>&status=배송준비">배송준비</a></li>
									<li><a class="dropdown-item"
										href="updateOrderStatus?orderId=<%= order.getOrderId() %>&status=배송중">배송중</a></li>
									<li><a class="dropdown-item"
										href="updateOrderStatus?orderId=<%= order.getOrderId() %>&status=배송완료">배송완료</a></li>
								</ul>
							</div>
							<button class="btn btn-sm btn-outline-danger"
								onclick="if(confirm('정말 취소하시겠습니까?')) location.href='deleteOrder?orderId=<%= order.getOrderId() %>'">취소</button>
						</td>
					</tr>
					<% } } else { %>
					<tr>
						<td colspan="7" class="text-center py-5">현재 들어온 주문이 없습니다.</td>
					</tr>
					<% } %>
				</tbody>
			</table>
		</div>
	</div>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>