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

import model.MemberDTO;
import model.OrderDAO;
import model.OrderDTO;
import model.ProductDAO;
import model.ProductDTO;
import model.CartDAO;
import model.CartDTO;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");
		HttpSession session = request.getSession();
		MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");

		if (loginUser == null) {
			response.sendRedirect("login.jsp");
			return;
		}

		// --- [1] 파라미터 수신 ---
		String[] pIdArray = request.getParameterValues("p_id");
		String[] countArray = request.getParameterValues("count");
		String totalPriceParam = request.getParameter("totalPrice");
		String address = request.getParameter("address");
		String phone = request.getParameter("phone"); // 결제창 입력값

		if (pIdArray == null || pIdArray.length == 0) {
			response.sendRedirect("list");
			return;
		}

		OrderDAO oDao = new OrderDAO();
		OrderDTO orderDto = new OrderDTO();
		boolean isSuccess = false;
		int finalTotalPrice = 0;

		// --- [2] DTO 공통 데이터 세팅 (이름 일치 작업) ---
		orderDto.setUserid(loginUser.getUserid());
		orderDto.setAddress(address);
		orderDto.setReceiverName(loginUser.getName());

		// [중요] OrderDTO의 두 필드 모두에 값을 넣어 확실히 전달합니다.
		orderDto.setReceiverPhone(phone);
		orderDto.setPhone(phone);

		// --- [3] 단품 결제와 장바구니 결제 분기 ---
		if (pIdArray.length == 1 && totalPriceParam == null) {
			int p_id = Integer.parseInt(pIdArray[0]);
			int count = Integer.parseInt(countArray[0]);

			ProductDAO pDao = new ProductDAO();
			ProductDTO product = pDao.getProductById(p_id);
			if (product == null) {
				response.sendRedirect("list");
				return;
			}

			finalTotalPrice = product.getPrice() * count;
			orderDto.setTotalPrice(finalTotalPrice);

			isSuccess = oDao.processOrderTransaction(orderDto, p_id, count);

		} else {
			finalTotalPrice = Integer.parseInt(totalPriceParam);
			orderDto.setTotalPrice(finalTotalPrice);

			List<CartDTO> itemList = new ArrayList<>();
			for (int i = 0; i < pIdArray.length; i++) {
				CartDTO item = new CartDTO();
				item.setP_id(Integer.parseInt(pIdArray[i]));
				item.setCount(Integer.parseInt(countArray[i]));
				// 0원 문제 방지를 위해 상품 정보를 가져와서 가격을 넣어주는 것이 안전합니다.
				itemList.add(item);
			}
			isSuccess = oDao.insertOrderFromCart(orderDto, itemList);
		}

		// --- [4] 결과 처리 ---
		if (isSuccess) {
			loginUser.setMileage(loginUser.getMileage() - finalTotalPrice);
			session.setAttribute("loginUser", loginUser);

			CartDAO cDao = new CartDAO();
			cDao.clearCart(loginUser.getUserid());
			session.removeAttribute("cartList");

			// 인코딩 처리 (tmpAddr, tmpPhone으로 안전장치)
			String encodedAddr = URLEncoder.encode(address, "UTF-8");
			String encodedPhone = URLEncoder.encode(phone, "UTF-8");

			response.sendRedirect("orderDetail.jsp?orderId=" + orderDto.getOrderId() + "&tmpAddr=" + encodedAddr
					+ "&tmpPhone=" + encodedPhone);
		} else {
			response.sendRedirect("cart?error=transaction_failed");
		}
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doPost(request, response);
	}
}
