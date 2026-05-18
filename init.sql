SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;
CREATE DATABASE IF NOT EXISTS shopdb CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE shopdb;

CREATE TABLE IF NOT EXISTS market_members (
    userid VARCHAR(50) PRIMARY KEY,
    password VARCHAR(100) NOT NULL,
    name VARCHAR(50) NOT NULL,
    age INT,
    phone VARCHAR(20),
    address VARCHAR(200),
    account_number VARCHAR(50),
    role VARCHAR(20) DEFAULT 'user',
    mileage INT DEFAULT 0
);

CREATE TABLE IF NOT EXISTS market_products (
    p_id INT AUTO_INCREMENT PRIMARY KEY,
    p_name VARCHAR(100) NOT NULL,
    p_category VARCHAR(50),
    p_price INT NOT NULL,
    p_stock INT DEFAULT 0,
    p_img_url VARCHAR(500),
    p_link_url VARCHAR(500)
);

CREATE TABLE IF NOT EXISTS market_reviews (
    r_id INT AUTO_INCREMENT PRIMARY KEY,
    p_id INT NOT NULL,
    userid VARCHAR(50) NOT NULL,
    content TEXT,
    rating INT,
    r_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (p_id) REFERENCES market_products(p_id),
    FOREIGN KEY (userid) REFERENCES market_members(userid)
);

CREATE TABLE IF NOT EXISTS market_cart (
    c_id INT AUTO_INCREMENT PRIMARY KEY,
    userid VARCHAR(50) NOT NULL,
    p_id INT NOT NULL,
    c_count INT DEFAULT 1,
    FOREIGN KEY (userid) REFERENCES market_members(userid),
    FOREIGN KEY (p_id) REFERENCES market_products(p_id)
);

CREATE TABLE IF NOT EXISTS market_orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    userid VARCHAR(50) NOT NULL,
    total_price INT NOT NULL,
    receiver_name VARCHAR(50),
    receiver_phone VARCHAR(20),
    address VARCHAR(200),
    status VARCHAR(20) DEFAULT '결제완료',
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (userid) REFERENCES market_members(userid)
);

CREATE TABLE IF NOT EXISTS market_order_items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    p_id INT NOT NULL,
    count INT NOT NULL,
    order_price INT NOT NULL,
    FOREIGN KEY (order_id) REFERENCES market_orders(order_id),
    FOREIGN KEY (p_id) REFERENCES market_products(p_id)
);

CREATE TABLE IF NOT EXISTS market_charge_request (
    request_id INT AUTO_INCREMENT PRIMARY KEY,
    userid VARCHAR(50) NOT NULL,
    amount INT NOT NULL,
    status VARCHAR(20) DEFAULT 'pending',
    request_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (userid) REFERENCES market_members(userid)
);

CREATE TABLE IF NOT EXISTS market_info (
    infoid INT PRIMARY KEY,
    bank_name VARCHAR(50),
    account_number VARCHAR(50),
    account_holder VARCHAR(50)
);

INSERT IGNORE INTO market_info (infoid, bank_name, account_number, account_holder)
VALUES (1, '국민은행', '123-456-789012', '홍길동');

-- 비밀번호: 1234 → SHA-256 해시
INSERT IGNORE INTO market_members (userid, password, name, age, phone, address, account_number, role, mileage)
VALUES ('admin', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', '관리자', 30, '010-0000-0000', '서울시', '000-000-000', 'admin', 1000000);
