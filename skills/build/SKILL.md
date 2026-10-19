---
name: build
description: >
  프로젝트 뼈대를 세우는 스킬. Next.js 프로젝트를 만들고 폴더 구조를 잡고 Supabase를 연결한 뒤
  /plan에서 고른 프리셋에 맞는 데이터베이스 스키마와 구글 로그인을 붙인다. 기능 구현은 하지 않는다.
  "프로젝트 만들어줘", "스택", "셋업", "stack", "DB 만들어줘", "뼈대", "테이블", "로그인 붙여줘"
  같은 말이나, 기획이 끝나고 실제 코드베이스를 시작해야 하는 상황에서 사용한다.
---

# /build 스택 셋업

## 진행 기록

시작할 때 `.claude/worklog/진행상황.md` 를 읽고 (없으면 만들고), **단계 하나를 끝낼 때마다** 고친다.
형식과 규칙은 `next` 스킬의 "작업 기록 파일" 을 따른다. 이미 "정해진 것" 에 있는 선택은 다시 묻지 않는다.

## 경계

**기능 구현은 하지 않는다.** 여기까지가 이 스킬의 범위다.

| 한다 | 안 한다 |
|---|---|
| Next.js 프로젝트 생성 | 화면별 기능 로직 |
| 폴더 구조 | 결제 연동 (`/pay`) |
| Supabase 연결과 스키마 | 배포 (`/publish`) |
| 구글 로그인 | 디자인 (`/design`) |

실제 기능은 클로드 기본 능력과 같이 설치된 외부 스킬이 맡는다.
이 경계를 넘지 마라. 넘기 시작하면 이 스킬이 감당 못 할 크기가 된다.

## 로컬 모드 (Supabase 계정이 아직 없을 때)

다음 중 하나면 로컬 모드로 간다.

- `.env.local` 이 없거나 `NEXT_PUBLIC_SUPABASE_URL` 이 비어 있다
- 사용자가 `/build local`, "로컬만", "Supabase 없이", "일단 화면부터" 라고 했다

로컬 모드에서 하는 것은 **1단계(Next.js 프로젝트)** 와 **임시 데이터**뿐이다.

1. `npx create-next-app@latest . --typescript --tailwind --app --eslint`
   이어서 1단계의 **커밋 검사기**도 깐다.
2. 기획서의 "저장할 것들"을 읽고 프리셋에 맞는 임시 데이터 파일을 만든다.
   - 단건: `data/products.ts` (상품 2~3개. 이름·가격·설명·사진)
   - 구독: `data/plans.ts`
   - 예약: `data/slots.ts` (클래스·공간 사진이 있으면 같이)
   화면은 이 파일을 import해서 쓴다. 데이터베이스는 아직 없다고 사용자에게 한 줄로 말해준다.
   **사진은 비워두지 말고 아래 "임시 사진 넣기"대로 고화질 사진을 받아 넣는다.**
   회색 빈 칸만 있는 화면으로는 디자인이 어떤지 판단할 수 없다.
3. `npm run dev` 로 첫 페이지가 뜨는 것까지 확인한다.

Supabase 연결·스키마·로그인(2~4단계)은 하지 않는다. 계정을 만들라고 하지도 않는다.
끝나면 이렇게 안내한다.

```
프로젝트가 생겼어요. 데이터는 지금 파일에 임시로 넣어뒀고, 나중에 데이터베이스로 옮깁니다.
다음은 화면 디자인이에요. 이어서 할까요?
```

"네" 면 `design` 스킬을 바로 시작한다 (`next` 스킬 "단계가 끝나면 다음 단계로 바로 간다").

### 임시 사진 넣기

상품 하나에 사진 2장씩 넣는다. (기본 디자인의 상품 카드는 마우스를 올리면 두 번째 사진으로 바뀐다)

**출처는 Unsplash의 무료 사진만 쓴다.** 상업적으로 써도 되고 출처 표기도 필요 없다.
구글 이미지 검색 결과나 다른 쇼핑몰의 상품 사진은 저작권이 있으니 절대 쓰지 않는다.
Unsplash+ (유료) 사진이 섞이지 않게 검색 주소에 `?license=free` 를 붙인다.

