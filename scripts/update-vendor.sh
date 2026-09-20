#!/usr/bin/env bash
# 외부 스킬을 업스트림 최신으로 갱신한다.
# 갱신 후 VENDOR.md의 커밋 해시를 손으로 고칠 것.
set -euo pipefail

R="$(cd "$(dirname "$0")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

clone() { git clone --depth 1 -q "https://github.com/$1.git" "$TMP/$2"; echo "$2 $(git -C "$TMP/$2" rev-parse --short HEAD)"; }

clone supabase/agent-skills supabase
clone vercel-labs/agent-skills vercel
clone anthropics/skills anthropic
clone nextlevelbuilder/ui-ux-pro-max-skill uiux
clone vercel-labs/agent-browser agentbrowser
clone jeffallan/claude-skills jeffallan
clone sickn33/agentic-awesome-skills awesome
git clone --depth 1 --filter=blob:none --sparse -q https://github.com/vercel/next.js.git "$TMP/next"
git -C "$TMP/next" sparse-checkout set skills
echo "next $(git -C "$TMP/next" rev-parse --short HEAD)"

cp_skill() { rm -rf "$R/skills/$2"; cp -R "$1" "$R/skills/$2"; }

cp_skill "$TMP/supabase/skills/supabase" supabase
cp_skill "$TMP/supabase/skills/supabase-postgres-best-practices" supabase-postgres-best-practices
for s in deploy-to-vercel react-best-practices composition-patterns web-design-guidelines vercel-cli-with-tokens; do
  cp_skill "$TMP/vercel/skills/$s" "$s"
done
for s in next-cache-components-optimizer next-dev-loop; do
  cp_skill "$TMP/next/skills/$s" "$s"
done
for s in frontend-design webapp-testing; do
  cp_skill "$TMP/anthropic/skills/$s" "$s"
done
cp_skill "$TMP/uiux/.claude/skills/ui-ux-pro-max" ui-ux-pro-max
cp_skill "$TMP/agentbrowser/skills/agent-browser" agent-browser
cp_skill "$TMP/jeffallan/skills/nextjs-developer" nextjs-developer
for s in nextjs-best-practices nextjs-supabase-auth; do
  cp_skill "$TMP/awesome/skills/$s" "$s"
done

cp "$TMP/supabase/LICENSE" "$R/licenses/supabase-agent-skills.LICENSE"
cp "$TMP/next/license.md" "$R/licenses/nextjs.LICENSE"
cp "$TMP/anthropic/skills/frontend-design/LICENSE.txt" "$R/licenses/anthropics-skills.LICENSE"
cp "$TMP/uiux/LICENSE" "$R/licenses/ui-ux-pro-max.LICENSE"
cp "$TMP/agentbrowser/LICENSE" "$R/licenses/agent-browser.LICENSE"
cp "$TMP/jeffallan/LICENSE" "$R/licenses/jeffallan-claude-skills.LICENSE"
cp "$TMP/awesome/LICENSE" "$R/licenses/agentic-awesome-skills.LICENSE"
cp "$TMP/awesome/LICENSE-CONTENT" "$R/licenses/agentic-awesome-skills-CONTENT.LICENSE"

find "$R/skills" -name "*.zip" -delete

# ui-ux-pro-max가 하드코딩한 경로용 심볼릭 링크 (VENDOR.md 참조)
mkdir -p "$R/.claude/skills"
ln -sfn ../../skills/ui-ux-pro-max "$R/.claude/skills/ui-ux-pro-max"
echo
echo "완료. 위 커밋 해시를 VENDOR.md에 반영하세요."
