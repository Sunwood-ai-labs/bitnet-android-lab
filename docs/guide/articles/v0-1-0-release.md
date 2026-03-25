# Shipping `bitnet-android-lab` v0.1.0

![v0.1.0 release header](/releases/release-header-v0.1.0.svg)

`v0.1.0` turns the private Android BitNet lab work into a public, evidence-backed repository with scripts, patches, monitoring helpers, and published docs that other readers can inspect without needing the original local environment.

## What This Release Packages

The release bundles three layers of reproducibility:

- public helper scripts for the Termux-side fine-tuning and inference paths
- minimal Android-specific workaround patches extracted from the local `qvac-fabric-llm.cpp` build
- sanitized evidence, dated rerun snippets, and device notes that keep the claims anchored to observed behavior

Because this is the first release, it covers the full published history of the repository rather than a delta against an earlier tag.

## Why The Monitoring Work Matters

One of the most practical additions in the release is the split monitoring story:

- optional Termux TUIs for quick observation during SSH sessions
- a Windows-side `adb` watcher that can still see per-core CPU activity and memory state when Termux-local `/proc` readers are limited by newer Android permissions

That separation is important for Android 15-class devices, where process viewers inside Termux are still useful but not always authoritative for CPU telemetry.

## Docs And Operator Flow

`v0.1.0` also turns the repo into a published bilingual docs surface. The setup guide, findings, limitations, evidence map, and experiment log now live behind a VitePress site with CI and GitHub Pages deployment, so the release is not just a raw git snapshot.

The Termux SSH entry path used in the lab is now explicitly linked back to the reusable [android-termux-ssh-bootstrap](https://github.com/Sunwood-ai-labs/android-termux-ssh-bootstrap-skill) skill, making the host-to-device setup provenance easier to follow from Windows.

## Validation Snapshot

For this release pass, the collateral and docs path were checked with:

- SVG validation for the reused branding asset and the new versioned release header
- local `npm run docs:build --prefix docs`
- shell syntax validation for `scripts/termux/*.sh`
- PowerShell parser validation for the watcher and supporting scripts

GitHub Actions and Pages deployment are used as the final public verification path after the docs collateral is pushed.

## Read Next

- [Release notes for v0.1.0](../../reference/releases/v0.1.0.md)
- [Termux setup guide](../setup-termux.md)
- [Evidence map](../../reference/evidence.md)
