install.packages("rmarkdown")
library(tidyverse)
head(diamonds)
# displays the columns and the first several rows of data. 

str(diamonds)
#STR sucks 
glimpse(diamonds)
#Good display on par with head. 

colnames(diamonds)
#returns the column names. 

# Cleaning Data 

# Cleaning the data, there is a function called rename to clean up the presentation for some of the column names. 
rename(diamonds, carat_new = carat)

rename(diamonds, carat_new = carat, cut_new = cut) 

# Summarize function is great for generating a wide range of statistics for data. 
summarize(diamonds, mean_carat = mean(carat))

#Step 4: Visualizing data
?GeomPoint
?aes
#aes stands for aesthetics mpaping how variables are placed in data maps
ggplot(data = diamonds, aes(x = carat, y = price)) +
  geom_point()

#if you wanted to change the color of each point so that it represented another variable, such as the cut of the diamond.
ggplot(data = diamonds, aes(x = carat, y = price, color = cut)) +
  geom_point()

# this facet_wrap(~cut) makes it so that each type of cut is displayed in a different color in each individual dot plot. 
ggplot(data = diamonds, aes(x = carat, y = price, color = cut)) +
  geom_point() + facet_wrap(~cut)


