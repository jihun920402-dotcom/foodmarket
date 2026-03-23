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
	private static final long serialVersionUID = 1L;

	// 충전 신청은 데이터 생성 작업이므로 doPost로 처리하는 것이 안전합니다.
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("utf-8");
		HttpSession session = request.getSession();
		MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");

		// 1. 로그인 체크
		if (loginUser == null) {
			response.sendRedirect("login.jsp");
			return;
		}

		try {
			// 2. 파라미터 수신 (chargeRequest.jsp의 input name="amount"와 일치해야 함)
			String amountStr = request.getParameter("amount");
			if (amountStr == null || amountStr.trim().isEmpty()) {
				response.sendRedirect("chargeList.jsp?error=empty_amount");
				return;
			}

			int amount = Integer.parseInt(amountStr.trim());

			// 3. DAO 호출 (메서드명: insertChargeRequest)
			ChargeDAO dao = new ChargeDAO();
			// 리턴 타입이 boolean이므로 조건문을 그에 맞게 수정했습니다.
			boolean isSuccess = dao.insertChargeRequest(loginUser.getUserid(), amount);

			if (isSuccess) {
				// 4. 성공 시 마이페이지나 충전 내역 리스트로 이동
				response.sendRedirect("chargeList.jsp?success=charge_requested");
			} else {
				response.sendRedirect("chargeList.jsp?error=charge_failed");
			}

		} catch (NumberFormatException e) {
			e.printStackTrace();
			response.sendRedirect("chargeList.jsp?error=invalid_amount");
		} catch (Exception e) {
			e.printStackTrace();
			response.sendRedirect("chargeList.jsp?error=server_error");
		}
	}

	// 혹시나 GET 방식으로 접근할 경우를 대비해 doPost로 토스합니다.
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doPost(request, response);
	}
}