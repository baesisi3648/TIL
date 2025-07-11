-- 고객의 최근 구매 내역
-- 각 고객별로 가장 최근 인보이스(invoice_id, invoice_date, total) 정보를 출력하세요.

SELECT
	customer_id,
	max(invoice_date) AS invoice_date
FROM invoices
GROUP BY customer_id;

SELECT
	i.customer_id,
	i.invoice_id,
	r.invoice_date AS 최근구매일,
	i.total
FROM invoices i
JOIN (SELECT
	customer_id,
	max(invoice_date) AS invoice_date
FROM invoices
GROUP BY customer_id) r ON i.customer_id = r.customer_id
WHERE i.invoice_date = r.invoice_date
ORDER BY i.customer_id;
