# Findings

## うまくいったこと

- `adb forward` 経由の SSH で Termux に接続できた
- 対象端末で Vulkan device discovery ができた
- patched local build の `llama-cli` と `llama-finetune-lora` が動いた
- 公開 biomedical adapter を使った TQ1 推論が通った
- TQ2 tiny LoRA training が checkpoint まで進んだ
- TQ2 checkpoint-based fast inference が短縮設定で通った

## きれいにはいかなかったこと

- `b7336` Android asset をそのまま Termux CLI bundle とみなす経路
- 最終 `--output-adapter` の public success case 検証
- repeated-run 安定性や production readiness の主張
- Android 15 で Termux 単体の CPU telemetry をそのまま信用すること

## 監視まわりの整理

いまの repo では、監視を 2 系統に分けています。

- Termux 側 TUI は手早い process / network 観察用
- Windows 側 `adb` watcher は各コア使用率バー、周波数、メモリ要約の観察用

Android の権限制限により、Termux 側だけでは読めない CPU 情報があるため、この分離が重要です。

## 推奨読書順

1. [Termux セットアップ](../guide/setup-termux.md)
2. [実験ログ](./experiment-log.md)
3. [制約](../reference/limitations.md)
4. [Evidence 対応表](../reference/evidence.md)
