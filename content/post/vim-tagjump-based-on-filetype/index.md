---
title: "vimでファイルタイプに基づいたTagジャンプを行う"
date: 2020-09-10T10:14:15Z
---

基本的に普段はvimを使った開発をしていて、コードの補完やタグジャンプには[coc.nvim](https://github.com/neoclide/coc.nvim)を利用している。
TypeScript(JavaScript)やGoのタグジャンプはcoc.nvimとエクステンションを利用することでうまく行うことができる。だが、[solargraph](https://github.com/castwide/solargraph)を利用しているRubyではうまくタグジャンプできず、地味に困っていた。

<!--more-->

coc.nvimを導入する前は、[ripper-tags](https://github.com/tmm1/ripper-tags)でtagsファイルを事前に作成しておき、それを利用してvimデフォルトのタグジャンプ `:tag` を行っていた。ここ最近うまくタグジャンプできず不便なシーンが多発したので、solargraphのlspとripper-tagsのtagsファイルとでタグジャンプを比較してみた。その結果、圧倒的にripper-tagsを利用したtagsファイルに基づくタグジャンプのほうが正しくジャンプできた。

そのため、方針としては次の通りとした。

- vimで開いているbufferがRubyの場合は `tags` ファイルが存在すればタグジャンプに `:tag` を利用
- bufferがRubyでも `tags` ファイルが存在していなければcoc.nvimの `CocAction('jumpDefinition')` を利用
- Ruby以外はcoc.nvimの `CocAction('jumpDefinition')` を利用

で、コードは次の通り。これで、`Ctrl-]`でタグジャンプができる。

```vim
function! s:jump_definition()
  let tags_file = findfile('tags', expand('%:p:h').';'.$HOME, 1)
  if &filetype == 'ruby' && filereadable(expand(tags_file))
    execute 'tag '.RubyCursorTag()
  else
    call CocAction('jumpDefinition')
  endif
endfunction
nmap <silent> <C-]> :call <SID>jump_definition()<CR>
```

ポイントとしては `tags` ファイルの検索に制限を設ける点。システムルートまでたどるのではなく、今回はホームフォルダまで検索するようにした。
ホームフォルダより上のディレクトリで作業するというのもほとんどないので今はこれで十分。
もしルートディレクトリまで検索したい場合は、次のようにすればOK。

```vim
let tags_file = findfile('tags', expand('%:p:h').';/', 1)
```