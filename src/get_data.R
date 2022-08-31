library(readr)
library(dplyr)
library(lubridate)

# Load in data
df_games <- 
  read_csv('data/final_dataset.csv') %>%
  select(Date, HomeTeam, AwayTeam, FTHG, FTAG) %>%
  mutate(Date = case_when(nchar(Date) ==8 ~ lubridate::as_date(Date, format = "%d/%m/%y"), 
                          TRUE ~ lubridate::as_date(Date, format = "%d/%m/%Y")
  ),
  MonthYear = paste0(month(Date, label = TRUE, abbr = FALSE), '-', year(Date)),
  HomePoints = case_when(FTHG > FTAG ~ 3,
                         FTHG == FTAG ~ 1,
                         FTHG < FTAG ~ 0,
                         TRUE ~ NA_real_),
  AwayPoints = case_when(FTAG > FTHG ~ 3,
                         FTAG == FTHG ~ 1,
                         FTAG < FTHG ~ 0,
                         TRUE ~ NA_real_),
  HomeTeam = recode(HomeTeam,
                    "Middlesboro" = "Middlesbrough"),
  AwayTeam = recode(AwayTeam,
                    "Middlesboro" = "Middlesbrough")
  )

df_motm <- 
  read_csv('data/managers-of-the-month.csv') %>%
  mutate(MonthYear = paste0(trimws(Month),'-',trimws(Year)),
         MOTM = TRUE) %>%
  select(MonthYear, Team, MOTM)