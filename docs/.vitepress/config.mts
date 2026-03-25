import { defineConfig } from "vitepress";

const repoUrl = "https://github.com/Sunwood-ai-labs/bitnet-android-lab";
const siteUrl = "https://sunwood-ai-labs.github.io/bitnet-android-lab/";

export default defineConfig({
  title: "bitnet-android-lab",
  description: "Public lab notes, patches, evidence, and monitoring helpers for QVAC BitNet LoRA experiments on Android Termux.",
  base: "/bitnet-android-lab/",
  cleanUrls: true,
  lastUpdated: true,
  head: [
    ["link", { rel: "icon", href: "/favicon.svg" }],
    ["meta", { property: "og:title", content: "bitnet-android-lab" }],
    ["meta", { property: "og:description", content: "Android Termux lab notes, patches, evidence, and monitoring helpers for QVAC BitNet LoRA experiments." }],
    ["meta", { property: "og:image", content: `${siteUrl}bitnet-android-lab-hero.svg` }]
  ],
  themeConfig: {
    logo: "/bitnet-android-lab-mark.svg",
    search: {
      provider: "local"
    },
    socialLinks: [
      { icon: "github", link: repoUrl }
    ],
    footer: {
      message: "Single-device lab evidence, not a general Android compatibility claim.",
      copyright: "Released with public-facing notes, patches, and evidence."
    }
  },
  locales: {
    root: {
      label: "English",
      lang: "en-US",
      themeConfig: {
        nav: [
          { text: "Guide", link: "/guide/setup-termux" },
          { text: "Results", link: "/results/experiment-log" },
          { text: "Reference", link: "/reference/evidence" },
          { text: "GitHub", link: repoUrl }
        ],
        sidebar: [
          {
            text: "Guide",
            items: [
              { text: "Overview", link: "/" },
              { text: "Termux Setup", link: "/guide/setup-termux" }
            ]
          },
          {
            text: "Results",
            items: [
              { text: "Experiment Log", link: "/results/experiment-log" },
              { text: "Findings", link: "/results/findings" }
            ]
          },
          {
            text: "Reference",
            items: [
              { text: "Limitations", link: "/reference/limitations" },
              { text: "Evidence Map", link: "/reference/evidence" }
            ]
          }
        ],
        outline: {
          label: "On this page"
        },
        docFooter: {
          prev: "Previous",
          next: "Next"
        },
        lastUpdated: {
          text: "Last updated"
        }
      }
    },
    ja: {
      label: "日本語",
      lang: "ja-JP",
      link: "/ja/",
      themeConfig: {
        nav: [
          { text: "ガイド", link: "/ja/guide/setup-termux" },
          { text: "結果", link: "/ja/results/experiment-log" },
          { text: "参照", link: "/ja/reference/evidence" },
          { text: "GitHub", link: repoUrl }
        ],
        sidebar: [
          {
            text: "ガイド",
            items: [
              { text: "概要", link: "/ja/" },
              { text: "Termux セットアップ", link: "/ja/guide/setup-termux" }
            ]
          },
          {
            text: "結果",
            items: [
              { text: "実験ログ", link: "/ja/results/experiment-log" },
              { text: "Findings", link: "/ja/results/findings" }
            ]
          },
          {
            text: "参照",
            items: [
              { text: "制約", link: "/ja/reference/limitations" },
              { text: "Evidence 対応表", link: "/ja/reference/evidence" }
            ]
          }
        ],
        outline: {
          label: "このページ"
        },
        docFooter: {
          prev: "前へ",
          next: "次へ"
        },
        lastUpdated: {
          text: "最終更新"
        }
      }
    }
  }
});
