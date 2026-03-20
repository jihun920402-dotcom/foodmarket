
package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.CartDAO;
import model.MemberDTO;

@WebServlet("/addToCart")
public class AddToCartServlet extends HttpServlet {
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");
		response.setContentType("application/json; charset=UTF-8");

		HttpSession session = request.getSession();
		MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");

		// 로그인 체크
		if (loginUser == null) {
			response.getWriter().write("{\"status\": \"login_required\"}");
			return;
		}

		try {
			int p_id = Integer.parseInt(request.getParameter("p_id"));
			int count = Integer.parseInt(request.getParameter("count"));

			CartDAO dao = new CartDAO();
			int result = dao.addToCart(loginUser.getUserid(), p_id, count);

			if (result > 0) {
				response.getWriter().write("{\"status\": \"success\"}");
			} else {
				response.getWriter().write("{\"status\": \"error\"}");
			}
		} catch (Exception e) {
			e.printStackTrace();
			response.getWriter().write("{\"status\": \"error\"}");
		}
	}
}