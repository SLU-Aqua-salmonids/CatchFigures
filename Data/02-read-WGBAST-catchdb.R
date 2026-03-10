library(dplyr)
library(readxl)
library(writexl)

## Create a excel-file in long format with Swedish salmon catches
## in the sea after 2019 (the last year in JDs file)
##

#dbfolder <- "//storage-dh.slu.se/restricted$/Lax/Data/WGBAST_CatchDatabase"
dbfolder <- "Data"
dbfname <- "WGBAST_Catch_Latest.xlsx"
dbpath <- file.path(dbfolder, dbfname)

col_types <- c("text", "text", "numeric", "numeric", "text",
               "text", "text", "text", "text", "text",
               "text", "numeric", "numeric", "text", "numeric",
               "text", "text", "text", "text", "text",
               "text", "text", "numeric", "numeric")

data_raw <- read_excel(dbpath,
                       sheet = "Catch data",
                       na = c("NA", ""),
                       col_types = col_types) %>%
     select(-TIME_PERIOD, -TP_TYPE, -SUB_DIV, -sub_div2, -sub_div3,
           -EFFORT, -WEIGHT, -W_TYPE, -N_TYPE, -w_ci, -n_ci, -GEAR2,
           -subdiv_IC, -HYR, -24)


# names(col_types) <- colnames(data_raw) # You can use this the check that col_types was defined correcly

data_selection <- data_raw %>%
    filter(YEAR > 2019, COUNTRY == "SE", SPECIES == "SAL", F_TYPE != "ALV")

result_sea <- data_selection %>%
    filter(FISHERY != "R") %>% # We will get river data from FishDB
    mutate(F_TYPE = case_when(
               F_TYPE == "BMS" ~ "COMM",
               F_TYPE == "DISC" ~ "COMM",
               F_TYPE == "SEAL" ~ "COMM",
               .default = F_TYPE)) %>%
    mutate(Fiske = case_when(
               FISHERY == "O" & F_TYPE == "COMM" ~ "Yrkesfiske hav",
               FISHERY == "C" & F_TYPE == "COMM" ~ "Yrkesfiske kust",
               FISHERY == "R" & F_TYPE == "COMM" ~ "Yrkesfiske älv (odlad)",
               FISHERY == "C" & F_TYPE == "RECR" ~ "Fritidsfiske fällor kust",
               FISHERY == "O" & F_TYPE == "RECR" ~ "Fritidsfiske trolling hav",
               .default = "Okänt fiske")
           ) %>%
    group_by(YEAR, Fiske) %>%
    summarise(Antal = sum(NUMB), .groups = "drop") %>%
    rename(År = YEAR)

write_xlsx(result_sea, "Data/sea-long.xlsx")
