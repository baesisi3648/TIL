USE practice;

DESC userinfo;

INSERT INTO userinfo (nickname, phone) VALUES
	('bob', '01011111111'),
    ('bae', '01022222222'),
    ('choi', '01033333333'),
    ('kim', '01044444444'),
    ('park', '01055555555');
    
SELECT * FROM userinfo;

SELECT * FROM userinfo WHERE id=3;

SELECT * FROM userinfo WHERE nickname='bob';

UPDATE userinfo SET phone='01099998888' WHERE id=2;

DELETE FROM userinfo WHERE id=2;

-- 전체 조회 (중간중간 계속 실행하면서 모니터링) R
-- id 가 3인 사람 조회 R
-- 별명이 bob 인 사람을 조회 R
-- 별명이 bob 인 사람의 핸드폰 번호를 01099998888 로 수정 (id로 수정) U
-- 별명이 bob 인 사람 삭제 (id로 수정) D