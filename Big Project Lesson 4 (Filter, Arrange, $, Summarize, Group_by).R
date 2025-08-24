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

hotel_bookings_city <- filter(hotel_bookings, hotel_bookings$hotel == "City Hotel")
head(hotel_bookings_city)

#' You quickly check what the average lead time for this set of hotels is, 
#' just like you did for all of hotels before:
mean(hotel_bookings_city$lead_time)


#' Now, your boss wants to know a lot more information about city hotels, 
#' including the maximum and minimum lead time. They are also interested in how
#' they are different from resort hotels. You don't want to run each line of 
#' code over and over again, so you decide to use the `group_by()`and`summarize()` 
#' functions. You can also use the pipe operator to make your code easier to
#' follow. You will store the new dataset in a data frame named 'hotel_summary':


hotel_summary <-
  hotel_bookings %>% 
  group_by(hotel) %>% 
  summarize(avg_lead_time = mean(lead_time),
            max_lead = max(lead_time),
            min_lead = min(lead_time))

head(hotel_summary)

#' Note
#' group_by compares two of the rows, here it compares city hotel and resort hotel. 
#' summarize needs to have column names defined with the code executed inside of it as being
#' set equal to. 
#' arrange really just helps compare which order to put it in 
#' filter is bit tricky 
#' 
#' It is Used to subset rows of a data frame based on a condition.

#hotel_bookings$hotel == "City Hotel":
  
 # Checks which rows have "City Hotel" in the hotel column.

#Returns a logical vector (TRUE or FALSE for each row).

#hotel_bookings_city <- ...:
  
 # Assigns the filtered result to a new object called hotel_bookings_city.

#✅ Summary:
  
 # This code creates a new data frame called hotel_bookings_city that contains 
#  only the rows where the hotel is "City Hotel".
  
  