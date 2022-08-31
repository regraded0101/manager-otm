library(readr)
library(dplyr)
library(lubridate)
library(ggplot2)

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

df_home <- 
  df_games %>%
  group_by(HomeTeam, MonthYear) %>%
  summarise(Points = sum(HomePoints, na.rm = TRUE),
            Games = n()) %>%
  rename(Team = HomeTeam) 

df_away <-
  df_games %>%
  group_by(AwayTeam, MonthYear) %>%
  summarise(Points = sum(AwayPoints, na.rm = TRUE),
            Games = n()) %>%
  rename(Team = AwayTeam)

df_points <-
  df_home %>%
  bind_rows(df_away) %>%
  group_by(Team, MonthYear) %>%
  summarise(Points = sum(Points, na.rm = TRUE),
            Games = sum(Games)) %>%
  mutate(PointsPerGame = Points/Games)





df_motm <- 
  read_csv('data/managers-of-the-month.csv') %>%
  mutate(MonthYear = paste0(trimws(Month),'-',trimws(Year)),
         MOTM = TRUE) %>%
  select(MonthYear, Team, MOTM)

df_motm <- 
  df_motm %>%
  mutate(Team = recode(Team,
                      "Birmingham City" = "Birmingham",
                      "Blackburn Rovers" = "Blackburn",
                      "AFC Bournemouth" = "Bournemouth",
                      "Bolton Wanderers" = "Bolton",
                      "Brighton & Hove Albion" = "Brighton",
                      "Charlton Athletic" = "Charlton",
                      "Coventry City" = "Coventry",
                      "Derby County" = "Derby",
                      "Huddersfield Town" = "Huddersfield",
                      "Hull City"= "Hull",
                      "Ipswich Town" = "Ipswich",
                      "Leeds United" = "Leeds",
                      "Leicester City" = "Leicester",
                      "Manchester City" = "Man City",
                      "Manchester United" = "Man United",
                      "Newcastle United" = "Newcastle",
                      "Middlesbrough" = "Middlesbrough",
                      "Norwich City" = "Norwich",
                      # Not exist: "Nottingham Forest"
                      # Not exist: "Oldham Athletic"
                      # Not exist: "Sheffield Wednesday"
                      "Swansea City" = "Swansea",
                      "Tottenham Hotspur" = "Tottenham",
                      "West Bromwich Albion" = "West Brom",
                      "West Ham United" = "West Ham",
                      "Wigan Athletic" = "Wigan",
                      #Not exist: "Wimbeldon"
                      "Wolverhampton Wanderers" = "Wolves"
                      )
         )


df_points <-
  df_points %>%
  left_join(df_motm, by = c("Team", "MonthYear")) %>%
  mutate(MOTM = case_when(is.na(MOTM) ~ FALSE,
                          TRUE ~ MOTM))

ggplot(data = df_points) +
  geom_density(aes(x = PointsPerGame, fill = MOTM),
               alpha = 0.7) +
  theme_bw()
