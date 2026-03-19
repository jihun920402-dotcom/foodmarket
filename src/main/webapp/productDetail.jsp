<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="model.ProductDTO, model.ReviewDTO, model.MemberDTO, java.util.List"%>
<%@ include file="header.jsp"%>

<style>
.detail-img-box {
	width: 100%;
	max-width: 500px;
	margin: 0 auto;
}

.detail-img-box img {
	width: 100%;
	height: 500px;
	object-fit: cover;
	border-radius: 10px;
}

.detail-wrapper {
	display: flex;
	gap: 40px;
	background: white;
	padding: 40px;
	border-radius: 15px;
	box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
}

.review-section {
	background: white;
	margin-top: 30px;
	padding: 40px;
	border-radius: 15px;
	box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
}

.review-item {
	border-bottom: 1px solid #f1f5f9;
	padding: 20px 0;
}

.star-rating {
	color: #ffc107;
	font-size: 18px;
}
</style>

<script>
function editReview(r_id, content, rating, p_id) {
    const contentBox = document.getElementById("review_content_" + r_id);
    const starBox = document.getElementById("review_star_" + r_id);
    const btnBox = document.getElementById("review_btns_" + r_id);
    
    starBox.style.display = 'none';
    btnBox.style.display = 'none';
    
    let html = '<form action="UpdateReviewServlet" method="post" class="mt-2 bg-light p-3 rounded shadow-sm">';
    html += '<input type="hidden" name="r_id" value="' + r_id + '">';
    html += '<input type="hidden" name="p_id" value="' + p_id + '">';
    html += '<div class="mb-2"><label class="small fw-bold">별점 수정</label><br>';
    html += '<select name="rating" class="form-select d-inline-block w-auto">';
    for(let i=5; i>=1; i--) {
        html += '<option value="' + i + '"' + (rating == i ? ' selected' : '') + '>' + '⭐'.repeat(i) + '</option>';
    }
    html += '</select></div>';
    html += '<textarea name="content" class="form-control mb-2" rows="3" required>' + content + '</textarea>';
    html += '<div class="text-end">';
    html += '<button type="submit" class="btn btn-sm btn-primary px-3 me-1">수정완료</button>';
    html += '<button type="button" class="btn btn-sm btn-secondary px-3" onclick="location.reload()">취소</button>';
    html += '</div></form>';
    
    contentBox.innerHTML = html;
}

function addToCart(productId) {
    const qty = document.getElementById("p_count") ? document.getElementById("p_count").value : 1;
    fetch('addToCart', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'p_id=' + productId + '&count=' + qty
    })
    .then(response => response.json())
    .then(data => {
        if (data.status === 'success') {
            if (confirm('장바구니에 담겼습니다. 이동하시겠습니까?')) { location.href = 'cartList'; }
        } else if (data.status === 'login_required') {
            alert('로그인이 필요합니다.'); location.href = 'login.jsp';
        } else { alert('실패!'); }
    });
}
</script>

<%
ProductDTO p = (ProductDTO) request.getAttribute("product");
List<ReviewDTO> reviewList = (List<ReviewDTO>) request.getAttribute("reviewList");
loginUser = (MemberDTO) session.getAttribute("loginUser");

if (p != null) {
	String imgPath = (p.getImgUrl() != null && !p.getImgUrl().trim().isEmpty()) ? p.getImgUrl()
	: "https://via.placeholder.com/500?text=No+Image";
%>

<div class="container mt-5 mb-5">
	<div class="detail-wrapper">
		<div class="detail-img-box">
			<img src="<%=imgPath%>">
		</div>
		<div class="detail-info-box" style="flex: 1;">
			<p class="text-muted">
				[<%=p.getCategory()%>]
			</p>
			<h1 class="fw-bold"><%=p.getName()%></h1>
			<hr>
			<h2 class="text-primary fw-bold"><%=String.format("%,d", p.getPrice())%>원
			</h2>
			<div class="mt-4">
				<label class="fw-bold">수량:</label> <input type="number" id="p_count"
					value="1" min="1" max="<%=p.getStock()%>"
					class="form-control d-inline-block w-25 ms-2">
			</div>
			<div class="mt-4 d-flex gap-2">
				<a href="list" class="btn btn-outline-secondary flex-fill p-3">목록으로</a>
				<button onclick="addToCart(<%=p.getId()%>)"
					class="btn btn-primary flex-fill p-3">장바구니 담기</button>
			</div>
		</div>
	</div>

	<div class="review-section">
		<h3 class="fw-bold mb-4">
			💬 구매 후기 (<%=(reviewList != null) ? reviewList.size() : 0%>)
		</h3>

		<%
		if (loginUser != null) {
		%>
		<div class="card p-4 bg-light mb-5 border-0 shadow-sm">
			<form action="AddReviewServlet" method="post">
				<input type="hidden" name="p_id" value="<%=p.getId()%>">
				<div class="row mb-3">
					<div class="col-md-3">
						<select name="rating" class="form-select">
							<option value="5">⭐⭐⭐⭐⭐</option>
							<option value="4">⭐⭐⭐⭐</option>
							<option value="3">⭐⭐⭐</option>
							<option value="2">⭐⭐</option>
							<option value="1">⭐</option>
						</select>
					</div>
				</div>
				<textarea name="content" class="form-control mb-3" rows="3"
					placeholder="후기를 작성해주세요." required></textarea>
				<button type="submit" class="btn btn-dark px-4">리뷰 등록</button>
			</form>
		</div>
		<%
		}
		%>

		<div class="review-list">
			<%
			if (reviewList != null) {
				for (ReviewDTO r : reviewList) {
			%>
			<div class="review-item">
				<div class="d-flex justify-content-between">
					<div>
						<span class="fw-bold"><%=r.getUserid()%></span> <span
							class="star-rating ms-2" id="review_star_<%=r.getR_id()%>">
							<%
							for (int i = 0; i < r.getRating(); i++) {
							%>★<%
							}
							%>
						</span>
					</div>
					<%
					if (loginUser != null && loginUser.getUserid().equals(r.getUserid())) {
					%>
					<div id="review_btns_<%=r.getR_id()%>">
						<button
							class="btn btn-link btn-sm text-primary p-0 text-decoration-none me-2"
							onclick="editReview(<%=r.getR_id()%>, '<%=r.getContent().replace("'", "\\'")%>', <%=r.getRating()%>, <%=p.getId()%>)">수정</button>
						<a
							href="DeleteReviewServlet?r_id=<%=r.getR_id()%>&p_id=<%=p.getId()%>"
							class="btn btn-link btn-sm text-danger p-0 text-decoration-none"
							onclick="return confirm('삭제할까요?')">삭제</a>
					</div>
					<%
					}
					%>
				</div>
				<div id="review_content_<%=r.getR_id()%>">
					<p class="mt-2 mb-1"><%=r.getContent()%></p>
					<small class="text-muted"><%=r.getR_date()%></small>
				</div>
			</div>
			<% } } %>
		</div>
	</div>
</div>
<% } %>
<%@ include file="footer.jsp"%>