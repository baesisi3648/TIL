-- window 함수 -> OVER() 구문

-- 전체구매액 평균
SELECT AVG(amount) FROM orders;

-- 고객별 구매액 평균
SELECT
	customer_id,
	AVG(amount)
FROM orders
GROUP BY customer_id;

-- 각 데이터와 전체 평균을 동시에 확인
SELECT
	order_id,
	customer_id,
	amount,
	AVG(amount) OVER() as 전체평균
FROM orders
LIMIT 10;

-- ROW_NUMBER() -> 줄세우기 [ROW_NUMBER() OVER(ORDER BY 정렬기준)]
-- 주문 금액이 높은 순서로

SELECT
	order_id,
	customer_id,
	amount,
	ROW_NUMBER() OVER (ORDER BY amount DESC) as 호구번호
FROM orders
ORDER BY 호구번호
LIMIT 20 OFFSET 40;

-- 주문날짜가 최신인 순서대로 번호 매기기
SELECT
	order_id,
	customer_id,
	amount,
	order_date,
	ROW_NUMBER() OVER (ORDER BY order_date DESC) as 최신주문순서,
	RANK() OVER (ORDER BY order_date DESC) as 랭크, -- 진짜 순위(대회용)
	DENSE_RANK() OVER (ORDER BY order_date DESC) as 덴스랭크 -- 군집화
FROM orders
ORDER BY 최신주문순서
LIMIT 40;


-- 7월 매출 TOP 3 고객 찾기
-- [이름, (해당고객)7월구매액, 순위]
-- CTE
-- 1. 고객별 7월의 총구매액 구하기 [고객id, 이름, 총구매액]
-- 2. 기존 컬럼에 번호 붙이기 [고객id, 이름, 구매액, 순위]
-- 3. 보여주기

WITH july_sales AS (
 	SELECT
	 	customer_id AS 고객id,
		SUM(amount) AS 월구매액
	FROM orders
	WHERE order_date BETWEEN '2024-07-01' AND '2024-07-31'
	GROUP BY customer_id
)
,ranking AS (
	SELECT
		고객id,
		월구매액,
		ROW_NUMBER() OVER (ORDER BY 월구매액 DESC) as 순위
	FROM july_sales
)
SELECT
	r.고객id,
	c.customer_name,
	r.월구매액,
	r.순위
FROM ranking r
INNER JOIN customers c ON r.고객id=c.customer_id
WHERE r.순위 <= 3;
	

-- 각 지역에서 총구매액 1위 고객 => ROW_NUMBER() 로 숫자를 매기고, 이 컬럼의 값이 1인 사람
-- [지역, 고객이름, 총구매액]
-- CTE
-- 1. 지역-사람별 "매출 데이터" 생성 [지역, 고객id, 이름, 해당 고객의 총 매출]
-- 2. "매출데이터" 에 새로운 열(ROW_NUMBER) 추가
-- 3. 최종 데이터 표시

WITH region_sales AS(
	SELECT 
		c.region,
		c.customer_id,
		c.customer_name,
		SUM(o.amount) AS 고객별총매출
	FROM customers c
	JOIN orders o ON c.customer_id = o.customer_id
	GROUP BY c.region, c.customer_id, c.customer_name
),
ranked_by_region AS(
	SELECT
		region AS 지역,
		customer_name AS 이름,
		고객별총매출,
		ROW_NUMBER() OVER (PARTITION BY region ORDER BY 고객별총매출 DESC) AS 지역순위
	FROM region_sales
)
SELECT
	지역,
	이름,
	고객별총매출,
	지역순위
FROM ranked_by_region
WHERE 지역순위 <4; -- 1~3위

-- 카테고리 별 인기 상품(매출순위) TOP 5
-- CTE
-- [상품 카테고리, 상품id, 상품이름, 상품가격, 해당상품의주문건수, 해당상품판매개수, 해당상품총매출]
-- 위에서 만든 테이블에 WINDOW함수 컬럼추가 + [매출순위, 판매량순위]
-- 총데이터 표시(매출순위 1 ~ 5위 기준으로 표시)

WITH category_sales AS (
	SELECT
		p.category,
		p.product_id,
		p.product_name,
		p.price,
		COUNT(o.order_id) AS 주문건수,
		SUM(o.quantity) AS 판매량,
		SUM(o.amount) AS 총매출
	FROM products p
	LEFT JOIN orders o ON p.product_id = o.product_id
	GROUP BY p.category, p.product_id, p.product_name, p.price
),
ranked_sales AS(
	SELECT
		category AS 카테고리,
		product_id AS 상품id,
		product_name AS 상품이름,
		price AS 상품가격,
		주문건수,
		판매량,
		총매출,
		DENSE_RANK() OVER (PARTITION BY category ORDER BY 총매출 DESC) AS 매출순위,
		DENSE_RANK() OVER (PARTITION BY category ORDER BY 판매량 DESC) AS 판매순위
	FROM category_sales
)
SELECT
	카테고리,
	상품id,
	상품이름,
	상품가격,
	주문건수,
	판매량,
	총매출,
	매출순위,
	판매순위
FROM ranked_sales
WHERE 매출순위 < 6
ORDER BY 카테고리, 매출순위;




