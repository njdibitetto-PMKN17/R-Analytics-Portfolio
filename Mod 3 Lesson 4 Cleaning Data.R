# Lesson / Cleaing Data in R 

# Step 1 install packages in R
install.packages("tidyverse")
install.packages("janitor")
install.packages("skimr")

library("tidyverse")
library("skimr")
library("janitor")

# Step 2 Import data 
setwd("C:/Users/DiBip/OneDrive/Documents/Coursera")
Hotelfile <- read_csv("hotel_bookings.csv")

# Step 3 Getting to know your data
head(Hotelfile)
colnames(Hotelfile)
glimpse(Hotelfile)
skim_without_charts(Hotelfile)

# Step 4 Cleaning your data

#'Based on the functions you have used so far, how would you 
#'describe your data in a brief to your stakeholder? 
#'Now, let's say you are primarily interested in the following 
#'variables: 'hotel','is_canceled', and 'lead_time'.
#' Create a new data frame with just those columns, calling it 
#' trimmed_df` by adding the variable names to this code chunk:

# We also want to rename a column for clarity 
trimmed_df <- Hotelfile %>% 
  select(hotel, is_canceled, lead_time) %>% 
  rename(hotel_type = hotel)
trimmed_df

#'Another common task is to either split or combine data in different 
#'columns. In this example, you can 
#'combine the arrival month and year into one column using the 
#'unite() function:
  
split <- Hotelfile %>% 
  select(arrival_date_year, arrival_date_month) %>% 
  unite(arrival_month_year, c("arrival_date_month",
                              "arrival_date_year"), sep = " ")
split 

#' You can also use the`mutate()` function to make changes to your columns.
#'  Let's say you wanted to create a new column that summed up 
#'  all the adults, children, and babies on a reservation for the
#'  total number of people. Modify the code chunk below to create 
#'  that new column: 
  
example_df <- Hotelfile %>% mutate(guests = adults + children + babies)
head(example_df)

#' Great. Now it's time to calculate some summary statistics! 
#' Calculate the total number of canceled bookings and the average
#' lead time for booking - you'll want to start your code after
#'  the %>% symbol. Make a column called 'number_canceled' 
#'  to represent the total number of canceled bookings. Then, make 
#'  a column called 'average_lead_time' to represent the average lead time. 
#'  Use the `summarize()`function to do this in the code chunk below:
names(Hotelfile)
summary_stats <- Hotelfile %>%  
  summarise(
    number_canceled = sum(is_canceled, na.rm = TRUE),
    average_lead_time = mean(lead_time, na.rm = TRUE)
  )
summary_stats

    
