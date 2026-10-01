---
name: start
description: >
  바이브 코딩 키트의 첫 단계. 서비스를 만들기 전에 필요한 개발 환경과 계정을 전부 준비한다.
  node·git이 없으면 직접 설치, Vercel·Supabase·토스페이먼츠·Google Cloud 계정 생성 안내,
  API 키 발급, .env.local 작성까지 처리한다.
  "시작", "처음", "setup", "환경 설정", "계정 만들기", "키 받아야 해", "뭐부터 해야 해",
  "개발 환경", "세팅" 같은 말이나, 아무 준비 없이 서비스를 만들려는 모든 요청에 트리거한다.
  코드는 한 줄도 쓰지 않는다. 준비물만 갖춘다.
---

# /start 환경과 계정

이 스킬은 **코딩 시작 전 준비물을 갖추는 단계**다. 코드는 쓰지 않는다.

사용자는 터미널을 처음 여는 사람이다. 명령어를 복붙할 줄만 안다고 가정한다.

## 진행 기록

시작할 때 `.claude/worklog/진행상황.md` 를 읽고 (없으면 만들고), **단계 하나를 끝낼 때마다** 고친다.
형식과 규칙은 `next` 스킬의 "작업 기록 파일" 을 따른다. 이미 "정해진 것" 에 있는 선택은 다시 묻지 않는다.
범위를 좁혀 돌렸으면 한 범위만 체크한다. 예: `/start local` 이면 "/start local" 한 줄만.

## 반드시 지킬 것

1. **기술 선택을 묻지 않는다.** Next.js + Supabase + Vercel + 토스페이먼츠로 정해져 있다.
   "어떤 DB 쓰실래요" 같은 질문을 하지 마라. 초보는 답할 수 없고, 답하려다 이탈한다.

2. **사업자등록 이야기를 여기서 절대 꺼내지 않는다.**
   토스는 테스트 키만 받는다. 첫 단계에서 그 벽을 만나면 사용자는 돌아오지 않는다.
   실결제 전환은 `/live` 와 `docs/02-실결제-전환-체크리스트.md`가 다룬다.
   사용자가 먼저 물어보면 "지금은 신경 안 쓰셔도 돼요. 다 만들고 나서 `/live` 라고 치시면 알려드릴게요"라고만 답한다.

3. **한 번에 하나씩.** 4개 계정을 한꺼번에 나열하지 마라.
   하나 끝내고 키를 받아서 `.env.local`에 적은 다음 다음 것으로 넘어간다.
   중간에 사용자가 나가도 거기까지는 남는다.

4. **브라우저에서 할 일은 화면에 보이는 그대로 적는다.**
   "프로젝트를 생성하세요"가 아니라 "초록색 New project 버튼을 누르세요"처럼.
   버튼 이름과 메뉴 위치를 말한다. 사이트가 개편돼서 안 보이면 사용자에게 화면을 물어본다.

5. **전문용어는 처음 나올 때 괄호로 푼다.**
   "환경변수(프로그램이 쓰는 비밀번호 같은 값들을 모아두는 파일)"

6. **키를 화면에 그대로 출력하지 않는다.** `.env.local`에 쓰고, 확인은 앞 8자만 보여준다.

## 범위 고르기

계정 4개를 한 번에 만들면 처음 하는 사람은 여기서 지쳐 나간다.
**기본 권장 순서는 "로컬에서 먼저 만들어 보고, 배포할 때 계정을 만든다"** 이다.
사용자가 아래처럼 범위를 말하면 그 부분만 한다. 아무 말 없으면 먼저 물어본다.

| 사용자가 이렇게 말하면 | 하는 것 | 끝나면 |
|---|---|---|
| `/start local`, "지금은 Node만", "계정은 나중에" | 0~1단계 (node·git) | `/plan` 안내. 계정 이야기는 꺼내지 않는다 |
| `/start deploy`, "배포하려고" | 5단계 (GitHub 계정 + gh 설치·로그인 + Vercel) | `/publish` 안내 |
| `/start accounts`, "로그인·결제 붙이려고" | GitHub 계정 확인(5-1) + 2~4단계 (Supabase·Google·토스) + 6단계 | `/build` 다시 돌리라고 안내 |
| `/start` 만 치고 범위를 말하지 않음 | 아래 0단계 질문으로 고르게 한다 | 고른 범위대로 |
| "전부", "다 준비할래" | 0~6단계 전체 | `/plan` 안내 |

