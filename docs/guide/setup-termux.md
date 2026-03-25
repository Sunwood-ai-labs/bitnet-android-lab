# Termux Setup

This guide describes the Termux-side layout and helper flow used in the public lab.

## Expected Layout

```text
$HOME/qvac-bitnet/
  models/
  adapters/
  data/
  checkpoints-tiny/
  qvac-fabric-llm.cpp/
```

## 1. Connect To Termux

The original lab used Windows host-side `adb forward` and SSH:

```powershell
adb forward tcp:8022 tcp:8022
ssh -p 8022 your-termux-user@127.0.0.1
```

Use your own SSH identity, key path, and host settings.

If you want to recreate the same host-to-device bootstrap path, the initial setup in this lab was done with the reusable [android-termux-ssh-bootstrap](https://github.com/Sunwood-ai-labs/android-termux-ssh-bootstrap-skill) skill. It covers ADB preparation, the GitHub Termux build, OpenSSH installation, public-key authentication, and `adb forward` SSH validation from a Windows host.

## 2. Prepare Packages

Install the packages needed for the Vulkan-enabled build:

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

Apply the public patches from this repository to that upstream commit:

- [Patch 0001](https://github.com/Sunwood-ai-labs/bitnet-android-lab/blob/main/patches/qvac-fabric-llm.cpp/0001-termux-vulkan-device-create-info.patch)
- [Patch 0002](https://github.com/Sunwood-ai-labs/bitnet-android-lab/blob/main/patches/qvac-fabric-llm.cpp/0002-termux-disable-future-file-buffer.patch)

Example:

```bash
git apply /path/to/0001-termux-vulkan-device-create-info.patch
git apply /path/to/0002-termux-disable-future-file-buffer.patch
```

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

The lab used upstream public assets from:

- <https://huggingface.co/qvac/fabric-llm-finetune-bitnet>
- <https://github.com/tetherto/qvac-rnd-fabric-llm-bitnet>

This repository does not redistribute those models or datasets.

## 7. Run The Helper Scripts

The helper scripts default to `QVAC_ROOT="$HOME/qvac-bitnet"` and can be overridden with environment variables.

- [Termux helper scripts](https://github.com/Sunwood-ai-labs/bitnet-android-lab/tree/main/scripts/termux)
- [Windows helper scripts](https://github.com/Sunwood-ai-labs/bitnet-android-lab/tree/main/scripts/windows)

## 8. Optional: Install Termux-Side Monitoring Tools

Install the optional TUI tools if you want a quick dashboard over SSH:

```bash
bash ./scripts/termux/install_monitoring_tools.sh
```

This installs:

- `gotop` for an all-in-one CPU, memory, process, disk, and network dashboard
- `htop` as a lighter process viewer fallback
- `bmon` for network-only bandwidth monitoring

Use them directly in the Termux SSH session:

```bash
gotop
htop
bmon
```

## 9. Optional: Watch Android Resources From Windows

Use the Windows watcher when you want Android-side stats without relying on Termux `/proc` access:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\windows\watch_android_resources.ps1
```

The watcher shows:

- memory and swap usage bars
- per-core CPU usage bars
- per-core current frequency lines
- `top` process rows
- `dumpsys cpuinfo` summary
- `dumpsys meminfo` summary

This is for live observation only. It can affect timing, and the output can include package and process names from the connected device.
