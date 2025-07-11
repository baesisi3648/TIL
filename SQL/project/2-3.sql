-- 2010년 이전에 가입한 고객 목록
-- 2010년 1월 1일 이전에 첫 인보이스를 발행한 고객의 customer_id, first_name, last_name, 첫구매일을 조회하세요.

SELECT
	c.customer_id,
	c.first_name,
	c.last_name,
	TO_CHAR(MIN(i.invoice_date),'YYYY-MM-DD') AS 첫구매일
FROM customers c
JOIN invoices i ON i.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING TO_CHAR(MIN(i.invoice_date), 'YYYY') < '2010'
ORDER BY 첫구매일;