1. 상품마다 영어 검색어를 정한다. 상품 자체가 보이는 단순한 사진이 좋다.
   ("핸드메이드 머그컵" → `ceramic mug`, "요가 클래스" → `yoga class studio`)
2. **WebFetch** 로 `https://unsplash.com/s/photos/<검색어>?license=free` 를 열어
   `https://images.unsplash.com/photo-...` 로 시작하는 사진 주소와 설명(alt)을 받는다.
   unsplash.com 페이지는 curl과 `agent-browser` 로는 봇 차단에 막힌다. WebFetch로 연다.
3. 정사각형 1600px로 잘라 받는다. `images.unsplash.com` 은 curl로 바로 받아진다.

   ```bash
   mkdir -p public/images/products
   curl -fL -o public/images/products/<상품-slug>-1.jpg \
     "https://images.unsplash.com/photo-XXXX?w=1600&h=1600&fit=crop&q=80&fm=jpg"
   ```

4. 받은 사진을 **Read로 열어 직접 눈으로 본다.** 상품과 맞는지, 글자·워터마크·사람 얼굴이 크게 없는지,
   상품이 가운데 잘 잘렸는지 확인하고, 아니면 다른 사진으로 바꾼다.
   한 상품의 사진 2장은 같은 물건처럼 보이면 가장 좋다. 안 되면 같은 색감으로 맞춘다.
5. 데이터 파일에는 `images: ["/images/products/<상품-slug>-1.jpg", ...]` 처럼 로컬 경로로 넣는다.
   다른 사이트 주소로 걸지 않으니 `next.config` 설정이 필요 없고, 사진이 사라질 일도 없다.
6. `data/image-sources.md` 에 파일 이름과 Unsplash 원본 주소를 한 줄씩 적어둔다. (`public/` 에 두면 인터넷에 그대로 공개되니 피한다)

인터넷이 안 되거나 맞는 사진을 못 찾으면 그 상품만 빈 칸으로 두고 사용자에게 말한다.

끝나면 이렇게 한 줄 덧붙인다.

```
상품 사진은 무료 사진으로 임시로 넣어뒀어요. 실제로 팔 때는 직접 찍은 사진으로 바꿔주세요.
```

### 로컬 모드에서 전체 모드로 이어서 돌릴 때

Next.js 프로젝트가 이미 있고 `.env.local` 에 Supabase 값이 채워져 있으면 1단계는 건너뛰고 2단계부터 간다.
3단계 스키마를 만든 뒤 `data/*.ts` 의 임시 데이터를 seed 마이그레이션으로 옮기고
(사진은 `public/images/` 에 그대로 두고 경로만 `images` 컬럼에 넣는다),
화면의 import를 Supabase 조회로 바꾼다. 임시 파일은 옮긴 뒤 지운다.

## 쓸 외부 스킬

| 스킬 | 언제 |
|---|---|
| `supabase` | 연결·인증·RLS 전반. **Supabase는 자주 바뀌므로 반드시 이 스킬을 통해 현재 문서를 확인한다** |
| `supabase-postgres-best-practices` | 테이블 설계 |
| `react-best-practices`, `composition-patterns` | 폴더 구조와 컴포넌트 경계 |
| `next-dev-loop` | 개발 서버 굴리며 확인 |
| `nextjs-best-practices` | **1단계 직후 반드시 읽는다.** 서버/클라이언트 컴포넌트 구분, 데이터 가져오기, 라우팅 원칙 |
| `nextjs-developer` | App Router 구조·layout·loading/error 경계·서버 액션 등 실제 파일을 만들 때 |
| `nextjs-supabase-auth` | 4단계 구글 로그인. Supabase Auth + App Router 미들웨어·콜백 패턴 |

## 반드시 지킬 것

1. **모든 테이블에 RLS를 켠다.** 예외 없다.
   Supabase에서 RLS 없는 테이블은 공개 API로 그대로 노출된다.
   `supabase` 스킬의 보안 체크리스트를 반드시 읽고 따른다.
