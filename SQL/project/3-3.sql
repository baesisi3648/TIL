-- 고객별 누적 구매액 및 등급 산출
-- 각 고객의 누적 구매액을 구하고,
-- 상위 20%는 'VIP', 하위 20%는 'Low', 나머지는 'Normal' 등급을 부여하세요.

WITH customer_total AS (
	SELECT
		customer_id,
		SUM(total) AS 누적구매액
	FROM invoices
	GROUP BY customer_id
),
customer_grade AS(
	SELECT
		*,
		CASE
		 	WHEN PERCENT_RANK() OVER (ORDER BY 누적구매액) >= 0.8 THEN 'VIP'
			WHEN PERCENT_RANK() OVER (ORDER BY 누적구매액) <= 0.2 THEN 'LOW'
			ELSE 'NORMAL'
		END AS 고객등급
	FROM customer_total
)
SELECT * FROM customer_grade
ORDER BY 누적구매액 DESC;

