# 기본 디자인: Your Next Store 스타일

`/design` 에서 사용자가 참고 사이트를 주지 않으면 이 디자인으로 간다.
원본은 [yournextstore/yournextstore](https://github.com/yournextstore/yournextstore) (MIT, 데모 https://demo.yournextstore.com).
`references/yns/` 에 화면 코드 원본을 담아뒀다. 출처와 커밋은 `VENDOR.md`.

## 느낌

흰 바탕에 검정 글씨, 색은 거의 없다. 상품 사진이 주인공이고 여백이 넓다.
버튼은 알약 모양(`rounded-full`), 사진 칸은 크게 둥근 사각형(`rounded-2xl`).
제목은 굵지 않게(`font-medium`) 자간을 살짝 좁힌다(`tracking-tight`).

## 토큰

shadcn `new-york` 스타일, `baseColor: neutral` 기본값과 거의 같다. 새로 지을 게 없다.

- 색: `references/yns/app/globals.css` 의 `:root` 와 `.dark` 블록을 그대로 쓴다.
  주 색상(`--primary`)도 검정에 가까운 회색이다.
- 모서리: `--radius: 0.625rem`
- 글꼴: 원본은 Geist(영문 전용)다. **Pretendard로 바꾼다.** `--font-sans` 만 Pretendard로 연결하면 된다.
- 다크 모드: 원본에 있다. `next-themes` 로 켠다.

사용자가 색 하나를 원하면 `--primary` 와 `--ring` 만 바꾼다. 나머지는 건드리지 않는다.

## 화면별 원본

| 화면 | 원본 파일 | 핵심 모양 |
|---|---|---|
| 공통 머리글 | `app/layout.tsx` 의 `<header>`, `app/navbar.tsx` | 위에 붙는 반투명 흰 막대(`sticky backdrop-blur-md`), 로고 왼쪽·메뉴 가운데·장바구니 오른쪽. 모바일은 왼쪽 햄버거 → 옆에서 나오는 `Sheet` |
| 첫 화면 | `app/page.tsx`, `components/sections/hero.tsx` | 큰 제목 + 설명 + 알약 버튼 2개(검정 채움 / 테두리). 배경 `bg-secondary/30` |
| 상품 목록 | `components/sections/product-grid.tsx`, `components/product-card.tsx` | 1·2·3열 그리드, `gap-8`. 카드는 정사각 사진 + 이름 + 가격. 사진이 2장이면 마우스를 올릴 때 두 번째로 바뀜 |
| 소개 | `components/sections/about.tsx` | 가운데 정렬 글 한 덩어리 |
| 뉴스레터 | `components/sections/newsletter.tsx` | 이메일 입력 + 버튼. 필요 없으면 뺀다 |
| 상품 상세 | `app/product/[slug]/page.tsx`, `media-gallery.tsx`, `add-to-cart-button.tsx`, `quantity-selector.tsx` | 데스크톱 2열: 왼쪽 사진(스크롤해도 따라옴), 오른쪽 이름·가격·구매 버튼. 모바일은 위아래 |
| 장바구니 | `app/cart/cart-sidebar.tsx`, `cart-item.tsx`, `app/cart-button.tsx` | 오른쪽에서 나오는 `Sheet` |
| 바닥글 | `app/footer.tsx` | 링크 몇 줄 + 저작권 |

공통 폭은 `max-w-7xl mx-auto px-4 sm:px-6 lg:px-8`, 섹션 위아래 여백은 `py-16 sm:py-24`.

## 옮길 때 바꿀 것

원본은 YNS 자체 서비스(`commerce-kit`)와 Stripe에 묶여 있다. **모양(마크업과 Tailwind 클래스)만 가져오고 데이터 연결은 우리 것으로 바꾼다.**

- `commerce.*`, `meGetCached`, `getStoreConfig` 호출 → `/build` 가 만든 데이터
  (로컬 모드면 `data/products.ts` 등, 전체 모드면 Supabase)
- `commerce-kit` 의 타입 → 우리 데이터 타입
- `YNSMedia` → `next/image` 의 `Image`
- `formatMoney` → `toLocaleString("ko-KR")` + "원"
- 영어 문구 → 한국어. `<html lang="ko">`
- `"use cache"`, `cacheLife` → 우리 프로젝트가 Cache Components를 켜지 않았으면 뺀다

**옮기지 않는 것**: 채팅 위젯, 쿠키 동의, 뉴스레터 팝업, 리뷰, 번들, 재입고 알림, 할인 코드, 구조화 데이터(JSON-LD), 추적.
원본의 부가 기능이고, 초보가 떠안기엔 무겁다.

## 제품 형태별로

원본은 장바구니가 있는 일반 쇼핑몰이다. 우리 제품 형태에 맞게 줄인다.

- **단건**: 장바구니를 빼고 상품 상세의 버튼을 "바로 구매"로. 상품이 2~3개뿐이면 목록 없이 첫 화면에 카드만.
- **구독**: 상품 카드 자리에 요금제 카드. 상세 페이지 대신 요금제 비교 한 화면.
- **예약**: 상품 상세의 구매 영역 자리에 날짜·시간 고르기. 나머지 모양은 그대로.

장바구니가 정말 필요하다고 사용자가 말할 때만 `cart-sidebar` 를 옮긴다.
