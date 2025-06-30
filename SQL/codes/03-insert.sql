USE lecture;

DESC members;

-- 데이터 입력 (CREATE)
INSERT INTO members (name, email) VALUES ('배성우', 'baesisi@naver.com');

-- 여러줄 한번에 입력 / (col1, col2) 순서 잘 맞추기!
INSERT INTO members (email, name) VALUES
	('eunbee@google.com','최은비'),
    ('seongyong@google.com','배성용');

-- 데이터 전체 조회 (Read)
SELECT * FROM members;

-- 단일 데이터 조회 (* -> 모든 칼럼)
SELECT * FROM members WHERE id=1;
