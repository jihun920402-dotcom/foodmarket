
package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.MemberDAO;
import model.MemberDTO;

@WebServlet("/join")
public class JoinServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// 한글 깨짐 방지
		request.setCharacterEncoding("UTF-8");

		// 1. 파라미터 수집
		String userid = request.getParameter("userid");
		String password = request.getParameter("password");
		String name = request.getParameter("name");
		int age = Integer.parseInt(request.getParameter("age"));
		String phone = request.getParameter("phone");
		String address = request.getParameter("address");
		String accountNumber = request.getParameter("accountNumber");

		// 2. DTO 객체 생성 (새로 만든 상세 생성자 사용)
		// role은 DAO에서 'user', mileage는 1,000,000으로 처리됨
		MemberDTO dto = new MemberDTO(userid, password, name, age, phone, address, accountNumber, "user", 1000000);

		// 3. DAO 호출
		MemberDAO dao = new MemberDAO();
		int result = dao.insertMember(dto);

		// 4. 결과 처리
		if (result > 0) {
			response.sendRedirect("login.jsp"); // 가입 성공 시 로그인으로
		} else {
			response.sendRedirect("join.jsp"); // 실패 시 가입 페이지 유지
		}
	}
}