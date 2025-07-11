-- 모든 앨범과 해당 아티스트 이름 출력	
-- 각 앨범의 title과 해당 아티스트의 name을 출력하고, 앨범 제목 기준 오름차순 정렬하세요.

SELECT
	b.title,
	a.name
FROM albums b
LEFT JOIN artists a ON b.artist_id = a.artist_id
ORDER BY b.title;