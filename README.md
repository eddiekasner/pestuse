# pestuse

Analyses of USGS Pesticide National Synthesis Project agricultural pesticide
use estimates, organized by state. Each state folder is self-contained (own
R Markdown source, own rendered output); shared inputs — the raw USGS
county-level and crop-group files, and the pesticide chemical-class
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
* `data/pesticide_classification.csv` — all 402 compounds reported for
  WA/OR/ID classified into two independent dimensions: **`CHEMICAL_CLASS`**
  (13 named structural families — Organophosphorous compound,
  Pyrethrins/Pyrethroids, Triazines, Dithiocarbamates, and so on — plus a
  compact `CHEM_ABBREV` code used in the ranking-chapter tables, and an
  `Other` catch-all for chemistries outside those 13) and **`FUNCTIONAL_CLASS`**
  (what the compound is used for — Insecticide, Herbicide/algicide,
  Fungicide, Fumigant, Acaricide, Plant Growth Regulator, and others).
  Splitting these into two columns (rather than one column doing both jobs)
  fixed a real distortion in the first version of this repo: a handful of
  fumigants (metam, metam potassium, dichloropropene, chloropicrin) used to
  share a single "Fumigant" bucket that behaved like a *chemical* class,
  when fumigants are actually chemically diverse and applied at far higher
  per-acre rates than herbicides or insecticides — that made raw-mass
  comparisons across the old classes misleading. `FUNCTIONAL_CLASS` still
  correctly shows fumigants' true (large) total mass; `CHEMICAL_CLASS` now
  distributes that mass into the compounds' real chemistry instead of an
  artificial catch-all. Neither column comes from USGS metadata — USGS's
  data-release documentation for these files covers only structural columns
  (compound name, year, FIPS codes, crop-group amounts), not a
  compound-level chemical/functional crosswalk — so every compound was
  checked individually against pesticide chemistry/mode-of-action
  references. The requested `CHEMICAL_CLASS` taxonomy is a fairly classical
  one that predates several chemistries now in wide use (sulfonylurea and
  other ALS-inhibiting herbicides, DMI/SDHI/strobilurin fungicides,
  chloroacetanilide and dinitroaniline herbicides, neonicotinoid and diamide
  insecticides, and more), so roughly two-thirds of compounds land in
  `Other` for that column rather than an ill-fitting named family; see the
  Washington pesticide class trends chapter's Methodology page for the full
  rationale and worked examples. Compiled once in the Washington chapter
  and reused unchanged by every state.

**Note on comparing states/regions.** Washington, Oregon, and Idaho farm
very different total acreages and crop mixes. Every raw-mass comparison in
this repo (state vs. state, or state vs. the Pacific Northwest chapter) is
absolute kg, not normalized by farmland — a higher number means more mass
applied, not necessarily more intensive use.

---

## Washington (`washington/`)

Four chapters:

1. **`pestuse.Rmd` → `pestuse.pdf` / `pestuse.md`** — Yakima County
   top-pesticide ranking (2012-2016). Lists rank and EPest-high mass
   applied for the 80 most common pesticides in Yakima County, by 1-year,
   3-year average, and 5-year average. This chapter is county-specific and
   has no direct equivalent in the other state folders.
2. **`wa_pesticide_class_trends.Rmd` → `wa_pesticide_class_trends.html`** —
   interactive dashboard (flexdashboard) of statewide pesticide use by
   chemical class and functional class, 1992-2018, overall and by USGS
   crop group. Covers all 402 classified compounds, not just
   organophosphates and carbamates — an Overview and Static Plots page use
   `FUNCTIONAL_CLASS` as the chart color (11 categories, tractable as
   simultaneous series); the Interactive Portal and Compound Explorer pages
   use `FUNCTIONAL_CLASS`/`CHEMICAL_CLASS` as filters instead, since
   `CHEMICAL_CLASS` can't be plotted as a legible simultaneous series
   (most compounds fall into its `Other` bucket). 2019 is excluded (see
   caveats below).
3. **`wa_statewide_top_pesticides.Rmd` → `wa_statewide_top_pesticides.pdf`**
   — statewide top-80 pesticide ranking, 2014-2018, with each compound's
   chemical class (abbreviated, with a key table) and a comparison to
   Yakima County's own ranking.
