<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="model.ProductDTO, model.ReviewDTO, model.MemberDTO, java.util.List"%>
<%@ include file="header.jsp"%>

<style>
/* --- 기본 레이아웃 --- */
.shop-container {
	max-width: 1100px;
	margin: 50px auto;
	padding: 0 20px;
}

.detail-wrapper {
	display: flex;
	gap: 50px;
	background: white;
	padding: 50px;
	border-radius: 20px;
	box-shadow: 0 10px 30px rgba(0, 0, 0, 0.05);
	align-items: center;
}

.detail-img-box {
	flex: 1;
	max-width: 450px;
}

.detail-img-box img {
	width: 100%;
	height: 450px;
	object-fit: cover;
	border-radius: 15px;
}

.detail-info-box {
	flex: 1.2;
}

.category-tag {
	color: #3b82f6;
	font-weight: 700;
	font-size: 14px;
	margin-bottom: 10px;
}

.product-name {
	font-size: 32px;
	font-weight: 800;
	color: #1e293b;
	margin-bottom: 15px;
}

.product-price {
	font-size: 28px;
	font-weight: 800;
	color: #0369a1;
}

/* --- 수량 및 버튼 (3:7 비율) --- */
.qty-wrapper {
	background: #f8fafc;
	padding: 20px;
	border-radius: 12px;
	margin: 30px 0;
}

.qty-input {
	width: 80px !important;
	text-align: center;
	font-weight: bold;
}

.btn-group-custom {
	display: flex;
	gap: 12px;
}

.btn-list {
	flex: 3;
	height: 55px;
	border-radius: 10px;
	font-weight: 600;
	border: 1px solid #e2e8f0;
	color: #64748b;
	text-decoration: none;
	display: flex;
	align-items: center;
	justify-content: center;
}

.btn-cart {
	flex: 7;
	height: 55px;
	border-radius: 10px;
	font-weight: bold;
	font-size: 18px;
	background: #3b82f6;
	border: none;
	color: white;
	box-shadow: 0 4px 12px rgba(59, 130, 246, 0.3);
}

/* --- 리뷰 섹션 스타일 --- */
.review-section {
	background: white;
	margin-top: 40px;
	padding: 40px;
	border-radius: 20px;
	box-shadow: 0 10px 30px rgba(0, 0, 0, 0.05);
}

.review-write-card {
	background: #f8fafc;
	border: none;
	border-radius: 15px;
	padding: 25px;
	margin-bottom: 40px;
}

.review-item {
	border-bottom: 1px solid #f1f5f9;
	padding: 25px 0;
}

.review-item:last-child {
	border-bottom: none;
}

.star-rating {
	color: #facc15;
	font-size: 16px;
}

.review-user {
	font-weight: 700;
	color: #334155;
}

.review-date {
	font-size: 12px;
	color: #94a3b8;
	margin-left: 10px;
}

.review-content {
	color: #475569;
	line-height: 1.6;
	margin-top: 10px;
}
</style>

<%
ProductDTO p = (ProductDTO) request.getAttribute("product");
List<ReviewDTO> reviewList = (List<ReviewDTO>) request.getAttribute("reviewList");
// 중복 선언 방지를 위해 세션에서 직접 확인
MemberDTO currentUser = (MemberDTO) session.getAttribute("loginUser");

