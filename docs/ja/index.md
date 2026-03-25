---
layout: home
title: bitnet-android-lab
hero:
  name: "bitnet-android-lab"
  text: "実機 Android 上で試した QVAC BitNet LoRA"
  tagline: "Termux + Vulkan 実験のための公開 lab note、patch、evidence、監視ヘルパーをまとめた docs です。"
  image:
    src: /bitnet-android-lab/bitnet-android-lab-hero.svg
    alt: bitnet-android-lab hero
  actions:
    - theme: brand
      text: セットアップを見る
      link: /ja/guide/setup-termux
    - theme: alt
      text: 実験ログを見る
      link: /ja/results/experiment-log
    - theme: alt
      text: Evidence 対応表を見る
      link: /ja/reference/evidence
features:
  - title: Evidence を明示
    details: 公開 claim と log snippet の対応を維持し、曖昧な成功談ではなく再確認しやすい形で整理しています。
  - title: Termux 主体の手順
    details: 実機で通った Termux 側の build path、helper script、最小 patch を中心に記録しています。
  - title: 監視ヘルパー同梱
    details: Termux 側 TUI と Windows 側 adb watcher を用意し、Android 側負荷を観察しやすくしています。
---

## 概要

`bitnet-android-lab` は、実機 Android 端末で QVAC Fabric BitNet LoRA 微調整を試した公開 lab notebook です。接続経路は Termux と `adb forward` SSH を前提にしています。

この repo の主張は狭く保っています。

- Android 全般への広い互換性主張ではなく、1 台の実機で確認できた evidence を公開
- stock Android bundle ではなく、Termux 上で通った patched local source build の経路を記録
- model weight や dataset を同梱せず、公開できる script、patch、evidence に限定

## 検証済みスナップショット

- 2026-03-25 の再確認時点で、Xiaomi `2409BRN2CL` / `Redmi 14C`、Android `15`、Mediatek `MT6769`、Mali-G52 MC2 を確認
- 成功点は patched Termux build、TQ1 公開 adapter 推論、TQ2 checkpoint progression、TQ2 fast checkpoint inference
- `b7336` の Android release asset をそのまま Termux CLI bundle とみなす経路は未検証
- `tok/s` は benchmark ではなく単発 run の参照値

## まず読む順番

1. [Termux セットアップ](./guide/setup-termux.md)
2. [実験ログ](./results/experiment-log.md)
3. [制約](./reference/limitations.md)
4. [Evidence 対応表](./reference/evidence.md)

## 監視について

観察用として、以下の 2 系統を用意しています。

- Termux 側の `gotop` / `htop` / `bmon`
- Windows 側の `adb` watcher。メモリ / スワップのバー、各コア使用率バー、周波数、`dumpsys` 要約を表示

どちらも観察用途であり、ベンチマーク用の計測器ではありません。
