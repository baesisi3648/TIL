# SQL advance

## 🎯 오늘 배운 핵심 내용

- **UNION**: 여러 쿼리 결과 합치기  
- **서브쿼리 반환 유형**: 스칼라, 벡터, 매트릭스  
- **Inline View & View**: 쿼리 재사용과 가상 테이블  
- **SQL 작성 주의사항**: JOIN, GROUP BY 등 실수 방지  

## 🔗 1. UNION - 여러 쿼리 결과 합치기

### 💡 UNION의 개념
여러 SELECT 쿼리의 결과를 세로로(행 방향) 합치는 기능

```sql
-- 기본 UNION 사용법
SELECT '고객 테이블' AS 구분, COUNT(*) AS 데이터수 FROM customers
UNION ALL
SELECT '매출 테이블' AS 구분, COUNT(*) AS 데이터수 FROM sales;
```

```sql
-- UNION vs UNION ALL
SELECT customer_type FROM customers  -- 중복 제거
UNION
SELECT customer_type FROM customers;

SELECT customer_type FROM customers  -- 중복 포함
UNION ALL
SELECT customer_type FROM customers;
```

### 🎯 UNION 실전 활용 - 통합 리포트 만들기

```sql
-- 카테고리별 + 고객유형별 통합 분석
SELECT
    '카테고리별' AS 분석유형,
    category AS 구분,
    COUNT(*) AS 건수,
    SUM(total_amount) AS 총액
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY category

UNION ALL

SELECT
    '고객유형별' AS 분석유형,
    customer_type AS 구분,
    COUNT(*) AS 건수,
    SUM(total_amount) AS 총액
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
GROUP BY customer_type

ORDER BY 분석유형, 총액 DESC;
```

### ⚠️ UNION 주의사항

- **컬럼 수 일치**
- **데이터 타입 호환**
- **컬럼명은 첫 번째 SELECT 기준**

## 📊 2. 서브쿼리 반환 유형

### 🔢 스칼라 서브쿼리 (Scalar Subquery)

```sql
SELECT
    product_name,
    total_amount,
    (SELECT AVG(total_amount) FROM sales) AS 전체평균,
    total_amount - (SELECT AVG(total_amount) FROM sales) AS 평균차이
FROM sales
WHERE total_amount > (SELECT AVG(total_amount) FROM sales);
```

### 📋 복수행(Vector) 서브쿼리

```sql
SELECT * FROM sales
WHERE customer_id IN (
    SELECT customer_id FROM customers WHERE customer_type = 'VIP'
);

SELECT * FROM sales
WHERE customer_id IN (
    SELECT DISTINCT customer_id FROM sales WHERE category = '전자제품'
);
```

### 📋 Inline View(Matrix)

```sql
SELECT c.customer_name
FROM customers c
WHERE EXISTS (
    SELECT s.customer_id, s.product_name, s.total_amount
    FROM sales s
    WHERE s.customer_id = c.customer_id AND s.total_amount >= 1000000
);
```

### 🎯 서브쿼리 유형 비교

| 유형     | 반환값        | 사용 위치         | 연산자     | 예시 |
|----------|---------------|-------------------|------------|------|
| 스칼라   | 1행 1열       | SELECT, WHERE     | =, >, <    | WHERE amount > (SELECT AVG...) |
| 벡터     | 여러행 1열    | WHERE, HAVING     | IN, ANY    | WHERE id IN (SELECT...) |
| 매트릭스 | 여러행 여러열 | FROM, EXISTS      | EXISTS     | WHERE EXISTS (SELECT...) |

## 📋 3. Inline View & View

### 💡 Inline View

```sql
SELECT *
FROM (
    SELECT
        category,
        AVG(total_amount) AS 평균매출,
        COUNT(*) AS 주문건수
    FROM sales s
    JOIN products p ON s.product_id = p.product_id
    GROUP BY category
) AS category_stats
WHERE 평균매출 >= 500000;
```

```sql
-- 복잡한 고객 분석
SELECT
    고객상태,
    COUNT(*) AS 고객수,
    AVG(총매출액) AS 평균매출액
FROM (
    SELECT
        c.customer_name,
        SUM(s.total_amount) AS 총매출액,
        CASE
            WHEN MAX(s.order_date) IS NULL THEN '미구매'
            WHEN DATEDIFF(CURDATE(), MAX(s.order_date)) <= 30 THEN '활성'
            ELSE '휴면'
        END AS 고객상태
    FROM customers c
    LEFT JOIN sales s ON c.customer_id = s.customer_id
    GROUP BY c.customer_id, c.customer_name
) AS customer_analysis
GROUP BY 고객상태;
```

### 📋 View (뷰)

```sql
-- View 생성
CREATE VIEW customer_summary AS
SELECT
    c.customer_id,
    c.customer_name,
    c.customer_type,
    COUNT(s.id) AS 주문횟수,
    COALESCE(SUM(s.total_amount), 0) AS 총구매액,
    COALESCE(AVG(s.total_amount), 0) AS 평균주문액
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
GROUP BY c.customer_id, c.customer_name, c.customer_type;

-- View 사용
SELECT * FROM customer_summary WHERE 주문횟수 >= 5;
SELECT * FROM customer_summary WHERE customer_type = 'VIP';

-- View 삭제
DROP VIEW customer_summary;
```

### 🔄 Inline View vs View 비교

| 구분       | Inline View         | View                    |
|------------|---------------------|--------------------------|
| 저장 여부  | 일회용              | DB에 저장                |
| 재사용     | 불가                | 가능                    |
| 성능       | 매번 실행           | 재사용 가능             |
| 용도       | 일회성 분석용       | 반복적 쿼리 용도         |

## ⚠️ 4. SQL 작성 주의사항

### 🔗 JOIN 관련 주의사항

1. **별명 필수**  
2. **JOIN 조건 명확히**
3. **LEFT JOIN에서 COUNT 주의**

### 📊 GROUP BY 관련 주의사항

- SELECT 컬럼은 GROUP BY에 모두 포함
- HAVING과 WHERE 구분

### 🔄 서브쿼리 주의사항

- 스칼라 서브쿼리는 반드시 단일 값
- LEFT JOIN 시 NULL 처리

---

## 💡 핵심 패턴 정리

### 🎯 문제 해결 접근법

- 문제를 단계별로 나눠보기
- 인라인 뷰로 서브쿼리 집계 + 조건 처리
- JOIN 적절히 선택
- NULL 처리 잊지 말기

### 📝 SQL 작성 체크리스트

- [ ] 테이블 별명 사용했나?  
- [ ] JOIN 조건 명확한가?  
- [ ] GROUP BY 컬럼 완비했나?  
- [ ] COUNT(*) 대신 COUNT(컬럼) 사용했나?  
- [ ] NULL 값 처리했나?  
- [ ] 서브쿼리 반환값 맞췄나?  