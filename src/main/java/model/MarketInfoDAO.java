package model;

import java.sql.*;
import common.DBConnection;

public class MarketInfoDAO {
	// 계좌 정보 가져오기
	public MarketInfoDTO getInfo() {
		String sql = "SELECT * FROM market_info WHERE infoid = 1";
		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {
			if (rs.next()) {
				return new MarketInfoDTO(rs.getString("bank_name"), rs.getString("account_number"),
						rs.getString("account_holder"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	// 계좌 정보 수정하기 (관리자용)
	public int updateInfo(String bank, String account, String holder) {
		String sql = "UPDATE market_info SET bank_name = ?, account_number = ?, account_holder = ? WHERE infoid = 1";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, bank);
			ps.setString(2, account);
			ps.setString(3, holder);
			return ps.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return 0;
	}
}