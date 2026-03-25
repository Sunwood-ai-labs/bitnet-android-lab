# Experiment Log

Base lab session: March 23, 2026. Follow-up runtime spot checks for device specs and throughput references: March 25, 2026.

## Summary

- Device access over `adb forward` + SSH was working.
- The then-current Android release asset did not look like a ready-to-run Termux CLI bundle in this lab.
- A patched local source build on Termux produced working `llama-cli` and `llama-finetune-lora` binaries.
- TQ1 plus the published biomedical adapter inference succeeded.
- TQ2 tiny training progressed through checkpoints.
- TQ2 fast checkpoint inference returned a short completion with shortened settings.

## Evidence Pointers

- [Evidence manifest](https://github.com/Sunwood-ai-labs/bitnet-android-lab/blob/main/evidence/manifest.md)
- [Training snippet](https://github.com/Sunwood-ai-labs/bitnet-android-lab/blob/main/evidence/logs/2026-03-23-finetune-tiny-snippet.txt)
- [Fast checkpoint inference snippet](https://github.com/Sunwood-ai-labs/bitnet-android-lab/blob/main/evidence/logs/2026-03-23-infer-tq2-checkpoint6-fast-snippet.txt)
- [TQ1 throughput rerun snippet](https://github.com/Sunwood-ai-labs/bitnet-android-lab/blob/main/evidence/logs/2026-03-25-infer-tq1-snippet.txt)
- [TQ2 throughput rerun snippet](https://github.com/Sunwood-ai-labs/bitnet-android-lab/blob/main/evidence/logs/2026-03-25-infer-tq2-fast-snippet.txt)

## Runtime Snapshot

- market name: `Redmi 14C`
- device codename: `pond`
- Android: `15`
- SoC: Mediatek `MT6769` / board `mt6768`
- CPU ABI: `arm64-v8a`
- CPU clusters: `6` cores at up to `1.70 GHz` plus `2` cores at up to `2.00 GHz`
- likely CPU core types from ARM part IDs: `6x Cortex-A55` plus `2x Cortex-A75`
- GPU seen by Vulkan: `Mali-G52 MC2`
- RAM from `/proc/meminfo`: `7849100 kB`
- `/data` at check time: `223G total / 74G used / 149G avail`

## Single-Run Throughput Reference

The repo separates prompt processing, generation, and end-to-end throughput so the numbers are not conflated.

| Run | Prompt tokens | Prompt `tok/s` | Generation tokens | Generation `tok/s` | End-to-end `tok/s` | Notes |
| --- | --- | --- | --- | --- | --- | --- |
| TQ1 base + published biomedical adapter rerun (`2026-03-25`) | `18` | `0.17` | `63` | `0.63` | `0.39` | Single run on the published adapter path |
| TQ2 fast checkpoint rerun (`2026-03-25`) | `18` | `0.21` | `7` | `0.13` | `0.18` | Shortened settings with `checkpoint_step_00000006/model.gguf` |

## Calculation Notes

- TQ1 end-to-end throughput: `81 total tokens / 207.29636 s = 0.3907 tok/s`
- TQ2 end-to-end throughput: `25 total tokens / 138.11535 s = 0.1810 tok/s`
- Prompt and generation rates came from the tool-reported `common_perf_print` lines in the rerun snippets.
- The end-to-end numbers include model load, prompt evaluation, and generation together.

## Known Unresolved Items

- Final `--output-adapter` generation was not the verified public success point.
- Shutdown still emitted `FORTIFY: pthread_mutex_lock called on a destroyed mutex`.
- The tiny dataset line count and runtime `datapoints=5` are still inconsistent.
- Thermal behavior and repeated-run stability were not characterized.
