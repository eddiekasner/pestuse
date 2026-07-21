# pestuse

Analyses of USGS Pesticide National Synthesis Project agricultural pesticide
use estimates for Washington State. The repo currently contains three
independent reports built from different USGS data products; each is
self-contained (own input data, own R Markdown source, own rendered output).

**CHECK FOR UPDATES TO DATA.** Please carefully review the applications and
limitations of these data, as described on [this USGS National
Water-Quality Assessment (NAWQA) Project page](https://water.usgs.gov/nawqa/pnsp/usage/maps/about.php).

---

## Chapter 1 — Yakima County top-pesticide ranking (2012-2016)

`pestuse.Rmd` → `pestuse.pdf` / `pestuse.md`

Lists the rank and best available estimates of mass applied (kg) for the 80
most common agricultural pesticides in Yakima County during 2016, as
reported by [USGS Estimated Annual Agricultural Pesticide
Use](https://water.usgs.gov/nawqa/pnsp/usage/maps/county-level/)
county-level data (`estimates/EPest.county.estimates.*.txt`). The table also
ranks compounds by 3-year average (2014-2016) and 5-year average
(2012-2016) mass applied. Rankings and estimates use the *EPest-high
method* described by [Thelin and Stone
(2013)](https://pubs.usgs.gov/sir/2013/5009/) and [Baker and Stone
(2015)](https://pubs.usgs.gov/ds/0907/).

NOTE: this chapter reports county-level estimates despite their intended
use to generate state-level estimates — see the USGS caveats page above.

Dependencies: knitr, bookdown, dplyr, kableExtra, a PDF engine (TeX).

To render:

```r
rmarkdown::render("pestuse.Rmd")
```

## Chapter 2 — Washington organophosphate & carbamate use trends (1992-2019)

`wa_op_carbamate_trends.Rmd` → `wa_op_carbamate_trends.html`

An interactive HTML dashboard (flexdashboard) summarizing annual
organophosphate and carbamate pesticide use across all of Washington (FIPS
53), 1992-2019, overall and by USGS crop group. It uses
`estimates/HighEstimate_AgPestUsebyCropGroup92to19.txt` (USGS Pesticide
National Synthesis Project *EPest-high estimates by crop group*, from
[ScienceBase item
6081ae7cd34e8564d6866222](https://www.sciencebase.gov/catalog/item/6081ae7cd34e8564d6866222))
and the compound classification in `data/op_carbamate_classification.csv`.

The dashboard includes an overview with headline trends, an interactive
data portal (crosstalk-linked filters, plots, and tables by crop group and
by compound), a page of static summary plots, and a methodology/data notes
page. Unlike Chapter 1, this dataset provides EPest-high estimates only (no
EPest-low range) and is state-level rather than county-level.

Dependencies: flexdashboard, plotly, DT, crosstalk, dplyr, tidyr, readr,
forcats, stringr, scales, ggplot2, knitr, kableExtra.

To render:

```r
rmarkdown::render("wa_op_carbamate_trends.Rmd")
```

## Chapter 3 — Washington statewide top-pesticide ranking (2014-2018)

`wa_statewide_top_pesticides.Rmd` → `wa_statewide_top_pesticides.pdf`

The statewide counterpart to Chapter 1: ranks the top 80 agricultural
pesticides across all of Washington (summed over every county) using the
same county-level source data and EPest-high method as Chapter 1
(`estimates/EPest.county.estimates.*.txt`), by 1-year, 3-year average, and
5-year average mass applied. Adds two things Chapter 1 doesn't have: each
compound's organophosphate/carbamate classification (reusing
`data/op_carbamate_classification.csv` from Chapter 2), and — for
comparison — its rank within Yakima County alone, so you can see where
Yakima's most-used pesticides fall statewide and vice versa.

The ranking window is 2014-2018, not 2014-2019: the 2019 county-level file
available at the time of writing is a partial/preliminary release covering
only 69 compounds nationwide (vs. ~400 in every other year), so using it as
the "most recent year" anchor would silently drop hundreds of real
compounds from every table. Re-run once a complete 2019 release is
available — see the in-file comment next to `window_years`.

Dependencies: knitr, bookdown, dplyr, tidyr, readr, ggplot2, scales,
kableExtra, a PDF engine (TeX, including the `longtable` and `ulem`
packages).

To render:

```r
rmarkdown::render("wa_statewide_top_pesticides.Rmd")
```

---

[License](https://github.com/eddiekasner/pestuse/blob/master/LICENSE)
