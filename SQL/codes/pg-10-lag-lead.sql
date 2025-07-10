-- 매일 체중 기록
-- LAG() - 이전 값을 가져온다.
-- 전월 대비 매출 분석

-- 매달 매출을 확인
-- 위 테이블에 증감률 컬럼 추가

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
FROM compare_before
ORDER BY 년월;

-- 고객별 다음 구매를 예측?
-- [고객ID, 주문일, 구매액, 
	-- 다음구매일, 구매간격(일수),다음구매액수,구매금액차이]
-- order by order_id, order_date LIMIT 10;

SELECT
	customer_id,
	order_date AS 구매일,
	amount,
	LEAD(order_date, 1) OVER (PARTITION BY customer_id ORDER BY order_date) AS 다음구매일,
	LEAD(amount, 1) OVER (PARTITION BY customer_id ORDER BY order_date) AS 다음구매금액
FROM orders
ORDER BY customer_id, order_date;

-- [고객id, 주문일, 금액, 구매 순서(ROW_NUMBER),
--	이전구매간격, 다음구매간격
-- 금액변화=(이번-저번), 금액변화율
-- 누적 구매 금액(SUM OVER)
-- [추가]누적 평균 구매 금액 (AVG OVER)
WITH order1 AS(
	SELECT
		customer_id,
		order_date AS 구매일,
		amount AS 구매액,
		LEAD(order_date, 1) OVER (PARTITION BY customer_id ORDER BY order_date) AS 다음구매일,
		LEAD(amount, 1) OVER (PARTITION BY customer_id ORDER BY order_date) AS 다음구매금액
	FROM orders
	ORDER BY customer_id, order_date
),
order2 AS(
	SELECT
		*,
		ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY 구매일) AS 구매순서,
		LAG(구매일, 1) OVER (PARTITION BY customer_id ORDER BY 구매일) AS 이전구매일,
		LAG(구매액, 1) OVER (PARTITION BY customer_id ORDER BY 구매일) AS 이전구매액
	FROM order1
),
order3 AS(
	SELECT
		*,
		구매일 - 이전구매일 AS 이전구매간격,
		다음구매일 - 구매일 AS 다음구매간격,
		구매액 - 이전구매액 AS 금액변화,
		CASE
			WHEN 이전구매액 IS NULL THEN '계산불가'
			ELSE ROUND((구매액 - 이전구매액) * 100 / 이전구매액, 2)::TEXT || '%'
		END AS 금액변화율
	FROM order2
)
	SELECT
		구매순서, customer_id, 구매일, 구매액, 금액변화, 금액변화율,
		SUM(구매액) OVER (PARTITION BY customer_id ORDER BY 구매일) AS 누적구매금액,
		AVG(구매액) OVER (
			PARTITION BY customer_id 
			ORDER BY 구매일
			ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW -- 현재 확인중인 ROW부터 맨 앞까지(기본적인 세팅, 안 적어도 됨.)
			-- ROWS BETWEEN 2 PRECEDING AND CURRENT ROW -- 현재 확인중인 ROW 포함 총 3개
		) AS 누적평균구매금액,
		-- 고객 구매 단계 분류
		CASE	
			WHEN 구매순서 = 1 THEN '첫구매'
			WHEN 구매순서 <= 3 THEN '초기고객'
			WHEN 구매순서 <= 10 THEN '일반고객'
			ELSE 'VIP고객'
		END AS 구매등급
	FROM order3
	WHERE customer_id = 'CUST-000001';