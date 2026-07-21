# pestuse 

This repo lists the rank and best available estimates of mass applied (kg) for the 80 most common agricultural pesticides in Yakima County during 2016, as reported by [USGS Estimated Annual Agricultural Pesticide Use](https://water.usgs.gov/nawqa/pnsp/usage/maps/county-level/) data. The table also includes rank by 3-year average (2014-2016) and 5-year average (2012-2016) estimates of mass applied. Rankings and estimates are based on the *EPest-high method* described by [Theilen and Stone (2013)](https://pubs.usgs.gov/sir/2013/5009/) and [Baker and Stone (2015)](https://pubs.usgs.gov/ds/0907/).

**CHECK FOR UPDATES TO DATA**

Please carefully review the applications and limitations of these data, as described on [this USGS National Water-Quality Assessment (NAWQA) Project page](https://water.usgs.gov/nawqa/pnsp/usage/maps/about.php). NOTE: We report county-level estimates despite their intended use to generate state-level estimates.

Dependencies: knitr, knitr, bookdown, dplyr, kableExtra, pdf creator (TeX)

## Washington organophosphate & carbamate use trends dashboard

`wa_op_carbamate_trends.Rmd` renders an interactive HTML dashboard
(flexdashboard) summarizing annual organophosphate and carbamate pesticide
use in Washington (FIPS 53), 1992-2019, overall and by USGS crop group. It
uses `estimates/HighEstimate_AgPestUsebyCropGroup92to19.txt` (USGS Pesticide
National Synthesis Project *EPest-high estimates by crop group*, from
[ScienceBase item 6081ae7cd34e8564d6866222](https://www.sciencebase.gov/catalog/item/6081ae7cd34e8564d6866222))
and the compound classification in `data/op_carbamate_classification.csv`.

The dashboard includes an overview with headline trends, an interactive
data portal (crosstalk-linked filters, plots, and tables by crop group and
by compound), a page of static summary plots, and a methodology/data notes
page.

To render:

```r
rmarkdown::render("wa_op_carbamate_trends.Rmd")
```

Additional dependencies: flexdashboard, plotly, DT, crosstalk, tidyr,
readr, forcats, stringr, scales.

[License](https://github.com/eddiekasner/pestuse/blob/master/LICENSE)
