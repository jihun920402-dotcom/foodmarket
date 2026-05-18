package model;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import common.DBConnection;

public class MemberDAO {
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

	// 1. 로그인 체크
	public MemberDTO loginCheck(String userid, String password) {
		conn = DBConnection.getConnection();
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

	// 2. 회원가입 (INSERT)
	public int insertMember(MemberDTO dto) {
		conn = DBConnection.getConnection();
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

	// 3. 내 정보 수정
	public int updateMember(MemberDTO dto) {
		conn = DBConnection.getConnection();
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

	// 4. 마일리지 직접 수정
	public int updateMileage(String userid, int mileage) {
		conn = DBConnection.getConnection();
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

	// 5. 아이디로 회원 정보 조회
	public MemberDTO getMemberByUserid(String userid) {
		conn = DBConnection.getConnection();
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

	// 6. [관리자] 전체 회원 목록 조회
	public List<MemberDTO> getAllMembers() {
		List<MemberDTO> list = new ArrayList<>();
		conn = DBConnection.getConnection();
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

	// 7. [관리자] 회원 탈퇴 (트랜잭션 적용)
	public int deleteMember(String userid) {
		conn = DBConnection.getConnection();
		int result = 0;
		try {
			conn.setAutoCommit(false);

			String sql1 = "DELETE FROM market_cart WHERE userid = ?";
			pstmt = conn.prepareStatement(sql1);
			pstmt.setString(1, userid);
			pstmt.executeUpdate();

			String sql2 = "DELETE FROM market_charge_request WHERE userid = ?";
			pstmt = conn.prepareStatement(sql2);
			pstmt.setString(1, userid);
			pstmt.executeUpdate();

			String sql3 = "DELETE FROM market_orders WHERE userid = ?";
			pstmt = conn.prepareStatement(sql3);
			pstmt.setString(1, userid);
			pstmt.executeUpdate();

			String sql4 = "DELETE FROM market_members WHERE userid = ?";
			pstmt = conn.prepareStatement(sql4);
			pstmt.setString(1, userid);
			result = pstmt.executeUpdate();

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

	// 8. [관리자] 회원 정보 수정
	public int updateMemberByAdmin(MemberDTO dto) {
		conn = DBConnection.getConnection();
		int result = 0;
		String sql = "UPDATE market_members SET name=?, phone=?, address=?, mileage=?, role=? WHERE userid=?";
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

	// 9. 아이디 중복 체크
	public boolean checkId(String userid) {
		conn = DBConnection.getConnection();
		boolean result = false;
		String sql = "SELECT userid FROM market_members WHERE userid = ?";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userid);
			rs = pstmt.executeQuery();
			if (rs.next())
				result = true;
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return result;
	}
}
