package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.MemberDTO;
import model.ReviewDAO;

@WebServlet("/AddReviewServlet")
public class AddReviewServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// 1. 한글 깨짐 방지 및 세션 체크
		request.setCharacterEncoding("UTF-8");
		HttpSession session = request.getSession();
		MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");

		// 로그인 안 된 상태면 로그인 페이지로
		if (loginUser == null) {
			response.sendRedirect("login.jsp");
			return;
		}

		// 2. 파라미터 수집
		int p_id = Integer.parseInt(request.getParameter("p_id")); // 상품 번호
		String content = request.getParameter("content"); // 리뷰 내용
		int rating = Integer.parseInt(request.getParameter("rating")); // 별점
		String userid = loginUser.getUserid(); // 작성자 ID

		// 3. DB 저장 실행
		ReviewDAO rDao = new ReviewDAO();
		int result = rDao.insertReview(p_id, userid, content, rating);

		if (result > 0) {
			// 4. 성공 시 다시 해당 상품 상세 페이지로 이동
			// 사장님의 상세페이지 주소 형식인 'detail?id=번호'에 맞췄습니다.
			response.sendRedirect("detail?id=" + p_id);
		} else {
			// 실패 시 메시지와 함께 이전 페이지로
			response.setContentType("text/html; charset=UTF-8");
			response.getWriter().println("<script>alert('리뷰 등록에 실패했습니다.'); history.back();</script>");
		}
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		response.sendRedirect("list"); // 직접 주소창 입력 시 리스트로 보냄
	}
}