4. **`wa_county_pesticide_use.Rmd` → `wa_county_pesticide_use.html`** —
   interactive dashboard (flexdashboard) of the county-level detail behind
   Chapters 2-3's statewide totals, 2014-2018 (same window as the ranking
   chapter). Overview and Static Plots pages show choropleth maps of county
   totals (offline, via the `maps`/`sf` packages) plus a top-10/top-15
   county bar chart; County Ranking mirrors the statewide ranking chapter's
   1yr/3yr-avg/5yr-avg format but for all 39 Washington counties; County
   Explorer and Compound Explorer are crosstalk portals for browsing by
   county, functional class, chemical class, and compound. USGS's own
   documentation cautions that these county-level figures are intended to
   be aggregated into state totals rather than read as precise
   county-by-county figures — the Overview and Methodology pages repeat
   this caveat prominently.

## Oregon (`oregon/`)

Three chapters, the state-parameterized ones from Washington (no
Yakima-style single-county chapter — see "Scope" below):

1. **`or_pesticide_class_trends.Rmd` → `or_pesticide_class_trends.html`**
   — same dashboard as Washington Chapter 2, FIPS 41.
2. **`or_statewide_top_pesticides.Rmd` → `or_statewide_top_pesticides.pdf`**
   — same ranking as Washington Chapter 3, FIPS 41 (no Yakima comparison
   column, since that was Washington-specific).
3. **`or_county_pesticide_use.Rmd` → `or_county_pesticide_use.html`** —
   same county-level dashboard as Washington Chapter 4, FIPS 41 (36 of 36
   Oregon counties reported use in the 2014-2018 window).

## Idaho (`idaho/`)

Same three chapters as Oregon, FIPS 16:
`id_pesticide_class_trends.Rmd` / `.html`,
`id_statewide_top_pesticides.Rmd` / `.pdf`, and
`id_county_pesticide_use.Rmd` / `.html` (44 of 44 Idaho counties reported
use in the 2014-2018 window).

## Pacific Northwest (`pacific_northwest/`)

The region-wide counterpart to the three state folders: Washington, Oregon,
and Idaho summed together, plus genuine state-vs-state comparisons that no
single-state chapter can show on its own.

1. **`pnw_pesticide_class_trends.Rmd` → `pnw_pesticide_class_trends.html`**
   — same dashboard as each state's Chapter 2, but combining all three
   states (FIPS 53/41/16). Overview, Interactive Portal, Compound Explorer,
   and most of Static Plots show WA+OR+ID **summed together**. A dedicated
   **State Comparison** page adds `STATE` as a third chart dimension (only
   3 values, safe to color directly, unlike the 13-value `CHEMICAL_CLASS`):
   an interactive combined trend line by state, plus a static "annual use
   by state, faceted by functional class" chart repeated on the Static
   Plots page.
2. **`pnw_regional_top_pesticides.Rmd` → `pnw_regional_top_pesticides.pdf`**
   — top-80 ranking summed across every WA+OR+ID county, 2014-2018, with
   **three** per-state rank columns (Rank WA / Rank OR / Rank ID) instead
   of Washington's single Yakima-comparison column — showing where each
   top compound concentrates, not just its regional total. The main table
   is 9 columns wide and doesn't fit a portrait page even at a small font,
   so it's the one table in this repo set in landscape.

## Alaska — not covered

No `alaska/` folder: both source files
(`estimates/EPest.county.estimates.*.txt` and
`estimates/HighEstimate_AgPestUsebyCropGroup92to19.txt`) contain **zero**
rows for Alaska (FIPS 02) in every year, 1992-2019. USGS's Pesticide
National Synthesis Project does not cover Alaska or Hawaii — this isn't a
gap in how these reports were built, there's no source data to report on.

## Scope note (why Oregon/Idaho only have 3 of Washington's 4 chapters)

Washington's Chapter 1 (Yakima County) is anchored to one specific county
chosen for its own reasons, not a "change the FIPS code" template like
Chapters 2-4 are — there's no obviously equivalent county to pick for
Oregon or Idaho. Chapters 2-4 are fully state-parameterized (set
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
crosstalk (dashboard chapters only); maps, sf (county-level dashboard
chapters only, for offline choropleth maps); a PDF engine — TeX including
the `longtable` and `ulem` packages (ranking/PDF chapters only), plus
`pdflscape`/`lscape` (Pacific Northwest ranking chapter only, for its one
landscape table).

---

[License](https://github.com/eddiekasner/pestuse/blob/master/LICENSE)
