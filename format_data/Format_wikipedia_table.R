library(readr)
library(dplyr)
library(tidyr)

#Read table extracted from wikipedia
og_table <- read_csv("data/Eclipses_21st_century.csv")[-1, ]
mod_table <- og_table

#Change date format from Month day, year (ex.: August 13, 2026) to year-month-day (ex.: 2026-08-13)
mod_table$Date <- format(
  as.Date(mod_table$Date, format = "%B %d, %Y"),
  "%Y-%m-%d"
)

mod_table <- mod_table[, 1:(ncol(mod_table) - 2)]

#Separate coordinates in three columns

mod_table <- mod_table |>
  mutate(
    Location = sub(".*white-space:nowrap\\}", "", Location)
  ) |>
  separate(
    Location,
    into = c("location-hyphen", "location-degree", "location-numeric"),
    sep = " / "
  ) |>
  separate("location-numeric", into = c("Latitude", "Longitude"), sep = "; ") |>
  select(-c("location-hyphen", "location-degree"))

#Save formatted table
write_csv(mod_table, "data/formatted_eclipses.csv")
