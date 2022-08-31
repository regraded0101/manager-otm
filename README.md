# manager-otm
Code to understand whether the Manager-of-the-Month (MOTM) 'curse', where managers perform significantly worse in the month following MOTM is true. This will be conducted by comparing the average number of points-per-game managers receive during their Manager-of-the-Month month's against the following month.

# Data Sources
- Managers of the month data extracted from [My Football Facts](https://www.myfootballfacts.com/premier-league/all-time-premier-league/premier_league_manager_of_the_month_awards/) (from August 1993 to April 2022)
- Football games data downloaded from [Kaggle](https://www.kaggle.com/datasets/saife245/english-premier-league/code?resource=download)

# Manager-of-the-Month
Do managers perform worse after winning the PL Manager-of-the-Month award? To start, let's look at how managers perform when they win the MOTM award compared to managers that do not win the award.
![plot](https://github.com/regraded0101/manager-otm/blob/main/outputs/chart_images/motm_v_non_motm.png)
The winner of the MOTM award clearly performs better than non-winners, measured as average points per game.
So how do they perform compared to their next month?
![plot](https://github.com/regraded0101/manager-otm/blob/main/outputs/chart_images/motm_v_next_month.png)
This is a clear drop in average points per game. But how does this compare to non-MOTM winners?
![plot](https://github.com/regraded0101/manager-otm/blob/main/outputs/chart_images/next_month_v_general_Average.png)
They appear to perform slightly better than the general non-MOTM managers. This could be caused because 'better' sides tend to win the award more frequently though, whereas general non-MOTM teams tend to have more 'average'/'poorer' sides.

# Conclusion
* MOTM winners achieve higher average points per game than non-winners
* MOTM winners *DO* perform worse in their following month
* In this following month, the average MOTM will score average more points per game compared to the general population but this could be explained by biases in the sample