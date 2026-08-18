library(tidyverse)
library(httr)
# read table

eclipse_data <- read_csv("data/formatted_eclipses.csv")

request_obj <- GET(
  "http://xjubier.free.fr/en/site_pages/SolarEclipsesGoogleEarth.html"
)

content(request_obj)
