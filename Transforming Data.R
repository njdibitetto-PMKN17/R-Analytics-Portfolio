install.packages("tidyr")
install.packages("tidyverse")
library("tidyverse")
library(tidyr)
install.packages("palmerpenguins")
library("palmerpenguins")
data(penguins)
#' This essentially creates the data frame below
id <- c(1:10)

name <- c("John Mendes", "Rob Stewart", "Rachel Abrahamson", "Christy Hickman", "Johnson Harper", "Candace Miller", "Carlson Landy", "Pansy Jordan", "Darius Berry", "Claudia Garcia")

job_title <- c("Professional", "Programmer", "Management", "Clerical", "Developer", "Programmer", "Management", "Clerical", "Developer", "Programmer")

employee <- data.frame(id, name, job_title)

#' After hitting run on employee, you see the last names are 
#' combined. Now we want to separate a column to separate the last names. 

separate(employee, name, into=c("first_name", "last_name"), sep=" ")
# This code above should separate the information. 

#' Separate function has a partner: unite.
#' Unite allows us to merge columns together.
#' 
#' I am not copying the inverse of the data above. hence first name , last name
#' employee but imagine first and last name were separate in raw data. 
#' The correct code that would unite the names together would be 
#' unite(employee, "name", first_name, last_name, sep = " ") 
#' the first section is dataframe, the column we're combining second, third and
#' fourth will be the columns being merged, lastly sep= " " is just to add a space
#' between the dataset. 


#' this part of the code is for mutate, and will be utilizing the penguins 
#' dataset.
#' Essentially there is a column that gives body mass in grams, and we want to 
#' add a column that can do it in kilograms.  

View(penguins)
penguins %>% 
  mutate(body_mass_kg = body_mass_g/1000)

#' now the beauty behind mutate is that you can mutate a second variable in the
#' same code segment/pipe. I will list it here below. This code below is the only
#' one that needs to be ran as an evolved version of the mutate code above. 

penguins %>% 
  mutate(body_mass_kg = body_mass_g/1000, flipper_length_m = flipper_length_mm/1000)

# you can see the results under where it says 334 more rows for current up to date data. 
