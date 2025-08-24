install.packages("tidyverse")
install.packages("skimr")
install.packages("janitor")

library(tidyverse)
library(skimr)
library(janitor)

setwd("C:/Users/DiBip/OneDrive/Documents/Coursera")
hotel_bookings <- read_csv("hotel_bookings.csv")

head(hotel_bookings)

#' There are 36 columns, arrivaldatemonth is chr

str(hotel_bookings)
glimpse(hotel_bookings)
colnames(hotel_bookings)

#' You can see the different column names and some sample values to the 
#' right of the colon.
#' You can also use `colnames()` to get the names of the columns in your dataset.

# Now manipulate your data

arrange(hotel_bookings, desc(lead_time))


#'Notice that when you just run `arrange()` without saving your data to 
#'a new data frame, it does not alter the existing data frame. Check it out 
#'by running `head()` again to find out if the highest lead times are first: 
head(hotel_bookings)

hotel_book2 <- arrange(hotel_bookings, desc(lead_time))
head(hotel_book2)

#' You can also find out the maximum and minimum lead times without sorting the 
#' whole dataset using the `arrange()` function. Try it out using 
#' the max() and min() functions below:
max(hotel_bookings$lead_time)
min(hotel_bookings$lead_time)

min(lead_time)
#' This is a common error that R users encounter. To correct this code chunk,
#'  you will need to add the data frame and the dollar sign in the appropriate places. 

#'Now, let's say you just want to know what the average lead time for booking 
#'is because your boss asks you how early you should run promotions for hotel
#' rooms. You can use the `mean()` function to answer that question since the 
#' average of a set of number is also the mean of the set of numbers:

mean(hotel_bookings$lead_time)

#' You were able to report to your boss what the average lead time before
#'  booking is, but now they want to know what the average lead time before
#'   booking is for just city hotels. They want to focus the promotion they're
#'  running by targeting major cities. 

#' You know that your first step will be creating a new dataset that only 
#' contains data about city hotels. You can do that using the `filter()` 
#' function, and name your new data frame 'hotel_bookings_city':




