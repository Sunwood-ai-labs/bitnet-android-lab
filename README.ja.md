# bitnet-android-lab

[English README](./README.md)

Android 実機上の Termux と `adb forward` SSH を使って、QVAC Fabric BitNet の LoRA 微調整と推論を試したときの、公開向け lab note です。

## このリポジトリにあるもの

- 2026年3月23日の実機検証を整理した公開版メモ
- 1台の Xiaomi / Android 15 / Mali-G52 MC2 端末で動いた patched local `qvac-fabric-llm.cpp` source build の断片
- Termux 側 helper script
- ローカル workaround から切り出した最小 patch
- 実行証跡として公開できる形に整えた evidence snippet

これは公式配布物ではなく、再現と検証のための公開 lab note です。

## 確認できた範囲

| 項目 | 状態 | 補足 |
| --- | --- | --- |
| Windows -> `adb forward` -> SSH -> Termux 接続 | 確認済み | 公開版では鍵パスや端末シリアルは除去済み |
| 公式 `llama-b7336-bin-android.zip` をそのまま Termux CLI bundle として使う経路 | 未確認 | この検証では Android app build artifact に見えた |
| patched local source build on Termux | 確認済み | upstream commit `a218e05479cc019dfa592a7fae2d6d82065012cc` 基準 |
| TQ1 base + 公開 biomedical adapter 推論 | 確認済み | 実機 smoke run |
| TQ2 tiny LoRA checkpoint progression | 確認済み | あくまで smoke test |
| TQ2 checkpoint ベース fast inference | 確認済み | 短縮設定で 1 件の非空応答を確認 |

## 実機スペック

2026年3月25日に接続中の実機から再確認した値:

| 項目 | 値 |
| --- | --- |
| ブランド / 型番 | Xiaomi `2409BRN2CL` |
| 市販名 | `Redmi 14C` |
| device codename | `pond` |
| Android | `15` |
| Android SDK | `35` |
| SoC vendor / model | Mediatek `MT6769` |
| board platform | `mt6768` |
| CPU ABI | `arm64-v8a` |
| CPU コア数 | `8` |
| CPU クラスタ構成 | `6` cores on `policy0` + `2` cores on `policy6` |
| CPU 最大周波数 | `1.70 GHz` (`0-5`), `2.00 GHz` (`6-7`) |
| CPU マイクロアーキテクチャ推定 | ARM part ID `0xd05` / `0xd0a` から、たぶん `6x Cortex-A55` + `2x Cortex-A75` |
| GPU | `Mali-G52 MC2` |
| Vulkan instance | `1.3.346` |
| GPU Vulkan API | `1.3.278` |
| GPU driver | ARM proprietary `v1.r49p1-03bet0.19498e0ae1d5dac223383c39a2e58f04` |
| 画面解像度 | `720x1640` |
| 画面 density | `320 dpi` |
| `/proc/meminfo` 上の RAM | `7849100 kB` |
| 確認時の `/data` 容量 | `223G total / 74G used / 149G avail` |
| Termux | GitHub `com.termux v0.118.3` |
| ビルド対象 | Vulkan 有効の `llama-cli` / `llama-finetune-lora` |

## 重要な注意点

- 成功したのは stock の Android 配布物ではなく、ローカル workaround を入れた source build です。
- TQ2 側の推論成功は、最終 `--output-adapter` ではなく `checkpoint_step_00000006/model.gguf` を使った一時 checkpoint ベースです。
- fast inference の成功は「端末上でテキスト生成が返った」ことの確認であり、品質評価や正答率の保証ではありません。
- 終了時に `FORTIFY: pthread_mutex_lock called on a destroyed mutex` が残るため、長時間運転や反復実行の安定性は未確認です。
- tiny 学習では、入力 JSONL は 2 lines なのに runtime log は `datapoints=5` と出ており、ここは未解決です。
- CPU マイクロアーキテクチャ欄は `/proc/cpuinfo` の ARM part ID からの推定で、メーカーの公式マーケティング表記そのものではありません。

## 構成

- [`scripts/termux/`](./scripts/termux/) - Termux 側 helper script
- [`patches/qvac-fabric-llm.cpp/`](./patches/qvac-fabric-llm.cpp/) - local workaround から切り出した最小 diff
- [`prompts/`](./prompts/) - 推論 helper で使う prompt
- [`evidence/`](./evidence/) - ログ断片と claim 対応表
- [`docs/`](./docs/) - setup, findings, limitations, experiment log
- [`THIRD_PARTY.md`](./THIRD_PARTY.md) - upstream provenance

## 最短の見方

1. [`docs/setup-termux.md`](./docs/setup-termux.md) で前提レイアウトを確認する
2. [`patches/qvac-fabric-llm.cpp/`](./patches/qvac-fabric-llm.cpp/) の patch を upstream commit に当てる
3. `QVAC_ROOT` 配下に model / adapter / dataset を置く
4. [`scripts/termux/`](./scripts/termux/) の script を実行する
5. [`evidence/logs/`](./evidence/logs/) のログ断片と見比べる

## 証跡

- [`evidence/manifest.md`](./evidence/manifest.md)
- [`evidence/logs/2026-03-23-finetune-tiny-snippet.txt`](./evidence/logs/2026-03-23-finetune-tiny-snippet.txt)
- [`evidence/logs/2026-03-23-infer-tq2-checkpoint6-fast-snippet.txt`](./evidence/logs/2026-03-23-infer-tq2-checkpoint6-fast-snippet.txt)

## 追加ドキュメント

- [`docs/setup-termux.md`](./docs/setup-termux.md)
- [`docs/experiment-log.md`](./docs/experiment-log.md)
- [`docs/findings.md`](./docs/findings.md)
- [`docs/limitations.md`](./docs/limitations.md)
