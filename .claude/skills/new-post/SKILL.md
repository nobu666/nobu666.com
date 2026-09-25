---
name: new-post
description: "nobu666.com（Hugo）の新規ブログ記事を、執筆→レビュー→humanizer→図→OGP生成→ビルド確認→ブラウザ確認→英語版作成(任意)→SNS文まで一気通貫で作るスキル。「記事を書いて」「新規記事」「ブログにして」「○○について書いて」などで起動する。"
version: "1.0.0"
---

# new-post — nobu666.com の記事作成フロー

Hugo製ブログ nobu666.com の記事を、公開可能な状態まで仕上げる手順。
プロジェクトの `CLAUDE.md`「記事を書く際のルール」を前提とし、それを実行可能な手順に落とし込んだもの。

作業ディレクトリは `~/Documents/nobu666.com`。

---

## 作業ルール

- 書き始める前に、この記事の「合格条件」を機械的に確認できる形で列挙する（文体ルール・分量・禁止事項・使ってはいけない部品）。曖昧な点は妥当な前提を置いて明記し、前提次第で記事の芯が変わるときだけ質問する
- 成果物を提出する前に、合格条件と1項目ずつ突き合わせて自己検証する。違反を見つけたら提出前に直す
- 提出物の最後に「検証報告」を付ける。確認した項目は証拠（該当箇所・カウント数）と共に、確認していない項目は「未検証」と正直に書く
- 指示されていないことをしない（お題の変更・分量の大幅超過・頼まれていない形式の追加）
- 指示の解釈が分かれ、どちらを取るかで記事が大きく変わる場合は、列挙して確認する。それ以外は妥当な方を選び、その前提を報告に書く
- 自分の成果物の一番弱い箇所を最低1つ具体的に挙げ、直すか、直せない理由を書く
- レビューや裏取りの結果、記事の芯・軸・結論が変わったら、部分修正で済ませない。全文を頭から読み直し、冒頭の掴み・首尾呼応の合言葉・見出し・表・図・タイトル・OGP・descriptionを新しい芯に揃え、レビューをもう一周する。差分修正は旧稿の残骸（回収されない自己言及・古い合言葉・伏線の前出し）を残す（実例: 記事1049で軸を差し替えた際、部分Editの積み重ねで旧軸の結び文と根拠場面のない「見誤っていた」が残った）

## 記事の自己検証手順（提出前に必ず順に実行）

1. humanizer-jaのチェックリスト（定型評価語・太字乱打・全角ダッシュ・「することができます」等）と自分の記事を1つずつ突き合わせ、該当する文があれば書き直す
2. 直近の記事2〜3本と突き合わせ、形を変えた再利用（同じ骨格・同じモチーフ・同じ締め型）がないか確認する
3. 機械カウントを実行する: 丸数字（0であること）／太字`**`（2箇所以内。「**ラベル:** 内容」形式は0）／一人称「私」「僕」（0であること）／X投稿文の重み付き文字数（280以内、手順10の計算式）
4. 記事中の数字・固有名詞・過去記事への言及が、素材（作業ログ・Vaultノート・過去記事）と矛盾しないか確認する
5. 結びで言い切る中心主張に、その理由が本文中に最低1つあるか確認する（ルールの宣言だけで終わらせない）
6. 表にだけ登場する論点がないか確認する（表の各行は本文で最低一度触れる）。「見誤っていた」等の執筆過程への自己言及は、その場面が本文に書かれているときだけ残す
7. 結びに本文未出の事実・数字・語彙が初出で置かれていないか確認する（結びは本文に既出の要素だけで組む。初出の新情報は本文へ移すか削る）。タイトル・descriptionが予告する結果・数字が本文で回収されているかも同時に確認する（結果が出る前に完了形で言い切らない）
8. 「半分」「大半」「ほとんど」等の割合表現に、何のうちの割合か（分母）が本文から一意に読めるか確認する
9. 修正後、検証結果の要約（項目・結果・修正した箇所）を添えて提出する

---

## 手順

### 1. 連番採番と雛形作成

ファイルは `content/YYYY/MM/DD/NNNN.md`（連番）。最大番号 +1 を採番する。

```bash
cd ~/Documents/nobu666.com
latest=$(find content -type f -name '*.md' -exec basename {} .md \; | sort -nr | head -n1)
echo "次の番号: $(( latest + 1 ))"
```

frontmatter は TOML（`+++`）。

```toml
+++
date = "YYYY-MM-DDThh:mm:ss+09:00"
Tags = ["tech", "ai"]
title = "記事タイトル"
description = "120字程度の要約（検索・OGP用）"
images = ["/images/NNNN-ogp.png"]
+++
```

