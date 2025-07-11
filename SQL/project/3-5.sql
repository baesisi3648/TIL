-- 최근 1년간 월별 신규 고객 및 잔존 고객
-- 최근 1년(마지막 인보이스 기준 12개월) 동안,
-- 각 월별 신규 고객 수와 해당 월에 구매한 기존 고객 수를 구하세요.

WITH max_invoice_date AS (
  SELECT MAX(invoice_date) AS 기준일 FROM invoices
),
first_purchase AS (
  SELECT
    customer_id,
    MIN(invoice_date) AS 첫구매일
  FROM invoices
  GROUP BY customer_id
),
monthly_activity AS (
  SELECT
    i.customer_id,
    DATE_TRUNC('month', i.invoice_date) AS 월
  FROM invoices i
  JOIN max_invoice_date m ON i.invoice_date >= m.기준일 - INTERVAL '12 months'
),
신규고객 AS (
  SELECT
    DATE_TRUNC('month', 첫구매일) AS 월,
    COUNT(*) AS 신규고객수
  FROM first_purchase fp
  JOIN max_invoice_date m ON fp.첫구매일 >= m.기준일 - INTERVAL '12 months'
  GROUP BY 월
),
전체구매고객 AS (
  SELECT
    월,
    COUNT(DISTINCT customer_id) AS 총구매고객
  FROM monthly_activity
  GROUP BY 월
)
SELECT
  z.월,
  COALESCE(n.신규고객수, 0) AS 신규고객수,
  z.총구매고객 - COALESCE(n.신규고객수, 0) AS 기존고객수
FROM 전체구매고객 z
LEFT JOIN 신규고객 n ON z.월 = n.월
ORDER BY z.월;
