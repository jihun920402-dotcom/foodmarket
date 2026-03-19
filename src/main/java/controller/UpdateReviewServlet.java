package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.ReviewDAO;

@WebServlet("/UpdateReviewServlet")
public class UpdateReviewServlet extends HttpServlet {
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");

		String r_idStr = request.getParameter("r_id");
		String p_idStr = request.getParameter("p_id");
		String content = request.getParameter("content");
		String ratingStr = request.getParameter("rating");

		try {
			if (r_idStr != null && !r_idStr.isEmpty()) {
				int r_id = Integer.parseInt(r_idStr);
				int rating = Integer.parseInt(ratingStr);

				ReviewDAO dao = new ReviewDAO();
				dao.updateReview(r_id, content, rating);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		// 수정 후 원래 보던 상품 상세 페이지로 이동
		if (p_idStr != null && !p_idStr.isEmpty()) {
			response.sendRedirect("detail?id=" + p_idStr);
		} else {
			response.sendRedirect("list");
		}
	}
}