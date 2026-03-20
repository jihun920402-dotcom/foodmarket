package controller;

import java.io.File;
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
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// 1. 한글 인코딩 설정
		request.setCharacterEncoding("UTF-8");

		// 2. 이미지 저장 경로 설정 (WebContent/images 또는 webapp/images)
		String savePath = request.getServletContext().getRealPath("images");

		// 폴더가 없으면 생성하는 로직
		File targetDir = new File(savePath);
		if (!targetDir.exists()) {
			targetDir.mkdirs();
		}

		// 파일 최대 크기 (10MB)
		int maxSize = 10 * 1024 * 1024;

		try {
			// 3. MultipartRequest 생성 (파일 업로드 수행)
			// 인코딩을 UTF-8로 지정하여 한글 파일명 깨짐 방지
			MultipartRequest multi = new MultipartRequest(request, savePath, maxSize, "UTF-8",
					new DefaultFileRenamePolicy());

			// 4. 파라미터 수집 (반드시 multi 객체 사용)
			// JSP의 <input name="p_id"> 등과 일치해야 함
			int id = Integer.parseInt(multi.getParameter("p_id"));
			String name = multi.getParameter("p_name");
			String category = multi.getParameter("p_category");
			int price = Integer.parseInt(multi.getParameter("p_price"));
			int stock = Integer.parseInt(multi.getParameter("p_stock"));
			String linkUrl = multi.getParameter("p_link_url");

			// 5. 이미지 경로 처리
			// 새 이미지가 업로드되었는지 확인
			String fileName = multi.getFilesystemName("p_img_url");

			ProductDAO dao = new ProductDAO();
			String imgUrl = null;

			if (fileName == null || fileName.trim().isEmpty()) {
				// 새 파일이 없으면 기존 DB에 저장된 이미지 경로를 그대로 사용
				ProductDTO oldProduct = dao.getProductById(id);
				if (oldProduct != null) {
					imgUrl = oldProduct.getImgUrl();
				}
			} else {
				// 새 파일이 있으면 "images/파일명" 형태로 경로 생성
				imgUrl = "images/" + fileName;
			}

			// 6. DTO 객체 생성 및 DB 반영
			// ProductDTO 생성자 파라미터 순서를 확인하세요 (id, name, category, price, stock, imgUrl,
			// linkUrl)
			ProductDTO dto = new ProductDTO(id, name, category, price, stock, imgUrl, linkUrl);
			int result = dao.updateProduct(dto);

			// 7. 결과 알림 및 페이지 이동
			// [주의] 만약 관리자 상품 목록 페이지 파일명이 다르면 아래 이름을 수정하세요.
			if (result > 0) {
				// 성공 시 목록으로 이동 (성공 파라미터 전달)
				response.sendRedirect("list?updateSuccess=1");
			} else {
				// 실패 시 에러 파라미터 전달
				response.sendRedirect("list?error=1");
			}

		} catch (Exception e) {
			e.printStackTrace();
			// 에러 발생 시 로그 출력 후 목록으로 리다이렉트
			response.sendRedirect("list?error=upload_fail");
		}
	}

	// GET 요청이 들어올 경우를 대비한 처리 (선택사항)
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doPost(request, response);
	}
}