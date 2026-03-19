package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.MemberDAO;
import model.MemberDTO;

@WebServlet("/adminDeleteMember")
public class AdminDeleteMemberServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// 1. 세션 및 권한 체크 (사장님의 UpdateMemberServlet 스타일 적용)
		HttpSession session = request.getSession(false);
		if (session == null) {
			response.sendRedirect("login.jsp");
			return;
		}

		MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
		if (loginUser == null || !"admin".equals(loginUser.getRole())) {
			response.sendRedirect("list");
			return;
		}

		String userid = request.getParameter("userid");

		// 2. 본인 삭제 방지
		if (loginUser.getUserid().equals(userid)) {
			response.setContentType("text/html; charset=UTF-8");
			response.getWriter().write("<script>alert('관리자 본인 계정은 삭제할 수 없습니다.'); history.back();</script>");
			return;
		}

		// 3. 삭제 처리
		MemberDAO dao = new MemberDAO();
		int result = dao.deleteMember(userid);

		if (result > 0) {
			response.sendRedirect("adminMemberList.jsp?delSuccess=1");
		} else {
			response.setContentType("text/html; charset=UTF-8");
			response.getWriter().write("<script>alert('삭제 처리에 실패했습니다.'); history.back();</script>");
		}
	}
}