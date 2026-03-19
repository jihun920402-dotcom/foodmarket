<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="model.MarketInfoDAO, model.MarketInfoDTO"%>
<%@ include file="header.jsp"%>
<%
    // 관리자 권한 체크
    if (loginUser == null || !"admin".equals(loginUser.getRole())) {
        out.println("<script>alert('관리자만 접근 가능한 페이지입니다.'); location.href='list';</script>");
        return;
    }

    // DB에서 현재 설정된 계좌 정보 불러오기
    MarketInfoDAO infoDao = new MarketInfoDAO();
    MarketInfoDTO info = infoDao.getInfo();
%>

<div class="container mt-5">
	<div class="row justify-content-center">
		<div class="col-md-6">
			<% if("1".equals(request.getParameter("success"))) { %>
			<div class="alert alert-success alert-dismissible fade show">계좌
				정보가 성공적으로 업데이트되었습니다!</div>
			<% } %>

			<div class="card shadow border-0">
				<div class="card-header bg-dark text-white py-3">
					<h5 class="mb-0 fw-bold">⚙️ 관리자 시스템 설정</h5>
				</div>
				<div class="card-body p-4">
					<form action="updateMarketInfo" method="post">
						<div class="mb-4">
							<h6 class="text-primary fw-bold mb-3 border-bottom pb-2">입금
								계좌 관리</h6>
							<p class="text-muted small">이곳에서 변경한 계좌 정보는 모든 고객의 마이페이지 충전
								화면에 즉시 반영됩니다.</p>
						</div>

						<div class="mb-3">
							<label class="form-label fw-bold">은행명</label> <input type="text"
								name="bankName" class="form-control"
								value="<%= (info != null) ? info.getBankName() : "" %>" required>
						</div>

						<div class="mb-3">
							<label class="form-label fw-bold">계좌번호</label> <input type="text"
								name="accountNumber" class="form-control"
								value="<%= (info != null) ? info.getAccountNumber() : "" %>"
								required>
						</div>

						<div class="mb-3">
							<label class="form-label fw-bold">예금주 (회사명)</label> <input
								type="text" name="accountHolder" class="form-control"
								value="<%= (info != null) ? info.getAccountHolder() : "" %>"
								required>
						</div>

						<div class="d-grid gap-2 mt-4">
							<button type="submit" class="btn btn-primary btn-lg">정보
								업데이트</button>
							<a href="list" class="btn btn-light">돌아가기</a>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
</div>

<%@ include file="footer.jsp"%>