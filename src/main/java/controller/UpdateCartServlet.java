package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.CartDAO;

@WebServlet("/updateCart")
public class UpdateCartServlet extends HttpServlet {
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		int cartId = Integer.parseInt(request.getParameter("cartId"));
		int count = Integer.parseInt(request.getParameter("count"));

		if (count > 0) {
			CartDAO dao = new CartDAO();
			dao.updateCartCount(cartId, count);
		}
		// [중요] jsp가 아니라 서블릿 주소인 cartList로 리다이렉트 해야 합니다!
		response.sendRedirect("cartList");
	}
}