2. **`SUPABASE_SECRET_KEY` 에 `NEXT_PUBLIC_` 을 붙이지 않는다.** 붙으면 브라우저로 새어나간다.
3. **스키마는 기획서의 프리셋에서 나온다.** 사용자에게 테이블 설계를 묻지 마라.
4. **마이그레이션 파일로 남긴다.** 대시보드에서 손으로 만들지 않는다. 나중에 재현이 안 된다.
5. **데이터베이스 일은 Supabase MCP로 한다.** 아래 "Supabase MCP 사용 규칙"을 따른다.
   `/feature`·`/pay`·`/live` 도 이 규칙을 그대로 쓴다.

## Supabase MCP 사용 규칙

대시보드를 사람이 눌러보게 하는 대신 Claude가 MCP로 직접 한다.
도구 이름이 아래와 조금 다르면 같은 일을 하는 도구를 쓴다.

### 사용 환경: 터미널인지 클로드 데스크탑인지

사용자는 터미널의 Claude Code가 아니라 **클로드 데스크탑 앱의 Code 탭**에서 이 키트를 쓰고 있을 수 있다.
둘은 MCP를 붙이는 방법 자체가 다르다. 터미널 기준으로만 안내하면 데스크탑 사용자는 엉뚱한 화면을 보고 막힌다.

- MCP 연결처럼 화면 조작을 시켜야 하는 순간, 어느 쪽인지 모르면 **한 번만** 묻는다.
  "지금 까만 터미널 창에서 쓰고 계세요, 아니면 클로드 앱(데스크탑)에서 쓰고 계세요?"
- 답을 알면 그쪽 안내만 한다. 두 가지를 한꺼번에 늘어놓지 않는다.
- 명령어가 필요하면 **Claude가 직접 실행한다.** 사용자에게 터미널을 열어 치라고 하지 않는다.
- 아래와 다른 화면이 보인다고 하면 추측하지 말고 보이는 화면을 물어본 뒤 안내한다.

**터미널**: 프로젝트 폴더의 `.mcp.json` 에 Supabase를 넣고 `/mcp` 로 로그인한다. 아래 "연결" 의 터미널 절차.

**클로드 데스크탑**: `/mcp` 를 치면 **설정 → 커넥터** 화면이 뜬다. Supabase는 목록에 바로 떠 있지 않고 **검색해야 나온다.**
그래서 `.mcp.json` 대신 이 화면에서 **Supabase 커넥터**를 추가한다. 아래 "연결" 의 데스크탑 절차.

### 연결 (처음 쓸 때 한 번)

**Supabase는 기본으로 MCP로 다룬다.** 대시보드를 사용자에게 눌러보게 하지 않는다.
보통 `/start` 의 Supabase 단계에서 연결한다. Supabase 프로젝트 생성부터 MCP로 하기 때문이다.
`/build`·`/feature`·`/pay`·`/live` 에서 MCP 도구가 안 보이면 그 자리에서 이 절차로 연결한다.
사용자에게 한 줄로 설명한다. "클로드가 데이터베이스를 직접 만들고 확인할 수 있게 연결할게요."

프로젝트 ID는 `.env.local` 의 `NEXT_PUBLIC_SUPABASE_URL` (`https://<프로젝트ID>.supabase.co`) 에서 읽는다.
아직 Supabase 프로젝트가 없으면 (`.env.local` 에 값이 없음) 프로젝트 ID 없이 연결한다. 프로젝트를 MCP로 만들어야 하기 때문이다.

#### 터미널

