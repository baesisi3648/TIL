
# SQL Advance 

## TIL
1. =은 연산 무조건 뒤에 온다. ex) >=, !=
2. 문자열 뒤엔 , 확인
3. 함수 다시 정리하면서 복습!

## 📚 SQL 핵심 개념 요약

## 🔹 SELECT 기본 구조
```sql
SELECT 컬럼명
FROM 테이블명
WHERE 조건
ORDER BY 정렬기준
LIMIT 개수 OFFSET 개수;
````
---

## 🔍 WHERE 조건식

### 🔸 비교 연산자

| 연산자    | 의미      | 예시                   |
| ------ | ------- | -------------------- |
| =      | 같음      | name = 'kim'         |
| <>, != | 다름      | id <> 1              |
| >, >=  | 크거나 같음  | id >= 2              |
| <, <=  | 작거나 같음  | age <= 30            |
| AND    | 모두 참    | age > 20 AND id < 5  |
| OR     | 하나 이상 참 | age < 20 OR age > 65 |

### 🔸 특수 연산자

| 연산자         | 사용법         | 예시                     |
| ----------- | ----------- | ---------------------- |
| BETWEEN     | 범위 검색       | id BETWEEN 1 AND 3     |
| IN          | 목록 검색       | name IN ('kim', 'lee') |
| LIKE        | 패턴 매칭       | email LIKE '%test.com' |
| IS NULL     | NULL 검사     | email IS NULL          |
| IS NOT NULL | NOT NULL 검사 | email IS NOT NULL      |

### 🔸 LIKE 패턴 문자

* `%`: 0개 이상의 임의 문자
* `_`: 정확히 1개의 임의 문자

---

## 🧠 논리 연산자 예시

```sql
-- AND: 모든 조건 만족
SELECT * FROM member WHERE name = 'kim' AND id >= 2;

-- OR: 하나 이상 조건 만족
SELECT * FROM member WHERE name = 'kim' OR name = 'lee';

-- NOT: 조건의 반대
SELECT * FROM member WHERE NOT name = 'kim';
```

---

## 📊 ORDER BY (정렬)

```sql
-- 오름차순 정렬 (기본)
SELECT * FROM member ORDER BY name;
SELECT * FROM member ORDER BY name ASC;

-- 내림차순 정렬
SELECT * FROM member ORDER BY created_at DESC;

-- 다중 정렬 (name ASC, id DESC)
SELECT * FROM member ORDER BY name ASC, id DESC;
```

---

## 📋 주요 데이터 타입

### 📄 문자열 타입

| 타입       | 크기     | 특징                     | 사용 예시       |
|------------|----------|--------------------------|-----------------|
| `CHAR(n)`  | 고정 길이 | 항상 n바이트 사용        | 주민번호, 우편번호 |
| `VARCHAR(n)` | 가변 길이 | 실제 길이만큼 사용      | 이름, 이메일    |
| `TEXT`     | ~65KB    | 긴 문자열                | 게시글 내용     |
| `LONGTEXT` | ~4GB     | 매우 긴 텍스트           | 소설, 대용량 텍스트 |

📎 [VARCHAR vs TEXT 정리 – 당근 블로그](https://medium.com/daangn/varchar-vs-text-230a718a22a1)

---

### 🔢 숫자 타입

| 타입       | 크기     | 범위                          | 사용 예시     |
|------------|----------|-------------------------------|----------------|
| `TINYINT`  | 1바이트  | -128 ~ 127                    | 상태값        |
| `INT`      | 4바이트  | -21억 ~ 21억                 | ID, 개수       |
| `BIGINT`   | 8바이트  | 매우 큰 정수                 | 포인트, 조회수 |
| `FLOAT`    | 4바이트  | 소수점 7자리 정도            | 온도           |
| `DOUBLE`   | 8바이트  | 소수점 15자리 정도           | 정밀한 계산    |
| `DECIMAL(p, s)` | 가변  | 정확한 숫자 저장             | 돈, 정밀 계산  |

---

### 🕓 날짜/시간 타입

| 타입        | 형식                   | 사용 예시         |
|-------------|------------------------|--------------------|
| `DATE`      | YYYY-MM-DD             | 생년월일, 가입일   |
| `TIME`      | HH:MM:SS               | 시간값             |
| `DATETIME`  | YYYY-MM-DD HH:MM:SS    | 작성일 시점        |
| `TIMESTAMP` | YYYY-MM-DD HH:MM:SS    | 자동 갱신 가능     |

### 🧮 함수 정리 - 주요 문자열 함수

| 함수 | 설명 | 예시 |
|------|------|------|
| `CHAR_LENGTH(str)` | 문자열 길이 | `CHAR_LENGTH('hello')` → 5 |
| `CONCAT(str1, str2, ...)` | 문자열 연결 | `CONCAT('A', 'B')` → 'AB' |
| `UPPER(str)` | 대문자 변환 | `UPPER('hello')` → 'HELLO' |
| `LOWER(str)` | 소문자 변환 | `LOWER('HELLO')` → 'hello' |
| `SUBSTRING(str, pos, len)` | 부분 문자열 | `SUBSTRING('hello', 2, 3)` → 'ell' |
| `REPLACE(str, old, new)` | 문자열 치환 | `REPLACE('hello', 'l', 'x')` → 'hexxo' |
| `TRIM(str)` | 앞뒤 공백 제거 | `TRIM('  hello ')` → 'hello' |
| `LEFT(str, len)` | 왼쪽부터 n글자 | `LEFT('hello', 3)` → 'hel' |
| `RIGHT(str, len)` | 오른쪽부터 n글자 | `RIGHT('hello', 3)` → 'llo' |
| `LOCATE(substr, str)` | 부분문자열 위치 | `LOCATE('l', 'hello')` → 3 |


## 💡 실무 활용 예시

### 이메일에서 사용자명 추출

```sql
SELECT
  email,
  SUBSTRING(email, 1, LOCATE('@', email) - 1) AS username
FROM member
WHERE email IS NOT NULL;
```

### 회원 정보 표시 형식 만들기

```sql
SELECT CONCAT(name, '(', email, ')') AS member_info FROM member;
```

### 검색 조건 조합

```sql
-- 이름에 '수'가 포함되고 이메일이 gmail인 회원
SELECT * FROM member
WHERE name LIKE '%수%'
  AND email LIKE '%gmail%';
```

---

## ⚠️ 주의사항

* `NULL` 비교는 `= NULL`이 아니라 `IS NULL` 사용
* 문자열 함수는 데이터가 많을수록 **성능 저하** 발생 가능
* `ORDER BY`는 느릴 수 있으므로 `LIMIT`, `OFFSET` 조합 권장

---

## 🎯 핵심 포인트 요약

✅ `WHERE` 절은 데이터 필터링의 핵심
✅ `ORDER BY`로 원하는 정렬 순서 지정
✅ 올바른 **데이터 타입** 사용은 성능 최적화에 중요
✅ **문자열 함수**로 다양한 데이터 가공 가능
✅ **조건** 조합으로 복잡한 검색 쿼리 구현 가능
