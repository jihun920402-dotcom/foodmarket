package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.ReviewDAO;

@WebServlet("/DeleteReviewServlet")
public class DeleteReviewServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// 상세페이지에서 넘겨준 r_id(리뷰번호)와 p_id(상품번호) 받기
		String r_idStr = request.getParameter("r_id");
		String p_idStr = request.getParameter("p_id");

		if (r_idStr != null && p_idStr != null) {
			int r_id = Integer.parseInt(r_idStr);
			int p_id = Integer.parseInt(p_idStr);

			ReviewDAO dao = new ReviewDAO();
			int result = dao.deleteReview(r_id);

			if (result > 0) {
				// 삭제 성공 시 다시 상세페이지로 이동 (id 파라미터 유지)
				response.sendRedirect("detail?id=" + p_id);
				return;
			}
		}
		response.sendRedirect("list");
	}
}