1. 프로젝트 폴더에서 연결한다. Claude가 직접 실행한다.
   **프로젝트가 있으면 그 하나로 묶는다** (`project_ref`). 다른 Supabase 프로젝트가 있는 사람도 엉뚱한 데이터베이스를 건드리지 않게 하는 안전장치다.

   ```bash
   claude mcp add --scope project --transport http supabase "https://mcp.supabase.com/mcp?project_ref=<프로젝트ID>"
   ```

   **프로젝트가 아직 없으면** `project_ref` 없이 연결한다. 묶여 있으면 `create_project` 같은 계정 단위 도구가 안 보인다.
   `/start` 가 프로젝트를 만든 뒤 `.mcp.json` 주소에 `?project_ref=<프로젝트ID>` 를 붙인다. 그 전까지는 도구를 쓸 때마다 프로젝트 ID를 직접 넘긴다.

   ```bash
   claude mcp add --scope project --transport http supabase "https://mcp.supabase.com/mcp"
   ```

2. `.mcp.json` 에 추가된 서버는 **새 세션을 열어야 잡힌다.** 지금 세션에서 supabase 도구가 안 보이면
   아래 "새 세션으로 넘어갈 때" 를 먼저 한다.
3. 로그인은 사용자만 할 수 있다. `/mcp` → 방향키로 supabase 선택 → Enter → **Authenticate** → 브라우저에서 허용하게 한다.
4. `get_project_url` 이 `.env.local` 과 같은 주소를 돌려주면 연결된 것이다. 프로젝트가 아직 없으면 `list_organizations` 가 답하면 된다.

`.mcp.json` 에는 주소만 들어가고 로그인 정보는 없다. 커밋해도 된다.

#### 클로드 데스크탑

`claude mcp add` 는 쓰지 않는다. 사용자에게 아래를 한 줄씩 그대로 안내한다.

```
1. 입력창에 /mcp 를 치세요. "커넥터" 화면이 열려요.
2. 위쪽의 "내 항목 / 탐색" 중 [탐색] 을 누르세요.
3. 오른쪽 위 검색창에 supabase 라고 치세요. 목록에 바로 안 보여서 검색해야 나와요.
4. 초록색 번개 모양, 이름 옆에 인증 표시가 있고 "제작: Supabase" 라고 적힌 카드의 [+] 를 누르세요.
5. 브라우저가 열리면 Supabase에 로그인하고 허용을 누르세요.
```

- 검색 결과에는 이름이나 설명에 Supabase가 들어간 **다른 회사 커넥터**(`커뮤니티` 표시)도 같이 나온다. **`제작: Supabase` 인 것만** 고르게 한다.
- 이미 추가돼 있으면 **내 항목** 탭에 Supabase가 있다. 연결이 끊겨 있으면 거기서 다시 연결하게 한다.
- 커넥터는 이 폴더가 아니라 **계정 전체**에 붙는다. `project_ref` 로 묶는 안전장치가 없으므로
  데이터베이스 도구를 쓸 때마다 **`.env.local` 의 프로젝트 ID를 직접 넘기고**, 첫 호출에서 프로젝트 목록이나 주소를 보고
  `.env.local` 과 같은 프로젝트인지 확인한다. 다르거나 여러 개 중 헷갈리면 사용자에게 묻는다.
- 추가한 뒤에도 지금 세션에 Supabase 도구가 안 보이면 아래 "새 세션으로 넘어갈 때" 를 한다.
- 프로젝트 주소가 `.env.local` 과 같게 나오면 연결된 것이다. 프로젝트가 아직 없으면 `list_organizations` 가 답하면 된다.

### 새 세션으로 넘어갈 때

새 세션을 열면 지금까지 나눈 대화는 넘어가지 않는다. 사용자가 이미 답한 걸 다시 묻거나 처음부터 다시 하지 않게,
**새 세션을 열라고 말하기 전에** 진행 상황을 적어둔다.

