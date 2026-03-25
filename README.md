# bitnet-android-lab

[日本語README](./README.ja.md)

Public lab notes, helper scripts, patches, and evidence for trying QVAC Fabric BitNet LoRA fine-tuning on a real Android phone through Termux and `adb forward` SSH.

## What This Repo Covers

- A real-device Android/Termux experiment, dated March 23, 2026
- A patched local `qvac-fabric-llm.cpp` source-build path that worked on one Xiaomi / Android 15 / Mali-G52 MC2 device
- Helper scripts for the Termux-side commands
- Minimal patch files extracted from the local Termux workarounds
- Evidence snippets that show the runs actually happened

This repository is not an official QVAC or Hugging Face release. It is a reproducibility-oriented lab notebook with sanitized, public-facing artifacts.

## Verified Scope

| Item | Status | Notes |
| --- | --- | --- |
| Windows -> `adb forward` -> SSH -> Termux access | Verified | Public repo does not include private key paths or device serials |
| Official `llama-b7336-bin-android.zip` behaving like a Termux CLI bundle | Not verified | In this lab it looked like Android app build artifacts, not a ready-to-run Termux CLI bundle |
| Patched local source build on Termux | Verified | Built against `tetherto/qvac-fabric-llm.cpp` commit `a218e05479cc019dfa592a7fae2d6d82065012cc` |
| TQ1 base model + published biomedical adapter inference | Verified | One-device smoke run |
| TQ2 tiny LoRA checkpoint progression | Verified | Smoke test only, checkpoint progression confirmed |
| TQ2 checkpoint-based fast inference | Verified | One short non-empty completion with shortened settings |

## Environment Snapshot

Confirmed again from the connected device on March 25, 2026:

| Item | Value |
| --- | --- |
| Brand / model | Xiaomi `2409BRN2CL` |
| Market name | `Redmi 14C` |
| Device codename | `pond` |
| Android | `15` |
| Android SDK | `35` |
| SoC vendor / model | Mediatek `MT6769` |
| Board platform | `mt6768` |
| CPU ABI | `arm64-v8a` |
| CPU cores | `8` total |
| CPU cluster layout | `6` cores on `policy0` + `2` cores on `policy6` |
| CPU max frequencies | `1.70 GHz` (cores `0-5`), `2.00 GHz` (cores `6-7`) |
| CPU microarchitecture guess | likely `6x Cortex-A55` + `2x Cortex-A75` from ARM part IDs `0xd05` / `0xd0a` |
| GPU | `Mali-G52 MC2` |
| Vulkan instance | `1.3.346` |
| GPU Vulkan API | `1.3.278` |
| GPU driver | ARM proprietary `v1.r49p1-03bet0.19498e0ae1d5dac223383c39a2e58f04` |
| Screen size | `720x1640` |
| Screen density | `320 dpi` |
| RAM seen by `/proc/meminfo` | `7849100 kB` |
| `/data` filesystem seen during the check | `223G total / 74G used / 149G avail` |
| Termux package used in the lab | GitHub `com.termux v0.118.3` |
| Build target | Vulkan-enabled `llama-cli` and `llama-finetune-lora` |

## Important Caveats

- The successful path used a local patched source build, not a stock official Android bundle.
- The TQ2 inference success used `checkpoint_step_00000006/model.gguf` as a temporary checkpoint artifact, not a verified final `--output-adapter`.
- The fast inference result proves text generation happened on-device. It does not prove answer quality or benchmark-level correctness.
- Any `tokens per second` (`tok/s`) figures in this repo are single-run throughput references documented in [`docs/experiment-log.md`](./docs/experiment-log.md), not benchmark medians or stock-device claims.
- Shutdown still emitted `FORTIFY: pthread_mutex_lock called on a destroyed mutex`, so repeated-run and long-run stability remain unverified.
- The tiny training smoke run still has one unresolved inconsistency: the input file was a 2-line subset, while runtime logs reported `datapoints=5`.
- The CPU microarchitecture row is an inference from ARM CPU part IDs exposed by `/proc/cpuinfo`, not a direct vendor marketing string.

