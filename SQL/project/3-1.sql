-- 월별 매출 및 전월 대비 증감률
-- 각 연월(YYYY-MM)별 총 매출과, 전월 대비 매출 증감률을 구하세요.
-- 결과는 연월 오름차순 정렬하세요.

WITH monthly_total AS (
	SELECT
		DATE_TRUNC('month', invoice_date) AS 월,
		SUM(total) AS 월매출
	FROM invoices
	GROUP BY 월
),
compare_before AS (
	SELECT
		TO_CHAR(월, 'YYYY-MM') as 년월,
		월매출,
		LAG(월매출, 1) OVER (ORDER BY 월) AS 전월매출
	FROM monthly_total
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