# Termux セットアップ

このページでは、公開 lab で使った Termux 側の作業レイアウトと helper の流れをまとめます。

## 想定レイアウト

```text
$HOME/qvac-bitnet/
  models/
  adapters/
  data/
  checkpoints-tiny/
  qvac-fabric-llm.cpp/
```

## 1. Termux に接続する

元の lab では、Windows 側から `adb forward` と SSH を使いました。

```powershell
adb forward tcp:8022 tcp:8022
ssh -p 8022 your-termux-user@127.0.0.1
```

秘密鍵パスや host 設定は、自分の環境に合わせて置き換えてください。

同じ host-to-device bootstrap 経路を再現したい場合、この lab の初期セットアップには再利用可能な [android-termux-ssh-bootstrap](https://github.com/Sunwood-ai-labs/android-termux-ssh-bootstrap-skill) skill を使っています。Windows 側からの ADB 準備、GitHub 版 Termux、OpenSSH、公開鍵認証、`adb forward` を使った SSH 検証までを含む流れです。

## 2. パッケージを入れる

Vulkan 有効 build に必要な package を導入します。

```bash
pkg update -y
pkg install -y git cmake ninja clang make pkg-config python vulkan-loader-android vulkan-tools shaderc vulkan-headers
```

## 3. upstream を clone する

```bash
cd "$HOME/qvac-bitnet"
git clone https://github.com/tetherto/qvac-fabric-llm.cpp.git
cd qvac-fabric-llm.cpp
git checkout a218e05479cc019dfa592a7fae2d6d82065012cc
```

## 4. local workaround patch を適用する

公開 repo の patch をその upstream commit に適用します。

- [Patch 0001](https://github.com/Sunwood-ai-labs/bitnet-android-lab/blob/main/patches/qvac-fabric-llm.cpp/0001-termux-vulkan-device-create-info.patch)
- [Patch 0002](https://github.com/Sunwood-ai-labs/bitnet-android-lab/blob/main/patches/qvac-fabric-llm.cpp/0002-termux-disable-future-file-buffer.patch)

例:

```bash
git apply /path/to/0001-termux-vulkan-device-create-info.patch
git apply /path/to/0002-termux-disable-future-file-buffer.patch
```

## 5. static binary を build する

```bash
cmake -S . -B build-static -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DGGML_VULKAN=ON \
  -DGGML_OPENMP=OFF \
  -DGGML_LLAMAFILE=OFF \
  -DBUILD_SHARED_LIBS=OFF

cmake --build build-static --config Release -j2 --target llama-cli llama-finetune-lora
```

## 6. model と data を用意する

lab で使った公開 asset の参照先:

- <https://huggingface.co/qvac/fabric-llm-finetune-bitnet>
- <https://github.com/tetherto/qvac-rnd-fabric-llm-bitnet>

この repo には model や dataset 自体は含めません。

## 7. helper script を使う

helper script は `QVAC_ROOT="$HOME/qvac-bitnet"` を前提にしていますが、環境変数で上書きできます。

- [Termux helper scripts](https://github.com/Sunwood-ai-labs/bitnet-android-lab/tree/main/scripts/termux)
- [Windows helper scripts](https://github.com/Sunwood-ai-labs/bitnet-android-lab/tree/main/scripts/windows)

## 8. Termux 側の監視ツールを入れる

SSH 越しにざっくり見たいときは、任意で TUI ツールを入れます。

```bash
bash ./scripts/termux/install_monitoring_tools.sh
```

導入されるもの:

- `gotop`: CPU、メモリ、process、disk、network をまとめて見る
- `htop`: 軽めの process viewer
- `bmon`: network 専用の帯域確認

実行例:

```bash
gotop
htop
bmon
```

## 9. Windows 側から Android 資源を見る

Termux の `/proc` 制限に依存しない観察をしたい場合は、Windows watcher を使います。

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\windows\watch_android_resources.ps1
```

表示内容:

- メモリ / スワップのバー
- 各 CPU コア使用率バー
- 各コアの現在周波数
- `top` の主要 process 行
- `dumpsys cpuinfo` 要約
- `dumpsys meminfo` 要約

これは live observation 用です。計測値に影響することがあり、package 名や process 名が表示される場合もあります。
