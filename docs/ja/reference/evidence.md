# Evidence 対応表

このページでは、公開 claim ごとに supporting script と sanitized evidence snippet を対応付けています。

## Claim: tiny TQ2 training が checkpoint step 6 まで進んだ

- Date: `2026-03-23`
- Script: [run_finetune_tiny.sh](https://github.com/Sunwood-ai-labs/bitnet-android-lab/blob/main/scripts/termux/run_finetune_tiny.sh)
- Evidence: [2026-03-23-finetune-tiny-snippet.txt](https://github.com/Sunwood-ai-labs/bitnet-android-lab/blob/main/evidence/logs/2026-03-23-finetune-tiny-snippet.txt)
- 期待行: `Training for 1 epochs`, `Optimizer: adamw`, `loss=3.04376`, `checkpoint_step_00000006/model.gguf`

## Claim: fast TQ2 checkpoint inference が非空 completion を返した

- Date: `2026-03-23`
- Script: [run_infer_tq2_checkpoint6_fast.sh](https://github.com/Sunwood-ai-labs/bitnet-android-lab/blob/main/scripts/termux/run_infer_tq2_checkpoint6_fast.sh)
- Evidence: [2026-03-23-infer-tq2-checkpoint6-fast-snippet.txt](https://github.com/Sunwood-ai-labs/bitnet-android-lab/blob/main/evidence/logs/2026-03-23-infer-tq2-checkpoint6-fast-snippet.txt)
- 期待行: `Mali-G52 MC2`, `offloaded 25/25 layers to GPU`, `checkpoint_step_00000006/model.gguf`, `A:`, `total time =`

## Claim: TQ1 公開 adapter rerun が単発 throughput 参照値を示した

- Date: `2026-03-25`
- Command family: 既存の Windows -> `adb forward` -> SSH -> Termux 経路で `llama-cli` を直接 rerun
- Evidence: [2026-03-25-infer-tq1-snippet.txt](https://github.com/Sunwood-ai-labs/bitnet-android-lab/blob/main/evidence/logs/2026-03-25-infer-tq1-snippet.txt)
- 期待行: `$HOME/qvac-bitnet/models/bitnet-xl.tq1_0.gguf`, `$HOME/qvac-bitnet/adapters/tq1_0-biomed-trained-adapter.gguf`, `prompt eval time =`, `eval time =`, `total time =`

## Claim: TQ2 fast checkpoint rerun が短縮設定の単発 throughput 参照値を示した

- Date: `2026-03-25`
- Command family: 既存の Windows -> `adb forward` -> SSH -> Termux 経路で `llama-cli` を直接 rerun
- Evidence: [2026-03-25-infer-tq2-fast-snippet.txt](https://github.com/Sunwood-ai-labs/bitnet-android-lab/blob/main/evidence/logs/2026-03-25-infer-tq2-fast-snippet.txt)
- 期待行: `$HOME/qvac-bitnet/models/bitnet-xl.tq2_0.gguf`, `$HOME/qvac-bitnet/checkpoints-tiny/checkpoint_step_00000006/model.gguf`, `prompt eval time =`, `eval time =`, `total time =`

## 関連 provenance

- [Evidence folder README](https://github.com/Sunwood-ai-labs/bitnet-android-lab/blob/main/evidence/README.md)
- [Third-party provenance](https://github.com/Sunwood-ai-labs/bitnet-android-lab/blob/main/THIRD_PARTY.md)
- [Patch provenance](https://github.com/Sunwood-ai-labs/bitnet-android-lab/blob/main/patches/README.md)
