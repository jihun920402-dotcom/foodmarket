package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// 1. 현재 세션 가져오기 (없으면 null 반환하지 않고 새로 만들지도 않음)
		HttpSession session = request.getSession(false);

		if (session != null) {
			// 2. 세션 무효화 (모든 데이터 삭제)
			session.invalidate();
		}

		// 3. 로그아웃 후 메인 목록 페이지로 이동
		response.sendRedirect("list");
	}
}