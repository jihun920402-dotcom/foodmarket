package model;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CartDAO {
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;

	// [확정] 사장님 DB 설정: /FREEPDB1 사용
	private void getConnection() {
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521/FREEPDB1", "system", "1234");
		} catch (Exception e) {
			System.out.println("DB 연결 실패: " + e.getMessage());
		}
	}

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

	// 1. 장바구니 목록 가져오기 (마켓 최신 컬럼명 반영)
	public List<CartDTO> getCartList(String userid) {
		List<CartDTO> list = new ArrayList<>();
		getConnection();
		// SQL 스크립트의 c_id, c_count, p_name, p_price, p_img_url 컬럼명 적용
		String sql = "SELECT c.c_id, c.userid, c.p_id, c.c_count, p.p_name, p.p_price, p.p_img_url "
				+ "FROM market_cart c JOIN market_products p ON c.p_id = p.p_id " + "WHERE c.userid = ?";
		try {
			if (conn != null) {
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, userid);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					CartDTO dto = new CartDTO();
					dto.setCartId(rs.getInt("c_id")); // DB: c_id
					dto.setUserid(rs.getString("userid"));
					dto.setP_id(rs.getInt("p_id"));
					dto.setCount(rs.getInt("c_count")); // DB: c_count
					dto.setProductName(rs.getString("p_name")); // DB: p_name
					dto.setProductPrice(rs.getInt("p_price")); // DB: p_price
					dto.setImgUrl(rs.getString("p_img_url")); // DB: p_img_url
					list.add(dto);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return list;
	}

	// 2. 장바구니 추가 (시퀀스 cart_seq 및 c_count 반영)
	public int addToCart(String userid, int p_id, int count) {
		getConnection();
		int result = 0;
		// SQL 스크립트의 c_id, c_count 컬럼명 적용
		String sql = "INSERT INTO market_cart (c_id, userid, p_id, c_count) VALUES (cart_seq.NEXTVAL, ?, ?, ?)";
		try {
			if (conn != null) {
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, userid);
				pstmt.setInt(2, p_id);
				pstmt.setInt(3, count);
				result = pstmt.executeUpdate();
			}
		} catch (Exception e) {
			System.out.println("장바구니 담기 오류: " + e.getMessage());
			e.printStackTrace();
		} finally {
			close();
		}
		return result;
	}

	// 3. 장바구니 개별 삭제 (c_id 기준)
	public int deleteCart(int cartId) {
		getConnection();
		int result = 0;
		String sql = "DELETE FROM market_cart WHERE c_id = ?";
		try {
			if (conn != null) {
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, cartId);
				result = pstmt.executeUpdate();
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return result;
	}

	// 4. 장바구니 전체 비우기 (결제 완료 시)
	public void clearCart(String userid) {
		getConnection();
		String sql = "DELETE FROM market_cart WHERE userid = ?";
		try {
			if (conn != null) {
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, userid);
				pstmt.executeUpdate();
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close();
		}
	}

	// [추가] 특정 사용자의 장바구니 전체 삭제 (OrderServlet 호환용)
	public int deleteCartByUser(String userid) {
		getConnection();
		int result = 0;
		String sql = "DELETE FROM market_cart WHERE userid = ?";
		try {
			if (conn != null) {
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, userid);
				result = pstmt.executeUpdate();
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return result;
	}
}