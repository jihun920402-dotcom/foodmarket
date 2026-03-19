<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.ChargeDTO, model.ChargeDAO"%>
<%@ include file="header.jsp"%>

<%
    // 관리자 권한 체크 (admin이 아니면 퇴출)
    if (loginUser == null || !"admin".equals(loginUser.getRole())) {
        out.println("<script>alert('관리자만 접근 가능합니다.'); location.href='list';</script>");
        return;
    }

    // 대기 중인 신청 목록 가져오기
    ChargeDAO dao = new ChargeDAO();
    List<ChargeDTO> list = dao.getPendingRequests();
%>

<div class="container mt-5">
	<h2 class="fw-bold mb-4">💳 마일리지 충전 승인 관리</h2>

	<% if("1".equals(request.getParameter("approveSuccess"))) { %>
	<div class="alert alert-success alert-dismissible fade show">충전
		승인이 완료되어 마일리지가 지급되었습니다.</div>
	<% } %>

	<div class="card shadow-sm border-0">
		<div class="card-body p-0">
			<table class="table table-hover align-middle mb-0">
				<thead class="table-dark">
					<tr class="text-center">
						<th>신청번호</th>
						<th>아이디</th>
						<th>신청금액</th>
						<th>신청일시</th>
						<th>상태</th>
						<th>관리</th>
					</tr>
				</thead>
				<tbody>
					<% if (list.isEmpty()) { %>
					<tr>
						<td colspan="6" class="text-center py-5 text-muted">대기 중인 신청
							건이 없습니다.</td>
					</tr>
					<% } else { 
                        for (ChargeDTO req : list) { %>
					<tr class="text-center">
						<td>#<%= req.getRequestId() %></td>
						<td class="fw-bold"><%= req.getUserid() %></td>
						<td class="text-primary fw-bold"><%= String.format("%,d", req.getAmount()) %>원</td>
						<td><%= req.getRequestDate() %></td>
						<td><span class="badge bg-warning text-dark">대기중</span></td>
						<td><a
							href="approveCharge?requestId=<%= req.getRequestId() %>&userid=<%= req.getUserid() %>&amount=<%= req.getAmount() %>"
							class="btn btn-success btn-sm fw-bold"
							onclick="return confirm('<%= req.getUserid() %>님의 <%= req.getAmount() %>원 충전을 승인하시겠습니까?')">
								승인하기 </a></td>
					</tr>
					<% } } %>
				</tbody>
			</table>
		</div>
	</div>

	<div class="mt-4">
		<a href="list" class="btn btn-secondary">메인으로 돌아가기</a>
	</div>
</div>

<%@ include file="footer.jsp"%>