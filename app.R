library(shiny)
library(bslib)
library(bsicons)
library(plotly)
library(dplyr)

# ── Data loading ──────────────────────────────────────────────────────────────
data_dir <- "data"

close_df  <- read.csv(file.path(data_dir, "close.csv"))
close_df$Date <- as.Date(close_df$Date)

spy_df <- read.csv(file.path(data_dir, "spy.csv"))
spy_df$Date <- as.Date(spy_df$Date)

date_min <- min(close_df$Date)
date_max <- max(close_df$Date)

ticker_labels <- c(
  "Apple (AAPL)"    = "AAPL",
  "Microsoft (MSFT)" = "MSFT",
  "Alphabet (GOOGL)" = "GOOGL",
  "Amazon (AMZN)"   = "AMZN",
  "Meta (META)"     = "META",
  "Nvidia (NVDA)"   = "NVDA",
  "Tesla (TSLA)"    = "TSLA"
)

# ── UI ────────────────────────────────────────────────────────────────────────
ui <- page_sidebar(
  title = "Magnificent 7 Stock Explorer",
  theme = bs_theme(
    version = 5,
    bg      = "#131722",
    fg      = "#d1d4dc",
    primary = "#2962ff",
    base_font = font_google("Inter")
  ),

  sidebar = sidebar(
    bg = "#1e222d",
    width = 260,

    selectInput(
      "ticker",
      "Select Stock",
      choices  = ticker_labels,
      selected = "NVDA"
    ),

    dateRangeInput(
      "date_range",
      "Date Range",
      min   = date_min,
      max   = date_max,
      start = date_min,
      end   = date_max
    ),

  ),

  # ── Value boxes ──────────────────────────────────────────────────────────
  layout_columns(
    col_widths = c(4, 4, 4),
    value_box(
      title    = "Current Price",
      value    = textOutput("vb_price"),
      showcase = bs_icon("currency-dollar")
    ),
    value_box(
      title    = "Total Return (period)",
      value    = textOutput("vb_return"),
      showcase = bs_icon("graph-up-arrow"),
      theme    = value_box_theme(bg = "#1a3a1a", fg = "#44bb70")
    ),
    value_box(
      title    = "Outperformance vs S&P 500",
      value    = textOutput("vb_vs_spy"),
      showcase = bs_icon("bar-chart-fill"),
      theme    = value_box_theme(bg = "#1a2a3a", fg = "#60a0e0")
    )
  ),

  # ── Price chart ──────────────────────────────────────────────────────────
  card(
    card_header("Historical Closing Price"),
    plotlyOutput("price_chart", height = "380px"),
    full_screen = TRUE
  )
)



# ── Server ────────────────────────────────────────────────────────────────────
server <- function(input, output, session) {

  # ── Reactive: filtered closing prices ──────────────────────────────────
  filtered_close <- reactive({
    close_df |>
      filter(Date >= input$date_range[1], Date <= input$date_range[2]) |>
      arrange(Date)
  })

  # ── Reactive: filtered SPY (for vs-SPY value box) ────────────────────
  filtered_spy <- reactive({
    spy_df |>
      filter(Date >= input$date_range[1], Date <= input$date_range[2]) |>
      arrange(Date)
  })

  # ── Value box helpers ──────────────────────────────────────────────────
  output$vb_price <- renderText({
    df     <- filtered_close()
    ticker <- input$ticker
    if (nrow(df) == 0 || !ticker %in% colnames(df)) return("N/A")
    price <- tail(df[[ticker]], 1)
    paste0("$", formatC(price, format = "f", digits = 2, big.mark = ","))
  })

  output$vb_return <- renderText({
    df     <- filtered_close()
    ticker <- input$ticker
    if (nrow(df) < 2 || !ticker %in% colnames(df)) return("N/A")
    start_p <- df[[ticker]][1]
    end_p   <- tail(df[[ticker]], 1)
    ret <- (end_p / start_p - 1) * 100
    paste0(ifelse(ret >= 0, "+", ""), formatC(ret, format = "f", digits = 2), "%")
  })

  output$vb_vs_spy <- renderText({
    df_c   <- filtered_close()
    df_spy <- filtered_spy()
    ticker <- input$ticker
    if (nrow(df_c) < 2 || !ticker %in% colnames(df_c) || nrow(df_spy) < 2) return("N/A")
    stock_ret <- (tail(df_c[[ticker]], 1) / df_c[[ticker]][1] - 1) * 100
    spy_ret   <- (tail(df_spy$SPY, 1)    / df_spy$SPY[1] - 1) * 100
    diff <- stock_ret - spy_ret
    paste0(ifelse(diff >= 0, "+", ""), formatC(diff, format = "f", digits = 2), "%")
  })

  # ── Price chart ────────────────────────────────────────────────────────
  output$price_chart <- renderPlotly({
    df     <- filtered_close()
    ticker <- input$ticker

    validate(need(nrow(df) > 0 && ticker %in% colnames(df),
                  "No data available for the selected range."))

    fig <- plot_ly() |>
      add_trace(
        data          = df,
        x             = ~Date,
        y             = df[[ticker]],
        type          = "scatter",
        mode          = "lines",
        name          = ticker,
        line          = list(color = "#2962ff", width = 2.5),
        hovertemplate = paste0("<b>%{x}</b><br>", ticker, ": $%{y:.2f}<extra></extra>")
      )

    fig |>
      layout(
        paper_bgcolor = "#131722",
        plot_bgcolor  = "#1e222d",
        font      = list(color = "#d1d4dc"),
        xaxis     = list(
          title     = "Date",
          gridcolor = "rgba(255,255,255,0.06)",
          rangeslider = list(visible = TRUE)
        ),
        yaxis     = list(
          title      = "Close Price (USD)",
          gridcolor  = "rgba(255,255,255,0.06)",
          tickprefix = "$"
        ),
        legend    = list(orientation = "h", x = 0, y = 1.08),
        hovermode = "x unified",
        margin    = list(l = 10, r = 10, t = 30, b = 10)
      )
  })

}

shinyApp(ui, server)
