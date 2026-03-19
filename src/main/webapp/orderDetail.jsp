<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="model.*, java.util.List"%>
<%
// [수정] 팝업 대신 리다이렉트 로직으로 변경
String orderIdStr = request.getParameter("orderId");
int orderId = 0;

// orderId가 없거나 숫자가 아니면 묻지도 따지지도 않고 목록으로 보냅니다.
if (orderIdStr == null || orderIdStr.trim().isEmpty()) {
    response.sendRedirect("orderList");
    return;
} else {
    try {
        orderId = Integer.parseInt(orderIdStr);
    } catch (NumberFormatException e) {
        response.sendRedirect("orderList");
        return;
    }
}

OrderDAO dao = new OrderDAO();

// 주문 마스터 정보와 상세 품목 리스트 조회
OrderDTO order = dao.getOrderById(orderId);
List<CartDTO> itemList = dao.getOrderDetailItems(orderId);

// DB에 데이터가 없는 경우에도 목록으로 이동
if (order == null) {
	response.sendRedirect("orderList");
	return;
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>주문 상세 내역</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">
<style>
.detail-container {
	background: white;
	border-radius: 15px;
	padding: 30px;
	margin-top: 50px;
	border: 1px solid #eee;
}

.product-img {
	width: 80px;
	height: 80px;
	object-fit: cover;
	border-radius: 8px;
}

.info-label {
	font-weight: bold;
	color: #666;
	width: 120px;
	display: inline-block;
}
</style>
</head>
<body class="bg-light">

	<jsp:include page="header.jsp" />

	<div class="container">
		<div class="row justify-content-center">
			<div class="col-lg-8 detail-container shadow-sm">
				<div class="d-flex justify-content-between align-items-center mb-4">
					<h3 class="fw-bold mb-0">📄 주문 상세 정보</h3>
					<span class="badge bg-primary fs-6"><%=order.getStatus()%></span>
				</div>

				<div class="alert alert-secondary p-3">
					<div class="mb-1">
						<span class="info-label">주문번호</span> #<%=order.getOrderId()%></div>
					<div>
						<span class="info-label">주문일시</span>
						<%=order.getOrderDate()%></div>
				</div>

				<h5 class="fw-bold mt-4 mb-3">🛒 구매 상품</h5>
				<table class="table align-middle">
					<thead class="table-light">
						<tr>
							<th colspan="2">상품 정보</th>
							<th>수량</th>
							<th class="text-end">금액</th>
						</tr>
					</thead>
					<tbody>
						<%
						if (itemList != null) {
							for (CartDTO item : itemList) {
						%>
						<tr>
							<td style="width: 100px;"><img
								src="img/<%=item.getImgUrl()%>" class="product-img" alt="상품이미지"></td>
							<td>
								<div class="fw-bold"><%=item.getProductName()%></div>
								<div class="small text-muted">
									단가:
									<%=String.format("%,d", item.getProductPrice())%>원
								</div>
							</td>
							<td><%=item.getCount()%>개</td>
							<td class="text-end fw-bold"><%=String.format("%,d", item.getProductPrice() * item.getCount())%>원
							</td>
						</tr>
						<%
							}
						}
						%>
					</tbody>
					<tfoot>
						<tr class="table-light">
							<td colspan="3" class="text-end fw-bold">총 결제 금액</td>
							<td class="text-end text-danger fw-bold fs-5"><%=String.format("%,d", order.getTotalPrice())%>원
							</td>
						</tr>
					</tfoot>
				</table>

				<h5 class="fw-bold mt-5 mb-3">📍 배송 정보</h5>
				<div class="border-top pt-3">
					<div class="mb-2">
						<span class="info-label">수령인</span>
						<%=order.getReceiverName()%></div>
					<div class="mb-2">
						<span class="info-label">연락처</span>
						<%=order.getReceiverPhone() != null ? order.getReceiverPhone() : "정보없음"%></div>
					<div class="mb-2">
						<span class="info-label">배송지 주소</span>
						<%=order.getAddress()%></div>
				</div>

				<div class="text-center mt-5">
					<a href="orderList" class="btn btn-secondary px-4">목록으로</a>
				</div>
			</div>
		</div>
	</div>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>