<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="model.MarketInfoDAO, model.MarketInfoDTO"%>
<%@ page import="model.MemberDTO"%>
<%@ include file="header.jsp"%>

<%
if (loginUser == null) {
	response.sendRedirect("login.jsp");
	return;
}

boolean isAdmin = "admin".equals(userRole);
MarketInfoDAO infoDao = new MarketInfoDAO();
MarketInfoDTO mInfo = infoDao.getInfo();

String bank = (mInfo != null) ? mInfo.getBankName() : "우리은행";
String account = (mInfo != null) ? mInfo.getAccountNumber() : "1002-123-456789";
String holder = (mInfo != null) ? mInfo.getAccountHolder() : "종합마켓";
%>

<style>
/* 마이페이지 전용 스타일 보완 */
.info-card {
	border-radius: 20px !important;
	overflow: hidden;
}

/* 버튼 간격 및 정렬 최적화 */
.mypage-btn-group {
	display: flex;
	flex-direction: column;
	gap: 12px; /* 버튼 사이 간격 확보 */
	margin-top: 15px;
}

.bottom-action-group {
	display: flex;
	flex-direction: column;
	gap: 10px; /* 하단 버튼 사이 간격 */
	margin-top: 30px;
}

/* 모바일 대응 */
@media ( max-width : 768px) {
	.display-6 {
		font-size: 2rem !important;
	}
	.col-md-4 {
		border-right: none !important;
		border-bottom: 1px solid #eee;
		padding-bottom: 20px;
		margin-bottom: 20px;
	}
	.ps-md-4 {
		padding-left: 0 !important;
		text-align: center;
	}
	.table th {
		width: 40% !important;
		font-size: 13px;
	}
	.table td {
		font-size: 13px;
	}
}
</style>

<div class="container mt-5 mb-5">
	<div class="row justify-content-center">
		<div class="col-md-8">
			<%
			if ("1".equals(request.getParameter("success"))) {
			%>
			<div
				class="alert alert-success alert-dismissible fade show border-0 shadow-sm"
				role="alert">
				<strong>신청 완료!</strong> 입금 확인 신청이 접수되었습니다. 관리자 승인 후 충전됩니다.
				<button type="button" class="btn-close" data-bs-dismiss="alert"
					aria-label="Close"></button>
			</div>
			<%
			}
			%>

			<%
			if ("1".equals(request.getParameter("updateSuccess"))) {
			%>
			<div
				class="alert alert-info alert-dismissible fade show border-0 shadow-sm"
				role="alert">
				회원 정보가 성공적으로 수정되었습니다.
				<button type="button" class="btn-close" data-bs-dismiss="alert"
					aria-label="Close"></button>
			</div>
			<%
			}
			%>

			<div class="card shadow-sm border-0 info-card">
				<div
					class="card-header bg-white py-3 d-flex justify-content-between align-items-center border-bottom">
					<h4 class="mb-0 fw-bold">👤 내 정보 관리</h4>
					<a href="list"
						class="btn btn-outline-secondary btn-sm rounded-pill">쇼핑 계속하기</a>
				</div>

				<div class="card-body p-4 p-md-5">
					<div class="row mb-4 align-items-center">
						<div class="col-md-4 text-center border-end">
							<div
								class="bg-light rounded-circle d-inline-flex align-items-center justify-content-center mb-3 shadow-sm"
								style="width: 100px; height: 100px;">
								<span style="font-size: 40px;">👤</span>
							</div>
							<h5 class="fw-bold mb-1"><%=loginUser.getName()%>님
							</h5>
							<span class="badge bg-primary rounded-pill px-3"><%=loginUser.getRole().toUpperCase()%></span>
						</div>

						<div class="col-md-8 ps-md-4">
							<h5 class="text-primary mb-2" style="font-size: 1.1rem;">나의
								마일리지</h5>
							<div class="display-6 fw-bold text-dark mb-3">
								<%=String.format("%,d", loginUser.getMileage())%><small
									style="font-size: 20px;">원</small>
							</div>

							<div class="mypage-btn-group">
								<%
								if (!isAdmin) {
								%>
								<button type="button"
									class="btn btn-primary btn-lg fw-bold shadow-sm py-3"
									data-bs-toggle="modal" data-bs-target="#chargeModal">
									마일리지 충전하기</button>
								<a href="chargeList.jsp"
									class="btn btn-outline-primary btn-lg fw-bold shadow-sm py-3">
									마일리지 충전내역 </a>
								<%
								}
								%>
							</div>
						</div>
					</div>

					<hr class="my-4 opacity-25">

					<h5 class="mb-3 fw-bold">
						<i class="bi bi-info-circle me-2"></i>상세 배송 및 계좌 정보
					</h5>
					<div class="table-responsive">
						<table class="table align-middle border-top">
							<tr>
								<th class="table-light py-3" style="width: 30%;">전화번호</th>
								<td class="py-3"><%=(loginUser.getPhone() != null) ? loginUser.getPhone() : "미등록"%></td>
							</tr>
							<tr>
								<th class="table-light py-3">배송지 주소</th>
								<td class="py-3"><%=(loginUser.getAddress() != null) ? loginUser.getAddress() : "미등록"%></td>
							</tr>
							<tr>
								<th class="table-light py-3">나의 환불 계좌</th>
								<td class="py-3"><%=(loginUser.getAccountNumber() != null) ? loginUser.getAccountNumber() : "미등록"%>
									(본인)</td>
							</tr>
						</table>
					</div>

					<div class="bottom-action-group">
						<%
						if (!isAdmin) {
						%>
						<a href="orderList"
							class="btn btn-info btn-lg px-4 text-white fw-bold shadow-sm py-3">
							📦 주문 기록 보기 </a>
						<%
						}
						%>
						<button class="btn btn-warning btn-lg px-4 fw-bold shadow-sm py-3"
							data-bs-toggle="modal" data-bs-target="#editProfileModal">
							정보 수정하기</button>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<%-- 1. 마일리지 충전 모달 --%>
