# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 서버 실행

```bash
# 최초 실행 또는 코드 변경 후 (재빌드 포함)
docker compose up --build -d

# 재빌드 없이 재시작
docker compose up -d

# 종료
docker compose down
```

접속 URL: http://localhost:8080/list (루트 `/`는 404 — welcome 파일 없음)

## 빌드 방식

Maven/Gradle 없음. `Dockerfile.dev` 멀티스테이지 빌드 (베이스: `tomcat:9.0-jdk21-openjdk-slim`):
- **Stage 1 (builder)**: `javac`로 `src/main/java/**/*.java` 컴파일. 클래스패스: `servlet-api.jar` + `WEB-INF/lib/*` + `mysql-connector-j.jar` (빌드 시 Maven Central 자동 다운로드)
- **Stage 2 (runtime)**: 컴파일된 클래스 + `src/main/webapp/` 전체를 Tomcat 9.0 `/webapps/ROOT/`에 배포

**JSP·정적 파일만 바꿔도 반드시 `--build` 재빌드해야 컨테이너에 반영됨.**

## DB 구성

- **MySQL 8.0** — Docker 컨테이너, 서비스명 `mysql`
- 접속 정보: DB `shopdb` / 유저 `shopuser` / 패스워드 `shoppass`
- 앱 컨테이너 → `mysql:3306` (Docker 내부 네트워크)
- 호스트 직접 접속: `localhost:3307`
- 초기화 스크립트: `init.sql` (테이블 생성 + admin 계정)
- 샘플 데이터: `sample_data.sql` (상품만), `sample_full.sql` (상품 12개 + 회원 3명 + 주문 + 리뷰 전체)
- 이미지 URL 업데이트: `update_product_images.sql` (Unsplash 외부 URL), `update_local_images.sql` (로컬 이미지 경로)
- 데이터 영속성: `mysql-data` Docker 볼륨

### 기본 계정 (비밀번호 `1234` → SHA-256)

| ID | 역할 |
|----|------|
| admin | 관리자 |
| user1, user2, user3 | 일반 회원 |

### DB 직접 쿼리

```bash
# SQL 파일로 실행 (한글 포함 시 반드시 이 방법)
docker cp ./파일.sql foodmarket-mysql-1:/tmp/파일.sql
docker exec foodmarket-mysql-1 mysql --default-character-set=utf8mb4 -u shopuser -pshoppass shopdb -e "source /tmp/파일.sql"

# 단순 쿼리
docker exec foodmarket-mysql-1 mysql -u shopuser -pshoppass shopdb -e "SELECT * FROM market_products;"
```

> **주의**: PowerShell에서 docker exec에 한글 직접 전달 시 인코딩 깨짐. 반드시 파일 cp 후 실행.

## 아키텍처

MVC 패턴:

```
controller/*Servlet.java  →  model/*DAO.java  →  common/DBConnection.java
        ↓                         ↓
   webapp/*.jsp            model/*DTO.java
```

### DB 연결 규칙

`common/DBConnection.java`가 유일한 연결 생성 지점. 모든 DAO는 `DBConnection.getConnection()` 사용. 하드코딩 개별 연결 금지.

### DAO 스레드 안전성

각 DAO는 `conn`, `pstmt`, `rs`를 인스턴스 필드로 보유하므로 **스레드-안전하지 않음**. 서블릿마다 `new XxxDAO()`로 새 인스턴스 생성 필수. DAO를 서블릿 필드에 저장하거나 공유 금지. 모든 메서드는 `finally { close(); }`로 연결 닫음.

### 마일리지 시스템

마일리지가 이 쇼핑몰의 유일한 결제 수단 (현금 대체):
- **충전**: `requestCharge` → 관리자 `approveCharge` 승인 → `market_members.mileage` 증가
- **결제**: `mileage >= totalPrice` 확인 후 차감 (DB 트랜잭션 원자 처리)
- 부족 시 주문/결제 전체 롤백

### 주문 처리 경로

| 경로 | 진입점 | 파라미터 |
|------|--------|----------|
| 단품 주문 | `/checkout` POST | `p_id` + `count` |
| 장바구니 주문 | `/checkout` POST | `p_id[]` + `count[]` + `totalPrice` |
| 구형 장바구니 (레거시) | `/OrderServlet` POST | `selectedCartIds` (콤마 구분) |

`totalPrice` 파라미터 유무로 단품/장바구니 분기.

### Servlet URL 매핑

`@WebServlet` 애노테이션으로 직접 매핑. `WEB-INF/web.xml`은 존재하지만 UTF-8 인코딩 필터(`SetCharacterEncodingFilter`) 하나만 정의 — 서블릿 매핑 없음.

