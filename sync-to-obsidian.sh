#!/bin/bash
# Hugo記事をObsidian Vaultに同期する
# TOML frontmatter → YAML frontmatter に変換してコピー

set -euo pipefail

CONTENT_DIR="$(cd "$(dirname "$0")" && pwd)/content"
VAULT_DIR="$HOME/Documents/Obsidian/Vault/nobu666.com"

convert_file() {
  local src
  src=$(cd "$(dirname "$1")" && echo "$(pwd)/$(basename "$1")")
  local relative="${src#$CONTENT_DIR/}"
  # YYYY/MM/DD/NNNN.md → NNNN.md
  local filename
  filename=$(basename "$relative" .md)
  # 日付をfrontmatterから取得
  local date title tags description

  date=$(grep -m1 '^date = ' "$src" | sed 's/date = "\(.*\)"/\1/')
  title=$(grep -m1 '^title = ' "$src" | sed 's/title = "\(.*\)"/\1/')
  # Tags or categories
  tags=$(grep -m1 '^\(Tags\|categories\) = ' "$src" | sed 's/.*= \[//;s/\]//;s/"//g' || true)
  description=$(grep -m1 '^description = ' "$src" | sed 's/description = "\(.*\)"/\1/' || true)

  local year
  year=$(echo "$date" | cut -c1-4)
  local dest_dir="$VAULT_DIR/$year"
  local dest="$dest_dir/${filename}.md"

  mkdir -p "$dest_dir"

  # 本文を取得（2つ目の +++ 以降）
  local body
  body=$(awk '/^\+\+\+/{n++; next} n>=2' "$src")

  # YAML frontmatter を生成
  {
    echo "---"
    echo "title: \"$title\""
    [ -n "$date" ] && echo "date: $date"
    if [ -n "$tags" ]; then
      echo "tags:"
      IFS=',' read -ra tag_arr <<< "$tags"
      for t in "${tag_arr[@]}"; do
        t=$(echo "$t" | xargs)
        [ -n "$t" ] && echo "  - $t"
      done
    fi
    [ -n "$description" ] && echo "description: \"$description\""
    echo "source: \"https://nobu666.com/${relative%.md}.html\""
    echo "---"
    echo "$body"
  } > "$dest"
}

# 引数があればそのファイルだけ、なければ全記事
if [ $# -gt 0 ]; then
  for f in "$@"; do
    [ -f "$f" ] && convert_file "$f"
  done
else
  find "$CONTENT_DIR" -name "*.md" | while read -r f; do
    convert_file "$f"
  done
fi

count=$(find "$VAULT_DIR" -name "*.md" 2>/dev/null | wc -l | xargs)
echo "同期完了: ${count}件 → $VAULT_DIR"
