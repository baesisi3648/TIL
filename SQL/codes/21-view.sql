USE lecture;

DROP VIEW customer_summary;
CREATE VIEW customer_summary AS
SELECT
    c.customer_id,
    c.customer_name,
    c.customer_type,
    c.join_date AS 가입일,
    COUNT(s.id) AS 주문횟수,
    COALESCE(SUM(s.total_amount), 0) AS 총구매액,
    COALESCE(AVG(s.total_amount), 0) AS 평균주문액,
    COALESCE(MAX(s.order_date), '주문없음') AS 최근주문일
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
GROUP BY c.customer_id, c.customer_name, c.customer_type, c.join_date;


-- 등급별 구매 평균
SELECT 
	customer_type,
    AVG(총구매액)
FROM customer_summary
GROUP BY customer_type;

-- 충성고객 -> 주문횟수 5이상
SELECT *
FROM customer_summary
WHERE 주문횟수 > 5;

-- 잠재고객 -> 가입일 최근 10명
SELECT *
FROM customer_summary
ORDER BY 가입일 DESC LIMIT 10;

-- 최근주문 빠른 10명
SELECT * 
FROM customer_summary
WHERE 최근주문일 != '주문없음'
ORDER BY 최근주문일 DESC LIMIT 10;

SELECT * FROM sales;
SELECT * FROM customers;
-- View 2: 카테고리별 성과 요약 View (category_performance)
-- 카테고리 별로, 총 주문건수, 총매출액, 평균주문금액, 구매고객수, 판매상품수, 매출비중(전체매출에서 해당 카테고리가 차지하는비율)
DROP VIEW category_perfomance;
CREATE VIEW category_perfomance AS
SELECT 
	category,
    COUNT(*) AS 총주문건수,
    SUM(total_amount) AS 총매출액,
    AVG(total_amount) AS 평균주문금액,
    COUNT(DISTINCT customer_id) AS 구매고객수,
    COUNT(DISTINCT product_name) AS 판매상품수,
    ROUND(SUM(total_amount) / (SELECT SUM(total_amount) FROM sales) * 100, 2) AS 매출비중
FROM sales
GROUP BY category;


-- View 3: 월별 매출 요약 (monthly_sales )
-- 년월(24-07), 월주문건수, 월평균매출액, 월활성고객수, 월신규고객수

DROP VIEW monthly_sales;
CREATE VIEW monthly_sales AS
SELECT 
  DATE_FORMAT(s.order_date, '%y-%m') AS 년월,
  COUNT(*) AS 월주문건수,
  ROUND(SUM(s.total_amount)) AS 월매출액,
  ROUND(AVG(s.total_amount)) AS 월평균매출액,
  COUNT(DISTINCT s.customer_id) AS 월활성고객수,
  COUNT(DISTINCT c.customer_id) AS 월신규고객수
FROM sales s
LEFT JOIN customers c 
	ON s.customer_id = c.customer_id
	AND DATE_FORMAT(s.order_date, '%y-%m') = DATE_FORMAT(c.join_date, '%y-%m')
GROUP BY DATE_FORMAT(s.order_date, '%y-%m')
ORDER BY 년월;

SELECT * FROM monthly_sales;
