# Experiment Log

Base lab session: March 23, 2026. Follow-up runtime spot checks for device specs and throughput references: March 25, 2026.

## Summary

- Device access over `adb forward` + SSH was working.
- The then-current Android release asset did not look like a ready-to-run Termux CLI bundle in this lab.
- A patched local source build on Termux produced working `llama-cli` and `llama-finetune-lora` binaries.
- TQ1 + published adapter inference succeeded.
- TQ2 tiny training progressed through checkpoints.
- TQ2 fast checkpoint inference returned a short completion with shortened settings.

## Evidence Pointers

- Training snippet: [`../evidence/logs/2026-03-23-finetune-tiny-snippet.txt`](../evidence/logs/2026-03-23-finetune-tiny-snippet.txt)
- Fast inference snippet: [`../evidence/logs/2026-03-23-infer-tq2-checkpoint6-fast-snippet.txt`](../evidence/logs/2026-03-23-infer-tq2-checkpoint6-fast-snippet.txt)
- TQ1 throughput rerun snippet: [`../evidence/logs/2026-03-25-infer-tq1-snippet.txt`](../evidence/logs/2026-03-25-infer-tq1-snippet.txt)
- TQ2 throughput rerun snippet: [`../evidence/logs/2026-03-25-infer-tq2-fast-snippet.txt`](../evidence/logs/2026-03-25-infer-tq2-fast-snippet.txt)
- Claim mapping: [`../evidence/manifest.md`](../evidence/manifest.md)

## Key Runtime Notes

- Device spec refresh on March 25, 2026:
  - market name: `Redmi 14C`
  - device codename: `pond`
  - SoC: Mediatek `MT6769` / board `mt6768`
  - CPU ABI: `arm64-v8a`
  - CPU clusters: `6` cores at up to `1.70 GHz` + `2` cores at up to `2.00 GHz`
  - likely CPU core types from ARM part IDs: `6x Cortex-A55` + `2x Cortex-A75`
  - screen: `720x1640` at `320 dpi`
  - RAM from `/proc/meminfo`: `7849100 kB`
  - `/data` at check time: `223G total / 74G used / 149G avail`
- GPU seen by Vulkan: `Mali-G52 MC2`
- GPU Vulkan API / driver: `1.3.278` / `v1.r49p1-03bet0.19498e0ae1d5dac223383c39a2e58f04`
- Successful fast inference settings: `-c 128 -b 8 -ub 8 --no-warmup -n 8`
- Checkpoint artifact used for fast inference: `checkpoint_step_00000006/model.gguf`

## Single-Run Throughput Reference (`tok/s`)

`Tokens per second` (`tok/s`) is the most common quick-look throughput metric for LLM inference. For this repo, the table below separates prompt processing, generation, and wall-clock end-to-end throughput so the numbers are not conflated.

| Run | Prompt tokens | Prompt `tok/s` | Generation tokens | Generation `tok/s` | End-to-end `tok/s` | Notes |
| --- | --- | --- | --- | --- | --- | --- |
| TQ1 base + published biomedical adapter rerun (`2026-03-25`) | `18` | `0.17` | `63` | `0.63` | `0.39` | Single run on the published adapter path |
| TQ2 fast checkpoint rerun (`2026-03-25`) | `18` | `0.21` | `7` | `0.13` | `0.18` | Single run with shortened settings and `checkpoint_step_00000006/model.gguf` |

### Calculation Notes

- TQ1 end-to-end throughput was derived from `81 total tokens / 207.29636 s = 0.3907 tok/s`, using the `common_perf_print: total time` line.
- TQ2 end-to-end throughput was derived from `25 total tokens / 138.11535 s = 0.1810 tok/s`, again using the `common_perf_print: total time` line.
- Prompt and generation throughput values match the tool-reported `common_perf_print` lines from the rerun snippets.
- The derived end-to-end numbers include model load time, prompt evaluation time, and generation time together.
- The TQ2 rerun used `-c 128 -b 8 -ub 8 --no-warmup -n 8`, so that row is a shortened smoke configuration rather than a full-length serving profile.

## Known Unresolved Items

- Final `--output-adapter` generation was not the verified success point for the public claim.
- `FORTIFY: pthread_mutex_lock called on a destroyed mutex` remained at shutdown.
- The tiny dataset line count and runtime `datapoints=5` log are still inconsistent.
- Repeated-run stability and thermal variance were not characterized, so the `tok/s` figures above should be treated as single-run references rather than sustained-speed claims.
