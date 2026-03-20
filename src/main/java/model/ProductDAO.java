package model;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import common.DBConnection;

public class ProductDAO {

	// 1. 전체 상품 조회 (리뷰 개수 및 평점 포함)
	public List<ProductDTO> getAllProducts() {
		List<ProductDTO> list = new ArrayList<>();
		// 서브쿼리를 이용해 리뷰 정보를 한 번에 가져오는 효율적인 방식입니다.
		String sql = "SELECT p.*, " + " (SELECT COUNT(*) FROM market_reviews r WHERE r.p_id = p.p_id) as review_cnt, "
				+ " (SELECT AVG(rating) FROM market_reviews r WHERE r.p_id = p.p_id) as avg_rate "
				+ "FROM market_products p ORDER BY p.p_id DESC";

		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {

			while (rs.next()) {
				ProductDTO dto = new ProductDTO(rs.getInt("p_id"), rs.getString("p_name"), rs.getString("p_category"),
						rs.getInt("p_price"), rs.getInt("p_stock"), rs.getString("p_img_url"),
						rs.getString("p_link_url"));
				dto.setReviewCount(rs.getInt("review_cnt"));
				// 평점 소수점 첫째 자리 반올림
				dto.setAvgRating(Math.round(rs.getDouble("avg_rate") * 10) / 10.0);
				list.add(dto);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	// 2. 카테고리별 조회
	public List<ProductDTO> getProductsByCategory(String category) {
		List<ProductDTO> list = new ArrayList<>();
		String sql = "SELECT p.*, " + " (SELECT COUNT(*) FROM market_reviews r WHERE r.p_id = p.p_id) as review_cnt, "
				+ " (SELECT AVG(rating) FROM market_reviews r WHERE r.p_id = p.p_id) as avg_rate "
				+ "FROM market_products p WHERE p.p_category = ? ORDER BY p.p_id DESC";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setString(1, category);
			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					ProductDTO dto = new ProductDTO(rs.getInt("p_id"), rs.getString("p_name"),
							rs.getString("p_category"), rs.getInt("p_price"), rs.getInt("p_stock"),
							rs.getString("p_img_url"), rs.getString("p_link_url"));
					dto.setReviewCount(rs.getInt("review_cnt"));
					dto.setAvgRating(Math.round(rs.getDouble("avg_rate") * 10) / 10.0);
					list.add(dto);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	// 3. 특정 상품 상세 조회 (ID 기준)
	public ProductDTO getProductById(int id) {
		String sql = "SELECT * FROM market_products WHERE p_id = ?";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, id);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					return new ProductDTO(rs.getInt("p_id"), rs.getString("p_name"), rs.getString("p_category"),
							rs.getInt("p_price"), rs.getInt("p_stock"), rs.getString("p_img_url"),
							rs.getString("p_link_url"));
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	// 4. 상품 등록
	public int insertProduct(ProductDTO dto) {
		String sql = "INSERT INTO market_products (p_id, p_name, p_category, p_price, p_stock, p_img_url, p_link_url) "
				+ "VALUES (market_seq.NEXTVAL, ?, ?, ?, ?, ?, ?)";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setString(1, dto.getName());
			ps.setString(2, dto.getCategory());
			ps.setInt(3, dto.getPrice());
			ps.setInt(4, dto.getStock());
			ps.setString(5, dto.getImgUrl());
			ps.setString(6, dto.getLinkUrl());
			return ps.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		}
	}

	// 5. 상품 수정
	public int updateProduct(ProductDTO dto) {
		String sql = "UPDATE market_products SET p_name=?, p_category=?, p_price=?, p_stock=?, p_img_url=?, p_link_url=? WHERE p_id=?";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setString(1, dto.getName());
			ps.setString(2, dto.getCategory());
			ps.setInt(3, dto.getPrice());
			ps.setInt(4, dto.getStock());
			ps.setString(5, dto.getImgUrl());
			ps.setString(6, dto.getLinkUrl());
			ps.setInt(7, dto.getId());
			return ps.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		}
	}

	// 6. 상품 삭제 (리뷰/장바구니 자식 레코드 대응 포함)
	public int deleteProduct(int id) {
		// [중요] 상품을 삭제하려면 먼저 해당 상품을 참조하는 리뷰와 장바구니 데이터를 지워야 합니다.
		try (Connection conn = DBConnection.getConnection()) {
			conn.setAutoCommit(false); // 트랜잭션 시작

			// 1) 리뷰 삭제
			String sqlReview = "DELETE FROM market_reviews WHERE p_id = ?";
			try (PreparedStatement ps = conn.prepareStatement(sqlReview)) {
				ps.setInt(1, id);
				ps.executeUpdate();
			}

			// 2) 장바구니 삭제
			String sqlCart = "DELETE FROM market_cart WHERE p_id = ?";
			try (PreparedStatement ps = conn.prepareStatement(sqlCart)) {
				ps.setInt(1, id);
				ps.executeUpdate();
			}

			// 3) 본 상품 삭제
			String sqlProduct = "DELETE FROM market_products WHERE p_id = ?";
			try (PreparedStatement ps = conn.prepareStatement(sqlProduct)) {
				ps.setInt(1, id);
				int result = ps.executeUpdate();
				conn.commit(); // 모두 성공 시 확정
				return result;
			}
		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		}
	}
}