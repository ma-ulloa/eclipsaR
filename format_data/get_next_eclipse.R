library(dplyr)

source("format_data/Format_wikipedia_table.R")

next_eclipse_date <- mod_table |>
  mutate(Date = as.Date(Date)) |>
  filter(Date >= Sys.Date()) |>
  slice_min(Date, n = 1) |>
  pull(Date)
