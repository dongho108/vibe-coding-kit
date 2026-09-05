---
name: toss-payments
description: >
  토스페이먼츠 결제를 Next.js 서비스에 붙이는 스킬. 결제위젯 연동, 결제 승인 API, 웹훅,
  결제 실패·취소 처리를 다루고 단건·구독(빌링키)·예약금 세 가지 흐름을 지원한다.
  "결제", "토스", "토스페이먼츠", "돈 받기", "결제창", "정기결제", "구독 결제", "환불", "웹훅",
  "결제 붙여줘" 같은 말이나, 서비스에 결제를 붙여야 하는 모든 상황에서 사용한다.
---

# /toss-payments 토스페이먼츠 연동

이 레포에서 **직접 만든 유일한 도메인 스킬**이다.
skills.sh와 GitHub 어디에도 토스페이먼츠 결제 연동 스킬이 없다.

## 대전제: 테스트 키로 끝까지 간다

사용자는 **사업자등록 없이** 결제가 끝까지 도는 완성품을 오늘 갖는다.
토스 개발자센터는 이메일과 전화번호만으로 가입되고 사업자등록번호를 묻지 않는다.
`/setup` 에서 받은 `test_gck_` / `test_gsk_` 키로 결제창부터 승인·웹훅까지 전부 동작한다.

**실결제 전환 이야기를 여기서 꺼내지 마라.** `/ship` 의 마지막 절이 담당한다.

## 반드시 지킬 것

1. **금액은 서버에서 다시 확인한다.**
   클라이언트가 보낸 금액을 그대로 믿고 승인하면 사용자가 값을 바꿔 1원에 결제할 수 있다.
   승인 전에 DB의 주문 금액과 대조한다. **이 스킬에서 가장 중요한 한 줄이다.**
2. **시크릿 키는 서버에서만 쓴다.** `TOSS_SECRET_KEY` 에 `NEXT_PUBLIC_` 을 붙이지 않는다.
3. **주문을 먼저 만들고 결제창을 연다.** `pending` 상태의 주문 행이 DB에 있어야 승인 때 대조할 수 있다.
4. **승인 성공을 웹훅으로만 판단하지 않는다.** 승인 API 응답으로 확정하고,
   웹훅은 상태 변경(취소·가상계좌 입금)을 받는 보조 경로로 쓴다.
5. **`orderId` 는 우리가 만든다.** 추측 불가능한 값으로 만들고 DB에 저장한다.

## SDK

```bash
npm install @tosspayments/tosspayments-sdk
```

v2다. v1의 여러 SDK가 하나로 합쳐졌다. 새로 만드는 것은 v2로 간다.

결제위젯을 쓰므로 키는 `gck` / `gsk` 계열이다. `ck` / `sk` 는 API 개별연동용이라 다르다.
사용자 키가 `test_ck_` 로 시작하면 잘못 받은 것이니 결제위젯 키를 다시 받게 한다.

## 흐름

```
1. 서버   주문 생성 (status: pending, orderId·금액 저장)
2. 브라우저 결제위젯 렌더 → requestPayment()
3. 토스    결제창 → 인증 → successUrl 로 리다이렉트
           (paymentKey, orderId, amount 가 쿼리로 온다)
4. 서버   ★ DB 주문 금액과 amount 대조 ★ → 승인 API 호출
5. 서버   주문 status: paid, paymentKey 저장
6. 웹훅   이후 상태 변경(취소·입금)을 받아 DB 갱신
```

4번의 대조를 빠뜨리는 게 가장 흔하고 가장 치명적인 실수다.

## 구현

### 1. 결제위젯 (클라이언트)

```ts
import { loadTossPayments, ANONYMOUS } from "@tosspayments/tosspayments-sdk"

const tossPayments = await loadTossPayments(
  process.env.NEXT_PUBLIC_TOSS_CLIENT_KEY!
)
const widgets = tossPayments.widgets({ customerKey: userId ?? ANONYMOUS })

await widgets.setAmount({ currency: "KRW", value: amount })
await widgets.renderPaymentMethods({ selector: "#payment-method" })
await widgets.renderAgreement({ selector: "#agreement" })

await widgets.requestPayment({
  orderId,
  orderName,
  successUrl: `${origin}/payments/success`,
  failUrl: `${origin}/payments/fail`,
})
```

로그인한 사용자는 `customerKey` 에 사용자 id를 넣는다. 비회원은 `ANONYMOUS`.
`customerKey` 에 이메일이나 전화번호처럼 개인정보를 넣지 마라.

