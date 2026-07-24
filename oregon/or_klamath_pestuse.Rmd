---
title: |
  | Estimated Annual Agricultural Pesticide Use
  | Klamath County, Oregon 2014-2018
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
                      fig.width=9,
                      fig.height=6,
                      out.width='100%',
                      fig.path='Figs/',
                      tidy.opts=list(width.cutoff=60),
                      tidy=TRUE)

options(scipen=999)
```

```{r load.packages, include=F}
required_pkgs <- c("knitr", "bookdown", "dplyr", "tidyr", "readr", "ggplot2", "scales", "kableExtra")
invisible(lapply(required_pkgs, function(pkg) library(pkg, character.only = TRUE)))
```

```{r constants}
state_fips  <- "41"
county_fips <- "035"
county_name <- "Klamath County"
# 2019 is excluded: the county-level file available at the time of writing
# is a partial/preliminary release covering only 69 compounds nationwide
# (vs. ~400-410 in every other year, 1992-2018), so anchoring the "most
# recent year" on it would silently drop hundreds of real compounds from
# every ranking table. Re-run with 2015-2019 once a complete 2019 release
# is available.
window_years <- 2014:2018
recent_year  <- max(window_years)

cat_hex <- c("#2a78d6", "#eb6834", "#1baf7a", "#eda100",
              "#e87ba4", "#008300", "#4a3aa7", "#e34948",
              "#8c564b", "#c25aab")
muted_grey <- "#898781"
functional_levels <- c("Herbicide/algicide", "Fungicide", "Insecticide",
                        "Plant Growth Regulator", "Acaricide", "Fumigant",
                        "Insect Growth Regulator", "Other Bactericides",
                        "Nematicides", "Insect Repellent", "Other")
functional_colors <- setNames(c(cat_hex[1:10], muted_grey), functional_levels)
```

```{r upload.and.clean.data, include=F}

## Read 2014-2018 county-level estimates (Klamath County, OR subset only)
## from ../estimates/EPest.county.estimates.<year>.txt

read_year <- function(yr) {
  read_delim(
    sprintf("../estimates/EPest.county.estimates.%d.txt", yr),
    delim = "\t",
    col_types = cols(
      COMPOUND = col_character(),
      YEAR = col_integer(),
      STATE_FIPS_CODE = col_character(),
      COUNTY_FIPS_CODE = col_character(),
      EPEST_LOW_KG = col_double(),
      EPEST_HIGH_KG = col_double()
    )
  ) %>%
    filter(STATE_FIPS_CODE == state_fips, COUNTY_FIPS_CODE == county_fips)
}

county_raw <- bind_rows(lapply(window_years, read_year))

classification <- read_csv("../data/pesticide_classification.csv", col_types = cols())

county_yearly <- county_raw %>%
  group_by(COMPOUND, YEAR) %>%
  summarize(EPEST_LOW_KG = sum(EPEST_LOW_KG, na.rm = TRUE),
            EPEST_HIGH_KG = sum(EPEST_HIGH_KG, na.rm = TRUE), .groups = "drop")

# Each window (1/3/5-yr) is ranked independently so a compound's presence
# in the appendix tables never depends on whether it also happens to
# appear in the *other* windows (e.g. a compound with real 2014-2018 use
# but zero recorded use in the single most recent year must still show up
# in the 5-yr appendix ranking).
compute_windows <- function(yearly) {
  one <- yearly %>%
    filter(YEAR == recent_year) %>%
    transmute(COMPOUND, EPEST_LOW_KG_1YR = EPEST_LOW_KG, EPEST_HIGH_KG_1YR = EPEST_HIGH_KG) %>%
    arrange(desc(EPEST_HIGH_KG_1YR)) %>%
    mutate(RANK_1YR = row_number())

  three <- yearly %>%
    filter(YEAR %in% tail(window_years, 3)) %>%
    group_by(COMPOUND) %>%
    summarize(EPEST_LOW_KG_3YR_AVG = mean(EPEST_LOW_KG), EPEST_HIGH_KG_3YR_AVG = mean(EPEST_HIGH_KG), .groups = "drop") %>%
    arrange(desc(EPEST_HIGH_KG_3YR_AVG)) %>%
    mutate(RANK_3YR = row_number())

  five <- yearly %>%
    group_by(COMPOUND) %>%
    summarize(EPEST_LOW_KG_5YR_AVG = mean(EPEST_LOW_KG), EPEST_HIGH_KG_5YR_AVG = mean(EPEST_HIGH_KG), .groups = "drop") %>%
    arrange(desc(EPEST_HIGH_KG_5YR_AVG)) %>%
    mutate(RANK_5YR = row_number())

  list(one = one, three = three, five = five)
}

