# Experiment Log

Date of the recorded lab session: March 23, 2026.

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
- Claim mapping: [`../evidence/manifest.md`](../evidence/manifest.md)

## Key Runtime Notes

- Device spec refresh on March 25, 2026:
  - market name: `Redmi 14C`
  - device codename: `pond`
  - SoC: Mediatek `MT6769` / board `mt6768`
  - CPU ABI: `arm64-v8a`
  - screen: `720x1640` at `320 dpi`
  - RAM from `/proc/meminfo`: `7849100 kB`
  - `/data` at check time: `223G total / 74G used / 149G avail`
- GPU seen by Vulkan: `Mali-G52 MC2`
- Successful fast inference settings: `-c 128 -b 8 -ub 8 --no-warmup -n 8`
- Checkpoint artifact used for fast inference: `checkpoint_step_00000006/model.gguf`

## Known Unresolved Items

- Final `--output-adapter` generation was not the verified success point for the public claim.
- `FORTIFY: pthread_mutex_lock called on a destroyed mutex` remained at shutdown.
- The tiny dataset line count and runtime `datapoints=5` log are still inconsistent.
