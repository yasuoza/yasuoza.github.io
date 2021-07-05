---
title: "homebridge-open-sesame"
date: 2021-07-05T13:45:58Z
---

{{<image src="homebridge-open-sesame.png">}}

[SESAME3](https://jp.candyhouse.co/collections/frontpage/products/sesame3)と[SESAME bot](https://jp.candyhouse.co/collections/frontpage/products/sesame3-bot)をHomeKitに組み込むHomebridgeプラグインを作った。

主な特徴は次の通り。

- 施錠/解錠状態のリアルタイム反映(手動での施錠/解錠を含む)
- プラグインではポーリングを行わないため、APIのレートリミットとなる可能性が低い
- SESAME3に加えてSESAME botも対応
- 複数のSESAME3を登録でき、Homeアプリでシーンを設定すれば1タップで複数の鍵を同時に操作できる

とくにリアルタイムに操作が反映される(そしてHomeアプリに通知を送遅らせることもできる)のはとても重要だ。
また、1つのタップで複数のSESAME3を同時に操作するのは現時点では公式のアプリでできないし、Appleのショートカットでも直列にしか操作できないため、かなり使い勝手が悪い。

<!--more-->

このプラグインを実装するに当たって、公式の[Web API](https://doc.candyhouse.co/ja/SesameAPI)に加えて、[pysesame3](https://github.com/mochipon/pysesame3)というPythonのライブラリを参考にした。
とくに、pysesame3は直接AWSのCognitoやAWS IoTと連携する処理を行っているため、その部分のコードを大いに参考にさせていただいた。
特徴にあるリアルタイム反映は、SESAME3が接続しているAWS IoTのmqttをこのプラグインでも利用させていただいていることで実現している。


homebridge-open-sesameのインストールと設定は[Homebridge Config UI X](https://github.com/oznu/homebridge-config-ui-x)を利用するとラクだ。
プラグインのタブを開いて「`Open Sesame`」と検索することで簡単にインストールできるし、そのまま設定できる。

設定に必要なAPIキーやCLIENT_IDは https://dash.candyhouse.co/ から取得できる。
UUIDやSecret Keyは https://sesame-qr-reader.vercel.app/ でSESAME3のQRコードを読み込ませることで取得できる。マネージャーかオーナー鍵でないとAPI操作できないので注意。

{{<image src="config-ui-x.png">}}

あとは取得した内容を先ほどのHomebridge Config UIにて設定すればOK。
我が家は鍵が2つあるタイプのドアなので、Homeアプリでシーンを設定して1タップで2つの鍵を同時に操作している。

一度HomeBridgeで設定してしまえば、あとはiPhoneやiPadのホームアプリでシーンを設定したり、通知の設定をしたりして自由に使うことができる。

個人的にはかなり便利なので、SESAME3ユーザーかつAppleユーザーの方でHomebridgeを導入できる人はぜひ使ってみて欲しい。
そしてフィードバックや要望をお待ちしています。