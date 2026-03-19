package model;

import java.sql.Timestamp;

public class ChargeDTO {
	private int requestId;
	private String userid;
	private int amount;
	private String status;
	private Timestamp requestDate;

	// 기본 생성자
	public ChargeDTO() {
	}

	// Getter / Setter
	public int getRequestId() {
		return requestId;
	}

	public void setRequestId(int requestId) {
		this.requestId = requestId;
	}

	public String getUserid() {
		return userid;
	}

	public void setUserid(String userid) {
		this.userid = userid;
	}

	public int getAmount() {
		return amount;
	}

	public void setAmount(int amount) {
		this.amount = amount;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public Timestamp getRequestDate() {
		return requestDate;
	}

	public void setRequestDate(Timestamp requestDate) {
		this.requestDate = requestDate;
	}
}