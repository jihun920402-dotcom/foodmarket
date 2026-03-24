package common;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
	public static Connection getConnection() {
		Connection conn = null;

		// 1. 드라이버 변경 (Oracle -> PostgreSQL)
		String driver = "org.postgresql.Driver";

		// 2. Render Internal URL 정보 적용
		// 주소 뒤에 ?sslmode=disable 옵션을 붙여주면 내부 연결 시 더 안정적입니다.
		String url = "jdbc:postgresql://dpg-d70fdteuk2gs7399g6m0-a:5432/shop_vm5g?sslmode=disable";
		String user = "admin";
		String pass = "RrwxAEPyRAWP9FLgGYqSMl8lM6vEQ0Wh";

		try {
			// 1. 드라이버 로드
			Class.forName(driver);
			// 2. 연결 생성
			conn = DriverManager.getConnection(url, user, pass);
			System.out.println("✅ Render PostgreSQL 연결 성공!");
		} catch (ClassNotFoundException e) {
			System.out.println("❌ PostgreSQL 드라이버 로드 실패 (라이브러리 확인 필요)");
			e.printStackTrace();
		} catch (SQLException e) {
			System.out.println("❌ DB 연결 실패 (Render URL/PW 확인 필요)");
			e.printStackTrace();
		}

		return conn;
	}
}