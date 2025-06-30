SELECT * FROM members;

INSERT INTO members(name) VALUES ('익명');
INSERT INTO members(email) VALUES ('abc@google.com'); -- 이름이 없어서 에러남

-- Update(데이터 수정)
UPDATE members SET name='홍길동', email='hong@naver.com' WHERE id=4;

-- 원치 않는 케이스 (name이 같으면 동시 수정)
UPDATE members SET email='No email' WHERE email='abc@google.com'; -- 에러는 안 났는데 명령어가 잘못됨.

-- DELETE(데이터 삭제)
DELETE FROM members WHERE id=5;

-- 테이블 모든 데이터 삭제(위험)
DELETE FROM members;