1. 작업 기록 `.claude/worklog/진행상황.md` 를 갱신한다 (`next` 스킬의 "작업 기록 파일" 규칙).
   새 세션은 `.claude/CLAUDE.md` 를 통해 이 파일을 자동으로 읽는다. 터미널이든 데스크탑이든 같다. "지금" 절을 이렇게 채운다.

   ```markdown
   ## 지금

   - 하는 중: /build 2단계 Supabase 연결 (MCP 연결 때문에 세션을 새로 열었음)
   - 다음 할 일: Supabase MCP 도구가 보이는지 확인 → 안 보이면 `build` 스킬 "연결" 의 사용 환경별 절차로 안내 →
     `.env.local` 과 같은 프로젝트인지 확인 → 2단계의 npm install부터
   - 하다 만 것: Supabase 커넥터 추가까지 함 (터미널이면 .mcp.json 에 추가까지)
   - 사용 환경: 클로드 데스크탑
   ```

   "정해진 것" 에 사용자가 이미 답한 선택이 빠져 있으면 같이 채운다.
   내용은 예시다. 실제로 하던 명령·단계 번호를 **구체적으로** 적는다. "구글 로그인 붙이는 중" 이 아니라 "4단계 콜백 라우트까지 만듦, 로그아웃 아직" 처럼.
2. 사용자 환경에 맞는 쪽 하나만 그대로 말해준다.

   터미널:

   ```
   데이터베이스 연결을 마무리하려면 클로드를 한 번 새로 열어야 해요.
   지금까지 한 건 적어뒀으니 처음부터 다시 안 하셔도 돼요.
   1. /exit 를 쳐서 나간 뒤, 같은 폴더에서 claude 를 다시 실행하세요.
   2. supabase 서버를 쓸지 물어보면 허용을 고르세요.
   3. "이어서 해줘" 라고 치세요. 로그인은 제가 이어서 안내할게요.
   ```

   클로드 데스크탑:

   ```
   데이터베이스 연결을 마무리하려면 새 대화를 한 번 열어야 해요.
   지금까지 한 건 적어뒀으니 처음부터 다시 안 하셔도 돼요.
   1. Cmd+N (Windows는 Ctrl+N) 으로 새 세션을 열고, 지금과 같은 프로젝트 폴더를 고르세요.
   2. "이어서 해줘" 라고 치세요. 연결이 안 됐으면 제가 이어서 안내할게요.
   ```

3. 새 세션에서 "이어서 해줘" 를 받으면 `next` 스킬이 작업 기록을 읽고 MCP 연결을 확인한 뒤 적힌 단계부터 이어간다.
   연결이 확인되면 "지금" 의 MCP 관련 내용을 지우고 평소처럼 갱신한다.

`/feature`·`/pay`·`/live` 에서 처음 연결하다 새 세션으로 넘어갈 때도 같은 절차를 따른다.

### 규칙

| 할 일 | 도구 | 규칙 |
|---|---|---|
| 현재 문서 확인 | `search_docs` | Supabase는 자주 바뀐다. 코드·SQL을 쓰기 전에 기억 대신 먼저 찾는다 |
| 테이블 만들기·바꾸기 | `apply_migration` | 스키마 변경은 **이것으로만** 한다. 같은 SQL을 `supabase/migrations/<YYYYMMDDHHMMSS>_<이름>.sql` 로 저장소에도 남긴다 |
| 적용 기록 확인 | `list_migrations` | 저장소의 마이그레이션 파일과 개수·이름이 맞는지 본다 |
| 구조 확인 | `list_tables` | 테이블·컬럼이 의도대로 생겼는지, RLS가 켜져 있는지 |
| 보안·성능 점검 | `get_advisors` | **스키마를 바꿀 때마다** security와 performance 둘 다 돌린다. 경고가 남아 있으면 끝내지 않는다 |
| 타입 만들기 | `generate_typescript_types` | 스키마를 바꿀 때마다 `lib/supabase/database.types.ts` 로 저장하고, Supabase 클라이언트에 타입을 붙인다 |
| 데이터 조회 | `execute_sql` | **읽기(SELECT)만.** 동작 확인용 |
| 오류 추적 | `query_logs` | 로그인·결제·API가 실패하면 추측하기 전에 로그부터 본다 |

**데이터를 지우거나 고치는 일은 반드시 사용자에게 묻고 한다.** `execute_sql` 로 `DELETE`·`UPDATE`·`DROP`·`TRUNCATE` 를
바로 돌리지 않는다. 실제 주문과 회원 정보가 쌓인 뒤에는 되돌릴 수 없다. 스키마 변경은 `apply_migration` 으로만 한다.

