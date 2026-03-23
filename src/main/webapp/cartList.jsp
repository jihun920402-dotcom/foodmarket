<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, model.CartDTO, model.MemberDTO" %>

<%-- 1. header.jsp를 먼저 포함시킵니다. (여기 안에 loginUser 선언이 이미 있음) --%>
<%@ include file="header.jsp"%>

<%
    // 2. 이미 header.jsp에서 loginUser가 만들어졌으므로 다시 선언(MemberDTO loginUser = ...)하지 않습니다.
    List<CartDTO> cartList = (List<CartDTO>) request.getAttribute("cartList");
    
    // 3. 변수 이름만 가져와서 사용합니다. (빨간줄 해결 포인트)
    int totalMileage = (loginUser != null) ? loginUser.getMileage() : 0;
%>

<div class="container" style="margin-top: 50px; margin-bottom: 100px;">
	<h2 class="mb-4">
		<i class="bi bi-cart4"></i> 나의 장바구니
	</h2>

	<div class="row">
		<div class="col-lg-8">
			<div class="card shadow-sm"
				style="border-radius: 15px; border: none;">
				<div class="card-body p-0">
					<table class="table mb-0" style="vertical-align: middle;">
						<thead class="table-light">
							<tr class="text-center">
								<th style="width: 50px;"><input type="checkbox"
									id="selectAll" class="form-check-input" checked
									onclick="toggleAll(this)"></th>
								<th>상품정보</th>
								<th>가격</th>
								<th style="width: 150px;">수량</th>
								<th>소계</th>
								<th>관리</th>
							</tr>
						</thead>
						<tbody>
							<% if (cartList == null || cartList.isEmpty()) { %>
							<tr>
								<td colspan="6" class="text-center py-5 text-muted">장바구니가
									비어 있습니다.</td>
							</tr>
							<% } else { 
                                for (CartDTO item : cartList) { %>
							<tr class="text-center cart-item-row">
								<td><input type="checkbox" name="selectedItems"
									class="form-check-input item-check"
									value="<%= item.getCartId() %>"
									data-price="<%= item.getProductPrice() %>"
									data-count="<%= item.getCount() %>" checked
									onclick="updateTotal()"></td>
								<td class="text-start">
									<div class="d-flex align-items-center">
										<img src="<%= item.getImgUrl() %>"
											style="width: 60px; height: 60px; object-fit: cover; border-radius: 8px; margin-right: 15px;">
										<span class="fw-bold"><%= item.getProductName() %></span>
									</div>
								</td>
								<td><%= String.format("%,d", item.getProductPrice()) %>원</td>
								<td>
									<form action="updateCart" method="post"
										class="d-flex align-items-center justify-content-center gap-1">
										<input type="hidden" name="cartId"
											value="<%= item.getCartId() %>">
										<button type="submit" name="count"
											value="<%= item.getCount() - 1 %>"
											class="btn btn-sm btn-outline-secondary"
											<%= item.getCount() <= 1 ? "disabled" : "" %>>-</button>
										<input type="text" value="<%= item.getCount() %>" readonly
											style="width: 35px; text-align: center; border: 1px solid #ddd;">
										<button type="submit" name="count"
											value="<%= item.getCount() + 1 %>"
											class="btn btn-sm btn-outline-secondary">+</button>
									</form>
								</td>
								<td class="text-primary fw-bold"><span><%= String.format("%,d", item.getProductPrice() * item.getCount()) %></span>원
								</td>
								<td><button class="btn btn-sm btn-outline-danger"
										onclick="if(confirm('삭제하시겠습니까?')) location.href='deleteCart?id=<%= item.getCartId() %>'">삭제</button></td>
							</tr>
							<% } } %>
						</tbody>
					</table>
				</div>
			</div>
		</div>

		<div class="col-lg-4">
			<div class="card shadow-sm"
				style="border-radius: 15px; border: none; background-color: #f8f9fa;">
				<div class="card-header bg-dark text-white text-center py-3">
					<h5 class="mb-0">결제 요약</h5>
				</div>
				<div class="card-body p-4">
					<div class="d-flex justify-content-between mb-3">
						<span class="text-muted">최종 결제금액</span>
						<h4 class="text-danger fw-bold">
							<span id="totalPriceDisplay">0</span>원
						</h4>
					</div>
					<div class="bg-white p-3 rounded-3 border mb-4">
						<small class="text-muted d-block mb-1">나의 보유 마일리지</small>
						<h5 class="mb-2 text-primary"><%= String.format("%,d", totalMileage) %>원
						</h5>
						<hr>
						<small class="text-muted d-block mb-1">결제 후 잔여 마일리지</small>
						<h5 class="mb-0">
							<span id="remainingMileageDisplay">0</span>
						</h5>
						<input type="hidden" id="currentUserMileage"
							value="<%= totalMileage %>">
					</div>
					<form action="OrderServlet" method="post" id="checkoutForm">
						<input type="hidden" name="selectedCartIds" id="selectedCartIds">
						<button type="button" onclick="submitCheckout()"
							class="btn btn-primary w-100 py-3 fw-bold">결제하기</button>
					</form>
				</div>
			</div>
		</div>
	</div>
</div>

<script>
// (기본 toggleAll, submitCheckout 함수는 동일...)

function updateTotal() {
    const checkboxes = document.querySelectorAll('.item-check:checked');
    let total = 0;
    let selectedIds = [];

    checkboxes.forEach(cb => {
        const price = parseInt(cb.getAttribute('data-price'));
        const count = parseInt(cb.getAttribute('data-count'));
        total += (price * count);
        selectedIds.push(cb.value);
    });

    document.getElementById('totalPriceDisplay').innerText = total.toLocaleString();
    
    // [수정] 마일리지 계산 로직 강화
    const currentMileage = parseInt(document.getElementById('currentUserMileage').value);
    const remaining = currentMileage - total;
    const remainingDisplay = document.getElementById('remainingMileageDisplay');
    
    remainingDisplay.innerText = remaining.toLocaleString() + "원";
    remainingDisplay.style.color = (remaining < 0) ? 'red' : 'black';
    document.getElementById('selectedCartIds').value = selectedIds.join(',');
}

function submitCheckout() {
    const selectedIds = document.getElementById('selectedCartIds').value;
    const currentMileage = parseInt(document.getElementById('currentUserMileage').value);
    // 콤마 제거 후 숫자로 변환
    const totalPrice = parseInt(document.getElementById('totalPriceDisplay').innerText.replace(/,/g, ''));

    if (!selectedIds) { alert("상품을 선택해주세요."); return; }
    if (currentMileage < totalPrice) { alert("마일리지가 부족합니다."); return; }
    if (confirm("결제하시겠습니까?")) { document.getElementById('checkoutForm').submit(); }
}

window.onload = updateTotal;
function toggleAll(selectAllBox) {
    document.querySelectorAll('.item-check').forEach(cb => cb.checked = selectAllBox.checked);
    updateTotal();
}
</script>
<%@ include file="footer.jsp"%>