범위를 좁혀 돌린 경우 완료 확인도 그 범위만 본다. 로컬만이면 `node --version` 이 20 이상이면 끝이다.

## 절차

### 0단계. 지금 어디까지 돼 있는지 확인

먼저 물어본다. 이미 계정이 있는 사람에게 처음부터 시키지 않는다.

```
어디까지 준비되셨는지 알려주세요. 없어도 괜찮아요, 같이 만들면 됩니다.
1. GitHub 계정
2. Vercel / Supabase / 토스페이먼츠 / Google Cloud 중 있는 것

그리고 오늘은 어디까지 갈까요?
A. 내 컴퓨터에서 먼저 만들어 보기 (추천, 계정 없이 시작)
B. 계정까지 전부 준비하기
```

A를 고르면 1단계까지만 하고 `/plan` 으로 보낸다.

작업 폴더가 없으면 만들고 `git init`까지 해둔다.

### 1단계. node와 git

```bash
node --version
git --version
```

둘 다 있고 `node` 가 20 이상이면 끝. 없으면 **사용자에게 사이트에 가서 받아오라고 하지 말고, 여기서 직접 설치한다.**
설치 전에 한 줄만 말한다. "node(자바스크립트를 실행하는 프로그램)가 없어서 제가 설치할게요. 1~2분 걸려요."
**Homebrew·nvm 은 쓰지 않는다.** 관리자 비밀번호를 물어보거나 설정이 꼬여서 초보가 막힌다.

#### node 설치 — Mac

관리자 비밀번호가 필요 없도록 **내 홈 폴더(`~/.node`)** 에 공식 배포본을 그대로 푼다. 아래를 한 번에 실행한다.

```bash
VER=$(curl -fsSL https://nodejs.org/dist/index.tab | awk -F'\t' 'NR>1 && $10!="-" {print $1; exit}')
case "$(uname -m)" in x86_64) A=x64;; *) A=arm64;; esac
curl -fsSL "https://nodejs.org/dist/$VER/node-$VER-darwin-$A.tar.gz" -o /tmp/node.tgz
rm -rf ~/.node && mkdir -p ~/.node && tar -xzf /tmp/node.tgz -C ~/.node --strip-components=1 && rm /tmp/node.tgz
grep -q '/.node/bin' ~/.zshrc 2>/dev/null || echo 'export PATH="$HOME/.node/bin:$PATH"' >> ~/.zshrc
grep -q '/.node/bin' ~/.zprofile 2>/dev/null || echo 'export PATH="$HOME/.node/bin:$PATH"' >> ~/.zprofile
~/.node/bin/node --version
```

- 첫 줄이 최신 LTS 버전을 알아낸다 (`index.tab` 의 `lts` 칸이 `-` 가 아닌 첫 줄). 버전을 손으로 적지 않는다.
- `.zshrc` 와 `.zprofile` 둘 다에 넣는 이유: 터미널은 `.zshrc` 를, 클로드 데스크탑 앱은 로그인 셸(`.zprofile`)을 읽는다.
- 마지막 줄에서 `v24.x.x` 처럼 버전이 찍히면 설치는 된 것이다. 이 세션에서 바로 쓰려면 이후 명령 앞에 `export PATH="$HOME/.node/bin:$PATH"` 를 붙인다.

#### git 설치 — Mac

```bash
xcode-select --install
```

이 명령은 **화면에 설치 창을 띄운다.** 터미널에서는 끝나지 않는다. 사용자에게 "화면에 뜬 창에서 **설치** 를 누르고 기다려주세요. 5~10분 걸려요" 라고 말하고,
끝났다고 하면 `xcode-select -p` 로 확인한다 (경로가 찍히면 됨). "이미 설치됨" 오류가 나면 이미 있는 것이다.

