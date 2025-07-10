# SQL advance

## 1. 윈도우 함수 기본 개념

윈도우 함수는 `OVER` 절을 사용하여 특정 행들의 집합(윈도우)에 대해 계산을 수행하는 함수입니다.

### 기본 구문
```sql
함수명() OVER (
    [PARTITION BY 컬럼명]
    [ORDER BY 컬럼명]
    [ROWS/RANGE 절]
)
```

## 2. PARTITION BY - 데이터 그룹화

`PARTITION BY`는 데이터를 특정 그룹으로 나누어 각 그룹 내에서 윈도우 함수를 적용합니다.

### 순위 함수들

#### ROW_NUMBER()
- 중복값이 있어도 연속된 순위를 부여
```sql
SELECT
    region,
    customer_id,
    amount,
    ROW_NUMBER() OVER (ORDER BY amount DESC) AS 전체순위,
    ROW_NUMBER() OVER (PARTITION BY region ORDER BY amount DESC) AS 지역순위
FROM orders;
```

#### RANK()
- 동일한 값에 같은 순위를 부여하고, 다음 순위는 건너뜀
```sql
SELECT
    region,
    customer_id,
    amount,
    RANK() OVER (ORDER BY amount DESC) AS 전체순위,
    RANK() OVER (PARTITION BY region ORDER BY amount DESC) AS 지역순위
FROM orders;
```

#### DENSE_RANK()
- 동일한 값에 같은 순위를 부여하지만, 다음 순위를 건너뛰지 않음
```sql
SELECT
    region,
    customer_id,
    amount,
    DENSE_RANK() OVER (ORDER BY amount DESC) AS 전체순위,
    DENSE_RANK() OVER (PARTITION BY region ORDER BY amount DESC) AS 지역순위
FROM orders;
```

## 3. 집계 윈도우 함수

### SUM() OVER() - 누적합

```sql
-- 일별 누적 매출액
WITH daily_sales AS (
    SELECT 
        order_date,
        SUM(amount) AS 일매출
    FROM orders
    WHERE order_date BETWEEN '2024-06-01' AND '2024-07-31'
    GROUP BY order_date
    ORDER BY order_date
)
SELECT
    order_date,
    일매출,
    SUM(일매출) OVER (ORDER BY order_date) as 누적매출,
    SUM(일매출) OVER (
        PARTITION BY DATE_TRUNC('month', order_date)
        ORDER BY order_date
    ) as 월누적매출
FROM daily_sales;
```

### AVG() OVER() - 이동평균

```sql
-- 이동평균 계산
SELECT
    order_date,
    일매출,
    ROUND(AVG(일매출) OVER(
        ORDER BY order_date
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    )) AS 이동평균7일,
    ROUND(AVG(일매출) OVER(
        ORDER BY order_date
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    )) AS 이동평균3일
FROM daily_sales;
```

## 4. LAG()와 LEAD() 함수

### LAG() - 이전 값 가져오기

```sql
-- 전월 대비 매출 분석
WITH monthly_sales AS (
    SELECT
        DATE_TRUNC('month', order_date) AS 월,
        SUM(amount) AS 월매출
    FROM orders
    GROUP BY 월
),
compare_before AS (
    SELECT
        TO_CHAR(월, 'YYYY-MM') as 년월,
        월매출,
        LAG(월매출, 1) OVER (ORDER BY 월) AS 전월매출
    FROM monthly_sales
)
SELECT
    *,
    월매출 - 전월매출 AS 증감액,
    CASE
        WHEN 전월매출 IS NULL THEN NULL
        ELSE ROUND((월매출 - 전월매출) * 100 / 전월매출, 2)::TEXT || '%'
    END AS 증감률
FROM compare_before;
```

### LEAD() - 다음 값 가져오기

```sql
-- 고객별 다음 구매 예측
SELECT
    customer_id,
    order_date AS 구매일,
    amount,
    LEAD(order_date, 1) OVER (PARTITION BY customer_id ORDER BY order_date) AS 다음구매일,
    LEAD(amount, 1) OVER (PARTITION BY customer_id ORDER BY order_date) AS 다음구매금액
FROM orders
ORDER BY customer_id, order_date;
```

## 5. 고급 윈도우 함수

### NTILE() - 균등 분할

```sql
-- 고객을 4등분으로 나누어 등급 부여
WITH customer_totals AS (
    SELECT
        customer_id,
        SUM(amount) AS 총구매금액,
        COUNT(*) AS 구매횟수
    FROM orders
    GROUP BY customer_id
),
customer_grade as (
    SELECT
        customer_id,
        총구매금액,
        구매횟수,
        NTILE(4) OVER (ORDER BY 총구매금액) AS 분위4,
        NTILE(10) OVER (ORDER BY 총구매금액) AS 분위10
    FROM customer_totals
    ORDER BY 총구매금액 DESC
)
SELECT
    c.customer_name,
    cg.총구매금액,
    cg.구매횟수,
    CASE
        WHEN 분위4=1 THEN 'Bronze'
        WHEN 분위4=2 THEN 'Silver'
        WHEN 분위4=3 THEN 'Gold'
        WHEN 분위4=4 THEN 'VIP'
    END AS 고객등급
FROM customer_grade cg
INNER JOIN customers c ON cg.customer_id = c.customer_id;
```

### PERCENT_RANK() - 백분위 순위

