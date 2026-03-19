package controller;

import java.io.IOException;
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

		// --- [방어 로직 추가] 파라미터 null 체크 ---
		String pIdParam = request.getParameter("p_id");
		String countParam = request.getParameter("count");

		// 파라미터가 하나라도 null이거나 비어있으면 목록으로 튕겨냄
		if (pIdParam == null || pIdParam.isEmpty() || countParam == null || countParam.isEmpty()) {
			System.out.println("에러: p_id 또는 count 값이 전달되지 않았습니다.");
			response.sendRedirect("list");
			return;
		}

		// 안전하게 파싱 (여기서 에러가 났던 36번줄 로직입니다)
		int p_id = Integer.parseInt(pIdParam);
		int count = Integer.parseInt(countParam);

		String address = request.getParameter("address");
		String phone = request.getParameter("phone");

		ProductDAO pDao = new ProductDAO();
		ProductDTO product = pDao.getProductById(p_id);

		if (product == null) {
			response.sendRedirect("list");
			return;
		}

		int totalPrice = product.getPrice() * count;

		OrderDTO orderDto = new OrderDTO();
		orderDto.setUserid(loginUser.getUserid());
		orderDto.setTotalPrice(totalPrice);
		orderDto.setAddress(address);
		orderDto.setPhone(phone);

		OrderDAO oDao = new OrderDAO();
		boolean isSuccess = oDao.processOrderTransaction(orderDto, p_id, count);

		if (isSuccess) {
			loginUser.setMileage(loginUser.getMileage() - totalPrice);
			session.setAttribute("loginUser", loginUser);
			response.sendRedirect("orderList?success=1");
		} else {
			response.sendRedirect("detail?id=" + p_id + "&error=transaction_failed");
		}
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doPost(request, response);
	}
}