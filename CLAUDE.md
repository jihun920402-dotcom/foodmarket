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

Maven/Gradle 없음. `Dockerfile.dev` 멀티스테이지 빌드로 처리:
- **Stage 1 (builder)**: Tomcat 이미지 안에서 `javac`로 `src/main/java/**/*.java` 컴파일. 클래스패스: `servlet-api.jar` + `WEB-INF/lib/*` + `mysql-connector-j.jar` (빌드 시 Maven Central에서 자동 다운로드)
- **Stage 2 (runtime)**: 컴파일된 클래스와 webapp을 Tomcat 9.0에 배포

코드 변경 후엔 반드시 `--build` 플래그로 재빌드해야 반영됨.

## DB 구성

- **MySQL 8.0** — Docker 컨테이너, 서비스명 `mysql`
- 접속: `shopdb` / `shopuser` / `shoppass`
- 앱 컨테이너는 Docker 네트워크를 통해 `mysql:3306`으로 연결
- 호스트에서 직접 접속: `localhost:3307`
- 초기화 스크립트: `init.sql` (테이블 생성 + 기본 데이터)
- 데이터 영속성: `mysql-data` Docker 볼륨

### DB에 직접 쿼리

```bash
# SQL 파일로 실행 (한글 포함 시 반드시 이 방법 사용)
docker cp ./파일.sql homepage-mysql-1:/tmp/파일.sql
docker exec homepage-mysql-1 mysql --default-character-set=utf8mb4 -u shopuser -pshoppass shopdb -e "source /tmp/파일.sql"

# 단순 쿼리 (한글 없을 때)
docker exec homepage-mysql-1 mysql -u shopuser -pshoppass shopdb -e "SELECT * FROM market_products;"
```

> **주의**: PowerShell에서 docker exec에 한글을 직접 넘기면 인코딩이 깨짐. 반드시 SQL 파일로 cp 후 실행할 것.

## 아키텍처

MVC 패턴:

```
controller/*Servlet.java  →  model/*DAO.java  →  common/DBConnection.java
        ↓                         ↓
   webapp/*.jsp            model/*DTO.java
```

### DB 연결

`common/DBConnection.java`가 유일한 연결 생성 지점. 모든 DAO는 `DBConnection.getConnection()`을 사용해야 하며, 하드코딩된 개별 연결은 허용하지 않음.

### DAO 패턴 주의사항

각 DAO는 `conn`, `pstmt`, `rs`를 인스턴스 필드로 보유하므로 **스레드-안전하지 않음**. 서블릿마다 `new XxxDAO()`로 새 인스턴스를 생성해야 하며, DAO 인스턴스를 서블릿 필드에 저장하거나 공유하면 안 됨. 모든 메서드는 `finally { close(); }`로 연결을 반드시 닫음.

### 마일리지 시스템

마일리지가 이 쇼핑몰의 결제 수단임 (포인트가 아닌 현금 대체). 흐름:
- **충전**: `requestCharge` → 관리자가 `approveCharge`로 승인 → `market_members.mileage` 증가
- **결제**: 주문 시 `mileage >= totalPrice` 조건 확인 후 차감 (DB 트랜잭션 내에서 원자적으로 처리)
- 마일리지 부족 시 주문/결제 전체 롤백

### 주문 처리 흐름 (두 가지 경로)

| 경로 | 진입점 | 설명 |
|------|--------|------|
| 단품 주문 | `/checkout` (POST) | 상품 상세 페이지에서 바로 구매. `p_id` + `count` 파라미터 |
| 장바구니 주문 | `/checkout` (POST) | 장바구니에서 구매. `p_id[]` + `count[]` + `totalPrice` 파라미터 |
| 구형 장바구니 주문 | `/OrderServlet` (POST) | 레거시 경로. `selectedCartIds` (콤마 구분) 파라미터 |

`/checkout`이 두 경우를 모두 처리하는 현재 주경로. `totalPrice` 파라미터 유무로 단품/장바구니 분기.

### Servlet URL 매핑

`@WebServlet` 애노테이션으로 URL 직접 매핑 (web.xml 없음).

| URL | Servlet | 설명 |
|-----|---------|------|
| `/list` | ProductListServlet | 상품 목록 (메인), `?category=` 필터 지원 |
| `/detail` | ProductDetailServlet | 상품 상세 |
| `/login` | LoginServlet | 로그인 (POST only) |
| `/join` | JoinServlet | 회원가입 |
| `/logout` | LogoutServlet | 로그아웃 |
| `/checkId` | CheckIdServlet | 아이디 중복 체크 (Ajax) |
| `/updateMember` | UpdateMemberServlet | 내 정보 수정 |
| `/addToCart` | AddToCartServlet | 장바구니 담기 |
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

JSP 직접 접근이 필요한 페이지: `login.jsp`, `join.jsp`, `mypage.jsp`, `adminMemberList.jsp`, `adminConfig.jsp`, `adminCharge.jsp`

### 인증 / 권한

- 로그인 정보는 세션에 `loginUser` (MemberDTO)로 저장
- 모든 JSP는 `header.jsp`를 include하며, 여기서 `loginUser`와 `userRole`("admin" 또는 "user") 변수를 설정
- 관리자 기능은 `"admin".equals(userRole)` 조건으로 분기

### 테이블 구조 (요약)

- `market_members` — userid(PK), password, name, age, phone, address, account_number, role, mileage
- `market_products` — p_id(AI PK), p_name, p_category, p_price, p_stock, p_img_url, p_link_url
- `market_cart` — c_id(AI PK), userid(FK), p_id(FK), c_count
- `market_orders` — order_id(AI PK), userid(FK), total_price, receiver_name, receiver_phone, address, status, order_date
- `market_order_items` — item_id(AI PK), order_id(FK), p_id(FK), count, order_price
- `market_reviews` — r_id(AI PK), p_id(FK), userid(FK), content, rating, r_date
- `market_charge_request` — request_id(AI PK), userid(FK), amount, status, request_date
- `market_info` — infoid(PK), bank_name, account_number, account_holder (infoid=1 고정)

주문 상태값: `결제완료`, `배송중`, `배송완료` (한글 문자열로 DB에 저장)

### 라이브러리 (WEB-INF/lib/)

- `cos.jar` — 파일 업로드 (MultipartRequest)
- `jstl.jar` / `standard.jar` — JSTL
- `mysql-connector-j.jar` — 빌드 시 자동 다운로드, 컨테이너에 배포됨
- `ojdbc8.jar` / `postgresql-42.7.5.jar` — 미사용 (제거 가능)

## 로그 확인

```bash
docker logs homepage-app-1 -f
docker logs homepage-mysql-1 -f
```
