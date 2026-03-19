<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="header.jsp"%>

<div class="container mt-5">
	<div class="row justify-content-center">
		<div class="col-md-4">
			<div class="card shadow">
				<div class="card-header bg-primary text-white text-center">
					<h4>로그인</h4>
				</div>
				<div class="card-body p-4">
					<form action="login" method="post">
						<div class="mb-3">
							<label for="userid" class="form-label">아이디</label> <input
								type="text" name="userid" id="userid" class="form-control"
								required>
						</div>
						<div class="mb-3">
							<label for="password" class="form-label">비밀번호</label> <input
								type="password" name="password" id="password"
								class="form-control" required>
						</div>
						<div class="d-grid gap-2 mt-4">
							<button type="submit" class="btn btn-primary"
								style="display: block !important; width: 100%; color: white !important;">로그인하기</button>
							<a href="join.jsp" class="btn btn-outline-secondary">회원가입 이동</a>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
</div>

<%@ include file="footer.jsp"%>