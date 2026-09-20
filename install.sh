#!/usr/bin/env bash
set -euo pipefail

REPO="dongho108/vibe-coding-kit"

echo "바이브 코딩 키트를 설치합니다."
claude plugin marketplace add "$REPO"
claude plugin install vibe-coding-kit@vibe-coding-kit -y

echo
echo "설치 완료. 이제 클로드 코드를 열고 이렇게 치세요."
echo
echo "  /start"
echo
