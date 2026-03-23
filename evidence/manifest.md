# Evidence Manifest

## Claim: Tiny TQ2 training progressed far enough to save checkpoint step 6

- Date: 2026-03-23
- Script: [`../scripts/termux/run_finetune_tiny.sh`](../scripts/termux/run_finetune_tiny.sh)
- Evidence file: [`./logs/2026-03-23-finetune-tiny-snippet.txt`](./logs/2026-03-23-finetune-tiny-snippet.txt)
- Supporting lines expected:
  - `Training for 1 epochs`
  - `Optimizer: adamw ...`
  - `loss=3.04376`
  - `checkpoint_step_00000006/model.gguf`

## Claim: Fast TQ2 checkpoint inference produced a non-empty completion

- Date: 2026-03-23
- Script: [`../scripts/termux/run_infer_tq2_checkpoint6_fast.sh`](../scripts/termux/run_infer_tq2_checkpoint6_fast.sh)
- Evidence file: [`./logs/2026-03-23-infer-tq2-checkpoint6-fast-snippet.txt`](./logs/2026-03-23-infer-tq2-checkpoint6-fast-snippet.txt)
- Supporting lines expected:
  - `Mali-G52 MC2`
  - `offloaded 25/25 layers to GPU`
  - `checkpoint_step_00000006/model.gguf`
  - `A:`
  - `total time =`

