install.packages(tidyverse)
library(tidyverse)
library(lubridate)

data.frame(x = c(1,2,3), y = c(1.5,5.5,7.5)) 
# This runs the data frame making a visual. 

z <- data.frame(x = c(1, 2, 3) , y = c(1.5, 5.5, 7.5))
z[2,1]
#This essentially draws the 2nd number from the 1st set which is 2.  
# For example if it was Z[3,1] it would be 3.Third number from first set which is 3.
# If it was Z[3,2] it would be 7.5.Third number from second set is 7.5
z[3,1]
z[3,2]

