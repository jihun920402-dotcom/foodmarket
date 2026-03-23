<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="model.ProductDTO"%>
<%@ include file="header.jsp"%>

<style>
/* 기존 스타일 유지 */
.shop-container {
	max-width: 1200px;
	margin: 0 auto;
	padding: 20px;
}

.main-banner {
	background: #e0f2fe;
	padding: 40px;
	text-align: center;
	font-size: 24px;
	font-weight: bold;
	border-radius: 15px;
	margin-bottom: 30px;
	color: #0369a1;
}

.content-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 20px;
}

.product-grid {
	display: grid;
	grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
	gap: 30px;
}

.product-card {
	background: #fff;
	border-radius: 12px;
	overflow: hidden;
	box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05);
	transition: 0.3s;
	border: 1px solid #eee;
	display: flex;
	flex-direction: column;
}

.product-card:hover {
	transform: translateY(-5px);
	box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
}

.card-img-box {
	width: 100%;
	height: 250px;
	overflow: hidden;
	background: #f8fafc;
}

.card-img {
	width: 100%;
	height: 100%;
	object-fit: cover;
}

.card-body {
	padding: 15px;
	flex-grow: 1;
}

.card-category {
	font-size: 12px;
	color: #3b82f6;
	font-weight: bold;
	margin-bottom: 5px;
}

.card-title {
	font-size: 16px;
	font-weight: 600;
	color: #334155;
	margin-bottom: 5px;
	height: 45px;
	overflow: hidden;
}

.card-price {
	font-size: 18px;
	font-weight: 800;
	color: #1e293b;
}

.btn-add-product {
	background: #3b82f6;
	color: white;
	padding: 10px 20px;
	border-radius: 8px;
	text-decoration: none;
	font-weight: bold;
}

.admin-menu {
	display: flex;
	border-top: 1px solid #f1f5f9;
	background: #fafafa;
}

.admin-btn {
	flex: 1;
	text-align: center;
	padding: 10px;
	font-size: 13px;
	text-decoration: none;
	color: #64748b;
	font-weight: 500;
}

.admin-btn:hover {
	background: #f1f5f9;
}

.delete-btn {
	color: #ef4444;
	border-left: 1px solid #f1f5f9;
}

/* [추가된 별점 스타일] */
.card-review {
	display: flex;
	align-items: center;
	gap: 4px;
	margin-bottom: 8px;
	font-size: 13px;
}

.star-filled {
	color: #facc15;
}

.star-empty {
	color: #e2e8f0;
}

.avg-score {
	font-weight: bold;
	color: #475569;
	margin-left: 2px;
}

.review-count {
	color: #94a3b8;
	font-size: 12px;
}
</style>

<div class="shop-container">
	<div class="main-banner">🌊 FRESH MARKET : 산지의 싱싱함을 그대로</div>

	<div class="content-header">
		<h2>인기 상품 추천</h2>
		<%
		if ("admin".equals(userRole)) {
		%>
		<a href="insertProduct.jsp" class="btn-add-product">+ 상품 등록</a>
		<%
		}
		%>
	</div>

	<div class="product-grid">
		<%
		List<ProductDTO> list = (List<ProductDTO>) request.getAttribute("products");
		if (list != null && !list.isEmpty()) {
			for (ProductDTO p : list) {
				String imgPath = (p.getImgUrl() != null && !p.getImgUrl().isEmpty()) ? p.getImgUrl()
				: "https://via.placeholder.com/300?text=No+Image";
		%>
		<div class="product-card">
			<a href="detail?id=<%=p.getId()%>" style="text-decoration: none;">
				<div class="card-img-box">
					<img src="<%=imgPath%>" class="card-img"
						onerror="this.src='https://via.placeholder.com/300?text=No+Image'">
				</div>
				<div class="card-body">
					<div class="card-category">
						[<%=p.getCategory()%>]
					</div>
					<div class="card-title text-dark"><%=p.getName()%></div>

					<%-- [별점 및 리뷰 표시 추가] --%>
					<div class="card-review">
						<%
						if (p.getReviewCount() > 0) {
						%>
						<span class="star-filled"> <%
 for (int i = 1; i <= 5; i++) {
 %> <%=(i <= p.getAvgRating()) ? "★" : "☆"%> <%
							}
							%>
						</span> <span class="avg-score"><%=p.getAvgRating()%></span> <span
							class="review-count">(<%=p.getReviewCount()%>)
						</span>
						<%
						} else {
						%>
						<span class="review-count">리뷰 없음</span>
						<%
						}
						%>
					</div>

					<div class="card-price"><%=String.format("%,d", p.getPrice())%>원
					</div>
				</div>
			</a>

			<%
			if ("admin".equals(userRole)) {
			%>
			<div class="admin-menu">
				<a href="edit?id=<%=p.getId()%>" class="admin-btn">수정</a> <a
					href="delete?id=<%=p.getId()%>" class="admin-btn delete-btn"
					onclick="return confirm('정말 삭제하시겠습니까?');">삭제</a>
			</div>
			<%
			}
			%>
		</div>
		<%
                }
            } else {
        %>
		<div
			style="grid-column: span 4; text-align: center; padding: 100px; color: #94a3b8;">등록된
			상품이 없습니다.</div>
		<% } %>
	</div>
</div>
<%@ include file="footer.jsp"%>