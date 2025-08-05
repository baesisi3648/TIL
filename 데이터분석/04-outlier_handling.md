
# 📊 이상치 처리 요약 노트

## 🔍 1. 이상치란?
- 데이터 분포에서 극단적으로 벗어난 값
- 모델 성능에 부정적 영향 → 사전 탐지 및 처리 필요

## 🧪 2. 이상치 탐지 방법

### ✅ Z-Score (표준점수)
- 평균과 표준편차 기준으로 얼마나 떨어졌는지 계산
- 일반 기준: |Z| > 3이면 이상치

```python
from scipy import stats

z_scores = stats.zscore(df['가격'])
df[ np.abs(z_scores) > 3 ]
```

### ✅ IQR (Interquartile Range, 사분위수 범위)
- Q1 (25%) ~ Q3 (75%) 사이의 범위를 벗어난 값
- 기준: Q1 - 1.5*IQR, Q3 + 1.5*IQR 밖이면 이상치

```python
def detect_outlier_iqr(series):
    Q1, Q3 = series.quantile([0.25, 0.75])
    IQR = Q3 - Q1
    return (series < Q1 - 1.5*IQR) | (series > Q3 + 1.5*IQR)

df[detect_outlier_iqr(df['가격'])]
```

### ✅ Percentile 방식
- 상하위 백분위 기준으로 이상치 정의
- 예: 상위 99%, 하위 1% 초과

```python
def detect_outlier_perc(series, lower=1, upper=99):
    return (series < series.quantile(lower/100)) | (series > series.quantile(upper/100))

df[detect_outlier_perc(df['가격'], 1, 97)]
```

## 🛠 3. 이상치 처리 방법

### 🗑 제거 (Remove)
- 이상치를 아예 제외함 → 분석 왜곡 방지, 데이터 손실 가능

```python
def remove_outliers_iqr(df, col):
    Q1, Q3 = df[col].quantile([0.25, 0.75])
    IQR = Q3 - Q1
    return df[(df[col] >= Q1 - 1.5*IQR) & (df[col] <= Q3 + 1.5*IQR)]
```

### 🔧 변환 (Winsorization)
- 극단값을 백분위 경계값으로 조정 (clip)

```python
def winsorize_outliers(df, col, lower=5, upper=95):
    low = df[col].quantile(lower/100)
    high = df[col].quantile(upper/100)
    df[col] = df[col].clip(low, high)
    return df
```

### 🔁 대체 (Imputation)
- 이상치를 중앙값 등 다른 값으로 대체

```python
def replace_outliers_with_median(df, col):
    Q1, Q3 = df[col].quantile([0.25, 0.75])
    IQR = Q3 - Q1
    outliers = (df[col] < Q1 - 1.5*IQR) | (df[col] > Q3 + 1.5*IQR)
    df.loc[outliers, col] = df[col].median()
    return df
```

## 📈 4. 시각화로 비교
- 히스토그램, 박스플롯, 산점도 활용해 이상치 탐색 및 처리 전후 비교

### 예시:
- 원본 vs 제거 vs 윈저화 후 가격 분포 비교
- 수량 vs 가격 산점도에서 이상치 색으로 표시

## ✅ 실무 팁
- 탐지 + 처리 함께 고려
- 제거보단 변환/대체가 안정적인 경우 많음
- 시각화는 필수
