-- 상품 이미지 URL 업데이트 (Unsplash Source)
-- 실행 방법:
-- docker cp ./update_product_images.sql foodmarket-mysql-1:/tmp/update_product_images.sql
-- docker exec foodmarket-mysql-1 mysql --default-character-set=utf8mb4 -u shopuser -pshoppass shopdb -e "source /tmp/update_product_images.sql"

UPDATE market_products SET p_img_url = 'https://images.unsplash.com/photo-1574781330855-d0db8cc6a79c?w=400&fit=crop' WHERE p_id = 1; -- 노르웨이산 생연어
UPDATE market_products SET p_img_url = 'https://images.unsplash.com/photo-1565680018434-b513d5e5fd47?w=400&fit=crop' WHERE p_id = 2; -- 국산 전복
UPDATE market_products SET p_img_url = 'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=400&fit=crop' WHERE p_id = 3; -- 제주 은갈치
UPDATE market_products SET p_img_url = 'https://images.unsplash.com/photo-1559339352-11d035aa65de?w=400&fit=crop' WHERE p_id = 4; -- 킹크랩
UPDATE market_products SET p_img_url = 'https://images.unsplash.com/photo-1546964124-0cce460f38ef?w=400&fit=crop' WHERE p_id = 5; -- 한우 등심 1++
UPDATE market_products SET p_img_url = 'https://images.unsplash.com/photo-1529193591184-b1d58069ecdd?w=400&fit=crop' WHERE p_id = 6; -- 국내산 삼겹살
UPDATE market_products SET p_img_url = 'https://images.unsplash.com/photo-1604503468506-a8da13d11bea?w=400&fit=crop' WHERE p_id = 7; -- 냉장 닭가슴살
UPDATE market_products SET p_img_url = 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=400&fit=crop' WHERE p_id = 8; -- 프리미엄 해산물 선물세트
UPDATE market_products SET p_img_url = 'https://images.unsplash.com/photo-1558030006-450675393462?w=400&fit=crop' WHERE p_id = 9; -- 한우 정육 선물세트
UPDATE market_products SET p_img_url = 'https://images.unsplash.com/photo-1606757389723-23c4a48713d4?w=400&fit=crop' WHERE p_id = 10; -- 제철 굴
UPDATE market_products SET p_img_url = 'https://images.unsplash.com/photo-1519984388953-d2406bc725e1?w=400&fit=crop' WHERE p_id = 11; -- 훈제 오리 슬라이스
UPDATE market_products SET p_img_url = 'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=400&fit=crop' WHERE p_id = 12; -- 명절 종합 선물세트
