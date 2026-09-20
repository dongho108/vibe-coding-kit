---
name: start
description: >
  바이브 코딩 키트의 첫 단계. 서비스를 만들기 전에 필요한 개발 환경과 계정을 전부 준비한다.
  node·git 설치 확인, Vercel·Supabase·토스페이먼츠·Google Cloud 계정 생성 안내,
  API 키 발급, .env.local 작성, Supabase MCP 연결까지 처리한다.
  "시작", "처음", "setup", "환경 설정", "계정 만들기", "키 받아야 해", "뭐부터 해야 해",
  "개발 환경", "세팅" 같은 말이나, 아무 준비 없이 서비스를 만들려는 모든 요청에 트리거한다.
  코드는 한 줄도 쓰지 않는다. 준비물만 갖춘다.
---

# /start 환경과 계정

이 스킬은 **코딩 시작 전 준비물을 갖추는 단계**다. 코드는 쓰지 않는다.

사용자는 터미널을 처음 여는 사람이다. 명령어를 복붙할 줄만 안다고 가정한다.

## 반드시 지킬 것

1. **기술 선택을 묻지 않는다.** Next.js + Supabase + Vercel + 토스페이먼츠로 정해져 있다.
   "어떤 DB 쓰실래요" 같은 질문을 하지 마라. 초보는 답할 수 없고, 답하려다 이탈한다.

2. **사업자등록 이야기를 여기서 절대 꺼내지 않는다.**
   토스는 테스트 키만 받는다. 첫 단계에서 그 벽을 만나면 사용자는 돌아오지 않는다.
   실결제 전환은 `/publish`과 `docs/02-실결제-전환-체크리스트.md`가 다룬다.
   사용자가 먼저 물어보면 "지금은 신경 안 쓰셔도 돼요. 다 만들고 나서 `/publish`에서 알려드릴게요"라고만 답한다.

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
| `/start deploy`, "배포하려고" | GitHub 계정 확인 + 5단계 (Vercel) | `/publish` 안내 |
| `/start accounts`, "로그인·결제 붙이려고" | 2~4단계 (Supabase·Google·토스) + 6~7단계 | `/build` 다시 돌리라고 안내 |
| `/start` 만 치고 범위를 말하지 않음 | 아래 0단계 질문으로 고르게 한다 | 고른 범위대로 |
| "전부", "다 준비할래" | 0~7단계 전체 | `/plan` 안내 |

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

- `node`가 없거나 20 미만이면 설치를 안내한다. macOS는 [nodejs.org](https://nodejs.org) 의 LTS 버튼,
  Windows도 동일. **Homebrew나 nvm을 권하지 마라.** 초보에게는 설치 파일이 가장 확실하다.
- `git`이 없으면 macOS는 `xcode-select --install`, Windows는 [git-scm.com](https://git-scm.com).
- 설치 후 **터미널을 껐다 켜야 인식된다.** 이 말을 반드시 해준다. 여기서 가장 많이 막힌다.

GitHub 계정이 없으면 먼저 만든다. Vercel 로그인에 쓴다.

### 2단계. Supabase (데이터베이스와 로그인)

1. [supabase.com](https://supabase.com) → **Start your project** → GitHub로 로그인
2. **New project**
   - Name: 서비스 이름
   - Database Password: **생성 버튼을 눌러 만들고 반드시 따로 저장하게 한다.** 다시 못 본다.
   - Region: `Northeast Asia (Seoul)`
3. 프로젝트 생성에 1~2분 걸린다. 기다리는 동안 다음 설명을 해준다.
4. 왼쪽 아래 **Project Settings** → **API Keys**

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

[developers.tosspayments.com](https://developers.tosspayments.com) 에서 **이메일과 전화번호만으로** 가입한다.
**사업자등록번호는 필요 없다.** 가입하면 "개발 연동 체험 상점"이 생기고 테스트 키가 나온다.

받아올 값 2개:

| 값 | 어디에 |
|---|---|
| 테스트 클라이언트 키 (`test_gck_...`) | `NEXT_PUBLIC_TOSS_CLIENT_KEY` |
| 테스트 시크릿 키 (`test_gsk_...`) | `TOSS_SECRET_KEY` |

키가 `test_`로 시작하는지 확인시킨다. 결제위젯은 `gck`/`gsk`, API 개별연동은 `ck`/`sk`다.
우리는 결제위젯을 쓰므로 **`gck`/`gsk`를 받는다.**

> 가입조차 건너뛰고 싶어 하면 문서용 테스트 키로도 결제창은 뜬다.
> 다만 웹훅과 API 로그가 없어서 `/publish`에서 다시 해야 한다. 그러니 지금 가입하는 편이 낫다고 말해준다.

### 5단계. Vercel (배포)

[vercel.com](https://vercel.com) → GitHub로 로그인. 지금은 여기까지만 한다.
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

`.gitignore`에 `.env*.local`이 있는지 **반드시 확인한다.** 없으면 추가한다.
사용자에게 왜 중요한지 한 줄로 말해준다. "이게 없으면 비밀 키가 GitHub에 그대로 올라갑니다."

### 7단계. Supabase MCP 연결

클로드가 데이터베이스를 직접 보고 만질 수 있게 연결한다.

```bash
claude mcp add --scope project --transport http supabase "https://mcp.supabase.com/mcp"
```

그 다음 터미널에서 `/mcp` 를 치고 supabase를 선택해 **Authenticate**로 로그인한다.

프로젝트를 하나로 제한하고 싶으면 URL 뒤에 `?project_ref=<프로젝트ID>`를 붙인다.

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
✅ Vercel    배포 (계정만, 배포는 나중에)

이제 뭘 만들지 정할 차례예요. /plan 이라고 쳐주세요.
```

## 자주 막히는 곳

| 증상 | 원인과 답 |
|---|---|
| `node: command not found` (설치했는데도) | 터미널을 껐다 켜야 한다 |
| Supabase에 `anon` 키만 보인다 | 레거시 키다. API Keys에서 새 publishable 키를 발급 |
| Google에서 OAuth client 생성 버튼이 없다 | OAuth consent screen을 먼저 설정해야 한다 |
| 구글 로그인 시 `redirect_uri_mismatch` | Google의 Authorized redirect URIs와 Supabase 콜백 URL이 한 글자라도 다르다. 복사해서 붙여넣게 한다 |
| 토스 키가 `live_`로 시작한다 | 실결제 키다. 테스트 키로 바꾼다 |
| 토스에서 사업자등록번호를 요구한다 | 실결제 신청 화면으로 들어간 것이다. 개발자센터의 테스트 키 화면으로 돌아간다 |

## 다음

`/plan` 이라고 치세요.
