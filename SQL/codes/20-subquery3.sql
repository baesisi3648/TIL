USE lecture;

-- 각 고객의 주문정보 [cid, cname, ctype, 총주문횟수, 총주문금액, 최근주문일]
-- 같은 추출 Subquery

SELECT
  c.customer_id,
  c.customer_name,
  c.customer_type,
  (SELECT COUNT(*)
     FROM sales s
     WHERE s.customer_id = c.customer_id) AS 총주문횟수,
  (SELECT COALESCE(SUM(total_amount), 0)
     FROM sales s
     WHERE s.customer_id = c.customer_id) AS 총주문금액,
  (SELECT COALESCE(AVG(total_amount), 0)
     FROM sales s
     WHERE s.customer_id = c.customer_id) AS 평균주문금액,
  (SELECT COALESCE(MAX(order_date), '주문없음')
     FROM sales s
     WHERE s.customer_id = c.customer_id) AS 최근주문일
FROM customers c;
-- JOIN + GROUP
SELECT
    c.customer_id,
    c.customer_name,
    c.customer_type,
    COUNT(s.id) AS 총주문횟수,
    COALESCE(SUM(s.total_amount), 0) AS 총주문금액,
    ROUND(COALESCE(AVG(s.total_amount), 0), 0) AS 평균주문금액,
    COALESCE(MAX(s.order_date), '주문없음') AS 최근주문일
FROM customers c
LEFT JOIN sales s
    ON c.customer_id = s.customer_id
GROUP BY
    c.customer_id,
    c.customer_name,
    c.customer_type
ORDER BY 총주문금액 DESC;

-- 각 카테고리 평균매출 중에서 50만원이상만 구하기

SELECT 
	category,
    AVG(total_amount) AS 평균매출액
FROM sales
GROUP BY category
HAVING 평균매출액 > 500000;
-- 인라인 뷰(View) => 내가 만든 테이블
SELECT * 
FROM (
	SELECT 
	category,
    AVG(total_amount) AS 평균매출액
FROM sales
GROUP BY category
) AS category_summary
WHERE 평균매출액 >= 500000;

-- 1. 카테고리별 매출 분석 후 필터링
-- 카테고리명, 주문건수, 총매출, 평균매출, [0<=저단가<400000<=중단가<800000<고단가]

;

SELECT 
	category,
    판매건수,
    총매출,
    평균매출,
    CASE
		WHEN 평균매출 >= 800000 THEN '고단가'
		WHEN 평균매출 >= 400000 THEN '중단가'
		ELSE '저단가'
    END AS 단가구분
FROM(
	SELECT
		category,
		COUNT(*) AS 판매건수,
		SUM(total_amount) AS 총매출,
		ROUND(AVG(total_amount)) AS 평균매출
	FROM sales
	GROUP BY category
    ) AS s2
WHERE 평균매출 >= 300000;

-- 영업사원별 성과 등급 분류 [영업사원, 총매출액, 주문건수, 평균주문액, 매출등급, 주문등급]
-- 매출등급 - 총매출[0<=C<=5백만<B<8백만<=A<2천만<=S]
-- 주문등급 - 주문건수 [0 <= C <10<=B <20<=A]
-- ORDER BY 총매출액 DESC


SELECT 
	영업사원, 총매출액, 주문건수, 평균주문액,
    CASE
		WHEN 총매출액 >= 20000000 THEN 'S'
        WHEN 총매출액 >= 8000000 THEN 'A'
        WHEN 총매출액 >= 5000000 THEN 'B'
        ELSE 'C'
    END AS 매출등급,
    CASE
		WHEN 주문건수 >= 20 THEN 'A'
        WHEN 주문건수 >= 10 THEN 'B'
        ELSE 'C'
    END AS 주문등급
FROM( 
SELECT 
	COALESCE(sales_rep, '확인불가') AS 영업사원,
	SUM(total_amount) AS 총매출액,
    COUNT(*) AS 주문건수,
    AVG(total_amount) AS 평균주문액
FROM sales
GROUP BY sales_rep) AS s2
ORDER BY 총매출액 DESC;



