# vibe-coding-kit

터미널이 처음이어도 아이디어부터 **결제되는 서비스**까지 갈 수 있는 Claude Code 플러그인.

기술 선택을 대신 내려줍니다. 뭘 써야 할지 고민하지 마세요.

## 설치

**Claude 데스크탑 앱**: 설정 > 플러그인 > 오른쪽 위 "+ 추가" > "마켓플레이스 추가" 에 아래 주소를 넣고, 검색창에 `vibe` 를 쳐서 나오는 카드의 + 를 누르세요.

```
https://github.com/dongho108/vibe-coding-kit
```

**터미널(Claude Code CLI)**:

```bash
curl -fsSL https://raw.githubusercontent.com/dongho108/vibe-coding-kit/main/install.sh | bash
```

설치가 끝나면 Code 탭(또는 클로드 코드)을 열고 `/start` 라고 치세요.

**새 버전 자동으로 받기**: `/plugin` > Marketplaces 탭 > `vibe-coding-kit` > **Enable auto-update**.
켜지 않으면 `/plugin` > Installed 탭 > **Update now** 로 직접 받습니다.

> 관리자용: main에 푸시만 해서는 사용자에게 가지 않습니다.
> GitHub Actions의 **Release** 워크플로를 직접 돌려야 버전이 올라가고 사용자에게 나갑니다.

## 순서

계정부터 만들면 지칩니다. **내 컴퓨터에서 먼저 돌려보고, 배포할 때 계정을 만드는 순서**를 권합니다.

```
/start local     Node만 확인. 계정은 아직 안 만듭니다
   ↓
/plan            아이디어를 기획서로. 여기서 제품 형태를 고릅니다
   ↓
/build local     Next.js 뼈대. 데이터는 임시 파일에
   ↓
/design          색·폰트 정하고 화면 만들기 → 내 컴퓨터에서 가게가 보입니다
   ↓
/start deploy    GitHub·Vercel 계정
   ↓
/publish only    인터넷 주소가 생깁니다
   ↓
/start accounts  Supabase·Google·토스 계정
   ↓
/build           데이터베이스와 구글 로그인 붙이기 (임시 데이터를 옮깁니다)
   ↓
/pay             결제
   ↓
/publish         로그인 주소 재등록, 웹훅, 최종 확인
```

한 번에 전부 준비하고 싶으면 `/start` 만 치고 "전부"라고 답하면 됩니다.
각 단계가 끝나면 다음에 칠 명령어를 알려줍니다. 외울 건 `/start` 하나뿐입니다.

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
`start` `plan` `build` `design` `publish` `pay`

**지식 스킬 (외부, 출처는 [VENDOR.md](VENDOR.md))**
`supabase` `supabase-postgres-best-practices` `deploy-to-vercel` `react-best-practices`
`composition-patterns` `web-design-guidelines` `vercel-cli-with-tokens`
`next-cache-components-optimizer` `next-dev-loop` `nextjs-developer` `nextjs-best-practices` `nextjs-supabase-auth`
`frontend-design` `webapp-testing` `ui-ux-pro-max` `agent-browser`

## 라이선스

MIT. 포함된 외부 스킬은 각 원저작자의 라이선스를 따릅니다. [VENDOR.md](VENDOR.md) 참조.
