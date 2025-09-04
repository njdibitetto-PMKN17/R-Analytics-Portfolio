#'What: Deletes all objects from your R session.
#'Why: Ensures a clean environment when knitting, so old variables don’t silently affect results.
rm(list = ls())

#' Tells knitr to echo code chunks in the knitted report
#' What: Configures knitr so your code appears in the HTML output.
#'Why: For transparency and grading—your code is visible alongside results.
knitr::opts_chunk$set(echo = TRUE)

#' This code below sets the CRAN mirror (prevents "choose a CRAN mirror" errors when installing packages) gave me 
#' What: Sets your package download mirror and installs kknn.
#' Why: So the kknn functions are available.
options(repos = c(CRAN = "https://cloud.r-project.org"))
install.packages("kknn", dependencies = TRUE)

#' Set working directory so R knows where to look for the data file
#' What: Changes the working directory.
#' Why: So read.table("credit_card_data-headers.txt", ...) will find the file.
setwd("~/data 2.2")

#' Must run library code as well to generate KKNN function. 
library(kknn)

#' Purpose: Makes all random operations reproducible 
#' (e.g., sample(), train/valid/test split). 
#' With the same seed and the same code, you get the same split and the same results.
#'Why 123: It’s just a commonly used integer. Any fixed integer would work.
#' There’s nothing special about 123 besides being easy to remember.
#' Why at the top: You want all subsequent randomness (splits, shuffles, 
#' cross-validation assignments) to be fixed — so you set the seed before you do any random sampling.
set.seed(123) 

#' Load the credit card dataset (tab-delimited, with headers) into a dataframe called cc
#' What: Reads the tab-delimited file with column names into cc.
#' Why: This is the dataset used for modeling (10 predictors + 1 response R1).
cc <- read.table("credit_card_data-headers.txt", header = TRUE, sep = "\t")

#' Make response a factor
#' What: Converts R1 (0/1) to a factor.
#' Why: Tells kknn to do classification (not regression).
#' Why classification and why set the response to factor first?
#' Why classification: Your target R1 encodes classes (0 = deny, 1 = approve).
#'  We want to predict which class, not a continuous number. That’s a classification problem.
#' Why factor: In R, modeling functions decide between regression vs classification based on the type of the response:
#'   numeric response → treated as regression
#' factor response → treated as classification
#' What is it originally?: In this dataset R1 is read as numeric (0/1). 
#' If you leave it numeric, KNN could be treated as regression (predicting a probability-like mean of neighbors).
#' Do you always need a factor? For classification in most R modeling functions 
#' (including kknn used this way), yes — set the response to a factor so the 
#' function returns class labels (0/1 as levels) and uses classification metrics.
#' Why here: We want a yes/no decision (approve/deny). 
#' Converting to factor tells the algorithm to vote a class, not return a numeric average.
cc$R1 <- as.factor(cc$R1)

#' Show previews of the dataset 
#' What: Prints shape (rows/cols), first rows, and column names.
#'Why: Quick sanity checks: 654×11, data looks right, and names match expectations. 
dim(cc)
head(cc)
colnames(cc)

#' Total Rows 
#' What: Saves the number of rows.
#' Why: Used to sample indices for splits.
#' nrow(x) is a base R function that returns the number of rows in 
#' object x (usually a data frame or matrix). Yes, it’s predefined in R.
#' Why assign to n: Convenience. We use n repeatedly when sampling indices and
#'  looping, so n <- nrow(cc) avoids retyping nrow(cc) and keeps code readable.
n <- nrow(cc) 

#' These are my components for training my KNN Model 
#' Training at (60%), validation (20%),  test (20%) 
#' 1:n creates the vector of row indices: c(1, 2, ..., n).
#' sample(1:n, size = 0.6*n) draws a random subset of indices of length 0.6*n (i.e., 60% of the rows) 
#' without replacement by default. That becomes the training set.
#' Why that formula: A standard split is 60/20/20 or 70/15/15. You chose 60% for training. Then:
#'   remaining <- setdiff(1:n, training) → the 40% not in training

