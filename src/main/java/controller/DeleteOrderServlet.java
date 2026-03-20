package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import model.OrderDAO;

@WebServlet("/deleteOrder")
public class DeleteOrderServlet extends HttpServlet {
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// 1. 파라미터로 넘어온 주문번호 받기
		String orderIdStr = request.getParameter("orderId");

		if (orderIdStr != null) {
			int orderId = Integer.parseInt(orderIdStr);

			// 2. DAO를 통해 DB에서 삭제
			OrderDAO dao = new OrderDAO();
			dao.deleteOrder(orderId);
		}

		// 3. 삭제 후 다시 주문 관리 목록으로 이동
		response.sendRedirect("adminOrderList");
	}
}
