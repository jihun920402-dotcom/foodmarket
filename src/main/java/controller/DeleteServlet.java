package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.ProductDAO;

@WebServlet("/delete")
public class DeleteServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String idStr = request.getParameter("id");
		String redirectPath = "list"; // 기본 이동 경로

		if (idStr != null && !idStr.isEmpty()) {
			try {
				int id = Integer.parseInt(idStr);
				ProductDAO dao = new ProductDAO();

				// DAO에서 리뷰/장바구니/상품 순으로 트랜잭션 삭제 수행
				int result = dao.deleteProduct(id);

				if (result > 0) {
					// 삭제 성공 시 파라미터 전달 (선택사항)
					redirectPath += "?deleteSuccess=1";
				} else {
					redirectPath += "?error=delete_fail";
				}
			} catch (NumberFormatException e) {
				// ID값이 숫자가 아닌 경우 처리
				e.printStackTrace();
				redirectPath += "?error=invalid_id";
			}
		}

		// 목록 페이지(list 서블릿)로 리다이렉트
		response.sendRedirect(redirectPath);
	}
}