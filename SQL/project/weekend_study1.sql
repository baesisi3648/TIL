-- 고객의 최근 구매 내역
-- 각 고객별로 가장 최근 인보이스(invoice_id, invoice_date, total) 정보를 출력하세요.

-- 1)

SELECT
	i.customer_id,
	i.invoice_id,
	i.invoice_date,
	i.total
FROM invoices i
WHERE invoice_date = (
	SELECT
		MAX(invoice_date)
	FROM invoices
	WHERE customer_id = i.customer_id)
ORDER BY customer_id;

-- 2)

WITH customer_info AS(
	SELECT
		customer_id,
		invoice_id,
		invoice_date,
		total,
		ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY invoice_date DESC) AS 구매번호
	FROM invoices
)
SELECT customer_id, invoice_id, invoice_date, total
FROM customer_info
WHERE 구매번호 = 1;