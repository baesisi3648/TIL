# SQL advance

## CTE (Common Table Expression) & Window Functions 정리

## ✅ CTE vs Subquery vs View 비교표

| 항목      | CTE (WITH)         | 서브쿼리 (Inline View) | VIEW (뷰)                |
| ------- | ------------------ | ------------------ | ----------------------- |
| 정의 방식   | WITH name AS (...) | SELECT 안에 SELECT   | CREATE VIEW name AS ... |
| 지속성     | ✖ 일회성 (한 쿼리 내)     | ✖ 일회성 (해당 구문 내)    | ✔ 영구 (DB 객체)            |
| 재사용 가능성 | ✖ 같은 쿼리 안에서만       | ✖ 불가               | ✔ 여러 쿼리에서 재사용           |
| 가독성     | ✔ 뛰어남              | ✖ 복잡해지기 쉬움         | ✔ 외부에서 보기 쉬움            |
| 재귀 지원   | ✔ WITH RECURSIVE   | ✖ 불가               | ✖ 불가                    |
| 인덱스 사용  | ✔ 가능               | ✔ 가능               | ✔ 가능 (주의 필요)            |
| 파라미터 전달 | ✖ 불가               | ✖ 불가               | ✖ (함수 필요)               |
| 권한 제어   | ✖ 불가               | ✖ 불가               | ✔ SELECT 권한 부여 가능       |

## ✅ 예제 비교

### 📌 1. CTE (WITH절)

```sql
WITH high_salary AS (
  SELECT * FROM employees WHERE salary > 50000
)
SELECT name FROM high_salary WHERE department = 'Sales';
```

### 📌 2. 서브쿼리

```sql
SELECT name
FROM (
  SELECT * FROM employees WHERE salary > 50000
) AS high_salary
WHERE department = 'Sales';
```

### 📌 3. VIEW

```sql
CREATE VIEW high_salary AS
SELECT * FROM employees WHERE salary > 50000;

SELECT name FROM high_salary WHERE department = 'Sales';
```

## ✅ 무엇을 언제 써야 할까?

| 상황               | 추천 도구                | 이유               |
| ---------------- | -------------------- | ---------------- |
| 복잡한 쿼리를 쪼개고 싶다   | CTE                  | 쿼리 구조 나누기 가능     |
| 즉석에서 한 번만 사용할 경우 | 서브쿼리                 | 가장 간단한 방법        |
| 여러 쿼리에서 반복 사용    | VIEW                 | 유지보수 및 권한 부여에 유리 |
| 재귀 구조 (조직도 등)    | CTE (WITH RECURSIVE) | 유일한 재귀 쿼리 수단     |
| 보안상 원본 감추기       | VIEW                 | SELECT 권한만 부여 가능 |

### ✨ 요약 한 줄

* **CTE**: 쿼리 내 구조 정리, 가독성 향상
* **서브쿼리**: 가장 간단한 즉석용 쿼리
* **VIEW**: 자주 쓰는 쿼리의 영구 저장

---

# 🎯 CTE란 무엇인가?

## 📚 한 줄 정의

CTE(Common Table Expression)는 **복잡한 쿼리를 단계별로 나누어 작성할 수 있는 임시 테이블**입니다.

## 🏗️ 기본 구조

```sql
WITH 단계1 AS (
    SELECT ...
),
단계2 AS (
    SELECT ... FROM 단계1
)
SELECT * FROM 단계2;
```

## 💡 CTE의 3가지 핵심 장점

### 1. 가독성 향상

```sql
WITH customer_region AS (
    SELECT region FROM customers WHERE customer_id = 'CUST-001'
),
region_avg AS (
    SELECT AVG(amount) as avg_amount
    FROM orders o JOIN customer_region cr ON o.region = cr.region
)
SELECT * FROM orders o JOIN region_avg ra ON o.amount > ra.avg_amount;
```

### 2. 성능 향상 (중복 계산 제거)

```sql
WITH avg_amount AS (
    SELECT AVG(amount) as avg_val FROM orders
)
SELECT customer_id, avg_val, amount - avg_val FROM orders, avg_amount;
```

### 3. 재사용성

```sql
WITH monthly_sales AS (
    SELECT DATE_TRUNC('month', order_date) as month, SUM(amount) as sales
    FROM orders GROUP BY month
)
SELECT month, sales FROM monthly_sales WHERE sales > 1000000
UNION ALL
SELECT '평균', AVG(sales) FROM monthly_sales;
```

---

## 🎯 CTE 활용 시나리오

### 📈 1. 단계별 계산 (매출 증감률)

```sql
WITH monthly_sales AS (
    SELECT DATE_TRUNC('month', order_date) as month, SUM(amount) as sales
    FROM orders GROUP BY month
),
sales_with_prev AS (
    SELECT ms1.month, ms1.sales, ms2.sales as prev_sales
    FROM monthly_sales ms1
    LEFT JOIN monthly_sales ms2 ON ms1.month = ms2.month + INTERVAL '1 month'
)
SELECT month, sales,
       ROUND((sales - prev_sales) * 100.0 / prev_sales, 2) as growth_rate
FROM sales_with_prev;
```

