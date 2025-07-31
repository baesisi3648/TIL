# 📂 파일 로드 및 저장 (CSV)

## 텍스트 인코딩 주의
- EUC-KR, UTF-8 등 인코딩을 지정하지 않으면 한글 깨짐 가능성 있음.

```python
# 파일 직접 열기
with open('./namsan.csv', encoding='EUC-KR') as f:
    print(f.readline())

# pandas로 불러오기
df = pd.read_csv('./namsan.csv', encoding='EUC-KR', dtype={'ISBN': str, '세트 ISBN': str})
```

## 저장
```python
df.to_csv('./test.csv', encoding='utf-8', index=False)
```

---

# ❓ 결측치 처리

## ✅ 확인
```python
df.isna()        # True/False 확인
df.isna().sum()  # 컬럼별 개수
df.isna().mean() * 100  # 비율
```

## ✅ 마스킹
```python
mask_has_na = df.isna().any(axis=1)
mask_no_na = df.notna().all(axis=1)
df[mask_has_na]   # 결측치 있는 행
df[mask_no_na]    # 결측치 없는 행
```

## ✅ 시각화
```python
sns.heatmap(df.isna(), cmap='viridis', cbar=False)
df.isna().sum().plot(kind='bar')
```

## ✅ 결측치 삭제
```python
df.dropna()                            # 결측치 있는 행 삭제
df.dropna(subset=['이름', '성별'])     # 특정 열 기준
df.dropna(axis=1)                      # 결측치 있는 열 삭제
```

## ✅ 결측치 채우기
```python
df.fillna(0)  # 일괄 값

# 컬럼별 값 설정
df.fillna({'이름': '익명', '급여': df['급여'].mean()})

# 앞/뒤 값으로 채우기
df.ffill()  # forward fill
df.bfill()  # backward fill
```

## ✅ 보간법 (interpolation)
```python
df.interpolate(method='linear')  # 시간 무시
df.interpolate(method='time')    # 시간 고려 (인덱스가 datetime이어야 함)
```

---

# 🔠 문자열 처리 & 타입 변환

## ✅ 문자열 메서드
```python
df['이메일'].str.upper()
df['이메일'].str.contains('gmail')
df['전화번호'].str.replace('-', '').str.replace(' ', '')
```

## ✅ 문자열 추출 및 분할
```python
df['이메일'].str.extract(r'@([^.]+)')  # 도메인만 추출
df['이메일'].str.split('@', expand=True)  # 사용자명, 도메인 분리
```

## ✅ 타입 변환
```python
df['정수형'] = df['정수형'].astype(int)
df['실수형'] = df['실수형'].astype(float)
df['불리언'] = df['불리언'].astype(bool)
df['날짜'] = pd.to_datetime(df['날짜'])

pd.to_numeric(df['혼합형'], errors='coerce')  # 변환 불가 시 NaN
pd.to_numeric(df['혼합형'], errors='ignore')  # 변환 불가 시 원래 데이터 유지
```

---

# 🧱 열(Column) 처리

## ✅ 열 삭제
```python
df.drop('비고', axis=1)  # 단일 열
df.drop(['비고', '임시데이터'], axis=1)  # 여러 열
```

## ✅ 열 이름 변경
```python
df.rename(columns={'국어점수': '국어'})
df.columns = [...]  # 전체 이름 교체
```

## ✅ 열 추가
```python
df['총점'] = df[['국어', '영어', '수학']].sum(axis=1)
df['성적등급'] = pd.cut(df['평균'], bins=[0, 70, 80, 90, 100], labels=['D', 'C', 'B', 'A'])
```

---

# 📊 행(Row) 처리

## ✅ 행 삭제
```python
df.drop(0)               # 인덱스로 삭제
df.drop([0, 2, 4])       # 여러 행 삭제
df.dropna()              # 결측치 있는 행 삭제
df.drop_duplicates()     # 중복 제거
```

## ✅ 행 필터링 및 정렬
```python
df[df['나이'] < 30]  # 조건 필터링

df.sort_values('급여', ascending=False)  # 정렬
df.reset_index(drop=True)  # 인덱스 재설정
```