```sql
-- 상품 가격 백분위 순위
SELECT
    product_name,
    category,
    price,
    RANK() OVER (ORDER BY price) AS 가격순위,
    PERCENT_RANK() OVER (ORDER BY price) AS 백분위순위,
    CASE
        WHEN PERCENT_RANK() OVER (ORDER BY price) <= 0.9 THEN '최고가(상위10%)'
        WHEN PERCENT_RANK() OVER (ORDER BY price) <= 0.7 THEN '고가(상위30%)'
        WHEN PERCENT_RANK() OVER (ORDER BY price) <= 0.3 THEN '중간가(상위70%)'
        ELSE '저가(하위30%)'
    END AS 가격등급
FROM products;
```

### FIRST_VALUE()와 LAST_VALUE() - 첫 번째/마지막 값

```sql
-- 카테고리별 최고가/최저가 상품 찾기
SELECT
    category,
    product_name,
    price,
    FIRST_VALUE(product_name) OVER (
        PARTITION BY category
        ORDER BY price DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS 최고가상품명,
    FIRST_VALUE(price) OVER (
        PARTITION BY category
        ORDER BY price DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS 최고가격,
    LAST_VALUE(product_name) OVER (
        PARTITION BY category
        ORDER BY price DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS 최저가상품명,
    LAST_VALUE(price) OVER (
        PARTITION BY category
        ORDER BY price DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS 최저가격
FROM products;
```

## 6. 윈도우 프레임 지정

### ROWS 절 옵션

- `ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW`: 처음부터 현재 행까지
- `ROWS BETWEEN 2 PRECEDING AND CURRENT ROW`: 이전 2개 행부터 현재 행까지
- `ROWS BETWEEN 6 PRECEDING AND CURRENT ROW`: 이전 6개 행부터 현재 행까지
- `ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING`: 파티션의 모든 행

## 7. 실무 활용 예제

### 고객 구매 패턴 분석

```sql
-- 고객별 상세 구매 분석
WITH order_analysis AS (
    SELECT
        customer_id,
        order_date AS 구매일,
        amount AS 구매액,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date) AS 구매순서,
        LAG(order_date, 1) OVER (PARTITION BY customer_id ORDER BY order_date) AS 이전구매일,
        LAG(amount, 1) OVER (PARTITION BY customer_id ORDER BY order_date) AS 이전구매액,
        SUM(amount) OVER (PARTITION BY customer_id ORDER BY order_date) AS 누적구매금액,
        AVG(amount) OVER (
            PARTITION BY customer_id 
            ORDER BY order_date
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS 누적평균구매금액
    FROM orders
)
SELECT
    customer_id,
    구매일,
    구매액,
    구매순서,
    구매일 - 이전구매일 AS 구매간격,
    구매액 - 이전구매액 AS 금액변화,
    누적구매금액,
    ROUND(누적평균구매금액, 2) AS 누적평균구매금액,
    CASE    
        WHEN 구매순서 = 1 THEN '첫구매'
        WHEN 구매순서 <= 3 THEN '초기고객'
        WHEN 구매순서 <= 10 THEN '일반고객'
        ELSE 'VIP고객'
    END AS 구매등급
FROM order_analysis
WHERE customer_id = 'CUST-000001';
```

## 8. 주요 함수 정리

| 함수명 | 설명 | 사용법 |
|--------|------|--------|
| `ROW_NUMBER()` | 연속된 순위 부여 | `ROW_NUMBER() OVER (ORDER BY 컬럼)` |
| `RANK()` | 동일값 같은 순위, 다음 순위 건너뜀 | `RANK() OVER (ORDER BY 컬럼)` |
| `DENSE_RANK()` | 동일값 같은 순위, 다음 순위 연속 | `DENSE_RANK() OVER (ORDER BY 컬럼)` |
| `LAG()` | 이전 행의 값 가져오기 | `LAG(컬럼, 행수) OVER (ORDER BY 컬럼)` |
| `LEAD()` | 다음 행의 값 가져오기 | `LEAD(컬럼, 행수) OVER (ORDER BY 컬럼)` |
| `SUM() OVER()` | 누적합 계산 | `SUM(컬럼) OVER (ORDER BY 컬럼)` |
| `AVG() OVER()` | 이동평균 계산 | `AVG(컬럼) OVER (ROWS BETWEEN n PRECEDING AND CURRENT ROW)` |
| `NTILE()` | 균등 분할 | `NTILE(n) OVER (ORDER BY 컬럼)` |
| `PERCENT_RANK()` | 백분위 순위 | `PERCENT_RANK() OVER (ORDER BY 컬럼)` |
| `FIRST_VALUE()` | 첫 번째 값 | `FIRST_VALUE(컬럼) OVER (PARTITION BY 컬럼 ORDER BY 컬럼)` |
| `LAST_VALUE()` | 마지막 값 | `LAST_VALUE(컬럼) OVER (PARTITION BY 컬럼 ORDER BY 컬럼)` |

## 9. 주의사항

1. **LAST_VALUE() 사용시**: `ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING`을 명시해야 정확한 결과를 얻을 수 있습니다.
2. **PARTITION BY**: 각 파티션별로 윈도우 함수가 초기화됩니다.
3. **ORDER BY**: 정렬 순서에 따라 결과가 달라집니다.
4. **NULL 값 처리**: LAG/LEAD 함수에서 첫 번째/마지막 행은 NULL이 될 수 있습니다.