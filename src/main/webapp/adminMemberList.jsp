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
List<MemberDTO> memberList = dao.getAllMembers();
%>

<style>
/* 관리자 페이지 전용 스타일 */
.admin-card {
	border-radius: 15px !important;
	overflow: hidden;
}

/* 모바일 테이블 스크롤 및 폰트 조절 */
@media ( max-width : 991px) {
	.table-responsive-custom {
		overflow-x: auto;
		-webkit-overflow-scrolling: touch;
	}
	.table {
		min-width: 800px; /* 아이디부터 관리까지 다 보이게 최소 폭 고정 */
		font-size: 14px;
	}
	.badge {
		font-size: 11px;
	}
}

/* 주소 열 너비 제한 (너무 길어지는 것 방지) */
.address-cell {
	max-width: 200px;
	overflow: hidden;
	text-overflow: ellipsis;
	white-space: nowrap;
}
</style>

<div class="container mt-5 mb-5">
	<div class="card shadow-sm border-0 admin-card">
		<div
			class="card-header bg-dark text-white py-3 d-flex justify-content-between align-items-center">
			<h4 class="mb-0 fw-bold">
				<i class="bi bi-people-fill me-2"></i>👥 회원 정보 관리
			</h4>
			<span class="badge bg-light text-dark">총 회원수: <%=memberList.size()%>명
			</span>
		</div>

		<div class="card-body p-0 table-responsive-custom">
			<table class="table table-hover align-middle mb-0">
				<thead class="table-light">
					<tr class="text-center">
						<th class="ps-3">아이디</th>
						<th>이름</th>
						<th>전화번호</th>
						<th>주소</th>
						<th>마일리지</th>
						<th>권한</th>
						<th>관리</th>
					</tr>
				</thead>
				<tbody>
					<%
					for (MemberDTO m : memberList) {
					%>
					<tr class="text-center">
						<td class="ps-3 text-start"><strong><%=m.getUserid()%></strong></td>
						<td><%=m.getName()%></td>
						<td><%=(m.getPhone() != null && !m.getPhone().isEmpty()) ? m.getPhone() : "-"%></td>
						<td class="text-start address-cell"><small><%=(m.getAddress() != null && !m.getAddress().isEmpty()) ? m.getAddress() : "미등록"%></small></td>
						<td class="text-primary fw-bold"><%=String.format("%,d", m.getMileage())%>원</td>
						<td><span
							class="badge <%=m.getRole().equals("admin") ? "bg-danger" : "bg-secondary"%> rounded-pill px-3">
								<%=m.getRole().toUpperCase()%>
						</span></td>
						<td>
							<button class="btn btn-sm btn-primary rounded-pill px-3"
								data-bs-toggle="modal"
								data-bs-target="#editModal<%=m.getUserid()%>">수정</button>
						</td>
					</tr>

					<div class="modal fade" id="editModal<%=m.getUserid()%>"
						tabindex="-1" aria-hidden="true">
						<div class="modal-dialog modal-dialog-centered">
							<div class="modal-content border-0 shadow-lg"
								style="border-radius: 20px;">
								<div class="modal-header bg-primary text-white border-0">
									<h5 class="modal-title fw-bold">
										회원 정보 수정 (<%=m.getUserid()%>)
									</h5>
									<button type="button" class="btn-close btn-close-white"
										data-bs-dismiss="modal"></button>
								</div>
								<form action="adminUpdateMember" method="post">
									<input type="hidden" name="userid" value="<%=m.getUserid()%>">
									<div class="modal-body p-4">
										<div class="mb-3">
											<label class="form-label fw-bold">이름</label> <input
												type="text" name="name" class="form-control border-2"
												value="<%=m.getName()%>" required>
										</div>
										<div class="mb-3">
											<label class="form-label fw-bold">전화번호</label> <input
												type="text" name="phone" class="form-control border-2"
												value="<%=(m.getPhone() != null) ? m.getPhone() : ""%>">
										</div>
										<div class="mb-3">
											<label class="form-label fw-bold">주소</label> <input
												type="text" name="address" class="form-control border-2"
												value="<%=(m.getAddress() != null) ? m.getAddress() : ""%>">
										</div>
										<div class="mb-3">
											<label class="form-label fw-bold">마일리지 (원)</label> <input
												type="number" name="mileage" class="form-control border-2"
												value="<%=m.getMileage()%>">
										</div>
										<div class="mb-3">
											<label class="form-label fw-bold text-danger">권한 설정</label> <select
												name="role" class="form-select border-2 fw-bold">
												<option value="user"
													<%="user".equals(m.getRole()) ? "selected" : ""%>>일반
													사용자 (USER)</option>
												<option value="admin"
													<%="admin".equals(m.getRole()) ? "selected" : ""%>>관리자
													(ADMIN)</option>
											</select>
										</div>
									</div>
									<div class="modal-footer bg-light border-0">
										<button type="button"
											class="btn btn-link text-muted text-decoration-none"
											data-bs-dismiss="modal">취소</button>
										<button type="submit"
											class="btn btn-primary px-4 fw-bold rounded-pill">변경사항
											저장</button>
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

<%@ include file="footer.jsp"%>