---
title: "GoでSwitchBotを動かす"
date: 2020-08-18T21:09:11+09:00
---

我が家ではホームIoTを自作していて、HomeKitやAlexaを駆使してエアコンを操作したり、テレビや照明を操作したりしている。
その中でも最も家族に評価されているのがお風呂の自動化だ。

お風呂を入れるにはお風呂場に行って換気扇を一時的に止め、それと同時にお湯を入れるスイッチを押す必要があるのだが、お風呂を入れるタイミングはだいたい家族で団らんしていたり、ゆっくりしているときなので、誰も立ち上がりたくなく、お風呂を入れるときにいつも小さなせめぎ合い起きていた。

この問題を解消するため、我が家では

- お風呂の換気扇のスイッチを押し、換気扇を一時的に止める。
- お湯を入れるスイッチを押す。

という2つのスイッチ操作を

{{< amazon asin="B07B7NXV4R" title="SwitchBot ボット スイッチ ボタンに適用 指ロボット スマートホーム ワイヤレス タイマー スマホで遠隔操作 アレクサ、Google home、HomePod、IFTTTに対応(ハブ必要)" >}}

を2つ利用して実現している。

このSwitchBotを操作するには

- スマートフォンアプリを都度開いて操作する。
- SwitchBot Hubを別途購入してAlexaやIFTTTと連携して操作する。
- 操作するコードを書いて操作する。

がある。

AlexaだけであればSwitchBot Hubを購入する方法が楽だが、[Node-Red](https://nodered.org/)を利用したHomeKit連携も作り込んでおり、Homeアプリ対応もしたかったので結局自分でコードを書くことにした。
ちなみに、このSwitchBotはBluetoothで操作することができ、[公式のサンプルコード](https://github.com/OpenWonderLabs/python-host)が公開されているのでそれが参考になる。
他にもサードパーティの[RoButton/switchbotpy](https://github.com/RoButton/switchbotpy)が公開されており、これがとても参考になった。

Goを選んだのはクロスコンパイルがあってホームIoTの母艦となっているRaspberry Pi Zero W向けにバイナリを出力できるから。他にもクロスコンパイルできる言語はあるけど、BLEのライブラリもある程度選べるGoを選択した。
リリース時のバイナリ生成もGitHub Actionsと[GoReleaser](https://goreleaser.com/)を利用して、ビルドの方法を忘れても良いような設定にした。

というわけで成果物はこちら。

{{< gh-card repo="yasuoza/switchbot" >}}

Raspberry Pi Zero W(ARM 6)で使う場合は

```bash
curl -SL https://github.com/yasuoza/switchbot/releases/latest/download/switchbot_linux_armv6.tar.gz -O
tar -xvzf switchbot_linux_armv6.tar.gz

# sudoなしでswitchbotを実行する場合
sudo setcap 'cap_net_raw,cap_net_admin+eip' ./switchbot
```

で利用できる。
