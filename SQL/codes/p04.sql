USE practice;

SELECT * FROM userinfo;

DROP TABLE userinfo;

CREATE TABLE userinfo (
	id INT AUTO_INCREMENT PRIMARY KEY,
	nickname VARCHAR(100),
	phone VARCHAR(11) UNIQUE,
    email VARCHAR(40)
);
DESC userinfo;

INSERT INTO userinfo (nickname, phone, email) VALUES
('김철수', '01112345378', 'kim@test.com'),
('이영희', NULL, 'lee@gmail.com'),
('박민수', '01612345637', NULL),
('최영수', '01745367894', 'choi@naver.com'),
('배성우', '01046653648', 'baesisi3648@naver.com'),
('최은비', '01091493602', 'eunbeechoi@gmail.com'),
('이건호', '01045678910', 'gunho@naver.com');

-- id가 3이상
SELECT * FROM userinfo WHERE id >= 3;
-- email이 gmail,naver 이런 특정 도메인으로 끝나는 사용자들
SELECT * FROM userinfo WHERE email LIKE '%@naver.com';
SELECT * FROM userinfo WHERE email LIKE '%@gmail.com';
-- email이 gmail 이거나 naver 인 사람들
SELECT * FROM userinfo WHERE email LIKE '%@naver.com' OR email LIKE '%@gmail.com';
-- 이름이 김철수, 박민수 2명 뽑기
SELECT * FROM userinfo WHERE nickname IN ('김철수','박민수');
SELECT * FROM userinfo WHERE nickname ='김철수' OR nickname='박민수';
-- 이름에 수 글자가 들어간 사람들
SELECT * FROM userinfo WHERE nickname LIKE '%수%';
-- 핸드폰 번호 010으로 시작하는 사람들
SELECT * FROM userinfo WHERE phone LIKE '010%';

-- 이메일이 비어있는(NULL) 사람들
SELECT * FROM userinfo WHERE email IS NULL;
-- 비어있지 않은 사람들
SELECT * FROM userinfo WHERE email IS NOT NULL;

-- 이름에 '이'가 있고, 폰번호 010, gmail 쓰는 사람
SELECT * FROM userinfo WHERE nickname LIKE '%이%' AND phone LIKE '010%' AND email LIKE '%@gmail.com';
-- 성이 김/최 둘중 하난데 gmail 씀
SELECT * FROM userinfo WHERE (nickname LIKE '김%' OR nickname LIKE '최%') AND email LIKE '%@gmail.com'; 