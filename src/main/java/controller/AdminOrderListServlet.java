package controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import model.OrderDAO;
import model.OrderDTO;

@WebServlet("/adminOrderList")
public class AdminOrderListServlet extends HttpServlet {
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		OrderDAO dao = new OrderDAO();
		List<OrderDTO> allOrders = dao.getAllOrders(); // 모든 주문 가져오기

		request.setAttribute("allOrders", allOrders);
		request.getRequestDispatcher("adminOrderList.jsp").forward(request, response);
	}
}