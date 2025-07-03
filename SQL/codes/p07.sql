USE practice;

CREATE TABLE dt_demo2 AS SELECT * FROM lecture.dt_demo;

SELECT * FROM dt_demo2;

-- 종합 정보 표시
SELECT
	id, name,
    IFNULL(nickname, '미설정') AS 닉네임,
    IFNULL(CONCAT(YEAR(birth),'년생'), '알수없음') AS 출생년도,
    IFNULL(TIMESTAMPDIFF(YEAR, birth, CURDATE()), '알수없음') AS 나이,
    COALESCE(ROUND(score, 1), 0) AS 점수, -- IF(score IS NOT NULL, ROUND(score, 1) , 0) AS 점수,
    CASE
		WHEN score >= 90 THEN 'A'
        WHEN score >= 80 THEN 'B'
        WHEN score >= 70 THEN 'C'
        ELSE 'D'
	END AS 등급,
    IF(is_active = 1 , '활성', '비활성') AS 상태,
    CASE
		WHEN TIMESTAMPDIFF(YEAR, birth, CURDATE()) < 30 THEN '청년'
        WHEN TIMESTAMPDIFF(YEAR, birth, CURDATE()) < 50 THEN '청장년'
        WHEN TIMESTAMPDIFF(YEAR, birth, CURDATE()) > 50 THEN '장년'
        ELSE '알수없음'
	END AS 연령대
FROM dt_demo2;        




-- id
-- name
-- 닉네임 (NULL -> '미설정')
-- 출생년도 (19xx년생)
-- 나이 (TIMESTAMPDIFF 로 나이만 표시)
-- 점수 (소수 1자리 반올림, Null -> 0)
-- 등급 (A >= 90 / B >= 80 / C >= 70 / D)
-- 상태 (is_active 가 1 이면 '활성' / 0 '비활성')
-- 연령대 (청년 < 30 < 청장년 < 50 < 장년)