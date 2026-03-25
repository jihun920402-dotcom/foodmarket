<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="model.ProductDTO"%>
<%@ include file="header.jsp"%>

<%
// 1. 검색어 파라미터 안전하게 가져오기 (null 방지)
String searchKeyword = request.getParameter("searchKeyword");
if (searchKeyword == null)
	searchKeyword = "";
searchKeyword = searchKeyword.trim();

// 2. 서버에서 넘어온 상품 리스트 가져오기 (null 방지)
List<ProductDTO> allProducts = (List<ProductDTO>) request.getAttribute("products");
List<ProductDTO> displayList = new ArrayList<>();

if (allProducts != null) {
	if (searchKeyword.isEmpty()) {
		displayList = allProducts;
	} else {
		for (ProductDTO p : allProducts) {
	if (p.getName() != null && p.getName().contains(searchKeyword)) {
		displayList.add(p);
	}
		}
	}
}
%>

<style>
/* 전체 레이아웃 */
.shop-container {
	max-width: 1200px;
	margin: 0 auto;
	padding: 20px;
}

/* 메인 배너 (중앙 유지) */
.main-banner {
	background: #e0f2fe;
	padding: 40px;
	text-align: center;
	font-size: 24px;
	font-weight: bold;
	border-radius: 15px;
	margin-bottom: 20px;
	color: #0369a1;
}

/* 검색창 (오른쪽 끝 배치) */
.search-bar-container {
	display: flex;
	justify-content: flex-end;
	margin-bottom: 30px;
}

.search-form-box {
	display: flex;
	background: #ffffff;
	border: 1px solid #cbd5e1;
	border-radius: 8px;
	padding: 4px;
	width: 320px; /* 너비를 살짝 키웠습니다 */
}

.search-input-field {
	border: none !important;
	outline: none !important;
	width: 100%;
	padding-left: 10px;
	font-size: 14px;
}

/* [수정] 검색 버튼 - 글자가 가로로 눕도록 설정 */
.search-submit-btn {
	background: #334155;
	color: white;
	border: none;
	border-radius: 6px;
	padding: 8px 20px; /* 좌우 여백을 늘려 글자 공간 확보 */
	font-size: 14px;
	cursor: pointer;
	white-space: nowrap; /* 글자가 절대 줄바꿈 되지 않게 고정 */
	min-width: 70px; /* 최소 너비 지정 */
}

/* 상품 그리드 및 기타 스타일 */
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
}

.delete-btn {
	color: #ef4444;
	border-left: 1px solid #f1f5f9;
}

@media ( max-width : 768px) {
	.product-grid {
		grid-template-columns: 1fr 1fr;
		gap: 15px;
	}
	.card-img-box {
		height: 160px;
	}
	.search-bar-container {
		justify-content: center;
	}
	.search-form-box {
		width: 100%;
	}
}
</style>

<div class="shop-container">
	<div class="main-banner">🌊 FRESH MARKET : 산지의 싱싱함을 그대로</div>

	<div class="search-bar-container">
		<form action="list" method="get" class="search-form-box">
			<input type="text" name="searchKeyword" class="search-input-field"
				placeholder="상품명을 입력하세요" value="<%=searchKeyword%>">
			<button type="submit" class="search-submit-btn">검색</button>
		</form>
	</div>

	<div class="content-header">
		<h2>
			<%=(!searchKeyword.isEmpty()) ? "'" + searchKeyword + "' 검색 결과" : "인기 상품 추천"%>
		</h2>
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
		if (displayList != null && !displayList.isEmpty()) {
			for (ProductDTO p : displayList) {
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
						[<%=(p.getCategory() != null) ? p.getCategory() : "기타"%>]
					</div>
					<div class="card-title text-dark"><%=(p.getName() != null) ? p.getName() : "이름 없음"%></div>

					<div class="card-review">
						<%
						if (p.getReviewCount() > 0) {
						%>
						<span class="star-filled"> <%
 for (int i = 1; i <= 5; i++) {
 %>
							<%=(i <= p.getAvgRating()) ? "★" : "☆"%> <%
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
			style="grid-column: span 4; text-align: center; padding: 100px; color: #94a3b8;">
			상품 정보가 없거나 검색 결과가 없습니다.</div>
		<% } %>
	</div>
</div>

<%@ include file="footer.jsp"%>