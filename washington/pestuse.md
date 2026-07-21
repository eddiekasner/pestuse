---
title: |
  | Estimated Annual Agricultural Pesticide Use 
  | Yakima County 2012-2016
date: '`r format(Sys.Date(), "%d %B %Y")`'
output:
  bookdown::pdf_document2:
    number_sections: no
    toc: no
geometry: margin = 0.75in
fontsize: 10pt
link-citations: true
linkcolor: blue
urlcolor: blue
---

```{r knitr.global.options, include=F}
knitr::opts_chunk$set(echo=F, 
                      warning=F, 
                      fig.align='center', 
                      fig.pos='H',
                      fig.width=12, 
                      fig.height=8, 
                      fig.path='Figs/', 
                      tidy.opts=list(width.cutoff=60),
                      tidy=TRUE)

options(scipen=999)

```

```{r load.packages, include=F}

# Load pacman, installing as necessary.
my_repo <- 'http://cran.r-project.org'
if (!require("pacman")) {install.packages("pacman", repos = my_repo)}

# Load the other packages, installing as needed.
pacman::p_load(knitr, bookdown, dplyr, kableExtra)

```

```{r upload.and.clean.data, include=F}

## Read in datasets for 2012-2016 county level estimates from USGS website https://water.usgs.gov/nawqa/pnsp/usage/maps/county-level/

pu2012 <- read.delim('estimates/EPest.county.estimates.2012.txt', header=T)
pu2013 <- read.delim('estimates/EPest.county.estimates.2013.txt', header=T)
pu2014 <- read.delim('estimates/EPest.county.estimates.2014.txt', header=T)
pu2015 <- read.delim('estimates/EPest.county.estimates.2015.txt', header=T)
pu2016 <- read.delim('estimates/EPest.county.estimates_noCA.2016.txt', header=T)

# Concatenate 2012-2016 files

pu.2012.2016 <- rbind(pu2012,pu2013,pu2014,pu2015,pu2016)

# Remove intermeidate files

rm(pu2012,pu2013,pu2014,pu2015,pu2016)

# Filter to Yakima County for 5 (2012-2016), 3 (2014-2016), and 1 (2016) year groups

yakima.2012.2016 <- filter(pu.2012.2016, STATE_FIPS_CODE==53 & COUNTY_FIPS_CODE==77)
yakima.2014.2016 <- filter(pu.2012.2016, STATE_FIPS_CODE==53 & COUNTY_FIPS_CODE==77 & YEAR >2013)
yakima.2016 <- filter(pu.2012.2016, STATE_FIPS_CODE==53 & COUNTY_FIPS_CODE==77 & YEAR == 2016)

```

# Summary

