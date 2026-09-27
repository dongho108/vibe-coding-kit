---
name: publish
description: >
  만든 서비스를 세상에 내보내는 스킬. Vercel 배포, 환경변수 이전, 도메인 연결, 구글 로그인
  실주소 설정, 토스페이먼츠 결제 연동과 웹훅 등록, 실결제 전환은 `/live` 로 넘긴다.
  "배포", "출시", "올려줘", "ship", "도메인", "런칭", "실제로 돈 받고 싶어", "사업자등록"
  같은 말이나, 로컬에서 동작하는 것을 실제 URL로 내보내야 하는 모든 상황에서 사용한다.
---

# /publish 배포와 결제

## 이 스킬이 끝나면

배포된 URL이 있고, 거기서 구글 로그인이 되고, 테스트 결제가 승인까지 간다.
**사업자등록 없이 여기까지 온다.**

## 쓸 외부 스킬

| 스킬 | 언제 |
|---|---|
| `deploy-to-vercel` | 배포 |
| `vercel-cli-with-tokens` | 토큰으로 환경변수 넣고 배포 자동화 |
| `pay` | 결제 연동 |
| `agent-browser` | 배포된 사이트를 실제로 눌러보며 확인 |
| `webapp-testing` | 동작 점검 |

## 반드시 지킬 것

1. **먼저 배포하고 결제를 붙인다.** 순서를 바꾸지 마라.
   웹훅은 공개 URL이 있어야 등록된다.
2. **`.env.local` 을 그대로 올리지 않는다.** Vercel 대시보드나 CLI로 환경변수를 넣는다.
3. **테스트 키로 끝까지 확인한 다음에 실결제 이야기를 꺼낸다.**
   순서를 앞당기면 사용자가 여기서 멈춘다.

## 배포만 모드

사용자가 `/publish only`, "배포까지만", "주소만", "결제는 나중에" 라고 하면 **1~3단계에서 멈춘다.**
배포 주소를 알려주고 끝낸다. 4~6단계는 하지 않고, 결제를 붙이자고 제안하지도 않는다.

범위를 말하지 않았어도 코드 상태를 보고 판단한다.

- 프로젝트에 Supabase 로그인 코드가 없으면 4단계를 건너뛴다
- `.env.local` 에 토스 키가 없거나 결제 코드가 없으면 5단계를 건너뛰고, "결제는 `/pay` 로 붙인 뒤 `/publish` 를 다시 돌리면 됩니다" 한 줄만 남긴다
- 6단계 체크리스트는 실제로 붙어 있는 기능만 확인한다

## 절차

### 1단계. 배포

GitHub에 올리고 Vercel에 연결한다. `/start deploy` 에서 gh 로그인이 끝나 있어야 한다. 안 돼 있으면 거기로 돌려보낸다.

커밋하기 전에 비밀 키가 섞이지 않았는지 확인한다.

```bash
gh auth status
git check-ignore -q .env.local && echo "OK: .env.local 은 올라가지 않음"
git add -A
git diff --cached --name-only | grep -E '(^|/)\.env' | grep -v '\.env\.example$'
```

- `check-ignore` 에서 OK가 안 나오면 `.gitignore` 에 `.env*` 를 넣고 다시 한다.
- 마지막 줄에서 파일 이름이 하나라도 나오면 멈춘다. `git restore --staged <파일>` 로 빼고 이유를 사용자에게 말한다.
- `/build` 가 깔아둔 커밋 검사기가 있으면 커밋할 때 한 번 더 막아준다. 없으면(`.git/hooks/pre-commit`)
  `/build` 의 1단계대로 지금 깐다. 검사기에 걸리면 `--no-verify` 로 건너뛰지 않는다.

```bash
git commit -m "first"
gh repo create <폴더이름> --private --source=. --remote=origin --push
```

이미 원격 저장소가 있으면 `gh repo create` 대신 `git push` 만 한다. 저장소는 비공개(`--private`)로 만든다. 비밀 키가 실수로 올라가도 남이 못 본다.

**키가 이미 올라간 걸 발견하면** 파일을 지우고 다시 커밋하는 것으로는 부족하다. 커밋 기록에 남아 있다.
그 키를 발급한 곳에서 **새 키를 발급받고 옛 키는 폐기**한 뒤 `.env.local` 과 Vercel 환경변수를 새 값으로 바꾼다.

| 키 | 새로 발급하는 곳 |
|---|---|
| `SUPABASE_SECRET_KEY` | Supabase → Project Settings → API Keys |
| `TOSS_SECRET_KEY` | 토스페이먼츠 개발자센터 → API 키 |
| Vercel 토큰 | Vercel → Account Settings → Tokens |

Vercel에서 **Add New → Project** → 저장소 선택 → Import.

첫 배포는 환경변수가 없어서 실패할 수 있다. 정상이다. 다음 단계에서 채운다.

### 2단계. 환경변수

`.env.local` 의 값을 Vercel에 옮긴다. Production·Preview·Development 전부에 넣는다.

```bash
vercel env add NEXT_PUBLIC_SUPABASE_URL production
```