county_w <- compute_windows(county_yearly)

top_n <- 80

# The main summary table (Table 1) intentionally requires a compound to
# appear in all three windows at once, since it displays 1/3/5-yr figures
# side by side for the same compound; the appendix tables below do not
# use this joined version.
county_ranked <- county_w$one %>%
  inner_join(county_w$three, by = "COMPOUND") %>%
  inner_join(county_w$five, by = "COMPOUND") %>%
  mutate(across(where(is.numeric) & !starts_with("RANK"), ~round(.x)))

county_top <- county_ranked %>%
  arrange(RANK_1YR) %>%
  slice(1:top_n) %>%
  left_join(classification, by = "COMPOUND") %>%
  mutate(CHEMICAL_CLASS = coalesce(CHEMICAL_CLASS, "Other"),
         CHEM_ABBREV = coalesce(CHEM_ABBREV, "OTH"),
         FUNCTIONAL_CLASS = coalesce(FUNCTIONAL_CLASS, "Other"),
         FUNCTIONAL_CLASS = factor(FUNCTIONAL_CLASS, levels = functional_levels)) %>%
  select(RANK_1YR, COMPOUND, CHEMICAL_CLASS, CHEM_ABBREV, FUNCTIONAL_CLASS, EPEST_HIGH_KG_1YR, EPEST_HIGH_KG_3YR_AVG, EPEST_HIGH_KG_5YR_AVG)
```

# Summary

Klamath County ranks **#5 of Oregon's 36 counties** by total
estimated agricultural pesticide mass applied (EPest-high method, summed
2014-2018), making it one of OR's five highest pesticide-use
counties. Klamath County, in the Klamath Basin, grows irrigated potatoes, alfalfa hay, and grain in a region long associated with disputes over irrigation water allocation.

Table \@ref(tab:merged-tables) lists the rank and best available estimates
of mass applied (kg) for the top `r top_n` agricultural pesticides in
**Klamath County, Oregon** during `r recent_year`, as reported by
[USGS Estimated Annual Agricultural Pesticide
Use](https://water.usgs.gov/nawqa/pnsp/usage/maps/county-level/) data. The
table also includes rank by 3-year average
(`r paste(range(tail(window_years,3)), collapse="-")`) and 5-year average
(`r paste(range(window_years), collapse="-")`) estimates of mass applied,
and each compound's chemical class (abbreviated; see the key in Table
\@ref(tab:class-key) and the full classification, with a separate
functional class column, in `data/pesticide_classification.csv`, shared
with every chapter in this repository). Rankings and estimates are based
on the *EPest-high method* described by [Thelin and Stone
(2013)](https://pubs.usgs.gov/sir/2013/5009/) and [Baker and Stone
(2015)](https://pubs.usgs.gov/ds/0907/):

> "EPest-low and EPest-high, are used to estimate a range of pesticide use.
> Both EPest-low and EPest-high methods incorporate proprietary surveyed
> rates for Crop Reporting Districts (CRDs), but EPest-low and EPest-high
> estimates differ in how they treat situations when a CRD was surveyed and
> pesticide use was not reported for a particular crop present in the CRD.
> In these situations, EPest-low assumes zero use in the CRD for that
> pesticide-by-crop combination. EPest-high, however, treats the unreported
> use for that pesticide-by-crop combination in the CRD as missing data. In
> this case, pesticide-by-crop use rates from neighboring CRDs or CRDs
> within the same region are used to estimate the pesticide-by-crop
> EPest-high rate for the CRD." [*-Pesticide National Synthesis Project
> webpage*](https://water.usgs.gov/nawqa/pnsp/usage/maps/about.php)

USGS lists several caveats of these data, in particular:

* Reliability decreases with scale (e.g. "detailed interpretation of where
  and how much use occurs within a county is not appropriate").
* EPest-low estimates are more likely to reflect state-based restrictions
  on pesticide use than EPest-high estimates.
* A blank cell in the source file (no reported/estimated use for that
  compound-year-county) is treated as zero in this chapter.
* **2019 is excluded from this ranking.** The 2019 county-level file
  available at the time of writing covers only 69 compounds nationwide,
  versus roughly 400 compounds in every other year from 1992-2018 — a
  partial/preliminary release, not a real drop in the number of pesticides
  in use. Anchoring the ranking on it would silently omit hundreds of real
  compounds. This chapter uses `r recent_year` (the most recent complete
  year) as the 1-year snapshot instead; re-run with `r recent_year+1`
  -included windows once a complete 2019 release is available.

```{r class-key, include=T}
kable(classification %>% distinct(CHEM_ABBREV, CHEMICAL_CLASS) %>% arrange(CHEMICAL_CLASS),
      "latex", booktabs = T, longtable = TRUE,
      col.names = c("Code", "Chemical class"),
      caption = "Chemical class abbreviation key (used in the Class column of Table 2)") %>%
  kable_styling(latex_options = c("striped", "repeat_header", "HOLD_position"), font_size = 8)
