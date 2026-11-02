# Environmental Time-Series Modelling in R

## Overview

This project examines seasonal variation, temporal autocorrelation and long-term trends in historical monthly air temperature observations from Nottingham, England, between 1920 and 1939.

The analyses use time-series decomposition, autoregressive models, generalised least-squares regression and generalised additive models to investigate temporal patterns in environmental data.

All analyses are contained in a single R script.

## Data

The analysis uses the `nottem` dataset, which is included in R's `datasets` package. The dataset contains monthly average air temperatures recorded in Nottingham between 1920 and 1939.

Temperatures were originally recorded in degrees Fahrenheit and are converted to degrees Celsius for analysis.

## Analyses

### Seasonal variation

Seasonal decomposition is used to separate the temperature time series into trend, seasonal and residual components.

### Temporal autocorrelation

A seasonal AR(1) time-series model is fitted to examine temporal dependence. Generalised least-squares models with and without AR(1) residual correlation are also fitted and compared using AIC.

Residual autocorrelation is examined to assess model performance.

### Nonlinear temperature trends

Generalised additive models are used to investigate linear and nonlinear changes in temperature over time while accounting for seasonal variation.

Model predictions and approximate 95% confidence intervals are generated, and model diagnostics are examined.

## Methods

The analyses were conducted in R using seasonal decomposition, autoregressive modelling, generalised least-squares regression, generalised additive models and statistical model comparison.

## R packages

- `ggplot2`
- `dplyr`
- `nlme`
- `mgcv`

## Running the analysis

Install the required packages:

```r
install.packages(c("ggplot2", "dplyr", "nlme", "mgcv"))
```

Download the R script and run it in RStudio. The temperature dataset is included in R and does not require an external download.

## Limitations

The dataset represents historical temperature observations from a single location and should not be interpreted as evidence of broader regional or global climate trends.

The GAM analysis does not explicitly model residual temporal autocorrelation, which may affect statistical inference. The results are therefore primarily intended to demonstrate environmental time-series modelling techniques.

## Data source

R Core Team. `nottem`: Average Monthly Temperatures at Nottingham, 1920–1939. R `datasets` package.

Documentation: https://stat.ethz.ch/R-manual/R-devel/library/datasets/html/nottem.html
