package model;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;

	// [기존 유지] Oracle DB 연결 설정
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

	/**
	 * [1. 단품 결제 트랜잭션]
	 */
	public boolean processOrderTransaction(OrderDTO order, int p_id, int count) {
		getConnection();
		boolean success = false;
		try {
			conn.setAutoCommit(false);

			// 1-1. 주문 메인 저장
			String sqlOrder = "INSERT INTO market_orders (order_id, userid, total_price, receiver_name, receiver_phone, address, status) "
					+ "VALUES (order_seq.NEXTVAL, ?, ?, ?, ?, ?, '결제완료')";
			pstmt = conn.prepareStatement(sqlOrder);
			pstmt.setString(1, order.getUserid());
			pstmt.setInt(2, order.getTotalPrice());
			pstmt.setString(3, order.getUserid());
			pstmt.setString(4, order.getPhone());
			pstmt.setString(5, order.getAddress());
			pstmt.executeUpdate();

			// 1-2. 상품 재고 차감
			String sqlStock = "UPDATE market_products SET p_stock = p_stock - ? WHERE p_id = ? AND p_stock >= ?";
			PreparedStatement psStock = conn.prepareStatement(sqlStock);
			psStock.setInt(1, count);
			psStock.setInt(2, p_id);
			psStock.setInt(3, count);
			int stockResult = psStock.executeUpdate();
			psStock.close();
			if (stockResult == 0)
				throw new Exception("재고 부족");

			// 1-3. 마일리지 차감
			String sqlMileage = "UPDATE member SET mileage = mileage - ? WHERE userid = ? AND mileage >= ?";
			PreparedStatement psMileage = conn.prepareStatement(sqlMileage);
			psMileage.setInt(1, order.getTotalPrice());
			psMileage.setString(2, order.getUserid());
			psMileage.setInt(3, order.getTotalPrice());
			int mileageResult = psMileage.executeUpdate();
			psMileage.close();
			if (mileageResult == 0)
				throw new Exception("마일리지 부족");

			conn.commit();
			success = true;
		} catch (Exception e) {
			try {
				if (conn != null)
					conn.rollback();
			} catch (SQLException se) {
				se.printStackTrace();
			}
			System.out.println("단품 주문 트랜잭션 실패: " + e.getMessage());
		} finally {
			close();
		}
		return success;
	}

	/**
	 * [2. 장바구니 다중 결제 트랜잭션] - 보완 완료
	 */
	public boolean insertOrderFromCart(OrderDTO order, List<CartDTO> items) {
		getConnection();
		boolean success = false;
		try {
			conn.setAutoCommit(false); // 트랜잭션 시작

			// 2-1. 주문 메인 저장 (market_orders)
			String sqlOrder = "INSERT INTO market_orders (order_id, userid, total_price, receiver_name, receiver_phone, address, status) VALUES (order_seq.NEXTVAL, ?, ?, ?, ?, ?, '결제완료')";
			pstmt = conn.prepareStatement(sqlOrder, new String[] { "order_id" });
			pstmt.setString(1, order.getUserid());
			pstmt.setInt(2, order.getTotalPrice());
			pstmt.setString(3, order.getReceiverName());
			pstmt.setString(4, order.getReceiverPhone());
			pstmt.setString(5, order.getAddress());
			pstmt.executeUpdate();

			// 생성된 주문 번호 가져오기
			rs = pstmt.getGeneratedKeys();
			int newOrderId = 0;
			if (rs.next()) {
				newOrderId = rs.getInt(1);
			}

			// 2-2. 장바구니 리스트만큼 반복하며 상세 내역 저장 및 재고 차감
			for (CartDTO item : items) {
				// 상세 품목 저장 (market_order_items)
				String sqlItem = "INSERT INTO market_order_items (order_item_id, order_id, p_id, count, order_price) VALUES (order_item_seq.NEXTVAL, ?, ?, ?, ?)";
				PreparedStatement psItem = conn.prepareStatement(sqlItem);
				psItem.setInt(1, newOrderId);
				psItem.setInt(2, item.getP_id());
				psItem.setInt(3, item.getCount());
				psItem.setInt(4, item.getProductPrice());
				psItem.executeUpdate();
				psItem.close();

				// 상품별 재고 차감
				String sqlStock = "UPDATE market_products SET p_stock = p_stock - ? WHERE p_id = ? AND p_stock >= ?";
				PreparedStatement psStock = conn.prepareStatement(sqlStock);
				psStock.setInt(1, item.getCount());
				psStock.setInt(2, item.getP_id());
				psStock.setInt(3, item.getCount());
				int stockUpdate = psStock.executeUpdate();
				psStock.close();

				if (stockUpdate == 0)
					throw new Exception("상품 번호 " + item.getP_id() + " 재고 부족");
			}

			// 2-3. 사용자 마일리지 총액 차감 (사장님 요청 보완 사항)
			String sqlMileage = "UPDATE member SET mileage = mileage - ? WHERE userid = ? AND mileage >= ?";
			PreparedStatement psMileage = conn.prepareStatement(sqlMileage);
			psMileage.setInt(1, order.getTotalPrice());
			psMileage.setString(2, order.getUserid());
			psMileage.setInt(3, order.getTotalPrice());
			int mileageUpdate = psMileage.executeUpdate();
			psMileage.close();

			if (mileageUpdate == 0)
				throw new Exception("마일리지 잔액 부족");

			conn.commit(); // 모든 단계 성공 시 일괄 반영
			success = true;
		} catch (Exception e) {
			try {
				if (conn != null)
					conn.rollback();
			} catch (SQLException se) {
				se.printStackTrace();
			}
			System.out.println("장바구니 주문 트랜잭션 실패: " + e.getMessage());
		} finally {
			close();
		}
		return success;
	}

	// [기존 유지] 주문 내역 조회
	public List<OrderDTO> getOrderList(String userid) {
		List<OrderDTO> list = new ArrayList<>();
		getConnection();
		String sql = "SELECT * FROM market_orders WHERE userid = ? ORDER BY order_date DESC";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userid);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				OrderDTO dto = new OrderDTO();
				dto.setOrderId(rs.getInt("order_id"));
				dto.setUserid(rs.getString("userid"));
				dto.setTotalPrice(rs.getInt("total_price"));
				dto.setOrderDate(rs.getTimestamp("order_date"));
				dto.setAddress(rs.getString("address"));
				dto.setStatus(rs.getString("status"));
				list.add(dto);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return list;
	}

	// [기존 유지] 관리자용 주문 상태 업데이트
	public int updateOrderStatus(int orderId, String status) {
		getConnection();
		int result = 0;
		String sql = "UPDATE market_orders SET status = ? WHERE order_id = ?";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, status);
			pstmt.setInt(2, orderId);
			result = pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return result;
	}

	// [기존 유지] 주문 삭제
	public int deleteOrder(int orderId) {
		getConnection();
		int result = 0;
		String sql = "DELETE FROM market_orders WHERE order_id = ?";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, orderId);
			result = pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return result;
	}

	// [기존 유지] 전체 주문 내역 조회
	public List<OrderDTO> getAllOrders() {
		List<OrderDTO> list = new ArrayList<>();
		getConnection();
		String sql = "SELECT * FROM market_orders ORDER BY order_date DESC";
		try {
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				OrderDTO dto = new OrderDTO();
				dto.setOrderId(rs.getInt("order_id"));
				dto.setUserid(rs.getString("userid"));
				dto.setTotalPrice(rs.getInt("total_price"));
				dto.setOrderDate(rs.getTimestamp("order_date"));
				dto.setReceiverName(rs.getString("receiver_name"));
				dto.setReceiverPhone(rs.getString("receiver_phone"));
				dto.setAddress(rs.getString("address"));
				dto.setStatus(rs.getString("status"));
				list.add(dto);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return list;
	}
}