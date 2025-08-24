# Install Packages
install.packages("kknn", dependencies = TRUE)

# Must run library code as well to generate KKNN function. 
library(kknn)

setwd("~/data 2.2")

data[,11] <- as.factor(data[,11])

# Formula: predict last column from the others
f <- R1 ~ .

n <- nrow(data)
acc <- numeric(n)

# Loop through each row (leave-one-out)
for (i in 1:n) {
  train <- data[-i, ]             # all rows except i
  test  <- data[i, , drop=FALSE]  # just the ith row
  m <- kknn(f, train=train, test=test, k=7, scale=TRUE)
  pred <- fitted(m)
  acc[i] <- pred == test[,11]     # TRUE/FALSE → 1/0
}

# Overall accuracy
mean(acc)