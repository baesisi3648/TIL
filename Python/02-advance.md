# Python Advance

## ✅ 컨테이너(Container)

여러 값을 담을 수 있는 자료형  
서로 다른 자료형도 담을 수 있음

---

## 📦 분류

| 유형       | 설명               | 예시                   |
|------------|--------------------|------------------------|
| 시퀀스형   | 순서 있음 (ordered) | list, tuple, range, str |
| 비시퀀스형 | 순서 없음 (unordered) | set, dict             |

---

## 🧱 시퀀스형 컨테이너

### 1. List
- 변경 가능(mutable), 순서 있음
- `[]`, `list()` 사용
- 예: `['서울', '부산']`

### 2. Tuple
- 변경 불가(immutable), 순서 있음
- `()`, `tuple()` 사용
- 단일 요소 튜플은 `(1,)` 처럼 쉼표 필요

### 3. Range
- 정수 시퀀스 생성
- `range(start, end, step)`
- 슬라이싱, 반복 등 시퀀스 연산 가능

### 4. String
- 문자 시퀀스
- 불변(immutable), 인덱싱/슬라이싱 가능

---

## 🔧 비시퀀스형 컨테이너

### 1. Set
- 중복 없음, 순서 없음
- `{}`, `set()` 사용
- 집합 연산 가능 (`|`, `&`, 등)

### 2. Dictionary
- key: value 쌍
- `{}`, `dict()` 사용
- key는 immutable만 가능

---

## 🧙 패킹 / 언패킹 (* 연산자)

- 패킹: `x, *y = 1, 2, 3` → `x=1`, `y=[2, 3]`
- 언패킹: `multiply(*[1, 2, 3])` → `multiply(1, 2, 3)`
- `*`는 곱셈 또는 패킹/언패킹 의미로 상황에 따라 다름

---

## 🔄 컨테이너 간 형변환

### 가능한 변환 예시:

| 변환                      | 결과 예시                 |
|---------------------------|----------------------------|
| `list((1,2))`             | `[1, 2]`                   |
| `set([1,2,2])`            | `{1, 2}`                   |
| `tuple(range(3))`         | `(0, 1, 2)`                |
| `dict([('a', 1), ('b', 2)])` | `{'a': 1, 'b': 2}`        |

> `dict()`는 (key, value) 쌍 필요

---

## ➕ 시퀀스 연산자

### `+` : 연결

- `[1,2] + [3]` → `[1,2,3]`
- `'a' + 'b'` → `'ab'`
- `range`에는 불가

### `*` : 반복

- `[0] * 3` → `[0,0,0]`
- `'hi' * 2` → `'hihi'`
- `range`에는 불가

---

## 🔍 인덱싱 / 슬라이싱

### 인덱싱

- `my_list[0]`
- 음수 인덱싱 가능: `[-1]`

### 슬라이싱

- `[start:end:step]`
- 예: `[1,2,3,4][1:3]` → `[2,3]`
- `[::-1]` → 역순

---

## 📦 기타 개념 요약

### 변수 & 자료형
- 모든 값은 객체, 자료형은 `type()`

### 함수 (Function)
- `def 이름(매개변수): return 값`

### 모듈 / 패키지 / 라이브러리
- **모듈**: `.py` 파일 (함수/클래스 모음)
- **패키지**: 모듈들의 묶음 (`__init__.py` 포함)
- **라이브러리**: 패키지 모음 (예: `pandas`, `matplotlib`)


## ✅ 파이썬 제어문 (Control Statement)

파이썬에서 코드 흐름을 제어하는 방법으로 크게 **조건문**, **반복문**, **제어문**이 있습니다.

---

## 🔹 조건문 (Conditional Statements)

### 1. if 문 기본 구조
```python
if 조건:
    실행문
elif 조건:
    실행문
else:
    실행문
```
- 조건은 `True/False`로 평가됨
- `elif`, `else`는 선택적
- 코드 블록은 **들여쓰기(4 spaces)**로 구분

---

### 2. 조건 표현식 (삼항 연산자)
```python
result = '양수' if num > 0 else '음수'
```

---

### 3. 중첩 조건문
```python
if 조건1:
    if 조건2:
        실행문
```

---

### 4. 예시
```python
num = int(input())
if num % 2 == 0:
    print("짝수")
else:
    print("홀수")
```

---

## 🔹 반복문 (Loops)

### 1. while 문
```python
while 조건:
    실행문
```
- 조건이 `True`인 동안 반복
- 반드시 종료 조건 필요!

---

### 2. for 문
```python
for 변수 in 반복가능한객체:
    실행문
```
- 문자열, 리스트, `range` 등 iterable 순회
- 딕셔너리 순회: `dict.keys()`, `dict.values()`, `dict.items()`
- `enumerate()`로 인덱스와 값 동시 접근 가능

#### 예시
```python
for char in "안녕!":
    print(char)

i = 1
while i <= 10:
    print(i)
    i += 1
```

---

## 🔹 반복 제어문 (break / continue / pass)

### 1. break
반복문을 **즉시 종료**
```python
for num in range(10):
    if num == 3:
        break
    print(num)
```

---

### 2. continue
**이번 반복을 건너뛰고**, 다음 반복 진행
```python
for num in range(5):
    if num % 2 == 0:
        continue
    print(num)  # 홀수만 출력
```

---

### 3. pass
**아무것도 하지 않고 넘어감**
- 문법적으로 블록(`: + 들여쓰기`)을 채울 필요가 있을 때 사용
- 일반적으로 조건문, 반복문의 형태만 만들어 놓고 넘어갈 때 사용

```python
if condition:
    pass  # 구현 예정
```