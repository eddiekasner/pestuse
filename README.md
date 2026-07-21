# pestuse

Analyses of USGS Pesticide National Synthesis Project agricultural pesticide
use estimates, organized by state. Each state folder is self-contained (own
R Markdown source, own rendered output); shared inputs — the raw USGS
county-level and crop-group files, and the organophosphate/carbamate
classification — live at the repo root and are read by every state's
reports via relative paths (`../estimates/...`, `../data/...`).

**CHECK FOR UPDATES TO DATA.** Please carefully review the applications and
limitations of these data, as described on [this USGS National
Water-Quality Assessment (NAWQA) Project page](https://water.usgs.gov/nawqa/pnsp/usage/maps/about.php).

## Shared inputs

* `estimates/EPest.county.estimates.<year>.txt` (1992-2019) — USGS
  [Estimated Annual Agricultural Pesticide
  Use](https://water.usgs.gov/nawqa/pnsp/usage/maps/county-level/),
  county-level, EPest-low and EPest-high, all states. 2019 is a
  partial/preliminary release (69 compounds nationwide vs. ~400 in every
  other year) — see Chapter 3 caveats below.
* `estimates/HighEstimate_AgPestUsebyCropGroup92to19.txt` (1992-2019) —
  USGS Pesticide National Synthesis Project *EPest-high estimates by crop
  group*, state-level, all states, from [ScienceBase item
  6081ae7cd34e8564d6866222](https://www.sciencebase.gov/catalog/item/6081ae7cd34e8564d6866222).
* `data/op_carbamate_classification.csv` — organophosphate/carbamate
  classification for 36 compounds, compiled once in the Washington chapter
  and reused unchanged by every state.

---

## Washington (`washington/`)

Three chapters:

1. **`pestuse.Rmd` → `pestuse.pdf` / `pestuse.md`** — Yakima County
   top-pesticide ranking (2012-2016). Lists rank and EPest-high mass
   applied for the 80 most common pesticides in Yakima County, by 1-year,
   3-year average, and 5-year average. This chapter is county-specific and
   has no direct equivalent in the other state folders.
2. **`wa_op_carbamate_trends.Rmd` → `wa_op_carbamate_trends.html`** —
   interactive dashboard (flexdashboard) of statewide organophosphate and
   carbamate use, 1992-2019, overall and by USGS crop group.
3. **`wa_statewide_top_pesticides.Rmd` → `wa_statewide_top_pesticides.pdf`**
   — statewide top-80 pesticide ranking, 2014-2018, with OP/carbamate
   classification and a comparison to Yakima County's own ranking.

## Oregon (`oregon/`)

Two chapters, the state-parameterized ones from Washington (no Yakima-style
single-county chapter — see "Scope" below):

1. **`or_op_carbamate_trends.Rmd` → `or_op_carbamate_trends.html`** —
   same dashboard as Washington Chapter 2, FIPS 41.
2. **`or_statewide_top_pesticides.Rmd` → `or_statewide_top_pesticides.pdf`**
   — same ranking as Washington Chapter 3, FIPS 41 (no Yakima comparison
   column, since that was Washington-specific).

## Idaho (`idaho/`)

Same two chapters as Oregon, FIPS 16:
`id_op_carbamate_trends.Rmd` / `.html` and
`id_statewide_top_pesticides.Rmd` / `.pdf`.

## Alaska — not covered

No `alaska/` folder: both source files
(`estimates/EPest.county.estimates.*.txt` and
`estimates/HighEstimate_AgPestUsebyCropGroup92to19.txt`) contain **zero**
rows for Alaska (FIPS 02) in every year, 1992-2019. USGS's Pesticide
National Synthesis Project does not cover Alaska or Hawaii — this isn't a
gap in how these reports were built, there's no source data to report on.

## Scope note (why Oregon/Idaho only have 2 of Washington's 3 chapters)

Washington's Chapter 1 (Yakima County) is anchored to one specific county
chosen for its own reasons, not a "change the FIPS code" template like
Chapters 2 and 3 are — there's no obviously equivalent county to pick for
Oregon or Idaho. Chapters 2 and 3 are fully state-parameterized (set
`state_fips`/`state_name` at the top of the file) and were reused as-is.

## Rendering any chapter

Each `.Rmd` reads its inputs relative to its own folder, so render from
inside that folder, e.g.:

```r
setwd("oregon")
rmarkdown::render("or_statewide_top_pesticides.Rmd")
```

Dependencies: knitr, bookdown, dplyr, tidyr, readr, forcats, stringr,
ggplot2, scales, kableExtra (all chapters); flexdashboard, plotly, DT,
crosstalk (dashboard chapters only); a PDF engine — TeX including the
`longtable` and `ulem` packages (ranking/PDF chapters only).

---

[License](https://github.com/eddiekasner/pestuse/blob/master/LICENSE)
