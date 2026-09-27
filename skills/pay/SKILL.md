---
name: pay
description: >
  토스페이먼츠 결제를 Next.js 서비스에 붙이는 스킬. 토스페이먼츠가 AI용으로 낸 LLM Quick Reference 문서를 읽고
  그 규칙대로 주문서형 결제(옛 결제위젯), 결제 승인 API, 웹훅, 결제 실패·취소 처리를 만든다.
  단건·구독(자동결제 빌링)·예약 세 가지 흐름을 지원한다.
  "결제", "토스", "토스페이먼츠", "돈 받기", "결제창", "결제위젯", "정기결제", "구독 결제", "환불", "웹훅",
  "결제 붙여줘" 같은 말이나, 서비스에 결제를 붙여야 하는 모든 상황에서 사용한다.
---

# /pay 토스페이먼츠 연동

이 레포에서 **직접 만든 유일한 도메인 스킬**이다.
결제 지식은 이 파일이 아니라 **토스페이먼츠 공식 문서**가 기준이다. 이 파일은 순서와 우리 스택에 맞춘 규칙만 담는다.
이 파일과 공식 문서가 다르면 공식 문서를 따르고, 다르다는 걸 사용자에게 한 줄로 알린다.

## 0단계. 공식 문서부터 읽는다

코드를 쓰기 전에 반드시 한다. 결제 코드는 기억에 의존해 짜면 없는 필드를 지어내기 쉽다.

1. **LLM Quick Reference** 를 원문 그대로 받아 읽는다. 토스가 AI 에이전트용으로 만든 한 장짜리 요약이다.

   ```bash
   curl -sL https://docs.tosspayments.com/guides/v2/get-started/llms-quick-reference.md
   ```

   결제 흐름, 제품 고르는 규칙, 보안 규칙(§2 Critical), 자주 틀리는 패턴(§8 Common Mistakes)이 들어 있다.
2. 구현에 필요한 세부 내용은 **llms.txt** 에서 해당 페이지를 찾아 그 페이지 주소 끝에 `.md` 를 붙여 받는다.

   ```bash
   curl -sL https://docs.tosspayments.com/llms.txt
   curl -sL https://docs.tosspayments.com/guides/v2/payment-widget/integration.md   # 예: 주문서형 결제 전체 코드
   ```

   WebFetch는 요약을 거치며 필드 이름이 뭉개질 수 있다. 문서는 curl로 원문을 받는다.
   문서 검색은 한국어 제품명으로 한다 (`주문서형 결제`, `자동결제`). 영어 이름으로는 안 나온다.
3. (선택) 토스페이먼츠 MCP 서버를 연결해두면 다음 대화부터 Claude가 문서를 직접 검색한다.

   ```bash
   claude mcp add --scope project tosspayments-integration-guide -- npx -y @tosspayments/integration-guide-mcp@latest
   ```

**문서에 없는 필드는 만들지 않는다.** Stripe 같은 다른 결제사 이름(`payment_intent` 등)을 흉내 내지 않는다.
필드가 확실하지 않으면 문서를 다시 찾고, 그래도 없으면 사용자에게 묻는다.

코드를 다 쓰면 Quick Reference의 **§8 Common Mistakes 표와 한 줄씩 대조**하고 나서 끝낸다.

## 대전제: 테스트 키로 끝까지 간다

사용자는 **사업자등록 없이** 테스트 결제가 끝까지 도는 완성품을 오늘 갖는다.
테스트 키로는 실제 돈이 오가지 않는다.

**실결제 전환 이야기를 여기서 꺼내지 마라.** 사용자가 요청하면 `live` 스킬(`/live`)이 담당한다.

## 키: 프리셋마다 다르다

토스 키는 두 종류이고, 클라이언트 키와 시크릿 키는 **같은 종류끼리 한 세트**로 써야 한다.
섞으면 `INVALID_API_KEY` 가 난다.

| 프리셋 | 쓰는 제품 | 키 | 사업자등록 전에 쓸 키 |
|---|---|---|---|
| 단건, 예약 | 주문서형 결제 (옛 이름 결제위젯) | `gck` / `gsk` | **문서용 테스트 키** (아래) |
| 구독 | 자동결제(빌링) | `ck` / `sk` (API 개별 연동 키) | 개발자센터 가입 후 **내 체험 상점 테스트 키** |

**주문서형 결제의 내 키(`gck`/`gsk`)는 토스페이먼츠 전자결제 신청을 해야 개발자센터에 나온다.**
전자결제 신청에는 사업자등록이 필요하다. 그 전에는 토스 문서에 공개된 테스트 키로 연동한다.

