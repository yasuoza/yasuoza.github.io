---
title: "Goのerrgroupとセマフォを組み合わせるメモ"
date: 2020-09-04T05:11:02Z
---

Goの並列処理でセマフォを利用しつつ、[`errgroup`](https://pkg.go.dev/golang.org/x/sync/errgroup)を利用したエラー処理をしたい場面があったので、そのメモ。

バッチ処理で一定数を並列に処理したいのだけど、どこかのバッチで失敗した場合にそれ以降のバッチはすべて行わないようにしたい。

たとえば、次のパターン。

- `[0, 1, 2]`
- `[3, 4, 5]`
- `[6, 7, 8]`

この組み合わせでこの順に処理が3並列で行われるケースを考える。1つめのバッチでは`[0, 1, 2]`を並列処理し、2つめのバッチでは`[3, 4, 5]`を並列処理するというものだ。
このどこかのバッチ処理でエラーが発生した場合には後続のバッチ処理を行わないようにしたい。

<!--more-->

次のサンプルコードでは2個めのバッチ処理(`[3, 4, 5]`)でエラーを発生させ、3個めのバッチ処理では処理を行わないようにしたい。そこで、`errgroup.WithContext`を利用して、他のgoroutineのエラーをチェックを行なっている。
なお、今回の処理ではセマフォの重み付けが不要だったので、[`sync.semaphore`](https://pkg.go.dev/golang.org/x/sync/semaphore)ではなく`channel`を利用した簡易的なものを使っている。


```go
package main

import (
	"context"
	"errors"
	"fmt"
	"time"

	"golang.org/x/sync/errgroup"
)

func heavyTask(i int) error {
	const tg = 5
	if i == tg { // fake error
		msg := fmt.Sprintf("%d is not acceptable", i)
		fmt.Printf("%s. we're failing\n", msg)
		return errors.New(msg)
	}
	fmt.Println(i)
	time.Sleep(2 * time.Second)
	return nil
}

func main() {
	// cheap semaphore implementation
	sem := make(chan bool, 3)

	g, ctx := errgroup.WithContext(context.Background())
	for i := 0; i < 10; i++ {
		sem <- true

		// Capture `i` variable to use go func
		i := i
		g.Go(func() error {
			defer func() { <-sem }()
			select {
			case <-ctx.Done():
				// groutine started.
				// But the context is set Done by another goroutine returned error.
				// So we do not execute heavyTask.
				fmt.Printf("canceled %d\n", i)
				return ctx.Err()
			default:
				return heavyTask(i)
			}
		})
	}

	if err := g.Wait(); err != nil {
		fmt.Printf("Fatal: %v\n", err)
	}
}
```

実行結果の例は次のようなかんじ。`[7, 8, 9]`のバッチは完全にキャンセルされている。
goroutineの実行タイミングで数字の順番がすこし変わったりはする。

```
2
0
1
3
5 is not acceptable. we're failing
4
canceled 6
canceled 7
canceled 8
canceled 9
Fatal: 5 is not acceptable
```

日常的に多く使うものではないけれど、goroutineとエラー処理を考えるいい例なのかなと思ったりした。

---

## Refereneces

- https://pkg.go.dev/golang.org/x/sync/errgroup