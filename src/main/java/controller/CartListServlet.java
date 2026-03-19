package controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.CartDAO;
import model.CartDTO;
import model.MemberDTO;

@WebServlet("/cartList") // 이 주소로 들어와야 함
public class CartListServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession();
		MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");

		if (loginUser == null) {
			response.sendRedirect("login.jsp");
			return;
		}

		String userId = loginUser.getUserid();
		CartDAO dao = new CartDAO();

		// DB에서 목록 가져오기
		List<CartDTO> list = dao.getCartList(userId);

		// 콘솔에 로그를 강제로 찍어 확인합니다.
		System.out.println("=== CartListServlet 실행됨 ===");
		System.out.println("조회 아이디: " + userId);
		System.out.println("검색된 항목 수: " + (list != null ? list.size() : 0));

		// JSP로 데이터 전달
		request.setAttribute("cartList", list);

		// cartList.jsp 페이지를 보여줌
		request.getRequestDispatcher("/cartList.jsp").forward(request, response);
	}
}