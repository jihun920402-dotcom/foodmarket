<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="header.jsp"%>

<%
    // 서블릿에서 넘겨준 파라미터 받기
    String orderId = request.getParameter("orderId");
    String totalPriceParam = request.getParameter("totalPrice");
    String pName = request.getParameter("pName");

    // [중요] Null 및 데이터 방어 로직
    if (orderId == null) orderId = "확인중";
    if (pName == null) pName = "선택 상품";
    
    int displayPrice = 0;
    if (totalPriceParam != null && !totalPriceParam.isEmpty()) {
        try {
            displayPrice = Integer.parseInt(totalPriceParam);
        } catch (NumberFormatException e) {
            displayPrice = 0;
        }
    }
%>

<div class="container mt-5 text-center">
	<div class="card shadow border-0 p-5 mx-auto" style="max-width: 700px;">
		<div class="mb-4">
			<i class="bi bi-bag-check-fill text-success" style="font-size: 5rem;"></i>
		</div>
		<h2 class="fw-bold mb-3">주문이 성공적으로 이루어졌습니다!</h2>
		<p class="text-muted fs-5 mb-5">저희 마켓을 이용해 주셔서 진심으로 감사합니다.</p>

		<div class="bg-light p-4 rounded-3 text-start mb-4">
			<h5 class="fw-bold border-bottom pb-2 mb-3">📋 주문 상세 내역</h5>
			<div class="d-flex justify-content-between mb-2">
				<span class="text-muted">주문 번호</span> <span class="fw-bold"><%= orderId %></span>
			</div>
			<div class="d-flex justify-content-between mb-2">
				<span class="text-muted">주문 상품</span> <span class="fw-bold"><%= pName %></span>
			</div>
			<div class="d-flex justify-content-between">
				<span class="text-muted">총 결제 금액</span> <span
					class="fw-bold text-danger"> <%-- 안전하게 처리된 숫자를 포맷팅하여 출력 --%>
					<%= String.format("%,d", displayPrice) %>원
				</span>
			</div>
		</div>

		<div class="d-grid gap-2 d-md-block">
			<a href="list" class="btn btn-outline-dark btn-lg px-4">계속 쇼핑하기</a> <a
				href="orderList" class="btn btn-primary btn-lg px-4">나의 주문목록</a>
		</div>
	</div>
</div>

<%@ include file="footer.jsp"%>