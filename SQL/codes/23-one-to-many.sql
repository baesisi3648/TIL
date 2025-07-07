USE lecture;

SELECT 
	c. customer_id, 
	c.customer_name,
    COUNT(s.id) AS 주문횟수,
    COALESCE(GROUP_CONCAT(s.product_name), '주문없음') AS 주문제품들 -- Concatanate 글자끼리 이어붙이는 함수
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
GROUP BY c. customer_id, c.customer_name;