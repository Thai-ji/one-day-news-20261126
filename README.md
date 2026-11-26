# One Day — Thursday 26 November 2026

[![make.fun competition](https://img.shields.io/badge/make.fun-news--image--20261126-1f5fa8)](https://make.fun/c/news-image-20261126)
[![GitHub repository](https://img.shields.io/badge/GitHub-Thai--ji%2Fone--day--news--20261126-16181d)](https://github.com/Thai-ji/one-day-news-20261126)
[![license: MIT](https://img.shields.io/badge/license-MIT-2e7d4f)](LICENSE)

A one-image newspaper front page summing up the world news of **Thursday 26 November 2026**: 36 stories from 9 regions, 13 original inline-SVG picture cards (3 large + 10 small), a 13-pin world map with 23 one-line briefs, a `THE DAY IN UTC` timeline, six key-number boxes and a date-check panel that separates out five items from other days.

## Files

| File | Purpose |
| --- | --- |
| `design.html` | The 1024×1024 page; all CSS and all 13 scenes are inline SVG. |
| `render.ps1` | Renders `design.html` to `entry.png` with Microsoft Edge headless (1024×1024, device scale 1). |
| `entry.png` | The submitted image: PNG, 1024×1024, well under 1 MiB. |
| `main.ts` | Entry program: validates the PNG and copies it to `$MAKEFUN_OUTPUT_DIR` (or `/output`). |

## Build

```powershell
# from this directory
powershell -NoProfile -ExecutionPolicy Bypass -File .\render.ps1
```

## Run the entry program

```powershell
# Node 22.18+ (or use --experimental-strip-types on 22.6–22.17)
mkdir out
$env:MAKEFUN_OUTPUT_DIR = "out"
node --experimental-strip-types main.ts
```

The program checks the PNG signature, the IHDR width/height (≤1024) and the 1,048,576-byte cap, then writes `entry.png` to the output directory unchanged.

## Layout

- Kicker: `THE WORLD IN ONE DAY` / `36 STORIES · 9 REGIONS · 41 SOURCES · 15 FIELDS`
- Masthead: `THURSDAY 26 NOVEMBER 2026`
- Stats strip (6 boxes), 9-segment region strip, `THE DAY IN UTC` timeline
- Row of 3 large picture cards (stories 1–3), two rows of 5 small picture cards (stories 4–13)
- Map band: 13 numbered pins + 23 one-line briefs (stories 14–36)
- `DATE CHECK` panel (5 excluded items) and credibility footer