### 🏆 2. 복잡한 등급화

```sql
WITH customer_stats AS (
    SELECT customer_id, SUM(amount) as total_purchase
    FROM orders GROUP BY customer_id
),
purchase_thresholds AS (
    SELECT AVG(total_purchase) as avg_purchase,
           PERCENTILE_CONT(0.8) WITHIN GROUP (ORDER BY total_purchase) as vip_threshold
    FROM customer_stats
),
customer_grades AS (
    SELECT cs.*, CASE
           WHEN total_purchase >= pt.vip_threshold THEN 'VIP'
           WHEN total_purchase >= pt.avg_purchase THEN '우수'
           ELSE '일반'
           END as grade
    FROM customer_stats cs CROSS JOIN purchase_thresholds pt
)
SELECT grade, COUNT(*) as 고객수, AVG(total_purchase) as 평균구매액
FROM customer_grades GROUP BY grade;
```

### 🔢 3. TOP-N 분석

```sql
WITH regional_sales AS (
    SELECT c.region, c.customer_name, SUM(o.amount) as total_sales
    FROM customers c JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.region, c.customer_name
)
SELECT region, customer_name, total_sales
FROM (
  SELECT *,
         ROW_NUMBER() OVER (PARTITION BY region ORDER BY total_sales DESC) as rank
  FROM regional_sales
) ranked
WHERE rank <= 3;
```

---

## 🔄 재귀 CTE 활용법

### 1. 계층 구조 (조직도)

```sql
WITH RECURSIVE org_tree AS (
    SELECT employee_id, employee_name, manager_id, 1 as level
    FROM employees WHERE manager_id IS NULL
    UNION ALL
    SELECT e.employee_id, e.employee_name, e.manager_id, ot.level + 1
    FROM employees e JOIN org_tree ot ON e.manager_id = ot.employee_id
)
SELECT REPEAT('  ', level-1) || employee_name as org_chart FROM org_tree;
```

### 2. 연속 날짜 생성

```sql
WITH RECURSIVE date_range AS (
    SELECT '2024-01-01'::date as date_val
    UNION ALL
    SELECT date_val + 1 FROM date_range WHERE date_val < '2024-01-31'
)
SELECT d.date_val, COALESCE(SUM(o.amount), 0) as daily_sales
FROM date_range d LEFT JOIN orders o ON d.date_val = o.order_date
GROUP BY d.date_val ORDER BY d.date_val;
```

---

# 📊 윈도우 함수 (Window Functions)

## 🎯 핵심 정의

> 윈도우 함수는 "집계 결과를 행별로 계산"하는 함수로, `OVER()` 구문과 함께 사용됩니다.

### 🔹 대표 함수

| 함수                | 설명                     |
| ----------------- | ---------------------- |
| `ROW_NUMBER()`    | 정렬 기준으로 행 번호 부여        |
| `RANK()`          | 동일값은 같은 순위, 다음 순위 건너뜀  |
| `DENSE_RANK()`    | 동일값 같은 순위, 다음 순위 안 건너뜀 |
| `NTILE(N)`        | N등분하여 그룹핑              |
| `SUM() OVER()`    | 누적합 계산                 |
| `AVG() OVER()`    | 누적 평균                  |
| `LAG()`, `LEAD()` | 이전/다음 행 값 가져오기         |

## 📌 사용 예시

### 1. `ROW_NUMBER()`

```sql
SELECT *, ROW_NUMBER() OVER (PARTITION BY region ORDER BY total_sales DESC) as rank
FROM regional_sales;
```

### 2. 누적합 (`SUM OVER`)

```sql
SELECT customer_id, order_date, amount,
       SUM(amount) OVER (PARTITION BY customer_id ORDER BY order_date) as 누적합
FROM orders;
```

### 3. `LAG()` / `LEAD()` 예시

```sql
SELECT order_id, customer_id, amount,
       LAG(amount) OVER (PARTITION BY customer_id ORDER BY order_date) as 이전금액,
       LEAD(amount) OVER (PARTITION BY customer_id ORDER BY order_date) as 다음금액
FROM orders;
```

---

## ✅ 실무 적용 체크리스트

### CTE 사용해야 할 때

* 중첩된 서브쿼리가 복잡할 때
* 계산을 단계별로 나눌 때
* 중간 결과를 여러 번 사용할 때
* 재귀 구조가 필요할 때 (조직도 등)

### 윈도우 함수 사용해야 할 때

* 순위 매기기 (TOP-N)
* 누적/이전/다음 값 계산
* 이동 평균 / 증감 분석

---

## 🔚 핵심 요약

> 💡 **CTE는 쿼리를 읽기 좋게 만들고**, **윈도우 함수는 집계 결과를 각 행에 부여**하는 데 강력한 도구입니다. SQL 분석 작업의 수준을 한 단계 끌어올리는 핵심 기능입니다.
