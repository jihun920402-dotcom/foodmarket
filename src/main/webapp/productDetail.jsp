<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="model.ProductDTO, model.ReviewDTO, model.MemberDTO, java.util.List"%>
<%@ include file="header.jsp"%>

<%
ProductDTO p = (ProductDTO) request.getAttribute("product");
List<ReviewDTO> reviewList = (List<ReviewDTO>) request.getAttribute("reviewList");
MemberDTO currentUser = (MemberDTO) session.getAttribute("loginUser");

if (p != null) {
    String imgPath = (p.getImgUrl() != null && !p.getImgUrl().trim().isEmpty()) ? p.getImgUrl()
        : request.getContextPath() + "/images/no-image.png";
%>

<main class="max-w-7xl mx-auto px-4 sm:px-6 py-10">

  <!-- 상품 상세 -->
  <div class="bg-[#18181c] border border-[rgba(255,255,255,0.07)] rounded-2xl overflow-hidden mb-8">
    <div class="flex flex-col md:flex-row gap-0">

      <!-- 이미지 -->
      <div class="md:w-2/5 bg-[#141418]">
        <div class="aspect-square md:aspect-auto md:h-full min-h-[280px] relative overflow-hidden">
          <img src="<%= imgPath %>"
               alt="<%= p.getName() %>"
               class="w-full h-full object-cover"
               onerror="this.src='<%= request.getContextPath() %>/images/no-image.png'; this.onerror=null;">
        </div>
      </div>

      <!-- 정보 -->
      <div class="md:w-3/5 p-5 sm:p-8 flex flex-col justify-between">
        <div>
          <p class="text-[10px] font-medium tracking-[0.15em] uppercase text-[#a8894e] mb-3"><%= p.getCategory() %></p>
          <h1 class="text-2xl md:text-3xl font-bold text-[#f0ede8] mb-4 leading-snug"><%= p.getName() %></h1>

          <div class="flex items-baseline gap-2 mb-8">
            <span class="text-3xl font-bold text-[#c8a96e]"><%= String.format("%,d", p.getPrice()) %></span>
            <span class="text-base text-[#8a8790]">원</span>
          </div>

          <!-- 수량 -->
          <div class="bg-[#141418] rounded-xl p-5 mb-6">
            <div class="flex items-center justify-between">
              <span class="text-sm font-medium text-[#8a8790]">구매 수량</span>
              <div class="flex items-center gap-3">
                <input type="number" id="p_count" value="1" min="1" max="<%= p.getStock() %>"
                       style="width: 80px; text-align: center; font-weight: bold; border: 1px solid rgba(200,169,110,0.3);">
                <span class="text-xs text-[#4a4850]">/ <%= p.getStock() %>개 남음</span>
              </div>
            </div>
          </div>
        </div>

        <!-- 버튼 -->
        <div class="flex gap-3 mt-4">
          <a href="list"
             class="shrink-0 px-5 py-3.5 rounded-xl border border-[rgba(255,255,255,0.07)] text-sm text-[#8a8790] hover:text-[#f0ede8] hover:border-[rgba(255,255,255,0.15)] transition-all text-center"
             style="text-decoration:none;">
            목록
          </a>
          <button onclick="addToCart(<%= p.getId() %>)"
                  class="flex-1 py-3.5 rounded-xl bg-[#c8a96e] text-[#0a0a0b] text-sm font-bold hover:bg-[#d4b87e] transition-colors"
                  style="border:none; cursor:pointer;">
            장바구니 담기
          </button>
        </div>
      </div>
    </div>
  </div>

  <!-- 리뷰 섹션 -->
  <div class="bg-[#18181c] border border-[rgba(255,255,255,0.07)] rounded-2xl p-8">
    <h2 class="text-lg font-bold text-[#f0ede8] mb-6">
      구매 후기
      <span class="text-[#c8a96e] ml-2"><%= (reviewList != null) ? reviewList.size() : 0 %></span>
    </h2>

    <!-- 리뷰 작성 -->
    <% if (currentUser != null) { %>
    <div class="bg-[#141418] border border-[rgba(255,255,255,0.07)] rounded-xl p-5 mb-8">
      <form action="AddReviewServlet" method="post">
        <input type="hidden" name="p_id" value="<%= p.getId() %>">
        <div class="flex items-center gap-4 mb-4 flex-wrap">
          <span class="text-sm font-medium text-[#8a8790]">만족도 별점</span>
          <select name="rating" style="width: auto; padding: 8px 14px;">
            <option value="5">★★★★★ (최고)</option>
            <option value="4">★★★★ (좋아요)</option>
            <option value="3">★★★ (보통)</option>
            <option value="2">★★ (그저그래요)</option>
            <option value="1">★ (별로예요)</option>
          </select>
        </div>
        <textarea name="content" rows="3" placeholder="진솔한 구매 후기를 남겨주세요." required
                  class="mb-4" style="width:100%; resize:none;"></textarea>
        <div class="flex justify-end">
          <button type="submit"
                  class="px-6 py-2.5 rounded-lg bg-[#c8a96e] text-[#0a0a0b] text-sm font-bold hover:bg-[#d4b87e] transition-colors"
                  style="width:auto; border:none;">
            리뷰 등록
          </button>
        </div>
      </form>
    </div>
    <% } else { %>
    <div class="bg-[#141418] border border-[rgba(255,255,255,0.07)] rounded-xl p-6 text-center mb-8">
      <p class="text-sm text-[#8a8790]">리뷰 작성을 위해 <a href="login.jsp" class="text-[#c8a96e] hover:text-[#d4b87e] font-medium">로그인</a>이 필요합니다.</p>
    </div>
    <% } %>

    <!-- 리뷰 목록 -->
    <div class="space-y-0">
      <% if (reviewList != null && !reviewList.isEmpty()) {
           for (ReviewDTO r : reviewList) { %>
      <div class="review-item border-b border-[rgba(255,255,255,0.07)] py-6 last:border-b-0" id="review_row_<%= r.getR_id() %>">
        <div class="flex justify-between items-start">
          <div>
            <span class="text-sm font-semibold text-[#f0ede8]"><%= r.getUserid() %></span>
            <span class="text-xs text-[#4a4850] ml-3"><%= r.getR_date() %></span>
            <div class="text-[#c8a96e] text-sm mt-1 tracking-wider" id="review_star_<%= r.getR_id() %>">
              <% for (int i = 0; i < r.getRating(); i++) { %>★<% } %>
              <% for (int i = r.getRating(); i < 5; i++) { %>☆<% } %>
            </div>
          </div>
          <% if (currentUser != null && currentUser.getUserid().equals(r.getUserid())) { %>
          <div class="flex gap-2" id="review_btns_<%= r.getR_id() %>">
            <button onclick="editReview(<%= r.getR_id() %>, '<%= r.getContent().replace("'", "\\'") %>', <%= r.getRating() %>, <%= p.getId() %>)"
                    class="text-xs text-[#8a8790] hover:text-[#f0ede8] transition-colors px-2 py-1"
                    style="background:none; border:none; cursor:pointer;">수정</button>
            <a href="DeleteReviewServlet?r_id=<%= r.getR_id() %>&p_id=<%= p.getId() %>"
               onclick="return confirm('정말 삭제하시겠습니까?')"
               class="text-xs text-[#e24b4a] hover:text-red-400 transition-colors px-2 py-1">삭제</a>
          </div>
          <% } %>
        </div>
        <div id="review_content_<%= r.getR_id() %>" class="text-sm text-[#8a8790] mt-3 leading-relaxed">
          <%= r.getContent().replace("\n", "<br>") %>
        </div>
      </div>
      <% } } else { %>
      <div class="text-center py-12 text-[#4a4850]">
        <p class="text-base">아직 작성된 리뷰가 없습니다. 첫 후기를 남겨보세요!</p>
      </div>
      <% } %>
    </div>
  </div>

</main>

<% } %>

