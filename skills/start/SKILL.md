---
name: start
description: >
  바이브 코딩 키트의 첫 단계. 서비스를 만들기 전에 필요한 개발 환경과 계정을 전부 준비한다.
  node·git·gh 직접 설치, Supabase 프로젝트 생성과 키 받기(Supabase MCP), 구글 로그인 설정(브라우저 조작),
  토스페이먼츠 테스트 키, Vercel 로그인, .env.local 작성까지 Claude가 직접 하고 사용자에게는 가입·허용만 시킨다.
  "시작", "처음", "setup", "환경 설정", "계정 만들기", "키 받아야 해", "뭐부터 해야 해",
  "개발 환경", "세팅" 같은 말이나, 아무 준비 없이 서비스를 만들려는 모든 요청에 트리거한다.
  코드는 한 줄도 쓰지 않는다. 준비물만 갖춘다.
---

# /start 환경과 계정

이 스킬은 **코딩 시작 전 준비물을 갖추는 단계**다. 코드는 쓰지 않는다.

사용자는 터미널을 처음 여는 사람이다. 명령어도 사이트 메뉴도 모른다고 가정한다.
**Claude가 할 수 있는 건 전부 Claude가 한다.** 사용자에게는 가입·로그인·"허용" 버튼·복사 버튼처럼 본인만 할 수 있는 것만 시킨다.
무엇을 어떤 순서로 처리하는지는 `next` 스킬의 "사용자에게 일 시키는 기준" 을 따른다.

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
   하나 끝내고 키를 `.env.local`에 적은 다음 다음 것으로 넘어간다.
   중간에 사용자가 나가도 거기까지는 남는다.

4. **사이트 작업은 Claude가 먼저 한다.** MCP·CLI → Claude의 브라우저 조작 → 외부 브라우저 순서다.
   사용자에게 메뉴를 찾아가게 하지 말고, 할 일이 있는 **그 페이지**를 열어서 버튼 하나만 시킨다.
   사용자 화면을 안내해야 할 때는 "초록색 New project 버튼"처럼 보이는 그대로 말한다. 화면이 다르면 추측하지 말고 물어본다.

5. **전문용어는 처음 나올 때 괄호로 푼다.**
   "환경변수(프로그램이 쓰는 비밀번호 같은 값들을 모아두는 파일)"

6. **키를 화면에 그대로 출력하지 않는다.** `.env.local`에 쓰고, 확인은 앞 8자만 보여준다.
   비밀 키는 클립보드로 받는 게 기본이고, 사용자가 대화창에 붙여넣어도 그대로 받는다.
   "붙여넣지 마세요" 라고 하지 않는다. 받는 방법은 `next` 스킬의 "비밀 키 받기".

## 범위 고르기

계정 4개를 한 번에 만들면 처음 하는 사람은 여기서 지쳐 나간다.
**기본 순서는 "로컬에서 먼저 만들어 보고, 배포할 때 계정을 만든다"** 이다.
범위는 사용자에게 고르게 하지 않는다. 진행상황.md 의 "다음 할 일" 이나 `next` 스킬이 부른 범위대로 한다.
사용자가 직접 말하면 (예: "전부 준비할래") 그대로 따른다.

| 사용자가 이렇게 말하면 | 하는 것 | 끝나면 |
|---|---|---|
| `/start local`, "지금은 Node만", "계정은 나중에" | 0~1단계 (node·git) | 기획으로 이어간다. 계정 이야기는 꺼내지 않는다 |
| `/start deploy`, "배포하려고" | 5단계 (GitHub 계정 + gh 설치·로그인 + Vercel) | 첫 배포로 이어간다 |
| `/start accounts`, "로그인·결제 붙이려고" | GitHub 계정 확인(5-1) + 2~4단계 (Supabase·Google·토스) + 6단계 | 데이터베이스 붙이기(`build`)로 이어간다 |
| `/start` 만 치고 범위를 말하지 않음 | 진행상황.md 기준 다음 범위. 기록이 없으면 local | 그 범위대로 |
| "전부", "다 준비할래" | 0~6단계 전체 | 기획으로 이어간다 |

