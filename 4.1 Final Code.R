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
install.packages("ggplot2", dependencies = TRUE)

#' Set working directory so R knows where to look for the data file
#' What: Changes the working directory.
#' Why: So read.table("credit_card_data-headers.txt", ...) will find the file.
getwd()
setwd("~/Week_2")

#' Must run library code as well to generate KKNN function. 
library(ggplot2)

str(iris)
data(iris)
head(iris)
print(summary(iris))


set.seed(123)

#' This sets variables to be functioned in returning a plot to find efficient 
#' number of clusters for this analysis. 
"Computes total within-cluster sum of squares (WSS) for k = 1..7.
Why: To make an elbow plot and pick a reasonable k (bend typically near k≈3 for Iris).
nstart = 5 runs multiple random starts and keeps the best; iter.max = 15 caps iterations."
#' tot.withiness mean in k-means each point belongs to the nearest cluster center. 
#' The smaller tot.withiness = tighter, denser clusters, and as you increase k, 
#' tot.withinss always goes down (because more clusters = smaller distances).
c.max <- 7
data <- as.matrix(iris[,1:4])
samp <- sapply(1:c.max,function(k){kmeans(data,k,nstart=5,iter.max=15)$tot.withinss})
samp

#' Elbow Plot for cluster analysis. 
#' 1:c.max means in short terms that 1:7 range. it creates that shorthand sequence
#' for the x-axis values of 1,2,3,..7. in reference to c.max.
#' type b stands for both points and lines in the plot. 
#' pch stands for plotting character and the 19 sets it 
#' to this drawn in diamond shape for the plot
#' frame equal to false stands for removes a box/frame around the graph
plot(1:c.max, samp,
     type="b", pch = 19, frame = FALSE, 
     xlab="Number of clusters-K",
     ylab="Cluster Tightness (Total WSS)")

#' Define km with kmeans which requires you to pick k = numbers of clusters. 
#'
#' 1:4 uses all 4 predictors for 
#' I will choose to start with 3 clusters based on plot so I set centers = 3. Then have 
#' nstart = 20 which runs k-means 20 times with different seeds and keeps the best solution. 
km <- kmeans(iris[, 1:4], centers = 3, nstart = 20)

#' This evaluates cluster quality. (unsupervised)
#' This lets me know how many of each species ended up in each cluster. 
" The cross tab is comparing the rows <- the clusters found by k-means (km$cluster)
the columns <- the actual known species labels (iris$Species)"
table(km$cluster, iris$Species)
"Cluster 1 contains 50 setosa (perfect grouping).
Cluster 2 contains mostly virginica (36) but also 2 misclassified versicolor.
Cluster 3 contains mostly versicolor (48) but 14 virginica mixed in."


#' Finding the best predictors 
# Only petal predictors
"This set is to compare the petal features of petal length and width"
km_petal <- kmeans(iris[,3:4], centers = 3, nstart = 20)
table(km_petal$cluster, iris$Species)

# Only sepal predictors
"This set is to compare sepal features exclusively"
km_sepal <- kmeans(iris[,1:2], centers = 3, nstart = 20)
table(km_sepal$cluster, iris$Species)


#' This computes the accuracy by majority vote per cluster to determine its 
#' efficient attributed cluster. 
"apply function uses cm as the matrix, the margin which is 1 
because each row = one cluster, and we want the cluster’s 'majority species', 
and the max to take the maximum value from each row."
cm <- as.matrix(table(km_petal$cluster, iris$Species))
acc <- sum(apply(cm, 1, max)) / sum(cm)
acc   # proportion correctly grouped

#'This quick plots a visual for the petal features. 
plot(iris[, 3:4],
     col = km_petal$cluster, pch = 19,
     xlab = "Petal.Length", ylab = "Petal.Width",
     main = "k-means (k = 3) on Petal Predictors")

#'This quick plots a visual for the sepal features 
#' 
plot(iris[, 1:2],
     col = km_sepal$cluster, pch = 19,
     xlab = "Sepal.Length", ylab = "Sepal.Width",
     main = "k-means (k = 3) on Sepal Predictors")

#' This segment of code below is to compare the accuracies of all the different methods 
#' Here I can directly compare predictor sets.
km_all   <- kmeans(iris[, 1:4], centers = 3, nstart = 20)
km_sepal <- kmeans(iris[, 1:2], centers = 3, nstart = 20)

acc_all   <- { cm <- table(km_all$cluster,   iris$Species);   sum(apply(cm, 1, max))/sum(cm) }
acc_sepal <- { cm <- table(km_sepal$cluster, iris$Species);   sum(apply(cm, 1, max))/sum(cm) }

acc_all; acc_sepal; acc   # compare accuracies

#' This computes the final table for accuracy for the best in the model based on 
#' my findings, the diagonal accuracy is in reference to cluster numbering 
#' lining up with that classification of species. Which is does, hence why the rating 
#' is of 0.96 for its accuracy. 
cm <- table(km_petal$cluster, iris$Species)
accuracy <- sum(diag(cm)) / sum(cm)
accuracy
