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
/* 1. 전역 설정 및 가로 스크롤 방지 */
html, body {
	width: 100%;
	overflow-x: hidden;
	margin: 0;
	padding: 0;
	-webkit-text-size-adjust: none; /* 아이폰 가로 전환 시 폰트 커짐 방지 */
}

/* 2. 메인 컨테이너 */
.shop-container {
	width: 95%;
	max-width: 1200px;
	margin: 0 auto;
	padding: 10px 0 50px 0; /* 하단 여백 추가 */
	box-sizing: border-box;
}

/* 3. 메인 배너 (반응형 폰트 적용) */
.main-banner {
	background: #f0f9ff;
	padding: 25px 15px;
	text-align: center;
	font-size: clamp(1.1rem, 4vw, 1.5rem); /* 화면 크기에 따라 폰트 유연하게 조절 */
	font-weight: 800;
	border-radius: 15px;
	margin-bottom: 20px;
	color: #0284c7;
	word-break: keep-all;
	line-height: 1.4;
	border: 1px solid #e0f2fe;
}

/* 4. 검색 영역 (중앙 정렬 최적화) */
.search-bar-container {
	display: flex;
	justify-content: center;
	margin-bottom: 25px;
}

.search-form-box {
	display: flex;
	background: #ffffff;
	border: 2px solid #e2e8f0; /* 테두리 조금 더 선명하게 */
	border-radius: 10px;
	padding: 4px;
	width: 100%;
	max-width: 400px;
	transition: border-color 0.2s;
}

.search-form-box:focus-within {
	border-color: #004d99;
}

.search-input-field {
	border: none !important;
	outline: none !important;
	flex: 1;
	padding: 8px 12px;
	font-size: 15px;
}

.search-submit-btn {
	background: #004d99;
	color: white;
	border: none;
	border-radius: 7px;
	padding: 8px 18px;
	font-size: 14px;
	font-weight: bold;
	cursor: pointer;
	white-space: nowrap;
}

/* 5. 상품 그리드 (PC 4열 -> 태블릿 3열 -> 모바일 2열) */
.product-grid {
	display: grid;
	grid-template-columns: repeat(4, 1fr);
	gap: 20px;
}

@media ( max-width : 1100px) {
	.product-grid {
		grid-template-columns: repeat(3, 1fr);
	}
}

.product-card {
	background: #fff;
	border-radius: 15px;
	overflow: hidden;
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.06);
	border: 1px solid #f1f5f9;
	display: flex;
	flex-direction: column;
	transition: all 0.3s ease;
}

.product-card:hover {
	transform: translateY(-7px);
	box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
}

.card-img-box {
	width: 100%;
	aspect-ratio: 1/1; /* 정사각형 비율 고정 */
	overflow: hidden;
	background: #f8fafc;
	border-bottom: 1px solid #f1f5f9;
}

.card-img {
	width: 100%;
	height: 100%;
	object-fit: cover;
	transition: transform 0.5s;
}

.product-card:hover .card-img {
	transform: scale(1.08);
}

.card-body {
	padding: 15px;
	flex-grow: 1;
	display: flex;
	flex-direction: column;
	justify-content: space-between;
}

.card-title {
	font-size: 15px;
	font-weight: 600;
	margin-bottom: 8px;
	color: #334155;
	line-height: 1.4;
	/* 글자 깨짐 방지 핵심 코드 (2줄 제한) */
	display: -webkit-box;
	-webkit-line-clamp: 2;
	-webkit-box-orient: vertical;
	overflow: hidden;
	height: 2.8em;
}

.card-price {
	font-size: 17px;
	font-weight: 800;
	color: #0f172a;
	display: flex;
	align-items: center;
	justify-content: space-between;
}

/* 6. 플로팅 버튼 (디자인 개선) */
.floating-back, .floating-top {
	position: fixed;
	bottom: 25px;
	width: 48px;
	height: 48px;
	border-radius: 50%;
	display: flex;
	align-items: center;
	justify-content: center;
	box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
	z-index: 1000;
	cursor: pointer;
	transition: 0.3s;
	text-decoration: none;
}

.floating-back {
	left: 20px;
	background: white;
	border: 1px solid #e2e8f0;
	color: #64748b;
	font-size: 18px;
}

.floating-top {
	right: 20px;
	background: #004d99;
	color: white;
	border: none;
	font-size: 11px;
	font-weight: 900;
	opacity: 0;
	visibility: hidden;
}

.floating-top.show {
	opacity: 1;
	visibility: visible;
}

/* 7. 모바일 전용 미디어 쿼리 (핵심 최적화) */
@media ( max-width : 768px) {
	.shop-container {
		width: 96%;
	}

	/* 모바일에서 무조건 한 줄에 2개씩 */
	.product-grid {
		grid-template-columns: repeat(2, 1fr);
		gap: 12px;
	}
	.card-body {
		padding: 10px;
	}

	/* 모바일 글자 크기 미세 조정하여 깨짐 방지 */
	.card-title {
		font-size: 13px;
		height: 2.8em;
	}
	.card-price {
		font-size: 15px;
	}
	.floating-back, .floating-top {
		width: 42px;
		height: 42px;
		bottom: 20px;
	}
	.floating-back {
		left: 15px;
	}
	.floating-top {
		right: 15px;
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