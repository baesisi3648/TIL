# NumPy 기초

## 1. 데이터 분석 소개

### 데이터 분석의 핵심 개념
- **데이터 분석**: 데이터에서 유용한 정보와 인사이트를 추출하는 과정
- **데이터 기반 의사결정**: 현대 비즈니스의 핵심 요소
- **해결 문제**: 트렌드 파악, 이상 감지, 고객 이해, 비용 절감, 새로운 가치 창출

### 데이터 분석 프로세스
1. 문제 정의: 명확한 질문과 목표 설정
2. 데이터 수집: 관련 데이터 확보
3. 데이터 전처리: 정제, 변환, 통합
4. 탐색적 분석(EDA): 패턴 및 관계 발견
5. 모델링 및 분석: 통계/머신러닝 적용
6. 결과 해석 및 커뮤니케이션: 인사이트 도출 및 공유

### 파이썬 데이터 분석 라이브러리
- **NumPy**: 수치 계산, 다차원 배열
- **Pandas**: 데이터 조작 및 분석
- **Matplotlib/Seaborn**: 시각화
- **SciPy**: 과학 계산
- **Scikit-learn**: 머신러닝

## 2. NumPy 기초

### NumPy 개요
- NumPy: Numerical Python의 약자
- 특징: 빠른 연산 속도, 메모리 효율성, 다차원 배열 지원
- ndarray: NumPy의 핵심 데이터 구조

### 리스트와 NumPy 배열 비교
| 항목 | 리스트 | NumPy 배열 |
|------|--------|-------------|
| 데이터 타입 | 혼합 가능 | 동일 타입 |
| 크기 | 동적 | 고정 |
| 연산 속도 | 느림 | 빠름 |

### 배열 생성 예시
```python
import numpy as np

arr = np.array([1, 2, 3, 4, 5])
zeros = np.zeros(5)
ones = np.ones((2, 3))
full = np.full(5, 7)
arange = np.arange(0, 10, 2)
linspace = np.linspace(0, 1, 5)
random = np.random.rand(3, 3)
```

### 배열 속성
```python
print(arr.shape)   # 배열 형태 (튜플)
print(arr.ndim)    # 차원 수
print(arr.size)    # 총 요소 수
print(arr.dtype)   # 데이터 타입
```

### 배열 재구성
```python
arr = np.arange(12)
reshaped = arr.reshape(3, 4)
flat = reshaped.flatten()
flat_view = reshaped.ravel()
```

## 3. 인덱싱과 슬라이싱

### 기본 인덱싱
```python
arr = np.array([10, 20, 30, 40, 50])
print(arr[0])     # 10
print(arr[-1])    # 50

arr_2d = np.array([[1,2,3],[4,5,6],[7,8,9]])
print(arr_2d[0, 0])   # 1
print(arr_2d[1, 2])   # 6
```

### 슬라이싱
```python
print(arr[2:5])     # [2 3 4]
print(arr[:5])      # [0 1 2 3 4]
print(arr[5:])      # [5 6 7 8 9]
print(arr[::2])     # [0 2 4 6 8]

print(arr_2d[:2])         # 처음 두 행
print(arr_2d[:,1:3])      # 모든 행의 2,3열
print(arr_2d[1:3,0:2])    # 2~3행의 1~2열
```

### 고급 인덱싱
```python
mask = arr > 3
print(arr[mask])           # [4 5]
print(arr[arr % 2 == 0])   # [2 4]

indices = np.array([1, 3, 4])
print(arr[indices])        # [2 4 5]
```

## 4. NumPy 배열 연산

### 기본 산술 연산
```python
a = np.array([1, 2, 3])
b = np.array([4, 5, 6])

print(a + b)
print(a - b)
print(a * b)
print(a / b)
print(a ** 2)
```

### 브로드캐스팅
```python
arr = np.array([1, 2, 3])
print(arr + 10)

matrix = np.array([[1, 2, 3], [4, 5, 6]])
row_vec = np.array([10, 20, 30])
print(matrix + row_vec)
```

### 주요 함수
```python
arr = np.array([1, 2, 3, 4, 5])
print(np.sqrt(arr))
print(np.exp(arr))
print(np.sum(arr))
print(np.mean(arr))
print(np.std(arr))
```

