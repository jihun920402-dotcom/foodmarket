package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import model.OrderDAO;

@WebServlet("/updateOrderStatus")
public class UpdateOrderStatusServlet extends HttpServlet {
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		int orderId = Integer.parseInt(request.getParameter("orderId"));
		String status = request.getParameter("status");

		OrderDAO dao = new OrderDAO();
		dao.updateOrderStatus(orderId, status);

		// 수정 후 다시 관리자 주문 목록으로 이동
		response.sendRedirect("adminOrderList");
	}
}