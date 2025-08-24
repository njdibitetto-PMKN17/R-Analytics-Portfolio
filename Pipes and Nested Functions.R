# Load the tidyverse package
library(tidyverse)

# Optionally check for updates (do NOT load tidyverse before running updates)
# Run this in a fresh R session if you're updating
# install.packages(c("broom", "ggplot2", "jsonlite", "pillar", "purrr", "readxl", "rlang", "tibble"))

# Load the ToothGrowth dataset
data("ToothGrowth")
View(ToothGrowth)
head(ToothGrowth)

# Filter for dose equal to 0.5
filtered_tg <- filter(ToothGrowth, dose == 0.5)
filtered_tg

# Arrange the filtered data by length
arranged_tg <- arrange(filtered_tg, len)

# Nested version of the above two steps
nested_tg <- arrange(filter(ToothGrowth, dose == 0.5), len)

# Using pipes to do the same: shortcut is Ctrl + Shift + M
filtered_toothgrowth <- ToothGrowth %>%
  filter(dose == 0.5) %>%
  arrange(len)

filtered_toothgrowth

# Group by supplement type and calculate mean length for dose == 0.5
filtered_toothgr <- ToothGrowth %>%
  filter(dose == 0.5) %>%
  group_by(supp) %>%
  summarize(mean_len = mean(len, na.rm = TRUE), .groups = "drop")
# Mean tooth length for each supplement at 0.5 mg dose
filtered_toothgr

# Explanation:
# - filter(dose == 0.5): Filters the rows with dose = 0.5
# - group_by(supp): Groups data by supplement type (VC or OJ)
# - summarize(...): Computes the mean of len, ignoring NAs
# - .groups = "drop": Ensures the result is a regular data frame, not grouped
