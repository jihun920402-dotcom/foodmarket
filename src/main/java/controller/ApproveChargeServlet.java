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
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// 1. 파라미터 수집
		// DAO의 approveRequest(requestId)가 내부적으로 userid와 amount를 조회하므로
		// requestId만 필수로 받으면 됩니다.
		String idStr = request.getParameter("requestId");

		if (idStr == null || idStr.isEmpty()) {
			response.sendRedirect("adminCharge.jsp?error=missing_id");
			return;
		}

		try {
			int requestId = Integer.parseInt(idStr);

			// 2. DAO 호출하여 승인 처리 (상태변경 + 마일리지 합산 트랜잭션 처리)
			ChargeDAO dao = new ChargeDAO();

			// 이전에 수정한 통합 메서드 호출 (반환값 1: 성공, 0: 실패)
			int result = dao.approveRequest(requestId);

			// 3. 결과 처리
			if (result > 0) {
				// 승인 성공 시
				response.sendRedirect("adminCharge.jsp?approveSuccess=1");
			} else {
				// DB 업데이트 실패 시
				response.sendRedirect("adminCharge.jsp?error=1");
			}

		} catch (NumberFormatException e) {
			e.printStackTrace();
			response.sendRedirect("adminCharge.jsp?error=invalid_format");
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doGet(request, response);
	}
}