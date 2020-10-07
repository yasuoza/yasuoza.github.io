---
title: "Github CodespacesのBeta招待が来た"
date: 2020-10-07T14:50:33Z
---

{{<image src="codespaces-beta-invites.png">}}

今年の5月あたりに登録しておいたCodespacesのベータの招待がようやく来た。
ざっと触ってみた感想を書いておく。

<!--more-->

**良い点**

- GitHubのリポジトリから直で開発環境を開くことができて便利。
- [料金表](https://docs.github.com/en/free-pro-team@latest/github/developing-online-with-codespaces/about-billing-for-codespaces)を見ると結構安い。
- VS Codeの環境設定がクラウドで同期できるのでいちいち設定し直さなくて良いのが便利。
- そもそもVS Codeが便利。
- localhostのサーバーにトンネルしてブラウザで確認できる（もちろんGitHubユーザーの認証付き）。
- ファイル追加もブラウザで開いているVS Codeに直接D&Dで追加できて便利。

**あんまり良くない点**

- 言語のバージョンや使うライブラリを開発環境の起動とともに使うにはDockerイメージをビルドしてDockerHubに登録しておく必要がある。
- iPadとの相性があんまり良くない。マウスのスクロールやポートフォワードのタブをクリックで開けない時が多い。

くらいかな。Codespacesはステートレスな開発環境なので、データベースとそのデータを別途用意する必要があるwebアプリケーションとかを本気で開発するには向かないと思った。
ただ、サクッと開発環境を立ち上げてパパッと手直ししたりするのにはとても向いている。
その、サクッと編集する目的のために開発用の動作環境をDockerHubに上げるのも面倒だとは思うが、テンプレートのようなDockerfileやCIの設定を行なってしまえば、あとはコピペでいけそう。

ベータの間は無料でCodespacesを使えるので、これまで自宅のNASで運用していたcode-serverをCodespacesに移行できないか検証していこうと思う。