**쓰고 있는 테이블·컬럼은 지우거나 이름을 바꾸지 않는다.** 데이터베이스는 내 컴퓨터와 실제 사이트가 같이 쓴다.
마이그레이션은 적용하는 순간 실제 사이트에도 반영되므로, 새 코드가 배포되기 전의 사이트가 깨진다.
컬럼·테이블은 **추가만** 하고, 지우는 일은 새 코드가 배포된 다음 따로 한다.

## 절차

### 0단계. 기획서 읽기

`docs/기획서.md` 맨 위의 `프리셋:` 값을 읽는다. 없으면 `/plan` 을 먼저 돌리라고 안내한다.

### 1단계. Next.js 프로젝트

```bash
npx create-next-app@latest . --typescript --tailwind --app --eslint
```

이미 폴더에 `.env.local` 이 있으면 덮어쓰지 않게 주의한다. `/start` 에서 만든 것이다.

프로젝트가 생기면 바로 **커밋 검사기**를 깐다. 비밀 키나 `.env` 파일이 커밋에 섞이면 커밋을 막는다.
Claude가 커밋하든 사용자가 직접 하든 항상 걸린다.

```bash
git rev-parse --git-dir >/dev/null 2>&1 || git init
cp "${CLAUDE_PLUGIN_ROOT}/skills/build/resources/pre-commit" "$(git rev-parse --git-dir)/hooks/pre-commit"
chmod +x "$(git rev-parse --git-dir)/hooks/pre-commit"
```

사용자에게 한 줄로 말해준다. "비밀 키가 실수로 GitHub에 올라가지 않게 커밋 검사기를 달아뒀어요."
검사기에 걸리면 **`--no-verify` 로 건너뛰지 마라.** 키를 `.env.local` 로 옮기고 다시 커밋한다.

프로젝트가 생기면 `nextjs-best-practices` 를 읽고 폴더 구조와 컴포넌트 경계를 그 원칙대로 잡는다. 파일을 실제로 만들 때는 `nextjs-developer` 의 App Router 패턴을 따른다. 로컬 모드에서도 같다.

### 2단계. Supabase 연결

먼저 Supabase MCP가 연결돼 있는지 본다. 없으면 위 "Supabase MCP 사용 규칙"의 **연결** 절차로 지금 연결한다.

```bash
npm install @supabase/supabase-js @supabase/ssr
```

클라이언트를 세 군데로 나눈다. 이게 Next.js App Router에서 Supabase를 쓰는 표준 형태다.

```
lib/supabase/client.ts     브라우저용 (createBrowserClient)
lib/supabase/server.ts     서버 컴포넌트·라우트 핸들러용 (createServerClient)
middleware.ts              세션 갱신
```

**구체적인 코드는 `supabase` 스킬을 통해 현재 문서를 확인하고 쓴다.**
`@supabase/ssr` 의 쿠키 처리 방식은 자주 바뀌었다. 기억에 의존하지 마라.

### 3단계. 스키마

프리셋에 따라 만든다. 아래는 뼈대이고, 기획서의 "저장할 것들"에 맞춰 컬럼을 더한다.

공통으로 `auth.users` 를 참조하는 `profiles` 를 둔다.

**`단건`**
```
profiles     id(auth.users 참조), email, name, created_at
products     id, name, description, price, images(text[]), active
orders       id, user_id, product_id, amount, status, toss_payment_key, toss_order_id, created_at
```

**`구독`**
```
profiles      id, email, name, created_at
plans         id, name, price, features, active
subscriptions id, user_id, plan_id, status, current_period_end, toss_billing_key, created_at
payments      id, subscription_id, amount, status, paid_at, toss_payment_key
```

**`예약`**
```
profiles     id, email, name, phone, created_at
slots        id, starts_at, capacity, price
bookings     id, user_id, slot_id, headcount, amount, status, toss_payment_key, created_at
```

`status` 는 문자열이 아니라 enum이나 check 제약으로 값을 제한한다.
결제 상태는 최소 `pending`, `paid`, `failed`, `cancelled` 를 갖는다.

