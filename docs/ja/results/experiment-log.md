# 実験ログ

ベースの lab 実行日は 2026-03-23、端末仕様と throughput 参照値の追跡確認日は 2026-03-25 です。

## 要約

- `adb forward` + SSH による Termux 接続は動作しました。
- 当時の Android release asset は、この lab ではそのまま使える Termux CLI bundle には見えませんでした。
- patched local source build により、Termux 上で `llama-cli` と `llama-finetune-lora` が動作しました。
- TQ1 と公開 biomedical adapter の推論が成功しました。
- TQ2 tiny training は checkpoint まで進行しました。
- TQ2 fast checkpoint inference では、短い completion を返しました。

## Evidence 参照

- [Evidence manifest](https://github.com/Sunwood-ai-labs/bitnet-android-lab/blob/main/evidence/manifest.md)
- [Training snippet](https://github.com/Sunwood-ai-labs/bitnet-android-lab/blob/main/evidence/logs/2026-03-23-finetune-tiny-snippet.txt)
- [Fast checkpoint inference snippet](https://github.com/Sunwood-ai-labs/bitnet-android-lab/blob/main/evidence/logs/2026-03-23-infer-tq2-checkpoint6-fast-snippet.txt)
- [TQ1 throughput rerun snippet](https://github.com/Sunwood-ai-labs/bitnet-android-lab/blob/main/evidence/logs/2026-03-25-infer-tq1-snippet.txt)
- [TQ2 throughput rerun snippet](https://github.com/Sunwood-ai-labs/bitnet-android-lab/blob/main/evidence/logs/2026-03-25-infer-tq2-fast-snippet.txt)

## 実行時スナップショット

- market name: `Redmi 14C`
- device codename: `pond`
- Android: `15`
- SoC: Mediatek `MT6769` / board `mt6768`
- CPU ABI: `arm64-v8a`
- CPU cluster: `1.70 GHz` までの 6 core と `2.00 GHz` までの 2 core
- ARM part ID からの推定 core type: `6x Cortex-A55` + `2x Cortex-A75`
- Vulkan 上で見えた GPU: `Mali-G52 MC2`
- `/proc/meminfo` の RAM: `7849100 kB`
- 確認時点の `/data`: `223G total / 74G used / 149G avail`

## 単発 Throughput 参照

prompt 処理、generation、end-to-end を分けて記録しています。

| Run | Prompt tokens | Prompt `tok/s` | Generation tokens | Generation `tok/s` | End-to-end `tok/s` | 補足 |
| --- | --- | --- | --- | --- | --- | --- |
| TQ1 base + 公開 biomedical adapter rerun (`2026-03-25`) | `18` | `0.17` | `63` | `0.63` | `0.39` | 公開 adapter 経路の単発 rerun |
| TQ2 fast checkpoint rerun (`2026-03-25`) | `18` | `0.21` | `7` | `0.13` | `0.18` | `checkpoint_step_00000006/model.gguf` を使った短縮設定 |

## 計算メモ

- TQ1 end-to-end throughput: `81 total tokens / 207.29636 s = 0.3907 tok/s`
- TQ2 end-to-end throughput: `25 total tokens / 138.11535 s = 0.1810 tok/s`
- prompt と generation の速度は rerun snippet の `common_perf_print` 行に対応します。
- end-to-end 値には model load、prompt eval、generation がすべて含まれます。

## 未解決事項

- 最終 `--output-adapter` 生成自体は公開成功点としては未検証です。
- 終了時には `FORTIFY: pthread_mutex_lock called on a destroyed mutex` が残っています。
- tiny dataset の行数と runtime の `datapoints=5` はまだ不一致です。
- 熱や repeated-run 安定性は未測定です。
