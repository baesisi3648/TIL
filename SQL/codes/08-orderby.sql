USE lecture;

-- 특정 컬럼을 기준으로 정렬함
-- ASC 오름차순 | DESC 내림차순

SELECT * FROM students;

-- 이름 ㄱㄴㄷ 순으로 정렬 -> DEFAULT(기본) 정렬 방식 = ASC
SELECT * FROM students ORDER BY name;
SELECT * FROM students ORDER BY name ASC; -- 위와 결과 동일
SELECT * FROM students ORDER BY name DESC;

-- 테이블 구조 변경 -> 컬럼 추가 -> grade VARCHAR(1) -> 기본값으로 'B'
ALTER TABLE students ADD COLUMN grade VARCHAR(1) DEFAULT'B';
-- 데이터 변경. 9명 -> id 1~3 -A/ id 7~9 -C
UPDATE students SET grade='A' WHERE id BETWEEN 1 AND 3;
UPDATE students SET grade='C' WHERE id BETWEEN 7 AND 9;

SELECT * FROM students;

# 다중 컬럼 정렬 -> 앞에 말한게 우선 정렬
SELECT * FROM students ORDER BY
age ASC,
grade DESC;

SELECT * FROM students ORDER BY
grade DESC,
age ASC
LIMIT 5;

# 필요사항은 추상적이고, 조건은 우리가 생각해야함 ex) 장학금 - 소득, 성적순

-- 나이가 40 미만인 학생들 중에서 학점 좋은순 -- 나이 많은순으로 상위 5명 뽑기
SELECT * FROM students 
WHERE age < 40
ORDER BY grade ASC,
age DESC
LIMIT 5;


