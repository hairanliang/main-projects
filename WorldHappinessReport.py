data = files.upload()
try:
  df = pd.read_csv(world-happiness-report-2021.csv) # Source: https://www.kaggle.com/datasets/ajaypalsinghlo/world-happiness-report-2021
  print("Data successfully uploaded.")
except Exception as error:
  print(f'Error Message: {error}')

# Getting the general shape of the dataset
df.shape
df.info(verbose = True)
df.head(10)

# Getting the unique values for the categorical variable of "Regional Indicator"
df.iloc[:, 1].unique()

# I will use Regional indicator a lot in my analysis, combining it with numerical columns to analyze how happiness
# relates to things like healthy life expectancy.

# Checking for missing values in my dataset: there are none
df.describe() 

# Based on this mean calculation, Ladder score(how well the countries scored on the Happiness Report) likely has 
# a positive correlation with healthy life expectancy, but the extent to which these two are linked will be analyzed
# more deeply in the figures to come.
df.groupby(["Ladder score"])["Healthy life expectancy"].mean()

# This preliminary mean calculation shows how different regions have varying average healthy life expectancies,
# which will be the main topic of my further analysis.
df.groupby(["Regional indicator"])["Healthy life expectancy"].mean()

# Using seaborn to see a more clear graphical representation of the previous mean calculation. Sub-Saharan Africa clearly has a lower
# Healthy life expectancy compared to regions like Western Europe and North America and ANZ (Australia and New Zealand).
sns.set(font_scale=1)
from numpy import median
plt.figure(figsize = (30,8))
ax = sns.barplot(x="Regional indicator", y="Healthy life expectancy", data=df, estimator = median)
h, l = ax.get_legend_handles_labels()

# The histogram shows clearly how regions in Europe and North America have considerably higher life expectancies 
# compared to African regions. We can see that healthy life expectancy is a bimodal distribution worldwide with modes
# of around 55 and 70, which could depict the separation between developed and developing countries. 
sns.displot(df, x="Healthy life expectancy", hue="Regional indicator")

# With Seaborn's violin plot, we can see the distribution has potential outliers, representing countries that either have life expectancies 
# greater than 80 or less than 45.
ax = sns.violinplot(x=df["Healthy life expectancy"])

# This heat map further supports the previous observation that there is a positive correlation between ladder score 
# and healthy life expectancy. Based on the shading, it can be concluded that many countries have a healthy life 
# expectancy between 65 - 70, and this led to a ladder score of around 6. 
sns.displot(df, x="Healthy life expectancy", y="Ladder score")

# As can be seen, this plot gives further evidence for the idea that life expectancies and ladder scores are positively
# correlated, with European and North American regions generally having higher life expectancies than African regions.
sns.relplot(x="Healthy life expectancy", y="Ladder score", hue="Regional indicator", data=df)

# Overall, through my EDA of the 2021 World Happiness Report, I was able to come to several conclusions. Firstly, while
# it is obvious, life expectancy has a positive correlation with ladder score, which itself is a proxy for measuring 
# "happiness." I also found that the the distribution of the world's life expectancy is bimodal, with modes of about 55
# and 70, which could represent the separation in life expectacy between developed and developing countries. In 
# particular, I found that African regions had lower life expectancies compared to North America and Europe, which 
# gives support to this idea of developing countries generally having lower life expectancies than developed countries.  

# If given more time(and what I will do once the quarter is over) I want to create a model to determine which of the
# many factors measured in the Happiness Report was most influential in the determining of the ladder score, and perhaps
# try to come up with an equation that can predict how well a country ranks given its various measurements for each 
# category. 





