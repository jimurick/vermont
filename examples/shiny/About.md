# About the HospitalStarRatings App


This app displays hospital scores from the Centers for Medicare &
Medicaid Services (CMS). The hospital’s star ratings (as of Oct 2023)
are displayed on the map’s popups. When you click “View Data”, you can
see that hospital’s historical measure-level scores compared to the
overall distribution for all hospitals.

The package is based on two CMS sources:

- Measure score data was taken from the [Hospitals archived data
  snapshots](https://data.cms.gov/provider-data/archived-data/hospitals)
- The Star rating algorithm was translated to R from the [SAS
  Package](https://qualitynet.cms.gov/inpatient/public-reporting/overall-ratings/sas)

The following sections describe the app’s three tabs.

## Tab 1: Map

I took CMS’s list of hospitals and geocoded their addresses with
Google’s [geocoding
API](https://developers.google.com/maps/documentation/geocoding/overview)
in python. Although the geocoding was generally accurate, there are some
mistakes. For example, New York’s Lincoln Medical & Mental Health Center
was confused with a similarly-named [facility in New
Zealand](https://lincolnmedical.nz/).

## Tab 2: Plots

CMS collects data from most larger hospitals to calculate the star
ratings annually. There are about 50 measures that are used in the
calculation; the measures are divided into are 5 groups:

- Mortality
- Patient Experience
- Process
- Readmission
- Safety

The following table gives examples of three measures.

<div class="about-table">

| Group | ID | Metric |
|:---|:---|:---|
| Mortality | MORT_30_AMI | Acute Myocardial Infarction (AMI) 30-Day Mortality Rate |
| Patient Experience | H_COMP_2_STAR_RATING | Doctor communication |
| Safety | HAI_1 | Central Line Associated Bloodstream Infection (ICU + select Wards) |

</div>

## Tab 3: About

This page, written in Markdown, is intended to give end-users some
motivation for the app, explanation of how it works, and information
about its data sources.

## Gratuitous Math

Standard normal CDF:

$$
\Phi(x)=\int_{-\infty}^{x}\frac{dt}{\sqrt{2\pi e^{t^2}}}
$$

The R function `pnorm()` calculates $\Phi$:

``` r
suppressPackageStartupMessages(library(tidyverse))
theme_set(theme_bw())

data.frame(x = seq(from = -3, to = 3, by = 0.01)) |>
  mutate(Φ = pnorm(x)) |>
  ggplot(aes(x, Φ)) + geom_point() + geom_line()
```

![](About_files/figure-commonmark/unnamed-chunk-2-1.png)
