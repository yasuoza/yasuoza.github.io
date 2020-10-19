---
title: "Blogging with textlint"
date: 2020-10-19T11:54:55Z
---

ブログのエントリーを書くときに利用していた校正ツールを「[テキスト校正くん](https://marketplace.visualstudio.com/items?itemName=ICS.japanese-proofreading)」から「[textlint](https://textlint.github.io)」に乗り換えた。

テキスト校正くんが決してダメというわけではなく、自分好みの校正設定を行いたかったので乗り換えることにした。むしろ、テキスト校正くんは手軽に校正なのだを導入できるという点で素晴らしい拡張だと思っている。

<!--more-->

さて、前述の通り、テキスト校正くんはVS Codeに拡張を導入するだけで使えてとても便利だし、それでいて最低限の校正も行なってくれる。が、いろいろと校正ツールを調べていくうちに、技術文書向けのtextlintルールプリセットである、[textlint-rule-preset-ja-technical-writing](https://github.com/textlint-ja/textlint-rule-preset-ja-technical-writing)を見つけた。ブログ記事を読む分には結構良さそう、ということで物は試し、早速導入してみる。

Node.jsに慣れていれば、textlintを導入こと自体は簡単。

- Node.jsをインストールする
- npmやyarnを利用してtextlint、その他必要なパッケージをインストールする
- `textlint --init` をして設定ファイルを出力
- 設定ファイルにルールを記述する

最後の `textlint --init` ではtextlintの設定ファイルがjson形式のファイルが出力される。しかし、textlintのドキュメントでは `json`、`js`、`yaml` で書くことができるとなっている。そこで、慣れ親しんでいるYAML形式で書くため、`.textlintrc.yml` としてYAMLで設定を書いている。
さらに、textlint-rule-preset-ja-technical-writingに加えて、ひらがなの方が好ましい助詞などをチェックできるプラグインも導入する。

```shell
yarn add -D \
    textlint-rule-ja-hiragana-fukushi \
    textlint-rule-ja-hiragana-hojodoushi \
    textlint-rule-ja-hiragana-keishikimeishi
```

今使っている設定ファイルはこんなかんじ。yaml形式にしたことで、正規表現の記述が楽になっていい。

```yaml
filters: 
rules:
  ja-hiragana-fukushi: true
  ja-hiragana-hojodoushi: true
  ja-hiragana-keishikimeishi: true

  # From textlint-rule-preset-ja-technical-writing
  preset-ja-spacing: true
  preset-ja-technical-writing: 
    ja-no-mixed-period:
      allowPeriodMarks:
        # Hugo shortcode
        - ">}}"
        # Code block
        - "```"
    ja-no-weak-phrase: false
    sentence-length:
      max: 100
      exclusionPatterns:
        # URL (Light)
        - /https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)/
        # Hugo shortcode
        - /{{</*\s+.*\s+*/>}}/
  spellcheck-tech-word: true
```

ブログ記事の成長とともに校正ツールの設定も変わっていくだろうけど、校正の土台はできたので今後はこれを育てていきたい。