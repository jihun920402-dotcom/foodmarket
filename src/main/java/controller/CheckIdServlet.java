package controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.MemberDAO;

@WebServlet("/checkId")
public class CheckIdServlet extends HttpServlet {
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String userid = request.getParameter("userid");
		MemberDAO dao = new MemberDAO();
		boolean isExist = dao.checkId(userid);

		// 결과값을 텍스트로 바로 응답 (기존 페이지 유지하면서 데이터만 주고받기)
		response.getWriter().write(isExist ? "fail" : "success");
	}
}