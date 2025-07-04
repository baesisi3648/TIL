USE practice;

SELECT COUNT(*) FROM sales
UNION
SELECT COUNT(*) FROM customers;

SELECT * FROM sales;
SELECT * FROM customers;
SELECT * FROM products;

-- 주문 거래액이 가장 높은 10건을 높은 순으로 [고객명, 상품명, 주문금액]을 보여주자
SELECT
	c.customer_name AS 고객명,
    s.product_name AS 상품명,
    s.total_amount AS 주문금액
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
ORDER BY total_amount DESC LIMIT 10;

-- 고객 유형별 [고객유형 주문건수 평균주문금액] 을 평균주문금액 높은 순으로 정렬해서 보여주자.
SELECT
	c.customer_type AS 고객유형,
    COUNT(*) AS 주문건수,
    AVG(s.total_amount) AS 평균주문금액
FROM customers c
JOIN sales s ON c.customer_id = s.customer_id -- INNER JOIN은 구매자들끼리 평균/ LEFT JOIN은 모든 고객 분석이지만, 0원때문에 평균 오염
GROUP BY c.customer_type
ORDER BY 평균주문금액 DESC;

-- 문제 1: 모든 고객의 이름과 구매한 상품명 조회
SELECT
	c.customer_name AS 고객명,
    coalesce(s.product_name, '없음') AS 구매한상품명
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
ORDER BY c.customer_name;
 
-- 문제 2: 고객 정보와 주문 정보를 모두 포함한 상세 조회
SELECT	*
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
ORDER BY s.order_date DESC;

-- 문제 3: VIP 고객들의 구매 내역만 조회
SELECT	*
FROM customers c
JOIN sales s ON c.customer_id = s.customer_id
WHERE c.customer_type = 'VIP'
ORDER BY s.total_amount DESC;

-- 문제 4: 50만원 이상 주문한 기업 고객들과 주문내역
SELECT	*
FROM customers c
JOIN sales s ON c.customer_id = s.customer_id
WHERE c.customer_type = '기업' AND s.total_amount > 500000;

-- 문제 5: 2024년 하반기(7월~12월) AND 전자제품 구매 내역
SELECT	*
FROM customers c
JOIN sales s ON c.customer_id = s.customer_id
WHERE s.category = '전자제품' AND s.order_date BETWEEN '2024-07-01' AND '2024-12-31';

-- 문제 6 : 고객별 주문 통계 (INNER JOIN) [고객명, 유형, 주문횟수, 총구매, 평균구매, 최근주문일]
SELECT
	c.customer_id,
    c.customer_name AS 고객명,
    c.customer_type AS 고객유형,
    COUNT(*) AS 주문횟수,
    SUM(s.total_amount) AS 총구매금액,
    AVG(s.total_amount) AS 평균구매액,
    MAX(s.order_date) AS 최근주문일
FROM customers c
JOIN sales s ON c.customer_id = s.customer_id
GROUP BY c.customer_id, c.customer_name, c.customer_type
ORDER BY c.customer_name;

-- 문제 7 : 모든 고객의 주문 통계 (LEFT JOIN) - 주문 없는 고객도 포함
SELECT	
	c.customer_id,
    c.customer_name,
    c.customer_type,
    c.join_date,
    COUNT(s.id) AS 주문횟수, -- LEFT JOIN일때는 * 사용 못함.
    COALESCE(SUM(s.total_amount), 0) AS 총구매금액, -- NULL 값 주의
    COALESCE(AVG(s.total_amount), 0) AS 평균구매액,
    COALESCE(MAX(s.total_amount), 0) AS 최대구매금액
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
GROUP BY c.customer_id, c.customer_name, c.customer_type, c.join_date
ORDER BY 총구매금액 DESC;

-- 문제 8: 상품 카테고리별로 구매한 고객 유형 분석
SELECT	
	s.category AS 카테고리,
    c.customer_type AS 고객유형,
    COUNT(*) AS 주문건수,
    SUM(s.total_amount) AS 총매출액
