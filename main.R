library(dplyr)
library(ggplot2)

# Load in data
source('src/get_data.R')

# Pre-process data
source('src/preprocess_data.R')

cbPalette <- c("#999999", "#E69F00")
cbbPalette <- c("#F0E442", "#0072B2")

# Plot PPG for MOTM v non-MOTM
ggplot(data = df_points) +
  geom_density(aes(x = PointsPerGame, fill = MOTM),
               alpha = 0.7) +
  theme_minimal() +
  theme(axis.text.y = element_blank()) +
  scale_fill_manual(name = "Status", values = cbPalette, labels = c("Not MOTM", "MOTM")) +
  labs(title = "How do average points compare for Manager-of-the-month v not?",
       x = "Points per Game",
       y = "")
ggsave("outputs/chart_images/motm_v_non_motm.png")


# Plot MOTM v next month
ggplot(df_motm_compare) +
  geom_density(aes(x = PointsPerGame, 
                   fill = MOTM_Status), 
               alpha = 0.7) +
  theme_minimal() +
  theme(axis.text.y = element_blank()) +
  scale_fill_manual(name = "Status", values = cbPalette, labels = c("Next Month", "MOTM")) +
  labs(title = "Does the Manager-of-the-Month curse exist?",
       x = "Points per Game",
       y = "")
ggsave('outputs/chart_images/motm_v_next_month.png')

# Plot next month v general average
df_points_motm_next %>%
  bind_rows(df_points %>% filter(!MOTM) %>% mutate(MOTM_Status = 'Not MOTM')) %>%
  ggplot() +
  geom_density(aes(x = PointsPerGame, fill = MOTM_Status),
               alpha = 0.7) +
  theme_minimal() +
  theme(axis.text.y = element_blank()) +
  scale_fill_manual(name = "Status", values = cbbPalette, labels = c("Next Month", "Not MOTM")) +
  labs(title = "How does the cursed month compare to normal non-MOTM months",
       x = "Points per Game",
       y = "")

ggsave(filename = 'outputs/chart_images/next_month_v_general_Average.png')

