#  📊 데이터베이스 핵심 개념

## TIL
1. SQL에서 명령어를 쓸 때, 정해진 명령어는 대문자(국룰) / 변경 가능한 명령어는 소문자로 쓰기
2. PRIMARY KEY는 필수 포함, 하나만 존재. 이 KEY를 가지고 UPDATE, DELETE함.
3. C(CREATE) R(READ) U(UPDATE) D(DELETE)
---
## ✅ 데이터베이스의 종류
- **RDBMS (관계형 데이터베이스)**: 가장 널리 쓰임
  - MySQL
  - PostgreSQL
  - Oracle
  - SQLite
  - MariaDB

- **Doucument DB(NoSQL 계열)**
  - Key-Value DB
  - Graph DB 등

---

## ✅ 스키마 (Schema)
- **정의**: 데이터베이스의 구조와 제약조건을 정의한 설계도
- **포함 요소**: 테이블 구조, 데이터 타입, 제약조건, 관계 등

---

## 🧱 DDL vs DML

| 구분 | DDL (Data Definition Language) | DML (Data Manipulation Language) |
|------|-------------------------------|----------------------------------|
| 목적 | 데이터베이스 구조 정의/변경     | 데이터 조작                       |
| 대상 | 테이블, DB, 스키마             | 데이터 (행)                       |
| 명령어 | CREATE, ALTER, DROP           | INSERT, SELECT, UPDATE, DELETE   |
| 결과 | 구조 변경                      | 데이터 변경                       |

---

## 🗄️ 데이터베이스 관리 (DDL)
```sql
-- 데이터베이스 생성
CREATE DATABASE database_name;

-- 데이터베이스 선택
USE database_name;

-- 데이터베이스 목록 조회
SHOW DATABASES;

-- 데이터베이스 삭제
DROP DATABASE IF EXISTS database_name;
```

## 📌 테이블 관리(DDL)

### 테이블 생성

```sql
CREATE TABLE table_name (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(30) NOT NULL,
  email VARCHAR(50) UNIQUE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

### 테이블 구조 확인

```sql
-- 테이블 목록
SHOW TABLES;

-- 테이블 구조
DESC table_name;
```

### 테이블 구조 변경

```sql
-- 컬럼 추가
ALTER TABLE table_name ADD COLUMN column_name datatype;

-- 컬럼 이름 및 타입 변경
ALTER TABLE members CHANGE COLUMN column_name new_name datatype;

-- 데이터 타입 변경
ALTER TABLE members MODIFY COLUMN column_name datatype;

-- 컬럼 삭제
ALTER TABLE table_name DROP COLUMN column_name;
```

### 테이블 삭제
```sql
DROP TABLE IF EXISTS table_name;
```

---

## 📝 데이터 조작 (DML)

### INSERT - 데이터 입력

```sql
-- 단일 행 입력
INSERT INTO table_name (column1, column2) VALUES (value1, value2);

-- 다중 행 입력
INSERT INTO table_name (column1, column2) VALUES
(value1, value2),
(value3, value4);
```

### SELECT - 데이터 조회

```sql
-- 전체 조회
SELECT * FROM table_name;

-- 특정 칼럼 조회
SELECT column1, column2 FROM table_name;

-- 조건부 조회
SELECT * FROM table_name WHERE condition;
```

### UPDATE - 데이터 수정

```sql
UPDATE table_name SET column1 = value1 WHERE condition;
```

### DELETE - 데이터 삭제

```sql
DELETE FROM table_name WHERE condition;
```

---

## 🔐 주요 제약조건

| 제약조건            | 목적        | 특징               | 예시                                    |
| --------------- | --------- | ---------------- | ------------------------------------- |
| PRIMARY KEY     | 고유 식별자    | 중복·NULL 불가       | `id INT AUTO_INCREMENT PRIMARY KEY`   |
| NOT NULL        | 필수 입력     | 빈 값 불가           | `name VARCHAR(30) NOT NULL`           |
| UNIQUE          | 중복 방지     | NULL 허용, 여러 개 가능 | `email VARCHAR(50) UNIQUE`            |
| DEFAULT         | 기본값 자동 입력 | 미입력 시 값 자동 입력    | `status VARCHAR(10) DEFAULT 'active'` |
| AUTO\_INCREMENT | 자동 숫자 증가  | PK에 주로 사용        | `id INT AUTO_INCREMENT`               |

---

## 🔢 주요 데이터 타입

| 타입         | 설명      | 예시                    |
| ---------- | ------- | --------------------- |
| INT        | 정수      | `age INT`             |
| VARCHAR(n) | 가변 문자열  | `name VARCHAR(50)`    |
| TEXT       | 긴 문자열   | `content TEXT`        |
| DATE       | 날짜      | `birth_date DATE`     |
| DATETIME   | 날짜 + 시간 | `created_at DATETIME` |

---

## ⚠️ 주의사항

### ❗ 안전한 쿼리 작성

```sql
-- 위험 예시 (모든 데이터 영향)
UPDATE users SET status = 'inactive';
DELETE FROM users;

-- 안전 예시 (조건 지정)
UPDATE users SET status = 'inactive' WHERE id = 1;
DELETE FROM users WHERE status = 'deleted';
```

### ❗ WHERE 절 필수 상황

* `UPDATE`, `DELETE`, `SELECT` → 조건을 명확히 지정하여 안전한 실행

### ❗ IF EXISTS 사용

* 존재 여부 확인 후 삭제하여 에러 방지

```sql
DROP TABLE IF EXISTS table_name;
DROP DATABASE IF EXISTS database_name;
```

---

## 🎯 핵심 포인트 요약

* **DDL**로 구조를 만들고, **DML**로 데이터를 다룬다
* **스키마**는 데이터베이스의 설계도
* **제약조건**은 데이터의 무결성을 보장
* **WHERE**절은 안전한 데이터 조작의 핵심
* **PRIMARY KEY + AUTO\_INCREMENT**는 자주 쓰이는 기본 패턴
* **DEFAULT + CURRENT\_TIMESTAMP**로 자동 시간 입력 가능

```

---
