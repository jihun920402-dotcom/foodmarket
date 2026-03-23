package model;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import common.DBConnection;

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

	// 3. 장바구니 목록 조회 (상품 정보와 JOIN)
	public List<CartDTO> getCartList(String userid) {
		List<CartDTO> list = new ArrayList<>();
		// [검증 완료] market_cart(c)와 market_products(p) 조인
		String sql = "SELECT c.c_id, c.userid, c.p_id, c.c_count, p.p_name, p.p_price, p.p_img_url "
				+ "FROM market_cart c JOIN market_products p ON c.p_id = p.p_id "
				+ "WHERE c.userid = ? ORDER BY c.c_id DESC";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, userid);
			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					CartDTO dto = new CartDTO();
					// DTO의 setter와 DB 컬럼명 매칭
					dto.setCartId(rs.getInt("c_id"));
					dto.setUserid(rs.getString("userid"));
					dto.setP_id(rs.getInt("p_id"));
					dto.setCount(rs.getInt("c_count"));
					dto.setProductName(rs.getString("p_name"));
					dto.setProductPrice(rs.getInt("p_price"));
					dto.setImgUrl(rs.getString("p_img_url"));
					list.add(dto);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	// 1. 장바구니 담기 (중복 상품은 수량만 UPDATE, 없으면 INSERT)
	public int addToCart(String userid, int p_id, int count) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int result = 0;

		try {
			conn = DBConnection.getConnection();

			// [검증 완료] 컬럼명: c_id, userid, p_id
			String checkSql = "SELECT c_id FROM market_cart WHERE userid = ? AND p_id = ?";
			pstmt = conn.prepareStatement(checkSql);
			pstmt.setString(1, userid);
			pstmt.setInt(2, p_id);
			rs = pstmt.executeQuery();

			if (rs.next()) {
				// 이미 있다면 수량(c_count)만 더하기
				int existingCId = rs.getInt("c_id");
				String updateSql = "UPDATE market_cart SET c_count = c_count + ? WHERE c_id = ?";
				pstmt.close();
				pstmt = conn.prepareStatement(updateSql);
				pstmt.setInt(1, count);
				pstmt.setInt(2, existingCId);
				result = pstmt.executeUpdate();
			} else {
				// 없다면 새로 추가 (시퀀스: cart_seq 사용)
				String insertSql = "INSERT INTO market_cart (c_id, userid, p_id, c_count) VALUES (cart_seq.NEXTVAL, ?, ?, ?)";
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
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
				if (conn != null)
					conn.close();
			} catch (Exception e) {
			}
		}
		return result;
	}

	// 4. 장바구니 개별 삭제
	public int deleteCart(int cartId) {
		String sql = "DELETE FROM market_cart WHERE c_id = ?";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, cartId);
			return ps.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		}
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

	// 2. 장바구니 수량 수정 (JSP의 +/- 버튼 연동)
	public int updateCartCount(int cartId, int newCount) {
		// [검증 완료] 컬럼명: c_count, c_id
		String sql = "UPDATE market_cart SET c_count = ? WHERE c_id = ?";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, newCount);
			ps.setInt(2, cartId);
			return ps.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		}
	}
	
	// CartDAO.java 파일 안에 추가하세요
	public CartDTO getCartItemById(int cId) {
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    CartDTO dto = null;

	    // 장바구니(market_cart)와 상품(market_products)을 조인해서 가격과 이름을 가져옵니다.
	    String sql = "SELECT c.c_id, c.userid, c.p_id, c.c_count, p.p_name, p.p_price, p.p_img_url " +
	                 "FROM market_cart c JOIN market_products p ON c.p_id = p.p_id " +
	                 "WHERE c.c_id = ?";

	    try {
	        conn = DBConnection.getConnection();
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1, cId);
	        rs = pstmt.executeQuery();

	        if (rs.next()) {
	            dto = new CartDTO();
	            // 사장님 DTO 필드명에 맞게 셋팅
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
	        try { if(rs!=null) rs.close(); if(pstmt!=null) pstmt.close(); if(conn!=null) conn.close(); } catch(Exception e) {}
	    }
	    return dto;
	}
}