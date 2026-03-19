package model;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ChargeDAO {
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;

	private void getConnection() {
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521/FREEPDB1", "system", "1234");
		} catch (Exception e) {
			e.printStackTrace();
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

	// [회원] 충전 신청 저장
	public int insertRequest(String userid, int amount) {
		getConnection();
		int result = 0;
		String sql = "INSERT INTO market_charge_request (request_id, userid, amount) VALUES (charge_seq.NEXTVAL, ?, ?)";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userid);
			pstmt.setInt(2, amount);
			result = pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return result;
	}

	// [관리자] 대기 중인 신청 목록 조회
	public List<ChargeDTO> getPendingRequests() {
		List<ChargeDTO> list = new ArrayList<>();
		getConnection();
		String sql = "SELECT * FROM market_charge_request WHERE status = 'pending' ORDER BY request_date ASC";
		try {
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
			close();
		}
		return list;
	}

	// [관리자] 충전 승인 처리 (트랜잭션 권장하나 단순화함)
	public boolean approveCharge(int requestId, String userid, int amount) {
		getConnection();
		try {
			conn.setAutoCommit(false); // 트랜잭션 시작

			// 1. 신청 상태를 success로 변경
			String sql1 = "UPDATE market_charge_request SET status = 'success' WHERE request_id = ?";
			pstmt = conn.prepareStatement(sql1);
			pstmt.setInt(1, requestId);
			pstmt.executeUpdate();

			// 2. 해당 회원의 마일리지 합산
			String sql2 = "UPDATE market_members SET mileage = mileage + ? WHERE userid = ?";
			pstmt = conn.prepareStatement(sql2);
			pstmt.setInt(1, amount);
			pstmt.setString(2, userid);
			pstmt.executeUpdate();

			conn.commit(); // 모두 성공 시 확정
			return true;
		} catch (Exception e) {
			try {
				conn.rollback();
			} catch (SQLException se) {
				se.printStackTrace();
			}
			e.printStackTrace();
			return false;
		} finally {
			close();
		}
	}
}