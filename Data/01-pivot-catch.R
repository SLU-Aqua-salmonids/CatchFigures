library(dplyr)
library(tidyr)
library(readxl)
library(writexl)

## Create a excel-file in long format for the data that JD compiled
##
data_wide <- read_excel("Data/catch-1996-2019.xlsx",
                        sheet = "Svenskt fiske totalt",
                        range = "C4:K24")

data_long <- data_wide %>%
    pivot_longer(cols = !År, names_to = "Fiske", values_to = "Antal") %>%
    mutate(Antal = round(Antal, 0)) %>%
  mutate(Fiske = case_when(
    Fiske == "Fritidsfiske trolling" ~ "Fritidsfiske trolling hav",
    Fiske == "Sportfiske älv" ~ "Fritidsfiske spö älv",
    Fiske == "Övrigt fiske älv" ~ "Fritidsfiske husbehov älv",
    .default = Fiske)) %>%
    arrange(År)

write_xlsx(data_long, "Data/catch-1996-2019-long.xlsx")
