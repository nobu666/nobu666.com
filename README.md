nobu666.com
====

[![MIT License](http://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)][license]
[![github pages](https://github.com/nobu666/nobu666.com/actions/workflows/gh-pages.yml/badge.svg)](https://github.com/nobu666/nobu666.com/actions/workflows/gh-pages.yml)

[license]: https://github.com/nobu666/nobu666.com/blob/master/LICENSE

[nobu666.com](https://nobu666.com/) のソースリポジトリです。静的サイトジェネレータ [Hugo](https://gohugo.io/)（Go 製）で構築しています。

## 構成

- **ジェネレータ**: Hugo（extended 版が必須）
- **テーマ**: [hugo-flex](https://github.com/ldeso/hugo-flex)。テーマは Git submodule として `themes/` 配下に取り込んでいます（`config.toml` の `theme` で切り替え）。
- **設定**: [`config.toml`](config.toml)
- **記事**: [`content/`](content/) 配下に年・月・日のディレクトリで配置
- **静的ファイル**: [`static/`](static/)（OGP 画像などは `static/images/`）
- **デプロイ**: master へ push すると GitHub Actions（[`.github/workflows/gh-pages.yml`](.github/workflows/gh-pages.yml)）が Hugo でビルドし、`gh-pages` ブランチへ公開します。

## ゼロからのセットアップ

### 1. 前提ツールのインストール

Hugo は **extended 版**が必要です（テーマが SCSS を使うため）。

```bash
# macOS (Homebrew)
brew install hugo git

# 確認（"+extended" が含まれていること）
hugo version
```

### 2. リポジトリの取得

テーマは submodule なので `--recursive` を付けてクローンします。

```bash
git clone --recursive https://github.com/nobu666/nobu666.com.git
cd nobu666.com
```

`--recursive` を付け忘れた場合は、後から取得します。

```bash
git submodule update --init --recursive
```

### 3. ローカルでプレビュー

```bash
# 下書き（draft）も含めてプレビューする場合は -D を付ける
hugo server -D
```

ブラウザで http://localhost:1313/ を開いて確認します。

### 4. 本番ビルド（任意）

通常は push すれば GitHub Actions が自動でビルド・デプロイするので手動ビルドは不要ですが、ローカルで成果物を確認したい場合は次の通りです。

```bash
hugo --minify --gc
# 生成物は public/ に出力されます（public/ は .gitignore 済み）
```

## 投稿のルール

### ファイルの置き場所と命名

記事は **`content/<年>/<月>/<日>/<連番>.md`** の形式で配置します。

```
content/2026/06/12/1032.md
```

- 連番はサイト全体で重複しない通し番号です。新規記事は既存の最大番号 +1 を使います。
- URL は `uglyurls = true` のため `https://nobu666.com/2026/06/12/1032.html` のようになります。

### Front Matter（TOML 形式）

記事の先頭に `+++ ... +++` で囲んだ TOML のメタ情報を記述します。

```toml
+++
date = "2026-06-12T12:00:00+09:00"
Tags = ["miscellaneous"]
title = "記事タイトル"
images = ["/images/1032-ogp.png"]
+++

ここから本文（Markdown）。
```

- **date**: タイムゾーン付き（`+09:00`）の ISO 8601 形式。
- **Tags**: 配列で指定。特に無ければ `["miscellaneous"]`。
- **title**: 記事タイトル。
- **images**: OGP / Twitter Card 用の画像 URL（任意だが推奨）。下記参照。

### OGP 画像

SNS シェア時のカード画像を出したい場合は、画像を **`static/images/<連番>-ogp.png`** に置き、front matter の `images` に `/images/<連番>-ogp.png` を指定します（先頭スラッシュ始まりのサイトルート相対パス）。推奨サイズは 1200×630。

### 新規記事の雛形作成

補助スクリプト [`newpost.sh`](newpost.sh) を使うと、既存の最大連番 +1 で当日付の雛形を生成し、そのパスをクリップボードへコピーします（macOS / Linux 両対応）。

```bash
./newpost.sh
```

Hugo の `new` コマンドで直接生成することもできます。

```bash
hugo new 2026/06/12/1033.md
```

いずれの場合も、生成後に front matter の `date` / `title` / `Tags` / `images` を埋めてください。

### 公開の流れ

1. 記事（と必要なら OGP 画像）を追加・編集する。
2. `hugo server -D` でローカル確認する。
3. master ブランチにコミットして push する。
4. GitHub Actions が自動でビルドし、`gh-pages` へデプロイ → 公開される。

```bash
git add content/2026/06/12/1033.md static/images/1033-ogp.png
git commit -m "Add post: 記事タイトル"
git push origin master
```

## Author

[nobu666](https://github.com/nobu666)
