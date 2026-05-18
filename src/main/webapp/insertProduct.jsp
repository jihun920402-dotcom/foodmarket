<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="header.jsp"%>

<main class="max-w-7xl mx-auto px-4 sm:px-6 py-10">
  <div class="max-w-xl mx-auto">
    <div class="mb-8">
      <h1 class="text-2xl font-bold text-[#f0ede8] tracking-tight">신규 상품 등록</h1>
      <p class="text-sm text-[#8a8790] mt-1">새로운 상품 정보를 입력하세요</p>
    </div>

    <div class="bg-[#18181c] border border-[rgba(255,255,255,0.07)] rounded-2xl p-8">
      <form action="insert" method="post" enctype="multipart/form-data" class="space-y-5">

        <div>
          <label class="block text-xs font-medium tracking-[0.08em] uppercase text-[#8a8790] mb-2">카테고리</label>
          <select name="p_category" style="width:100%;">
            <option value="해산물">해산물</option>
            <option value="육류">육류</option>
            <option value="선물류">선물류</option>
          </select>
        </div>

        <div>
          <label class="block text-xs font-medium tracking-[0.08em] uppercase text-[#8a8790] mb-2">상품명</label>
          <input type="text" name="p_name" required style="width:100%;">
        </div>

        <div>
          <label class="block text-xs font-medium tracking-[0.08em] uppercase text-[#8a8790] mb-2">상품 이미지</label>
          <input type="file" name="p_img_file" required style="width:100%;">
        </div>

        <div>
          <label class="block text-xs font-medium tracking-[0.08em] uppercase text-[#8a8790] mb-2">참조 링크 (선택)</label>
          <input type="url" name="p_link_url" placeholder="https://..." style="width:100%;">
        </div>

        <div class="grid grid-cols-2 gap-4">
          <div>
            <label class="block text-xs font-medium tracking-[0.08em] uppercase text-[#8a8790] mb-2">가격 (원)</label>
            <input type="number" name="p_price" required style="width:100%;">
          </div>
          <div>
            <label class="block text-xs font-medium tracking-[0.08em] uppercase text-[#8a8790] mb-2">수량</label>
            <input type="number" name="p_stock" value="1" style="width:100%;">
          </div>
        </div>

        <div class="flex gap-3 pt-2">
          <a href="list"
             class="flex-none flex items-center justify-center px-6 py-3.5 rounded-xl border border-[rgba(255,255,255,0.07)] text-sm text-[#8a8790] hover:text-[#f0ede8] hover:border-[rgba(255,255,255,0.15)] transition-all">
            취소
          </a>
          <button type="submit"
                  class="flex-1 py-3.5 rounded-xl bg-[#c8a96e] text-[#0a0a0b] text-sm font-bold hover:bg-[#d4b87e] transition-colors"
                  style="border:none; cursor:pointer;">
            상품 등록 완료
          </button>
        </div>
      </form>
    </div>
  </div>
</main>

<%@ include file="footer.jsp"%>
