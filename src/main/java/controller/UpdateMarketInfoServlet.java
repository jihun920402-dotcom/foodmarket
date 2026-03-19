package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import model.MarketInfoDAO;
import model.MemberDTO;

@WebServlet("/updateMarketInfo")
public class UpdateMarketInfoServlet extends HttpServlet {
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		HttpSession session = request.getSession();
		MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");

		// 관리자 권한 체크
		if (loginUser == null || !"admin".equals(loginUser.getRole())) {
			response.sendRedirect("list");
			return;
		}

		String bank = request.getParameter("bankName");
		String account = request.getParameter("accountNumber");
		String holder = request.getParameter("accountHolder");

		MarketInfoDAO dao = new MarketInfoDAO();
		dao.updateInfo(bank, account, holder);

		response.sendRedirect("adminConfig.jsp?success=1");
	}
}