<script>
function addToCart(productId) {
  const qty = document.getElementById("p_count").value;
  fetch('addToCart', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: 'p_id=' + productId + '&count=' + qty
  })
  .then(r => r.json())
  .then(data => {
    if (data.status === 'success') {
      if (confirm('장바구니에 담았습니다. 장바구니로 이동하시겠습니까?')) location.href = 'cartList';
    } else if (data.status === 'login_required') {
      alert('로그인이 필요한 기능입니다.'); location.href = 'login.jsp';
    } else { alert('처리에 실패했습니다.'); }
  });
}

function editReview(r_id, content, rating, p_id) {
  const contentBox = document.getElementById("review_content_" + r_id);
  const starBox = document.getElementById("review_star_" + r_id);
  const btnBox = document.getElementById("review_btns_" + r_id);
  starBox.style.display = 'none';
  btnBox.style.display = 'none';

  let stars = '';
  for (let i = 5; i >= 1; i--) {
    const sel = rating == i ? ' selected' : '';
    const label = '★'.repeat(i);
    stars += '<option value="' + i + '"' + sel + '>' + label + '</option>';
  }

  contentBox.innerHTML =
    '<form action="UpdateReviewServlet" method="post" class="mt-3" style="background:#141418; padding:16px; border-radius:12px; border:1px solid rgba(255,255,255,0.07);">' +
    '<input type="hidden" name="r_id" value="' + r_id + '">' +
    '<input type="hidden" name="p_id" value="' + p_id + '">' +
    '<div style="margin-bottom:10px;"><select name="rating" style="width:auto; padding:8px 12px;">' + stars + '</select></div>' +
    '<textarea name="content" rows="3" required style="width:100%; resize:none; margin-bottom:10px;">' + content + '</textarea>' +
    '<div style="display:flex; justify-content:flex-end; gap:8px;">' +
    '<button type="submit" style="padding:8px 20px; border-radius:8px; background:#c8a96e; color:#0a0a0b; font-size:13px; font-weight:700; border:none; cursor:pointer;">수정완료</button>' +
    '<button type="button" onclick="location.reload()" style="padding:8px 20px; border-radius:8px; background:transparent; border:1px solid rgba(255,255,255,0.1); color:#8a8790; font-size:13px; cursor:pointer;">취소</button>' +
    '</div></form>';
}
</script>

<%@ include file="footer.jsp"%>
