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

@WebServlet("/updateMember")
public class UpdateMemberServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");

		HttpSession session = request.getSession(false);
		if (session == null) {
			response.sendRedirect("login.jsp");
			return;
		}

		MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
		if (loginUser == null) {
			response.sendRedirect("login.jsp");
			return;
		}

		String password = request.getParameter("password");
		String name = request.getParameter("name");
		String phone = request.getParameter("phone");
		String address = request.getParameter("address");
		String accountNumber = request.getParameter("accountNumber");

		if (password == null || password.trim().isEmpty() || name == null || name.trim().isEmpty()) {
			response.setContentType("text/html; charset=UTF-8");
			response.getWriter().write("<script>alert('비밀번호와 이름은 필수입니다.'); history.back();</script>");
			return;
		}

		MemberDTO updateDto = new MemberDTO();
		updateDto.setUserid(loginUser.getUserid());
		updateDto.setPassword(password.trim());
		updateDto.setName(name.trim());
		updateDto.setPhone(phone != null ? phone.trim() : "");
		updateDto.setAddress(address != null ? address.trim() : "");
		updateDto.setAccountNumber(accountNumber != null ? accountNumber.trim() : "");

		MemberDAO dao = new MemberDAO();
		int result = dao.updateMember(updateDto);

		if (result > 0) {
			MemberDTO freshUser = dao.getMemberByUserid(loginUser.getUserid());
			if (freshUser != null) {
				session.setAttribute("loginUser", freshUser);
			}
			response.sendRedirect("mypage.jsp?updateSuccess=1");
		} else {
			response.setContentType("text/html; charset=UTF-8");
			response.getWriter().write("<script>alert('회원정보 수정 실패'); history.back();</script>");
		}
	}
}