| URL | Servlet | 설명 |
|-----|---------|------|
| `/list` | ProductListServlet | 상품 목록 (메인), `?category=`, `?keyword=`, `?sort=` |
| `/detail` | ProductDetailServlet | 상품 상세 |
| `/login` | LoginServlet | 로그인 (POST only) |
| `/join` | JoinServlet | 회원가입 |
| `/logout` | LogoutServlet | 로그아웃 |
| `/checkId` | CheckIdServlet | 아이디 중복 체크 (Ajax) |
| `/updateMember` | UpdateMemberServlet | 내 정보 수정 |
| `/addToCart` | AddToCartServlet | 장바구니 담기 (JSON 응답) |
| `/cartList` | CartListServlet | 장바구니 목록 |
| `/updateCart` | UpdateCartServlet | 장바구니 수량 변경 |
| `/deleteCart` | DeleteCartServlet | 장바구니 항목 삭제 |
| `/checkout` | CheckoutServlet | 결제 처리 (단품/장바구니 공통) |
| `/OrderServlet` | OrderServlet | 구형 장바구니 결제 (레거시) |
| `/orderList` | OrderListServlet | 내 주문 내역 |
| `/deleteOrder` | DeleteOrderServlet | 주문 취소 (마일리지 환불 + 재고 복구) |
| `/AddReviewServlet` | AddReviewServlet | 리뷰 작성 |
| `/UpdateReviewServlet` | UpdateReviewServlet | 리뷰 수정 |
| `/DeleteReviewServlet` | DeleteReviewServlet | 리뷰 삭제 |
| `/chargeList` | ChargeListServlet | 내 충전 내역 |
| `/requestCharge` | RequestChargeServlet | 마일리지 충전 신청 |
| `/adminOrderList` | AdminOrderListServlet | 관리자 주문 관리 |
| `/updateOrderStatus` | UpdateOrderStatusServlet | 관리자 주문 상태 변경 |
| `/adminUpdateMember` | AdminUpdateMemberServlet | 관리자 회원 정보 수정 |
| `/adminDeleteMember` | AdminDeleteMemberServlet | 관리자 회원 탈퇴 |
| `/approveCharge` | ApproveChargeServlet | 관리자 충전 승인 |
| `/updateMarketInfo` | UpdateMarketInfoServlet | 관리자 쇼핑몰 정보 수정 |
| `/insert` | InsertServlet | 관리자 상품 등록 |
| `/edit` | EditServlet | 관리자 상품 수정 페이지 |
| `/UpdateServlet` | UpdateServlet | 관리자 상품 수정 처리 |
| `/delete` | DeleteServlet | 관리자 상품 삭제 |

JSP 직접 접근 페이지: `login.jsp`, `join.jsp`, `mypage.jsp`, `updateMember.jsp`, `chargeRequest.jsp`, `orderDetail.jsp`, `orderSuccess.jsp`, `insertProduct.jsp`, `adminMemberList.jsp`, `adminConfig.jsp`, `adminCharge.jsp`, `adminOrderList.jsp`

> `editProduct.jsp`는 `/edit` 서블릿이 `request.setAttribute("product")` 후 forward하는 JSP — 직접 접근 불가.

### 인증 / 권한

- 로그인 정보: 세션의 `loginUser` (MemberDTO)
- 모든 JSP는 `header.jsp`를 include → `loginUser`, `userRole`("admin"/"user") 변수 세팅
- 관리자 분기: `"admin".equals(userRole)`

### 테이블 구조 (요약)

- `market_members` — userid(PK), password, name, age, phone, address, account_number, role, mileage
- `market_products` — p_id(AI PK), p_name, p_category, p_price, p_stock, p_img_url, p_link_url
- `market_cart` — c_id(AI PK), userid(FK), p_id(FK), c_count
- `market_orders` — order_id(AI PK), userid(FK), total_price, receiver_name, receiver_phone, address, status, order_date
- `market_order_items` — item_id(AI PK), order_id(FK), p_id(FK), count, order_price
- `market_reviews` — r_id(AI PK), p_id(FK), userid(FK), content, rating, r_date
- `market_charge_request` — request_id(AI PK), userid(FK), amount, status, request_date
- `market_info` — infoid(PK), bank_name, account_number, account_holder (infoid=1 고정)

주문 상태값: `결제완료`, `배송중`, `배송완료` (한글 문자열 그대로 DB 저장)
충전 상태값: `pending`, `approved`

## 프론트엔드

- **스타일**: Tailwind CSS CDN + Pretendard 폰트 CDN. 다크 테마 고정 (`<html class="dark">`)
- **공통 레이아웃**: `header.jsp` (네비 + 모바일 햄버거 메뉴) + `footer.jsp` include
- **반응형**: 모바일 우선. 장바구니(`cartList.jsp`)는 모바일 카드 레이아웃(`block sm:hidden`) + 데스크탑 테이블(`hidden sm:block`) 이중 구조
- **공통 버튼 클래스**: `btn-gold`, `btn-outline`, `btn-ghost`, `btn-danger` (header.jsp `<style>`에 정의)
- **공통 JS 헬퍼**: `openModal(id)` / `closeModal(id)` — header.jsp에 정의, 모든 JSP에서 바로 사용 가능. 모달 표시 시 `body.overflow:hidden` 처리 포함.

### 상품 이미지

- 로컬 이미지: `webapp/images/products/product_{p_id}.jfif` (상품 12개)
- 폴백 이미지: `webapp/images/no-image.png`
- `onerror` 패턴 (모든 상품 이미지 태그에 적용):
  ```html
  onerror="this.src='<%= request.getContextPath() %>/images/no-image.png'; this.onerror=null;"
  ```
- `p_img_url`이 `/images/products/...` (로컬) 또는 `https://...` (외부) 둘 다 지원

## 유틸리티

- `common/PasswordUtil.java` — `PasswordUtil.hash(String)`: SHA-256 해시 반환. 회원가입·비밀번호 수정 시 반드시 이 메서드로 해싱 후 DB 저장. DB에는 평문 절대 저장 금지.
- `common/DBConnection.java` — 유일한 DB 연결 생성 지점 (호스트명 `mysql` 하드코딩, Docker 내부 네트워크 전용)

## 라이브러리 (WEB-INF/lib/)

- `cos.jar` — 파일 업로드 (MultipartRequest)
- `jstl.jar` / `standard.jar` — JSTL
- `mysql-connector-j.jar` — 빌드 시 Maven Central 자동 다운로드
- `ojdbc8.jar` / `postgresql-42.7.5.jar` — 미사용

## 로그 확인

```bash
docker logs foodmarket-app-1 -f
docker logs foodmarket-mysql-1 -f
```
