<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*, model.CartDTO, model.MemberDTO"%>
<%@ include file="header.jsp"%>

<%
List<CartDTO> cartList = (List<CartDTO>) request.getAttribute("cartList");
int totalMileage = (loginUser != null) ? loginUser.getMileage() : 0;
%>

<main class="max-w-7xl mx-auto px-4 sm:px-6 py-10">
  <div class="mb-8">
    <h1 class="text-2xl font-bold text-[#f0ede8] tracking-tight">장바구니</h1>
    <p class="text-sm text-[#8a8790] mt-1">담은 상품을 확인하고 결제하세요</p>
  </div>

  <div class="flex flex-col lg:flex-row gap-6">

    <!-- 상품 목록 -->
    <div class="flex-1 bg-[#18181c] border border-[rgba(255,255,255,0.07)] rounded-2xl overflow-hidden">
      <div class="overflow-x-auto">
        <table class="w-full text-sm" style="min-width: 580px;">
          <thead>
            <tr class="border-b border-[rgba(255,255,255,0.07)]">
              <th class="px-4 py-3.5 w-10">
                <input type="checkbox" id="selectAll" checked onclick="toggleAll(this)" style="width:16px!important;">
              </th>
              <th class="px-4 py-3.5 text-left text-[10px] font-medium tracking-[0.1em] uppercase text-[#8a8790]">상품정보</th>
              <th class="px-4 py-3.5 text-center text-[10px] font-medium tracking-[0.1em] uppercase text-[#8a8790]">가격</th>
              <th class="px-4 py-3.5 text-center text-[10px] font-medium tracking-[0.1em] uppercase text-[#8a8790] w-36">수량</th>
              <th class="px-4 py-3.5 text-center text-[10px] font-medium tracking-[0.1em] uppercase text-[#8a8790]">소계</th>
              <th class="px-4 py-3.5 text-center text-[10px] font-medium tracking-[0.1em] uppercase text-[#8a8790]">관리</th>
            </tr>
          </thead>
          <tbody>
            <% if (cartList == null || cartList.isEmpty()) { %>
            <tr>
              <td colspan="6" class="text-center py-20 text-[#4a4850]">장바구니가 비어 있습니다.</td>
            </tr>
            <% } else {
                 for (CartDTO item : cartList) { %>
            <tr class="border-b border-[rgba(255,255,255,0.05)] hover:bg-[rgba(255,255,255,0.02)] transition-colors cart-item-row">
              <td class="px-4 py-4 text-center">
                <input type="checkbox" name="selectedItems" class="item-check"
                       value="<%= item.getCartId() %>"
                       data-price="<%= item.getProductPrice() %>"
                       data-count="<%= item.getCount() %>"
                       checked onclick="updateTotal()" style="width:16px!important;">
              </td>
              <td class="px-4 py-4">
                <div class="flex items-center gap-3">
                  <img src="<%= item.getImgUrl() %>" alt=""
                       style="width:52px; height:52px; object-fit:cover; border-radius:8px; border:1px solid rgba(255,255,255,0.07); flex-shrink:0;">
                  <span class="text-sm font-medium text-[#f0ede8]"><%= item.getProductName() %></span>
                </div>
              </td>
              <td class="px-4 py-4 text-center text-sm text-[#8a8790]"><%= String.format("%,d", item.getProductPrice()) %>원</td>
              <td class="px-4 py-4 text-center">
                <form action="updateCart" method="post" class="inline-flex items-center gap-1">
                  <input type="hidden" name="cartId" value="<%= item.getCartId() %>">
                  <button type="submit" name="count" value="<%= item.getCount() - 1 %>"
                          <%= item.getCount() <= 1 ? "disabled" : "" %>
                          class="w-7 h-7 rounded-lg border border-[rgba(255,255,255,0.07)] text-[#8a8790] hover:text-[#f0ede8] hover:border-[rgba(255,255,255,0.2)] transition-all disabled:opacity-30"
                          style="background:none; cursor:pointer; font-size:16px; padding:0;">−</button>
                  <input type="text" value="<%= item.getCount() %>" readonly
                         style="width:36px; text-align:center; border:1px solid rgba(255,255,255,0.07); padding:4px; font-size:13px;">
                  <button type="submit" name="count" value="<%= item.getCount() + 1 %>"
                          class="w-7 h-7 rounded-lg border border-[rgba(255,255,255,0.07)] text-[#8a8790] hover:text-[#f0ede8] hover:border-[rgba(255,255,255,0.2)] transition-all"
                          style="background:none; cursor:pointer; font-size:16px; padding:0;">+</button>
                </form>
              </td>
              <td class="px-4 py-4 text-center text-sm font-semibold text-[#c8a96e]">
                <span><%= String.format("%,d", item.getProductPrice() * item.getCount()) %></span>원
              </td>
              <td class="px-4 py-4 text-center">
                <button onclick="if(confirm('삭제하시겠습니까?')) location.href='deleteCart?id=<%= item.getCartId() %>'"
                        class="text-xs text-[#e24b4a] hover:text-red-400 transition-colors px-3 py-1.5 rounded-lg border border-[rgba(226,75,74,0.25)] hover:bg-[rgba(226,75,74,0.08)]"
                        style="background:none; cursor:pointer;">삭제</button>
              </td>
            </tr>
            <% } } %>
          </tbody>
        </table>
      </div>
    </div>

    <!-- 결제 요약 -->
    <div class="lg:w-72 shrink-0">
      <div class="bg-[#18181c] border border-[rgba(255,255,255,0.07)] rounded-2xl overflow-hidden sticky top-20">
        <div class="px-5 py-4 border-b border-[rgba(255,255,255,0.07)]">
          <h3 class="text-sm font-bold text-[#f0ede8]">결제 요약</h3>
        </div>
        <div class="p-5 space-y-4">
          <div class="flex justify-between items-center">
            <span class="text-sm text-[#8a8790]">최종 결제금액</span>
            <span class="text-xl font-bold text-[#c8a96e]"><span id="totalPriceDisplay">0</span>원</span>
          </div>

          <div class="bg-[#141418] border border-[rgba(255,255,255,0.05)] rounded-xl p-4 space-y-3">
            <div>
              <p class="text-[11px] text-[#4a4850] mb-1">보유 마일리지</p>
              <p class="text-base font-semibold text-[#f0ede8]"><%= String.format("%,d", totalMileage) %>원</p>
            </div>
            <div class="border-t border-[rgba(255,255,255,0.05)] pt-3">
              <p class="text-[11px] text-[#4a4850] mb-1">결제 후 잔여 마일리지</p>
              <p class="text-base font-semibold" id="remainingMileageDisplay">0원</p>
            </div>
          </div>

          <input type="hidden" id="currentUserMileage" value="<%= totalMileage %>">

          <form action="OrderServlet" method="post" id="checkoutForm">
            <input type="hidden" name="selectedCartIds" id="selectedCartIds">
            <button type="button" onclick="submitCheckout()"
                    class="w-full py-3.5 rounded-xl bg-[#c8a96e] text-[#0a0a0b] text-sm font-bold hover:bg-[#d4b87e] transition-colors"
                    style="border:none; cursor:pointer; width:100%;">
              결제하기
            </button>
          </form>
        </div>
      </div>
    </div>

  </div>