### 배열 결합 및 분할
```python
a = np.array([1, 2, 3])
b = np.array([4, 5, 6])
print(np.concatenate([a, b]))
print(np.vstack([a, b]))
arr = np.arange(10)
print(np.split(arr, 2))
print(np.split(arr, [3, 7]))
```

## 5. 브로드캐스팅 심화
```python
matrix = np.array([[1,2,3],[4,5,6],[7,8,9]])
row_vec = np.array([10,20,30])
col_vec = np.array([[100],[200],[300]])
print(matrix + row_vec)
print(matrix + col_vec)
```

### 실용 응용
```python
data = np.array([[1,2,3],[4,5,6],[7,8,9]])
mean = np.mean(data, axis=0)
std = np.std(data, axis=0)
normalized = (data - mean) / std

points = np.random.rand(5, 2)
diff = points[:, np.newaxis, :] - points[np.newaxis, :, :]
distances = np.sqrt(np.sum(diff**2, axis=2))
```

## 6. NumPy 실전 응용

### 성적 분석 예시
```python
scores = np.array([[88,92,75],[90,87,66],[67,89,82],[95,78,89],[78,85,94]])
student_means = np.mean(scores, axis=1)
subject_means = np.mean(scores, axis=0)
rankings = np.argsort(student_means)[::-1]
```

### 확률 시뮬레이션
```python
flips = np.random.binomial(1, 0.5, 1000)
print(np.sum(flips)/1000)

dice = np.random.randint(1,7,(100,2))
sums = np.sum(dice, axis=1)
print(np.mean(sums == 7))
```

### 선형대수 연산
```python
A = np.array([[1,2],[3,4]])
B = np.array([[5,6],[7,8]])
print(np.matmul(A,B))
print(np.linalg.inv(A))
eigval, eigvec = np.linalg.eig(A)
```

# 🧮 NumPy 종합 요약

## 📌 핵심 개념

- **NumPy ndarray**: 효율적인 수치 계산을 위한 다차원 배열
- **벡터화된 연산**: 루프 없이 전체 배열에 연산 적용
- **브로드캐스팅**: 다른 크기의 배열 간 연산을 자동 확장
- **인덱싱/슬라이싱**: 배열의 특정 요소/부분집합 접근
- **집계 함수**: 합계, 평균, 표준편차 등 통계량 계산

---

## 🧠 활용 분야

- **데이터 전처리**: 결측치/이상치 처리, 정규화
- **통계 분석**: 기술통계, 상관관계, 가설검정
- **머신러닝**: 특성 공학, 모델 입력 준비
- **과학 계산**: 물리학, 공학, 금융 모델링
- **이미지 처리**: 필터링, 변환, 특성 추출

---

## 🛠️ 실무 팁

- **메모리 효율**: 적절한 데이터 타입 사용 (`np.int32`, `np.float32`)
- **뷰 vs 복사본**: 연산 시 의도치 않은 데이터 변경 주의
- **브로드캐스팅 이해**: 복잡한 연산 전에 형태 호환성 확인
- **벡터화 활용**: 가능한 한 반복문 대신 NumPy 내장 함수 사용

---

## 📊 Axis 관련 요약

### ✅ 핵심 개념

- `axis`는 "축의 번호"이지, "행"이나 "열"이 아님!
- → **"어느 축을 기준으로 연산을 할 것인가?"**

### ✅ 예: 2차원 배열

```python
import numpy as np

arr = np.array([[1, 2, 3],
                [4, 5, 6]])

arr.shape  # (2, 3)
```

| axis 값 | 기준 축 | 연산 방향 | 의미 |
|---------|----------|-------------|------|
| axis=0 | 행 인덱스 | 세로 방향 ↓ | 같은 열끼리 연산 |
| axis=1 | 열 인덱스 | 가로 방향 → | 같은 행끼리 연산 |

### ✅ 실전 예제

```python
np.sum(arr, axis=0)
# [[1, 2, 3],
#  [4, 5, 6]]
# 결과: [5, 7, 9]

np.sum(arr, axis=1)
# 결과: [6, 15]
```

### ✅ 이해 팁

- `axis=0`: 축 0(행)끼리 묶어서 계산 → 세로줄 기준(상하)
- `axis=1`: 축 1(열)끼리 묶어서 계산 → 가로줄 기준(좌우)

### ✅ 정리

| 작업 | axis 값 |
|------|----------|
| 같은 열끼리 연산 (세로 방향) | axis=0 |
| 같은 행끼리 연산 (가로 방향) | axis=1 |