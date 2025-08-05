
# 🕒 시계열 데이터 분석 요약노트

## 1. 시계열 데이터 개요
- 시계열 데이터(Time Series): 시간의 흐름에 따라 수집된 데이터.
- Pandas는 `DatetimeIndex`, `date_range`, `to_datetime`, `resample` 등의 도구를 제공.

## 2. 날짜 처리와 변환
```python
pd.to_datetime(date_string)
```
- 다양한 날짜 형식을 자동으로 변환 가능.
- 변환 실패 시 예외 처리 필요.

## 3. 날짜 인덱스 생성
```python
pd.date_range(start, end, freq='D'|'M'|'W')
```
- D: 일 단위, M: 월 말 기준, W: 주 단위

## 4. 시계열 DataFrame 생성 및 전처리
- 임의의 일별 매출 데이터 생성 (연간/주간 패턴 포함)
- `clip(lower=10000)`로 음수 제거
- `set_index('date')`로 날짜를 인덱스로 설정

## 5. 날짜 인덱스 속성 활용
- `df.index.year`, `month`, `day`, `weekday`, `day_name()`, `quarter`
- 년/월/일/요일/분기 등 다양한 날짜 정보 추출 가능

## 6. 그룹 분석 및 시각화
- `groupby()`로 요일/월/분기 평균 매출 분석
- `reindex()`로 요일 순서 정렬

### 📊 주요 시각화
- 일별 매출 추이
- 요일/월별/분기별 평균 매출
- 월별 박스플롯

## 7. 인덱싱 및 슬라이싱
```python
df['2023-01']
df['2023-01-01':'2023-01-15']
df.loc['2023-06']
```
- 날짜 문자열을 이용해 직관적 필터링 가능

### 🔍 조건 필터링 예시
```python
df[df['weekname'] == 'Friday']
df[df['weekday'].isin([5, 6])]
```

## 8. 고급 시각화 및 분석
### 📈 시계열 분해 (Trend / Seasonal / Residual)
```python
from statsmodels.tsa.seasonal import seasonal_decompose
seasonal_decompose(df['sales'], model='additive', period=7)
```

### 🔥 히트맵
- 월별 x 요일별 평균 매출 시각화 (`sns.heatmap`)

### 📦 박스플롯
- 월별 / 분기별 매출 분포 비교

## 9. 주요 통계 지표
```python
cumsum()           # 누적 매출
rolling().mean()   # 이동 평균선
pct_change()       # 변화율 계산
```

## 10. 리샘플링 (Resampling)
```python
df.resample('W'|'M'|'Q').agg(['sum', 'mean', ...])
```
- W: 주간, M: 월간, Q: 분기
- 시계열 집계 및 추세 분석 가능

### 📊 리샘플링 시각화
- 주/월/분기별 총 매출 및 통계 (최소/평균/최대)

## 11. 실습: 가상 주식 시계열 분석
- 기하 브라운 운동 모델을 이용해 주식가격 시뮬레이션
- 거래량은 가격 변동성과 반비례하게 생성
- `returns`, `close`, `volume` 컬럼 포함

## 12. 기타 시계열 분석 Tip
- `FuncFormatter`로 축 단위 유연하게 표시
- 다양한 그래프 레이아웃 (`subplot`, `tight_layout`)
- `matplotlib`, `seaborn`으로 복합 시각화 구성 가능

## ✅ 핵심 키워드 요약
- `pd.to_datetime()`, `pd.date_range()`
- `DatetimeIndex` 속성 활용
- `groupby()`, `resample()`, `rolling()`, `pct_change()`
- `seasonal_decompose()`, `sns.heatmap()`, `boxplot()`
- `cumsum()`, `rolling().mean()`