이어갈 때는 명령어를 알려주지 않고 "이어서 할까요?" 만 묻는다 (`next` 스킬 "단계가 끝나면 다음 단계로 바로 간다").
범위를 좁혀 돌린 경우 완료 확인도 그 범위만 본다. 로컬만이면 `node --version` 이 20 이상이면 끝이다.

## 절차

### 0단계. 지금 어디까지 돼 있는지 확인

사용자에게 묻지 않고 **Claude가 확인한다.** 이미 된 것은 건너뛴다.

```bash
node --version; git --version; gh --version; gh auth status
grep -o '^[A-Z_]*=.' .env.local 2>/dev/null   # 어떤 키가 이미 채워졌는지 (값은 안 보임)
```

Supabase MCP가 붙어 있으면 `list_projects` 로 이미 만든 프로젝트가 있는지도 본다.
계정이 있는지는 가입 단계에서 사이트를 열어보면 알 수 있으니 미리 묻지 않는다.

작업 폴더가 없으면 만들고 `git init`까지 해둔다.

사용자에게는 오늘 할 일을 한 줄로만 말하고 바로 시작한다. "먼저 개발 도구를 설치할게요. 계정은 나중에 필요할 때 만들어요."

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
- git 이름·이메일이 비어 있으면 **묻지 않고** 임시로 넣어둔다. 커밋에 찍히는 값이고 서비스에 보이지 않는다.
  GitHub에 로그인한 뒤(5-3) GitHub 계정 값으로 바꾼다.

```bash
git config --global user.name >/dev/null || git config --global user.name "$(id -F 2>/dev/null || whoami)"
git config --global user.email >/dev/null || git config --global user.email "$(whoami)@users.noreply.github.com"
```

### 2단계. Supabase (데이터베이스와 로그인)

**사용자가 할 일은 가입과 연결 허용뿐이다.** 프로젝트 생성·지역 선택·키 복사는 Claude가 Supabase MCP로 한다.

먼저 `.gitignore` 에 `.env*` 가 있는지 확인하고 없으면 넣는다 (6단계 참고). 이제부터 키를 파일에 쓴다.

#### 2-1. 가입 (사용자)

Supabase와 Vercel은 GitHub로 로그인한다. GitHub 계정이 없으면 5-1(가입)만 먼저 하고 온다.

Supabase 가입 페이지를 열어준다. `open "https://supabase.com/dashboard/sign-in"`

```
열린 페이지에서 [Continue with GitHub] 로 로그인해주세요.
조직(Organization)을 만들라고 나오면 이름은 아무거나, Type은 Personal, Plan은 Free 로 만들어주세요.
대시보드가 보이면 "했어" 라고 해주세요. 프로젝트는 제가 만들게요.
```

브라우저 조작이 되는 환경이면 조직 만들기도 Claude가 채운다. 사용자는 GitHub 로그인만 한다.

#### 2-2. Supabase MCP 연결

`build` 스킬의 "Supabase MCP 사용 규칙" → "연결" 절차를 **지금** 한다. 이후 모든 데이터베이스 일이 이 연결로 돌아간다.
아직 프로젝트가 없으니 터미널은 `project_ref` **없이** 연결한다 (그 절차에 적혀 있다).
새 세션을 열어야 하면 그 절차의 "새 세션으로 넘어갈 때" 대로 진행상황.md 를 먼저 갱신한다.

#### 2-3. 프로젝트 만들기 (Claude, MCP)

이미 쓸 프로젝트가 있으면 (`list_projects`) 그걸 쓰고 새로 만들지 않는다. 여러 개면 어느 것인지 한 번만 묻는다.

없으면 만든다. 사용자에게는 "데이터베이스를 만들고 있어요. 1~2분 걸려요." 한 줄만.

