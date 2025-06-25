# 📘 Git 기본 명령어 정리

Git은 버전 관리 시스템으로, 프로젝트의 변경 이력을 기록하고 협업을 가능하게 해줍니다. 아래는 Git을 사용할 때 자주 쓰는 명령어들과 그 예시입니다.

---

## 🛠️ 1. Git 초기화 및 사용자 설정

```bash
git init
현재 디렉토리를 Git 저장소로 초기화합니다.

.git 폴더가 생성되어 Git이 변경 이력을 관리하게 됩니다.

bash
복사
편집
git config --global user.name "홍길동"
git config --global user.email "hong@example.com"
Git 커밋에 사용될 사용자 이름과 이메일을 설정합니다.

--global 옵션은 컴퓨터 전체에 적용됩니다.

📁 2. 파일 스테이징 (추적할 파일 지정)
bash
복사
편집
git add <파일명>
특정 파일을 스테이징(커밋 후보) 영역에 추가합니다.

bash
복사
편집
git add .
현재 디렉토리의 모든 변경 파일을 스테이징합니다.

예시:

bash
복사
편집
git add index.html
git add .
📦 3. 커밋 (스냅샷 저장)
bash
복사
편집
git commit -m "커밋 메시지"
스테이징된 파일들의 현재 상태를 Git 히스토리에 저장합니다.

예시:

bash
복사
편집
git commit -m "Add user login form"
🌐 4. 원격 저장소 연결 및 업로드
bash
복사
편집
git remote add origin <원격 저장소 URL>
원격 저장소를 로컬 저장소에 연결합니다.

예시:

bash
복사
편집
git remote add origin https://github.com/hong/project.git
bash
복사
편집
git push origin main
로컬의 main 브랜치를 원격 저장소에 업로드합니다.

🔍 5. Git 상태 확인
bash
복사
편집
git status
현재 저장소의 상태(추적 중, 수정됨, 커밋할 파일 등)를 보여줍니다.

예시 출력:

yaml
복사
편집
On branch main
Changes not staged for commit:
  modified:   style.css

Untracked files:
  script.js
🔁 6. 전체 사용 흐름 예시
bash
복사
편집
# 1. Git 저장소 초기화
git init

# 2. 사용자 정보 설정 (최초 1회)
git config --global user.name "홍길동"
git config --global user.email "hong@example.com"

# 3. 파일 추가 및 커밋
git add .
git commit -m "Initial commit"

# 4. 원격 저장소 연결 및 푸시
git remote add origin https://github.com/hong/project.git
git push origin main

📎 참고
git log: 커밋 히스토리 확인

git clone <URL>: 원격 저장소 복제