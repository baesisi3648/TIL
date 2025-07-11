-- 국가별 재구매율(Repeat Rate)
-- 각 국가별로 전체 고객 수, 2회 이상 구매한 고객 수, 재구매율을 구하세요.
-- 결과는 재구매율 내림차순 정렬

WITH customer_purchase_count AS (
  SELECT
    i.billing_country,
    i.customer_id,
    COUNT(i.invoice_id) AS purchase_count
  FROM invoices i
  JOIN customers c ON i.customer_id = c.customer_id
  GROUP BY i.billing_country, i.customer_id
),
country_repurchase_rate AS (
  SELECT
    billing_country,
    COUNT(*) AS total_customers,
    COUNT(CASE WHEN purchase_count >= 2 THEN 1 END) AS repeat_customers,
    ROUND(COUNT(CASE WHEN purchase_count >= 2 THEN 1 END) * 100.0 / COUNT(*), 2) AS repeat_rate
  FROM customer_purchase_count
  GROUP BY billing_country
)
SELECT *
FROM country_repurchase_rate
ORDER BY repeat_customers DESC;

