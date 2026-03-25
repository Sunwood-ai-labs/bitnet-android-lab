#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

pkg update -y
pkg install -y gotop htop bmon

cat <<'EOF'
Installed Termux monitoring tools:

- gotop: all-in-one CPU / memory / process / disk / network dashboard for SSH sessions
- htop: process-focused fallback if gotop renders poorly on your terminal
- bmon: network bandwidth monitor

Suggested usage:

  gotop
  htop
  bmon

Notes:

- These tools are for interactive observation, not benchmark-grade instrumentation.
- They can perturb timing, CPU load, or thermals during inference or fine-tuning.
- GPU counters and Android thermal sensors are still outside the scope of this repo.
EOF
