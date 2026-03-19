package model;

public class CartDTO {
	private int cartId; // DB의 c_id 대응
	private String userid; // DB의 userid 대응
	private int p_id; // DB의 p_id 대응
	private int count; // DB의 c_count 대응

	// 조인(Join)을 통해 market_products 테이블에서 가져올 정보
	private String productName; // DB의 p_name 대응
	private int productPrice; // DB의 p_price 대응
	private String imgUrl; // DB의 p_img_url 대응

	public CartDTO() {
	}

	// Getter & Setter
	public int getCartId() {
		return cartId;
	}

	public void setCartId(int cartId) {
		this.cartId = cartId;
	}

	public String getUserid() {
		return userid;
	}

	public void setUserid(String userid) {
		this.userid = userid;
	}

	public int getP_id() {
		return p_id;
	}

	public void setP_id(int p_id) {
		this.p_id = p_id;
	}

	public int getCount() {
		return count;
	}

	public void setCount(int count) {
		this.count = count;
	}

	public String getProductName() {
		return productName;
	}

	public void setProductName(String productName) {
		this.productName = productName;
	}

	public int getProductPrice() {
		return productPrice;
	}

	public void setProductPrice(int productPrice) {
		this.productPrice = productPrice;
	}

	public String getImgUrl() {
		return imgUrl;
	}

	public void setImgUrl(String imgUrl) {
		this.imgUrl = imgUrl;
	}
}