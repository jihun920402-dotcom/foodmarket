<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<style>
.footer {
	width: 100%;
	border-top: 1px solid #e5e7eb; /* 조금 더 선명한 선 색상 */
	margin-top: 60px;
	padding: 40px 0;
	background: #f9fafb; /* 배경을 아주 연한 회색으로 깔아 고급스럽게 변경 */
}

.footer-content {
	/* [핵심 수정] 고정 너비 1100px를 제거하고 반응형으로 변경 */
	width: 95%;
	max-width: 1100px;
	margin: 0 auto;
	font-size: 13px;
	color: #6b7280;
	display: flex;
	justify-content: space-between;
	align-items: flex-start; /* 상단 정렬 유지 */
	box-sizing: border-box;
}

.footer-info-text {
	line-height: 1.8; /* 가독성을 위해 줄간격 확보 */
}

.footer-right-text {
	text-align: right;
}

/* 📱 모바일 대응 스타일 추가 */
@media ( max-width : 768px) {
	.footer {
		padding: 30px 0;
	}
	.footer-content {
		flex-direction: column; /* 가로 배열을 세로로 변경 */
		text-align: center; /* 모바일에서는 중앙 정렬이 깔끔함 */
		gap: 20px; /* 위아래 문단 사이 간격 */
	}
	.footer-right-text {
		text-align: center; /* 오른쪽 정렬을 중앙으로 변경 */
		width: 100%;
		border-top: 1px dashed #e5e7eb; /* 구분선 추가 */
		padding-top: 20px;
	}
}
</style>
<div class="footer">
	<div class="footer-content">
		<div class="footer-info-text">
			<p style="margin: 0;">
				<strong>SEAFOOD MARKET</strong> | 대표자: 관리자 | 사업자등록번호: 123-45-67890
			</p>
			<p style="margin: 5px 0 0 0;">주소: 대구광역시 어딘가 해산물 거리 1F</p>
		</div>
		<div class="footer-right-text">
			<p style="margin: 0;">&copy; 2026 Seafood Management System. All
				Rights Reserved.</p>
			<p style="margin: 5px 0 0 0; color: #a0aec0;">모든 해산물은 당일 배송을 원칙으로
				합니다.</p>
		</div>
	</div>
</div>
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
