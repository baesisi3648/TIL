-- 가장 많이 팔린 트랙 TOP 5
-- 판매량(구매된 수량)이 가장 많은 트랙 5개(track_id, name, 총 판매수량)를 출력하세요.
-- 동일 판매수량일 경우 트랙 이름 오름차순 정렬하세요.

SELECT
	t.track_id,
	t.name,
	SUM(i.quantity) AS 총판매수량
FROM tracks t
JOIN invoice_items i ON i.track_id = t.track_id
GROUP BY t.track_id, t.name
ORDER BY 총판매수량 DESC, t.name
LIMIT 5;
	