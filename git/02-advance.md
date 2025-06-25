# 🌿 git branch – 새로운 작업 공간 만들기
## 🧠 개념:
**브랜치(branch)**는 기존 작업(main)과 별도로 새로운 작업을 시도할 수 있는 공간이에요.

메인 코드에 영향 없이 실험하고, 다 끝나면 다시 합치면 돼요.

## 🛠️ 자주 쓰는 명령어:
```bash
git branch          # 브랜치 목록 확인
git branch 새브랜치명   # 브랜치 만들기
git checkout 브랜치명   # 브랜치 이동
git checkout -b 새브랜치명 # 만들고 바로 이동
```
## 📌 예시:
```bash
git branch login-feature      # login-feature라는 브랜치 생성
git checkout login-feature    # 그 브랜치로 이동
```

# 🔗 git merge – 작업을 다시 합치기

## 🧠 개념:
작업이 끝난 브랜치를 다시 main 브랜치에 합치기!

merge는 말 그대로 변경 내용을 합치는 작업

## 🛠️ 예시:
```bash
git checkout main         # main 브랜치로 이동
git merge login-feature   # login-feature 브랜치의 내용을 main에 합치기
```

## 🔁 전체 흐름 그림으로 보면
```scss
(main) ───────▶ 개발 진행 중

       └─┬─ (login-feature 브랜치 생성)
         └─ 작업...작업...

(main) ◀───── merge 후 다시 하나로 합쳐짐
```

## ✅ 정리 요약
명령어	설명
---
```bash
git branch	#브랜치 목록 확인

git branch new-feature	#새로운 브랜치 생성

git checkout new-feature #브랜치로 이동

git checkout -b new-feature	#만들고 바로 이동

git merge #브랜치명	다른 브랜치의 변경 사항을 현재 브랜치에 합침
```