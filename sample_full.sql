SET NAMES utf8mb4;
USE shopdb;

-- 상품 초기화 후 삽입
DELETE FROM market_reviews;
DELETE FROM market_order_items;
DELETE FROM market_orders;
DELETE FROM market_cart;
DELETE FROM market_charge_request;
DELETE FROM market_products;

-- 상품
INSERT INTO market_products (p_name, p_category, p_price, p_stock, p_img_url, p_link_url) VALUES
('노르웨이산 생연어 (1kg)', '해산물', 28000, 30, 'https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?w=400', ''),
('국산 전복 (10마리)', '해산물', 45000, 20, 'https://images.unsplash.com/photo-1565680018434-b513d5e5fd47?w=400', ''),
('제주 은갈치 (2마리)', '해산물', 32000, 25, 'https://images.unsplash.com/photo-1534482421-64566f976cfa?w=400', ''),
('킹크랩 (1kg)', '해산물', 89000, 10, 'https://images.unsplash.com/photo-1610725664285-7c57e6eeac3f?w=400', ''),
('한우 등심 1++ (500g)', '육류', 75000, 15, 'https://images.unsplash.com/photo-1558030006-450675393462?w=400', ''),
('국내산 삼겹살 (500g)', '육류', 18000, 50, 'https://images.unsplash.com/photo-1606728035253-49e8a23146de?w=400', ''),
('냉장 닭가슴살 (1kg)', '육류', 12000, 60, 'https://images.unsplash.com/photo-1604503468506-a8da13d11d36?w=400', ''),
('프리미엄 해산물 선물세트 (A호)', '선물류', 120000, 10, 'https://images.unsplash.com/photo-1513125370-3460ebe3401b?w=400', ''),
('한우 정육 선물세트 (500g×2)', '선물류', 150000, 8, 'https://images.unsplash.com/photo-1546833998-877b37c2e5c6?w=400', ''),
('제철 굴 (1kg)', '해산물', 22000, 35, 'https://images.unsplash.com/photo-1526376043067-5af36c35cd6c?w=400', ''),
('훈제 오리 슬라이스 (300g)', '육류', 15000, 40, 'https://images.unsplash.com/photo-1432139509613-5c4255815697?w=400', ''),
('명절 종합 선물세트 (B호)', '선물류', 85000, 12, 'https://images.unsplash.com/photo-1607305387299-a3d9611cd469?w=400', '');

-- 일반 회원 (비밀번호: 1234 → SHA-256)
INSERT IGNORE INTO market_members (userid, password, name, age, phone, address, account_number, role, mileage) VALUES
('user1', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', '김철수', 28, '010-1234-5678', '서울시 강남구 역삼동 123', '110-123-456789', 'user', 150000),
('user2', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', '이영희', 35, '010-2345-6789', '부산시 해운대구 우동 456', '020-234-567890', 'user', 80000),
('user3', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', '박민준', 42, '010-3456-7890', '인천시 연수구 송도동 789', '090-345-678901', 'user', 200000);

-- 주문 (user1)
INSERT INTO market_orders (userid, total_price, receiver_name, receiver_phone, address, status, order_date) VALUES
('user1', 46000, '김철수', '010-1234-5678', '서울시 강남구 역삼동 123', '배송완료', '2026-05-10 14:30:00'),
('user1', 75000, '김철수', '010-1234-5678', '서울시 강남구 역삼동 123', '배송중', '2026-05-16 10:00:00');

-- 주문 (user2)
INSERT INTO market_orders (userid, total_price, receiver_name, receiver_phone, address, status, order_date) VALUES
('user2', 120000, '이영희', '010-2345-6789', '부산시 해운대구 우동 456', '결제완료', '2026-05-18 09:00:00');

-- 주문 아이템
INSERT INTO market_order_items (order_id, p_id, count, order_price) VALUES
(1, 1, 1, 28000),
(1, 6, 1, 18000),
(2, 5, 1, 75000),
(3, 8, 1, 120000);

-- 리뷰
INSERT INTO market_reviews (p_id, userid, content, rating, r_date) VALUES
(1, 'user1', '신선도가 정말 좋아요! 다음에도 구매할 것 같습니다.', 5, '2026-05-12 11:00:00'),
(6, 'user1', '삼겹살이 두툼하고 맛있어요. 배송도 빠르고 좋았습니다.', 4, '2026-05-12 11:30:00'),
(5, 'user2', '한우 등심 품질이 기대 이상이었어요. 강추합니다!', 5, '2026-05-17 15:00:00');

-- 충전 신청 내역
INSERT INTO market_charge_request (userid, amount, status, request_date) VALUES
('user1', 100000, 'approved', '2026-05-05 10:00:00'),
('user2', 200000, 'approved', '2026-05-08 14:00:00'),
('user3', 300000, 'pending', '2026-05-19 09:00:00');
