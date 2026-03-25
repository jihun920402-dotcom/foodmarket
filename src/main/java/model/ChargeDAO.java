package model;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import common.DBConnection;

public class ChargeDAO {
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;

	// 자원 해제 공통 메서드 (기존 스타일 유지)
	private void closeAll(Connection conn, PreparedStatement ps, ResultSet rs) {
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
			conn = DBConnection.getConnection();
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

	// 2. 마일리지 충전 신청 (INSERT)
	// [수정] PostgreSQL: SERIAL 사용으로 request_id 제외, SYSDATE 대신 CURRENT_TIMESTAMP 사용
	public boolean insertChargeRequest(String userid, int amount) {
		Connection conn = null;
		PreparedStatement ps = null;
		// request_id는 SERIAL이므로 INSERT 컬럼에서 제외합니다.
		String sql = "INSERT INTO market_charge_request (userid, amount, status, request_date) "
				+ "VALUES (?, ?, 'pending', CURRENT_TIMESTAMP)";

		try {
			conn = DBConnection.getConnection();
			ps = conn.prepareStatement(sql);
			ps.setString(1, userid);
			ps.setInt(2, amount);

			return ps.executeUpdate() > 0;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		} finally {
			closeAll(conn, ps, null);
		}
	}

	// 3. [관리자] 대기 중인 신청 목록 조회
	public List<ChargeDTO> getPendingRequests() {
		List<ChargeDTO> list = new ArrayList<>();
		String sql = "SELECT * FROM market_charge_request WHERE status = 'pending' ORDER BY request_date ASC";
		try {
			conn = DBConnection.getConnection();
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

	// 4. [관리자] 충전 승인 처리 (PostgreSQL 서브쿼리 문법 최적화)
	public int approveRequest(int requestId) {
		int result = 0;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;

		try {
			conn = DBConnection.getConnection();
			conn.setAutoCommit(false); // 트랜잭션 시작

			// (1) 요청 상태 변경
			String sql1 = "UPDATE market_charge_request SET status = 'success' WHERE request_id = ? AND status = 'pending'";
			pstmt1 = conn.prepareStatement(sql1);
			pstmt1.setInt(1, requestId);
			int updateStatus = pstmt1.executeUpdate();

			if (updateStatus > 0) {
				// (2) 해당 사용자의 마일리지 합산 (PostgreSQL 서브쿼리 방식 유지)
				String sql2 = "UPDATE market_members SET mileage = mileage + "
						+ "(SELECT amount FROM market_charge_request WHERE request_id = ?) "
						+ "WHERE userid = (SELECT userid FROM market_charge_request WHERE request_id = ?)";
				pstmt2 = conn.prepareStatement(sql2);
				pstmt2.setInt(1, requestId);
				pstmt2.setInt(2, requestId);
				int updateMileage = pstmt2.executeUpdate();

				if (updateMileage > 0) {
					conn.commit();
					result = 1;
				} else {
					conn.rollback();
				}
			} else {
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

	// 5. 사용자의 충전 내역 조회 (중복 메서드 정리)
	public List<ChargeDTO> getChargeList(String userid) {
		return getChargeListByUser(userid); // 위에서 만든 메서드 재사용
	}
}