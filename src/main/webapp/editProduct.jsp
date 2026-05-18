<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="model.ProductDTO"%>
<%
ProductDTO product = (ProductDTO) request.getAttribute("product");
%>
<%@ include file="header.jsp"%>

<main class="max-w-7xl mx-auto px-4 sm:px-6 py-10">
  <div class="max-w-2xl mx-auto">
    <div class="mb-8">
      <h1 class="text-2xl font-bold text-[#f0ede8] tracking-tight">상품 정보 수정</h1>
      <p class="text-sm text-[#8a8790] mt-1">상품 정보를 수정합니다</p>
    </div>

    <div class="bg-[#18181c] border border-[rgba(255,255,255,0.07)] rounded-2xl p-8">
      <form action="UpdateServlet" method="post" enctype="multipart/form-data">
        <input type="hidden" name="p_id" value="<%= product.getId() %>">

        <div class="flex flex-col md:flex-row gap-8">
          <!-- 이미지 미리보기 -->
          <div class="md:w-56 shrink-0">
            <p class="text-xs font-medium tracking-[0.08em] uppercase text-[#8a8790] mb-3">현재 이미지</p>
            <div class="aspect-square bg-[#141418] border border-[rgba(255,255,255,0.07)] rounded-xl overflow-hidden mb-4">
              <img id="imagePreview" src="<%= product.getImgUrl() %>"
                   class="w-full h-full object-cover" alt="상품 이미지">
            </div>
            <div>
              <label class="block text-xs font-medium tracking-[0.08em] uppercase text-[#8a8790] mb-2">이미지 변경</label>
              <input type="file" name="p_img_url" id="imgInput" accept="image/*" style="width:100%;">
            </div>
          </div>

          <!-- 상품 정보 -->
          <div class="flex-1 space-y-4">
            <div>
              <label class="block text-xs font-medium tracking-[0.08em] uppercase text-[#8a8790] mb-2">상품명</label>
              <input type="text" name="p_name" value="<%= product.getName() %>" required style="width:100%;">
            </div>

            <div>
              <label class="block text-xs font-medium tracking-[0.08em] uppercase text-[#8a8790] mb-2">카테고리</label>
              <select name="p_category" style="width:100%;">
                <option value="해산물" <%= "해산물".equals(product.getCategory()) ? "selected" : "" %>>해산물</option>
                <option value="육류" <%= "육류".equals(product.getCategory()) ? "selected" : "" %>>육류</option>
                <option value="선물류" <%= "선물류".equals(product.getCategory()) ? "selected" : "" %>>선물류</option>
              </select>
            </div>

            <div class="grid grid-cols-2 gap-3">
              <div>
                <label class="block text-xs font-medium tracking-[0.08em] uppercase text-[#8a8790] mb-2">가격 (원)</label>
                <input type="number" name="p_price" value="<%= product.getPrice() %>" required style="width:100%;">
              </div>
              <div>
                <label class="block text-xs font-medium tracking-[0.08em] uppercase text-[#8a8790] mb-2">재고</label>
                <input type="number" name="p_stock" value="<%= product.getStock() %>" required style="width:100%;">
              </div>
            </div>

            <div>
              <label class="block text-xs font-medium tracking-[0.08em] uppercase text-[#8a8790] mb-2">참조 링크</label>
              <input type="url" name="p_link_url" value="<%= product.getLinkUrl() %>" style="width:100%;">
            </div>
          </div>
        </div>

        <div class="flex gap-3 mt-8">
          <button type="button" onclick="location.href='list'"
                  class="flex-none px-6 py-3.5 rounded-xl border border-[rgba(255,255,255,0.07)] text-sm text-[#8a8790] hover:text-[#f0ede8] hover:border-[rgba(255,255,255,0.15)] transition-all"
                  style="background:none; cursor:pointer;">
            목록으로
          </button>
          <button type="submit"
                  class="flex-1 py-3.5 rounded-xl bg-[#c8a96e] text-[#0a0a0b] text-sm font-bold hover:bg-[#d4b87e] transition-colors"
                  style="border:none; cursor:pointer;">
            수정 완료
          </button>
        </div>
      </form>
    </div>
  </div>
</main>

<script>
document.getElementById('imgInput').onchange = function() {
  const [file] = this.files;
  if (file) document.getElementById('imagePreview').src = URL.createObjectURL(file);
};
</script>

<%@ include file="footer.jsp"%>
