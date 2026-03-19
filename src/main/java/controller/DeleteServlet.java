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
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String idStr = request.getParameter("id");

		if (idStr != null && !idStr.isEmpty()) {
			int id = Integer.parseInt(idStr);
			ProductDAO dao = new ProductDAO();
			dao.deleteProduct(id);
		}
		response.sendRedirect("list");
	}
}