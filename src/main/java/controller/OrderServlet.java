package controller;

import java.io.IOException;
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
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");
		HttpSession session = request.getSession();
		MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");

		if (loginUser == null) {
			response.sendRedirect("login.jsp");
			return;
		}

		int totalPrice = Integer.parseInt(request.getParameter("totalPrice"));
		String pName = request.getParameter("pName");

		// 1. 잔액 검증 (정상 작동 로직)
		if (loginUser.getMileage() < totalPrice) {
			response.sendRedirect("cartList?error=low_mileage");
			return;
		}

		try {
			CartDAO cDao = new CartDAO();
			List<CartDTO> cartItems = cDao.getCartList(loginUser.getUserid());
			
			OrderDAO oDao = new OrderDAO();
			OrderDTO oDto = new OrderDTO();
			oDto.setUserid(loginUser.getUserid());
			oDto.setTotalPrice(totalPrice);
			oDto.setReceiverName(loginUser.getName());
			oDto.setReceiverPhone(loginUser.getPhone());
			oDto.setAddress(loginUser.getAddress());

			// [핵심] DB 트랜잭션 실행 (주문 저장 + 재고 차감 + 마일리지 차감)
			boolean success = oDao.insertOrderFromCart(oDto, cartItems);

			if (success) {
				// 장바구니 비우기
				cDao.deleteCartByUser(loginUser.getUserid());

				// 세션 마일리지 갱신
				loginUser.setMileage(loginUser.getMileage() - totalPrice);
				session.setAttribute("loginUser", loginUser);

				String orderId = "ORD-" + System.currentTimeMillis();
				response.sendRedirect("orderSuccess.jsp?orderId=" + orderId + "&totalPrice=" + totalPrice + "&pName="
						+ java.net.URLEncoder.encode(pName, "UTF-8"));
			} else {
				response.sendRedirect("cartList?error=process_fail");
			}

		} catch (Exception e) {
			e.printStackTrace();
			response.sendRedirect("cartList?error=fail");
		}
	}
}