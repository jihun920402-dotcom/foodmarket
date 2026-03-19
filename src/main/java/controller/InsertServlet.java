package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;
import model.ProductDAO;
import model.ProductDTO;

@WebServlet("/insert")
public class InsertServlet extends HttpServlet {
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String savePath = request.getServletContext().getRealPath("images");
		int maxSize = 10 * 1024 * 1024;
		MultipartRequest multi = new MultipartRequest(request, savePath, maxSize, "UTF-8",
				new DefaultFileRenamePolicy());

		String name = multi.getParameter("p_name");
		String category = multi.getParameter("p_category");
		int price = Integer.parseInt(multi.getParameter("p_price"));
		int stock = Integer.parseInt(multi.getParameter("p_stock"));
		String linkUrl = multi.getParameter("p_link_url");

		String fileName = multi.getFilesystemName("p_img_file");
		String imgUrl = (fileName != null) ? "images/" + fileName : "images/no-image.png";

		ProductDTO dto = new ProductDTO(0, name, category, price, stock, imgUrl, linkUrl);
		ProductDAO dao = new ProductDAO();
		dao.insertProduct(dto);

		response.sendRedirect("list");
	}
}