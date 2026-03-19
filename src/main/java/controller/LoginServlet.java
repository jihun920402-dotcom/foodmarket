package controller;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import model.MemberDAO;
import model.MemberDTO;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String userid = request.getParameter("userid");
		String password = request.getParameter("password");

		MemberDAO dao = new MemberDAO();
		MemberDTO user = dao.loginCheck(userid, password);

		response.setContentType("text/html; charset=UTF-8");
		PrintWriter out = response.getWriter();

		if (user != null) {
			HttpSession session = request.getSession();
			session.setAttribute("loginUser", user);
			response.sendRedirect("list");
		} else {
			// [사장님 지시사항] 로그인 실패 시 팝업창 띄우기
			out.println("<script>");
			out.println("alert('아이디 또는 비밀번호가 일치하지 않습니다.');");
			out.println("location.href='login.jsp';");
			out.println("</script>");
		}
	}
}