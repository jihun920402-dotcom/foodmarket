package controller;

import java.io.IOException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.*;

@WebServlet("/OrderServlet")
public class OrderServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("utf-8");
		HttpSession session = request.getSession();
		MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");

		// 1. 로그인 체크
		if (loginUser == null) {
			response.sendRedirect("login.jsp");
			return;
		}

		// JSP에서 넘어온 선택된 장바구니 번호들 (예: "1,2,3")
		String selectedIdsStr = request.getParameter("selectedCartIds");

		// 2. 선택 데이터 유효성 검사
		if (selectedIdsStr == null || selectedIdsStr.trim().isEmpty()) {
			System.out.println("결제할 상품이 선택되지 않았습니다.");
			response.sendRedirect("cartList.jsp?error=no_selection");
			return;
		}

		try {
			// 3. DAO 및 리스트 준비
			CartDAO cartDao = new CartDAO();
			OrderDAO orderDao = new OrderDAO(); // 변수명을 아래와 맞췄습니다.

			int totalPrice = 0;
			List<CartDTO> checkoutList = new ArrayList<>();

			// 4. 선택된 ID 분리 및 상세 정보 추출
			String[] cartIdArray = selectedIdsStr.split(",");
			for (String cIdStr : cartIdArray) {
				if (cIdStr.trim().isEmpty())
					continue;

				int cId = Integer.parseInt(cIdStr.trim());
				CartDTO item = cartDao.getCartItemById(cId);

				if (item != null) {
					totalPrice += (item.getProductPrice() * item.getCount());
					checkoutList.add(item);
				}
			}

			// 5. 보유 마일리지 검사
			if (loginUser.getMileage() < totalPrice) {
				response.sendRedirect("cartList.jsp?error=insufficient_mileage");
				return;
			}

			// 6. 실제 결제 처리 (OrderDAO의 리턴값인 int orderId를 받습니다)
			int orderId = orderDao.processOrder(loginUser, checkoutList, totalPrice);

			if (orderId > 0) {
				// 성공 시 세션 정보 동기화 (마일리지 차감 반영)
				session.setAttribute("loginUser", loginUser);

				// 대표 상품명 조립 (예: 한우 등심 외 1건)
				String pName = checkoutList.get(0).getProductName();
				if (checkoutList.size() > 1) {
					pName += " 외 " + (checkoutList.size() - 1) + "건";
				}

				// 한글 깨짐 방지 인코딩 및 리다이렉트
				String encodedPName = URLEncoder.encode(pName, "UTF-8");
				response.sendRedirect(
						"orderSuccess.jsp?orderId=" + orderId + "&totalPrice=" + totalPrice + "&pName=" + encodedPName);
			} else {
				// DB 처리 실패 시
				response.sendRedirect("cartList.jsp?error=pay_fail");
			}

		} catch (Exception e) {
			e.printStackTrace();
			response.sendRedirect("cartList.jsp?error=server_error");
		}
	}
}