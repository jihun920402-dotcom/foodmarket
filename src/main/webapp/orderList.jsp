<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="model.OrderDTO, java.util.List"%>
<%
    // Servlet에서 전달한 orderList 가져오기
    List<OrderDTO> orderList = (List<OrderDTO>) request.getAttribute("orderList");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>나의 주문 내역</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">
<style>
.order-card {
	background: white;
	border-radius: 12px;
	border: 1px solid #eee;
	margin-bottom: 20px;
	transition: 0.3s;
}

.order-card:hover {
	box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);
}

.status-badge {
	font-size: 0.8rem;
	padding: 4px 10px;
	border-radius: 20px;
	font-weight: bold;
}

.status-done {
	background-color: #e3f2fd;
	color: #0d47a1;
} /* 결제완료 */
.status-ship {
	background-color: #f1f8e9;
	color: #33691e;
} /* 배송중/완료 */
.empty-msg {
	padding: 100px 0;
	color: #888;
}
</style>
</head>
<body class="bg-light">

	<jsp:include page="header.jsp" />

	<div class="container mt-5">
		<div class="row justify-content-center">
			<div class="col-lg-10">
				<h3 class="fw-bold mb-4">
					🛍️ 주문 내역 <span class="text-muted fs-6">총 <%= (orderList != null) ? orderList.size() : 0 %>건
					</span>
				</h3>

				<hr class="mb-5">

				<% if (orderList != null && !orderList.isEmpty()) { 
                    for (OrderDTO order : orderList) { %>
				<div class="order-card p-4 shadow-sm">
					<div class="d-flex justify-content-between align-items-center mb-3">
						<div>
							<span class="text-muted small">주문번호: <strong>#<%= order.getOrderId() %></strong></span>
							<span class="mx-2 text-silver">|</span> <span
								class="text-muted small">주문일자: <%= order.getOrderDate() %></span>
						</div>
						<div>
							<% 
                                    String status = order.getStatus();
                                    String badgeClass = "status-done";
                                    if(status.contains("배송")) badgeClass = "status-ship";
                                %>
							<span class="status-badge <%= badgeClass %>"><%= status %></span>
						</div>
					</div>

					<div class="row align-items-center">
						<div class="col-md-8">
							<h5 class="fw-bold mb-1">
								<%-- 상세 상품명은 나중에 Join으로 가져올 수 있게 구조만 잡아둠 --%>
								주문 상품 (주문번호 #<%= order.getOrderId() %>)
							</h5>
							<p class="text-muted mb-0 small">
								배송지:
								<%= order.getAddress() %></p>
						</div>
						<div class="col-md-4 text-md-end mt-3 mt-md-0">
							<h4 class="text-primary fw-bold mb-0">
								<%= String.format("%,d", order.getTotalPrice()) %>원
							</h4>
							<button class="btn btn-sm btn-outline-secondary mt-2"
								onclick="location.href='orderDetail.jsp?orderId=<%= order.getOrderId() %>'">상세보기</button>
						</div>
					</div>
				</div>
				<% } } else { %>
				<div class="text-center empty-msg">
					<div class="fs-1">📝</div>
					<h5 class="mt-3">최근 주문한 내역이 없습니다.</h5>
					<p>맛있는 상품들을 구경하러 가보실까요?</p>
					<a href="/creathomepage/list" class="btn btn-primary mt-3">상품 보러가기</a>
				</div>
				<% } %>

			</div>
		</div>
	</div>

	<footer class="mt-5 py-4 text-center text-muted border-top bg-white">
		&copy; 2026
		<%= session.getAttribute("marketName") != null ? session.getAttribute("marketName") : "Market System" %>.
		All Rights Reserved.
	</footer>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>