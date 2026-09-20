---
name: build
description: >
  프로젝트 뼈대를 세우는 스킬. Next.js 프로젝트를 만들고 폴더 구조를 잡고 Supabase를 연결한 뒤
  /plan에서 고른 프리셋에 맞는 데이터베이스 스키마와 구글 로그인을 붙인다. 기능 구현은 하지 않는다.
  "프로젝트 만들어줘", "스택", "셋업", "stack", "DB 만들어줘", "뼈대", "테이블", "로그인 붙여줘"
  같은 말이나, 기획이 끝나고 실제 코드베이스를 시작해야 하는 상황에서 사용한다.
---

# /build 스택 셋업

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
2. 기획서의 "저장할 것들"을 읽고 프리셋에 맞는 임시 데이터 파일을 만든다.
   - 단건: `data/products.ts` (상품 2~3개. 이름·가격·설명·이미지 자리)
   - 구독: `data/plans.ts`
   - 예약: `data/slots.ts`
   화면은 이 파일을 import해서 쓴다. 데이터베이스는 아직 없다고 사용자에게 한 줄로 말해준다.
3. `npm run dev` 로 첫 페이지가 뜨는 것까지 확인한다.

Supabase 연결·스키마·로그인(2~4단계)은 하지 않는다. 계정을 만들라고 하지도 않는다.
끝나면 이렇게 안내한다.

```
프로젝트가 생겼어요. 데이터는 지금 파일에 임시로 넣어뒀고, 나중에 데이터베이스로 옮깁니다.
다음은 화면을 만들 차례예요. /design 이라고 쳐주세요.
```

### 로컬 모드에서 전체 모드로 이어서 돌릴 때

Next.js 프로젝트가 이미 있고 `.env.local` 에 Supabase 값이 채워져 있으면 1단계는 건너뛰고 2단계부터 간다.
3단계 스키마를 만든 뒤 `data/*.ts` 의 임시 데이터를 seed 마이그레이션으로 옮기고,
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

## 절차

### 0단계. 기획서 읽기

`docs/기획서.md` 맨 위의 `프리셋:` 값을 읽는다. 없으면 `/plan` 을 먼저 돌리라고 안내한다.

### 1단계. Next.js 프로젝트

```bash
npx create-next-app@latest . --typescript --tailwind --app --eslint
```

이미 폴더에 `.env.local` 이 있으면 덮어쓰지 않게 주의한다. `/start` 에서 만든 것이다.

프로젝트가 생기면 `nextjs-best-practices` 를 읽고 폴더 구조와 컴포넌트 경계를 그 원칙대로 잡는다. 파일을 실제로 만들 때는 `nextjs-developer` 의 App Router 패턴을 따른다. 로컬 모드에서도 같다.

### 2단계. Supabase 연결

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
products     id, name, description, price, active
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

`supabase` 스킬의 RLS 함정 목록을 반드시 확인한다. 특히 UPDATE 정책에 `USING` 과 `WITH CHECK` 를 둘 다 넣는 것,
`TO authenticated` 만으로는 남의 데이터가 보인다는 것.

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

Supabase MCP로 테이블을 직접 조회해서 확인한다.

## 완료 확인

로컬 모드면 첫 줄만 본다.

- `npm run dev` 로 페이지가 뜬다
- Supabase에 테이블이 실제로 만들어져 있고 전부 RLS가 켜져 있다
- 구글 로그인이 동작하고 `profiles` 에 행이 생긴다
- 마이그레이션 파일이 저장소에 남아 있다

## 다음

로컬 모드였으면 `/design` 입니다.

이제 기능을 만들 차례입니다. 기획서의 화면을 하나씩 만들어달라고 하세요.
다 되면 `/publish` 이라고 치세요.