FROM customers c
JOIN sales s ON c.customer_id = s.customer_id
GROUP BY s.category, c.customer_type
ORDER BY 총매출액 DESC;

-- 문제 9: 고객별 등급 분류
-- 활동등급(구매횟수) : [0(잠재고객) < 브론즈 < 3 <= 실버 < 5 <= 골드 < 10 <= 플래티넘]
-- 구매등급(구매총액) : [0(신규) < 일반 <= 10만 < 우수 <= 20만 < 최우수 < 50만 <= 로얄]
SELECT	
	c.customer_id,
    c.customer_name,
    c.customer_type,
	CASE
		WHEN COUNT(s.id) = 0 THEN '잠재고객'
        WHEN COUNT(s.id) >= 10 THEN '플래티넘'
		WHEN COUNT(s.id) >= 5 THEN '골드'
		WHEN COUNT(s.id) >= 3 THEN '실버'
		ELSE '브론즈'
    END AS 활동등급,
    CASE
		WHEN COALESCE(SUM(s.total_amount), 0) >= 500000 THEN '로얄'
        WHEN COALESCE(SUM(s.total_amount), 0) >= 200000 THEN '최우수'
        WHEN COALESCE(SUM(s.total_amount), 0) >= 100000 THEN '우수'
        WHEN COALESCE(SUM(s.total_amount), 0) > 0 THEN '일반'
        ELSE '신규'
	END AS 구매등급
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
GROUP BY c.customer_id, c.customer_name, c.customer_type
ORDER BY c.customer_id;

-- 문제 10: 활성 고객 분석
-- 고객상태(최종구매일) [NULL(구매없음) | 활성고객 <= 30 < 관심고객 <= 90 < 휴면고객]별로
-- 고객수, 총주문건수, 총매출액, 평균주문금액 분석 

SELECT 
	고객상태,
    COUNT(*) AS 고객수,
    SUM(총주문건수) AS 상태별총주문건수,
    SUM(총매출액) AS 상태별총매출액,
    ROUND(AVG(평균주문금액)) AS 상태별평균주문금액
FROM(
SELECT 
	c.customer_id,
    c.customer_name,
    COUNT(s.id) AS 총주문건수,
    coalesce(SUM(total_amount), 0) AS 총매출액,
    coalesce(AVG(total_amount), 0) AS 평균주문금액,
    CASE
		WHEN MAX(order_date) IS NULL THEN '구매없음'
        WHEN DATEDIFF('2024-12-31', MAX(s.order_date)) <= 30 THEN '활성고객'
		WHEN DATEDIFF('2024-12-31', MAX(s.order_date)) <= 90 THEN '관심고객'
        ELSE '휴면고객'
	END AS 고객상태
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
GROUP BY c.customer_id, c.customer_name) AS customer_2 -- 별칭 까먹지 말기
GROUP BY 고객상태;


-- 🏠 복습 과제
-- 1. 각 카테고리별 평균 매출보다 높은 주문들 (서브쿼리)
SELECT *
FROM sales s1
WHERE total_amount > (
  SELECT AVG(total_amount)
  FROM sales s2
  WHERE s2.category = s1.category
);
-- 2. 모든 고객의 주문 통계 (LEFT JOIN + GROUP BY)
SELECT	
	c.customer_name,
    c.customer_type,
    COUNT(order_date),
	s.category,
    s.total_amount
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
GROUP BY s.category, c.customer_name, c.customer_type, s.total_amount;

-- 3. 주문 없는 고객들 찾기 (LEFT JOIN + WHERE NULL)
SELECT	*
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
WHERE order_date IS NULL;

-- 4. VIP 고객들의 카테고리별 구매 패턴 (INNER JOIN + GROUP BY)
SELECT 
  s.category,
  COUNT(*) AS 주문건수,
  SUM(s.total_amount) AS 총구매액
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id
WHERE c.customer_type = 'VIP'
GROUP BY s.category
ORDER BY 총구매액 DESC;