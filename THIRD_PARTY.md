# Third-Party Provenance

This repository does not redistribute model weights, datasets, or full upstream source trees.

## Upstream Code

- Project: `tetherto/qvac-fabric-llm.cpp`
- URL: <https://github.com/tetherto/qvac-fabric-llm.cpp>
- Commit used in this lab: `a218e05479cc019dfa592a7fae2d6d82065012cc`
- Local public artifacts derived from that code:
  - [`patches/qvac-fabric-llm.cpp/0001-termux-vulkan-device-create-info.patch`](./patches/qvac-fabric-llm.cpp/0001-termux-vulkan-device-create-info.patch)
  - [`patches/qvac-fabric-llm.cpp/0002-termux-disable-future-file-buffer.patch`](./patches/qvac-fabric-llm.cpp/0002-termux-disable-future-file-buffer.patch)

The patch files are minimal diffs extracted from the local Android/Termux workarounds used during the March 23, 2026 experiment.

## External Models And Data

These files were used during the experiment but are not included in this repository:

- `1bitLLM-bitnet_b1_58-xl-tq1_0.gguf`
- `1bitLLM-bitnet_b1_58-xl-tq2_0.gguf`
- `tq1_0-biomed-trained-adapter.gguf`
- Biomedical training JSONL from the referenced public repositories

See [`docs/setup-termux.md`](./docs/setup-termux.md) for the upstream URLs.

