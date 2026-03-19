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
import model.OrderDAO;
import model.OrderDTO;

/**
 * [수정사항] 1. Post 방식 대응 (doPost 추가) 2. 한글 깨짐 방지 인코딩 설정 3. 서버 콘솔을 통한 실행 로그 출력
 * (404 및 데이터 흐름 추적용)
 */
@WebServlet("/orderList")
public class OrderListServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// 1. 인코딩 및 로그 출력
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		System.out.println("[로그] OrderListServlet: 주문 내역 요청 진입");

		HttpSession session = request.getSession();
		MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");

		// 2. 로그인 세션 체크
		if (loginUser == null) {
			System.out.println("[경고] 로그인 세션 없음: login.jsp로 리다이렉트");
			response.sendRedirect("login.jsp");
			return;
		}

		try {
			// 3. DAO를 통해 데이터 조회
			OrderDAO dao = new OrderDAO();
			List<OrderDTO> orderList = dao.getOrderList(loginUser.getUserid());

			// 데이터 확인 로그
			System.out.println("[정보] 조회된 주문 건수: " + (orderList != null ? orderList.size() : 0));

			// 4. 결과 전달
			request.setAttribute("orderList", orderList);
			request.getRequestDispatcher("orderList.jsp").forward(request, response);

		} catch (Exception e) {
			System.out.println("[에러] 주문 내역 조회 중 예외 발생");
			e.printStackTrace();
			// 에러 발생 시 사용자를 배려한 에러 페이지 이동 (선택사항)
			// response.sendRedirect("error.jsp");
		}
	}

	// [보완] POST 방식으로 들어와도 처리할 수 있도록 연결
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doGet(request, response);
	}
}