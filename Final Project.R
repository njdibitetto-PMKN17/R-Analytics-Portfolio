#' Read files 
library(readxl)
unrate <- read.csv("C:/Users/DiBip/Downloads/unrate.csv")
srp <- read.csv("C:/Users/DiBip/Downloads/srp.csv")
mu <- read.csv("C:/Users/DiBip/Downloads/mu.csv")
ipg <- read.csv("C:/Users/DiBip/Downloads/ipg.csv")
gap <- read.csv("C:/Users/DiBip/Downloads/gap.csv")
cfnai <- read.csv("C:/Users/DiBip/Downloads/cfnai.csv")
cay <- read.csv("C:/Users/DiBip/Downloads/cay.csv")
goyaldata_nber <- read.csv("C:/Users/DiBip/Downloads/goyaldata_nber.csv")
fred_md_factors <- read.csv("C:/Users/DiBip/Downloads/fred_md_factors.csv")

#' Show charts of data individually 
View(unrate)
View(srp)
View(mu)
View(ipg)
View(gap)
View(cfnai)
View(cay)
View(goyaldata_nber)
View(fred_md_factors)

# 'date' column is numeric for all datasets
cay$date <- as.numeric(cay$date)
cfnai$date <- as.numeric(cfnai$date)
gap$date <- as.numeric(gap$date)
ipg$date <- as.numeric(ipg$date)
mu$date <- as.numeric(mu$date)
srp$date <- as.numeric(srp$date)
unrate$date <- as.numeric(unrate$date)

# Convert yyyymm to numeric in `fred_md_factors` and `goyaldata_nber`
fred_md_factors$Date <- as.numeric(fred_md_factors$yyyymm)
goyaldata_nber$Date <- as.numeric(goyaldata_nber$yyyymm)



# Check column names for each dataset
names(cay)
names(cfnai)
names(fred_md_factors)
names(gap)
names(ipg)
names(mu)
names(srp)
names(unrate)
names(goyaldata_nber)

# Print column names of the merged dataframe
names(data)

#' Remove columns printing NA/NAN/INF
#' 
# Convert relevant columns to numeric, catching any NAs introduced by coercion
data <- data.frame(lapply(data[numeric_cols], function(x) as.numeric(as.character(x))))

# Check for any remaining NA, NaN, or Inf values and handle them
problematic_counts <- sapply(data, function(x) sum(is.na(x)) + sum(is.nan(x)) + sum(is.infinite(x)))
print(problematic_counts)

# Remove rows with any NA, NaN, or Inf values across the entire dataset
data <- data[complete.cases(data), ]

# Ensure `Index` does not contain any problematic values
y <- data$Index
X <- data[, c("Cay", "CFNAI", "Gap", "IPG", "MU", "SRP", "UNRATE", "factor1", "factor2", "factor3", "factor4", "factor5", "factor6", "factor7")]

# Create a logical index to identify rows with NA/NaN/Inf values in X
valid_rows <- apply(X, 1, function(row) {
  !any(is.na(row) | is.nan(row) | is.infinite(row))
})

# Filter out invalid rows in X
X <- X[valid_rows, ]

# Align `y` with filtered `X`
y <- y[valid_rows]

# Verify the clean dataset
print(head(data))

# Fit the baseline regression model
model <- lm(y ~ ., data = data.frame(y, X))
summary(model)

# Fit the rolling regression model
window_size <- 60  # 60-month rolling window

rolling_reg <- rollapply(data.frame(y, X), width = window_size, by = 1, FUN = function(df) {
  coef(lm(y ~ ., data = as.data.frame(df)))
}, by.column = FALSE)

# Convert results to a data frame for plotting
rolling_reg <- as.data.frame(t(rolling_reg))
colnames(rolling_reg) <- paste0("coef_", 1:ncol(rolling_reg))

# Plot the rolling regression coefficients
matplot(rolling_reg, type = "l", lty = 1, col = 1:ncol(rolling_reg), xlab = "Time", ylab = "Coefficient Value", main = "Rolling Regression Coefficients")
legend("topright", legend = colnames(rolling_reg), col = 1:ncol(rolling_reg), lty = 1, cex = 0.8)

summary(model)$coefficients
str(data)


# QQ Plot (Quantile-Quantile Plot)
qqnorm(model$residuals, main = "QQ Plot")
qqline(model$residuals, col = "red")

# Histogram of Residuals
hist(model$residuals, main = "Histogram of Residuals", xlab = "Residuals", breaks = 30)

# Predicted vs. Actual Values
plot(data$Index, predict(model), main = "Predicted vs. Actual Values", xlab = "Actual Values", ylab = "Predicted Values")
abline(0, 1, col = "red")


