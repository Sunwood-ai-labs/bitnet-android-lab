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

## Recommended Reading Order

1. [`setup-termux.md`](./setup-termux.md)
2. [`limitations.md`](./limitations.md)
3. [`experiment-log.md`](./experiment-log.md)