</main>

<script>
function updateTotal() {
  const checkboxes = document.querySelectorAll('.item-check:checked');
  let total = 0;
  let selectedIds = [];
  checkboxes.forEach(cb => {
    total += parseInt(cb.getAttribute('data-price')) * parseInt(cb.getAttribute('data-count'));
    selectedIds.push(cb.value);
  });
  document.getElementById('totalPriceDisplay').innerText = total.toLocaleString();
  const currentMileage = parseInt(document.getElementById('currentUserMileage').value);
  const remaining = currentMileage - total;
  const display = document.getElementById('remainingMileageDisplay');
  display.innerText = remaining.toLocaleString() + "원";
  display.style.color = remaining < 0 ? '#e24b4a' : '#f0ede8';
  document.getElementById('selectedCartIds').value = selectedIds.join(',');
}

function submitCheckout() {
  const selectedIds = document.getElementById('selectedCartIds').value;
  const currentMileage = parseInt(document.getElementById('currentUserMileage').value);
  const totalPrice = parseInt(document.getElementById('totalPriceDisplay').innerText.replace(/,/g, ''));
  if (!selectedIds) { alert("상품을 선택해주세요."); return; }
  if (currentMileage < totalPrice) { alert("마일리지가 부족합니다."); return; }
  if (confirm("결제하시겠습니까?")) document.getElementById('checkoutForm').submit();
}

function toggleAll(selectAllBox) {
  document.querySelectorAll('.item-check').forEach(cb => cb.checked = selectAllBox.checked);
  updateTotal();
}

window.onload = updateTotal;
</script>

<%@ include file="footer.jsp"%>
