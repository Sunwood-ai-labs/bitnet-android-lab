---
layout: home
title: bitnet-android-lab
hero:
  name: "bitnet-android-lab"
  text: "QVAC BitNet LoRA on a real Android phone"
  tagline: "Public lab notes, patches, evidence, and monitoring helpers for a real Termux + Vulkan experiment."
  image:
    src: /bitnet-android-lab-hero.svg
    alt: bitnet-android-lab hero
  actions:
    - theme: brand
      text: Read the setup guide
      link: /guide/setup-termux
    - theme: alt
      text: View the experiment log
      link: /results/experiment-log
    - theme: alt
      text: Inspect the evidence map
      link: /reference/evidence
features:
  - title: Reproducible evidence
    details: The repo keeps public claim-to-evidence mapping, trimmed logs, and dated rerun notes instead of hand-wavy success claims.
  - title: Termux-first workflow
    details: Helper scripts, minimal patches, and setup notes document the Termux-side path that actually worked on a real Android device.
  - title: Monitoring helpers
    details: Optional Termux and Windows-side monitors make it easier to inspect Android-side load without confusing those views with benchmark instrumentation.
---

## Overview

`bitnet-android-lab` is a public lab notebook for trying QVAC Fabric BitNet LoRA fine-tuning on a real Android phone through Termux and `adb forward` SSH.

The repository is intentionally narrow:

- one-device evidence rather than broad Android compatibility claims
- a patched local Termux source-build path rather than a stock Android bundle story
- public-facing scripts, patches, and evidence instead of bundled model weights or datasets

## Verified Snapshot

- Device path verified again on March 25, 2026: Xiaomi `2409BRN2CL` / `Redmi 14C`, Android `15`, Mediatek `MT6769`, Mali-G52 MC2
- Verified success points: patched Termux build, TQ1 published-adapter inference, TQ2 checkpoint progression, TQ2 fast checkpoint inference
- Not verified: treating the `b7336` Android release asset as a ready-to-run Termux CLI bundle
- Throughput figures are single-run `tok/s` references, not sustained benchmarks

## Start Here

1. Read [Termux Setup](./guide/setup-termux.md).
2. Review [Experiment Log](./results/experiment-log.md) for dated outcomes and throughput notes.
3. Read [Limitations](./reference/limitations.md) before generalizing any result.
4. Compare public claims against [Evidence Map](./reference/evidence.md).

## Monitoring

The repository includes both Termux-side and Windows-side observation helpers:

- `gotop`, `htop`, and `bmon` via the optional Termux installer
- a Windows `adb` watcher with memory and swap bars, per-core CPU usage bars, frequency lines, and `dumpsys` summaries

These tools are useful for live inspection but should not be treated as benchmark instrumentation.

## Latest Release

- [v0.1.0 release notes](./reference/releases/v0.1.0.md)
- [v0.1.0 walkthrough article](./guide/articles/v0-1-0-release.md)