```

```{r merged-tables, include=T}
# See the Washington statewide top-pesticides chapter for why this uses
# longtable rather than kableExtra's "scale_down": scale_down bundles the
# whole table into one atomic latex box that cannot break across pages,
# which silently drops every row past the page boundary for tables this
# long instead of erroring.
display <- county_top %>% select(-CHEMICAL_CLASS, -FUNCTIONAL_CLASS)
names(display) <- c("Rank", "Compound", "Class", "EPest-high 1yr",
                     "EPest-high 3yr avg", "EPest-high 5yr avg")

kable(display, "latex", booktabs = T, digits = 0, longtable = TRUE,
      caption = paste0("Top ", top_n, " EPest-high Estimates, ", county_name, ", OR, 1-Yr (", recent_year,
                        "), 3-Yr Avg, 5-Yr Avg, with Chemical Class (abbreviated; see the ",
                        "classification key table above)")) %>%
  kable_styling(latex_options = c("striped", "repeat_header", "HOLD_position"), font_size = 8)

write.csv(county_top, "klamath.pesticide.use.2014-2018.csv", row.names = FALSE)
```

```{r top-chart, include=T, fig.cap="Top 25 compounds in Klamath County by EPest-high mass applied, most recent year, colored by pesticide functional class."}
top_chart <- county_top %>%
  slice(1:25) %>%
  mutate(COMPOUND = forcats::fct_reorder(COMPOUND, EPEST_HIGH_KG_1YR))

ggplot(top_chart, aes(x = COMPOUND, y = EPEST_HIGH_KG_1YR, fill = FUNCTIONAL_CLASS)) +
  geom_col() +
  coord_flip() +
  scale_fill_manual(values = functional_colors, name = "Functional class", drop = FALSE) +
  scale_y_continuous(labels = comma) +
  guides(fill = guide_legend(nrow = 4, byrow = TRUE)) +
  labs(title = paste0(county_name, " top 25 pesticides, ", recent_year),
       x = NULL, y = "EPest-high estimate (kg)") +
  theme_minimal(base_size = 11) +
  theme(legend.position = "bottom", panel.grid.minor = element_blank())
```

# Appendices

```{r table-1yr, include=T}
kable(head(county_w$one %>% arrange(RANK_1YR) %>%
             select(RANK_1YR, COMPOUND, EPEST_LOW_KG_1YR, EPEST_HIGH_KG_1YR), n = 50),
      "latex", booktabs = T, digits = 0,
      caption = paste0("Top 50 ", county_name, " Estimates, Range (EPest-low and EPest-high), 1-Yr, ", recent_year)) %>%
  kable_styling(latex_options = c("striped", "scale_down"))
```

```{r table-3yr, include=T}
kable(head(county_w$three %>% arrange(RANK_3YR) %>%
             select(RANK_3YR, COMPOUND, EPEST_LOW_KG_3YR_AVG, EPEST_HIGH_KG_3YR_AVG), n = 50),
      "latex", booktabs = T, digits = 0,
      caption = paste0("Top 50 ", county_name, " Estimates, Range (EPest-low and EPest-high), 3-Yr Avg, ",
                        paste(range(tail(window_years,3)), collapse="-"))) %>%
  kable_styling(latex_options = c("striped", "scale_down"))
```

```{r table-5yr, include=T}
kable(head(county_w$five %>% arrange(RANK_5YR) %>%
             select(RANK_5YR, COMPOUND, EPEST_LOW_KG_5YR_AVG, EPEST_HIGH_KG_5YR_AVG), n = 50),
      "latex", booktabs = T, digits = 0,
      caption = paste0("Top 50 ", county_name, " Estimates, Range (EPest-low and EPest-high), 5-Yr Avg, ",
                        paste(range(window_years), collapse="-"))) %>%
  kable_styling(latex_options = c("striped", "scale_down"))
```

