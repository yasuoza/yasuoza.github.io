---
title: "Dockerコンテナを利用したRictyフォントのビルド"
date: 2021-03-08T12:23:50Z
---

[プログラミング用フォント Ricty](https://rictyfonts.github.io)をビルドするときにDockerを利用するメモ。
Homebrewのformulaを利用する方法は便利なんだけど、ビルドをするためだけに必要なライブラリが多い。そして、そのライブラリはビルドしたあとで不要になるので、いっそのことDockerを利用してビルドした環境を捨てられるようにする。

<!--more-->

方針としてはホスト側のディレクトリをdockerコンテナにマウントして、dockerコンテナで生成したフォントをその共有ディレクトリに移動して取り出すというもの。
コンテナのイメージは https://hub.docker.com/r/homebrew/brew  を利用する。

ホスト側の処理。

```shell
$ mkdir -p fonts
$ docker run --rm -it $PWD/fonts:/share homebrew/brew bash
```

コンテナ内の処理。

```shell
$ brew tap sanemat/font
$ brew install --with-powerline ricty
$ cp -f /home/linuxbrew/.linuxbrew/opt/ricty/share/fonts/Ricty*.ttf /share/fonts/
```

これでホスト側のfontsディレクトリからビルドしたRictyフォントを入手できるのでそれらをインストールする。
ホスト側でインストールした後はコンテナから`exit`すればOK。