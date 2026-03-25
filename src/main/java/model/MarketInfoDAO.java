package model;

import java.sql.*;
import common.DBConnection;

public class MarketInfoDAO {

	// 1. 계좌 정보 가져오기 (마이페이지 충전 모달 등에서 사용)
	public MarketInfoDTO getInfo() {
		// [확인] infoid = 1인 기본 계좌 정보를 가져옵니다.
		String sql = "SELECT bank_name, account_number, account_holder FROM market_info WHERE infoid = 1";

		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;

		try {
			conn = DBConnection.getConnection();
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();

			if (rs.next()) {
				// DTO 생성자 파라미터 순서 유지 (은행명, 계좌번호, 예금주)
				return new MarketInfoDTO(rs.getString("bank_name"), rs.getString("account_number"),
						rs.getString("account_holder"));
			}
		} catch (Exception e) {
			System.out.println("MarketInfo 조회 중 오류: " + e.getMessage());
			e.printStackTrace();
		} finally {
			// 자원 해제 (PostgreSQL 연결 누수 방지)
			try {
				if (rs != null)
					rs.close();
			} catch (Exception e) {
			}
			try {
				if (ps != null)
					ps.close();
			} catch (Exception e) {
			}
			try {
				if (conn != null)
					conn.close();
			} catch (Exception e) {
			}
		}
		return null;
	}

	// 2. 계좌 정보 수정하기 (관리자 설정 페이지용)
	public int updateInfo(String bank, String account, String holder) {
		String sql = "UPDATE market_info SET bank_name = ?, account_number = ?, account_holder = ? WHERE infoid = 1";

		Connection conn = null;
		PreparedStatement ps = null;

		try {
			conn = DBConnection.getConnection();
			ps = conn.prepareStatement(sql);
			ps.setString(1, bank);
			ps.setString(2, account);
			ps.setString(3, holder);

			return ps.executeUpdate();
		} catch (Exception e) {
			System.out.println("MarketInfo 수정 중 오류: " + e.getMessage());
			e.printStackTrace();
		} finally {
			// 자원 해제
			try {
				if (ps != null)
					ps.close();
			} catch (Exception e) {
			}
			try {
				if (conn != null)
					conn.close();
			} catch (Exception e) {
			}
		}
		return 0;
	}
}