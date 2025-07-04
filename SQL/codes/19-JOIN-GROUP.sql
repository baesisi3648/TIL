USE lecture;

-- VIP 고객들의 구매 내역 조회 (고객명, 고객유형, 상품명, 카테고리, 주문금액)
SELECT * FROM customers;
SELECT * FROM sales;

SELECT *
FROM customers c
INNER JOIN sales s ON c.customer_id = s.customer_id
WHERE c.customer_type = 'VIP';


-- 각 등급별 구매액 평균
SELECT
  c.customer_type,
  AVG(s.total_amount)
FROM customers c
INNER JOIN sales s ON c.customer_id = s.customer_id
GROUP BY c.customer_type;

-- LEFT JOIN을 통한 [모든 고객]의 구매 현황 분석(구매를 하지 않았어도 분석)
SELECT
    c.customer_id,
    c.customer_name,
    c.customer_type,
    c.join_date,
    COUNT(s.id) AS 주문횟수,
    COALESCE(SUM(s.total_amount), 0) AS 총구매액,
    COALESCE(AVG(s.total_amount), 0) AS 평균주문액,
    COALESCE(MAX(s.order_date), '주문없음') AS 최근주문일,
    CASE
        WHEN COUNT(s.id) = 0 THEN '잠재고객'
        WHEN COUNT(s.id) >= 5 THEN '충성고객'
        WHEN COUNT(s.id) >= 4 THEN '일반고객'
        ELSE '신규고객'
    END AS 고객분류
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
GROUP BY c.customer_id, c.customer_name, c.customer_type, c.join_date
ORDER BY 총구매액 DESC;


-- INNER JOIN 교집합
-- 특정 고객의 ~~( 고객이 주어니까 고객데이터 중심으로 JOIN)
SELECT
	'1. INNER JOIN' AS 구분,
    COUNT(*) AS 줄수,
	COUNT(DISTINCT c.customer_id) AS 고객수
FROM customers c 
INNER JOIN sales s ON c. customer_id = s. customer_id

UNION
-- LEFT JOIN 왼쪽(FROM 뒤에 온)테이블은 무조건 다 나옴
SELECT 
	'2. LEFT JOIN' AS 구분,
     COUNT(*) AS 줄수,
	 COUNT(DISTINCT c.customer_id) AS 고객수
FROM customers c 
LEFT JOIN sales s ON c. customer_id = s. customer_id

UNION
SELECT 
	'3. RIGHT JOIN' AS 구분,
     COUNT(*) AS 줄수,
	 COUNT(DISTINCT c.customer_id) AS 고객수
FROM customers c 
RIGHT JOIN sales s ON c. customer_id = s. customer_id -- RIGHT JOIN은 FROM 순서만 바꾸면 되는거라 실무에선 잘 사용안함. 

UNION
SELECT 
	'3. 전체 고객수' AS 구분,
     COUNT(*) AS 행수, -- 컬럼 이름 달라도 넣을 수 있음
	 COUNT(*) AS 고객수
FROM customers c;