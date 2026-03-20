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

/**
 * [ProductListServlet] 역할: 전체 상품 목록 조회 및 카테고리별 필터링 조회 매핑 주소: /list
 */
@WebServlet("/list")
public class ProductListServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// 1. 파라미터 수집 (카테고리 필터링용)
		String category = request.getParameter("category");

		// 2. 비즈니스 로직 수행 (DAO 호출)
		ProductDAO dao = new ProductDAO();
		List<ProductDTO> list = null;

		try {
			if (category != null && !category.isEmpty()) {
				// 카테고리가 선택된 경우 해당 카테고리 상품만 가져옴
				list = dao.getProductsByCategory(category);
			} else {
				// 카테고리가 없으면 전체 상품 조회
				list = dao.getAllProducts();
			}
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("상품 목록 로드 중 오류 발생");
		}

		// 3. 결과 저장 (JSP에서 사용할 이름 "products")
		// 만약 list가 null이면 빈 리스트를 보내서 JSP 에러 방지
		if (list == null) {
			list = new java.util.ArrayList<>();
		}
		request.setAttribute("products", list);

		// 4. View(JSP)로 포워딩
		// 경로가 실제 WebContent(또는 webapp) 폴더 내의 파일명과 일치해야 함
		request.getRequestDispatcher("/productList.jsp").forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doGet(request, response);
	}
}
