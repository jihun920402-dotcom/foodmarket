package model;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.sql.Date;

public class ReviewDAO {
	private Connection conn;
	private PreparedStatement ps;
	private ResultSet rs;

	private void getConnection() {
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			String url = "jdbc:oracle:thin:@localhost:1521/FREEPDB1";
			// 아이디: system / 비밀번호: 1234 반영
			conn = DriverManager.getConnection(url, "system", "1234");
		} catch (Exception e) {
			System.out.println("❌ DB 연결 실패: " + e.getMessage());
		}
	}

	private void closeAll() {
		try {
			if (rs != null)
				rs.close();
			if (ps != null)
				ps.close();
			if (conn != null)
				conn.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// 1. 리뷰 등록 (AddReviewServlet 호환)
	public int insertReview(int p_id, String userid, String content, int rating) {
		// 테이블명을 market_reviews로 정확히 수정했습니다.
		String sql = "INSERT INTO market_reviews (r_id, p_id, userid, content, rating, r_date) "
				+ "VALUES (review_seq.NEXTVAL, ?, ?, ?, ?, SYSDATE)";
		int result = 0;
		try {
			getConnection();
			if (conn != null) {
				ps = conn.prepareStatement(sql);
				ps.setInt(1, p_id);
				ps.setString(2, userid);
				ps.setString(3, content);
				ps.setInt(4, rating);
				result = ps.executeUpdate();
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			closeAll();
		}
		return result;
	}

	// 2. 리뷰 목록 조회 (ProductDetailServlet 호환)
	public List<ReviewDTO> getReviewsByProduct(int p_id) {
		// 테이블명을 market_reviews로 정확히 수정했습니다.
		String sql = "SELECT * FROM market_reviews WHERE p_id = ? ORDER BY r_date DESC";
		List<ReviewDTO> list = new ArrayList<>();
		try {
			getConnection();
			if (conn != null) {
				ps = conn.prepareStatement(sql);
				ps.setInt(1, p_id);
				rs = ps.executeQuery();
				while (rs.next()) {
					ReviewDTO r = new ReviewDTO();
					r.setR_id(rs.getInt("r_id"));
					r.setP_id(rs.getInt("p_id"));
					r.setUserid(rs.getString("userid"));
					r.setContent(rs.getString("content"));
					r.setRating(rs.getInt("rating"));
					r.setR_date(rs.getDate("r_date")); // Date 타입 호환
					list.add(r);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			closeAll();
		}
		return list;
	}

	// 3. 리뷰 수정 (UpdateReviewServlet 호환)
	public void updateReview(int r_id, String content, int rating) {
		// 테이블명을 market_reviews로 정확히 수정했습니다.
		String sql = "UPDATE market_reviews SET content = ?, rating = ? WHERE r_id = ?";
		try {
			getConnection();
			if (conn != null) {
				ps = conn.prepareStatement(sql);
				ps.setString(1, content);
				ps.setInt(2, rating);
				ps.setInt(3, r_id);
				ps.executeUpdate();
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			closeAll();
		}
	}

	// 4. 리뷰 삭제 (DeleteReviewServlet 호환)
	public int deleteReview(int r_id) {
		// 테이블명을 market_reviews로 정확히 수정했습니다.
		String sql = "DELETE FROM market_reviews WHERE r_id = ?";
		int result = 0;
		try {
			getConnection();
			if (conn != null) {
				ps = conn.prepareStatement(sql);
				ps.setInt(1, r_id);
				result = ps.executeUpdate();
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			closeAll();
		}
		return result;
	}
}