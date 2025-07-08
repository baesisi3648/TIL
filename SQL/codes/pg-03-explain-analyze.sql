-- 실행 계획을 보자 
EXPLAIN
SELECT * FROM large_customers WHERE customer_type = 'VIP';

-- cost = 점수(낮을수록 좋음) 0.00...3746.00 0부터 마지막행 가져오는 데 필요한 데이터량
-- rows * width = 총 메모리 사용량

-- 실행 + 통계
EXPLAIN ANALYZE
SELECT * FROM large_customers WHERE customer_type = 'VIP';

-- actual time = 실제 시간(22.446 - 마지막 행 가져온 시간)
-- Rows Removed by Filter: 걸러진 행 갯수
-- 인덱스 없고
-- 테이블 대부분의 행을 읽어야하고
-- 순차 스캔이 빠를 때

-- EXPLAIN 옵션들

-- 버퍼 사용량 포함
EXPLAIN (ANALYZE, BUFFERS)
SELECT * FROM large_customers WHERE loyalty_points > 8000;

-- 상세 정보 포함
EXPLAIN (ANALYZE, VERBOSE, BUFFERS)
SELECT * FROM large_customers WHERE loyalty_points > 8000;

-- JSON 형태
EXPLAIN (ANALYZE, VERBOSE, BUFFERS, FORMAT JSON)
SELECT * FROM large_customers WHERE loyalty_points > 8000;

-- 진단(Score is too high)
EXPLAIN ANALYZE
SELECT
	c.customer_name,
	COUNT(o.order_id)
FROM large_customers c
LEFT JOIN large_orders o ON c.customer_name = o.customer_id -- 잘못된 JOIN 조건
GROUP BY c.customer_name;

-- 메모리 부족
EXPLAIN (ANALYZE, BUFFERS)
SELECT customer_id, array_agg(order_id)
FROM large_orders
GROUP BY customer_id;
