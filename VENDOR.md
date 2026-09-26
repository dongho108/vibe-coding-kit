# 외부 스킬 출처

이 저장소는 제3자가 만든 스킬을 복사해서 담고 있다.
`npx skills add` 로 따로 설치하지 않고 한 레포에 모아둔 이유는, 설치 경로를 하나로 유지하고
업데이트 시점을 직접 통제하기 위해서다. 대신 **업스트림이 개선돼도 자동으로 따라오지 않는다.**
`scripts/update-vendor.sh` 로 주기적으로 갱신한다.

## 목록

2026-08-31 확인, 2026-09-20 Next.js 스킬 3개 추가. 전부 현행 저장소이며 폐기 예고 없음.

| 스킬 | 원본 | 라이선스 | 커밋 |
|---|---|---|---|
| supabase | supabase/agent-skills | MIT | 8331f91 |
| supabase-postgres-best-practices | supabase/agent-skills | MIT | 8331f91 |
| deploy-to-vercel | vercel-labs/agent-skills | MIT | 063bee9 |
| react-best-practices | vercel-labs/agent-skills | MIT | 063bee9 |
| composition-patterns | vercel-labs/agent-skills | MIT | 063bee9 |
| web-design-guidelines | vercel-labs/agent-skills | MIT | 063bee9 |
| vercel-cli-with-tokens | vercel-labs/agent-skills | MIT | 063bee9 |
| next-cache-components-optimizer | vercel/next.js (`skills/`) | MIT | 00b2275 |
| next-dev-loop | vercel/next.js (`skills/`) | MIT | 00b2275 |
| frontend-design | anthropics/skills | Apache-2.0 | 3b3fad9 |
| webapp-testing | anthropics/skills | Apache-2.0 | 3b3fad9 |
| ui-ux-pro-max | nextlevelbuilder/ui-ux-pro-max-skill | MIT | d279284 |
| agent-browser | vercel-labs/agent-browser | Apache-2.0 | 118af8e |
| nextjs-developer | jeffallan/claude-skills | MIT | 882ef55 |
| nextjs-best-practices | sickn33/agentic-awesome-skills | MIT (코드) / CC BY 4.0 (문서) | 2fd5ecf |
| nextjs-supabase-auth | sickn33/agentic-awesome-skills (원출처 vibeship-spawner-skills, Apache-2.0) | MIT (코드) / CC BY 4.0 (문서) | 2fd5ecf |
| design/references/yns (화면 코드 일부) | yournextstore/yournextstore | MIT | edc036b |

원본 라이선스 전문은 `licenses/` 에 있다. `sickn33/agentic-awesome-skills` 는 코드 MIT, 문서 콘텐츠 CC BY 4.0 이중 라이선스라 둘 다 담았다. `nextjs-supabase-auth` 의 SKILL.md 프론트매터에 원출처(vibeship-spawner-skills, Apache 2.0)가 적혀 있어 그대로 둔다.
`vercel-labs/agent-skills` 만 루트에 LICENSE 파일이 없고 README의 License 절에 MIT로 선언한다.
`licenses/vercel-agent-skills.LICENSE` 에 그 사실을 적어뒀다.

## 알아둘 것

### design/references/yns 는 스킬이 아니라 참고 코드다

`/design` 의 기본 디자인 원본이다. 2026-09-26에 추가했다.
Your Next Store 저장소에서 화면 모양을 담은 파일 18개만 골라 원본 그대로 담았다. 목록은 `scripts/update-vendor.sh` 의 `YNS_FILES`.
앱으로 실행되지 않고, `/design` 이 사용자 프로젝트에 옮겨 쓸 때 읽기만 한다.
원본이 쓰는 `commerce-kit`·Stripe 연결을 우리 데이터로 바꾸는 법은 `skills/design/references/yns-style.md` 에 있다.
갱신한 뒤에는 `yns-style.md` 에 적힌 파일 이름과 클래스가 아직 맞는지 확인한다.

### agent-browser 는 얇은 스텁이다

업스트림이 packaging을 바꿨다. `SKILL.md` 는 이제 52줄짜리 발견용 스텁이고,
실제 사용법은 CLI가 설치된 버전에 맞춰 서빙한다.

```bash
agent-browser skills get core
```

번들된 내용이 낡는 걸 막으려는 의도적 설계다. 그러니 이 스킬은 갱신 주기가 짧지 않아도 된다.
프론트매터에 `hidden: true` 가 있는 것도 업스트림 그대로 유지했다.

### ui-ux-pro-max 는 경로를 하드코딩한다

`SKILL.md` 안의 스크립트 호출이 `${CLAUDE_PLUGIN_ROOT}/.claude/skills/ui-ux-pro-max/scripts/search.py` 로
박혀 있다. 우리는 스킬을 `skills/` 아래 두므로 그대로면 경로가 깨진다.

원본을 고치는 대신 **심볼릭 링크로 맞췄다.**

```
.claude/skills/ui-ux-pro-max -> ../../skills/ui-ux-pro-max
```

업스트림을 갱신해도 이 링크는 그대로 두면 된다. `scripts/update-vendor.sh` 가 링크를 건드리지 않는다.

## 폐기된 것

`vercel-labs/next-skills` 는 폐기됐다. **skills.sh의 Next.js 목록은 아직 이 저장소를 가리키니 믿지 말 것.**

- `next-best-practices` 는 스킬이 아니게 됐다. Next.js 16.3+ 가 `next dev` 실행 시
  `AGENTS.md` / `CLAUDE.md` 를 자동 생성해 그 지식을 전달한다. 별도 설치가 필요 없다.
- `next-cache-components` 는 `next-cache-components-optimizer` 와 `next-cache-components-adoption` 으로
  쪼개져 `vercel/next.js` 저장소의 `skills/` 아래로 옮겨졌다. 우리는 optimizer 만 담았다.

## 아직 없는 것

**토스페이먼츠 스킬은 어디에도 없다.** skills.sh, GitHub 모두 확인했고 결제 연동 스킬은 존재하지 않는다.
(토스증권 Open API용 `BEOKS/tossinvest-skill` 은 다른 물건이다.)
그래서 `skills/pay` 는 이 레포에서 직접 만든다. 이게 이 저장소의 가장 뚜렷한 차별점이다.
