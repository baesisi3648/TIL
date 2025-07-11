# SQL advance

## 🎯 윈도우 함수 핵심 개념

### 📚 한 줄 정의

> 윈도우 함수 = 창문을 통해 주변을 보면서 나의 위치를 파악하는 함수

### 🏗️ 기본 구조

```sql
윈도우함수() OVER (
    PARTITION BY 그룹컬럼    -- 방 나누기 (선택사항)
    ORDER BY 정렬컬럼       -- 순서 정하기
    ROWS/RANGE BETWEEN ...  -- 범위 지정 (선택사항)
)
```

### 💡 일반 함수와의 차이점

| 구분    | 일반 집계 함수   | 윈도우 함수     |
| ----- | ---------- | ---------- |
| 결과    | 하나의 값      | 각 행마다 값    |
| 정보 유지 | ❌ 개별 행 사라짐 | ✅ 개별 행 유지  |
| 활용도   | 단순 집계      | 순위, 비교, 분석 |

---

## 🏆 1. 순위 함수들

### 📊 ROW\_NUMBER() - 고유한 순번

```sql
ROW_NUMBER() OVER (ORDER BY amount DESC)
```

* 동점자도 다른 번호
* 용도: 페이징, 고유 식별번호

### 🥇 RANK() - 진짜 순위

```sql
RANK() OVER (ORDER BY amount DESC)
```

* 동점자 같은 순위, 다음 순위 건너뜀

### 🏅 DENSE\_RANK() - 촘촘한 순위

```sql
DENSE_RANK() OVER (ORDER BY amount DESC)
```

* 동점자 같은 순위, 다음 순위 연속 유지

### 🎯 언제 어떤 순위 함수를?

| 상황       | 함수          | 이유        |
| -------- | ----------- | --------- |
| 게시판 페이징  | ROW\_NUMBER | 고유 번호 부여  |
| 시험 성적 순위 | RANK        | 현실적 순위 반영 |
| 상품 등급 분류 | DENSE\_RANK | 연속된 등급 부여 |

---

## 🏠 2. PARTITION BY - 그룹별 분석

### 🎯 핵심 개념

> 전체 데이터 → 그룹별로 나누기 → 각 그룹에서 윈도우 함수 적용

### 💪 실무 활용 예시

```sql
-- 각 지역별 매출 1위 고객
RANK() OVER (PARTITION BY region ORDER BY 총매출 DESC)

-- 각 카테고리별 TOP 3 상품
ROW_NUMBER() OVER (PARTITION BY category ORDER BY 총판매량 DESC) <= 3

-- 월별 일일 매출 순위
RANK() OVER (PARTITION BY DATE_TRUNC('month', order_date) ORDER BY daily_sales DESC)
```

---

## 📊 3. 집계 윈도우 함수

### 💰 SUM() OVER() - 누적 합계

```sql
-- 기본 누적
SUM(amount) OVER (ORDER BY order_date)

-- 그룹별 누적
SUM(amount) OVER (PARTITION BY customer_id ORDER BY order_date)

-- 월별 리셋 누적
SUM(daily_sales) OVER (
    PARTITION BY DATE_TRUNC('month', order_date)
    ORDER BY order_date
)
```

### 📈 AVG() OVER() - 이동 평균

```sql
-- 최근 7일 이동 평균
AVG(daily_sales) OVER (
    ORDER BY order_date
    ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
)

-- 앞뒤 3일 평균
AVG(daily_sales) OVER (
    ORDER BY order_date
    ROWS BETWEEN 3 PRECEDING AND 3 FOLLOWING
)

-- 전체 평균
AVG(daily_sales) OVER (
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
)
```

### 📅 ROWS vs RANGE

| 구분    | ROWS  | RANGE    |
| ----- | ----- | -------- |
| 기준    | 행 개수  | 값의 범위    |
| 사용례   | 최근 7일 | 같은 날짜 값들 |
| 동점 처리 | 개별 처리 | 함께 처리    |

---

## 🔄 4. 이동 함수: LAG / LEAD

### ⬅️ LAG() - 과거 데이터

```sql
LAG(컬럼명, 단계수, 기본값) OVER (PARTITION BY 그룹 ORDER BY 정렬)
```

