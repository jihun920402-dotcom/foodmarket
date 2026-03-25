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
/* 1. 기본 레이아웃 최적화 */
.shop-container {
	width: 95%; /* 고정 폭 대신 퍼센트 사용 */
	max-width: 1200px; /* PC에서만 최대 폭 제한 */
	margin: 0 auto;
	padding: 10px 0; /* 모바일 여백 축소 */
}

/* 2. 메인 배너 반응형 */
.main-banner {
	background: #e0f2fe;
	padding: 20px; /* 패딩 축소 */
	text-align: center;
	font-size: 1.2rem; /* 글자 크기를 유동적으로 */
	font-weight: bold;
	border-radius: 10px;
	margin-bottom: 15px;
	color: #0369a1;
	word-break: keep-all; /* 한글 줄바꿈 예쁘게 */
}

/* 3. 검색창 모바일 최적화 */
.search-bar-container {
	display: flex;
	justify-content: flex-end;
	margin-bottom: 20px;
}

.search-form-box {
	display: flex;
	background: #ffffff;
	border: 1px solid #cbd5e1;
	border-radius: 8px;
	padding: 4px;
	width: 100%; /* 모바일에서 가로 꽉 차게 */
	max-width: 320px; /* PC에선 기존 크기 유지 */
}

.search-input-field {
	border: none !important;
	outline: none !important;
	flex: 1;
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

/* 4. 상품 그리드 (핵심 수정부) */
.product-grid {
	display: grid;
	grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
	gap: 20px;
}

/* 5. 상품 카드 내부 비율 고정 */
.product-card {
	background: #fff;
	border-radius: 12px;
	overflow: hidden;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
	border: 1px solid #eee;
	display: flex;
	flex-direction: column;
}

.product-card:hover {
	transform: translateY(-5px);
}

.card-img-box {
	width: 100%;
	aspect-ratio: 1/1; /* 가로세로 1:1 비율 강제 고정 */
	overflow: hidden;
	background: #f8fafc;
}

.card-img {
	width: 100%;
	height: 100%;
	object-fit: cover;
}

.card-body {
	padding: 12px;
}

.card-title {
	font-size: 15px;
	font-weight: 600;
	margin-bottom: 5px;
	height: 40px;
	overflow: hidden;
}

.card-price {
	font-size: 16px;
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

/* 1. 뒤로가기 버튼 (왼쪽 하단) */
.floating-back {
	position: fixed;
	bottom: 20px;
	left: 20px;
	width: 50px;
	height: 50px;
	background: rgba(255, 255, 255, 0.9);
	border: 1px solid #cbd5e1;
	border-radius: 50%;
	display: flex;
	align-items: center;
	justify-content: center;
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
	cursor: pointer;
	z-index: 999;
	text-decoration: none;
	color: #334155;
	font-size: 20px;
	font-weight: bold;
}

/* 2. TOP 버튼 (오른쪽 하단) */
.floating-top {
	position: fixed;
	bottom: 20px;
	right: 20px;
	width: 50px;
	height: 50px;
	background: #334155;
	color: white;
	border: none;
	border-radius: 50%;
	display: flex;
	align-items: center;
	justify-content: center;
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
	cursor: pointer;
	z-index: 999;
	font-size: 12px;
	font-weight: bold;
	opacity: 0; /* 처음엔 안보임 */
	transition: 0.3s;
	visibility: hidden;
}

.floating-top.show {
	opacity: 1;
	visibility: visible;
}
/* 6. [중요] 모바일 전용 미디어 쿼리 */
@media ( max-width : 768px) {
	.main-banner {
		font-size: 1rem;
		padding: 15px;
	}

	/* 모바일에서는 상품을 2줄로 배치 */
	.product-grid {
		grid-template-columns: 1fr 1fr;
		gap: 10px;
	}
	.card-body {
		padding: 8px;
	}
	.card-title {
		font-size: 13px;
		height: 36px;
	}
	.card-price {
		font-size: 14px;
	}
	.search-bar-container {
		justify-content: center;
	} /* 검색창 중앙 */
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
				String imgPath = (p.getImgUrl() != null && !p.getImgUrl().isEmpty())
				? p.getImgUrl()
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
			style="grid-column: span 4; text-align: center; padding: 100px; color: #94a3b8;">
			상품 정보가 없거나 검색 결과가 없습니다.</div>
		<%
		}
		%>
	</div>
</div>

<script>
	// 스크롤이 어느 정도 내려가면 TOP 버튼이 나타나게 설정
	window.onscroll = function() {
		var topBtn = document.getElementById("topBtn");
		if (document.body.scrollTop > 300
				|| document.documentElement.scrollTop > 300) {
			topBtn.classList.add("show");
		} else {
			topBtn.classList.remove("show");
		}
	};
</script>

<%@ include file="footer.jsp"%>