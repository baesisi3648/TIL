
# SQL advance (서브쿼리, JOIN)

## TIL
1. JOIN/GROUP BY 문제 많이 풀어보기
2. COALESCE() 함수 유용하니까 숙지!
3. GROUP BY로 묶은 컬럼은 위에 반드시 적어야함.

## 🎯 오늘 배운 핵심 내용
1. 서브쿼리 기초 : 쿼리 안의 쿼리로 조건 만들기
2. JOIN 기초 :  여러 테이블 연결하여 정보 합치기
3. GROUP BY + JOIN : 연결된 데이터를 그룹별로 집계

## 🔍 1. 서브쿼리 (Subquery)

### 💡 서브쿼리란?
다른 쿼리의 결과를 조건이나 값으로 사용하는 쿼리  
예: "평균보다 높은 매출의 주문들을 보여줘"

```sql
-- 평균보다 높은 주문 찾기
SELECT * FROM sales
WHERE total_amount > (SELECT AVG(total_amount) FROM sales);
```

### 🎯 서브쿼리 기본 패턴들

#### 1. 평균과 비교
```sql
SELECT
    product_name,
    total_amount,
    total_amount - (SELECT AVG(total_amount) FROM sales) AS 평균차이
FROM sales
WHERE total_amount > (SELECT AVG(total_amount) FROM sales);
```

#### 2. 최대/최소값 찾기
```sql
SELECT * FROM sales
WHERE total_amount = (SELECT MAX(total_amount) FROM sales);
```

#### 3. 목록에 포함된 것들 (IN)
```sql
SELECT * FROM sales
WHERE customer_id IN (
    SELECT customer_id FROM customers WHERE customer_type = 'VIP'
);
```

#### 💡 서브쿼리 핵심 포인트
- 괄호 필수: `(SELECT ...)`
- `=`: 단일 값 / `IN`: 다중 값
- 실행 순서: 서브쿼리 → 외부 쿼리

---

## 🔗 2. JOIN - 테이블 연결하기

### 💡 JOIN이 필요한 이유
서브쿼리보다 효율적으로 여러 테이블의 데이터를 합칠 수 있음

```sql
-- INNER JOIN 방식 (효율적)
SELECT
    c.customer_name,
    c.customer_type,
    s.product_name,
    s.total_amount
FROM customers c
INNER JOIN sales s ON c.customer_id = s.customer_id;
```

### 🎯 INNER JOIN vs LEFT JOIN

| JOIN 종류 | 설명 | 예시 |
|-----------|------|------|
| `INNER JOIN` | 양쪽 다 매칭될 때만 출력 | 출력 ❌            | 주문한 고객만 |
| `LEFT JOIN`  | 왼쪽 테이블은 모두 출력  | 오른쪽은 NULL로 채움   | 주문 없는 고객도 포함 |
| `RIGHT JOIN` | 오른쪽 테이블은 모두 출력 | 왼쪽은 NULL로 채움    |  |


---

## 🔧 JOIN 문법
```sql
SELECT 컬럼들
FROM 테이블1 별명1
[INNER/LEFT] JOIN 테이블2 별명2 ON 조건
WHERE 추가조건;
```

---

## 🎯 JOIN 실전 예시

### 1. VIP 고객들의 구매 내역
```sql
SELECT c.customer_name, s.product_name, s.total_amount
FROM customers c
INNER JOIN sales s ON c.customer_id = s.customer_id
WHERE c.customer_type = 'VIP';
```

### 2. 주문 없는 잠재 고객 찾기
```sql
SELECT c.customer_name, c.join_date
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
WHERE s.customer_id IS NULL;
```

---

## 📊 3. GROUP BY + JOIN

### 💡 왜 필요한가?
→ 고객 정보 + 주문 정보 연결 + 그룹별 집계

### 예시: 고객유형별 평균구매금액
```sql
SELECT
    c.customer_type,
    COUNT(*) AS 주문건수,
    AVG(s.total_amount) AS 평균구매금액
FROM customers c
INNER JOIN sales s ON c.customer_id = s.customer_id
GROUP BY c.customer_type;
```

### LEFT JOIN + GROUP BY
```sql
SELECT
    c.customer_name,
    COUNT(s.id) AS 주문횟수,
    COALESCE(SUM(s.total_amount), 0) AS 총구매액,
    COALESCE(AVG(s.total_amount), 0) AS 평균주문액,
    CASE
        WHEN COUNT(s.id) = 0 THEN '잠재고객'
        WHEN COUNT(s.id) >= 5 THEN '충성고객'
        ELSE '일반고객'
    END AS 고객분류
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
GROUP BY c.customer_id, c.customer_name, c.customer_type
ORDER BY 총구매액 DESC;
```

---

## 🚨 GROUP BY + JOIN 주의사항

### 1. GROUP BY에 모든 일반 컬럼 포함
```sql
SELECT c.customer_name, COUNT(*)
FROM customers c JOIN sales s ON c.customer_id = s.customer_id
GROUP BY c.customer_id, c.customer_name;
```

### 2. LEFT JOIN에서 COUNT 사용
```sql
-- ❌ 주문 없는 고객도 1로 나옴
COUNT(*)

-- ✅ 올바름
COUNT(s.id)
```

### 3. NULL 값 처리
```sql
COALESCE(SUM(s.total_amount), 0)
COALESCE(MAX(s.order_date), '주문없음')
```

---

## 🎯 핵심 패턴 정리

### 1. 서브쿼리
| 상황 | 패턴 | 예시 |
|------|------|------|
| 평균보다 높음 | `WHERE 컬럼 > (SELECT AVG(...))` | 매출 비교 |
| 최대/최소값 | `WHERE 컬럼 = (SELECT MAX(...))` | 최고 매출 |
| 목록 포함 | `WHERE 컬럼 IN (SELECT ...)` | VIP 주문 |

### 2. JOIN 선택
| 상황 | JOIN 종류 | 이유 |
|------|------------|------|
| 실제 고객 분석 | INNER JOIN | 양쪽에 다 있음 |
| 전체 고객 현황 | LEFT JOIN | 고객 전체 포함 필요 |

### 3. GROUP BY + JOIN
```sql
SELECT 그룹컬럼, COUNT(오른쪽.id), COALESCE(SUM(...), 0)
FROM 왼쪽 LEFT JOIN 오른쪽 ON 조건
GROUP BY 그룹컬럼들
```

---

## 💡 자주 하는 실수들

### 1. 별명 안 쓰기
```sql
-- ❌ 혼동 발생
customer_id = customer_id

-- ✅ 명확하게
c.customer_id = s.customer_id
```

### 2. GROUP BY 누락
```sql
-- ❌ 오류 발생
SELECT customer_name, COUNT(*) FROM sales;

-- ✅ 올바름
SELECT customer_name, COUNT(*) FROM sales GROUP BY customer_name;
```

### 3. COUNT(*) 오용
```sql
-- ❌ LEFT JOIN에서 COUNT(*)
-- ✅ COUNT(s.id)
```

---

## 🏠 복습 과제
1. 각 카테고리별 평균 매출보다 높은 주문들 (서브쿼리)
2. 모든 고객의 주문 통계 (LEFT JOIN + GROUP BY)
3. 주문 없는 고객들 찾기 (LEFT JOIN + WHERE NULL)
4. VIP 고객들의 카테고리별 구매 패턴 (INNER JOIN + GROUP BY)