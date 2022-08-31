library(dplyr)
library(lubridate)


# get total points per game per month per team
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

# align Team names for joining later
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



# bring in MOTM data so MOTM v non-MOTM comparisons can be made
df_points <-
  df_points %>%
  left_join(df_motm, by = c("Team", "MonthYear")) %>%
  mutate(MOTM = case_when(is.na(MOTM) ~ FALSE,
                          TRUE ~ MOTM))



# get PPG for month after MOTM
df_motm_next <-
  df_points %>%
  filter(MOTM) %>%
  mutate(NextMonthYear = my(MonthYear)%m+% months(1),
         NextMonthYear = paste0(month(NextMonthYear, label = TRUE, abbr = FALSE), '-', year(NextMonthYear))) %>%
  select(Team, NextMonthYear)

df_points_motm_next <-
  df_points %>%
  inner_join(df_motm_next, 
             by = c("Team", "MonthYear" = "NextMonthYear")) %>%
  mutate(MOTM_Status = 'Following Month')

# bring together MOTM and next month data for plotting
df_motm_compare <- 
  df_points %>%
  filter(MOTM) %>%
  mutate(MOTM_Status = 'Manager-of-the-Month') %>%
  bind_rows(df_points_motm_next)
