
package controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.MemberDTO;
import model.ChargeDAO;
import model.ChargeDTO;

@WebServlet("/chargeList")
public class ChargeListServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// 1. 세션에서 로그인한 사용자 정보 가져오기
		HttpSession session = request.getSession();
		MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");

		// 로그인 안 되어 있으면 로그인 페이지로
		if (loginUser == null) {
			response.sendRedirect("login.jsp");
			return;
		}

		// 2. DAO 호출하여 해당 사용자의 충전 내역 리스트 가져오기
		ChargeDAO cDao = new ChargeDAO();
		// [점검완료] 사장님이 만든 getChargeListByUser 메서드 사용
		List<ChargeDTO> chargeList = cDao.getChargeListByUser(loginUser.getUserid());

		// 3. JSP에서 사용할 수 있도록 request에 담기
		request.setAttribute("chargeList", chargeList);

		// 4. 충전 내역 페이지(chargeList.jsp)로 이동
		request.getRequestDispatcher("chargeList.jsp").forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doGet(request, response);
	}
}