## Repository Layout

- [`scripts/termux/`](./scripts/termux/) - Termux-side helper scripts, including an optional monitoring tool installer
- [`scripts/windows/`](./scripts/windows/) - Windows host-side helper scripts, including an `adb` resource watcher
- [`patches/qvac-fabric-llm.cpp/`](./patches/qvac-fabric-llm.cpp/) - Minimal diffs extracted from the local Termux workarounds
- [`prompts/`](./prompts/) - Prompt files used by the inference helpers
- [`evidence/`](./evidence/) - Captured log snippets and claim-to-evidence mapping
- [`docs/`](./docs/) - Setup notes, findings, limitations, and experiment log
- [`THIRD_PARTY.md`](./THIRD_PARTY.md) - Provenance for upstream code, models, and datasets referenced by this lab

## Quick Start

1. Read [`docs/setup-termux.md`](./docs/setup-termux.md) for the expected Termux layout and build steps.
2. Apply the patch files in [`patches/qvac-fabric-llm.cpp/`](./patches/qvac-fabric-llm.cpp/) to upstream commit `a218e05479cc019dfa592a7fae2d6d82065012cc`.
3. Place models, adapters, and datasets under `QVAC_ROOT` on the device. This repo does not ship model weights or datasets.
4. Use the scripts in [`scripts/termux/`](./scripts/termux/) with `QVAC_ROOT`, `UPSTREAM_DIR`, and prompt paths adjusted for your environment.
5. Compare your output against the evidence files in [`evidence/logs/`](./evidence/logs/).
6. Optionally install SSH monitoring tools with `bash ./scripts/termux/install_monitoring_tools.sh` if you want a live TUI dashboard during runs.
7. Optionally watch Android-side CPU and memory state from Windows with `powershell -File .\scripts\windows\watch_android_resources.ps1` for observation only; the live view can include package and process names.

## Evidence

- [`evidence/manifest.md`](./evidence/manifest.md) maps each public claim to scripts, dates, and evidence files.
- [`evidence/logs/2026-03-23-finetune-tiny-snippet.txt`](./evidence/logs/2026-03-23-finetune-tiny-snippet.txt) shows tiny training progression and checkpoint saves.
- [`evidence/logs/2026-03-23-infer-tq2-checkpoint6-fast-snippet.txt`](./evidence/logs/2026-03-23-infer-tq2-checkpoint6-fast-snippet.txt) shows the fast checkpoint inference run.
- [`evidence/logs/2026-03-25-infer-tq1-snippet.txt`](./evidence/logs/2026-03-25-infer-tq1-snippet.txt) shows a rerun of the published TQ1 adapter path with perf lines.
- [`evidence/logs/2026-03-25-infer-tq2-fast-snippet.txt`](./evidence/logs/2026-03-25-infer-tq2-fast-snippet.txt) shows a rerun of the shortened TQ2 checkpoint path with perf lines.

## Documentation

- [`docs/setup-termux.md`](./docs/setup-termux.md)
- [`docs/experiment-log.md`](./docs/experiment-log.md)
- [`docs/findings.md`](./docs/findings.md)
- [`docs/limitations.md`](./docs/limitations.md)

## Sources

- Hugging Face article: [LoRA Fine-Tuning BitNet b1.58 LLMs on Heterogeneous Edge GPUs via QVAC Fabric](https://huggingface.co/blog/qvac/fabric-llm-finetune-bitnet)
- Upstream code: [tetherto/qvac-fabric-llm.cpp](https://github.com/tetherto/qvac-fabric-llm.cpp)
- Model collection: [qvac/fabric-llm-finetune-bitnet](https://huggingface.co/qvac/fabric-llm-finetune-bitnet)
