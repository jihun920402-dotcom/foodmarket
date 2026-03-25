<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="model.OrderDAO, model.OrderDTO, java.util.List"%>
<%@ page import="model.MemberDTO"%>

<%-- 1. 헤더 포함 (loginUser 체크는 헤더 내부 로직과 맞춤) --%>
<%@ include file="header.jsp"%>

<%
    // 관리자 권한 체크 (userRole은 header.jsp에서 이미 선언됨)
    if (!"admin".equals(userRole)) {
        out.println("<script>alert('관리자만 접근 가능합니다.'); location.href='list';</script>");
        return;
    }

    // 주문 목록 가져오기
    OrderDAO dao = new OrderDAO();
    List<OrderDTO> list = dao.getAllOrders();
%>

<style>
/* 기존 컨셉 유지하며 디테일 보완 */
.table-container {
	background: white;
	border-radius: 15px;
	padding: 20px; /* 모바일 대응 위해 패딩 살짝 축소 */
	margin-top: 30px;
	margin-bottom: 50px;
}

.status-badge {
	padding: 6px 12px;
	border-radius: 20px;
	font-size: 0.8rem;
	font-weight: bold;
	display: inline-block;
	white-space: nowrap;
}

/* 상태별 색상 (사장님 기존 색상 유지 및 가독성 업) */
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

/* [핵심] 모바일 반응형 테이블 설정 */
@media ( max-width : 991px) {
	.table-responsive-custom {
		overflow-x: auto;
		-webkit-overflow-scrolling: touch;
	}
	.table {
		min-width: 900px; /* 정보가 많으므로 최소 폭 확보 */
		font-size: 14px;
	}
	.btn-sm {
		padding: 4px 8px;
		font-size: 12px;
	}
}

/* 주소 열 너비 제한 */
.address-text {
	max-width: 180px;
	display: block;
	overflow: hidden;
	text-overflow: ellipsis;
	white-space: nowrap;
}
</style>

<div class="container">
	<div class="table-container shadow-sm border">
		<div class="d-flex justify-content-between align-items-center mb-4">
			<div>
				<h2 class="fw-bold mb-1">📦 전체 주문 관리</h2>
				<p class="text-muted mb-0 small">고객님의 주문 내역 확인 및 배송 상태를 관리합니다.</p>
			</div>
			<span class="badge bg-dark rounded-pill">총 <%= list != null ? list.size() : 0 %>건
			</span>
		</div>

		<div class="table-responsive-custom">
			<table class="table table-hover align-middle">
				<thead class="table-light">
					<tr class="text-center">
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
                            if("배송준비".equals(currentStatus)) badgeClass = "status-ready";
                            else if("배송중".equals(currentStatus)) badgeClass = "status-shipping";
                            else if("배송완료".equals(currentStatus)) badgeClass = "status-done";
                    %>
					<tr class="text-center">
						<td><strong>#<%= order.getOrderId() %></strong></td>
						<td><%= order.getUserid() %></td>
						<td class="text-primary fw-bold"><%= String.format("%,d", order.getTotalPrice()) %>원</td>
						<td class="small text-muted"><%= order.getOrderDate() %></td>
						<td class="text-start"><span class="address-text"
							title="<%= order.getAddress() %>"> <small><%= order.getAddress() %></small>
						</span></td>
						<td><span class="status-badge <%= badgeClass %>"><%= currentStatus %></span></td>
						<td>
							<div class="d-flex gap-1 justify-content-center">
								<div class="btn-group">
									<button type="button"
										class="btn btn-sm btn-outline-success dropdown-toggle fw-bold"
										data-bs-toggle="dropdown">상태변경</button>
									<ul class="dropdown-menu shadow-sm">
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
								<button class="btn btn-sm btn-outline-danger fw-bold"
									onclick="if(confirm('주문을 취소하시겠습니까?')) location.href='deleteOrder?orderId=<%= order.getOrderId() %>'">취소</button>
							</div>
						</td>
					</tr>
					<% } } else { %>
					<tr>
						<td colspan="7" class="text-center py-5 text-muted">현재 들어온
							주문이 없습니다.</td>
					</tr>
					<% } %>
				</tbody>
			</table>
		</div>
	</div>
</div>

<%@ include file="footer.jsp"%>