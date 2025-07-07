-- 전자제품을 구매한 고객 정보

SELECT 
	customer_id,
    customer_name,
    customer_type
FROM customers
WHERE customer_id IN (
	SELECT customer_id FROM sales WHERE category='전자제품');
    
    SELECT 
	customer_id,
    customer_name,
    customer_type
FROM customers c
WHERE EXISTS (
	SELECT 1 FROM sales s WHERE s.customer_id=c.customer_id AND s.category='전자제품');


-- EXISTS ( ~~한 적이 있는)
-- 전자제품과 의류를 모두 구매해 본 적이 있고, 동시에 50만원 이상 구매 이력도 가진 고객을 찾자.

SELECT 
  customer_id,
  customer_name,
  customer_type
FROM customers c
WHERE 
  EXISTS (
    SELECT 1 FROM sales s1 
    WHERE s1.customer_id = c.customer_id AND s1.category = '전자제품'
  )
AND 
  EXISTS (
    SELECT 1 FROM sales s2 
    WHERE s2.customer_id = c.customer_id AND s2.category = '의류'
  )
AND 
  EXISTS (
    SELECT 1 FROM sales s3 
    WHERE s3.customer_id = c.customer_id AND s3.total_amount >= 500000
  );

-- 3. 한번도 팔린적이 없는 상품 NOT EXISTS 활용 (IN으로는 복잡함)
SELECT
    p.product_name,
    p.category,
    p.selling_price,
    '한 번도 팔리지 않은 상품' AS 상태
FROM products p
WHERE NOT EXISTS (
    SELECT 1 FROM sales s WHERE s.product_name = p.product_name
)
ORDER BY p.category, p.selling_price DESC;