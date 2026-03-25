# bitnet-android-lab

[日本語 README](./README.ja.md)

[![CI](https://github.com/Sunwood-ai-labs/bitnet-android-lab/actions/workflows/ci.yml/badge.svg)](https://github.com/Sunwood-ai-labs/bitnet-android-lab/actions/workflows/ci.yml)
[![Docs](https://github.com/Sunwood-ai-labs/bitnet-android-lab/actions/workflows/pages.yml/badge.svg)](https://github.com/Sunwood-ai-labs/bitnet-android-lab/actions/workflows/pages.yml)
[![GitHub Pages](https://img.shields.io/badge/docs-GitHub%20Pages-0f172a?logo=github)](https://sunwood-ai-labs.github.io/bitnet-android-lab/)

![bitnet-android-lab hero](./docs/public/bitnet-android-lab-hero.svg)

Public lab notes, patches, evidence, and monitoring helpers for trying QVAC Fabric BitNet LoRA fine-tuning on a real Android phone through Termux, `adb forward`, and a patched local Vulkan build.

This repository is intentionally narrow. It documents one real-device path that worked on March 23, 2026, plus follow-up spot checks from March 25, 2026. It is not an official QVAC or Hugging Face release, and it does not claim broad Android compatibility.

The Windows-to-Termux bootstrap used in this lab was set up with the reusable [android-termux-ssh-bootstrap](https://github.com/Sunwood-ai-labs/android-termux-ssh-bootstrap-skill) skill. That setup flow covers ADB preparation, the GitHub Termux build, OpenSSH installation, public-key authentication, and `adb forward` SSH validation from Windows.

## Verified Snapshot

| Area | Status | Notes |
| --- | --- | --- |
| Windows -> `adb forward` -> SSH -> Termux access | Verified | Public artifacts exclude private key paths and device serials |
| Patched local `qvac-fabric-llm.cpp` build on Termux | Verified | Built from upstream commit `a218e05479cc019dfa592a7fae2d6d82065012cc` |
| TQ1 base model + published biomedical adapter inference | Verified | Single-device smoke rerun with throughput references |
| TQ2 tiny LoRA checkpoint progression | Verified | Checkpoint progression reached step 6 |
| TQ2 checkpoint-based fast inference | Verified | One short non-empty completion with shortened settings |
| Official `llama-b7336-bin-android.zip` as a ready-to-run Termux CLI bundle | Not verified | In this lab it looked like Android app build artifacts rather than a turnkey CLI bundle |

## Quick Start

1. Read the setup guide in [`docs/guide/setup-termux.md`](./docs/guide/setup-termux.md) or the published docs at <https://sunwood-ai-labs.github.io/bitnet-android-lab/>.
2. Apply the patch files in [`patches/qvac-fabric-llm.cpp/`](./patches/qvac-fabric-llm.cpp/) to upstream commit `a218e05479cc019dfa592a7fae2d6d82065012cc`.
3. Place models, adapters, and datasets under your `QVAC_ROOT` on the device. This repository does not ship weights or datasets.
4. Run the helper scripts in [`scripts/termux/`](./scripts/termux/) with your environment-specific paths.
5. Compare outputs against [`evidence/manifest.md`](./evidence/manifest.md) and the sanitized snippets in [`evidence/logs/`](./evidence/logs/).

## Monitoring Helpers

Two monitoring paths are included for observation during runs:

- Termux-side TUI helpers via [`scripts/termux/install_monitoring_tools.sh`](./scripts/termux/install_monitoring_tools.sh): `gotop`, `htop`, and `bmon`
- Windows-side `adb` watcher via [`scripts/windows/watch_android_resources.ps1`](./scripts/windows/watch_android_resources.ps1): memory and swap bars, per-core CPU usage bars, per-core current frequencies, `top`, `dumpsys cpuinfo`, and `dumpsys meminfo`

Both paths are observation aids, not benchmark instrumentation. They can affect timing and may surface package or process names from the connected device.

## Repo Map

- [`docs/`](./docs/) contains the published guide, results, and reference notes
- [`evidence/`](./evidence/) maps public claims to dated log snippets
- [`patches/qvac-fabric-llm.cpp/`](./patches/qvac-fabric-llm.cpp/) stores the minimal Termux workaround patches
- [`scripts/termux/`](./scripts/termux/) stores the Termux-side helpers
- [`scripts/windows/`](./scripts/windows/) stores the Windows host-side helpers
- [`THIRD_PARTY.md`](./THIRD_PARTY.md) tracks upstream provenance

## Caveats

- The successful path used a local patched source build, not a stock official Android bundle.
- The TQ2 success case used `checkpoint_step_00000006/model.gguf` as an intermediate checkpoint artifact, not a verified final `--output-adapter`.
- The published `tok/s` values are single-run references, not benchmark medians or sustained-speed claims.
- Shutdown still emitted `FORTIFY: pthread_mutex_lock called on a destroyed mutex`, so repeated-run and long-run stability remain unverified.
- The tiny training smoke run still has an unresolved inconsistency between the two-line input subset and runtime `datapoints=5`.

## Docs

- Published site: <https://sunwood-ai-labs.github.io/bitnet-android-lab/>
- Guide: [`docs/guide/setup-termux.md`](./docs/guide/setup-termux.md)
- Results: [`docs/results/experiment-log.md`](./docs/results/experiment-log.md), [`docs/results/findings.md`](./docs/results/findings.md)
- Reference: [`docs/reference/limitations.md`](./docs/reference/limitations.md), [`docs/reference/evidence.md`](./docs/reference/evidence.md)

## Sources

- Hugging Face article: [LoRA Fine-Tuning BitNet b1.58 LLMs on Heterogeneous Edge GPUs via QVAC Fabric](https://huggingface.co/blog/qvac/fabric-llm-finetune-bitnet)
- Upstream code: [tetherto/qvac-fabric-llm.cpp](https://github.com/tetherto/qvac-fabric-llm.cpp)
- Model collection: [qvac/fabric-llm-finetune-bitnet](https://huggingface.co/qvac/fabric-llm-finetune-bitnet)
