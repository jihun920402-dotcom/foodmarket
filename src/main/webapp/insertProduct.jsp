<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="header.jsp"%>

<div class="container" style="max-width: 800px; margin: 40px auto;">
	<div
		style="background: white; padding: 40px; border-radius: 15px; border: 1px solid #e1e8ed; box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);">
		<h2 style="color: #0d6efd; margin-top: 0;">🌊 신규 상품 등록</h2>
		<hr style="border: 0; border-top: 1px solid #eee; margin: 20px 0;">

		<%-- action="insert"는 서블릿 매핑 주소입니다 --%>
		<form action="insert" method="post" enctype="multipart/form-data">
			<div style="margin-bottom: 15px;">
				<label
					style="display: block; margin-bottom: 5px; font-weight: bold;">카테고리</label>
				<select name="p_category" class="form-select" style="padding: 10px;">
					<option value="해산물">해산물</option>
					<option value="육류">육류</option>
					<option value="선물류">선물류</option>
				</select>
			</div>

			<div style="margin-bottom: 15px;">
				<label
					style="display: block; margin-bottom: 5px; font-weight: bold;">상품명</label>
				<input type="text" name="p_name" class="form-control" required
					style="padding: 10px;">
			</div>

			<div style="margin-bottom: 15px;">
				<label
					style="display: block; margin-bottom: 5px; font-weight: bold;">상품
					이미지 선택</label> 
				<%-- name값이 서블릿의 getPart()와 일치해야 합니다 --%>
				<input type="file" name="p_img_file" class="form-control"
					required style="padding: 10px;">
			</div>

			<div style="margin-bottom: 15px;">
				<label
					style="display: block; margin-bottom: 5px; font-weight: bold;">네이버
					쇼핑 링크</label> <input type="url" name="p_link_url" class="form-control"
					placeholder="https://..." style="padding: 10px;">
			</div>

			<div class="row">
				<div class="col-6 mb-3">
					<label
						style="display: block; margin-bottom: 5px; font-weight: bold;">가격
						(원)</label> <input type="number" name="p_price" class="form-control"
						required style="padding: 10px;">
				</div>
				<div class="col-6 mb-3">
					<label
						style="display: block; margin-bottom: 5px; font-weight: bold;">초기
						재고량</label> <input type="number" name="p_stock" value="10"
						class="form-control" style="padding: 10px;">
				</div>
			</div>

			<div class="mt-4 d-flex gap-2">
				<%-- 해결: type="submit"을 명시하여 클릭 시 데이터가 전송되도록 수정 --%>
				<button type="submit" class="btn btn-primary btn-lg fw-bold"
					style="flex: 2; padding: 15px;">상품 등록 완료</button>
				<a href="list" class="btn btn-outline-secondary btn-lg"
					style="flex: 1; padding: 15px; text-decoration: none; text-align: center;">취소</a>
			</div>
		</form>
	</div>
</div>

<%@ include file="footer.jsp"%>