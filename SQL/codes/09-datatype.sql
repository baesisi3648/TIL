USE lecture;
DROP TABLE dt_demo;
CREATE TABLE dt_demo(
	id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(20) NOT NULL,
    nickname VARCHAR(20),
    birth DATE,
	score FLOAT,
    salary DECIMAL(20,3),
    description TEXT,
    is_active BOOL DEFAULT TRUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

DESC dt_demo;

INSERT INTO dt_demo (name, nickname, birth, score, salary, description) VALUES
('김철수', 'kim', '1995-01-01', 88.75, 3500000.50, '우수한 학생입니다. 성적은 우수권입니다.'),
('이영희', 'lee', '1990-05-15', 92.30, 4200000.00, '성실하고 열심히 공부합니다. 성적이 최우수권입니다.'),
('박민수', 'park', '1988-09-09', 75.80, 2800000.75, '인성이 좋습니다. 성적은 중위권입니다.'),
('배성우','bae', '1993-07-16', 79.99, 4500000.50, '성적 향상이 기대되는 학생입니다. 성적은 현재 중상위권입니다.');

SELECT * FROM dt_demo;

-- 80점 이상만 조회
SELECT * FROM dt_demo WHERE score >= 80;

-- description에 '학생'이라는 말이 없는 사람

SELECT * FROM dt_demo WHERE description NOT LIKE '%학생%';

-- 95년 이전 출생자만 조회
SELECT * FROM dt_demo WHERE birth < '1995-01-01';