if (p != null) {
    String imgPath = (p.getImgUrl() != null && !p.getImgUrl().trim().isEmpty()) ? p.getImgUrl() 
    : "https://via.placeholder.com/500?text=No+Image";
%>

<div class="shop-container">
	<div class="detail-wrapper">
		<div class="detail-img-box">
			<img src="<%=imgPath%>"
				onerror="this.src='https://via.placeholder.com/500?text=No+Image'">
		</div>
		<div class="detail-info-box">
			<div class="category-tag">
				[<%=p.getCategory()%>]
			</div>
			<h1 class="product-name"><%=p.getName()%></h1>
			<div class="product-price"><%=String.format("%,d", p.getPrice())%>원
			</div>

			<div class="qty-wrapper">
				<div class="d-flex align-items-center justify-content-between">
					<span class="fw-bold text-secondary">구매 수량</span> <input
						type="number" id="p_count" value="1" min="1"
						max="<%=p.getStock()%>" class="form-control qty-input">
				</div>
			</div>

			<div class="btn-group-custom">
				<a href="list" class="btn-list">목록</a>
				<button onclick="addToCart(<%=p.getId()%>)" class="btn-cart">
					<i class="bi bi-cart-plus me-2"></i>장바구니 담기
				</button>
			</div>
		</div>
	</div>

	<div class="review-section">
		<h3 class="fw-bold mb-4">
			💬 구매 후기 <span class="text-primary"><%=(reviewList != null) ? reviewList.size() : 0%></span>
		</h3>

		<% if (currentUser != null) { %>
		<div class="review-write-card">
			<form action="AddReviewServlet" method="post">
				<input type="hidden" name="p_id" value="<%=p.getId()%>">
				<div class="d-flex align-items-center mb-3">
					<span class="fw-bold me-3">만족도 별점</span> <select name="rating"
						class="form-select w-auto">
						<option value="5">⭐⭐⭐⭐⭐ (최고)</option>
						<option value="4">⭐⭐⭐⭐ (좋아요)</option>
						<option value="3">⭐⭐⭐ (보통)</option>
						<option value="2">⭐⭐ (그저그래요)</option>
						<option value="1">⭐ (별로예요)</option>
					</select>
				</div>
				<textarea name="content"
					class="form-control border-0 shadow-sm mb-3" rows="3"
					placeholder="진솔한 구매 후기를 남겨주세요." required style="resize: none;"></textarea>
				<div class="text-end">
					<button type="submit" class="btn btn-dark px-4 py-2 fw-bold">리뷰
						등록하기</button>
				</div>
			</form>
		</div>
		<% } else { %>
		<div class="alert alert-light text-center py-4 border-dashed mb-5">
			리뷰 작성을 위해 <a href="login.jsp"
				class="fw-bold text-primary text-decoration-none">로그인</a>이 필요합니다.
		</div>
		<% } %>

		<div class="review-list">
			<% if (reviewList != null && !reviewList.isEmpty()) { 
                for (ReviewDTO r : reviewList) { %>
			<div class="review-item" id="review_row_<%=r.getR_id()%>">
				<div class="d-flex justify-content-between align-items-start">
					<div>
						<span class="review-user"><%=r.getUserid()%></span> <span
							class="review-date"><%=r.getR_date()%></span>
						<div class="star-rating mt-1" id="review_star_<%=r.getR_id()%>">
							<% for(int i=0; i<r.getRating(); i++) { %>★<% } %>
							<% for(int i=r.getRating(); i<5; i++) { %>☆<% } %>
						</div>
					</div>
					<% if (currentUser != null && currentUser.getUserid().equals(r.getUserid())) { %>
					<div class="btn-group" id="review_btns_<%=r.getR_id()%>">
						<button class="btn btn-sm btn-outline-primary border-0"
							onclick="editReview(<%=r.getR_id()%>, '<%=r.getContent().replace("'", "\\'")%>', <%=r.getRating()%>, <%=p.getId()%>)">수정</button>
						<a
							href="DeleteReviewServlet?r_id=<%=r.getR_id()%>&p_id=<%=p.getId()%>"
							class="btn btn-sm btn-outline-danger border-0"
							onclick="return confirm('정말 삭제하시겠습니까?')">삭제</a>
					</div>
					<% } %>
				</div>
				<div id="review_content_<%=r.getR_id()%>" class="review-content">
					<%=r.getContent().replace("\n", "<br>")%>
				</div>
			</div>
			<% } } else { %>
			<div class="text-center py-5 text-muted">아직 작성된 리뷰가 없습니다. 첫 후기를
				남겨보세요!</div>
			<% } %>
		</div>
	</div>
</div>

<% } %>

<script>
// 1. 장바구니 담기
function addToCart(productId) {
    const qty = document.getElementById("p_count").value;
    fetch('addToCart', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'p_id=' + productId + '&count=' + qty
    })
    .then(response => response.json())
    .then(data => {
        if (data.status === 'success') {
            if (confirm('장바구니에 상품을 담았습니다. 장바구니로 이동하시겠습니까?')) { location.href = 'cartList'; }
        } else if (data.status === 'login_required') {
            alert('로그인이 필요한 기능입니다.'); location.href = 'login.jsp';
        } else { alert('처리에 실패했습니다.'); }
    });
}

// 2. 리뷰 수정 모드 전환
function editReview(r_id, content, rating, p_id) {
    const contentBox = document.getElementById("review_content_" + r_id);
    const starBox = document.getElementById("review_star_" + r_id);
    const btnBox = document.getElementById("review_btns_" + r_id);
    
    starBox.style.display = 'none';
    btnBox.style.display = 'none';
    
    let html = '<form action="UpdateReviewServlet" method="post" class="mt-3 bg-white p-3 border rounded shadow-sm">';
    html += '<input type="hidden" name="r_id" value="' + r_id + '">';
    html += '<input type="hidden" name="p_id" value="' + p_id + '">';
    html += '<div class="mb-2 small fw-bold text-primary">별점 수정</div>';
    html += '<select name="rating" class="form-select form-select-sm w-auto mb-2">';
    for(let i=5; i>=1; i--) {
        html += '<option value="' + i + '"' + (rating == i ? ' selected' : '') + '>' + '⭐'.repeat(i) + '</option>';
    }
    html += '</select>';
    html += '<textarea name="content" class="form-control mb-2" rows="3" required>' + content + '</textarea>';
    html += '<div class="text-end">';
    html += '<button type="submit" class="btn btn-sm btn-primary px-3 me-1">수정완료</button>';
    html += '<button type="button" class="btn btn-sm btn-light border px-3" onclick="location.reload()">취소</button>';
    html += '</div></form>';
    
    contentBox.innerHTML = html;
}
</script>

<%@ include file="footer.jsp"%>