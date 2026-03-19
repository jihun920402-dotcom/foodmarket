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

@WebServlet("/UpdateServlet")
public class UpdateServlet extends HttpServlet {
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String savePath = request.getServletContext().getRealPath("images");
		int maxSize = 10 * 1024 * 1024;
		MultipartRequest multi = new MultipartRequest(request, savePath, maxSize, "UTF-8",
				new DefaultFileRenamePolicy());

		int id = Integer.parseInt(multi.getParameter("p_id"));
		String name = multi.getParameter("p_name");
		String category = multi.getParameter("p_category");
		int price = Integer.parseInt(multi.getParameter("p_price"));
		int stock = Integer.parseInt(multi.getParameter("p_stock"));
		String linkUrl = multi.getParameter("p_link_url");

		String fileName = multi.getFilesystemName("p_img_url");
		ProductDAO dao = new ProductDAO();
		String imgUrl;

		if (fileName == null || fileName.isEmpty()) {
			// 새 파일이 없으면 기존 DB의 경로 유지
			ProductDTO old = dao.getProductById(id);
			imgUrl = old.getImgUrl();
		} else {
			// 새 파일이 있으면 접두어 추가
			imgUrl = "images/" + fileName;
		}

		ProductDTO dto = new ProductDTO(id, name, category, price, stock, imgUrl, linkUrl);
		dao.updateProduct(dto);

		response.sendRedirect("list");
	}
}