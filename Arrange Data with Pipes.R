# Organize data 

install.packages("tidyverse")
library("tidyverse")
penguins %>% 
  arrange(bill_length_mm)

# This data in this tibble it spits out is currently in assending order
# if wanted in descending order then just add a - before column sign: 
# penguins %>% 
#   arrange(-bill_length_mm) 
# now the longest penguin bill is first. 

# This data is just saved in our console, to save it to a data frame:
# 1. Need to name it. 
penguins2 <- penguins %>%  arrange(-bill_length_mm)

# 2. now to execute saved data. 
penguins2

# This saves it as a dataset
View(penguins2)


#'group_by() :  usually combined with other functions, 
#'ex: might want to group_by a certain column, and then perform 
#'an operation on those groups. 
#' With penguin data we can group by island, and then summarize()
#' to get mean bill length. 
#' 
#' summarize() : gets high level information about raw data set.
#' 
#' We are not interested in NA values in data, we can leave those out 
#' using drop_na 
#' add summarize to get high level info
#' need to build the mean statement next to get result.

penguins %>%  group_by(island) %>% drop_na() %>% 
  summarize(mean_bill_length_mm = mean(bill_length_mm))

#' We can get other summaries too. to get max bill length, run the same
#' style just replace mean with max. 

penguins %>%  group_by(island) %>% drop_na() %>% 
  summarize(max_bill_length_mm = max(bill_length_mm))

#' Summarize() can hand multiple at once as long as they're clean
#' You can use a comma to add multiple summary statistics. 

penguins %>%  group_by(island) %>% drop_na() %>% 
  summarize(mean_bill_length_mm = mean(bill_length_mm), 
            max_bill_length_mm = max(bill_length_mm))
