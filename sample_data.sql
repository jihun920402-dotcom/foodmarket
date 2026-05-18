SET NAMES utf8mb4;
USE shopdb;

DELETE FROM market_products;

INSERT INTO market_products (p_name, p_category, p_price, p_stock, p_img_url, p_link_url) VALUES
-- 해산물
('노르웨이산 생연어 (1kg)', '해산물', 28000, 30, 'https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?w=400', ''),
('국산 전복 (10마리)', '해산물', 45000, 20, 'https://images.unsplash.com/photo-1565680018434-b513d5e5fd47?w=400', ''),
('제주 은갈치 (2마리)', '해산물', 32000, 25, 'https://images.unsplash.com/photo-1534482421-64566f976cfa?w=400', ''),
('킹크랩 (1kg)', '해산물', 89000, 10, 'https://images.unsplash.com/photo-1610725664285-7c57e6eeac3f?w=400', ''),
-- 육류
('한우 등심 1++ (500g)', '육류', 75000, 15, 'https://images.unsplash.com/photo-1558030006-450675393462?w=400', ''),
('국내산 삼겹살 (500g)', '육류', 18000, 50, 'https://images.unsplash.com/photo-1606728035253-49e8a23146de?w=400', ''),
('냉장 닭가슴살 (1kg)', '육류', 12000, 60, 'https://images.unsplash.com/photo-1604503468506-a8da13d11d36?w=400', ''),
-- 선물류
('프리미엄 해산물 선물세트 (A호)', '선물류', 120000, 10, 'https://images.unsplash.com/photo-1513125370-3460ebe3401b?w=400', ''),
('한우 정육 선물세트 (500g×2)', '선물류', 150000, 8, 'https://images.unsplash.com/photo-1546833998-877b37c2e5c6?w=400', '');
