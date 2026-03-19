<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="model.ProductDTO"%>
<%
    ProductDTO product = (ProductDTO) request.getAttribute("product");
%>
<%@ include file="header.jsp"%>

<div class="container">
	<div class="card edit-card"
		style="max-width: 700px; margin: 50px auto; border-radius: 20px; box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1); border: none;">
		<div class="card-header"
			style="background-color: #0d6efd; color: white; text-align: center; padding: 20px; border-radius: 20px 20px 0 0;">
			<h3 class="mb-0">상품 정보 수정</h3>
		</div>
		<div class="card-body p-4">
			<form action="UpdateServlet" method="post"
				enctype="multipart/form-data">
				<%-- 수정 시 반드시 필요한 ID값 (hidden) --%>
				<input type="hidden" name="p_id" value="<%= product.getId() %>">

				<div class="row">
					<div class="col-md-5">
						<div class="img-section"
							style="background: #f1f1f1; border-radius: 15px; padding: 20px; text-align: center;">
							<p class="text-muted small">현재 상품 이미지</p>
							<img id="imagePreview" src="<%= product.getImgUrl() %>"
								style="max-width: 100%; border-radius: 10px;" alt="상품 이미지">
							<div class="mt-3">
								<label class="form-label fw-bold">이미지 변경</label> <input
									type="file" name="p_img_url" id="imgInput"
									class="form-control form-control-sm" accept="image/*">
							</div>
						</div>
					</div>

					<div class="col-md-7">
						<div class="mb-3">
							<label class="form-label fw-bold">상품명</label> <input type="text"
								name="p_name" class="form-control"
								value="<%= product.getName() %>" required>
						</div>

						<div class="mb-3">
							<label class="form-label fw-bold">카테고리</label> <select
								name="p_category" class="form-select">
								<option value="해산물"
									<%= product.getCategory().equals("해산물") ? "selected" : "" %>>해산물</option>
								<option value="육류"
									<%= product.getCategory().equals("육류") ? "selected" : "" %>>육류</option>
								<option value="선물류"
									<%= product.getCategory().equals("선물류") ? "selected" : "" %>>선물류</option>
							</select>
						</div>

						<div class="row">
							<div class="col-6 mb-3">
								<label class="form-label fw-bold">가격</label> <input
									type="number" name="p_price" class="form-control"
									value="<%= product.getPrice() %>" required>
							</div>
							<div class="col-6 mb-3">
								<label class="form-label fw-bold">재고</label> <input
									type="number" name="p_stock" class="form-control"
									value="<%= product.getStock() %>" required>
							</div>
						</div>

						<div class="mb-4">
							<label class="form-label fw-bold">참조 링크</label> <input type="url"
								name="p_link_url" class="form-control"
								value="<%= product.getLinkUrl() %>">
						</div>
					</div>
				</div>

				<div class="d-flex gap-2">
					<button type="button" class="btn btn-outline-secondary w-50"
						onclick="location.href='list'">목록으로</button>
					<button type="submit" class="btn btn-primary w-50">수정 완료</button>
				</div>
			</form>
		</div>
	</div>
</div>

<script>
    document.getElementById('imgInput').onchange = function (evt) {
        const [file] = this.files;
        if (file) {
            document.getElementById('imagePreview').src = URL.createObjectURL(file);
        }
    };
</script>
<%@ include file="footer.jsp"%>