`date` は現在時刻以前にすること（未来日時だと build されない）。雛形には `date '+%Y-%m-%dT%H:%M:%S+09:00'` の実行結果をそのまま入れ、キリのいい時刻を手打ちしない（数分未来なだけでもビルド対象外になり、`hugo -D` でも生成されない。`-D` はdraft用でfuture用ではない）。ビルドしたのに記事のhtmlが生成されないときは、最初に date を疑う（実例: 記事1050で2分未来のdateが原因でビルドされず、原因特定に回り道した）。

### 2. 本文執筆

- 既存記事のトーンに合わせる。直近の記事を2〜3本読んでから書く（口語・具体的、結論に自分の体温を入れる）
- 求められていない機能説明・一般論を盛らない。実体験と具体を優先
- 記事の主張が外部の製品・サービス・発表の仕様に依存する場合、執筆前に一次情報（公式ドキュメント・原文）を取得し、依拠する記述を列挙してから書く。レビューSubagentは検算であって取材ではない。裏取りをレビュー工程に先送りしない（実例: 記事1049でKiroの動作を二次情報で書き、公式docs確認後に芯ごと書き直しになった）

文体ルール:

- 一人称は「俺」（「私」「僕」は使わない）。これは nobu666.com 固有の好み
- AIっぽい言い回し・太字の乱打・定型表現の除去は、このスキルで個別に管理しない。手順4の `humanizer-ja` に集約して任せる（ルールの正本はあちら）。新しく気づいたNG表現は humanizer-ja 側に足す

### 3. レビュー（Subagent）

書き上げたら Subagent で多観点レビュー（誤字脱字／論理の飛躍／事実整合性）。指摘を反映する。

構造レビュー（首尾一貫・回収漏れ・表と本文の矛盾・伏線の前出し）は subagent `reviewer-structure` に通す。記事の主張が外部サービスの仕様・価格・期限など一次情報で裏取りできる事実に依存する場合は subagent `fact-checker` にも通す（正本は各agent定義。上位モデル指定・裏取り手順はagent側に集約済み）。上記の自己検証チェックリストはレビューの代替にならない（実測: 記事1049はレビュー指摘11件、チェックリスト4項目を追加した記事1050でも8件。うちチェックリストで防げた種類は1件のみ。「ある・なし」の検査はルール化できるが「合っているか」の読解はできない）。

### 4. humanizer-ja を必ず適用

`/humanizer-ja content/YYYY/MM/DD/NNNN.md` を実行し、AIっぽい表現を除去する。**公開前の必須工程**。

### 5. 図の要否を判断（任意）

理解を助ける箇所があれば SVG 図を作り `static/images/NNNN-*.svg` に置く。
本文には `<img src="/images/NNNN-*.svg" alt="..." width="680">` で挿入。
既存図のスタイル（`static/images/1034-architecture.svg` 等）に合わせる：`#fafafa` 背景、角丸 rect、`-apple-system` フォント、矢印 marker。

### 6. OGP画像を数種類生成

1200×630。`assets/ogp-style.css` と `assets/ogp-template.html` を使う。ヘッドレス Chrome でHTML→PNG。

```bash
mkdir -p /tmp/ogp-NNNN && cp .claude/skills/new-post/assets/ogp-style.css /tmp/ogp-NNNN/style.css
# assets/ogp-template.html を元に a.html〜d.html を作り、各案のslug/チップ/見出し/コマンドを差し替える
CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
for v in a b c d; do
  "$CHROME" --headless=new --disable-gpu --hide-scrollbars --force-device-scale-factor=1 \
    --window-size=1200,630 --screenshot="/tmp/ogp-NNNN/out-$v.png" "file:///tmp/ogp-NNNN/$v.html" >/dev/null 2>&1
done
open /tmp/ogp-NNNN/out-*.png   # OGP候補をプレビューで開く
```

**OGPを見せるときは記事本文も一緒に確認できるようにする。** この時点で手順8の `hugo server` を起動し、OGP候補（プレビュー）と記事URL（ブラウザ）を同時にユーザーへ渡す。OGP選択と本文レビューを1回で回せる。

採用案を `static/images/NNNN-ogp.png` にコピーして確定。
**タイトルとOGPの第一印象（見出し）を揃える**と効果的。ただし「揃える」は方向性の話で、**タイトルと同文の見出しにはしない**。SNSカードではOGP画像とタイトルが並んで表示されるため、同文だと情報が重複する。OGPには記事の一番強い数字・結果を置き、タイトルと補完し合う形にする（実例: 記事1050でタイトル同文の案でなく実測数字「8件中1件」の案を採用）。記事の芯と逆の印象を与える見出し（改善が効いたように読める等）は候補から外す。

