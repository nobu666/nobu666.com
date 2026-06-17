# CLAUDE.md

nobu666.com — Hugo製の個人ブログ（テーマ: hugo-flex）。

## プロジェクト構成

- `content/YYYY/MM/DD/NNNN.md` — 記事（連番ファイル名、TOML frontmatter）
- `newpost.sh` — 新規記事の雛形を作成し、パスをクリップボードにコピー
- `static/images/` — 記事で使う画像
- `layouts/` — テンプレートのカスタマイズ
- `config.toml` — サイト設定
- GitHub Actions で master push 時に自動デプロイ

## 記事のフォーマット

```toml
+++
date = "2026-06-17T19:30:00+09:00"
Tags = ["tech", "ai"]
title = "記事タイトル"
images = ["/images/NNNN-ogp.png"]
+++
```

## 記事を書く際のルール

1. **レビュー必須** — 記事を書いたら公開前に必ずレビューすること。誤字脱字、論理の飛躍、読みにくい箇所がないか確認する
2. **図の挿入を検討** — 途中で図（SVG、スクリーンショット等）を入れたほうが理解しやすくなる箇所がないか確認し、提案すること
3. **文体の統一** — 過去の記事と文章のスタイルを合わせること。既存記事を読んでトーンや表現を揃える
4. **SNS投稿文の提案** — 記事が完成したら、X（Twitter）と Facebook に投稿する際の文章をそれぞれ提案すること

## ビルド・プレビュー

```bash
hugo server -D    # ローカルプレビュー（http://localhost:1313）
hugo              # 静的ファイル生成（public/）
```