1. `list_organizations` 로 조직 ID를 얻는다. 여러 개면 묻는다.
2. `get_cost` (type `project`) → 무료(`$0`)인지 확인 → `confirm_cost`.
   무료가 아니면 (무료 프로젝트 2개를 이미 쓰는 중 등) 만들지 말고 사용자에게 비용과 이유를 말하고 묻는다.
3. `create_project`: 이름은 기획서의 서비스 이름(없으면 폴더 이름), **지역은 서울 `ap-northeast-2`**. 지역은 나중에 못 바꾼다.
   데이터베이스 비밀번호는 Supabase가 정한다. 앱 코드에서 쓰지 않으므로 사용자에게 받거나 보여주지 않는다.
4. `get_project` 로 상태가 `ACTIVE_HEALTHY` 가 될 때까지 기다린다.

#### 2-4. 키 받기

| 값 | 어디에 | 받는 방법 |
|---|---|---|
| Project URL | `NEXT_PUBLIC_SUPABASE_URL` | MCP `get_project_url` |
| Publishable key (`sb_publishable_...`) | `NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY` | MCP `get_publishable_keys` |
| Secret key (`sb_secret_...`) | `SUPABASE_SECRET_KEY` | MCP로는 안 나온다. 아래 |

앞의 둘은 Claude가 바로 `.env.local` 에 쓴다. `anon` 같은 레거시 키 말고 `sb_publishable_` 로 시작하는 것을 쓴다.

Secret key 는 키 페이지를 열고 복사 버튼만 누르게 한 뒤 클립보드로 받는다 (`next` 스킬 "비밀 키 받기", 접두사 `sb_secret_`).

```bash
open "https://supabase.com/dashboard/project/<프로젝트ID>/settings/api-keys"
```

```
열린 페이지의 Secret keys 칸에서 복사 버튼을 누르고 "했어" 라고 해주세요. (대화창에 붙여넣으셔도 돼요)
```

Secret key 가 하나도 없으면 같은 페이지의 **New secret key** 로 하나 만들고 복사하게 한다.

이것으로 터미널에서 `project_ref` 없이 연결했던 MCP를 이 프로젝트로 묶는다.
`.mcp.json` 의 주소 끝에 `?project_ref=<프로젝트ID>` 를 붙여둔다. 다음 세션부터 적용되고, 지금 세션은 그대로 이어서 쓴다.

`NEXT_PUBLIC_`이 붙은 값은 브라우저로 전송된다. **`SUPABASE_SECRET_KEY`에는 절대 붙이지 않는다.**

### 3단계. Google Cloud (구글 로그인)

**Claude가 브라우저를 조작해서 한다.** 사용자는 그 브라우저에서 Google·Supabase에 로그인만 한다.
(클로드 데스크탑은 앱의 내장 브라우저, 터미널은 `agent-browser --headed`. `next` 스킬 "할 일을 처리하는 순서" 2번)
사용자에게 미리 한 줄 말한다. "구글 로그인 설정은 제가 브라우저로 할게요. 로그인 화면이 나오면 로그인만 해주세요."

콜백 주소는 정해져 있어서 따로 복사하지 않는다. `https://<프로젝트ID>.supabase.co/auth/v1/callback`