```
NEXT_PUBLIC_TOSS_CLIENT_KEY=test_gck_docs_Ovk5rk1EwkEbP0W43n07xlzm
TOSS_SECRET_KEY=test_gsk_docs_OaPz8L5KdmQXkzRz3y47BMw6
```

토스 가이드가 전자결제 신청 전에는 이 키로 연동하라고 안내하는 키다. 결제창과 결제 승인까지 테스트할 수 있다.
다만 모두가 같이 쓰는 키라서 **내 개발자센터에 결제 내역이 안 쌓이고 웹훅을 등록할 수 없다.**
사용자에게 이 차이를 한 줄로 말해준다.
전자결제 신청이 끝나면 `.env.local` 과 Vercel 환경변수의 두 값만 내 키로 바꾸면 된다. 코드는 그대로다.

구독은 개발자센터에 가입만 하면 "개발 연동 체험 상점"의 `test_ck_` / `test_sk_` 키가 나온다.
이 키로는 결제 내역과 웹훅까지 내 계정에서 된다.

## 반드시 지킬 것

공식 문서 §2 Critical을 우리 스택에 맞춘 것이다.

1. **금액은 서버에서 다시 확인한다.**
   브라우저에서 `requestPayment` 전에 콘솔로 금액을 바꿔 결제할 수 있다.
   승인 전에 DB의 주문 금액과 대조하고, 승인 요청에는 **DB의 금액**을 보낸다. **이 스킬에서 가장 중요한 한 줄이다.**
2. **시크릿 키는 서버 파일에서만 읽는다.** `TOSS_SECRET_KEY` 에 `NEXT_PUBLIC_` 을 붙이지 않는다.
   `api.tosspayments.com` 은 라우트 핸들러·서버 액션에서만 부른다. `"use client"` 파일에서 부르면 키가 브라우저에 보인다.
3. **주문을 먼저 만들고 결제창을 연다.** `pending` 상태의 주문 행이 DB에 있어야 승인 때 대조할 수 있다.
4. **결제 확정은 승인 API 응답으로 한다.** 웹훅은 취소·입금 같은 이후 상태 변경을 받는 보조 경로다.
5. **식별자 형식을 지킨다.**
   - `orderId`: 우리가 만든다. 영문·숫자·`-`·`_` 로 6~64자, 결제마다 고유하게. (`crypto.randomUUID()` 면 된다)
   - `customerKey`: 추측할 수 없는 값. 이메일·전화번호·회원 id를 그대로 쓰지 않는다.
     `profiles` 에 `toss_customer_key uuid default gen_random_uuid()` 컬럼을 두고 그 값을 쓴다. 비회원은 `ANONYMOUS`.

## SDK

```bash
npm install @tosspayments/tosspayments-sdk
```

**V2만 쓴다.** V1(`/v1/payment-widget` 등)과 섞지 않는다. 옛 블로그 글이나 기억 속 코드는 V1인 경우가 많다.
SDK 버전과 별개로 서버 API 주소는 둘 다 `https://api.tosspayments.com/v1/...` 이다.

## 흐름 (단건·예약)

```
1. 서버     주문 생성 (status: pending, orderId·금액 저장)
2. 브라우저 주문서형 결제 렌더 → requestPayment()
3. 토스     결제창 → 인증 → successUrl 로 리다이렉트
            (paymentKey, orderId, amount, paymentType 이 쿼리로 온다)
4. 서버     ★ DB 주문 금액과 amount 대조 ★ → 승인 API 호출
5. 서버     주문 status: paid, paymentKey 저장
6. 웹훅     이후 상태 변경(취소·입금)을 받아 DB 갱신
```

