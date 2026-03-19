package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import model.MemberDAO;
import model.MemberDTO;

@WebServlet("/adminUpdateMember")
public class AdminUpdateMemberServlet extends HttpServlet {
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");

		String userid = request.getParameter("userid");
		String name = request.getParameter("name");
		String phone = request.getParameter("phone");
		String address = request.getParameter("address");
		int mileage = Integer.parseInt(request.getParameter("mileage"));
		String role = request.getParameter("role");

		MemberDTO dto = new MemberDTO();
		dto.setUserid(userid);
		dto.setName(name);
		dto.setPhone(phone);
		dto.setAddress(address);
		dto.setMileage(mileage);
		dto.setRole(role);

		MemberDAO dao = new MemberDAO();
		dao.updateMemberByAdmin(dto);

		// 수정 후 다시 회원 목록 페이지로 이동
		response.sendRedirect("adminMemberList.jsp");
	}
}