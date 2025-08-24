# These are all packages for cleaning data
install.packages("here")
install.packages("skimr")
install.packages("janitor")
install.packages("dplyr")

# Load them into libraries
library("here")
library("skimr")
library("janitor")
library("dplyr")

# This is just how the lesson was structured, so install palmer penguins package
install.packages("palmerpenguins")
library("palmerpenguins")
data(penguins)


# These functions can be used to get summaries of our data frames.
glimpse(penguins) 
skim_without_charts(penguins)
head(penguins)

# Run a pipe for the example in lesson. The select function takes one variable
# and selects its column for observation. 
penguins %>% 
  select(species)

#' If you want everything except the species column, put: 
#' penguins %>% 
#'  select(-species)
#' The minus sign is the indicator here. 

#' Renanme() makes it easy to change column names
penguins %>%  
  rename(island_new=island)

#' rename_with() : makes the columns more consistent 
#' like if you wanted to make all column names lower case. 
rename_with(penguins,tolower)

#' clean_names() : ensures there is only characters, 
#' numbers and underscores in the names
clean_names(penguins)





read_csv()
