package model;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import common.DBConnection;

public class ProductDAO {
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;

	// 자원 해제 공통 메서드
	private void close() {
		try {
			if (rs != null)
				rs.close();
			if (pstmt != null)
				pstmt.close();
			if (conn != null)
				conn.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// 1. 검색 + 카테고리 + 정렬 통합 조회 (리뷰 개수 및 평점 포함)
	public List<ProductDTO> getProductList(String keyword, String category, String sort) {
		List<ProductDTO> list = new ArrayList<>();

		StringBuilder sql = new StringBuilder(
			"SELECT p.*,"
			+ " (SELECT COUNT(*) FROM market_reviews r WHERE r.p_id = p.p_id) as review_cnt,"
			+ " (SELECT AVG(rating) FROM market_reviews r WHERE r.p_id = p.p_id) as avg_rate"
			+ " FROM market_products p WHERE 1=1"
		);

		if (category != null && !category.isEmpty()) {
			sql.append(" AND p.p_category = ?");
		}
		if (keyword != null && !keyword.isEmpty()) {
			sql.append(" AND p.p_name LIKE ?");
		}

		switch (sort == null ? "" : sort) {
			case "price_asc":  sql.append(" ORDER BY p.p_price ASC");  break;
			case "price_desc": sql.append(" ORDER BY p.p_price DESC"); break;
			default:           sql.append(" ORDER BY p.p_id DESC");    break;
		}

		try {
			conn = DBConnection.getConnection();
			pstmt = conn.prepareStatement(sql.toString());

			int idx = 1;
			if (category != null && !category.isEmpty()) {
				pstmt.setString(idx++, category);
			}
			if (keyword != null && !keyword.isEmpty()) {
				pstmt.setString(idx++, "%" + keyword + "%");
			}

			rs = pstmt.executeQuery();
			while (rs.next()) {
				ProductDTO dto = new ProductDTO(rs.getInt("p_id"), rs.getString("p_name"), rs.getString("p_category"),
						rs.getInt("p_price"), rs.getInt("p_stock"), rs.getString("p_img_url"),
						rs.getString("p_link_url"));
				dto.setReviewCount(rs.getInt("review_cnt"));
				dto.setAvgRating(Math.round(rs.getDouble("avg_rate") * 10) / 10.0);
				list.add(dto);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return list;
	}

	// 3. 특정 상품 상세 조회 (ID 기준)
	public ProductDTO getProductById(int id) {
		String sql = "SELECT * FROM market_products WHERE p_id = ?";
		try {
			conn = DBConnection.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, id);
			rs = pstmt.executeQuery();

			if (rs.next()) {
				return new ProductDTO(rs.getInt("p_id"), rs.getString("p_name"), rs.getString("p_category"),
						rs.getInt("p_price"), rs.getInt("p_stock"), rs.getString("p_img_url"),
						rs.getString("p_link_url"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return null;
	}

	// 4. 상품 등록 (INSERT)
	// [수정] PostgreSQL SERIAL 사용: p_id 컬럼과 market_seq.NEXTVAL을 제거했습니다.
	public int insertProduct(ProductDTO dto) {
		String sql = "INSERT INTO market_products (p_name, p_category, p_price, p_stock, p_img_url, p_link_url) "
				+ "VALUES (?, ?, ?, ?, ?, ?)";
		try {
			conn = DBConnection.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getName());
			pstmt.setString(2, dto.getCategory());
			pstmt.setInt(3, dto.getPrice());
			pstmt.setInt(4, dto.getStock());
			pstmt.setString(5, dto.getImgUrl());
			pstmt.setString(6, dto.getLinkUrl());
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		} finally {
			close();
		}
	}

	// 5. 상품 수정
	public int updateProduct(ProductDTO dto) {
		String sql = "UPDATE market_products SET p_name=?, p_category=?, p_price=?, p_stock=?, p_img_url=?, p_link_url=? WHERE p_id=?";
		try {
			conn = DBConnection.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getName());
			pstmt.setString(2, dto.getCategory());
			pstmt.setInt(3, dto.getPrice());
			pstmt.setInt(4, dto.getStock());
			pstmt.setString(5, dto.getImgUrl());
			pstmt.setString(6, dto.getLinkUrl());
			pstmt.setInt(7, dto.getId());
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		} finally {
			close();
		}
	}

	// 6. 상품 삭제 (트랜잭션 적용)
	public int deleteProduct(int id) {
		try {
			conn = DBConnection.getConnection();
			conn.setAutoCommit(false); // 트랜잭션 시작

			// 1) 리뷰 삭제
			String sqlReview = "DELETE FROM market_reviews WHERE p_id = ?";
			pstmt = conn.prepareStatement(sqlReview);
			pstmt.setInt(1, id);
			pstmt.executeUpdate();
			pstmt.close();

			// 2) 장바구니 삭제
			String sqlCart = "DELETE FROM market_cart WHERE p_id = ?";
			pstmt = conn.prepareStatement(sqlCart);
			pstmt.setInt(1, id);
			pstmt.executeUpdate();
			pstmt.close();

			// 3) 본 상품 삭제
			String sqlProduct = "DELETE FROM market_products WHERE p_id = ?";
			pstmt = conn.prepareStatement(sqlProduct);
			pstmt.setInt(1, id);
			int result = pstmt.executeUpdate();

			conn.commit(); // 모두 성공 시 확정
			return result;
		} catch (Exception e) {
			try {
				if (conn != null)
					conn.rollback();
			} catch (SQLException se) {
			}
			e.printStackTrace();
			return 0;
		} finally {
			close();
		}
	}
}