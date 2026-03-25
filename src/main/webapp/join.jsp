<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="header.jsp"%>

<style>
@media ( max-width : 768px) {
	/* 1. 전체 카드를 화면 너비에 맞춤 */
	.col-md-6 {
		width: 100% !important;
	}

	/* 2. 카드 내부 여백 조절 */
	.card-body {
		padding: 20px !important;
	}

	/* 3. 이름과 나이 칸을 한 줄에 하나씩 나오게 변경 */
	.row.mb-3 .col-md-8, .row.mb-3 .col-md-4 {
		width: 100% !important;
		margin-bottom: 15px;
	}

	/* 4. 모든 입력창 높이를 키워 터치하기 편하게 (오타 방지) */
	.form-control {
		height: 50px !important;
		font-size: 16px !important; /* 아이폰 화면 줌 방지용 */
	}

	/* 5. 아이디 중복확인 버튼 배치 최적화 */
	.input-group {
		flex-direction: column;
	}
	.input-group .form-control {
		width: 100% !important;
		border-radius: 5px !important;
		margin-bottom: 8px;
	}
	.input-group .btn {
		width: 100% !important;
		border-radius: 5px !important;
		margin-left: 0 !important;
		height: 45px;
	}
}
</style>

<div class="container mt-5 mb-5">
	<div class="row justify-content-center">
		<div class="col-md-6">
			<div class="card shadow border-0">
				<div class="card-header bg-primary text-white text-center py-3">
					<h4 class="mb-0">회원가입 (상세정보 입력)</h4>
				</div>
				<div class="card-body p-4">
					<form action="join" method="post" onsubmit="return validateForm()">
						<h6 class="text-primary mb-3">계정 정보</h6>

						<div class="mb-3">
							<label class="form-label">아이디</label>
							<div class="input-group">
								<input type="text" name="userid" id="userid"
									class="form-control" placeholder="아이디를 입력하세요" required>
								<button type="button" class="btn btn-outline-primary"
									onclick="checkDuplicate()">중복 확인</button>
							</div>
							<div id="id_msg" class="small mt-1"></div>
							<input type="hidden" id="id_checked" value="false">
						</div>

						<div class="mb-3">
							<label class="form-label">비밀번호</label> <input type="password"
								name="password" id="password" class="form-control"
								placeholder="비밀번호를 입력하세요" required>
						</div>

						<div class="mb-3">
							<label class="form-label">비밀번호 확인</label> <input type="password"
								id="password_check" class="form-control"
								placeholder="비밀번호를 한 번 더 입력하세요" required>
							<div id="pw_msg" class="small mt-1"></div>
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

<script>
	// 1. 아이디 중복 확인 기능 (AJAX)
	function checkDuplicate() {
		const userid = document.getElementById("userid").value;
		const idMsg = document.getElementById("id_msg");
		const idChecked = document.getElementById("id_checked");

		if (userid === "") {
			alert("아이디를 입력해주세요.");
			document.getElementById("userid").focus();
			return;
		}

		// 서버의 checkId 서블릿에 물어보기
		fetch("checkId?userid=" + userid)
			.then(res => res.text())
			.then(data => {
				if (data === "success") {
					idMsg.innerHTML = "✅ 사용 가능한 아이디입니다.";
					idMsg.style.color = "green";
					idChecked.value = "true";
				} else {
					idMsg.innerHTML = "❌ 이미 사용 중인 아이디입니다.";
					idMsg.style.color = "red";
					idChecked.value = "false";
				}
			})
			.catch(err => {
				console.error("오류 발생:", err);
				alert("서버 연결에 실패했습니다.");
			});
	}

	// 아이디를 새로 입력하면 중복체크 다시 하도록 초기화
	document.getElementById("userid").addEventListener("input", function() {
		document.getElementById("id_checked").value = "false";
		document.getElementById("id_msg").innerHTML = "";
	});

	// 2. 비밀번호 실시간 일치 확인 기능
	const pw = document.getElementById("password");
	const pwCheck = document.getElementById("password_check");
	const msg = document.getElementById("pw_msg");

	function checkPw() {
		if (pwCheck.value === "") {
			msg.innerHTML = "";
			return;
		}
		if (pw.value === pwCheck.value) {
			msg.innerHTML = "✅ 비밀번호가 일치합니다.";
			msg.style.color = "green";
		} else {
			msg.innerHTML = "❌ 비밀번호가 일치하지 않습니다.";
			msg.style.color = "red";
		}
	}

	pw.addEventListener("keyup", checkPw);
	pwCheck.addEventListener("keyup", checkPw);

	// 3. 가입 버튼 눌렀을 때 최종 체크
	function validateForm() {
		// 중복 확인 여부 체크
		if (document.getElementById("id_checked").value !== "true") {
			alert("아이디 중복 확인을 먼저 해주세요!");
			return false;
		}

		// 비밀번호 일치 체크
		if (pw.value !== pwCheck.value) {
			alert("비밀번호가 일치하지 않습니다. 다시 확인해주세요!");
			pwCheck.focus();
			return false;
		}
		return true;
	}
</script>

<%@ include file="footer.jsp"%>