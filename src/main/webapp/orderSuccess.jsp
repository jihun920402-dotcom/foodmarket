<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="header.jsp"%>

<%
    String orderId = request.getParameter("orderId");
    String totalPrice = request.getParameter("totalPrice");
    String pName = request.getParameter("pName");
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
					class="fw-bold text-danger"><%= String.format("%,d", Integer.parseInt(totalPrice)) %>원</span>
			</div>
		</div>

		<div class="d-grid gap-2 d-md-block">
			<a href="list" class="btn btn-outline-dark btn-lg px-4">계속 쇼핑하기</a> <a
				href="orderList" class="btn btn-primary btn-lg px-4">나의 주문목록</a>
		</div>
	</div>
</div>

<%@ include file="footer.jsp"%>