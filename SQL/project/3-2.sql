-- 장르별 상위 3개 아티스트 및 트랙 수
-- 각 장르별로 트랙 수가 가장 많은 상위 3명의 아티스트(artist_id, name, track_count)를 구하세요.
-- 동점일 경우 아티스트 이름 오름차순 정렬.

WITH genre_info AS (
	SELECT 
		g.name AS 장르,
		a1.artist_id,
		a1.name AS 아티스트이름,
		COUNT(track_id) AS 트랙수
	FROM artists a1
	JOIN albums a2 ON a2.artist_id = a1.artist_id
	JOIN tracks t ON t.album_id = a2.album_id
	JOIN genres g ON g.genre_id = t.genre_id
	GROUP BY g.name, a1.artist_id, a1.name
),
genre_info2 AS(
	SELECT
		*,
		ROW_NUMBER() OVER (PARTITION BY 장르 ORDER BY 트랙수 DESC, 아티스트이름) AS 장르순위
	FROM genre_info
)
SELECT * FROM genre_info2
WHERE 장르순위 < 4 ;