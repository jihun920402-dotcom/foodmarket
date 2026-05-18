package model;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import common.DBConnection;

public class CartDAO {
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;

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

	// 1. 장바구니 담기 (중복 상품은 수량만 UPDATE, 없으면 INSERT)
	public int addToCart(String userid, int p_id, int count) {
		int result = 0;
		try {
			// common.DBConnection도 PostgreSQL 설정으로 되어있어야 합니다.
			conn = DBConnection.getConnection();

			// 중복 체크
			String checkSql = "SELECT c_id FROM market_cart WHERE userid = ? AND p_id = ?";
			pstmt = conn.prepareStatement(checkSql);
			pstmt.setString(1, userid);
			pstmt.setInt(2, p_id);
			rs = pstmt.executeQuery();

			if (rs.next()) {
				// 이미 있다면 수량(c_count) 업데이트
				int existingCId = rs.getInt("c_id");
				String updateSql = "UPDATE market_cart SET c_count = c_count + ? WHERE c_id = ?";
				pstmt.close();
				pstmt = conn.prepareStatement(updateSql);
				pstmt.setInt(1, count);
				pstmt.setInt(2, existingCId);
				result = pstmt.executeUpdate();
			} else {
				// [수정] PostgreSQL SERIAL 사용: c_id와 NEXTVAL을 제거함
				String insertSql = "INSERT INTO market_cart (userid, p_id, c_count) VALUES (?, ?, ?)";
				pstmt.close();
				pstmt = conn.prepareStatement(insertSql);
				pstmt.setString(1, userid);
				pstmt.setInt(2, p_id);
				pstmt.setInt(3, count);
				result = pstmt.executeUpdate();
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return result;
	}

	// 2. 장바구니 목록 조회
	public List<CartDTO> getCartList(String userid) {
		List<CartDTO> list = new ArrayList<>();
		String sql = "SELECT c.c_id, c.userid, c.p_id, c.c_count, p.p_name, p.p_price, p.p_img_url "
				+ "FROM market_cart c JOIN market_products p ON c.p_id = p.p_id "
				+ "WHERE c.userid = ? ORDER BY c.c_id DESC";

		try {
			conn = DBConnection.getConnection();
			pstmt = conn.prepareStatement(sql); // 여기서 변수명을 pstmt로 통일했습니다.
			pstmt.setString(1, userid);         // ps -> pstmt로 수정
			rs = pstmt.executeQuery();          // ps -> pstmt로 수정
			
			while (rs.next()) {
				CartDTO dto = new CartDTO();
				dto.setCartId(rs.getInt("c_id"));
				dto.setUserid(rs.getString("userid"));
				dto.setP_id(rs.getInt("p_id"));
				dto.setCount(rs.getInt("c_count"));
				dto.setProductName(rs.getString("p_name"));
				dto.setProductPrice(rs.getInt("p_price"));
				dto.setImgUrl(rs.getString("p_img_url"));
				list.add(dto);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return list;
	}

	// 3. 장바구니 수량 수정
	public int updateCartCount(int cartId, int newCount) {
		String sql = "UPDATE market_cart SET c_count = ? WHERE c_id = ?";
		try {
			conn = DBConnection.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, newCount);
			pstmt.setInt(2, cartId);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		} finally {
			close();
		}
	}

	// 4. 개별 삭제
	public int deleteCart(int cartId) {
		String sql = "DELETE FROM market_cart WHERE c_id = ?";
		try {
			conn = DBConnection.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, cartId);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		} finally {
			close();
		}
	}

	// 5. 전체 비우기
	public void clearCart(String userid) {
		String sql = "DELETE FROM market_cart WHERE userid = ?";
		try {
			conn = DBConnection.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userid);
			pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close();
		}
	}

	// 6. 특정 사용자 전체 삭제 (OrderServlet용)
	public int deleteCartByUser(String userid) {
		int result = 0;
		String sql = "DELETE FROM market_cart WHERE userid = ?";
		try {
			conn = DBConnection.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userid);
			result = pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return result;
	}

	// 7. 아이템 하나 정보 가져오기
	public CartDTO getCartItemById(int cId) {
		CartDTO dto = null;
		String sql = "SELECT c.c_id, c.userid, c.p_id, c.c_count, p.p_name, p.p_price, p.p_img_url "
				+ "FROM market_cart c JOIN market_products p ON c.p_id = p.p_id " + "WHERE c.c_id = ?";
		try {
			conn = DBConnection.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, cId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				dto = new CartDTO();
				dto.setCartId(rs.getInt("c_id"));
				dto.setUserid(rs.getString("userid"));
				dto.setP_id(rs.getInt("p_id"));
				dto.setCount(rs.getInt("c_count"));
				dto.setProductName(rs.getString("p_name"));
				dto.setProductPrice(rs.getInt("p_price"));
				dto.setImgUrl(rs.getString("p_img_url"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return dto;
	}
}