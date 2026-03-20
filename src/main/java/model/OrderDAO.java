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

			String sqlOrder = "INSERT INTO market_orders (order_id, userid, total_price, receiver_name, receiver_phone, address, status) "
					+ "VALUES (order_seq.NEXTVAL, ?, ?, ?, ?, ?, '결제완료')";
			pstmt = conn.prepareStatement(sqlOrder);
			pstmt.setString(1, order.getUserid());
			pstmt.setInt(2, order.getTotalPrice());
			pstmt.setString(3, order.getUserid());
			pstmt.setString(4, order.getPhone());
			pstmt.setString(5, order.getAddress());
			pstmt.executeUpdate();

			String sqlStock = "UPDATE market_products SET p_stock = p_stock - ? WHERE p_id = ? AND p_stock >= ?";
			PreparedStatement psStock = conn.prepareStatement(sqlStock);
			psStock.setInt(1, count);
			psStock.setInt(2, p_id);
			psStock.setInt(3, count);
			int stockResult = psStock.executeUpdate();
			psStock.close();
			if (stockResult == 0)
				throw new Exception("재고 부족");

			// 수정: 테이블명 market_members
			String sqlMileage = "UPDATE market_members SET mileage = mileage - ? WHERE userid = ? AND mileage >= ?";
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
	 * [2. 장바구니 다중 결제 트랜잭션] 수정 내용: 1. 컬럼명 order_item_id -> ITEM_ID 로 변경 (사장님 DB 기준)
	 * 2. ITEM_ID에 시퀀스(order_item_seq.NEXTVAL) 직접 주입하여 NULL 에러 방지 3. 마일리지 차감 테이블명
	 * market_members 반영
	 */
	public boolean insertOrderFromCart(OrderDTO order, List<CartDTO> items) {
		getConnection();
		boolean success = false;
		try {
			conn.setAutoCommit(false);

			// 1. 주문 메인 저장 (market_orders)
			String sqlOrder = "INSERT INTO market_orders (order_id, userid, total_price, receiver_name, receiver_phone, address, status) VALUES (order_seq.NEXTVAL, ?, ?, ?, ?, ?, '결제완료')";
			pstmt = conn.prepareStatement(sqlOrder, new String[] { "order_id" });
			pstmt.setString(1, order.getUserid());
			pstmt.setInt(2, order.getTotalPrice());
			pstmt.setString(3, order.getReceiverName());
			pstmt.setString(4, order.getReceiverPhone());
			pstmt.setString(5, order.getAddress());
			pstmt.executeUpdate();

			rs = pstmt.getGeneratedKeys();
			int newOrderId = 0;
			if (rs.next()) {
				newOrderId = rs.getInt(1);
			}

			// 2. 주문 상세 저장 (에러 발생 지점 수정)
			for (CartDTO item : items) {
				// 사장님 DB 컬럼명인 ITEM_ID를 사용하고 시퀀스를 명시적으로 넣습니다.
				String sqlItem = "INSERT INTO market_order_items (ITEM_ID, order_id, p_id, count, order_price) VALUES (order_item_seq.NEXTVAL, ?, ?, ?, ?)";
				PreparedStatement psItem = conn.prepareStatement(sqlItem);
				psItem.setInt(1, newOrderId);
				psItem.setInt(2, item.getP_id());
				psItem.setInt(3, item.getCount());
				psItem.setInt(4, item.getProductPrice());
				psItem.executeUpdate();
				psItem.close();

				// 재고 차감 (기존 로직 유지)
				String sqlStock = "UPDATE market_products SET p_stock = p_stock - ? WHERE p_id = ? AND p_stock >= ?";
				PreparedStatement psStock = conn.prepareStatement(sqlStock);
				psStock.setInt(1, item.getCount());
				psStock.setInt(2, item.getP_id());
				psStock.setInt(3, item.getCount());
				psStock.executeUpdate();
				psStock.close();
			}

			// 3. 마일리지 차감 (테이블명: market_members)
			String sqlMileage = "UPDATE market_members SET mileage = mileage - ? WHERE userid = ? AND mileage >= ?";
			PreparedStatement psMileage = conn.prepareStatement(sqlMileage);
			psMileage.setInt(1, order.getTotalPrice());
			psMileage.setString(2, order.getUserid());
			psMileage.setInt(3, order.getTotalPrice());
			int mileageUpdate = psMileage.executeUpdate();
			psMileage.close();

			if (mileageUpdate == 0)
				throw new Exception("마일리지 잔액 부족");

			conn.commit();
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

	/**
	 * [3. 주문 아이디로 단일 주문 조회] - 상세페이지(25번 라인) 해결
	 */
	public OrderDTO getOrderById(int orderId) {
		OrderDTO dto = null;
		getConnection();
		String sql = "SELECT * FROM market_orders WHERE order_id = ?";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, orderId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				dto = new OrderDTO();
				dto.setOrderId(rs.getInt("order_id"));
				dto.setUserid(rs.getString("userid"));
				dto.setTotalPrice(rs.getInt("total_price"));
				dto.setOrderDate(rs.getTimestamp("order_date"));
				dto.setReceiverName(rs.getString("receiver_name"));
				dto.setReceiverPhone(rs.getString("receiver_phone"));
				dto.setAddress(rs.getString("address"));
				dto.setStatus(rs.getString("status"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return dto;
	}

	/**
	 * [4. 특정 주문의 상세 품목 조회] 수정 내용: 사장님 DB 컬럼명 (p_img -> p_img_url) 반영 완료
	 */
	public List<CartDTO> getOrderDetailItems(int orderId) {
		List<CartDTO> list = new ArrayList<>();
		getConnection();

		// DB 설계도에 맞춰 p.p_img를 p.p_img_url로 변경했습니다.
		String sql = "SELECT i.p_id, p.p_name, p.p_img_url, i.count, i.order_price " + "FROM market_order_items i "
				+ "JOIN market_products p ON i.p_id = p.p_id " + "WHERE i.order_id = ?";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, orderId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				CartDTO item = new CartDTO();
				item.setP_id(rs.getInt("p_id"));
				item.setProductName(rs.getString("p_name"));

				// ResultSet에서도 p_img_url로 가져옵니다.
				item.setImgUrl(rs.getString("p_img_url"));

				item.setCount(rs.getInt("count"));
				item.setProductPrice(rs.getInt("order_price"));
				list.add(item);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return list;
	}

	/**
	 * [사용자용 주문 내역 조회] DB 테이블(market_orders)의 컬럼명과 100% 매칭 완료
	 */
	public List<OrderDTO> getOrderList(String userid) {
		List<OrderDTO> list = new ArrayList<>();
		getConnection();
		// 최신 DB 구조 반영: order_date, total_price, address, status
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
				dto.setReceiverName(rs.getString("receiver_name")); // DB: receiver_name
				dto.setReceiverPhone(rs.getString("receiver_phone")); // DB: receiver_phone
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

	/**
	 * [기존 유지] 관리자용 주문 상태 업데이트
	 */
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

	/**
	 * [주문 취소/삭제 통합 로직] 1. 마일리지 환불 (market_members) 2. 상품 재고 복구 (market_products) 3.
	 * 주문 내역 삭제 (market_order_items, market_orders)
	 */
	public int deleteOrder(int orderId) {
		getConnection();
		int result = 0;

		try {
			// [중요] 돈과 재고가 걸린 문제이므로 자동 커밋을 끕니다.
			conn.setAutoCommit(false);

			// 1. 환불 정보를 위해 주문 메인 정보 조회
			String sqlSelectOrder = "SELECT userid, total_price FROM market_orders WHERE order_id = ?";
			pstmt = conn.prepareStatement(sqlSelectOrder);
			pstmt.setInt(1, orderId);
			rs = pstmt.executeQuery();

			String orderUserid = null;
			int refundAmount = 0;
			if (rs.next()) {
				orderUserid = rs.getString("userid");
				refundAmount = rs.getInt("total_price");
			}
			rs.close();
			pstmt.close();

			if (orderUserid != null) {
				// 2. 마일리지 복구 (UPDATE market_members)
				String sqlRefund = "UPDATE market_members SET mileage = mileage + ? WHERE userid = ?";
				pstmt = conn.prepareStatement(sqlRefund);
				pstmt.setInt(1, refundAmount);
				pstmt.setString(2, orderUserid);
				pstmt.executeUpdate();
				pstmt.close();

				// 3. 재고 복구 (주문 상세 내역을 돌면서 각 상품 재고를 늘림)
				String sqlSelectItems = "SELECT p_id, count FROM market_order_items WHERE order_id = ?";
				pstmt = conn.prepareStatement(sqlSelectItems);
				pstmt.setInt(1, orderId);
				ResultSet rsItems = pstmt.executeQuery();

				// 재고 업데이트용 쿼리 (market_products 테이블의 p_stock 컬럼 사용)
				String sqlRestoreStock = "UPDATE market_products SET p_stock = p_stock + ? WHERE p_id = ?";
				PreparedStatement psStock = conn.prepareStatement(sqlRestoreStock);

				while (rsItems.next()) {
					int p_id = rsItems.getInt("p_id");
					int count = rsItems.getInt("count");

					psStock.setInt(1, count);
					psStock.setInt(2, p_id);
					psStock.executeUpdate();
				}
				rsItems.close();
				psStock.close();
				pstmt.close();

				// 4. 주문 상세 내역 삭제 (자식 레코드)
				String sqlDeleteItems = "DELETE FROM market_order_items WHERE order_id = ?";
				pstmt = conn.prepareStatement(sqlDeleteItems);
				pstmt.setInt(1, orderId);
				pstmt.executeUpdate();
				pstmt.close();

				// 5. 주문 메인 삭제 (부모 레코드)
				String sqlDeleteOrder = "DELETE FROM market_orders WHERE order_id = ?";
				pstmt = conn.prepareStatement(sqlDeleteOrder);
				pstmt.setInt(1, orderId);
				result = pstmt.executeUpdate();
			}

			// 모든 로직이 성공했을 때만 DB에 최종 반영
			conn.commit();
			System.out.println("주문 취소 성공: 마일리지 및 재고 복구 완료");

		} catch (Exception e) {
			try {
				if (conn != null)
					conn.rollback(); // 하나라도 에러나면 모든 작업을 취소함
			} catch (SQLException se) {
				se.printStackTrace();
			}
			e.printStackTrace();
		} finally {
			close();
		}
		return result;
	}

	/**
	 * [관리자용 전체 주문 조회] 모든 주문 건을 최신순으로 가져옴
	 */
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
