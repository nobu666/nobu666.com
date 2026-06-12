#!/bin/bash
set -euo pipefail

# 既存記事の最大連番を求めて +1 する（パス階層に依存しないよう最終要素=ファイル名で判定）
latest=$(find content -type f -name '*.md' -exec basename {} .md \; | sort -nr | head -n1)
new_seq=$(( latest + 1 ))

# クリップボードコマンドを環境に応じて選択（macOS: pbcopy / Linux: xsel）
if command -v pbcopy >/dev/null 2>&1; then
  clip=pbcopy
elif command -v xsel >/dev/null 2>&1; then
  clip="xsel --clipboard --input"
else
  clip=cat
fi

hugo new "$(date +%Y/%m/%d)/${new_seq}.md" | awk -F\" '{print $2}' | $clip
