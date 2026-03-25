# 制約

- この repository は 1 台の端末で得た lab 結果を記録したもので、広い Android 互換性を主張するものではありません。
- 成功した経路は、Termux 固有の workaround patch に依存しています。
- fast TQ2 inference は中間 checkpoint artifact を使っています。
- evidence が示しているのは短い非空 completion であり、品質 benchmark ではありません。
- 公開している `tok/s` は単発 run の参照値で、benchmark median や sustained-speed claim ではありません。
- 終了時には `FORTIFY` warning が残っています。
- 元の raw note には private path や device identifier が含まれていたため、公開 repo では除去・sanitization しています。
- 監視ヘルパーは観察補助であり、タイミングに影響したり package 名や process 名を表示したりする可能性があります。
