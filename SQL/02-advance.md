
# SQL Advance 

## TIL
1. =은 연산 무조건 뒤에 온다. ex) >=, !=
2. 문자열 뒤엔 , 확인
3. 함수 다시 정리하면서 복습!

## 🧾 개념 설명

### 📄 문자열 타입

| 타입       | 크기     | 특징                     | 사용 예시       |
|------------|----------|--------------------------|-----------------|
| `CHAR(n)`  | 고정 길이 | 항상 n바이트 사용        | 주민번호, 우편번호 |
| `VARCHAR(n)` | 가변 길이 | 실제 길이만큼 사용      | 이름, 이메일    |
| `TEXT`     | ~65KB    | 긴 문자열                | 게시글 내용     |
| `LONGTEXT` | ~4GB     | 매우 긴 텍스트           | 소설, 대용량 텍스트 |

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

