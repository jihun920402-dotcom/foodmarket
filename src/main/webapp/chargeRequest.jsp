<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="model.MemberDTO"%>
<%@ include file="header.jsp"%>

<style>
/* 사장님 마켓 스타일 가이드 적용 */
.shop-container {
	max-width: 600px;
	margin: 60px auto;
	padding: 0 20px;
}

.main-banner {
	background: #e0f2fe;
	padding: 40px;
	text-align: center;
	border-radius: 15px;
	margin-bottom: 30px;
	color: #0369a1;
}

.charge-card {
	background: white;
	padding: 40px;
	border-radius: 20px;
	box-shadow: 0 10px 30px rgba(0, 0, 0, 0.05);
	border: 1px solid #eef2f6;
}

.input-label {
	font-weight: 700;
	color: #334155;
	margin-bottom: 12px;
	display: block;
}

.amount-btn-group {
	display: grid;
	grid-template-columns: repeat(3, 1fr);
	gap: 10px;
	margin-bottom: 25px;
}

.btn-amount {
	background: #f8fafc;
	border: 1px solid #e2e8f0;
	padding: 12px 5px;
	border-radius: 10px;
	color: #64748b;
	font-weight: 600;
	transition: 0.2s;
}

.btn-amount:hover {
	background: #e0f2fe;
	border-color: #3b82f6;
	color: #3b82f6;
}

.amount-input-wrapper {
	position: relative;
	margin-bottom: 8px;
}

.amount-input {
	height: 65px;
	font-size: 26px;
	font-weight: 800;
	text-align: right;
	color: #0369a1;
	border-radius: 12px;
	border: 2px solid #f1f5f9;
	padding-right: 50px;
}

.currency-unit {
	position: absolute;
	right: 20px;
	top: 50%;
	transform: translateY(-50%);
	font-size: 20px;
	font-weight: bold;
	color: #94a3b8;
}

/* 버튼 비율 (3:7) */
.btn-group-custom {
	display: flex;
	gap: 12px;
	margin-top: 35px;
}

.btn-back {
	flex: 3;
	height: 55px;
	border-radius: 10px;
	border: 1px solid #e2e8f0;
	background: white;
	color: #64748b;
	font-weight: 600;
	display: flex;
	align-items: center;
	justify-content: center;
	text-decoration: none;
}

.btn-submit {
	flex: 7;
	height: 55px;
	border-radius: 10px;
	background: #3b82f6;
	color: white;
	font-weight: 800;
	font-size: 18px;
	border: none;
	box-shadow: 0 4px 12px rgba(59, 130, 246, 0.3);
}
</style>

<div class="shop-container">
	<div class="main-banner">
		<h2 class="fw-bold mb-1">💰 MILEAGE CHARGE</h2>
		<p class="mb-0 opacity-75">원하시는 충전 금액을 입력해 주세요.</p>
	</div>

	<div class="charge-card">
		<form action="requestCharge" method="post" id="chargeForm">
			<div class="mb-4">
				<label class="input-label">빠른 금액 선택</label>
				<div class="amount-btn-group">
					<button type="button" class="btn-amount" onclick="addAmount(10000)">+
						1만</button>
					<button type="button" class="btn-amount" onclick="addAmount(30000)">+
						3만</button>
					<button type="button" class="btn-amount" onclick="addAmount(50000)">+
						5만</button>
					<button type="button" class="btn-amount"
						onclick="addAmount(100000)">+ 10만</button>
					<button type="button" class="btn-amount"
						onclick="addAmount(500000)">+ 50만</button>
					<button type="button" class="btn-amount" onclick="resetAmount()"
						style="color: #ef4444;">초기화</button>
				</div>
			</div>

			<div class="amount-input-wrapper">
				<label class="input-label" for="amount">충전 신청 금액</label> <input
					type="number" name="amount" id="amount"
					class="form-control amount-input" placeholder="0" required
					min="1000" step="1000"> <span class="currency-unit">원</span>
			</div>

			<div class="btn-group-custom">
				<a href="chargeList.jsp" class="btn-back">목록으로</a>
				<button type="submit" class="btn-submit">충전 신청하기</button>
			</div>
		</form>
	</div>
</div>

<script>
const amountInput = document.getElementById('amount');

function addAmount(val) {
    let currentVal = parseInt(amountInput.value) || 0;
    amountInput.value = currentVal + val;
}

function resetAmount() {
    amountInput.value = '';
    amountInput.focus();
}

document.getElementById('chargeForm').onsubmit = function() {
    const val = parseInt(amountInput.value);
    if (val < 1000) {
        alert("최소 1,000원부터 충전이 가능합니다.");
        return false;
    }
    return confirm(val.toLocaleString() + "원을 충전 신청하시겠습니까?");
};
</script>

<%@ include file="footer.jsp"%>