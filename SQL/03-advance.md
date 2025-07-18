
# SQL advance (함수 및 고급 쿼리 정리)

## TIL
1. 컬럼마다 , 넣기
2. IF는 2가지 상황(간단상황)/ CASE는 복잡한 경우의 수
3. 실전문제 많이 풀어보기!

## 1️⃣ 날짜/시간 함수

| 함수 | 용도 | 예시 |
|------|------|------|
| `NOW()` | 현재 날짜+시간 | `SELECT NOW();` |
| `CURDATE()` | 현재 날짜만 | `SELECT CURDATE();` |
| `DATE_FORMAT()` | 날짜 형식 변환 | `DATE_FORMAT(birth, '%Y년 %m월')` |
| `DATEDIFF()` | 날짜 간 일수 차이 | `DATEDIFF(CURDATE(), birth)` |
| `TIMESTAMPDIFF()` | 기간 단위별 차이 | `TIMESTAMPDIFF(YEAR, birth, CURDATE())` |
| `DATE_ADD()` | 날짜 더하기 | `DATE_ADD(birth, INTERVAL 1 YEAR)` |
| `YEAR()`, `MONTH()`, `DAY()` | 날짜 요소 추출 | `YEAR(birth), MONTH(birth)` |

- 핵심 FORMAT 기호: `%Y`(년도), `%m`(월), `%d`(일), `%H`(시간), `%i`(분)

---

## 2️⃣ 숫자 함수

| 함수 | 용도 | 예시 |
|------|------|------|
| `ROUND()` | 반올림 | `ROUND(score, 1)` |
| `CEIL()` | 올림 | `CEIL(score)` |
| `FLOOR()` | 내림 | `FLOOR(score)` |
| `ABS()` | 절댓값 | `ABS(score - 80)` |
| `MOD()` | 나머지 | `MOD(id, 2)` |
| `POWER()` | 거듭제곱 | `POWER(score, 2)` |
| `SQRT()` | 제곱근 | `SQRT(score)` |

---

## 3️⃣ 조건부 함수

| 함수 | 용도 | 예시 |
|------|------|------|
| `IF()` | 단순 조건 | `IF(score >= 80, '우수', '보통')` |
| `CASE WHEN` | 다중 조건 | `CASE WHEN score >= 90 THEN 'A' ELSE 'B' END` |
| `IFNULL()` | NULL 처리 | `IFNULL(nickname, '미설정')` |
| `COALESCE()` | 첫 번째 NULL 아닌 값 | `COALESCE(nickname, name, 'Unknown')` |

---

## 4️⃣ 집계 함수 (= 스프레드시트 함수)

| SQL 집계함수 | 스프레드시트 | 용도 |
|--------------|--------------|------|
| `COUNT(*)`   | `=COUNT()`   | 행 개수 세기 |
| `SUM()`      | `=SUM()`     | 합계 |
| `AVG()`      | `=AVERAGE()` | 평균 |
| `MIN()`      | `=MIN()`     | 최솟값 |
| `MAX()`      | `=MAX()`     | 최댓값 |

---

## 5️⃣ GROUP BY (= 피벗테이블)

> 카테고리별 매출 (피벗테이블의 행=카테고리, 값=매출합계)

```sql
SELECT
    category,
    COUNT(*) AS 건수,
    SUM(total_amount) AS 매출액
FROM sales
GROUP BY category
ORDER BY 매출액 DESC;
```

---

## 6️⃣ HAVING (= 피벗테이블 필터)

> 매출 100만원 이상인 카테고리만 조회

```sql
SELECT category, SUM(total_amount) AS 총매출
FROM sales
GROUP BY category
HAVING SUM(total_amount) >= 1000000;
```

- **WHERE vs HAVING**
  - `WHERE`: 개별 행 조건 (그룹핑 전)
  - `HAVING`: 그룹 조건 (그룹핑 후)

---

## 🔥 핵심 실전 쿼리 패턴

### ✅ 1. 종합 통계 대시보드
```sql
SELECT
    COUNT(*) AS 총주문건수,
    COUNT(DISTINCT customer_id) AS 총고객수,
    SUM(total_amount) AS 총매출액,
    AVG(total_amount) AS 평균주문액,
    MAX(total_amount) AS 최대주문액
FROM sales;
```

### ✅ 2. 월별 매출 트렌드
```sql
SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS 월,
    COUNT(*) AS 주문건수,
    SUM(total_amount) AS 월매출액
FROM sales
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY 월;
```

### ✅ 3. 우수 고객/영업사원 찾기
-- 월평균 매출 50만원이상 영업사원
```sql
SELECT
    sales_rep,
    COUNT(*) AS 주문건수,
    SUM(total_amount) AS 총매출,
    ROUND(SUM(total_amount) / COUNT(DISTINCT DATE_FORMAT(order_date, '%Y-%m')), 0) AS 월평균매출
FROM sales
GROUP BY sales_rep
HAVING 월평균매출 >= 500000
ORDER BY 월평균매출 DESC;
```

### ✅ 4. 교차분석 (크로스탭)
-- 지역별 카테고리 매출 분포
```sql
SELECT
    region,
    SUM(CASE WHEN category = '전자제품' THEN total_amount ELSE 0 END) AS 전자제품,
    SUM(CASE WHEN category = '의류' THEN total_amount ELSE 0 END) AS 의류,
    SUM(CASE WHEN category = '생활용품' THEN total_amount ELSE 0 END) AS 생활용품,
    SUM(CASE WHEN category = '식품' THEN total_amount ELSE 0 END) AS 식품
FROM sales
GROUP BY region;
```
