# Release QA Inventory

## Release Context

- repository: `bitnet-android-lab`
- release tag: `v0.1.0`
- compare range: `initial release mode from root commit 0b6406f to main commit 79ca184 before tag creation`
- requested outputs: `GitHub release body, docs-backed release notes, companion walkthrough article`
- validation commands run: `powershell -ExecutionPolicy Bypass -File D:\Prj\gh-release-notes-skill\scripts\verify-svg-assets.ps1 -RepoPath . -Path docs/public/bitnet-android-lab-hero.svg,docs/public/bitnet-android-lab-mark.svg,docs/public/releases/release-header-v0.1.0.svg`, `npm run docs:build --prefix docs`, `Get-ChildItem scripts\termux -Filter *.sh | ForEach-Object { bash -lc "bash -n 'scripts/termux/$($_.Name)'" }`, `PowerShell parser validation for *.ps1`, `gh run view 23540861555 --repo Sunwood-ai-labs/bitnet-android-lab`, `gh run view 23540861535 --repo Sunwood-ai-labs/bitnet-android-lab`, `gh release view v0.1.0 --repo Sunwood-ai-labs/bitnet-android-lab --json url,name,body,publishedAt,isDraft,isPrerelease,tagName,targetCommitish`
- release URLs: `https://github.com/Sunwood-ai-labs/bitnet-android-lab/releases/tag/v0.1.0`, `https://sunwood-ai-labs.github.io/bitnet-android-lab/reference/releases/v0.1.0`, `https://sunwood-ai-labs.github.io/bitnet-android-lab/guide/articles/v0-1-0-release`, `https://sunwood-ai-labs.github.io/bitnet-android-lab/ja/reference/releases/v0.1.0`, `https://sunwood-ai-labs.github.io/bitnet-android-lab/ja/guide/articles/v0-1-0-release`
- post-release corrections: `refreshed docs/public/releases/release-header-v0.1.0.svg to remove text-overflow risk in narrow renderers and rewrote the GitHub release body in English after Pages published the updated asset`

## Claim Matrix

| claim | code refs | validation refs | docs surfaces touched | scope |
| --- | --- | --- | --- | --- |
| Initial public release packages a reproducible Android Termux BitNet lab with helper scripts, minimal workaround patches, and evidence-backed public claims | `scripts/termux/run_finetune_tiny.sh`, `scripts/termux/run_infer_tq1.sh`, `scripts/termux/run_infer_tq2_checkpoint6_fast.sh`, `patches/README.md`, `evidence/manifest.md` | `collect-release-context.ps1 target main`, `gh release view verification` | `README.md, README.ja.md` | `steady_state` |
| Monitoring support includes optional Termux TUIs and a Windows-side adb watcher with per-core CPU bars, frequency lines, and dumpsys summaries | `scripts/termux/install_monitoring_tools.sh`, `scripts/windows/watch_android_resources.ps1`, `docs/guide/setup-termux.md`, `docs/ja/guide/setup-termux.md` | `shell syntax check`, `PowerShell parser validation` | `README.md, README.ja.md, docs/guide/setup-termux.md, docs/ja/guide/setup-termux.md` | `path_specific` |
| The release ships with bilingual published docs, docs-backed release notes, a companion walkthrough article, and GitHub Pages automation | `.github/workflows/ci.yml`, `.github/workflows/pages.yml`, `docs/.vitepress/config.mts`, `docs/reference/releases/v0.1.0.md`, `docs/guide/articles/v0-1-0-release.md` | `docs build`, `CI run 23540861555`, `Pages run 23540861535` | `README.md, README.ja.md, docs/index.md, docs/ja/index.md` | `published_docs` |

## Steady-State Docs Review

