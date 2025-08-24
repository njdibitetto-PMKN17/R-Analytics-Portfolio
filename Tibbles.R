#Tibbles
install.packages("tidyverse")
library(tidyverse)
data(diamonds)
View(diamonds)

as_tibble(diamonds)
#'Running this function will display the diamonds tibble, but it won’t 
#'save the tibble. To save the diamonds dataset as a tibble, save it 
#'to a new object with the following code:

diamonds_tibb <- as_tibble(diamonds)
# This examines it within the code diamonds_tibb

