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
/* 1. 전역 설정 및 쏠림 방지 (반드시 최상단) */
html, body {
	width: 100%;
	overflow-x: hidden; /* 가로 스크롤 발생 원천 차단 */
	margin: 0;
	padding: 0;
}

/* 2. 메인 컨테이너 */
.shop-container {
	width: 95%;
	max-width: 1200px;
	margin: 0 auto;
	padding: 20px 0;
	box-sizing: border-box;
}

/* 3. 메인 배너 */
.main-banner {
	background: #e0f2fe;
	padding: 30px 20px;
	text-align: center;
	font-size: 1.5rem;
	font-weight: bold;
	border-radius: 15px;
	margin-bottom: 25px;
	color: #0369a1;
	word-break: keep-all; /* 한글 단어 단위 줄바꿈 */
}

/* 4. 검색 영역 */
.search-bar-container {
	display: flex;
	justify-content: flex-end; /* 기본은 오른쪽 정렬 */
	margin-bottom: 30px;
}

.search-form-box {
	display: flex;
	background: #ffffff;
	border: 1px solid #cbd5e1;
	border-radius: 8px;
	padding: 4px;
	width: 100%;
	max-width: 320px;
}

.search-input-field {
	border: none !important;
	outline: none !important;
	flex: 1;
	padding-left: 10px;
	font-size: 14px;
}

.search-submit-btn {
	background: #334155;
	color: white;
	border: none;
	border-radius: 6px;
	padding: 8px 20px;
	font-size: 14px;
	cursor: pointer;
	white-space: nowrap; /* 글자 세로로 안 서게 고정 */
	min-width: 70px;
}

/* 5. 상품 그리드 (반응형의 핵심) */
.product-grid {
	display: grid;
	/* PC: 최소 250px 너비로 자동 채움 */
	grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
	gap: 25px;
}

.product-card {
	background: #fff;
	border-radius: 12px;
	overflow: hidden;
	box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05);
	border: 1px solid #eee;
	display: flex;
	flex-direction: column;
	transition: transform 0.3s ease;
}

.product-card:hover {
	transform: translateY(-5px);
}

.card-img-box {
	width: 100%;
	aspect-ratio: 1/1; /* 정사각형 비율 유지 */
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

.card-title {
	font-size: 16px;
	font-weight: 600;
	margin-bottom: 8px;
	height: 44px; /* 두 줄까지 표시 */
	overflow: hidden;
	color: #334155;
}

.card-price {
	font-size: 18px;
	font-weight: 800;
	color: #1e293b;
}

/* 6. 플로팅 버튼 (뒤로가기 & TOP) */
.floating-back, .floating-top {
	position: fixed;
	bottom: 25px;
	width: 50px;
	height: 50px;
	border-radius: 50%;
	display: flex;
	align-items: center;
	justify-content: center;
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
	z-index: 1000;
	cursor: pointer;
	transition: 0.3s;
}

.floating-back {
	left: 20px;
	background: rgba(255, 255, 255, 0.95);
	border: 1px solid #cbd5e1;
	color: #334155;
	font-size: 20px;
	text-decoration: none;
}

.floating-top {
	right: 20px;
	background: #334155;
	color: white;
	border: none;
	font-size: 12px;
	font-weight: bold;
	opacity: 0;
	visibility: hidden;
}

.floating-top.show {
	opacity: 1;
	visibility: visible;
}

/* 7. 모바일 전용 미디어 쿼리 (768px 이하) */
@media ( max-width : 768px) {
	.main-banner {
		font-size: 1.1rem;
		padding: 20px 10px;
	}

	/* 모바일은 검색창을 중앙으로 */
	.search-bar-container {
		justify-content: center;
		margin-bottom: 20px;
	}
	.search-form-box {
		max-width: 100%;
	}

	/* 모바일은 무조건 한 줄에 2개씩 정렬 */
	.product-grid {
		grid-template-columns: 1fr 1fr;
		gap: 12px;
	}
	.card-body {
		padding: 10px;
	}
	.card-title {
		font-size: 14px;
		height: 38px;
	}
	.card-price {
		font-size: 15px;
	}

	/* 모바일 플로팅 버튼 위치 미세 조정 */
	.floating-back {
		left: 15px;
		bottom: 20px;
	}
	.floating-top {
		right: 15px;
		bottom: 20px;
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