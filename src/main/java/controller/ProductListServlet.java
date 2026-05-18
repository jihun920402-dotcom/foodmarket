package controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.ProductDAO;
import model.ProductDTO;

@WebServlet("/list")
public class ProductListServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");

		String keyword  = request.getParameter("keyword");
		String category = request.getParameter("category");
		String sort     = request.getParameter("sort");

		if (keyword  == null) keyword  = "";
		if (category == null) category = "";
		if (sort     == null) sort     = "latest";

		List<ProductDTO> list = new ArrayList<>();
		try {
			ProductDAO dao = new ProductDAO();
			list = dao.getProductList(keyword, category, sort);
		} catch (Exception e) {
			e.printStackTrace();
		}

		request.setAttribute("products", list);
		request.setAttribute("keyword",  keyword);
		request.setAttribute("category", category);
		request.setAttribute("sort",     sort);

		request.getRequestDispatcher("/productList.jsp").forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doGet(request, response);
	}
}
