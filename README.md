# main-projects
My Academic Projects

importandplot.m: Data Analysis of Non-Match to Sample experiments in the Buonomano Lab written in MATLAB. Task had participants click when two objects
(circle or star) in succession were a match or not. Circle was associated with longer delays, star with shorter delays(implicit timing: participants had 
no idea about this relationship during the experiment). Concluded that when participants expected a circle to appear(longer delay), but instead a star 
appeared, participants had a statistically significantly higher reaction time after performing data cleaning and filtering(ex: some participants were 
four standard deviations away from the mean in terms of reaction time, etc). Used a T-test of validity and 2-way mixed anova to check for statistical
significance.

WorldHappinessReport.py: An EDA written in python of the World Happiness Report of 2021 I did as part of the Data Science Union at UCLA. After cleaning the data and checking for null values using the pandas library, I was able to find some key facts. For one, life expectancy has a positive correlation with ladder score, which is a proxy for measuring happiness. I first used simple statistics like mean, and then used graphs from the seaborn library such as violin plots and heat maps to support these conclusions.

EfficientGameofLife.m: A microcosm of living cells and how they interact with each other written in MATLAB. Encoded how living and dying cells would change 
on each iteration. Living cells that were beside 2 or 3 living cells lived, but if they were beside 4 or more, or 1 or less, they turned to dead on the
next turn. Dying cells would only come back to life on the following turn if on the current turn there is 3 living cells adjacent to it. Allowed user
to change the colour/design of the game board, how many rows/columns the simulation would have, the proportion of starting living cells, and the time 
between each iteration.






