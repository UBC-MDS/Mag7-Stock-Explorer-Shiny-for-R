# Magnificent 7 Stock Explorer — Shiny for R

An individual re-implementation of the [DSCI 532 group project](https://github.com/UBC-MDS/DSCI-532_2026_35_financebros) dashboard using **Shiny for R**.  
The original group project is written in Shiny for Python; this version uses R with `bslib` and `plotly`.

> **Deployed app:** https://019ce9dc-5be9-9cd2-3845-dd1997d71cec.share.connect.posit.cloud/

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

From the R console or RStudio, set the working directory to `Mag7-Stock-Explorer-Shiny-for-R/` and run:

```r
setwd("Mag7-Stock-Explorer-Shiny-for-R")   # adjust path as needed
shiny::runApp()
```

Or from the terminal:

```bash
Rscript -e "shiny::runApp('Mag7-Stock-Explorer-Shiny-for-R')"
```

---

## Deploying to Posit Connect Cloud

1. The `data/` folder is already included in the repository — no extra steps needed.
2. Open `app.R` in RStudio and click **Publish** → **Posit Connect Cloud**.  
   Alternatively, use the `rsconnect` package:

```r
install.packages("rsconnect")
rsconnect::deployApp(
  appDir   = "Mag7-Stock-Explorer-Shiny-for-R",
  appName  = "mag7-stock-explorer-r",
  server   = "connect.posit.cloud"
)
```

3. After deployment, paste the resulting URL into the **About** section of your GitHub repository and replace the placeholder link at the top of this README.

---

## Project Structure

```
Mag7-Stock-Explorer-Shiny-for-R/
├── app.R        # Shiny for R application (UI + server in one file)
├── README.md    # This file
└── data/        # CSV data files included in the repository
    ├── close.csv
    └── spy.csv
```