`toss_payment_key` 같은 결제 컬럼을 지금 미리 넣어둔다. `/pay` 가 이 자리를 쓴다.

**모든 테이블에 RLS를 켜고 정책을 만든다.**
`profiles`, `orders`, `subscriptions`, `bookings` 는 본인 것만 보이게 한다.
`products`, `plans`, `slots` 는 누구나 읽을 수 있게 하되 쓰기는 막는다.

**RLS와 함께 GRANT도 같은 마이그레이션에 넣는다.** 2026-05-30 이후 만든 프로젝트는 새 테이블이 저절로 열리지 않는다
(2026-10-30부터는 예전 프로젝트도 같다). GRANT가 없으면 RLS를 맞게 짜도 앱에서 `42501 permission denied` 가 난다.
필요한 역할에 필요한 권한만 준다. 예: `products` 는 `grant select ... to anon, authenticated`,
`orders` 는 `grant select, insert ... to authenticated`. 서버에서 비밀 키로 쓰는 테이블은 `service_role` 에도 준다.
정확한 문법은 `search_docs` 로 "Securing your API" 를 확인한다.

`supabase` 스킬의 RLS 함정 목록을 반드시 확인한다. 특히 UPDATE 정책에 `USING` 과 `WITH CHECK` 를 둘 다 넣는 것,
`TO authenticated` 만으로는 남의 데이터가 보인다는 것.

**적용은 MCP로 한다.** 위 "Supabase MCP 사용 규칙" 순서 그대로:

1. `apply_migration` 으로 테이블·GRANT·RLS 정책을 적용하고, 같은 SQL을 `supabase/migrations/` 에 저장한다.
2. `list_tables` 로 테이블과 RLS가 생겼는지 본다.
3. `get_advisors` (security, performance) 경고가 없을 때까지 고친다.
4. `generate_typescript_types` 로 `lib/supabase/database.types.ts` 를 만든다.

### 4단계. 구글 로그인

`nextjs-supabase-auth` 와 `supabase` 스킬을 같이 본다. 미들웨어·콜백 라우트 패턴은 전자, 현재 API는 후자를 따른다.

`/start` 에서 Supabase 대시보드에 Google Client ID/Secret을 이미 넣어뒀다. 코드만 붙인다.

- 로그인 버튼 (`signInWithOAuth` with `provider: 'google'`)
- 콜백 라우트 핸들러 (`app/auth/callback/route.ts`)
- 로그아웃
- 로그인한 사용자를 `profiles` 에 자동 생성 (트리거 또는 콜백에서)

**구체적인 코드는 `supabase` 스킬로 현재 문서를 확인하고 쓴다.**

### 5단계. 확인

```bash
npm run dev
```

- 페이지가 뜬다
- 구글 로그인이 실제로 된다
- 로그인 후 `profiles` 에 행이 생긴다

사용자에게 "데이터베이스를 보세요"라고 하지 않는다. Claude가 MCP로 직접 확인한다.

- `execute_sql` 로 `select id, email, created_at from profiles order by created_at desc limit 5` 를 조회해 방금 로그인한 계정이 있는지 본다.
- 로그인이 안 되면 `query_logs` 로 auth 로그를 먼저 본다.

## 완료 확인

로컬 모드면 첫 줄만 본다.

- `npm run dev` 로 페이지가 뜬다
- Supabase에 테이블이 실제로 만들어져 있고 전부 RLS가 켜져 있다 (`list_tables`)
- `get_advisors` security 경고가 없다
- `lib/supabase/database.types.ts` 가 현재 스키마와 맞다
- 구글 로그인이 동작하고 `profiles` 에 행이 생긴다
- 마이그레이션 파일이 저장소에 남아 있고, `list_migrations` 와 개수가 맞다

## 다음

`next` 스킬의 "단계가 끝나면 다음 단계로 바로 간다" 를 따른다. 명령어를 치라고 하지 않는다.

- 로컬 모드였으면 다음은 디자인(`design`).
- 데이터베이스·로그인까지 붙였으면 다음은 결제(`pay`), 그다음 최종 배포(`publish`).
