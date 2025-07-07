
# SQL advance

## 오늘 배운 내용 
- 테이블 관계 설계 (1:1, 1:N, N:M)
- 고급 JOIN (FULL OUTER, CROSS, Self JOIN)
- 고급 서브쿼리 (ANY, ALL, EXISTS vs IN)
- PostgreSQL vs MySQL 비교
- PostgreSQL 특화 데이터 타입
- 대용량 데이터 생성 & 성능 측정
- EXPLAIN 분석 방법

---

## 🔗 1. 테이블 관계 설계 완전 정리

### 1.1 관계 유형별 특징

#### ✅ 1:1 관계 (One-to-One)
**사용 사례**: 직원 ↔ 직원상세정보 (보안상 분리)

```sql
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    department VARCHAR(30)
);

CREATE TABLE employee_details (
    emp_id INT PRIMARY KEY,
    social_number VARCHAR(20),
    salary DECIMAL(10,2),
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id) ON DELETE CASCADE
);
```

- 보안/성능상 테이블 분리 필요
- 같은 Primary Key 사용
- CASCADE 옵션으로 데이터 일관성 유지

#### ✅ 1:N 관계 (One-to-Many)
**사용 사례**: 고객 ↔ 주문

- 외래키는 항상 'N'쪽 테이블에 존재
- 부모 삭제 시 자식 데이터 처리 방식 고려 (ON DELETE)
- 실무에서 가장 자주 사용되는 관계

#### ✅ N:M 관계 (Many-to-Many)
**사용 사례**: 학생 ↔ 수업

```sql
CREATE TABLE students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(50)
);

CREATE TABLE courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100)
);

CREATE TABLE student_courses (
    student_id INT,
    course_id INT,
    enrollment_date DATE,
    grade VARCHAR(5),
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);
```

- 반드시 중간 테이블(Junction Table) 필요
- 중간 테이블에 추가 속성 저장 가능
- 복합 기본키 사용

---

## 🔗 2. 고급 JOIN 패턴

### 2.1 FULL OUTER JOIN (MySQL에서 구현)
MySQL은 FULL OUTER JOIN을 직접 지원하지 않으므로 `UNION`으로 구현

```sql
SELECT c.customer_name, s.product_name, 'LEFT에서' AS 출처
FROM customers c LEFT JOIN sales s ON c.customer_id = s.customer_id
UNION
SELECT c.customer_name, s.product_name, 'RIGHT에서' AS 출처
FROM customers c RIGHT JOIN sales s ON c.customer_id = s.customer_id
WHERE c.customer_id IS NULL;
```

**활용 예시**: 데이터 무결성 검사, 마스터 데이터 통합

### 2.2 CROSS JOIN (카르테시안 곱)
모든 조합 생성

```sql
SELECT c.customer_name, p.product_name, p.selling_price
FROM customers c
CROSS JOIN products p
WHERE c.customer_type = 'VIP'
ORDER BY c.customer_name, p.selling_price DESC;
```

**활용 예시**:
- 추천 시스템
- 시나리오 분석
- 날짜 테이블 생성

### 2.3 Self JOIN (같은 테이블끼리)

```sql
SELECT 직원.emp_name AS 직원명, 상사.emp_name AS 상사명
FROM employees 직원
LEFT JOIN employees 상사 ON 직원.manager_id = 상사.emp_id;
```

**활용 예시**:
- 조직도 구성
- 고객 유사도 분석
- 연속 구매 패턴

---

## ⚡ 3. 고급 서브쿼리 연산자

### 3.1 `ANY` 연산자 - 하나라도 만족
```sql
SELECT product_name, total_amount
FROM sales
WHERE total_amount > ANY (
    SELECT s.total_amount
    FROM sales s
    JOIN customers c ON s.customer_id = c.customer_id
    WHERE c.customer_type = 'VIP'
);
```

### 3.2 `ALL` 연산자 - 모두 만족

```sql
SELECT product_name, total_amount
FROM sales
WHERE total_amount > ALL (
    SELECT s.total_amount
    FROM sales s
    JOIN customers c ON s.customer_id = c.customer_id
    WHERE c.customer_type = 'VIP'
);
```

### 3.3 `EXISTS` vs `IN` 성능 비교

```sql
-- IN 방식
SELECT customer_name
FROM customers
WHERE customer_id IN (
    SELECT customer_id FROM sales WHERE category = '전자제품'
);

-- EXISTS 방식 (성능 우수)
SELECT customer_name
FROM customers c
WHERE EXISTS (
    SELECT 1 FROM sales s WHERE s.customer_id = c.customer_id AND s.category = '전자제품'
);
```

- EXISTS: 조건 만족 여부만 확인 → 대용량에 유리
- IN: 작은 값 목록에는 유리

---

## 🆚 4. PostgreSQL vs MySQL

| 항목 | MySQL | PostgreSQL |
|------|-------|------------|
| 철학 | 빠르고 간단 | 표준 준수, 고급 기능 |
| 대상 | 웹 애플리케이션 | 엔터프라이즈, 분석 |
| 강점 | 단순 읽기 성능 | 복잡 쿼리 최적화 |
| 타입 | VARCHAR, JSON 등 | 배열, JSONB, 범위 타입 등 |
| 추천 | 빠른 CRUD | 복잡한 분석, JSON 처리 |

---

## 📊 5. PostgreSQL 특화 기능

### 5.1 `generate_series()`로 대용량 데이터 생성

```sql
SELECT generate_series(1, 1000000) AS id;
SELECT generate_series('2024-01-01'::date, '2024-12-31'::date, '1 day') AS dates;
```

### 예시 테이블 생성

```sql
CREATE TABLE large_orders AS
SELECT
    generate_series(1, 1000000) AS order_id,
    'CUST-' || LPAD((random() * 50000)::text, 6, '0') AS customer_id,
    (random() * 1000000)::NUMERIC(12,2) AS amount,
    ARRAY['전자제품', '의류', '생활용품'][CEIL(random() * 3)::int] AS categories,
    jsonb_build_object('payment', 'card', 'express', random() < 0.3) AS details
FROM generate_series(1, 1000000);
```

### 고급 검색

```sql
-- 배열 검색
SELECT * FROM orders WHERE '전자제품' = ANY(categories);

-- JSONB 검색
SELECT * FROM orders WHERE details @> '{"express": true}';

-- 범위 검색
SELECT * FROM products WHERE price_range @> 50000;
```

---

## 🔍 6. EXPLAIN 분석 비교

### MySQL

```sql
EXPLAIN SELECT * FROM sales WHERE customer_id = 'C001';
```

- `type`: const > eq_ref > ref > range > index > ALL
- `Extra`: Using index (좋음), Using filesort (주의)

### PostgreSQL

```sql
EXPLAIN ANALYZE SELECT * FROM large_orders WHERE customer_id = 'CUST-025000';
```

- 트리 형태 출력
- 예상 비용 vs 실제 실행 시간 비교 가능
- Buffers: 메모리 IO 정보 제공

---

## 🎯 실무 선택 가이드

### ✅ MySQL을 선택할 때
- 웹 서비스 (쇼핑몰, 블로그 등)
- 빠른 CRUD 중심의 환경
- 가벼운 서버 성능

### ✅ PostgreSQL을 선택할 때
- 데이터 분석, BI 시스템
- JSON 문서 기반 데이터
- ERP, 금융 등 고무결성 환경
- 고급 SQL 기능 사용 (View, CTE 등)
