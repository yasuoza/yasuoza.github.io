---
title: "Code ServerとiPadでブログを書く"
date: 2020-08-27T20:49:53+09:00
---
{{<image src="hugo-code-server.jpeg">}}

このブログはHugoを利用して静的ファイルを生成している。一般的にはパソコンからHugoを起動してプレビューしつつ記事を書き、最後にビルドしてサイトに置くという使い方になるのだが、ブログを書くのにいちいちパソコンを開きたくなかったので、iPadでブログ記事を書けるようにした。もちろん、記事を書きつつブラウザでプレビューできることも必須要件だ。

<!--more-->

構成図というかイメージは冒頭の画像の通り。
ブログ記事のソースとなるMarkdownは[code-server](https://github.com/cdr/code-server)を利用している。
自宅ではSynologyのNASを利用していて、そのNASでDockerが動いているので、code-serverのイメージにHugoのバイナリを入れてDockerイメージを作成し、NASのDockerで動かしている。

Dockerfileはこんなかんじで

```dockerfile
FROM codercom/code-server:3.4.1

# Must be set as environment variable
ENV CODESERVER_PASSWORD='password'

ARG HUGO=0.74.3

COPY docker/git-credential-github-token /usr/local/bin
RUN git config --global credential.helper github-token && \
    sudo chmod +x /usr/local/bin/git-credential-github-token

COPY docker/code-server.yml /home/coder/.config/code-server/config.yaml
RUN sudo chown -R coder:coder /home/coder/.config

COPY docker/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN sudo chmod +x /usr/local/bin/entrypoint.sh

RUN mkdir -p /tmp/hugo && \
    curl -sSL "https://github.com/gohugoio/hugo/releases/download/v${HUGO}/hugo_extended_${HUGO}_Linux-64bit.tar.gz" | tar zx -C /tmp/hugo && \
    sudo cp /tmp/hugo/hugo /usr/local/bin/ && \
    rm -rf /tmp/hugo
EXPOSE 1313

USER coder
WORKDIR /home/coder
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/usr/bin/code-server", "--bind-addr", "0.0.0.0:8080", "."]
EXPOSE 8080
```

`docker-compose.yml`はこんなかんじ。

```yaml
version: '3.7'

services:
  code-server:
    image: hugo-coder-server
    container_name: hugo-coder-server
    build:
      context: .
    tty: true
    environment:
      CODESERVER_PASSWORD: $CODESERVER_PASSWORD
      GITHUB_USERNAME: $GITHUB_USERNAME
      GITHUB_TOKEN: $GITHUB_TOKEN      
      GIT_AUTHOR_NAME: $GIT_USERNAME
      GIT_COMMITTER_NAME: $GIT_USERNAME
      EMAIL: $GIT_USER_EMAIL
    working_dir: /home/coder/blog
    volumes:
      - '.:/home/coder/blog:cached'
    ports:
      - '8080:8080'
      - '1313:1313'
```

直接イメージからコンテナを起動する場合に必要な環境変数などは `docker-file.yml` を参考にして欲しい。

このDockerイメージはGitHubのPackagesにビルド済みのイメージを置いているので、イメージが欲しい場合は、`read:packages` 権限があるGitHubのアクセストークンを取得しておいて、

```bash
$ cat GITHUB_TOKEN.txt | docker login https://docker.pkg.github.com -u GitHubのユーザー名 --password-stdin
$ docker pull docker.pkg.github.com/yasuoza/yasuoza.github.io/hugo-code-server:latest
```

で `pull` することができる。
なお、SynologyのNASで利用する場合はコントロールパネルからSSHを有効にしてSSHでログインし、`pull` する必要がある。

あとはマウントするボリュームやアクセスするポートを設定すればブラウザからブログ記事を書くことができる。
ひとつ注意点としては、code-serverのUIDとGIDをホスト側から渡すか、割り切ってホスト側のディレクトリのパーミッションをcode-serverの
```
uid=1000(coder) gid=1000(coder) groups=1000(coder)
```
に設定しておかないと権限エラーでマウント先の `~/coder/project` に書き込むことができない。

一度Dockerコンテナを設定して、code-serverの方でワークスペースを作成しておけば、次回からはブラウザに `http://yourcodeserver:1313/?workspace=/home/coder/project/thisisyourworkspace.code-workspace` などと入力することで直接ワークスペースを開くことができるのでオススメ。
コンテナはブログを書く時だけ起動して、通常時にはコンテナを停止させておくという使い方もできる。
なお、Hugoとcode-serverを動かしている時はコンテナのメモリ使用量が630MB程度だったので参考まで。

VS Codeの拡張機能も使えるし、VS Codeそのものが快適なので、もはやパソコンから書くときもこのコンテナを利用してブラウザで書くというのもアリだなという気持ちになっている。