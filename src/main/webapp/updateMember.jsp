<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="header.jsp"%>

<%
if (loginUser == null) {
	response.sendRedirect("login.jsp");
	return;
}
%>

<div class="container mt-5 mb-5">
	<div class="row justify-content-center">
		<div class="col-md-6">
			<div class="card shadow border-0">
				<div class="card-header bg-warning text-dark text-center py-3">
					<h4 class="mb-0 fw-bold">👤 내 정보 수정</h4>
				</div>
				<div class="card-body p-4">
					<form action="updateMember" method="post">
						<div class="mb-4 text-center">
							<p class="text-muted small">아이디는 변경할 수 없습니다.</p>
						</div>

						<div class="mb-3">
							<label class="form-label fw-bold">아이디</label> <input type="text"
								name="userid" class="form-control bg-light"
								value="<%=loginUser.getUserid()%>" readonly>
						</div>

						<div class="mb-3">
							<label class="form-label fw-bold">비밀번호</label> <input
								type="password" name="password" class="form-control"
								value="<%=loginUser.getPassword()%>" required>
						</div>

						<div class="mb-3">
							<label class="form-label fw-bold">이름</label> <input type="text"
								name="name" class="form-control"
								value="<%=loginUser.getName()%>" required>
						</div>

						<div class="mb-3">
							<label class="form-label fw-bold">전화번호</label> <input type="text"
								name="phone" class="form-control"
								value="<%=(loginUser.getPhone() != null) ? loginUser.getPhone() : ""%>"
								placeholder="010-0000-0000">
						</div>

						<div class="mb-3">
							<label class="form-label fw-bold">배송지 주소</label> <input
								type="text" name="address" class="form-control"
								value="<%=(loginUser.getAddress() != null) ? loginUser.getAddress() : ""%>"
								placeholder="배송 상세 주소">
						</div>

						<div class="mb-3">
							<label class="form-label fw-bold">충전/환불 계좌번호</label> <input
								type="text" name="accountNumber" class="form-control"
								value="<%=(loginUser.getAccountNumber() != null) ? loginUser.getAccountNumber() : ""%>"
								required>
						</div>

						<div class="d-grid gap-2 mt-4">
							<button type="submit" class="btn btn-warning btn-lg fw-bold">수정
								완료</button>
							<a href="mypage.jsp" class="btn btn-light">취소하고 돌아가기</a>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
</div>

<%@ include file="footer.jsp"%>
