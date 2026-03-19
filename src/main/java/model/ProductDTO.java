package model;

public class ProductDTO {
	private int id;
	private String name;
	private String category;
	private int price;
	private int stock;
	private String imgUrl;
	private String linkUrl;

	// [추가된 리뷰 관련 필드]
	private int reviewCount;
	private double avgRating;

	public ProductDTO() {
	}

	public ProductDTO(int id, String name, String category, int price, int stock, String imgUrl, String linkUrl) {
		this.id = id;
		this.name = name;
		this.category = category;
		this.price = price;
		this.stock = stock;
		this.imgUrl = imgUrl;
		this.linkUrl = linkUrl;
	}

	// 기존 Getter/Setter
	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getCategory() {
		return category;
	}

	public void setCategory(String category) {
		this.category = category;
	}

	public int getPrice() {
		return price;
	}

	public void setPrice(int price) {
		this.price = price;
	}

	public int getStock() {
		return stock;
	}

	public void setStock(int stock) {
		this.stock = stock;
	}

	public String getImgUrl() {
		return imgUrl;
	}

	public void setImgUrl(String imgUrl) {
		this.imgUrl = imgUrl;
	}

	public String getLinkUrl() {
		return linkUrl;
	}

	public void setLinkUrl(String linkUrl) {
		this.linkUrl = linkUrl;
	}

	// [추가된 Getter/Setter]
	public int getReviewCount() {
		return reviewCount;
	}

	public void setReviewCount(int reviewCount) {
		this.reviewCount = reviewCount;
	}

	public double getAvgRating() {
		return avgRating;
	}

	public void setAvgRating(double avgRating) {
		this.avgRating = avgRating;
	}
}