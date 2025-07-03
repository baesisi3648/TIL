USE lecture;

-- Scala -> 한개의 데이터
-- Vector -> 한줄로 이루어진 데이터
-- Matrix -> 행과 열로 이루어진 데이터

SELECT * FROM customers;

-- 모든 VIP의 id('c001','c005'....)
SELECT customer_id FROM customers WHERE customer_type = 'VIP';

-- 모든 VIP의 주문내역
SELECT *
FROM sales
WHERE customer_id IN (SELECT customer_id FROM customers WHERE customer_type = 'VIP')
ORDER BY total_amount DESC;

-- 전자제품을 구매한 고객들의 모든 주문
SELECT DISTINCT customer_id FROM sales WHERE category = '전자제품';

SELECT * FROM sales
WHERE customer_id IN (SELECT DISTINCT customer_id FROM sales WHERE category = '전자제품')
ORDER BY customer_id, total_amount DESC;