Table \@ref(tab:merged-tables) lists the rank and best available estimates of mass applied (kg) for the 80 most common agricultural pesticides in Yakima County during 2016, as reported by [USGS Estimated Annual Agricultural Pesticide Use](https://water.usgs.gov/nawqa/pnsp/usage/maps/county-level/) data. The table also includes rank by 3-year average (2014-2016) and 5-year average (2012-2016) estimates of mass applied. Rankings and estimates are based on the *EPest-high method* described by [Theilen and Stone (2013)](https://pubs.usgs.gov/sir/2013/5009/) and [Baker and Stone (2015)](https://pubs.usgs.gov/ds/0907/):

> "EPest-low and EPest-high, are used to estimate a range of pesticide use. Both EPest-low and EPest-high methods incorporate proprietary surveyed rates for Crop Reporting Districts (CRDs), but EPest-low and EPest-high estimates differ in how they treat situations when a CRD was surveyed and pesticide use was not reported for a particular crop present in the CRD. In these situations, EPest-low assumes zero use in the CRD for that pesticide-by-crop combination. EPest-high, however, treats the unreported use for that pesticide-by- crop combination in the CRD as missing data. In this case, pesticide-by-crop use rates from neighboring CRDs or CRDs within the same region are used to estimate the pesticide-by-crop EPest-high rate for the CRD." [*-Pesticide National Synthesis Project webpage*](https://water.usgs.gov/nawqa/pnsp/usage/maps/about.php)

USGS lists several caveats of these data, in particular:

* Data for 2013-2016 are preliminary (i.e. "using projected county crop acres from the previous Census of Agriculture and are expected to be revised upon availability of updated crop acreages in the following Census of Agriculture")
* Reliability decreases with scale (e.g. "detailed interpretation of where and how much use occurs within a county is not appropriate")
* EPest-low estimates are more likely to reflect state-based restrictions on pesticide use than EPest-high estimates

For a more detailed look at the range (EPest-low and EPest-high) of 1-yr, 3-yr, and 5-yr data, please see Tables \@ref(tab:table-1yr-2016), \@ref(tab:table-3yr-2014-2016), and \@ref(tab:table-5yr-2012-2016), respectively.


```{r summary-1yr-2016, include=T}

# create 1 yr dataset that follows naming convention in 5 and 3 yr datasets

yak.1yr <- yakima.2016

# sort in terms of decreasing use

yak.1yr <- yak.1yr[order(yak.1yr$EPEST_HIGH_KG, decreasing = T), ]

# add rank

yak.1yr$RANK_1YR <- 1:nrow(yak.1yr) 

# reorder variables

yak.1yr <- yak.1yr[c("RANK_1YR", "COMPOUND", "EPEST_LOW_KG", "EPEST_HIGH_KG")]

# round to integers

yak.1yr$EPEST_LOW_KG  <- round(as.numeric(yak.1yr$EPEST_LOW_KG, digits = 0))
yak.1yr$EPEST_HIGH_KG <- round(as.numeric(yak.1yr$EPEST_HIGH_KG, digits = 0))

# table for 2016 low and high data

row.names(yak.1yr) <- NULL

colnames(yak.1yr)[colnames(yak.1yr)=="EPEST_LOW_KG"] <- "EPEST_LOW_KG_1YR_ONLY"
colnames(yak.1yr)[colnames(yak.1yr)=="EPEST_HIGH_KG"] <- "EPEST_HIGH_KG_1YR_ONLY"

#kable(head(yak.1yr, n=50), "latex", booktabs = T, caption = "Top 50 Pesticides Used in Yakima County, 1 Year, 2016") %>%
#kable_styling(latex_options = c("striped", "scale_down"))

```

```{r summary-3yr-2014-2016, include=T}

# calculate arithmetic mean (avg) by compound for 3-year period (2014-2016)

yak.3yr <- yakima.2014.2016 %>% group_by(COMPOUND) %>% summarize(EPEST_HIGH_KG_3YR_AVG=mean(EPEST_HIGH_KG), EPEST_LOW_KG_3YR_AVG=mean(EPEST_LOW_KG))

# sort in terms of decreasing use

yak.3yr <- yak.3yr[order(yak.3yr$EPEST_HIGH_KG_3YR_AVG, decreasing = T), ]

# add rank

yak.3yr$RANK_3YR <- 1:nrow(yak.3yr) 

# reorder variables

yak.3yr <- yak.3yr[c("RANK_3YR", "COMPOUND", "EPEST_LOW_KG_3YR_AVG", "EPEST_HIGH_KG_3YR_AVG")]

# round to integers

yak.3yr$EPEST_LOW_KG_3YR_AVG  <- round(as.numeric(yak.3yr$EPEST_LOW_KG_3YR_AVG, digits = 0))
yak.3yr$EPEST_HIGH_KG_3YR_AVG <- round(as.numeric(yak.3yr$EPEST_HIGH_KG_3YR_AVG, digits = 0))

```

```{r summary-5yr-2012-2016, include=T}

# calculate arithmetic mean (avg) by compound for 5-year period (2012-2016)

yak.5yr <- yakima.2012.2016 %>% group_by(COMPOUND) %>% summarize(EPEST_HIGH_KG_5YR_AVG=mean(EPEST_HIGH_KG), EPEST_LOW_KG_5YR_AVG=mean(EPEST_LOW_KG))

# sort in terms of decreasing use

yak.5yr <- yak.5yr[order(yak.5yr$EPEST_HIGH_KG_5YR_AVG, decreasing = T), ]

# add rank

yak.5yr$RANK_5YR <- 1:nrow(yak.5yr) 

# reorder variables

yak.5yr<- yak.5yr[c("RANK_5YR", "COMPOUND", "EPEST_LOW_KG_5YR_AVG", "EPEST_HIGH_KG_5YR_AVG")]

# round to integers

yak.5yr$EPEST_LOW_KG_5YR_AVG  <- round(as.numeric(yak.5yr$EPEST_LOW_KG_5YR_AVG, digits = 0))
yak.5yr$EPEST_HIGH_KG_5YR_AVG <- round(as.numeric(yak.5yr$EPEST_HIGH_KG_5YR_AVG, digits = 0))

```

```{r merged-tables, include=T}

# merge 5, 3, and 1 yr datasets

merge.5yr.3yr <- merge(yak.5yr, yak.3yr, by = 'COMPOUND')
merge.all     <- merge(merge.5yr.3yr, yak.1yr, by = 'COMPOUND')

# reorder variables

final.2012.2016 <- merge.all[c("COMPOUND", "RANK_1YR", "RANK_3YR", "RANK_5YR", "EPEST_HIGH_KG_1YR_ONLY", "EPEST_HIGH_KG_3YR_AVG", "EPEST_HIGH_KG_5YR_AVG")]

# sort in terms of decreasing use for 2016 data

final.2012.2016 <- final.2012.2016[order(final.2012.2016$EPEST_HIGH_KG_1YR, decreasing = T), ]

# table for 1 yr (2016), 3 yr avg (2014-2016), and 5 yr avg (2012-2016)

row.names(final.2012.2016) <- NULL

kable(head(final.2012.2016, n=80), "latex", booktabs = T, caption = "Top 80 EPest-high Estimates for Yakima County, 1-Yr (2016), 3-Yr Avg (2014-2016), 5-Yr Avg (2012-2016)") %>%
kable_styling(latex_options = c("striped", "scale_down"))

# create csv file for final table

write.csv(final.2012.2016, "~/pestuse/yakima.pesticide.use.2012-2016.csv", row.names=FALSE)

```

\newpage

# Appendices

```{r table-1yr-2016, include=T}

#table for 2016 low and high data

kable(head(yak.1yr, n=50), "latex", booktabs = T, caption = "Top 50 Estimates in Yakima County, Range (EPest-low and EPest-high), 1-Yr, 2016") %>%
kable_styling(latex_options = c("striped", "scale_down"))

```

```{r table-3yr-2014-2016, include=T}

#table for 2014-2016 low and high data

kable(head(yak.3yr, n=50), "latex", booktabs = T, caption = "Top 50 Estimates in Yakima County, Range (EPest-low and EPest-high), 3-Yr Avg, 2014-2016") %>%
kable_styling(latex_options = c("striped", "scale_down"))

```

```{r table-5yr-2012-2016, include=T}

#table for 2012-2016 low and high data

kable(head(yak.5yr, n=50), "latex", booktabs = T, caption = "Top 50 Estimates in Yakima County, Range (EPest-low and EPest-high), 5-Yr Avg, 2012-2016") %>%
kable_styling(latex_options = c("striped", "scale_down"))

```

