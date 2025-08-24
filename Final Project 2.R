# Load necessary libraries
library(zoo)
library(knitr)
library(readxl)

# Load datasets
cay <- read.csv("C:/Users/DiBip/Downloads/cay.csv")
cfnai <- read.csv("C:/Users/DiBip/Downloads/cfnai.csv")
fred_md_factors <- read.csv("C:/Users/DiBip/Downloads/fred_md_factors.csv")
gap <- read.csv("C:/Users/DiBip/Downloads/gap.csv")
ipg <- read.csv("C:/Users/DiBip/Downloads/ipg.csv")
mu <- read.csv("C:/Users/DiBip/Downloads/mu.csv")
srp <- read.csv("C:/Users/DiBip/Downloads/srp.csv")
unrate <- read.csv("C:/Users/DiBip/Downloads/unrate.csv")
goyaldata_nber <- read.csv("C:/Users/DiBip/Downloads/goyaldata_nber.csv")

# Convert yyyymm to numeric in `fred_md_factors` and `goyaldata_nber`
fred_md_factors$Date <- as.numeric(fred_md_factors$yyyymm)
goyaldata_nber$Date <- as.numeric(goyaldata_nber$yyyymm)

# Merge datasets using the common 'date' column
data <- merge(merge(merge(merge(merge(merge(merge(cay, cfnai, by = "date"),
                                            gap, by = "date"),
                                      ipg, by = "date"),
                                mu, by = "date"),
                          srp, by = "date"),
                    unrate, by = "date"),
              fred_md_factors, by.x = "date", by.y = "Date")
data <- merge(data, goyaldata_nber, by.x = "date", by.y = "Date")


# Define the numeric columns
numeric_cols <- c("Cay", "CFNAI", "Gap", "IPG", "MU", "SRP", "UNRATE", "factor1", "factor2", "factor3", "factor4", "factor5", "factor6", "factor7", "Index")

# Convert all relevant columns to numeric, catching any NAs introduced by coercion
data[numeric_cols] <- lapply(data[numeric_cols], function(x) as.numeric(as.character(x)))

# Remove rows with any NA, NaN, or Inf values across the entire dataset
data <- data[complete.cases(data), ]

# Re-define the dependent variable (stock returns)
y <- data$Index

# Re-define the independent variables (factors)
X <- data[, numeric_cols[-length(numeric_cols)]]

# Fit the baseline regression model
model <- lm(y ~ ., data = data.frame(y, X))
summary(model)

# QQ Plot (Quantile-Quantile Plot)
qqnorm(model$residuals, main = "QQ Plot")
qqline(model$residuals, col = "red")

# Histogram of Residuals
hist(model$residuals, main = "Histogram of Residuals", xlab = "Residuals", breaks = 30)

# Predicted vs. Actual Values
plot(data$Index, predict(model), main = "Predicted vs. Actual Values", xlab = "Actual Values", ylab = "Predicted Values")
abline(0, 1, col = "red")

# Fit the rolling regression model
window_size <- 60  # 60-month rolling window
rolling_reg <- rollapply(data.frame(y, X), width = window_size, by = 1, FUN = function(df) {
  lm(y ~ ., data = as.data.frame(df))$coef
}, by.column = FALSE)

# Convert results to a data frame for plotting
rolling_reg <- as.data.frame(t(rolling_reg))
colnames(rolling_reg) <- c("(Intercept)", numeric_cols[-length(numeric_cols)])

# Plot the rolling regression coefficients
matplot(rolling_reg, type = "l", lty = 1, col = 1:ncol(rolling_reg), xlab = "Time", ylab = "Coefficient Value", main = "Rolling Regression Coefficients")
legend("topright", legend = colnames(rolling_reg), col = 1:ncol(rolling_reg), lty = 1, cex = 0.8)
