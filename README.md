# Magnificent 7 Stock Explorer — Shiny for R

An individual re-implementation of the [DSCI 532 group project](https://github.com/UBC-MDS/DSCI-532_2026_35_financebros) dashboard using **Shiny for R**.  
The original group project is written in Shiny for Python; this version uses R with `bslib` and `plotly`.

> **Deployed app:** _Add your Posit Connect Cloud link here_

---

## Features

| Category | Details |
|---|---|
| **Inputs** | Stock selector (dropdown), date-range picker |
| **Reactive calcs** | `filtered_close` — closing prices filtered to selected date range; `filtered_spy` — SPY prices filtered to same range |
| **Outputs** | Interactive Plotly price chart, 3 value boxes (current price, total return for the period, outperformance vs S&P 500) |

---

## Installation

### Prerequisites

- **R ≥ 4.3**  
- The following R packages (install once from the R console):

```r
install.packages(c(
  "shiny",
  "bslib",
  "bsicons",
  "plotly",
  "dplyr"
))
```

### Data

The repository includes the required CSV files in `data/`

---

## Running the App

From the R console or RStudio, set the working directory to `individual/` and run:

```r
setwd("individual")   # adjust path as needed
shiny::runApp()
```

Or from the terminal:

```bash
Rscript -e "shiny::runApp('individual')"
```

---

## Deploying to Posit Connect Cloud

1. The `data/` folder is already included in the repository — no extra steps needed.
2. Open `app.R` in RStudio and click **Publish** → **Posit Connect Cloud**.  
   Alternatively, use the `rsconnect` package:

```r
install.packages("rsconnect")
rsconnect::deployApp(
  appDir   = "individual",
  appName  = "mag7-stock-explorer-r",
  server   = "connect.posit.cloud"
)
```

3. After deployment, paste the resulting URL into the **About** section of your GitHub repository and replace the placeholder link at the top of this README.

---

## Project Structure

```
individual/
├── app.R        # Shiny for R application (UI + server in one file)
├── README.md    # This file
└── data/        # CSV data files included in the repository
    ├── close.csv
    └── spy.csv
```
