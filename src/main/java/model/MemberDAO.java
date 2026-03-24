package model;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MemberDAO {
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;

	private void getConnection() {
		try {
			// 1. PostgreSQL 드라이버 로드
			Class.forName("org.postgresql.Driver");

			// 2. Render External URL 주소 (사장님의 DB 정보)
			String url = "jdbc:postgresql://dpg-d70fdteuk2gs7399g6m0-a.singapore-postgres.render.com:5432/shop_vm5g";
			String user = "admin";
			String pass = "RrwxAEPyRAWP9FLgGYqSMl8lM6vEQ0Wh";

			conn = DriverManager.getConnection(url, user, pass);
		} catch (Exception e) {
			System.out.println("DB 연결 실패 (PostgreSQL): " + e.getMessage());
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

	public MemberDTO loginCheck(String userid, String password) {
		getConnection();
		MemberDTO dto = null;
		String sql = "SELECT * FROM market_members WHERE userid = ? AND password = ?";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userid);
			pstmt.setString(2, password);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				dto = new MemberDTO();
				dto.setUserid(rs.getString("userid"));
				dto.setPassword(rs.getString("password"));
				dto.setName(rs.getString("name"));
				dto.setAge(rs.getInt("age"));
				dto.setPhone(rs.getString("phone"));
				dto.setAddress(rs.getString("address"));
				dto.setAccountNumber(rs.getString("account_number"));
				dto.setRole(rs.getString("role"));
				dto.setMileage(rs.getInt("mileage"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return dto;
	}

	public int insertMember(MemberDTO dto) {
		getConnection();
		int result = 0;
		String sql = "INSERT INTO market_members (userid, password, name, age, phone, address, account_number, role, mileage) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getUserid());
			pstmt.setString(2, dto.getPassword());
			pstmt.setString(3, dto.getName());
			pstmt.setInt(4, dto.getAge());
			pstmt.setString(5, dto.getPhone());
			pstmt.setString(6, dto.getAddress());
			pstmt.setString(7, dto.getAccountNumber());
			pstmt.setString(8, dto.getRole());
			pstmt.setInt(9, dto.getMileage());
			result = pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return result;
	}

	public int updateMember(MemberDTO dto) {
		getConnection();
		int result = 0;
		String sql = "UPDATE market_members SET password=?, name=?, phone=?, address=?, account_number=? WHERE userid=?";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getPassword());
			pstmt.setString(2, dto.getName());
			pstmt.setString(3, dto.getPhone());
			pstmt.setString(4, dto.getAddress());
			pstmt.setString(5, dto.getAccountNumber());
			pstmt.setString(6, dto.getUserid());
			result = pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return result;
	}

	public int updateMileage(String userid, int mileage) {
		getConnection();
		int result = 0;
		String sql = "UPDATE market_members SET mileage=? WHERE userid=?";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, mileage);
			pstmt.setString(2, userid);
			result = pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return result;
	}

	public MemberDTO getMemberByUserid(String userid) {
		getConnection();
		MemberDTO dto = null;
		String sql = "SELECT * FROM market_members WHERE userid = ?";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userid);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				dto = new MemberDTO();
				dto.setUserid(rs.getString("userid"));
				dto.setPassword(rs.getString("password"));
				dto.setName(rs.getString("name"));
				dto.setAge(rs.getInt("age"));
				dto.setPhone(rs.getString("phone"));
				dto.setAddress(rs.getString("address"));
				dto.setAccountNumber(rs.getString("account_number"));
				dto.setRole(rs.getString("role"));
				dto.setMileage(rs.getInt("mileage"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return dto;
	}

	// [관리자 전용] 전체 회원 목록 조회 (권한 순, 이름 순 정렬)
	public List<MemberDTO> getAllMembers() {
		List<MemberDTO> list = new ArrayList<>();
		getConnection();
		String sql = "SELECT * FROM market_members ORDER BY role ASC, name ASC";
		try {
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				MemberDTO dto = new MemberDTO();
				dto.setUserid(rs.getString("userid"));
				dto.setName(rs.getString("name"));
				dto.setAge(rs.getInt("age"));
				dto.setPhone(rs.getString("phone"));
				dto.setAddress(rs.getString("address"));
				dto.setAccountNumber(rs.getString("account_number"));
				dto.setRole(rs.getString("role"));
				dto.setMileage(rs.getInt("mileage"));
				list.add(dto);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return list;
	}

	// [관리자 전용] 회원 강제 탈퇴 (자식 데이터 포함 삭제)
	public int deleteMember(String userid) {
		getConnection();
		int result = 0;
		try {
			// 트랜잭션 시작
			conn.setAutoCommit(false);

			// 1. 장바구니 데이터 삭제
			String sql1 = "DELETE FROM market_cart WHERE userid = ?";
			pstmt = conn.prepareStatement(sql1);
			pstmt.setString(1, userid);
			pstmt.executeUpdate();

			// 2. 충전 요청 데이터 삭제
			String sql2 = "DELETE FROM market_charge_request WHERE userid = ?";
			pstmt = conn.prepareStatement(sql2);
			pstmt.setString(1, userid);
			pstmt.executeUpdate();

			// 3. 주문 내역 데이터 삭제
			String sql3 = "DELETE FROM market_orders WHERE userid = ?";
			pstmt = conn.prepareStatement(sql3);
			pstmt.setString(1, userid);
			pstmt.executeUpdate();

			// 4. 최종 회원 정보 삭제
			String sql4 = "DELETE FROM market_members WHERE userid = ?";
			pstmt = conn.prepareStatement(sql4);
			pstmt.setString(1, userid);
			result = pstmt.executeUpdate();

			// 전체 성공 시 커밋
			conn.commit();
		} catch (Exception e) {
			try {
				if (conn != null)
					conn.rollback(); // 오류 시 되돌리기
			} catch (SQLException se) {
				se.printStackTrace();
			}
			e.printStackTrace();
		} finally {
			close();
		}
		return result;
	}

	public int updateMemberByAdmin(MemberDTO dto) {
		getConnection();
		int result = 0;
		// [수정] 설계도에 맞게 MARKET_MEMBERS (S 추가)로 변경
		String sql = "UPDATE MARKET_MEMBERS SET name=?, phone=?, address=?, mileage=?, role=? WHERE userid=?";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getName());
			pstmt.setString(2, dto.getPhone());
			pstmt.setString(3, dto.getAddress());
			pstmt.setInt(4, dto.getMileage());
			pstmt.setString(5, dto.getRole());
			pstmt.setString(6, dto.getUserid());
			result = pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return result;
	}
}