#' validation <- sample(remaining, size = 0.5*length(remaining)) → half of the remaining → 20% of
#'  total (validation)
#' test <- setdiff(remaining, validation) → the rest → 20% (test)
"So the “formula” is: to decide the desired proportions (here 0.6 / 0.2 / 0.2) and sample 
indices accordingly so they’re disjoint and cover all rows."
training <- sample (1:n, size = 0.6*n)
remaining <- setdiff(1:n, training)
validation <- sample(remaining, size = 0.5*length(remaining))
test <- setdiff(remaining, validation)

#' Create splits
#' What: Subsets the data frame by those indices.
#' Why: Produces the actual three datasets used in modeling.
#' data frame subsetting is is as df[rows, columns]
#' Leaving the columns section blank means all columns. 
train_data <- cc[training, ]
valid_data <- cc[validation, ]
test_data <- cc[test, ]

#' Train on training data, validate on valid_data. 
#' What: Formula: predict R1 using all other columns.
#' Why: Tells kknn which columns are predictors and which is the response.
"R1 ~ . is a formula meaning: model R1 as a function of all other columns in the data frame.
Left-hand side (LHS): the response (R1).
Right-hand side (RHS): the predictors. The dot . is shorthand for “all other variables in the data”.
When you call kknn(R1 ~ ., train = ..., test = ...), the function:
Looks at the formula to know which column is the target and which are features.
For each test row, finds the k nearest training rows using the features (scaled if scale=TRUE).
Votes among their R1 labels (because R1 is a factor) to output a class prediction."
f <- R1 ~ . 


#' example of k of my choosing. 
" What this does: 
kknn() is the function from the kknn package that fits a k-nearest neighbors classifier (or regressor).
f is the formula: R1 ~ . → predicts the column R1 using all other columns.
train = train_data: use the training set to find the nearest neighbors.
test = valid_data: apply the model to the validation set (so predictions are made for those rows).
k = 10: tells the algorithm to look at the 10 nearest neighbors for each validation row when predicting.
scale = TRUE: standardizes (rescales) all predictor variables so they’re on the same scale before computing distances.
This is important because KNN uses Euclidean distance by default; otherwise, a large-valued feature (like A15, which can be in the thousands) would dominate the distance calculation.
Why:
I'm trying out one choice of k (10) to see how well it works on this validation set.
Result:
m is a fitted kknn object. It stores the neighbors found, the predicted values for the test set, and other details."
m <- kknn(f, train = train_data, test = valid_data, k = 10, scale = TRUE)


#' Accuracy on validation 
"fitted(m) extracts the predicted classifications for the validation data from the model object m.
valid_data$R1 is the true labels for the validation rows.
fitted(m) == valid_data$R1 compares them element-by-element, returning TRUE if correct, FALSE if wrong.
mean(...) converts TRUE/FALSE to 1/0 and averages them.
Example: if 85 out of 100 predictions were correct → mean = 0.85.
Why:
This gives the accuracy of this KNN classifier on the validation set when k = 10.
Accuracy = proportion of correctly classified observations.
Result:
A single number between 0 and 1. In this case, around 0.8397 = 83.97% accuracy.
It looks to Valid_data$R1 because I need to draw out the true labels of the column to 
compare against the predictions of the model to test the accuracy.
The '$' is used to pull out a specific column from the dataframe by its name 'R1'. 
fitted(m) = vector of predicted classes for the validation set.
valid_data$R1 = vector of true classes for the validation set.
You get a vector of logicals (TRUE/FALSE):
TRUE if the model predicted correctly for that row.
FALSE if the prediction was wrong.
Finally, mean(...) turns this into an accuracy score (the proportion correct)."
mean(fitted(m) == valid_data$R1)



#' Up to this point it generates random kernels for the selection and you 
#' obtain different accuracies for each run through the dataset. 


