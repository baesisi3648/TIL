# Python 데이터 구조 정리

## 🔷 데이터 구조(Data Structure)

**정의**: 데이터를 효율적으로 구성·저장·관리하기 위한 형식

### 종류
- **순서 있음**: 문자열(str), 리스트(list), 튜플(tuple)
- **순서 없음**: 셋(set), 딕셔너리(dict)

---

## 📌 문자열(String)

### 특징
- **immutable** (변경 불가)
- **ordered** (순서 있음)
- **iterable** (반복 가능)

### 문자열 탐색 및 검증
```python
# 위치 찾기
str.find(x)        # x의 위치 반환 (없으면 -1)
str.index(x)       # x의 위치 반환 (없으면 오류 발생)

# 접두/접미어 확인
str.startswith(x)  # 접두어 확인
str.endswith(x)    # 접미어 확인

# 문자열 구성 확인
str.isalpha()      # 알파벳만 포함
str.isdigit()      # 숫자만 포함
str.isspace()      # 공백만 포함
str.isalnum()      # 알파벳+숫자만 포함
```

### 문자열 변경
```python
# 치환
str.replace(old, new[, count])

# 공백/문자 제거
str.strip([chars])   # 양쪽 제거
str.lstrip()         # 왼쪽 제거
str.rstrip()         # 오른쪽 제거

# 분할 및 결합
str.split([sep])     # 분할 → 리스트
'sep'.join(iterable) # 구분자 기준 결합
```

### 대소문자 관련
```python
str.capitalize()     # 첫 글자만 대문자
str.title()          # 각 단어의 첫 글자 대문자
str.upper()          # 모두 대문자
str.lower()          # 모두 소문자
str.swapcase()       # 대소문자 뒤바꿈
```

---

## 📌 리스트(List)

### 특징
- **mutable** (변경 가능)
- **ordered** (순서 있음)
- **iterable** (반복 가능)

### 값 추가 및 삭제
```python
# 추가
list.append(x)           # 맨 끝에 추가
list.extend(iterable)    # 여러 개 추가
list.insert(i, x)        # i번째에 삽입

# 삭제
list.remove(x)           # 첫 번째 x 제거
list.pop([i])            # i번째 제거 후 반환 (기본값: 마지막)
list.clear()             # 모두 삭제
```

### 탐색 및 정렬
```python
# 탐색
list.index(x)            # x의 위치 반환
list.count(x)            # x의 개수 반환

# 정렬
list.sort(key=, reverse=)  # 원본 변경
sorted(list)               # 원본 유지, 새 리스트 반환
list.reverse()             # 원본 뒤집기
```

---

## 📌 튜플(Tuple)

### 특징
- **immutable** (변경 불가)
- **ordered** (순서 있음)
- **iterable** (반복 가능)

### 주요 메서드
```python
tuple.index(x)    # x의 위치 반환
tuple.count(x)    # x의 개수 반환
```

---

## 📌 셋(Set)

### 특징
- **mutable** (변경 가능)
- **unordered** (순서 없음)
- **iterable** (반복 가능)
- **중복 허용 안함**

### 주요 메서드
```python
# 추가
set.add(x)              # 요소 하나 추가
set.update(iterable)    # 여러 요소 추가

# 삭제
set.remove(x)           # x 제거 (없으면 오류)
set.discard(x)          # x 제거 (없어도 오류 없음)
set.pop()               # 임의 요소 제거 후 반환
set.clear()             # 모두 삭제
```

### 집합 연산
```python
set1 | set2             # 합집합
set1 & set2             # 교집합
set1 - set2             # 차집합
set1 ^ set2             # 대칭차집합
```

---

## 📌 딕셔너리(Dictionary)

### 특징
- **mutable** (변경 가능)
- **unordered** (순서 없음)
- **iterable** (반복 가능)
- **Key:Value 쌍**

### 조회
```python
dict[key]                    # key로 접근 (없으면 오류)
dict.get(key[, default])     # 기본값 반환
dict.setdefault(key[, default])  # 없으면 추가 후 반환
```

### 추가 및 삭제
```python
dict[key] = value           # 추가/수정
dict.pop(key[, default])    # 삭제하고 값 반환
dict.update(other)          # 병합/갱신
dict.clear()                # 모두 삭제
```

### 키/값 조회
```python
dict.keys()                 # 모든 키 반환
dict.values()               # 모든 값 반환
dict.items()                # 모든 (키, 값) 쌍 반환
```

---

## 🧠 얕은 복사 vs 깊은 복사

### Immutable 데이터
값만 복사되므로 원본에 영향 없음
```python
a = 20
b = a
b = 10  # a는 여전히 20
```

### Mutable 데이터

#### 할당 (Assignment)
같은 객체를 바라봄 (`a is b → True`)
```python
a = [1, 2, 3]
b = a
b.append(4)  # a도 [1, 2, 3, 4]가 됨
```

#### 얕은 복사 (Shallow Copy)
객체는 다르나 내부 객체는 공유
```python
a = [1, 2, [3, 4]]
b = a[:]         # 또는 b = list(a)
b[2].append(5)   # a도 [1, 2, [3, 4, 5]]가 됨
```

#### 깊은 복사 (Deep Copy)
내부 객체까지 모두 복제
```python
from copy import deepcopy

a = [1, 2, [3, 4]]
b = deepcopy(a)
b[2].append(5)   # a는 [1, 2, [3, 4]] 그대로
```

---

## 💡 추가 팁

### 메서드 확인 방법
```python
# 사용 가능한 메서드 확인
dir(list)       # 리스트의 모든 메서드 확인
help(list.sort) # 특정 메서드의 자세한 설명
```

### 자료구조별 특징 요약
| 자료구조 | Mutable | Ordered | Iterable | 중복허용 |
|----------|---------|---------|----------|----------|
| str      | ❌      | ✅      | ✅       | ✅       |
| list     | ✅      | ✅      | ✅       | ✅       |
| tuple    | ❌      | ✅      | ✅       | ✅       |
| set      | ✅      | ❌      | ✅       | ❌       |
| dict     | ✅      | ❌      | ✅       | Key만 중복불가 |