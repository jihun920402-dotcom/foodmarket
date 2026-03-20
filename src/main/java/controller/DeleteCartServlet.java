
package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.CartDAO;

// JSP에서 호출하는 href="deleteCart"와 이름을 일치시켰습니다.
@WebServlet("/deleteCart")
public class DeleteCartServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// 1. JSP의 deleteCart?cart_id=... 에서 'cart_id' 값을 가져옵니다.
		String cartIdStr = request.getParameter("cart_id");

		if (cartIdStr != null && !cartIdStr.isEmpty()) {
			try {
				int cartId = Integer.parseInt(cartIdStr);
				CartDAO dao = new CartDAO();

				// 2. DAO를 통해 삭제 수행 (DB 연결 주소는 /FREEPDB1 확인됨)
				dao.deleteCart(cartId);

			} catch (NumberFormatException e) {
				System.out.println("장바구니 ID 숫자 변환 실패: " + cartIdStr);
				e.printStackTrace();
			}
		}

		// 3. 삭제 완료 후 장바구니 목록 화면(CartListServlet)으로 이동합니다.
		response.sendRedirect("cartList");
	}
}