#### node·git 설치 — Windows

Windows에 기본으로 들어 있는 `winget` 으로 설치한다. 다른 걸 받아올 필요가 없다.

```powershell
winget install --id OpenJS.NodeJS.LTS -e --accept-source-agreements --accept-package-agreements
winget install --id Git.Git -e --accept-source-agreements --accept-package-agreements
```

- 중간에 "이 앱이 디바이스를 변경하도록 허용하시겠어요?" 창이 뜨면 **예** 를 누르라고 미리 말해둔다.
- `winget` 자체가 없다고 나오면 (오래된 Windows 10) Microsoft Store에서 **앱 설치 관리자** 를 설치하게 한다. 이 경우만 사이트 다운로드로 안내한다: [nodejs.org](https://nodejs.org) LTS, [git-scm.com](https://git-scm.com).

#### 설치 뒤

- **클로드(또는 터미널)를 껐다 켜야 새 프로그램을 인식한다.** 이 말을 반드시 해준다. 여기서 가장 많이 막힌다.
  껐다 켠 뒤 `node --version`, `git --version` 을 다시 돌려 확인하고 진행상황.md 에 적는다.
- git 이 처음이면 이름과 이메일을 넣어둔다. 커밋에 찍히는 값이고, 서비스에 보이지는 않는다.

```bash
git config --global user.name "<이름>"
git config --global user.email "<이메일>"
```

### 2단계. Supabase (데이터베이스와 로그인)

**GitHub 계정부터 확인한다.** Supabase와 Vercel 둘 다 GitHub로 로그인한다.
`/start deploy` 를 건너뛰고 바로 `/start accounts` 로 온 사람은 계정이 없을 수 있다.
없다고 하면 5-1(계정 만들기)만 먼저 하고 돌아온다. gh 설치와 Vercel은 배포 때 하므로 여기서는 하지 않는다.

1. [supabase.com](https://supabase.com) → **Start your project** → GitHub로 로그인
2. 처음 가입한 사람은 **조직(Organization)** 을 먼저 만들라는 화면이 나온다. 조직은 프로젝트를 담는 폴더라고 한 줄로 설명한다.

   | 칸 | 넣을 값 |
   |---|---|
   | Name | 아무거나 (본인 이름이나 서비스 이름) |
   | Type | `Personal` |
   | Plan | `Free - $0/month` (카드 등록을 묻지 않는 무료 요금제) |

3. **New project** 화면. 칸마다 아래 값을 그대로 불러준다. 표에 없는 칸은 건드리지 않고 기본값으로 둔다.

   | 칸 | 넣을 값 | 사용자에게 할 말 |
   |---|---|---|
   | Organization | 방금 만든 조직 | |
   | Project name | 서비스 이름 (영어·한글 상관없음) | "나중에 바꿀 수 있어요" |
   | Database Password | **Generate a password** 를 눌러 자동 생성 → **Copy** | "메모장 같은 데 꼭 따로 저장해두세요. 다시 볼 수 없어요." 지금 앱 코드에는 안 쓰지만 잃어버리면 재설정해야 한다 |
   | Region | `Northeast Asia (Seoul)` | "한국에서 쓸 거라 서울로 해야 빨라요." **만든 뒤에는 못 바꾼다** |
   | Compute size (보일 때만) | 기본값 (`Micro` 또는 `Nano`) 그대로 | 무료 요금제에서는 이것만 고를 수 있다 |
   | Enable Data API (보안 옵션 안) | **켠 채로 둔다** | 끄면 앱이 데이터베이스를 읽지 못한다 |
   | Automatically expose new tables (보안 옵션 안) | **체크하지 않는다** (기본값) | 새 테이블이 인터넷에 저절로 열리지 않게 하는 안전장치. `/build` 가 테이블마다 필요한 권한만 따로 열어준다 |
   | Postgres type (보일 때만) | 기본값 `Postgres` | 실험 버전(OrioleDB)은 고르지 않는다 |

   화면이 표와 다르면 (칸 이름이 바뀌었거나 모르는 칸이 있으면) 추측하지 말고 사용자에게 보이는 칸 이름을 물어본 뒤 답한다.
   원칙은 하나다. **지역만 서울로 바꾸고, 나머지 모르는 칸은 기본값.**

4. 초록색 **Create new project** 를 누른다. 생성에 1~2분 걸린다. 기다리는 동안 다음 설명을 해준다.
5. 왼쪽 아래 **Project Settings** → **API Keys**

받아올 값 3개:

| 값 | 어디에 |
|---|---|
| Project URL | `NEXT_PUBLIC_SUPABASE_URL` |
| Publishable key (`sb_publishable_...`) | `NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY` |
| Secret key (`sb_secret_...`) | `SUPABASE_SECRET_KEY` |

**키 이름이 바뀌었다.** 예전 `anon` / `service_role` 키는 레거시이고 2026년 말 폐기된다.
화면에 `anon`만 보이면 새 키를 발급받게 안내한다.

`NEXT_PUBLIC_`이 붙은 값은 브라우저로 전송된다. **`SUPABASE_SECRET_KEY`에는 절대 붙이지 않는다.**
사용자에게도 이 차이를 한 줄로 설명한다. "앞에 NEXT_PUBLIC이 붙으면 남들도 볼 수 있는 값이에요."

### 3단계. Google Cloud (구글 로그인)

먼저 Supabase에서 콜백 주소를 복사한다.
Supabase 대시보드 → **Authentication** → **Sign In / Providers** → **Google** → 거기 표시된 **Callback URL**.

그 다음 [console.cloud.google.com](https://console.cloud.google.com):

1. 프로젝트 생성
2. **APIs & Services** → **OAuth consent screen** 먼저 설정 (안 하면 클라이언트를 못 만든다)
   - User Type: External
   - 앱 이름, 지원 이메일만 채우면 된다
3. **Credentials** → **Create Credentials** → **OAuth client ID**
   - Application type: **Web application**
   - **Authorized redirect URIs**에 아까 복사한 Supabase 콜백 URL을 붙여넣는다
4. 나온 **Client ID**와 **Client Secret**을 Supabase의 Google provider 화면에 붙여넣고 저장

이 단계가 4개 중 제일 길다. 사용자에게 미리 말해준다.
**여기서 지치는 사람이 많으니 중간에 "거의 다 왔어요" 같은 말을 넣는다.**

Google 키는 Supabase 대시보드에 저장되므로 `.env.local`에는 넣지 않는다.

### 4단계. 토스페이먼츠 (결제, 테스트 키만)

**사업자등록 없이 테스트 키로 간다.** 어떤 키를 쓰는지는 기획서의 프리셋에 따라 다르다.
`docs/기획서.md` 가 아직 없으면 "매달 결제하는 구독 서비스인가요?" 하나만 묻고 고른다.
(근거: 토스 [API 키 가이드](https://docs.tosspayments.com/reference/using-api/api-keys.md).
주문서형 결제용 내 키는 사업자등록이 필요한 전자결제 신청 뒤에만 나온다.)

**단건·예약 → 가입 없이 문서용 테스트 키**

토스 문서에 공개된 주문서형 결제(옛 이름 결제위젯) 테스트 키를 그대로 넣는다. 가입하지 않아도 된다.

| 값 | 어디에 |
|---|---|
| `test_gck_docs_Ovk5rk1EwkEbP0W43n07xlzm` | `NEXT_PUBLIC_TOSS_CLIENT_KEY` |
| `test_gsk_docs_OaPz8L5KdmQXkzRz3y47BMw6` | `TOSS_SECRET_KEY` |

결제창과 결제 승인까지 테스트된다. 다만 모두가 같이 쓰는 키라서 내 결제 내역이 안 보이고 웹훅을 등록할 수 없다.
사용자에게 한 줄로 말해준다. "사업자등록하고 토스에 전자결제 신청을 하면 내 키로 두 값만 바꾸면 돼요."

**구독 → 개발자센터 가입 후 내 테스트 키**

[developers.tosspayments.com](https://developers.tosspayments.com) 에서 **이메일만으로** 가입한다. 사업자등록번호는 묻지 않는다.
가입하면 "개발 연동 체험 상점"이 생긴다. 개발자센터 → API 키 → **API 개별 연동 키** 에서 받는다.

| 값 | 어디에 |
|---|---|
| 테스트 클라이언트 키 (`test_ck_...`) | `NEXT_PUBLIC_TOSS_CLIENT_KEY` |
| 테스트 시크릿 키 (`test_sk_...`) | `TOSS_SECRET_KEY` |

구독의 자동결제(빌링)는 이 `ck`/`sk` 키를 쓴다. 이 키로는 결제 내역과 웹훅까지 내 계정에서 된다.

어느 쪽이든 키가 `test_` 로 시작하는지 확인시킨다. `live_` 는 실제 돈이 나간다.

### 5단계. GitHub 연결과 Vercel (배포 준비)

#### 5-1. GitHub 계정

없으면 [github.com](https://github.com) 에서 이메일로 가입한다. 있으면 로그인만 확인한다.

#### 5-2. GitHub CLI(gh) 설치

`/publish` 가 코드를 GitHub에 올릴 때 이 도구로 저장소를 만들고 로그인한다. 터미널에서 GitHub에 접속하는 프로그램이라고 한 줄로 설명한다.

```bash
gh --version
```

없으면 1단계의 node 처럼 **여기서 직접 설치한다.** Homebrew는 쓰지 않는다.

Mac — 관리자 비밀번호 없이 홈 폴더(`~/.node/bin`, 1단계에서 PATH에 넣은 곳)에 넣는다:

```bash
V=$(curl -fsSL https://api.github.com/repos/cli/cli/releases/latest | grep -o '"tag_name": *"v[^"]*"' | grep -o 'v[0-9.]*')
case "$(uname -m)" in x86_64) A=amd64;; *) A=arm64;; esac
curl -fsSL "https://github.com/cli/cli/releases/download/$V/gh_${V#v}_macOS_$A.zip" -o /tmp/gh.zip
mkdir -p ~/.node/bin && unzip -qo /tmp/gh.zip -d /tmp/gh && cp /tmp/gh/gh_*/bin/gh ~/.node/bin/ && rm -rf /tmp/gh /tmp/gh.zip
~/.node/bin/gh --version
```

(`~/.node` 가 없는 컴퓨터면 — node를 다른 방법으로 깔아둔 경우 — `mkdir -p ~/.node/bin` 뒤 1단계와 같이 `.zshrc`·`.zprofile` 에 PATH 줄을 넣는다.)

Windows:

```powershell
winget install --id GitHub.cli -e --accept-source-agreements --accept-package-agreements
```

**설치 후 클로드(또는 터미널)를 껐다 켜야 인식된다.** node 때와 같은 함정이다.

#### 5-3. gh 로그인

```bash
gh auth login
```

질문이 나오면 이렇게 고르게 한다. 하나씩 화면 그대로 말해준다.

1. `GitHub.com`
2. `HTTPS`
3. `Yes` (Git 인증에 gh 사용)
4. `Login with a web browser` → 화면에 나온 8자리 코드를 복사 → Enter → 브라우저에서 코드 붙여넣고 **Authorize**

```bash
gh auth status
```

`Logged in to github.com account <아이디>` 가 나오면 끝이다.

#### 5-4. 스타 부탁 (이 자리에서 한 번만)

로그인이 확인된 직후 아래를 말한다. 강요하지 않고, 싫다고 하거나 답이 없으면 그냥 넘어간다. 프로젝트당 한 번만 한다.

```
방금 GitHub에 로그인됐으니 하나만 부탁드릴게요.
이 키트가 도움이 됐다면 별 하나 눌러주세요. 다음 사람이 찾기 쉬워집니다.
https://github.com/dongho108/vibe-coding-kit
제가 대신 눌러드릴까요? (네 / 아니요)
```

"네"일 때만 실행한다.

```bash
gh api -X PUT /user/starred/dongho108/vibe-coding-kit
```

#### 5-5. Vercel

[vercel.com](https://vercel.com) → **Continue with GitHub** → 권한 허용. 지금은 여기까지만 한다.
실제 배포는 `/publish`에서 한다. 키를 미리 받을 필요 없다.

### 6단계. `.env.local` 작성

프로젝트 폴더에 만든다.

```bash
# Supabase
NEXT_PUBLIC_SUPABASE_URL=
NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY=
SUPABASE_SECRET_KEY=

# 토스페이먼츠 (테스트 키)
NEXT_PUBLIC_TOSS_CLIENT_KEY=
TOSS_SECRET_KEY=
```

`.gitignore`에 `.env*` 가 있는지 **반드시 확인한다.** 없으면 추가한다.
(`.env*.local` 만으로는 부족하다. Vercel 토큰 같은 값이 `.env` 에 들어가기도 한다.
Next.js가 만드는 `.gitignore` 에도 `.env*` 로 들어 있다.)
정말 무시되는지 명령으로 확인한다. 경로가 출력되면 된 것이다.

```bash
git check-ignore -v .env.local
```

사용자에게 왜 중요한지 한 줄로 말해준다. "이게 없으면 비밀 키가 GitHub에 그대로 올라갑니다."

## 완료 확인

범위를 좁혀 돌렸으면 그 범위만 확인한다. 아래는 전체 모드 기준이다.

```bash
grep -c '=$' .env.local
```

`0`이 나와야 한다. 빈 값이 남아 있으면 어느 항목인지 짚어주고 그 단계로 되돌아간다.

마지막으로 요약해준다.

```
준비 끝났습니다.
✅ Supabase  데이터베이스와 로그인
✅ Google    구글 로그인 연결
✅ 토스페이먼츠  결제 (테스트 키)
✅ GitHub    gh 로그인
✅ Vercel    배포 (계정만, 배포는 나중에)

이제 뭘 만들지 정할 차례예요. /plan 이라고 쳐주세요.
```

## 자주 막히는 곳

| 증상 | 원인과 답 |
|---|---|
| `node: command not found` (설치했는데도) | 터미널을 껐다 켜야 한다. 그래도 안 되면 `cat ~/.zshrc ~/.zprofile` 에 `.node/bin` 줄이 있는지 본다 |
| Mac에서 `curl` 이 실패한다 | 인터넷·회사 프록시 문제. 와이파이를 바꿔보고, 안 되면 그때만 [nodejs.org](https://nodejs.org) 설치 파일로 안내 |
| `xcode-select --install` 이 "이미 설치됨" | 이미 있는 것. `git --version` 으로 확인하고 넘어간다 |
| `gh: command not found` (설치했는데도) | 같은 이유. 껐다 켜기 |
| `gh auth login` 에서 브라우저가 안 열린다 | 화면의 주소(github.com/login/device)를 직접 열고 코드 입력 |
| Supabase 지역을 서울 말고 다른 곳으로 만들었다 | 지역은 나중에 못 바꾼다. 아직 데이터가 없으면 프로젝트를 지우고 서울로 새로 만든다 |
| Supabase에 `anon` 키만 보인다 | 레거시 키다. API Keys에서 새 publishable 키를 발급 |
| Google에서 OAuth client 생성 버튼이 없다 | OAuth consent screen을 먼저 설정해야 한다 |
| 구글 로그인 시 `redirect_uri_mismatch` | Google의 Authorized redirect URIs와 Supabase 콜백 URL이 한 글자라도 다르다. 복사해서 붙여넣게 한다 |
| 토스 키가 `live_`로 시작한다 | 실결제 키다. 테스트 키로 바꾼다 |
| 토스에서 사업자등록번호를 요구한다 | 실결제 신청 화면으로 들어간 것이다. 개발자센터의 테스트 키 화면으로 돌아간다 |

## 다음

`/plan` 이라고 치세요.
