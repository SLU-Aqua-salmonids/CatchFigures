library(dplyr)
#library(DCFsers)
#library(RPostgres)
library(readxl)
library(writexl)

## Create a excel-file in long format with Swedish salmon catches
## in the sea after 2019 (the last year in JDs file)
##

#db <- sers_connect()


## Get all data for landed salmon after 2019 and haronr < 86001 (Mörrum)
# sql <- "select haronr, year, num_fish, fcat, gear
# from fishdata.river_sum
# where year > 2019 AND haronr < 86001 AND maf = 'SAL' AND landed"

#data_raw <- dbGetQuery(db, sql)
data_raw <- read_excel("Data/fishdata-latest.xlsx", sheet = "river_sum",
                       na = c("NA", "")) %>%
    filter(year > 2019, haronr < 86001, maf == "SAL", landed) %>%
    select(haronr, year, num_fish, fcat, gear)

#dbDisconnect(db)

result_river <- data_raw %>%
        mutate(Fiske = case_when(
               fcat == "Commercial"  ~ "Yrkesfiske älv (odlad)",
               fcat == "Brood"  ~ "Avelsfiske älv",
               fcat == "Other"  ~ "Fritidsfiske husbehov älv",
               fcat == "Recreational"  ~ "Fritidsfiske spö älv",
               .default = "Okänt fiske")) %>%
    group_by(year, Fiske) %>%
    summarise(Antal = sum(num_fish),  .groups = "drop") %>%
    rename(År = year)


write_xlsx(result_river, "Data/river-long.xlsx")
