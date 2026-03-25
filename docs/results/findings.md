# Findings

## What Worked

- Termux access over SSH through `adb forward`
- Vulkan device discovery on the target phone
- Patched local build of `llama-cli` and `llama-finetune-lora`
- TQ1 inference with a published biomedical adapter
- TQ2 tiny checkpoint progression during LoRA fine-tuning
- TQ2 checkpoint-based fast inference with shortened settings

## What Did Not Work Cleanly

- Treating the `b7336` Android asset as a ready-to-run Termux CLI bundle
- Verifying the final `--output-adapter` path as the public success case
- Claiming repeated-run stability or production readiness
- Trusting Termux-local CPU telemetry alone for Android 15 resource inspection

## Monitoring Takeaway

The repository now carries two complementary monitoring routes:

- Termux-side TUIs for quick process and bandwidth inspection
- a Windows-side `adb` watcher for per-core CPU usage bars, frequency lines, and memory summaries

That split matters because newer Android permissions can limit what Termux-local `/proc` readers can see.

## Suggested Reading Order

1. [Termux Setup](../guide/setup-termux.md)
2. [Experiment Log](./experiment-log.md)
3. [Limitations](../reference/limitations.md)
4. [Evidence Map](../reference/evidence.md)
