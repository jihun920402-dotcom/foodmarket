package model;

public class MarketInfoDTO {
	private String bankName;
	private String accountNumber;
	private String accountHolder;

	public MarketInfoDTO(String bankName, String accountNumber, String accountHolder) {
		this.bankName = bankName;
		this.accountNumber = accountNumber;
		this.accountHolder = accountHolder;
	}

	public String getBankName() {
		return bankName;
	}

	public String getAccountNumber() {
		return accountNumber;
	}

	public String getAccountHolder() {
		return accountHolder;
	}
}