<div class="modal fade" id="chargeModal" tabindex="-1"
	aria-hidden="true">
	<div class="modal-dialog modal-dialog-centered">
		<div class="modal-content border-0 shadow-lg"
			style="border-radius: 20px;">
			<div class="modal-header bg-primary text-white border-0 py-3">
				<h5 class="modal-title fw-bold">마일리지 충전 신청</h5>
				<button type="button" class="btn-close btn-close-white"
					data-bs-dismiss="modal"></button>
			</div>
			<div class="modal-body p-4">
				<div class="alert alert-warning border-0 small">
					<strong>[필독] 입금 안내</strong><br> 아래의 마켓 전용 계좌로 입금해 주셔야 확인 후
					충전됩니다.
				</div>
				<div class="bg-light p-4 rounded-3 text-center my-4 border">
					<p class="text-muted small mb-2">
						입금하실 계좌 (예금주:
						<%=holder%>)
					</p>
					<h4 class="fw-bold text-dark mb-0"><%=bank%></h4>
					<h3 class="fw-bold text-primary"><%=account%></h3>
					<p class="mb-0 mt-2 text-secondary">
						입금자명: <strong><%=loginUser.getName()%></strong>
					</p>
				</div>
				<div class="mb-2">
					<label class="form-label fw-bold">충전 희망 금액 선택</label> <select
						id="chargeAmount" class="form-select form-select-lg border-2">
						<option value="10000">10,000원</option>
						<option value="50000">50,000원</option>
						<option value="100000">100,000원</option>
						<option value="300000">300,000원</option>
						<option value="500000">500,000원</option>
					</select>
				</div>
			</div>
			<div class="modal-footer bg-light border-0">
				<button type="button"
					class="btn btn-link text-muted text-decoration-none"
					data-bs-dismiss="modal">취소</button>
				<button type="button"
					class="btn btn-primary px-4 fw-bold rounded-pill"
					onclick="requestCharge()">입금 완료 및 신청</button>
			</div>
		</div>
	</div>
</div>

<%-- 2. 내 정보 수정 모달 --%>
<div class="modal fade" id="editProfileModal" tabindex="-1"
	aria-hidden="true">
	<div class="modal-dialog modal-dialog-centered">
		<div class="modal-content border-0 shadow-lg"
			style="border-radius: 20px;">
			<div class="modal-header bg-warning border-0 py-3">
				<h5 class="modal-title fw-bold">내 정보 수정</h5>
				<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
			</div>
			<form action="updateMember" method="post">
				<div class="modal-body p-4">
					<div class="mb-3">
						<label class="form-label fw-bold">아이디 (변경불가)</label> <input
							type="text" class="form-control bg-light"
							value="<%=loginUser.getUserid()%>" readonly>
					</div>
					<div class="mb-3">
						<label class="form-label fw-bold">비밀번호</label> <input
							type="password" name="password" class="form-control border-2"
							value="<%=loginUser.getPassword()%>" required>
					</div>
					<div class="mb-3">
						<label class="form-label fw-bold">이름</label> <input type="text"
							name="name" class="form-control border-2"
							value="<%=loginUser.getName()%>" required>
					</div>
					<div class="mb-3">
						<label class="form-label fw-bold">전화번호</label> <input type="text"
							name="phone" class="form-control border-2"
							value="<%=(loginUser.getPhone() != null) ? loginUser.getPhone() : ""%>">
					</div>
					<div class="mb-3">
						<label class="form-label fw-bold">배송지 주소</label> <input
							type="text" name="address" class="form-control border-2"
							value="<%=(loginUser.getAddress() != null) ? loginUser.getAddress() : ""%>">
					</div>
					<div class="mb-3">
						<label class="form-label fw-bold">환불 계좌번호</label> <input
							type="text" name="accountNumber" class="form-control border-2"
							value="<%=(loginUser.getAccountNumber() != null) ? loginUser.getAccountNumber() : ""%>">
					</div>
				</div>
				<div class="modal-footer bg-light border-0">
					<button type="button"
						class="btn btn-link text-muted text-decoration-none"
						data-bs-dismiss="modal">닫기</button>
					<button type="submit"
						class="btn btn-warning fw-bold px-4 rounded-pill">수정 완료</button>
				</div>
			</form>
		</div>
	</div>
</div>

<script>
	function requestCharge() {
		const amount = document.getElementById('chargeAmount').value;
		const formattedAmount = parseInt(amount).toLocaleString();
		if (confirm(formattedAmount + "원을 입금하셨습니까?\n확인을 누르면 신청이 완료됩니다.")) {
			location.href = "requestCharge?amount=" + amount;
		}
	}
</script>

<%@ include file="footer.jsp"%>