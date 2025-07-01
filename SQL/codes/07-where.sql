-- SELECT 컬럼 FROM 테이블 WHERE 조건 ORDER BY 정렬기준 LIMIT 개수

USE lecture;

DROP TABLE students;

CREATE TABLE students (
	id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(20),
    age INT
);

DESC students;

INSERT INTO students (name, age) VALUES
('배성우', 33),
('박준영', 33),
('이찬균', 32),
('최은비', 34),
('안재용', 32),
('김지석', 33),
('조민호', 43),
('안성원', 46),
('권용진', 20);

SELECT * FROM students;

SELECT * FROM students WHERE name='최은비';

SELECT * FROM students WHERE age > 20; -- >= 이상

SELECT * FROM students WHERE id <> 1; -- 해당 조건 여집합(해당 조건이 아닌)
SELECT * FROM students WHERE id !=1;

SELECT * FROM students WHERE age BETWEEN 20 and 40; -- 20 이상, 40 이하

SELECT * FROM students WHERE id IN (1, 3, 5, 7); -- 합집합
SELECT * FROM students WHERE age IN (33);  -- () 무조건 해야함

-- 문자열 패턴 (% -> 있을 수도, 없을 수도 있다. , _ -> 정확히 갯수만큼 글자가 있다.)
-- 배 씨만 찾기
SELECT * FROM students WHERE name LIKE '배%';
-- '성' 글자가 들어가는 사람 
SELECT * FROM students WHERE name LIKE '%성%';
-- '성' 으로 시작만 하면 됨
SELECT * FROM students WHERE name LIKE '성%';
-- '성' 으로 끝나기만 하면 됨
SELECT * FROM students WHERE name LIKE '%성';
-- 이름이 정확히 3글자인 배씨
SELECT * FROM students WHERE name LIKE '배__';