예시:

```sql
-- 전월 대비
LAG(monthly_sales, 1) OVER (ORDER BY month) as 전월매출

-- 전년 동월 대비
LAG(monthly_sales, 12) OVER (ORDER BY month)

-- 이전 구매일
LAG(order_date, 1) OVER (PARTITION BY customer_id ORDER BY order_date)
```

### ➡️ LEAD() - 미래 데이터

```sql
-- 다음 구매일
LEAD(order_date, 1) OVER (PARTITION BY customer_id ORDER BY order_date)

-- 구매 간격 분석
LEAD(order_date) OVER (...) - order_date
```

---

## 📊 5. 분위수 함수들

### 🎯 NTILE() - 균등 분할

```sql
NTILE(4) OVER (ORDER BY 총구매금액)
```

* 고객/상품/성과 등급화에 활용

### 📈 PERCENT\_RANK() - 백분위

```sql
PERCENT_RANK() OVER (ORDER BY price)
```

* 상위 몇 %인지 확인 가능

---

## 🎯 6. FIRST\_VALUE / LAST\_VALUE

### 🥇 최고가 상품 예시

```sql
FIRST_VALUE(product_name) OVER (
  PARTITION BY category
  ORDER BY price DESC
  ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
)
```

### ✅ LAST\_VALUE 주의사항

```sql
-- 잘못된 예:
LAST_VALUE(price) OVER (PARTITION BY category ORDER BY price)

-- 올바른 예:
LAST_VALUE(price) OVER (
  PARTITION BY category ORDER BY price
  ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
)
```

---

## ⚡ 7. 성능 최적화 팁

### 🔧 인덱스 전략

```sql
CREATE INDEX idx_orders_customer_date ON orders(customer_id, order_date);
CREATE INDEX idx_orders_date_amount ON orders(order_date, amount);
CREATE INDEX idx_orders_region_date ON orders(region, order_date);
```

### 📊 성능 고려사항

| 요소           | 좋은 성능    | 나쁜 성능     |
| ------------ | -------- | --------- |
| ORDER BY     | 인덱스 있음   | 인덱스 없음    |
| PARTITION BY | 카디널리티 적당 | 너무 높음     |
| 데이터량         | 제한       | 전체 테이블 스캔 |

---

## 🎯 8. 실무 활용 시나리오

### 📈 매출 분석

```sql
WITH monthly_sales AS (...)
SELECT
  월,
  월매출,
  LAG(월매출, 1) OVER (ORDER BY 월) as 전월매출,
  AVG(월매출) OVER (ORDER BY 월 ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) as 3개월이동평균
FROM monthly_sales;
```

### 👥 고객 분석

```sql
SELECT
  customer_id,
  ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date) as 구매순서,
  SUM(amount) OVER (PARTITION BY customer_id ORDER BY order_date) as 누적구매금액,
  LAG(order_date, 1) OVER (PARTITION BY customer_id ORDER BY order_date) as 이전구매일
FROM orders;
```

### 🏆 순위 분석

```sql
SELECT
  product_name,
  RANK() OVER (ORDER BY 총매출 DESC) as 매출순위,
  RANK() OVER (PARTITION BY category ORDER BY 총매출 DESC) as 카테고리내순위,
  NTILE(4) OVER (ORDER BY 총매출) as 매출등급
FROM product_sales;
```

---

## 💡 9. 자주 하는 실수들

### ❌ 흔한 실수 & ✅ 해결 방법

* PARTITION BY 누락

```sql
❌ RANK() OVER (ORDER BY amount)
✅ RANK() OVER (PARTITION BY region ORDER BY amount)
```

* ORDER BY 누락

```sql
❌ LAG(amount) OVER (PARTITION BY customer_id)
✅ LAG(amount) OVER (PARTITION BY customer_id ORDER BY order_date)
```

* LAST\_VALUE에서 ROWS 생략

```sql
❌ LAST_VALUE(price) OVER (ORDER BY price)
✅ LAST_VALUE(price) OVER (ORDER BY price ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
```

* NULL 처리 미흡

```sql
❌ amount - LAG(amount) OVER (...)
✅ COALESCE(amount - LAG(amount) OVER (...), 0)
```
