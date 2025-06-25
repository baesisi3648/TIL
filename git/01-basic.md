좋습니다! 요청하신 명령어들을 모두 포함하여, 각 명령어의 **설명과 예시**를 함께 담은 **마크다운(.md) 형식의 전체 문서**를 아래에 정리해드릴게요. 복사해서 `git-guide.md` 파일로 저장하면 바로 사용하실 수 있습니다.

---

````markdown
# 📘 Git 기본 명령어 정리 (예시 포함)

Git은 소스코드를 효과적으로 관리하고 협업할 수 있게 해주는 분산 버전 관리 시스템입니다. 아래는 Git을 처음 사용할 때 꼭 알아야 할 기본 명령어들의 정리입니다.

---

## 📥 git clone

```bash
git clone <원격 저장소 URL>
````

* 원격 저장소(GitHub, GitLab 등)의 전체 프로젝트를 **내 컴퓨터로 복제**합니다.

**예시:**

```bash
git clone https://github.com/username/project.git
```

---

## 🛠️ git init

```bash
git init
```

* 현재 디렉토리를 Git 저장소로 초기화합니다.
* `.git` 폴더가 생성되어 Git이 버전 관리를 시작합니다.

---

## 👤 사용자 정보 설정

```bash
git config --global user.name "홍길동"
git config --global user.email "hong@example.com"
```

* 커밋 기록에 사용될 이름과 이메일을 설정합니다.
* `--global` 옵션은 모든 Git 저장소에 적용됩니다.

---

## 📁 git add

```bash
git add <파일명>
```

* 특정 파일을 스테이징 영역에 추가합니다.
  커밋 대상 파일로 지정하는 작업입니다.

```bash
git add .
```

* 현재 디렉토리 하위의 **모든 변경 파일을 스테이징**합니다.

---

## 📦 git commit

```bash
git commit -m "커밋 메시지"
```

* 스테이징된 변경사항을 하나의 커밋(버전)으로 저장합니다.

**예시:**

```bash
git commit -m "Add main page layout"
```

---

## 🌐 원격 저장소 연결

```bash
git remote add origin <원격 저장소 URL>
```

* 로컬 저장소에 \*\*원격 저장소(origin)\*\*를 연결합니다.

**예시:**

```bash
git remote add origin https://github.com/username/project.git
```

---

## 📤 git push

```bash
git push origin main
```

* 로컬의 `main` 브랜치를 \*\*원격 저장소(origin)\*\*로 업로드합니다.
* 최초 푸시 시 `main` 브랜치를 명시해야 할 수도 있습니다.

---

## 🔍 git status

```bash
git status
```

* 현재 작업 디렉토리의 Git 상태를 확인합니다.
* 어떤 파일이 수정되었고, 커밋 대상인지 아닌지 등을 보여줍니다.

---

## 🔁 전체 Git 흐름 요약

```bash
# 1. 원격 저장소 복제 (처음 시작할 때)
git clone https://github.com/username/project.git

# 또는 새 프로젝트 만들기
git init
git config --global user.name "홍길동"
git config --global user.email "hong@example.com"

# 2. 작업한 파일 추가 및 커밋
git add .
git commit -m "Initial commit"

# 3. 원격 저장소 연결 및 업로드
git remote add origin https://github.com/username/project.git
git push origin main

# 4. 상태 확인
git status
```

---

> 📌 **팁:** 커밋 메시지는 팀원들이 이해하기 쉽게 간결하고 명확하게 작성하는 것이 좋습니다.
>
> 🧠 추가로 `git log`, `git pull`, `git branch`, `git merge` 등도 함께 익히면 더 효과적인 Git 사용이 가능합니다.

## 📎 기타 유용한 명령어
git log : 커밋 히스토리 보기

git pull : 원격 저장소에서 변경사항 가져오기

git branch : 브랜치 목록 확인

git checkout -b <브랜치명> : 새 브랜치 생성 및 이동
