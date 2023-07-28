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

DSU_MovieRecommendationEngine: This is the movie recommendation system I built as my final project for my Data Science Union internship. I harnessed sci-kit learn's TF-IDF vectorizer to perform content-based filtering machine learning. This way, given a movie, I was able to recommend movies similar to it after passing the TF-IDF matrices into sci-kit learn's cosine similarity and linear kernel functions. I then implemented collaborative filtering so that users with similar tastes in movies can be recommended movies that one or the other has watched.

PersonalChessAnalysis: This is "Part 1" of a Personal Chess Analysis project. In this part of the project, I did an Exploratory Data Analysis of around 4000 chess games I played on chess.com. I played a lot of chess in highschool, becoming a national master and national champion. Thus, this topic was of great interest to me. I wanted to see if I could discover some new insights in my play, especially things I can look to improve on. I was able to take a messy dataset and convert it into a dataframe I could use. I found I struggle most against the French Defense as White, and the English Opening as black. I also made a cool visualization that showed how my winrate decreased as the number of moves in the game increased. 

Ethnicity Predictor: This is a project as part of my involvement in the Data Science Union at UCLA, where I am currently the Director of Data Science Training and a past Project Lead. In this project, my group set out to create various models that could predict for age, gender, and ethnicity from the UTKFace dataset (https://susanqq.github.io/UTKFace/). I was in sole charge of building the ethnicity model (https://github.com/hairanliang/main-projects/blob/main/Ethnicity%20Predictor.ipynb), and I ended up getting a test accuracy of 77.0% on the test dataset provided by UTKFace. Using images from members of our club (~50 images), I had an accuracy of 62.2%.

Contrastive_Learning_Train: Code that is based on SimCLR's implementation of Contrastive Learning in a self-supervised setting. This code has the vectorized contrastive loss formula components, all coded by me. It also includes a small CNN model with an MLP, and a training loop that I use to test the contrastive loss along with .backward. It all works so far, and the next step is to implement the dataloader so that I can train on real retinal OCT images. This is part of my work for the Chiang Lab at UCLA. 


