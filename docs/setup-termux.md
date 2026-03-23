# Termux Setup Notes

This repository assumes a Termux-side working directory like:

```text
$HOME/qvac-bitnet/
  models/
  adapters/
  data/
  checkpoints-tiny/
  qvac-fabric-llm.cpp/
```

## 1. Connect To Termux

The original lab used:

```powershell
adb forward tcp:8022 tcp:8022
ssh -p 8022 u0_a202@127.0.0.1
```

Use your own SSH identity and host settings.

## 2. Prepare Packages

Install the packages needed by the lab build:

```bash
pkg update -y
pkg install -y git cmake ninja clang make pkg-config python vulkan-loader-android vulkan-tools shaderc vulkan-headers
```

## 3. Clone Upstream

```bash
cd "$HOME/qvac-bitnet"
git clone https://github.com/tetherto/qvac-fabric-llm.cpp.git
cd qvac-fabric-llm.cpp
git checkout a218e05479cc019dfa592a7fae2d6d82065012cc
```

## 4. Apply The Local Workaround Patches

Copy the patch files from this repo and apply them:

```bash
git apply /path/to/0001-termux-vulkan-device-create-info.patch
git apply /path/to/0002-termux-disable-future-file-buffer.patch
```

The patches were generated from the public files in [`patches/qvac-fabric-llm.cpp/`](../patches/qvac-fabric-llm.cpp/).

## 5. Build Static Binaries

```bash
cmake -S . -B build-static -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DGGML_VULKAN=ON \
  -DGGML_OPENMP=OFF \
  -DGGML_LLAMAFILE=OFF \
  -DBUILD_SHARED_LIBS=OFF

cmake --build build-static --config Release -j2 --target llama-cli llama-finetune-lora
```

## 6. Fetch Models And Data

The lab used upstream public files from:

- <https://huggingface.co/qvac/fabric-llm-finetune-bitnet>
- <https://github.com/tetherto/qvac-rnd-fabric-llm-bitnet>

This repo intentionally does not bundle those assets.

## 7. Run The Helper Scripts

The scripts in [`scripts/termux/`](../scripts/termux/) default to `QVAC_ROOT="$HOME/qvac-bitnet"` and can be overridden with environment variables.