### 2. 승인 (서버)

`POST https://api.tosspayments.com/v1/payments/confirm`

인증은 **시크릿 키 뒤에 `:` 를 붙여 base64로 인코딩한 Basic 인증**이다.
`Basic base64(secretKey + ":")` 이고, 콜론을 빠뜨리면 401이 난다.

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
  },
  body: JSON.stringify({ paymentKey, orderId, amount: order.amount }),
})
```

승인 요청에 보내는 `amount` 는 쿼리로 받은 값이 아니라 **DB에서 읽은 값**이다.

실패 응답에는 `code` 와 `message` 가 온다. `message` 는 한국어라 사용자에게 그대로 보여줘도 된다.

### 3. 웹훅

`payment_status_changed` 를 받는다. 가상계좌를 쓰면 `deposit_callback` 도.

라우트 핸들러를 만들고 토스 개발자센터에서 URL을 등록한다.
로컬 개발 중에는 공개 URL이 없으므로 배포 후(`/ship`) 등록하는 편이 낫다.

**웹훅은 검증한다.** 받은 데이터의 `secret` 이 결제 승인 때 받아둔 Payment 객체의 `secret` 과 같은지 확인한다.
검증 없이 DB를 갱신하면 아무나 결제 상태를 조작할 수 있다.

웹훅은 **여러 번 올 수 있다.** 같은 이벤트를 두 번 처리해도 결과가 같도록 만든다.

### 4. 실패와 취소

`failUrl` 로는 `code`, `message`, `orderId` 가 온다. 주문을 `failed` 로 바꾸고 사람 말로 안내한다.

취소는 `POST /v1/payments/{paymentKey}/cancel` 에 `cancelReason` 을 보낸다. 부분 취소는 `cancelAmount` 를 더한다.

## 프리셋별 차이

기획서 맨 위의 `프리셋:` 값을 읽고 해당하는 것만 구현한다.

### `단건`

위 흐름 그대로다. `orders` 테이블에 `status`, `toss_payment_key`, `toss_order_id` 를 채운다.
가장 단순하니 여기서 막히면 다른 걸 의심하지 말고 금액 대조부터 확인한다.

### `구독`

**정기결제는 빌링키 방식이다.** 결제 흐름이 두 단계로 나뉜다.

1. **카드 등록**: 위젯 대신 `requestBillingAuth` 로 카드를 등록받고 `authKey` 를 받는다.
   그걸 서버에서 빌링키로 교환해 `subscriptions.toss_billing_key` 에 저장한다.
2. **매달 결제**: 저장한 빌링키로 서버에서 결제를 요청한다. 사용자 화면이 필요 없다.

매달 실행할 무언가가 필요하다. Supabase의 `pg_cron` 이나 Vercel Cron을 쓴다.
**결제 실패 처리를 반드시 만든다.** 카드 한도 초과나 만료로 실패하는 일이 실제로 흔하다.
실패하면 재시도하고, 계속 실패하면 구독을 `past_due` 로 바꾼다.

빌링키는 카드 정보와 같은 무게로 다룬다. 절대 클라이언트로 내보내지 않는다.

해지는 다음 결제일까지는 쓸 수 있게 하는 게 일반적이다. 즉시 끊지 마라.

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
- **금액을 조작한 요청 → 거부되는가** (successUrl의 amount를 손으로 바꿔서 호출해본다)
- 같은 주문을 두 번 승인 → 두 번째가 막히는가

세 번째와 네 번째를 반드시 해본다. 여기가 실제 사고가 나는 자리다.

`agent-browser` 로 결제창까지 눌러보며 확인할 수 있다.

## 자주 막히는 곳

| 증상 | 원인 |
|---|---|
| 401 Unauthorized | 시크릿 키 뒤 `:` 를 빼먹고 base64 인코딩했다 |
| 위젯이 안 뜬다 | `ck` 키를 받았다. 결제위젯은 `gck` 다 |
| `NOT_FOUND_PAYMENT_SESSION` | `requestPayment` 의 `orderId` 와 승인 때 `orderId` 가 다르다 |
| 승인은 됐는데 DB가 그대로 | successUrl 핸들러에서 예외가 났다. 승인 성공 후 DB 갱신까지 한 트랜잭션으로 묶는다 |
| 웹훅이 안 온다 | 로컬 주소를 등록했다. 배포된 공개 URL이어야 한다 |
| 실결제 키를 넣었다 | `live_` 로 시작하면 실제 돈이 나간다. 즉시 테스트 키로 되돌린다 |
