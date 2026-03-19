package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.ChargeDAO;
import model.MemberDTO;

@WebServlet("/requestCharge")
public class RequestChargeServlet extends HttpServlet {
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession();
		MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");

		if (loginUser == null) {
			response.sendRedirect("login.jsp");
			return;
		}

		int amount = Integer.parseInt(request.getParameter("amount"));
		ChargeDAO dao = new ChargeDAO();
		int result = dao.insertRequest(loginUser.getUserid(), amount);

		if (result > 0) {
			response.sendRedirect("mypage.jsp?success=1");
		} else {
			response.sendRedirect("mypage.jsp?error=1");
		}
	}
}