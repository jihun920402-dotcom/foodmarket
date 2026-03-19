package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.ChargeDAO;

@WebServlet("/approveCharge")
public class ApproveChargeServlet extends HttpServlet {
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// 1. 파라미터 수집
		int requestId = Integer.parseInt(request.getParameter("requestId"));
		String userid = request.getParameter("userid");
		int amount = Integer.parseInt(request.getParameter("amount"));

		// 2. DAO 호출하여 승인 처리 (상태변경 + 마일리지 합산)
		ChargeDAO dao = new ChargeDAO();
		boolean isSuccess = dao.approveCharge(requestId, userid, amount);

		// 3. 결과 처리
		if (isSuccess) {
			response.sendRedirect("adminCharge.jsp?approveSuccess=1");
		} else {
			response.sendRedirect("adminCharge.jsp?error=1");
		}
	}
}