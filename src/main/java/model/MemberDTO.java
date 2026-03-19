package model;

public class MemberDTO {
	private String userid;
	private String password;
	private String name;
	private int age;
	private String phone;
	private String address;
	private String accountNumber; // DB의 account_number 대응
	private String role;
	private int mileage;

	// 1. 기본 생성자 (필수)
	public MemberDTO() {
	}

	// 2. [해결사] 상세 생성자 (JoinServlet에서 사용하는 형태)
	public MemberDTO(String userid, String password, String name, int age, String phone, String address,
			String accountNumber, String role, int mileage) {
		this.userid = userid;
		this.password = password;
		this.name = name;
		this.age = age;
		this.phone = phone;
		this.address = address;
		this.accountNumber = accountNumber;
		this.role = role;
		this.mileage = mileage;
	}

	// Getter & Setter (기존과 동일하게 유지하여 다른 파일 오류 방지)
	public String getUserid() {
		return userid;
	}

	public void setUserid(String userid) {
		this.userid = userid;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public int getAge() {
		return age;
	}

	public void setAge(int age) {
		this.age = age;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getAccountNumber() {
		return accountNumber;
	}

	public void setAccountNumber(String accountNumber) {
		this.accountNumber = accountNumber;
	}

	public String getRole() {
		return role;
	}

	public void setRole(String role) {
		this.role = role;
	}

	public int getMileage() {
		return mileage;
	}

	public void setMileage(int mileage) {
		this.mileage = mileage;
	}
}