전체 코드는 [주문서형 결제 가이드](https://docs.tosspayments.com/guides/v2/payment-widget/integration.md)를 받아서 보고 만든다.
아래는 우리 스택에서 틀리기 쉬운 부분만이다.

### 1. 주문서형 결제 (클라이언트 컴포넌트)

```ts
import { loadTossPayments, ANONYMOUS } from "@tosspayments/tosspayments-sdk"

const tossPayments = await loadTossPayments(process.env.NEXT_PUBLIC_TOSS_CLIENT_KEY!)
const widgets = tossPayments.widgets({ customerKey: tossCustomerKey ?? ANONYMOUS })

await widgets.setAmount({ currency: "KRW", value: amount })   // V2 웹은 setAmount. updateAmount 아님
await widgets.renderPaymentMethods({ selector: "#payment-method" })
await widgets.renderAgreement({ selector: "#agreement" })

// 구매자가 결제 버튼을 누르면
await widgets.requestPayment({
  orderId,
  orderName,
  successUrl: `${window.location.origin}/payments/success`,
  failUrl: `${window.location.origin}/payments/fail`,
})
```

### 2. 승인 (서버)

인증 헤더는 **시크릿 키 뒤에 `:` 를 붙여 base64** 한 Basic 인증이다. 콜론을 빠뜨리면 401이 난다.

```ts
const basic = Buffer.from(`${process.env.TOSS_SECRET_KEY}:`).toString("base64")

// ★ 먼저 대조한다
const order = await getOrder(orderId)          // DB
if (!order || order.status !== "pending") throw new Error("잘못된 주문")
if (order.amount !== Number(amount)) throw new Error("금액 불일치")

const res = await fetch("https://api.tosspayments.com/v1/payments/confirm", {
  method: "POST",
  headers: {
    Authorization: `Basic ${basic}`,
    "Content-Type": "application/json",
    "Idempotency-Key": order.id,   // 같은 주문을 두 번 승인하지 않게. UUID
  },
  body: JSON.stringify({ paymentKey, orderId, amount: order.amount }),
})
```

- 승인 API의 `amount` 는 객체가 아니라 **정수**다. (SDK의 `setAmount` 만 `{ value, currency }` 객체)
- 실패 응답에는 `code` 와 `message` 가 온다. `message` 는 한국어라 사용자에게 보여줘도 된다.
- **승인 API가 실패했다고 바로 결제 실패로 처리하지 않는다.** 네트워크 문제로 응답만 못 받았을 수 있다.
  `GET /v1/payments/orders/{orderId}` 로 조회해서 실제 상태를 보고 나눈다.
  조회도 안 되면 `failed` 가 아니라 확인이 필요한 상태로 두고 사용자에게 알린다.
- 승인 응답의 `status` 가 `DONE` 일 때만 `paid` 로 바꾼다.
  가상계좌면 `WAITING_FOR_DEPOSIT` 이 오는데, 이건 결제 완료가 아니다. 입금 웹훅을 받을 때까지 기다린다.

### 3. 실패

`failUrl` 로는 `code`, `message`, `orderId` 가 온다. **승인 API를 부르지 않는다.**
주문을 `failed` 로 바꾸고, 사람 말로 안내한 뒤 다시 결제할 수 있게 주문 화면으로 돌아가는 버튼을 둔다.

### 4. 웹훅

라우트 핸들러(`app/api/webhooks/toss/route.ts`)를 만든다. 받는 이벤트는
`PAYMENT_STATUS_CHANGED`, `CANCEL_STATUS_CHANGED`, 가상계좌를 쓰면 `DEPOSIT_CALLBACK`.

**일반 결제 웹훅에는 서명이 없다.** 받은 내용을 그대로 믿지 말고,
`paymentKey` 로 `GET /v1/payments/{paymentKey}` 를 다시 불러 그 응답의 상태로 DB를 갱신한다.
(`tosspayments-webhook-signature` 헤더 검증은 지급대행용이다. 여기서 만들지 않는다)

웹훅은 **여러 번 올 수 있다.** 같은 이벤트를 두 번 처리해도 결과가 같게 만든다.

웹훅 URL 등록은 배포 후 `/publish` 에서 한다. **문서용 테스트 키를 쓰는 동안은 등록할 곳이 없으니 건너뛴다.**
카드·간편결제는 승인 API 응답으로 확정되므로 웹훅 없이도 결제는 끝까지 된다.

### 5. 취소

`POST /v1/payments/{paymentKey}/cancel` 에 `{ cancelReason }`. 부분 취소는 `cancelAmount` 를 더한다.
취소 요청에도 `Idempotency-Key` 를 붙인다. 성공하면 주문을 `cancelled` 로 바꾼다.

## 프리셋별 차이

기획서 맨 위의 `프리셋:` 값을 읽고 해당하는 것만 구현한다.

### `단건`

위 흐름 그대로다. `orders` 테이블에 `status`, `toss_payment_key`, `toss_order_id` 를 채운다.
가장 단순하니 여기서 막히면 다른 걸 의심하지 말고 금액 대조부터 확인한다.

### `구독`

**자동결제(빌링)다.** 주문서형 결제와 키도 흐름도 다르다. 먼저
[자동결제 결제창 연동 가이드](https://docs.tosspayments.com/guides/v2/billing/integration.md)를 받아 읽는다.

1. **카드 등록** (클라이언트): `tossPayments.payment({ customerKey })` 로 만든 객체의
   `requestBillingAuth({ method: "CARD", successUrl, failUrl })`. successUrl로 `customerKey`, `authKey` 가 온다.
2. **빌링키 발급** (서버): `POST /v1/billing/authorizations/issue` 에 `authKey`, `customerKey` →
   `billingKey` 를 `subscriptions.toss_billing_key` 에 저장한다.
3. **매달 결제** (서버): `POST /v1/billing/{billingKey}`, 본문에 주문 정보와 `customerKey`. 사용자 화면이 없다.

- 빌링은 `requestPayment` / successUrl / `/v1/payments/confirm` 을 **쓰지 않는다.** 섞지 마라.
- 키는 API 개별 연동 키(`ck`/`sk`)다. 주문서형 키(`gck`/`gsk`)로는 안 된다.
- 매달 실행할 무언가가 필요하다. Supabase의 `pg_cron` 이나 Vercel Cron을 쓴다.
  매달 결제 요청에는 `Idempotency-Key` 를 `구독id-결제월` 처럼 붙여 같은 달에 두 번 결제되지 않게 한다.
- **결제 실패 처리를 반드시 만든다.** 카드 한도 초과나 만료로 실패하는 일이 실제로 흔하다.
  실패하면 재시도하고, 계속 실패하면 구독을 `past_due` 로 바꾼다.
- 빌링키는 카드 정보와 같은 무게로 다룬다. 절대 클라이언트로 내보내지 않는다.
- 해지는 다음 결제일까지는 쓸 수 있게 하는 게 일반적이다. 즉시 끊지 마라.

### `예약`

단건과 같되 **정원 관리와 취소·환불이 추가된다.**

- 결제 전에 슬롯 정원을 확인하고 자리를 잡아둔다.
  안 그러면 두 사람이 동시에 마지막 자리를 결제한다. DB 트랜잭션이나 제약으로 막는다.
- 결제가 실패하면 잡아둔 자리를 풀어준다.
- 취소 규정을 정한다. (예: 하루 전까지 전액, 당일 50%)
  부분 환불은 취소 API의 `cancelAmount` 를 쓴다.

## 테스트

테스트 키로는 실제 돈이 오가지 않는다. 마음껏 눌러본다.

확인할 것:
- 결제 성공 → 주문이 `paid` 가 되는가
- 결제창에서 취소 → `failUrl` 로 오고 주문이 `failed` 가 되는가
- **금액을 조작한 요청 → 거부되는가** (결제 버튼 누르기 전에 금액을 바꿔 `requestPayment` 를 부르거나,
  DB의 주문 금액을 바꿔놓고 결제해본다)
- 같은 주문을 두 번 승인 → 두 번째가 막히는가

세 번째와 네 번째를 반드시 해본다. 여기가 실제 사고가 나는 자리다.

에러 상황은 [환경 설정 가이드](https://docs.tosspayments.com/guides/v2/get-started/environment.md)의 방법으로 재현할 수 있다.
`agent-browser` 로 결제창까지 눌러보며 확인할 수 있다.

## 자주 막히는 곳

| 증상 | 원인 |
|---|---|
| 401 Unauthorized | 시크릿 키 뒤 `:` 를 빼먹고 base64 인코딩했다 |
| `INVALID_API_KEY` | 클라이언트 키와 시크릿 키가 한 세트가 아니다. 또는 테스트·라이브 키를 섞었다 |
| 주문서형 결제가 안 뜬다 | `ck` 키를 넣었다. 주문서형은 `gck` 다. 사업자등록 전이면 문서용 테스트 키 |
| 구독 카드 등록이 안 된다 | `gck` 키를 넣었다. 자동결제는 `ck` / `sk` 다 |
| `NOT_FOUND_PAYMENT_SESSION` | `requestPayment` 의 `orderId` 와 승인 때 `orderId` 가 다르다 |
| 승인은 됐는데 DB가 그대로 | successUrl 핸들러에서 예외가 났다. 승인 성공 후 DB 갱신까지 한 트랜잭션으로 묶는다 |
| 웹훅이 안 온다 | 로컬 주소를 등록했거나, 문서용 테스트 키를 쓰는 중이다 |
| 개발자센터에 결제 내역이 없다 | 문서용 테스트 키를 쓰는 중이다. 정상이다 |
| 실결제 키를 넣었다 | `live_` 로 시작하면 실제 돈이 나간다. 즉시 테스트 키로 되돌린다 |

그 밖의 오류 코드는 [SDK 에러 코드](https://docs.tosspayments.com/sdk/v2/error-codes.md)와
[API 에러 코드](https://docs.tosspayments.com/reference/error-codes.md)에서 찾는다.
