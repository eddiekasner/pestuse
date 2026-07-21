# pestuse

Analyses of USGS Pesticide National Synthesis Project agricultural pesticide
use estimates for Washington State. The repo currently contains two
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

---

[License](https://github.com/eddiekasner/pestuse/blob/master/LICENSE)
