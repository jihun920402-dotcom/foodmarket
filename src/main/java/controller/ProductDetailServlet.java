package controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.ProductDAO;
import model.ProductDTO;
import model.ReviewDAO;
import model.ReviewDTO;

@WebServlet("/detail") // 기존 주소 유지
public class ProductDetailServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// 1. 기존 방식대로 "id" 파라미터 받기
		String idStr = request.getParameter("id");

		if (idStr != null) {
			try {
				int id = Integer.parseInt(idStr);

				// 2. 기존 상품 조회 로직
				ProductDAO pDao = new ProductDAO();
				ProductDTO product = pDao.getProductById(id);

				if (product != null) {
					// 3. [추가] 해당 상품의 리뷰 목록 조회 (상품번호 id 사용)
					ReviewDAO rDao = new ReviewDAO();
					List<ReviewDTO> reviewList = rDao.getReviewsByProduct(id);

					// 4. 기존 데이터 + 리뷰 데이터 세팅
					request.setAttribute("product", product);
					request.setAttribute("reviewList", reviewList);

					request.getRequestDispatcher("/productDetail.jsp").forward(request, response);
					return;
				}
			} catch (NumberFormatException e) {
				e.printStackTrace();
			}
		}
		// 실패 시 기존처럼 리스트로 리다이렉트
		response.sendRedirect("list");
	}
}