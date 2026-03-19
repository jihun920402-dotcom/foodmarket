<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="header.jsp"%>

<div class="container mt-5 mb-5">
	<div class="row justify-content-center">
		<div class="col-md-6">
			<div class="card shadow border-0">
				<div class="card-header bg-primary text-white text-center py-3">
					<h4 class="mb-0">회원가입 (상세정보 입력)</h4>
				</div>
				<div class="card-body p-4">
					<form action="join" method="post">
						<h6 class="text-primary mb-3">계정 정보</h6>
						<div class="mb-3">
							<label class="form-label">아이디</label> <input type="text"
								name="userid" class="form-control" placeholder="아이디를 입력하세요"
								required>
						</div>
						<div class="mb-3">
							<label class="form-label">비밀번호</label> <input type="password"
								name="password" class="form-control" placeholder="비밀번호를 입력하세요"
								required>
						</div>
						<hr>

						<h6 class="text-primary mb-3">배송 및 충전 정보</h6>
						<div class="row mb-3">
							<div class="col-md-8">
								<label class="form-label">이름</label> <input type="text"
									name="name" class="form-control" placeholder="성함" required>
							</div>
							<div class="col-md-4">
								<label class="form-label">나이</label> <input type="number"
									name="age" class="form-control" placeholder="나이" required>
							</div>
						</div>
						<div class="mb-3">
							<label class="form-label">전화번호</label> <input type="text"
								name="phone" class="form-control" placeholder="010-0000-0000"
								required>
						</div>
						<div class="mb-3">
							<label class="form-label">배송지 주소</label> <input type="text"
								name="address" class="form-control"
								placeholder="배송 받으실 상세 주소를 입력하세요" required>
						</div>
						<div class="mb-3">
							<label class="form-label">마일리지 충전 계좌번호</label> <input type="text"
								name="accountNumber" class="form-control"
								placeholder="환불 및 충전용 계좌번호" required>
						</div>

						<div class="d-grid gap-2 mt-4">
							<button type="submit" class="btn btn-primary btn-lg">가입
								완료</button>
							<button type="button" class="btn btn-light"
								onclick="history.back()">취소</button>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
</div>

<%@ include file="footer.jsp"%>