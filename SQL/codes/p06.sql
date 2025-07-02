USE practice;

SELECT * FROM userinfo;

-- 별명 길이 확인
SELECT nickname, char_length(nickname) AS 별명길이 FROM userinfo;

-- 별명 과 email 을 '-' 로 합쳐서 info (가상)컬럼으로 확인해 보기
SELECT concat(nickname,'-',email) AS info FROM userinfo;

-- 별명 은 모두 대문자로, email은 모두 소문자로 확인
SELECT UPPER(nickname), LOWER(email) FROM userinfo;

-- email 에서 gmail.com 을 naver.com 으로 모두 new_email 컬럼으로 추출
SELECT REPLACE(email, 'gmail.com', 'naver.com') AS new_email FROM userinfo;

-- email 앞에 붙은 단어만 username 컬럼 으로 확인 
SELECT 
	substring(email, 1, locate('@',email)-1)
	AS username FROM userinfo;
    
-- (추가 과제 -> email 이 NULL 인 경우 'No Mail' 이라고 표시
SELECT
	email,
    CASE
		WHEN email is NOT NULL
        THEN SUBSTRING(email, 1, LOCATE('@', email) - 1)
        ELSE 'NO Mail :('
		END 
        AS username FROM userinfo;

-- userinfo 테이블에서 각 사용자의 email에서 @ 뒤 도메인 부분만 추출해서 domain이라는 컬럼명으로 출력하세요.
SELECT 
	substring(email, (locate('@',email)+1), char_length(email)) as domain from userinfo;

-- 각 사용자의 nickname과 phone을 다음과 같은 형식으로 결합해서 contact_info 컬럼으로 출력하세요
SELECT 
	CONCAT(nickname, ' (', phone, ')') AS contact_info FROM userinfo;

-- phone 컬럼에서 뒤 4자리 번호만 추출해서 last4digits라는 이름으로 출력하세요.
SELECT RIGHT 
	(phone, 4) AS last4digits FROM userinfo;
    
-- 문제 1. 30대 사용자 중 이메일이 등록된 사람 찾기
SELECT * FROM userinfo WHERE age=30 and email IS NOT NULL;

-- 문제 2. 이메일 도메인이 naver.com인 사용자 목록
SELECT * FROM userinfo WHERE email LIKE '%@naver.com';

-- 문제 3. 전화번호 뒷자리 4자리를 `last4` 컬럼으로 출력
SELECT nickname, RIGHT (phone, 4) AS last4 FROM userinfo; -- 컬럼 개수에 따라 , 넣기