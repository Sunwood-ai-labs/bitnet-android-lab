#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

QVAC_ROOT="${QVAC_ROOT:-$HOME/qvac-bitnet}"
UPSTREAM_DIR="${UPSTREAM_DIR:-$QVAC_ROOT/qvac-fabric-llm.cpp}"
BIN_DIR="${BIN_DIR:-$UPSTREAM_DIR/build-static/bin}"
MODEL_PATH="${MODEL_PATH:-$QVAC_ROOT/models/bitnet-xl.tq2_0.gguf}"
TRAIN_FILE="${TRAIN_FILE:-$QVAC_ROOT/data/train-mini.jsonl}"
OUTPUT_ADAPTER="${OUTPUT_ADAPTER:-$QVAC_ROOT/adapters/my-biomed-mini.gguf}"

cd "$UPSTREAM_DIR"

"$BIN_DIR/llama-finetune-lora" \
  -m "$MODEL_PATH" \
  -f "$TRAIN_FILE" \
  --output-adapter "$OUTPUT_ADAPTER" \
  -ngl 99 -c 128 -b 64 -ub 64 -fa off \
  --num-epochs 1
