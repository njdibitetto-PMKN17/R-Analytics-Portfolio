# Module 3 Lesson 2 Challenge
install.packages("tidyverse")
library(tidyverse)

# Run this to see if there are any problems looking for the correct file 
# for the code you are about to put below this code in line 7
list.files()

# This code searches for the data in the respective location
setwd("C:/Users/DiBip/OneDrive/Documents/Coursera")
bookings_df <- read_csv("hotel_bookings.csv")
#' Line 10 is optional, only for precision
#' Line 11 is base code for searching data. 

# Clean Data 
head(bookings_df)
str(bookings_df)
colnames(bookings_df)

#' I want to create a new data frame that focuses on the average daily rate
#' which is referred to as 'adr' in the data frame, and 'adults'. 
#' This is the following code. 
new_df <- select(bookings_df, `adr`, adults)
new_df

#' To create new variables in the data frame, we can use mutate here. 
#' This will only make changes to the data frame we created. 
mutate(new_df, total = `adr` / adults)

