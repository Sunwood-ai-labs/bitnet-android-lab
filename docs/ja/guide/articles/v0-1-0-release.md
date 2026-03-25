# `bitnet-android-lab` v0.1.0 を公開

![v0.1.0 release header](/releases/release-header-v0.1.0.svg)

`v0.1.0` では、Android 上の BitNet lab 作業を、script、patch、監視ヘルパー、公開 docs を備えた evidence-backed repository として外から追える形にまとめました。元のローカル環境を知らなくても、公開情報だけで流れを追いやすくしたのがこの release の中心です。

## このリリースでまとまったもの

今回の release では、再確認性を 3 層でそろえています。

- Termux 側の fine-tuning / inference helper script
- local `qvac-fabric-llm.cpp` build から切り出した最小 Android workaround patch
- public claim を支える sanitized evidence、日付付き rerun snippet、device note

初回 release なので、前 tag との差分ではなく、公開されている履歴全体を対象にしています。

## 監視まわりを入れた意味

この release の実用面で大きいのは、監視経路を 2 系統に分けたことです。

- SSH 越しにすぐ見たいときの Termux 側 TUI
- Android の権限制限で Termux 単体では見えにくい CPU 情報を、Windows 側 `adb` watcher で補う経路

特に Android 15 系では、Termux 内の process viewer は便利でも、CPU telemetry の正しさまではそのまま信用できない場面があります。この release ではその整理を docs と script の両方に反映しました。

## Docs と運用導線

`v0.1.0` では、repo を日英対応の VitePress docs surface として公開しました。setup、findings、limitations、evidence map、experiment log を GitHub Pages で辿れるので、release が単なる git snapshot で終わらない形になっています。

また、この lab で使った Windows から Termux への接続経路については、再利用可能な [android-termux-ssh-bootstrap](https://github.com/Sunwood-ai-labs/android-termux-ssh-bootstrap-skill) skill と結び付けて、bootstrap provenance も追えるようにしました。

## 検証スナップショット

この release pass では、次の確認を通しています。

- 再利用した branding asset と versioned release header の SVG validation
- ローカル `npm run docs:build --prefix docs`
- `scripts/termux/*.sh` の shell syntax validation
- watcher を含む `*.ps1` の PowerShell parser validation

最後の公開確認は、push 後に GitHub Actions と Pages deployment で行います。

## 次に読むページ

- [v0.1.0 リリースノート](../../reference/releases/v0.1.0.md)
- [Termux セットアップ](../setup-termux.md)
- [Evidence 対応表](../../reference/evidence.md)