또는 대시보드의 **Settings → Environment Variables**.

**`NEXT_PUBLIC_` 이 안 붙은 값이 제대로 서버 전용인지 다시 본다.**
특히 `SUPABASE_SECRET_KEY` 와 `TOSS_SECRET_KEY`.

넣고 나서 재배포한다. 환경변수는 빌드 시점에 들어가므로 기존 배포에는 반영되지 않는다.

### 3단계. 도메인

Vercel이 준 `*.vercel.app` 주소로 계속 가도 된다. 사용자에게 먼저 물어본다.

```
도메인을 따로 사실 건가요? 없어도 지금 주소로 서비스할 수 있어요.
나중에 붙여도 되고요.
```

산다고 하면 Vercel의 **Domains** 에서 구매하거나, 외부에서 산 도메인의 네임서버를 Vercel로 돌린다.

### 4단계. 구글 로그인 실주소 등록

**로컬에서 되던 로그인이 배포하면 깨진다.** 주소가 바뀌었기 때문이다. 두 곳을 고친다.

1. **Supabase** → Authentication → URL Configuration
   - Site URL: 배포된 주소
   - Redirect URLs: 배포된 주소 + `/**`
2. **Google Cloud** → Credentials → OAuth client
   - Authorized redirect URIs에 Supabase 콜백 URL이 있는지 확인 (이건 안 바뀐다)

배포된 사이트에서 실제로 로그인해본다.

### 5단계. 결제

`pay` 스킬로 연동한다. 아직 안 붙였으면 여기서 붙인다.

붙인 뒤 **웹훅을 등록한다.** 이제 공개 URL이 있으니 가능하다.

토스 개발자센터 → 웹훅 → 배포된 주소의 웹훅 라우트를 등록한다.
`PAYMENT_STATUS_CHANGED`, `CANCEL_STATUS_CHANGED` 를 받는다. 가상계좌를 쓰면 `DEPOSIT_CALLBACK` 도.

**문서용 테스트 키(`test_gck_docs_...`)를 쓰는 중이면 건너뛴다.** 내 상점이 아니라 등록할 곳이 없다.
카드 결제는 승인 API 응답으로 확정되므로 웹훅 없이도 결제는 끝까지 된다.
"웹훅은 전자결제 신청 후 내 키로 바꿀 때 등록해요" 한 줄만 남긴다.

### 6단계. 실제로 눌러본다

`agent-browser` 로 배포된 사이트를 열어 처음부터 끝까지 해본다.

- 랜딩이 뜨는가
- 구글 로그인이 되는가
- 결제창이 뜨는가
- 테스트 결제가 승인되는가
- DB에 주문이 `paid` 로 남는가
- 모바일 폭에서 깨지지 않는가

**하나라도 안 되면 여기서 멈추고 고친다.** 다음 절로 넘어가지 마라.

## 완료 확인

배포만 모드면 "배포된 주소가 열린다" 하나만 본다.

배포된 사이트에서 로그인하고 테스트 결제가 승인까지 간다.

여기까지 오면 사용자에게 축하한다. 실제로 큰 일이다.

```
서비스가 살아 있습니다. (주소)

지금은 테스트 결제라 실제 돈은 오가지 않아요.
진짜로 돈을 받으려면 몇 가지 절차가 남았는데, 급하지 않으면 나중에 하셔도 됩니다.
```

## 실결제 전환

**이 스킬에서는 하지 않는다.** 사용자가 실제로 돈을 받고 싶다고 하면 `live` 스킬(`/live`)이 맡는다.
여기서는 완료 메시지 뒤에 한 줄만 남긴다.

```
진짜로 돈을 받고 싶어지면 /live 라고 치세요. 사업자등록부터 라이브 키까지 순서대로 안내해드려요.
```

## 자주 막히는 곳

| 증상 | 원인 |
|---|---|
| 배포는 됐는데 로그인이 안 된다 | Supabase Site URL / Redirect URLs가 로컬 주소 그대로다 |
| 환경변수를 넣었는데 반영이 안 된다 | 재배포해야 한다 |
| 로컬은 되는데 배포하면 500 | 서버 환경변수 누락. Vercel 로그를 본다 |
| 웹훅이 안 온다 | 등록한 URL이 로컬이거나, 라우트가 POST를 안 받는다. 문서용 테스트 키로는 원래 안 온다 |
| 빌드가 실패한다 | 타입 에러가 대부분이다. `npm run build` 를 로컬에서 먼저 돌려본다 |
| `gh repo create` 에서 로그인 오류 | `/start deploy` 로 돌아가 `gh auth login` |
| Vercel에서 저장소가 안 보인다 | Vercel의 GitHub 권한 화면에서 해당 저장소를 허용한다 |

## 다음

이제부터는 원하는 기능을 말로 하면 됩니다. "리뷰 기능 붙여줘", "버튼 색 바꿔줘"처럼요.
`/feature` 가 작은 수정은 바로 고치고, 큰 기능은 기획부터 차근차근 진행합니다. 끝나면 검증도 알아서 돌립니다.
