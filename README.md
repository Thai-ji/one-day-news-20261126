# The World in One Day — Thursday 26 November 2026

[![make.fun news image](https://make.fun/badge/news-image-20261126.svg)](https://make.fun/bounty/news-image-20261126)
[![rank](https://make.fun/badge/news-image-20261126/Thai-ji/one-day-news-20261126/rank.svg)](https://make.fun/bounty/news-image-20261126)
[![reward](https://make.fun/badge/news-image-20261126/Thai-ji/one-day-news-20261126/reward.svg)](https://make.fun/bounty/news-image-20261126)

A one-page newspaper image summing up the world news of Thursday 26 November 2026. The page holds 36 stories from 9 regions: 13 illustrated cards, each with an original inline-SVG scene, followed by 23 one-line briefs beside a world map with 13 numbered pins. It also carries a six-box stats strip, a colour-coded region strip, a `THE DAY IN UTC` timeline of six editorial time slots, a date-check box listing events that are not from 26 November, and a credibility legend.

Files: `design.html` is the self-contained 1024×1024 page (all CSS inline, all artwork inline SVG); `render.ps1` renders it to `entry.png` with headless Microsoft Edge; `main.ts` validates and copies `entry.png` to `MAKEFUN_OUTPUT_DIR` (default `/output`); `entry.png` is the rendered image.

To render: run `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\render.ps1`, then `mkdir out` and `MAKEFUN_OUTPUT_DIR=out node --experimental-strip-types main.ts`. No network, no dependencies beyond Node 22 and Microsoft Edge.
