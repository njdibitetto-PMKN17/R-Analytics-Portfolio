#Matrices / Matrix 
#'To create a matrix in R, you can use the matrix() function. The matrix() function has two main arguments that you enter in the parentheses. 
#'First, add a vector. The vector contains the values you want to place in the matrix. Next, add at least one matrix dimension. You can choose
#'to specify the number of rows or the number of columns by using the code nrow = or ncol =. 

matrix(c(3:8), nrow = 2)

#You can also choose to specify the number of columns (ncol = ) instead of the number of rows (nrow = ). Run the code: 
matrix(c(3:8), ncol = 2)