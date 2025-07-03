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