1. [console.cloud.google.com](https://console.cloud.google.com) 에서 새 프로젝트를 만든다 (이름은 서비스 이름).
2. **Google Auth Platform**(예전 이름 OAuth consent screen) 시작: 앱 이름, 지원 이메일(로그인한 계정), Audience **External**, 연락처 이메일.
   이걸 먼저 해야 클라이언트를 만들 수 있다.
3. **Clients** → **Create client** → Application type **Web application** →
   **Authorized redirect URIs** 에 위 콜백 주소 → Create.
4. 나온 **Client ID** 와 **Client Secret** 을 Supabase **Authentication → Sign In / Providers → Google**
   (`https://supabase.com/dashboard/project/<프로젝트ID>/auth/providers`) 에 넣고 켜고 저장한다.

Client ID·Secret 은 Claude가 페이지에서 읽어 바로 Supabase 칸에 넣는다. 파일이나 대화에 남기지 않는다.
Google 키는 Supabase에 저장되므로 `.env.local` 에는 넣지 않는다.

**브라우저 조작이 안 되는 환경이면** 같은 순서를 외부 브라우저로 한다. 각 단계의 페이지를 Claude가 열고,
칸에 넣을 값을 한 줄씩 불러준다. 이 경로만 길다. 중간에 "거의 다 왔어요" 같은 말을 넣는다.
Client ID·Secret 은 사용자가 대화창에 붙여넣게 하고 Claude가 받아서 다음 칸을 안내한다.

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

가입은 사용자만 할 수 있다. 가입 페이지를 열어준다. `open "https://developers.tosspayments.com"`
**이메일만으로** 가입한다. 사업자등록번호는 묻지 않는다. 가입하면 "개발 연동 체험 상점"이 생긴다.

키는 개발자센터 → API 키 → **API 개별 연동 키** 에 있다. 그 페이지를 열고 복사 버튼을 하나씩 누르게 해서
클립보드로 받는다 (`next` 스킬 "비밀 키 받기", 접두사 `test_ck_` 와 `test_sk_`). 대화창에 붙여넣어도 받는다.

| 값 | 어디에 |
|---|---|
| 테스트 클라이언트 키 (`test_ck_...`) | `NEXT_PUBLIC_TOSS_CLIENT_KEY` |
| 테스트 시크릿 키 (`test_sk_...`) | `TOSS_SECRET_KEY` |

구독의 자동결제(빌링)는 이 `ck`/`sk` 키를 쓴다. 이 키로는 결제 내역과 웹훅까지 내 계정에서 된다.

어느 쪽이든 키가 `test_` 로 시작하는지 확인시킨다. `live_` 는 실제 돈이 나간다.

### 5단계. GitHub 연결과 Vercel (배포 준비)

#### 5-1. GitHub 계정

가입은 사용자만 할 수 있다. `gh auth status` 로 이미 로그인돼 있으면 건너뛴다.
아니면 가입 페이지를 열어준다. `open "https://github.com/signup"`
"계정이 이미 있으면 이 페이지는 닫으셔도 돼요" 라고 같이 말한다. 로그인은 5-3에서 Claude가 이어서 한다.

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

`gh auth login` 을 그냥 돌리면 질문 4개를 주고받아야 한다. 질문 없이 돌리고, 사용자는 브라우저에서 코드 붙여넣기와 허용만 한다.
로그인을 기다리는 명령이라 **백그라운드로** 돌린다.

```bash
gh auth login --hostname github.com --git-protocol https --web --clipboard --skip-ssh-key
```

- 8자리 코드가 출력되고 클립보드에 복사된다. (`--clipboard` 를 모르는 옛 gh면 그 옵션만 빼고 다시 돌리고, 출력의 코드를 사용자에게 보여준다)
- 브라우저가 안 열렸으면 Claude가 연다. `open "https://github.com/login/device"`

```
열린 GitHub 페이지에서 코드 칸에 붙여넣기(Cmd+V)를 하고, Continue → Authorize 를 눌러주세요.
```

끝나면 git이 GitHub 로그인을 쓰게 하고, 임시로 넣었던 git 이름·이메일을 GitHub 값으로 바꾼다.

```bash
gh auth status
gh auth setup-git
git config --global user.name "$(gh api user --jq '.name // .login')"
git config --global user.email "$(gh api user --jq '"\(.id)+\(.login)@users.noreply.github.com"')"
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

Vercel CLI를 설치하고 로그인까지 Claude가 돌린다. 1단계에서 node를 홈 폴더에 깔았으므로 관리자 비밀번호 없이 설치된다.

```bash
npm install -g vercel
vercel whoami || vercel login
```

`npm install -g` 가 권한 오류(`EACCES`)로 실패하면 (node를 홈 폴더가 아닌 곳에 깔아둔 컴퓨터) 설치하지 말고 이후 `vercel` 대신 `npx vercel` 로 쓴다.

`vercel login` 은 로그인을 기다리므로 **백그라운드로** 돌리고, 출력된 주소를 Claude가 연다.
처음 쓰는 사람은 그 화면에서 계정이 만들어진다.

```
열린 Vercel 페이지에서 [Continue with GitHub] → 허용을 눌러주세요.
```

`vercel whoami` 에 아이디가 나오면 끝이다. 실제 배포는 `/publish` 에서 한다.

### 6단계. `.env.local` 확인

앞 단계에서 Claude가 값을 바로바로 써 왔다. 여기서는 빠진 줄이 없는지만 본다. 형태는 이렇다.

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

마지막으로 요약하고, 다음 단계로 이어간다 (`next` 스킬 "단계가 끝나면 다음 단계로 바로 간다").

```
준비 끝났습니다.
✅ Supabase  데이터베이스와 로그인
✅ Google    구글 로그인 연결
✅ 토스페이먼츠  결제 (테스트 키)
✅ GitHub    로그인
✅ Vercel    로그인 (배포는 나중에)

다음은 뭘 만들지 정하는 기획이에요. 이어서 할까요?
```

## 자주 막히는 곳

| 증상 | 원인과 답 |
|---|---|
| `node: command not found` (설치했는데도) | 터미널을 껐다 켜야 한다. 그래도 안 되면 `cat ~/.zshrc ~/.zprofile` 에 `.node/bin` 줄이 있는지 본다 |
| Mac에서 `curl` 이 실패한다 | 인터넷·회사 프록시 문제. 와이파이를 바꿔보고, 안 되면 그때만 [nodejs.org](https://nodejs.org) 설치 파일로 안내 |
| `xcode-select --install` 이 "이미 설치됨" | 이미 있는 것. `git --version` 으로 확인하고 넘어간다 |
| `gh: command not found` (설치했는데도) | 같은 이유. 껐다 켜기 |
| `gh auth login` 에서 브라우저가 안 열린다 | Claude가 `open https://github.com/login/device` 로 연다. 코드는 클립보드에 있다 |
| `vercel: command not found` (설치했는데도) | `export PATH="$HOME/.node/bin:$PATH"` 를 붙여 다시 돌린다 |
| Supabase MCP `create_project` 가 없다 | 터미널에서 `project_ref` 를 붙여 연결해서다. 2-2대로 `project_ref` 없이 다시 연결한다 |
| `get_cost` 가 무료가 아니다 | 무료 프로젝트 2개를 이미 쓰는 중. 안 쓰는 프로젝트를 정지(pause)할지 사용자에게 묻는다 |
| Supabase 지역을 서울 말고 다른 곳으로 만들었다 | 지역은 나중에 못 바꾼다. 아직 데이터가 없으면 프로젝트를 지우고 서울로 새로 만든다 |
| `get_publishable_keys` 에 `anon` 키만 나온다 | 레거시 키다. API Keys 페이지를 열어 새 publishable 키를 발급하게 한다 |
| 클립보드에서 키를 못 읽었다 (접두사 안 맞음) | 다른 걸 복사했다. 어느 칸의 복사 버튼인지 다시 짚어주거나, 대화창에 붙여넣어 달라고 한다 |
| Google에서 OAuth client 생성 버튼이 없다 | OAuth consent screen을 먼저 설정해야 한다 |
| 구글 로그인 시 `redirect_uri_mismatch` | Google의 Authorized redirect URIs와 Supabase 콜백 URL이 한 글자라도 다르다. 복사해서 붙여넣게 한다 |
| 토스 키가 `live_`로 시작한다 | 실결제 키다. 테스트 키로 바꾼다 |
| 토스에서 사업자등록번호를 요구한다 | 실결제 신청 화면으로 들어간 것이다. 개발자센터의 테스트 키 화면으로 돌아간다 |

## 다음

기획(`plan` 스킬). 범위를 좁혀 돌렸으면 진행상황.md 의 다음 단계. 명령어를 치라고 하지 않고 "이어서 할까요?" 만 묻는다.
