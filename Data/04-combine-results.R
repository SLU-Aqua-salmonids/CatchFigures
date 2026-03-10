library(dplyr)
library(readxl)
library(writexl)

##
## Merge three files to create inpot for "development of fishing figure"
##

old_data <- read_excel("Data/catch-1996-2019-long.xlsx")
sea_data <- read_excel("Data/sea-long.xlsx")
river_data <- read_excel("Data/river-long.xlsx")

new_data <- bind_rows(old_data, sea_data, river_data)


write_xlsx(new_data, "Data/figure_data_long.xlsx")
