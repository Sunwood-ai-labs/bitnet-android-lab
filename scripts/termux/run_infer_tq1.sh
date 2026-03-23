#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
REPO_ROOT=$(CDPATH= cd -- "$SCRIPT_DIR/../.." && pwd)
QVAC_ROOT="${QVAC_ROOT:-$HOME/qvac-bitnet}"
UPSTREAM_DIR="${UPSTREAM_DIR:-$QVAC_ROOT/qvac-fabric-llm.cpp}"
BIN_DIR="${BIN_DIR:-$UPSTREAM_DIR/build-static/bin}"
MODEL_PATH="${MODEL_PATH:-$QVAC_ROOT/models/bitnet-xl.tq1_0.gguf}"
LORA_PATH="${LORA_PATH:-$QVAC_ROOT/adapters/tq1_0-biomed-trained-adapter.gguf}"
PROMPT_FILE="${PROMPT_FILE:-$REPO_ROOT/prompts/biomed-fracture.txt}"
PROMPT="${PROMPT:-$(cat "$PROMPT_FILE")}"

cd "$UPSTREAM_DIR"

"$BIN_DIR/llama-cli" \
  -m "$MODEL_PATH" \
  --lora "$LORA_PATH" \
  -ngl 99 -c 512 -b 128 -ub 128 -fa off \
  -p "$PROMPT" \
  -n 64