デザインの型（既存OGPに準拠）：ダーク背景／左上に ● slug／右上に `# TECH # AI`／チップ列（最後の1つを緑でハイライト）／大見出し（緑アクセント可）／下部に区切り線＋`$ コマンド`（左, mono）と `nobu666`（右）。

### 7. ビルド確認

```bash
cd ~/Documents/nobu666.com && hugo --quiet; echo "exit: $?"
grep -o '<title>[^<]*</title>' public/YYYY/MM/DD/NNNN.html | head -1
grep -o 'og:image" content="[^"]*"' public/YYYY/MM/DD/NNNN.html | head -1
```

ローカルの最終確認は次の手順8で行う。

### 8. ブラウザでプレビューして確認を取る（公開前の必須ゲート）

`hugo server -D` をバックグラウンドで起動し、記事URLをユーザーに渡して**ブラウザで見てもらう**。OKが出るまで公開（date更新・commit・push）に進まない。手順6でOGPと一緒に起動済みなら、そのサーバを再利用する。

**`--baseURL http://localhost:1313/` を必ず付ける。** `config.toml` の `canonifyURLs = true` により、本文中の raw HTML の `<img src="/images/...">` は baseURL で絶対URL化される。`--baseURL` を付けずに起動する（または古いサーバプロセスが残っている）と、img の src が本番の `https://nobu666.com/...` を指してしまい、まだ push 前の画像（例: 新規追加した図）がプレビューで表示されない。起動前に既存の `hugo server` プロセスを止めてから、明示的に `--baseURL` 付きで起動し直すこと。

**構造的な変更（`.en.md` の追加等）をしたら、確認を待たずサーバを再起動する。** `--baseURL` 付きで起動していても、稼働中のサーバに新しい content ファイルを検知させると、内部リビルドの際に `config.toml` の `baseurl`（小文字、本番URL）に静かに戻る。記事1048・1050と2記事連続で再現しており、「戻っていたら再起動」ではなく「構造変更をしたら再起動してから確認」を手順にする。再起動後およびユーザーに最終確認を依頼する直前に、`curl -s http://localhost:1313/.../NNNN.html | grep -o '<img[^>]*>'` 等で src が `http://localhost:1313/...` になっているか確認する。

```bash
pkill -f "hugo server" 2>/dev/null
cd ~/Documents/nobu666.com && (hugo server -D --bind 127.0.0.1 --port 1313 --baseURL "http://localhost:1313/" >/tmp/hugo-server-NNNN.log 2>&1 &)
sleep 2
curl -s -o /dev/null -w "%{http_code}\n" http://localhost:1313/YYYY/MM/DD/NNNN.html
```

- 提示URL: `http://localhost:1313/YYYY/MM/DD/NNNN.html`
- 見てもらう点: 本文の流れ／図の見え方／結びの体温／前後記事とのつながり
- 直し要望は反映して再確認。**ユーザーのOKが出てから次へ**

### 9. 英語版の作成と推敲（任意）

日本語版がユーザーの確認OKを得た後（手順8の後）、英語版を作るかどうかユーザーに確認する。作る場合:

1. **翻訳**: `content/YYYY/MM/DD/NNNN.en.md` を作成する（Hugoの多言語機能は同一パス+`.en`サフィックスで自動的にペアリングされる）。
   - frontmatterは `date` / `Tags` / `images` は元記事のまま、`title` と `description` のみ翻訳する
   - 本文は逐語訳でなく、一人称・口語調の自然な英語に意訳する（技術ブログのトーン）
   - 見出し（`##`）・`<img>` タグ（`alt` のみ訳し `src`/`width` は不変）・記法はそのまま維持する
   - 本文中の内部リンク（他記事へのリンク）は、リンク先に英語版が無い限り日本語版のURLのままにする（存在しない `/en/...` パスを作らない）
   - 前提: `config.toml` の `[languages]` 設定とテーマの言語切替リンク（`layouts/partials/banner.html`）は導入済み。追加設定は不要

2. **推敲（英語版のhumanizer）**: `humanizer` スキル（本家blader版、`~/.claude/skills/humanizer/`）を適用する。仕上げに、定型語リストを目視でなく grep で機械的に検査する（`for w in "delve" "moreover" ...; do grep -io "$w" NNNN.en.md; done` の形。「機械で数えられるものは機械で数える」）。
   - 定番のAIくさい言い回し（"delve into", "moreover", "furthermore", "leverage", "robust", "seamless", "unlock", "landscape", "realm", "boasts", "in today's world", "it's worth noting", "testament to", "elevate", "dive into", "unpack", "game changer", "tapestry" 等）が無いか
   - 「In conclusion」「Overall, this shows」のような紋切り型の書き出し・締めが無いか
   - 冗長な言い回し（例: "already X before" の "before" が不要など）が無いか
   - 見つかった場合のみ最小限の修正をする。無ければ変更しない（変更のための変更はしない）

