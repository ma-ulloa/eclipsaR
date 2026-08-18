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

# make names syntactically valid

mod_table <-
  mod_table |>
  rename(
    "Central_duration_min_s" = `Centralduration(min:s)`,
    "Time_of_greatest_eclipse_terrestrial_time" = `Time ofgreatest eclipse(Terrestrial Time)`,
    "Path_width_km" = `Path width...9`,
    "Path_width_miles" = `Path width...10`,
    "Geographical_area" = `Geographical area`
  )

# split geographical area

mod_table <- mod_table |> select(!Geographical_area)

# remove extra words in `Type` column

mod_table <- mod_table |>
  mutate(Type = str_split_i(Type, i = 1, pattern = " "))

#Save formatted table
write_csv(mod_table, "data/formatted_eclipses.csv")
