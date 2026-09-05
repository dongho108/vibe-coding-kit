# vibe-coding-kit

터미널이 처음이어도 아이디어부터 **결제되는 서비스**까지 갈 수 있는 Claude Code 플러그인.

기술 선택을 대신 내려줍니다. 뭘 써야 할지 고민하지 마세요.

## 설치

```bash
curl -fsSL https://raw.githubusercontent.com/dongho108/vibe-coding-kit/main/install.sh | bash
```

설치가 끝나면 클로드 코드를 열고 `/setup` 이라고 치세요.

## 순서

```
/setup   환경과 계정 4개 준비
   ↓
/plan    아이디어를 기획서로. 여기서 제품 형태를 고릅니다
   ↓
/design  색·폰트 정하고 화면 시안
   ↓
/stack   Next.js 뼈대와 데이터베이스
   ↓
   ...   기능 만들기 (클로드가 알아서)
   ↓
/ship    배포하고 결제 붙이기
```

각 단계가 끝나면 다음에 칠 명령어를 알려줍니다. 외울 건 `/setup` 하나뿐입니다.

## 정해져 있는 것

| | |
|---|---|
| 프레임워크 | Next.js |
| 데이터베이스·로그인 | Supabase |
| 배포 | Vercel |
| 디자인 | shadcn/ui + Tailwind |
| 결제 | 토스페이먼츠 |
| 로그인 | 구글 |

바꾸고 싶다면 `docs/03-왜-이-스택인가.md` 를 보세요. 왜 이걸 골랐는지와 바꾸는 법이 적혀 있습니다.

## 제품 형태 3종

`/plan` 에서 하나를 고르면 이후 데이터베이스 구조와 결제 흐름이 거기에 맞춰집니다.

- **단건** 전자책·템플릿·강의처럼 한 번 사면 끝나는 것
- **구독** 매달 결제하고 쓰는 서비스
- **예약** 클래스·상담·공간처럼 시간을 예약하고 결제하는 것

## 결제에 대해

**사업자등록 없이 결제가 끝까지 도는 상태를 오늘 만들 수 있습니다.**
토스페이먼츠 개발자센터에 이메일과 전화번호만으로 가입하면 테스트 키가 나오고,
결제창부터 승인·웹훅까지 전부 동작합니다. 사업자등록번호는 묻지 않습니다.

실제로 돈을 받으려면 사업자등록과 통신판매업 신고가 필요합니다.
이건 결제사와 무관하게 법적으로 요구되는 절차이고, `docs/02-실결제-전환-체크리스트.md` 에 순서대로 적어뒀습니다.
먼저 만들고 나중에 밟으세요.

## 스킬 목록

직접 만든 것과 좋은 외부 스킬을 한 저장소에 모아뒀습니다. 따로 설치할 게 없습니다.

**진행 스킬 (직접 제작)**
`setup` `plan` `design` `stack` `ship` `toss-payments`

**지식 스킬 (외부, 출처는 [VENDOR.md](VENDOR.md))**
`supabase` `supabase-postgres-best-practices` `deploy-to-vercel` `react-best-practices`
`composition-patterns` `web-design-guidelines` `vercel-cli-with-tokens`
`next-cache-components-optimizer` `next-dev-loop`
`frontend-design` `webapp-testing` `ui-ux-pro-max` `agent-browser`

## 라이선스

MIT. 포함된 외부 스킬은 각 원저작자의 라이선스를 따릅니다. [VENDOR.md](VENDOR.md) 참조.
