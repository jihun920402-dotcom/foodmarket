package common;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
	public static Connection getConnection() {
		Connection conn = null;

		// 1. 드라이버 설정
		String driver = "org.postgresql.Driver";

		// 2. Render External URL 기반으로 수정 (외부 접속용 주소)
		// 사장님이 주신 외부망 주소: dpg-d70fdteuk2gs7399g6m0-a.singapore-postgres.render.com
		String url = "jdbc:postgresql://dpg-d70fdteuk2gs7399g6m0-a.singapore-postgres.render.com:5432/shop_vm5g";
		String user = "admin";
		String pass = "RrwxAEPyRAWP9FLgGYqSMl8lM6vEQ0Wh";

		try {
			// 1. 드라이버 로드
			Class.forName(driver);
			// 2. 연결 생성 (사용자 이름과 비밀번호를 명시적으로 전달)
			conn = DriverManager.getConnection(url, user, pass);
			System.out.println("✅ Render External PostgreSQL 연결 성공!");
		} catch (ClassNotFoundException e) {
			System.out.println("❌ PostgreSQL 드라이버 로드 실패 (라이브러리 확인 필요)");
			e.printStackTrace();
		} catch (SQLException e) {
			System.out.println("❌ DB 연결 실패 (External URL 또는 PW 확인 필요)");
			e.printStackTrace();
		}

		return conn;
	}
}