# SQL advance

## 🔍 MySQL EXPLAIN 기본 사용법

### 📘 문법 요약

```sql
-- 기본 EXPLAIN
EXPLAIN
SELECT * FROM sales WHERE total_amount > 500000;

-- EXPLAIN EXTENDED (MySQL 5.1+)
EXPLAIN EXTENDED
SELECT * FROM sales WHERE total_amount > 500000;
SHOW WARNINGS;

-- EXPLAIN FORMAT=JSON (MySQL 5.6+)
EXPLAIN FORMAT=JSON
SELECT * FROM sales WHERE total_amount > 500000;

-- 실제 실행 통계 (MySQL 8.0+)
EXPLAIN ANALYZE
SELECT * FROM sales WHERE total_amount > 500000;
```

### 📊 EXPLAIN 결과 구조

```sql
EXPLAIN
SELECT c.customer_name, s.product_name, s.total_amount
FROM customers c
INNER JOIN sales s ON c.customer_id = s.customer_id
WHERE c.customer_type = 'VIP';
```

| id | select_type | table | type | possible_keys | key | key_len | ref | rows | Extra         |
|----|-------------|-------|------|----------------|-----|---------|-----|------|---------------|
| 1  | SIMPLE      | c     | ALL  | PRIMARY        | NULL| NULL    | NULL| 50   | Using where   |
| 1  | SIMPLE      | s     | ref  | customer_id    | cust_id | 12  | c.id| 2    | NULL          |

---

## 🆚 MySQL vs PostgreSQL EXPLAIN 비교

### 📋 출력 형태 차이

- **MySQL**: 테이블 형식 출력
- **PostgreSQL**: 트리 구조 및 실행 비용 포함

```sql
-- PostgreSQL 예시
EXPLAIN SELECT * FROM large_orders WHERE customer_id = 'CUST-025000';
-- 결과:
-- Index Scan using idx_large_orders_customer_id on large_orders
-- (cost=0.42..8.45 rows=1 width=89)
```

### 🔍 컬럼별 정보 설명

#### MySQL 주요 컬럼

- `id`: 쿼리의 식별자
- `select_type`: 쿼리 유형
- `type`: 조인 방식 (system > const > eq_ref > ref > range > index > ALL)
- `rows`: 예상 읽을 행 수
- `Extra`: 추가 정보 (Using where, Using index, Using filesort 등)

#### PostgreSQL 분석 정보

- `cost`: 시작~종료 비용
- `rows`: 예상 결과 행 수
- `width`: 평균 행 크기
- `actual time`: 실제 실행 시간 (ANALYZE 시)
- `loops`: 반복 횟수

---

## 🔧 MySQL EXPLAIN 실전 분석

### 🔍 인덱스 사용 확인

```sql
EXPLAIN SELECT * FROM sales WHERE total_amount > 500000;
```

- `type: ALL` → 전체 테이블 스캔 (비효율)
- `type: range` → 인덱스 사용 시 효율적

### 🔍 조인 성능 확인

```sql
EXPLAIN
SELECT c.customer_name, COUNT(s.id)
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
GROUP BY c.customer_name;
```

- `type: ALL` → 인덱스 필요
- `Extra: Using temporary`, `Using filesort` 주의

---

## ⚙️ 인덱스 성능 개선 사례

### 1. 단일 고객 검색

```sql
SELECT * FROM orders WHERE customer_id = 'CUST-12345';
```

- 인덱스 없으면 느림
- 인덱스 있으면 수백 배 향상

### 2. 범위 검색

```sql
SELECT * FROM orders WHERE amount BETWEEN 500000 AND 1000000;
```

- 인덱스 유무에 따라 2~3배 차이

### 3. 복합 조건

```sql
SELECT * FROM orders WHERE region = '서울' AND amount > 800000;
```

- 복합 인덱스 활용 시 4~5배 향상

---

## 🏗️ 인덱스 종류별 비교

| 검색 유형          | B-Tree     | Hash        |
|-------------------|------------|-------------|
| 정확 일치 (=)     | ⭐⭐⭐⭐     | ⭐⭐⭐⭐⭐     |
| 범위 검색 (BETWEEN)| ⭐⭐⭐⭐⭐    | ❌         |
| 정렬 (ORDER BY)   | ⭐⭐⭐⭐⭐    | ❌         |
| 부분 일치 (LIKE)  | ⭐⭐⭐⭐     | ❌         |

---

## 🎯 실무 인덱스 설계 가이드

### ✅ B-Tree 추천 상황

- 범위 검색이 필요한 경우
- 정렬 조건이 있는 쿼리
- 다양한 WHERE 조건

### ✅ Hash 추천 상황

- 로그인 ID, 이메일 등 정확 일치
- 메모리 중요할 때

---

## 💡 성능 향상 수치 요약

| 검색 유형         | 인덱스 전 | B-Tree 후 | Hash 후 | 최적 선택 |
|------------------|-----------|-----------|----------|------------|
| 정확 검색 (=)     | 느림      | 빠름      | 초고속   | Hash 우세  |
| 범위 검색        | 느림      | 매우 빠름 | 불가     | B-Tree 필수|
| 복합 조건        | 느림      | 매우 빠름 | 제한적   | B-Tree     |
| 정렬 포함        | 매우 느림 | 빠름      | 불가     | B-Tree     |

---

## 💎 핵심 메시지

### 🎯 인덱스는 검색 성능 향상의 핵심

> "올바른 인덱스는 수백 배의 성능 차이를 만든다."

### 🧭 인덱스 설계 4원칙

1. 자주 사용하는 쿼리 기반 분석
2. B-Tree vs Hash 선택
3. 적절한 컬럼과 순서 선정
4. 성능 모니터링 및 지속적 최적화

---

## 🧠 선택 가이드 요약

| 상황                           | 인덱스 추천 |
|--------------------------------|--------------|
| 검색 패턴이 다양할 때          | B-Tree       |
| 범위 검색이 필요한 경우        | B-Tree       |
| 정확한 값만 필요할 때          | Hash         |
| 메모리 효율 중요할 때          | Hash         |
| 정렬 또는 부분 검색이 필요할 때| B-Tree       |