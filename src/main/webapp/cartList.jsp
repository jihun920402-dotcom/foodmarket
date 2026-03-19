<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.CartDTO"%>
<%@ include file="header.jsp"%>

<%
    List<CartDTO> cartList = (List<CartDTO>) request.getAttribute("cartList");
    int totalSum = 0;
    String representativeName = "";
    int cartSize = 0;

    if (cartList != null && !cartList.isEmpty()) {
        cartSize = cartList.size();
        representativeName = cartList.get(0).getProductName();
        if (cartSize > 1) representativeName += " 외 " + (cartSize - 1) + "건";
        for (CartDTO cart : cartList) {
            totalSum += (cart.getProductPrice() * cart.getCount());
        }
    }
%>

<div class="container mt-5">
	<h2 class="fw-bold mb-4">🛒 나의 장바구니</h2>

	<% if (cartList == null || cartList.isEmpty()) { %>
	<div class="text-center py-5 shadow-sm bg-light rounded border">
		<p class="text-muted fs-5">장바구니가 비어 있습니다.</p>
		<a href="list" class="btn btn-primary px-4 py-2">상품 보러 가기</a>
	</div>
	<% } else { %>
	<div class="row">
		<div class="col-md-8">
			<table class="table align-middle border-top">
				<thead class="table-light text-center">
					<tr>
						<th>상품정보</th>
						<th>가격</th>
						<th>수량</th>
						<th>소계</th>
						<th>관리</th>
					</tr>
				</thead>
				<tbody>
					<% for (CartDTO cart : cartList) { 
                        int subtotal = cart.getProductPrice() * cart.getCount();
                        String imgUrl = cart.getImgUrl();
                        if(imgUrl != null && !imgUrl.startsWith("http") && !imgUrl.startsWith("images/")) {
                            imgUrl = "images/" + imgUrl;
                        }
                    %>
					<tr>
						<td>
							<div class="d-flex align-items-center">
								<img src="<%= imgUrl %>" width="60" height="60"
									class="rounded me-3 shadow-sm" style="object-fit: cover;"
									onerror="this.src='https://via.placeholder.com/60'"> <span
									class="fw-bold"><%= cart.getProductName() %></span>
							</div>
						</td>
						<td class="text-center"><%= String.format("%,d", cart.getProductPrice()) %>원</td>
						<td class="text-center"><%= cart.getCount() %>개</td>
						<td class="text-center fw-bold text-primary"><%= String.format("%,d", subtotal) %>원</td>
						<td class="text-center"><a
							href="deleteCart?cart_id=<%= cart.getCartId() %>"
							class="btn btn-sm btn-outline-danger"
							onclick="return confirm('정말 삭제하시겠습니까?');">삭제</a></td>
					</tr>
					<% } %>
				</tbody>
			</table>
		</div>
		<div class="col-md-4">
			<div class="card border-0 shadow-sm sticky-top" style="top: 100px;">
				<div class="card-header bg-dark text-white py-3 text-center">
					<h5 class="mb-0 fw-bold">결제 요약</h5>
				</div>
				<div class="card-body p-4 bg-light">
					<div class="d-flex justify-content-between mb-4">
						<span class="fw-bold h5">최종 결제금액</span> <span
							class="fw-bold h5 text-danger"><%= String.format("%,d", totalSum) %>원</span>
					</div>
					<form action="checkout" method="post"
						onsubmit="return confirm('정말로 결제를 진행하시겠습니까?');">
						<input type="hidden" name="totalPrice" value="<%= totalSum %>">
						<input type="hidden" name="pName"
							value="<%= representativeName %>">
						<div
							class="bg-white p-3 rounded mb-3 small shadow-sm border-start border-4 border-primary">
							<p class="mb-1 text-muted">결제 후 잔여 마일리지</p>
							<p class="mb-0 fw-bold"><%= String.format("%,d", (loginUser != null ? loginUser.getMileage() - totalSum : 0)) %>원
							</p>
						</div>
						<button type="submit"
							class="btn btn-primary w-100 btn-lg fw-bold py-3">결제하기</button>
					</form>
				</div>
			</div>
		</div>
	</div>
	<% } %>
</div>
<%@ include file="footer.jsp"%>