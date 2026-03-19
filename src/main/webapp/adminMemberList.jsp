<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="model.MemberDAO, model.MemberDTO, java.util.List"%>
<%@ include file="header.jsp"%>
<%
    // 관리자 체크
    if (!"admin".equals(userRole)) {
        out.println("<script>alert('권한이 없습니다.'); location.href='list';</script>");
        return;
    }

    MemberDAO dao = new MemberDAO();
    List<MemberDTO> memberList = dao.getAllMembers(); // 모든 회원 가져오는 메서드
%>

<div class="container mt-5">
	<div class="card shadow-sm border-0">
		<div class="card-header bg-dark text-white py-3">
			<h4 class="mb-0 fw-bold">👥 회원 정보 관리</h4>
		</div>
		<div class="card-body p-0">
			<table class="table table-hover align-middle mb-0">
				<thead class="table-light">
					<tr>
						<th class="ps-3">아이디</th>
						<th>이름</th>
						<th>전화번호</th>
						<th>주소</th>
						<th>마일리지</th>
						<th>권한</th>
						<th class="text-center">관리</th>
					</tr>
				</thead>
				<tbody>
					<% for (MemberDTO m : memberList) { %>
					<tr>
						<td class="ps-3"><strong><%= m.getUserid() %></strong></td>
						<td><%= m.getName() %></td>
						<td><%= (m.getPhone() != null) ? m.getPhone() : "-" %></td>
						<td><small><%= (m.getAddress() != null) ? m.getAddress() : "-" %></small></td>
						<td class="text-primary fw-bold"><%= String.format("%,d", m.getMileage()) %>원</td>
						<td><span
							class="badge <%= m.getRole().equals("admin") ? "bg-danger" : "bg-secondary" %>">
								<%= m.getRole().toUpperCase() %></span></td>
						<td class="text-center">
							<button class="btn btn-sm btn-outline-primary"
								data-bs-toggle="modal"
								data-bs-target="#editModal<%= m.getUserid() %>">수정</button>
						</td>
					</tr>

					<div class="modal fade" id="editModal<%= m.getUserid() %>"
						tabindex="-1" aria-hidden="true">
						<div class="modal-dialog">
							<div class="modal-content">
								<div class="modal-header">
									<h5 class="modal-title">
										회원 정보 수정 (<%= m.getUserid() %>)
									</h5>
									<button type="button" class="btn-close"
										data-bs-target="#editModal<%= m.getUserid() %>"
										data-bs-dismiss="modal"></button>
								</div>
								<form action="adminUpdateMember" method="post">
									<input type="hidden" name="userid" value="<%= m.getUserid() %>">
									<div class="modal-body">
										<div class="mb-3">
											<label class="form-label">이름</label> <input type="text"
												name="name" class="form-control" value="<%= m.getName() %>"
												required>
										</div>
										<div class="mb-3">
											<label class="form-label">전화번호</label> <input type="text"
												name="phone" class="form-control"
												value="<%= m.getPhone() %>">
										</div>
										<div class="mb-3">
											<label class="form-label">주소</label> <input type="text"
												name="address" class="form-control"
												value="<%= m.getAddress() %>">
										</div>
										<div class="mb-3">
											<label class="form-label">마일리지</label> <input type="number"
												name="mileage" class="form-control"
												value="<%= m.getMileage() %>">
										</div>
										<div class="mb-3">
											<label class="form-label">권한 설정</label> <select name="role"
												class="form-select">
												<option value="user"
													<%= "user".equals(m.getRole()) ? "selected" : "" %>>USER</option>
												<option value="admin"
													<%= "admin".equals(m.getRole()) ? "selected" : "" %>>ADMIN</option>
											</select>
										</div>
									</div>
									<div class="modal-footer">
										<button type="button" class="btn btn-secondary"
											data-bs-dismiss="modal">취소</button>
										<button type="submit" class="btn btn-primary">변경사항 저장</button>
									</div>
								</form>
							</div>
						</div>
					</div>
					<% } %>
				</tbody>
			</table>
		</div>
	</div>
</div>

<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<%@ include file="footer.jsp"%>