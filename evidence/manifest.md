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

## Claim: TQ1 published-adapter rerun provides a single-run throughput reference

- Date: 2026-03-25
- Command family: direct `llama-cli` rerun over the existing Windows -> `adb forward` -> SSH -> Termux path
- Evidence file: [`./logs/2026-03-25-infer-tq1-snippet.txt`](./logs/2026-03-25-infer-tq1-snippet.txt)
- Supporting lines expected:
  - `Mali-G52 MC2`
  - `$HOME/qvac-bitnet/models/bitnet-xl.tq1_0.gguf`
  - `$HOME/qvac-bitnet/adapters/tq1_0-biomed-trained-adapter.gguf`
  - `prompt eval time =`
  - `eval time =`
  - `total time =`

## Claim: TQ2 fast checkpoint rerun provides a shortened single-run throughput reference

- Date: 2026-03-25
- Command family: direct `llama-cli` rerun over the existing Windows -> `adb forward` -> SSH -> Termux path
- Evidence file: [`./logs/2026-03-25-infer-tq2-fast-snippet.txt`](./logs/2026-03-25-infer-tq2-fast-snippet.txt)
- Supporting lines expected:
  - `Mali-G52 MC2`
  - `$HOME/qvac-bitnet/models/bitnet-xl.tq2_0.gguf`
  - `$HOME/qvac-bitnet/checkpoints-tiny/checkpoint_step_00000006/model.gguf`
  - `prompt eval time =`
  - `eval time =`
  - `total time =`