3. **OGP と図の英語版**: 日本語版の OGP・SVG を流用せず、英語版を別ファイルで作って `.en.md` から参照する（記事1059で指摘され、1056〜1058は流用していた）。
   - OGP: 採用案の HTML（手順6の `/tmp/ogp-NNNN/<案>.html`）のチップ・見出しを英訳して同じ手順で PNG 化し、`static/images/NNNN-ogp.en.png` に置く。`.en.md` の `images` をそれに変える。見出しが2行に収まるかを日本語版と同じく目視で確認する（英語は1行の文字数が増えて3行に折れやすい）
   - 図: SVG のラベルを英訳した `static/images/NNNN-xxx.en.svg` を作り、`.en.md` の `<img src>` をそれに変える。`alt` も英語にする。描画して文字のはみ出しを確認する

4. **ビルド確認**: `hugo --minify` でエラーが無いこと、`public/en/YYYY/MM/DD/NNNN.html` が生成されていることを確認する

5. **ブラウザ確認**: 手順8で起動したサーバで `http://localhost:1313/en/YYYY/MM/DD/NNNN.html` を開き、ヘッダーの言語切替リンク（日本語/English）が表示され、正しく行き来できることを確認する

### 10. SNS投稿文の提案

X（Twitter）と Facebook 用の投稿文をそれぞれ提案する。記事URLは `https://nobu666.com/YYYY/MM/DD/NNNN.html`。

**英語版（手順9）を作った場合、Facebook投稿文は日本語→英語の順で併記する。** 1つの投稿文の中に日本語段落と英語段落を両方入れ、URLは言語ごとに分けて置く。日本語段落の直後に日本語版URL（`https://nobu666.com/YYYY/MM/DD/NNNN.html`）、英語段落の直後に英語版URL（`https://nobu666.com/en/YYYY/MM/DD/NNNN.html`）。末尾にURLを1つだけまとめる形にはしない。Xは字数制限が厳しいため日本語のみでよい（英語版が別に欲しいと言われた場合のみ追加で用意する）。

**X投稿文は提案前に必ず文字数を確認する。** Xの280字制限はCJK文字を2字換算するため、日本語の文字数（`wc -m` 相当）をそのまま信用しない。URL部分は実際の長さに関わらず23字固定で数える。280字を超える場合は提案前に短縮する。

```python
import re
def x_weighted_len(s):
    total = 0
    for ch in s:
        cp = ord(ch)
        wide = [(0x1100,0x115F),(0x2E80,0xA4CF),(0xAC00,0xD7A3),(0xF900,0xFAFF),(0xFF00,0xFF60),(0xFFE0,0xFFE6),(0x20000,0x3FFFD)]
        total += 2 if any(lo <= cp <= hi for lo, hi in wide) else 1
    return total

def estimate(p):
    m = re.search(r'https?://\S+', p)
    body = p.replace(m.group(0), '') if m else p
    return x_weighted_len(body) + (23 if m else 0)
```

### 11. 完了報告

`CLAUDE.md`「完了報告」の形式（全体の流れ／修正内容の表／やっていないこと）で報告する。

---

## 注意

- **公開（commit & push）の直前に、記事 frontmatter の `date` を必ず現在日時へ更新する**。執筆から公開まで日をまたぐ（寝かせる）ことがあり、古い日付で公開されるのを防ぐため。
  ```bash
  now=$(date '+%Y-%m-%dT%H:%M:%S+09:00')   # 例: 2026-06-21T15:06:00+09:00
  # frontmatter の date = "..." をこの値に書き換えてから git add → commit
  ```
  - URL は `content/YYYY/MM/DD/` のパス由来。日付をまたいだら、必要に応じてファイルを新しい日付ディレクトリへ `git mv` する（URLが変わる点はユーザーに確認）。
  - 注意: `git mv` は索引の旧blobを移すので、**先に date 編集を `git add` してから** mv するか、mv 後にもう一度 `git add` すること（未ステージの編集を取りこぼさない）。
- **コミット・push は確認なしに実行しない**。`master` push で自動デプロイされるため、ユーザーの指示を待つ
- Conventional Commits（`feat:` 等）、本文は日本語。例: `feat: 記事(NNNN) ○○を追加`
- OGP候補の作業ファイルは `/tmp/` に置き、リポジトリには採用分（`NNNN-ogp.png`）のみ追加する