#' Creates a vector of possible k values to test. 
ks <- c(1,3,5,7,11,13,15,17,20,25)


#' This prepares the results table. Makes the acc empty dataframe with one row per k and an accuracy column.
#' Why: So you can fill it with accuracy results and later compare them easily.
#' Purpose: Storage for evaluation results. 
val_results <- data.frame(k = ks, acc = NA_real_)

#' This is the validation loop I created. Its purpose is to maximize validation accuracy to find the best K.
" Loops over each candidate k.
Fits a KNN classifier on training data, predicts on validation data.
Computes accuracy for that k and saves it into val_results.
Why: This is model selection. You’re trying different k’s to see which one 
generalizes best to unseen (validation) data."
"Seq_along produces sequence like 1,2,3.etc. It is need to create a loop index that covers all positions 
in Ks. Seq_along produces a neccessary and clean empty sequence.
j takes the values 1,2,3 lengths of ks. while ks[j] takes out the j-th element of the vector ks. 
it is assigned to k so we can then pass the kknn(..., k=k,...).
ex: on the first loop, j=1, so ks[1] = 1 which translates to k=1. Next j=2 so ks[2] = 3 and so k=3. 
This is from the selected vectors I chose above to compile this. 
The only reason I am not using 'for (k in ks) {fit <- kknn(..., k=k,...)} is because I need the J
in order to store the index and the value ks[j] in my results table which I use for val_results$acc[j]). 
The code will be futher below but it makes sense."
for (j in seq_along(ks)) {
  k <- ks[j]
  fit <- kknn(f, train = train_data, test = valid_data, k = k, scale = TRUE)
  val_results$acc[j] <- mean(fitted(fit) == valid_data$R1)
}



#' This code segment will extract the best K. 
"Finds the row of val_results with the highest accuracy.
Pulls out the corresponding k and accuracy.
Prints the winning k and its validation accuracy.
Why: We don’t want to just guess a k. This automates the choice using validation results.
Purpose: Establishes the optimal hyperparameter based on validation."
"which.max(x) returns the best maximum position in an index from a numeric vector. 
Example:
x <- c(0.82, 0.85, 0.84)
which.max(x)
# [1] 2"
" I use it here to fin the row that has the best K. 
Best_row is a one =row dataframe containing both the accuracy and k for the winning row.
Bestrow$k extracts the k value from that winning row. 
The same methodology is attributed to best_val_acc"
best_row <- val_results[which.max(val_results$acc), ]
best_k   <- best_row$k
best_val_acc <- best_row$acc
cat("Best k on validation =", best_k, " | Validation accuracy =", round(best_val_acc, 4), "\n")




#' Retrain on train+validation, evaluate once on test using the most optimal K
"Combines training + validation into a single larger dataset (trainval_data).
Fits a final KNN with the chosen best_k and tests on the held-out test set.
Why: Once you’ve tuned hyperparameters using validation, you want the final
model to benefit from all available data except test.
Purpose: Build the best possible model for the final evaluation."
trainval_data <- rbind(train_data, valid_data)
final_fit <- kknn(f, train = trainval_data, test = test_data, k = best_k, scale = TRUE)


#'Evaluate model on test set to compose final score. 
"Makes predictions on the test set.
Compares them to the true labels.
Computes test accuracy.
Prints the final performance.
Why: The test set has been untouched until now. This gives an honest estimate
of how well your tuned KNN classifier generalizes to new, unseen data.
Purpose: Final performance check. This is the number you’d report in your homework as the test accuracy."
test_acc <- mean(fitted(final_fit) == test_data$R1)
cat("Test accuracy with k =", best_k, ":", round(test_acc, 4), "\n")



# Pretty print
"first code line cleans the accuracy column for the table that we are about to print"
val_results$acc <- round(val_results$acc, 4)
# The Results table
" This is the full table (k + accuracy)"
val_results[order(val_results$k), ]
# Best k by this split:
cat("Best k on this split =", best_row$k, " | Validation acc =", best_row$acc, "\n")


