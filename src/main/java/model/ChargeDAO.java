package model;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import common.DBConnection;

public class ChargeDAO {
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;

	private void getConnection() {
		try {
			conn = DBConnection.getConnection();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private void closeAll() {
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

	// 1. [회원] 내 충전 내역 조회
	public List<ChargeDTO> getChargeListByUser(String userid) {
		List<ChargeDTO> list = new ArrayList<>();
		String sql = "SELECT * FROM market_charge_request WHERE userid = ? ORDER BY request_date DESC";
		try {
			getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userid);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				ChargeDTO dto = new ChargeDTO();
				dto.setRequestId(rs.getInt("request_id"));
				dto.setUserid(rs.getString("userid"));
				dto.setAmount(rs.getInt("amount"));
				dto.setStatus(rs.getString("status"));
				dto.setRequestDate(rs.getTimestamp("request_date"));
				list.add(dto);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			closeAll();
		}
		return list;
	}

	// 2. [회원] 충전 신청 등록 (시퀀스: charge_seq 사용 확인됨)
	public int insertRequest(String userid, int amount) {
		int result = 0;
		String sql = "INSERT INTO market_charge_request (request_id, userid, amount, status, request_date) "
				+ "VALUES (charge_seq.NEXTVAL, ?, ?, 'pending', SYSDATE)";
		try {
			getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userid);
			pstmt.setInt(2, amount);
			result = pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			closeAll();
		}
		return result;
	}

	// 3. [관리자] 대기 중인 신청 목록 조회
	public List<ChargeDTO> getPendingRequests() {
		List<ChargeDTO> list = new ArrayList<>();
		String sql = "SELECT * FROM market_charge_request WHERE status = 'pending' ORDER BY request_date ASC";
		try {
			getConnection();
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				ChargeDTO dto = new ChargeDTO();
				dto.setRequestId(rs.getInt("request_id"));
				dto.setUserid(rs.getString("userid"));
				dto.setAmount(rs.getInt("amount"));
				dto.setStatus(rs.getString("status"));
				dto.setRequestDate(rs.getTimestamp("request_date"));
				list.add(dto);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			closeAll();
		}
		return list;
	}

	// 4. [관리자] 충전 승인 처리 (중복 충전 방지 로직 추가)
	public int approveRequest(int requestId) {
		int result = 0;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;

		try {
			getConnection();
			conn.setAutoCommit(false); // 트랜잭션 시작

			// (1) 요청 상태 변경: 반드시 'pending' 상태인 것만 'success'로 바꿈 (중복 승인 방지)
			String sql1 = "UPDATE market_charge_request SET status = 'success' WHERE request_id = ? AND status = 'pending'";
			pstmt1 = conn.prepareStatement(sql1);
			pstmt1.setInt(1, requestId);
			int updateStatus = pstmt1.executeUpdate();

			// (2) 해당 사용자의 마일리지 합산
			// 위에서 updateStatus가 1일 때만 실행되도록 설계하여 안전성을 높였습니다.
			if (updateStatus > 0) {
				String sql2 = "UPDATE market_members SET mileage = mileage + "
						+ "(SELECT amount FROM market_charge_request WHERE request_id = ?) "
						+ "WHERE userid = (SELECT userid FROM market_charge_request WHERE request_id = ?)";
				pstmt2 = conn.prepareStatement(sql2);
				pstmt2.setInt(1, requestId);
				pstmt2.setInt(2, requestId);
				int updateMileage = pstmt2.executeUpdate();

				if (updateMileage > 0) {
					conn.commit(); // 모든 과정 성공
					result = 1;
				} else {
					conn.rollback();
				}
			} else {
				// 이미 승인되었거나 존재하지 않는 요청인 경우
				conn.rollback();
			}
		} catch (Exception e) {
			try {
				if (conn != null)
					conn.rollback();
			} catch (SQLException ex) {
			}
			e.printStackTrace();
		} finally {
			try {
				if (pstmt1 != null)
					pstmt1.close();
			} catch (SQLException e) {
			}
			try {
				if (pstmt2 != null)
					pstmt2.close();
			} catch (SQLException e) {
			}
			closeAll();
		}
		return result;
	}
}