package common;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
	public static Connection getConnection() {
		Connection conn = null;

		// 연결 정보 (SQL Developer에서 성공했던 정보와 동일!)
		String driver = "oracle.jdbc.driver.OracleDriver";
		String url = "jdbc:oracle:thin:@localhost:1521/FREEPDB1"; // 서비스 이름 주의!
		String user = "system";
		String pass = "1234";

		try {
			// 1. 드라이버 로드
			Class.forName(driver);
			// 2. 연결 생성
			conn = DriverManager.getConnection(url, user, pass);
			System.out.println("✅ 해산물 DB 연결 성공!");
		} catch (ClassNotFoundException e) {
			System.out.println("❌ 드라이버 로드 실패 (ojdbc 파일 확인 필요)");
			e.printStackTrace();
		} catch (SQLException e) {
			System.out.println("❌ DB 연결 실패 (URL/ID/PW 확인 필요)");
			e.printStackTrace();
		}

		return conn;
	}
}