| surface | status | evidence |
| --- | --- | --- |
| README.md | pass | Added latest v0.1.0 release-note and walkthrough links and re-checked scope wording against the final release body |
| README.ja.md | pass | Added the Japanese latest-release links and kept the bootstrap provenance aligned with the release docs |
| docs/index.md | pass | Added latest-release links so the English docs homepage points at the release notes and walkthrough article |
| docs/ja/index.md | pass | Added latest-release links so the Japanese docs homepage points at the release notes and walkthrough article |
| docs/guide/setup-termux.md | pass | Re-reviewed the setup flow and kept the android-termux-ssh-bootstrap provenance link aligned with the release collateral |
| docs/ja/guide/setup-termux.md | pass | Re-reviewed the Japanese setup guide and kept the bootstrap provenance aligned with the release collateral |

## QA Inventory

| criterion_id | status | evidence |
| --- | --- | --- |
| compare_range | pass | `powershell -ExecutionPolicy Bypass -File D:\Prj\gh-release-notes-skill\scripts\collect-release-context.ps1 -Target main` reported initial release mode from root commit `0b6406f` to `main` commit `79ca184` |
| release_claims_backed | pass | Release body, commit log, `git show` on `0b6406f`, `b0c49e9`, `ebd53a5`, and `7a30c68`, plus direct file inspection of scripts, evidence, and workflows |
| docs_release_notes | pass | `docs/reference/releases/v0.1.0.md, docs/ja/reference/releases/v0.1.0.md` |
| companion_walkthrough | pass | `docs/guide/articles/v0-1-0-release.md, docs/ja/guide/articles/v0-1-0-release.md` |
| operator_claims_extracted | pass | Claim matrix completed above and mirrored in the GitHub release body sections |
| impl_sensitive_claims_verified | pass | Inspected `scripts/windows/watch_android_resources.ps1`, `scripts/termux/install_monitoring_tools.sh`, `evidence/manifest.md`, `.github/workflows/ci.yml`, and `.github/workflows/pages.yml` |
| steady_state_docs_reviewed | pass | Reviewed and updated `README.md`, `README.ja.md`, `docs/index.md`, `docs/ja/index.md`, `docs/guide/setup-termux.md`, and `docs/ja/guide/setup-termux.md` |
| claim_scope_precise | pass | README, docs release notes, and release body all keep the scope to a single device, a patched Termux path, and non-benchmark throughput references |
| latest_release_links_updated | pass | Added `v0.1.0` release-note and walkthrough links to both READMEs and both docs homepages |
| svg_assets_validated | pass | `powershell -ExecutionPolicy Bypass -File D:\Prj\gh-release-notes-skill\scripts\verify-svg-assets.ps1 -RepoPath . -Path docs/public/bitnet-android-lab-hero.svg,docs/public/bitnet-android-lab-mark.svg,docs/public/releases/release-header-v0.1.0.svg` |
| docs_assets_committed_before_tag | pass | Release collateral was committed in `79ca184` and pushed to `main` before creating and pushing tag `v0.1.0` |
| docs_deployed_live | pass | `gh run view 23540861535 --repo Sunwood-ai-labs/bitnet-android-lab` succeeded, and the four docs URLs plus the release header asset returned HTTP `200` |
| tag_local_remote | pass | Local `git tag -l v0.1.0` returns the tag, and `git push origin v0.1.0` created the remote tag |
| github_release_verified | pass | `gh release edit v0.1.0 --repo Sunwood-ai-labs/bitnet-android-lab --notes-file <temp english notes>` plus `gh release view v0.1.0 --repo Sunwood-ai-labs/bitnet-android-lab --json url,name,body,publishedAt,isDraft,isPrerelease,tagName,targetCommitish` confirmed the English body, docs badge links, and release URL |
| validation_commands_recorded | pass | Validation commands are listed in Release Context and were executed during this release task |
| publish_date_verified | pass | `gh release view v0.1.0 --repo Sunwood-ai-labs/bitnet-android-lab --json publishedAt` reported `2026-03-25T12:27:09Z` |

## Notes

- blockers:
- waivers:
- post-release verification on 2026-03-25: live asset URL for `release-header-v0.1.0.svg` returned HTTP `200` after the refresh commit, and the GitHub release body was re-read after `gh release edit` to confirm the English rewrite
- follow-up docs tasks: consider adding dedicated docs navigation entries for release notes and article archives once there is a second tagged release
