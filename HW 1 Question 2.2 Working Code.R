#Install packages and load the library
install.packages("kernlab", dependencies = TRUE)
library(kernlab)

#Load source data into the script file. 
setwd("~/data 2.2")

#'For the code below, I used the dataset that includes the headers
#'Therefore I need to include a header = TRUE segment, followed by sep = T
#'to make note the file is tab-delimited. 
data <- read.table("credit_card_data-headers.txt", header = TRUE, sep = "\t")

# Display preview data for sanity check
head(data)

# Call ksvm. Vanilladot is a simple linear kernel.
model <- ksvm(as.matrix(data[,1:10]), as.factor(data[,11]),type="C-svc",
              kernel="vanilladot", C=100,scaled=TRUE)
model

# calculate a1...am
a <- colSums(model@xmatrix[[1]] * model@coef[[1]])
a
#'ModelMatrix is the support vectors of xi
#'ModelCoefficient is the alpha coefficients in ai
#'If you multiply each support vector bu its alpha, 
#'you get a matrix of weightes support vectors. 
#
# calculate a0
a0 <- -model@b
a0
#'b is the bias variable which is added to increase margin for this linear kernel.

# see what the model predicts
pred <- predict(model,data[,1:10])
pred
#'data[all_rows, columns 1 through 10]
#'Each row gets predicted as "0" for deny or "1" for approve.  
#'This gets applied to all 654 applications. 

#See what fraction of the model’s predictions match the actual classification
sum(pred == data[,11]) / nrow(data)
#' my model generated a score of .8639 which is 86% accurate. 
#' When I change the C to a larger number of 7924561, my models accuracy 
#' reduces to being 70.9% accurate. Another example of C=1000000 I believe
#' which gave an estimate of 62%
#' C is my penalty parameter, therefore the larger it is the less margin I have. 
#' Which also increases Overfitting. Most Optimal C's I have found are in a range
#' of .01 to an estimate range of 100. 
