package model;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import common.DBConnection;

public class OrderDAO {
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

	public boolean processOrderTransaction(OrderDTO order, int p_id, int count) {
		conn = DBConnection.getConnection();
		boolean success = false;
		try {
			conn.setAutoCommit(false);

			String sqlOrder = "INSERT INTO market_orders (userid, total_price, receiver_name, receiver_phone, address, status, order_date) "
					+ "VALUES (?, ?, ?, ?, ?, '결제완료', CURRENT_TIMESTAMP)";
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
			}
			System.out.println("단품 주문 트랜잭션 실패: " + e.getMessage());
		} finally {
			close();
		}
		return success;
	}

	public boolean insertOrderFromCart(OrderDTO order, List<CartDTO> items) {
		conn = DBConnection.getConnection();
		boolean success = false;
		try {
			conn.setAutoCommit(false);

			String sqlOrder = "INSERT INTO market_orders (userid, total_price, receiver_name, receiver_phone, address, status, order_date) "
					+ "VALUES (?, ?, ?, ?, ?, '결제완료', CURRENT_TIMESTAMP)";
			pstmt = conn.prepareStatement(sqlOrder, Statement.RETURN_GENERATED_KEYS);
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

			for (CartDTO item : items) {
				String sqlItem = "INSERT INTO market_order_items (order_id, p_id, count, order_price) VALUES (?, ?, ?, ?)";
				PreparedStatement psItem = conn.prepareStatement(sqlItem);
				psItem.setInt(1, newOrderId);
				psItem.setInt(2, item.getP_id());
				psItem.setInt(3, item.getCount());
				psItem.setInt(4, item.getProductPrice());
				psItem.executeUpdate();
				psItem.close();

				String sqlStock = "UPDATE market_products SET p_stock = p_stock - ? WHERE p_id = ? AND p_stock >= ?";
				PreparedStatement psStock = conn.prepareStatement(sqlStock);
				psStock.setInt(1, item.getCount());
				psStock.setInt(2, item.getP_id());
				psStock.setInt(3, item.getCount());
				psStock.executeUpdate();
				psStock.close();
			}

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
			}
			System.out.println("장바구니 주문 트랜잭션 실패: " + e.getMessage());
		} finally {
			close();
		}
		return success;
	}

	public OrderDTO getOrderById(int orderId) {
		OrderDTO dto = null;
		conn = DBConnection.getConnection();
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

	public List<CartDTO> getOrderDetailItems(int orderId) {
		List<CartDTO> list = new ArrayList<>();
		conn = DBConnection.getConnection();
		String sql = "SELECT i.p_id, p.p_name, p.p_img_url, i.count, i.order_price "
				+ "FROM market_order_items i "
				+ "JOIN market_products p ON i.p_id = p.p_id "
				+ "WHERE i.order_id = ?";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, orderId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				CartDTO item = new CartDTO();
				item.setP_id(rs.getInt("p_id"));
				item.setProductName(rs.getString("p_name"));
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

	public List<OrderDTO> getOrderList(String userid) {
		List<OrderDTO> list = new ArrayList<>();
		conn = DBConnection.getConnection();
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

	public int updateOrderStatus(int orderId, String status) {
		conn = DBConnection.getConnection();
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

	public int deleteOrder(int orderId) {
		conn = DBConnection.getConnection();
		int result = 0;
		try {
			conn.setAutoCommit(false);

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
				String sqlRefund = "UPDATE market_members SET mileage = mileage + ? WHERE userid = ?";
				pstmt = conn.prepareStatement(sqlRefund);
				pstmt.setInt(1, refundAmount);
				pstmt.setString(2, orderUserid);
				pstmt.executeUpdate();
				pstmt.close();

				String sqlSelectItems = "SELECT p_id, count FROM market_order_items WHERE order_id = ?";
				pstmt = conn.prepareStatement(sqlSelectItems);
				pstmt.setInt(1, orderId);
				ResultSet rsItems = pstmt.executeQuery();

				String sqlRestoreStock = "UPDATE market_products SET p_stock = p_stock + ? WHERE p_id = ?";
				PreparedStatement psStock = conn.prepareStatement(sqlRestoreStock);
				while (rsItems.next()) {
					psStock.setInt(1, rsItems.getInt("count"));
					psStock.setInt(2, rsItems.getInt("p_id"));
					psStock.executeUpdate();
				}
				rsItems.close();
				psStock.close();
				pstmt.close();

				String sqlDeleteItems = "DELETE FROM market_order_items WHERE order_id = ?";
				pstmt = conn.prepareStatement(sqlDeleteItems);
				pstmt.setInt(1, orderId);
				pstmt.executeUpdate();
				pstmt.close();

				String sqlDeleteOrder = "DELETE FROM market_orders WHERE order_id = ?";
				pstmt = conn.prepareStatement(sqlDeleteOrder);
				pstmt.setInt(1, orderId);
				result = pstmt.executeUpdate();
			}
			conn.commit();
		} catch (Exception e) {
			try {
				if (conn != null)
					conn.rollback();
			} catch (SQLException se) {
			}
			e.printStackTrace();
		} finally {
			close();
		}
		return result;
	}

	public List<OrderDTO> getAllOrders() {
		List<OrderDTO> list = new ArrayList<>();
		conn = DBConnection.getConnection();
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

	public int processOrder(MemberDTO user, List<CartDTO> checkoutList, int totalPrice) {
		int generatedOrderId = 0;
		try {
			conn = DBConnection.getConnection();
			conn.setAutoCommit(false);

			String sqlOrder = "INSERT INTO market_orders (userid, total_price, order_date, receiver_name, receiver_phone, address, status) "
					+ "VALUES (?, ?, CURRENT_TIMESTAMP, ?, ?, ?, '결제완료')";
			pstmt = conn.prepareStatement(sqlOrder, Statement.RETURN_GENERATED_KEYS);
			pstmt.setString(1, user.getUserid());
			pstmt.setInt(2, totalPrice);
			pstmt.setString(3, user.getName());
			pstmt.setString(4, user.getPhone());
			pstmt.setString(5, user.getAddress());
			pstmt.executeUpdate();

			rs = pstmt.getGeneratedKeys();
			if (rs.next()) {
				generatedOrderId = rs.getInt(1);
			}

			String sqlItem = "INSERT INTO market_order_items (order_id, p_id, count, order_price) VALUES (?, ?, ?, ?)";
			PreparedStatement psItem = conn.prepareStatement(sqlItem);
			for (CartDTO item : checkoutList) {
				psItem.setInt(1, generatedOrderId);
				psItem.setInt(2, item.getP_id());
				psItem.setInt(3, item.getCount());
				psItem.setInt(4, item.getProductPrice());
				psItem.addBatch();
			}
			psItem.executeBatch();
			psItem.close();

			String sqlUser = "UPDATE market_members SET mileage = mileage - ? WHERE userid = ? AND mileage >= ?";
			PreparedStatement psUser = conn.prepareStatement(sqlUser);
			psUser.setInt(1, totalPrice);
			psUser.setString(2, user.getUserid());
			psUser.setInt(3, totalPrice);
			int userUpdate = psUser.executeUpdate();
			psUser.close();
			if (userUpdate == 0)
				throw new Exception("마일리지 부족");

			String sqlCart = "DELETE FROM market_cart WHERE c_id = ?";
			PreparedStatement psCart = conn.prepareStatement(sqlCart);
			for (CartDTO item : checkoutList) {
				psCart.setInt(1, item.getCartId());
				psCart.addBatch();
			}
			psCart.executeBatch();
			psCart.close();

			conn.commit();
			return generatedOrderId;
		} catch (Exception e) {
			try {
				if (conn != null)
					conn.rollback();
			} catch (Exception ex) {
			}
			e.printStackTrace();
			return 0;
		} finally {
			close();
		}
	}
}
