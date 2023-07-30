#caret = Classification And Regression Tree

library(caret)
library(tidyverse)

#train test split
#1. split data
#2. train model
#3. score
#4. evaluate

`
glimpse(mtcars)

# split data 80% 20%
#()เป็นการประกาศค่าตวแปร
train_test_split <- function(data, trainRatio = 0.7){
  set.seed(42)
  (n <- nrow(mtcars))
  (id <- sample(1:n, size=trainRatio*n))
  
  train_data <- mtcars[id,]
  test_data <- mtcars[-id,]
  return(list(train=train_data,test=test_data))
  
}

set.seed(42)
splitData <- train_test_split(mtcars,0.8)
train_data <- splitData$train
test_data <- splitData$test ## splitData[["test"]]



#train model

model <- lm(mpg ~ hp + wt + am, data = train_data)

#score model
mpg_pred <- predict(model, newdata = test_data)

#evaluate model
#MAE, MSE, RMSE

mae_metric <- function(actual, prediction) {
  # mean absolute error
  abs_error <- abs(actual - prediction)
  mean(abs_error)
}


mae_metric(test_data$mpg, mpg_pred)


mse_metric <- function(actual, prediction) {
  # mean absolute error
  sq_error <- (actual - prediction)**2
  mean(sq_error)
}

mse_metric(test_data$mpg, mpg_pred)

#MAE treats every data point the same
#MSE treats ตัวที่ผิดเยอะๆ


rmse_metric <- function(actual, prediction) {
  # root mean square error
  sq_error <- (actual - prediction)**2
  sqrt(mean(sq_error))
}

rmse_metric(test_data$mpg, mpg_pred)


## CARET = Classification And Regression Tree
## Supervised Learning = Prediction
library(caret)

# 1. split model
splitData <- train_test_split(mtcars,0.7)
train_data <- splitData[[1]]
test_data <- splitData[[2]]



# 2. train model
#mpg = f(hp, wt,am)
set.seed(42)
#sett metohod
ctrl <- trainControl(method = "boot",
                     number = 100,
                     verboseIter = TRUE) 

ctrl <- trainControl(method = "LOOCV",
                     #number = 100,
                     verboseIter = TRUE) 

ctrl <- trainControl(method = "cv", #k-fold golden standard
                     number = 5, # k= 5
                     verboseIter = TRUE) 
  
lm_model <- train(mpg ~ hp + wt + am, 
               data = train_data,
               method ="lm",
               trControl = ctrl)

#model
rm_model <- train(mpg ~ hp + wt + am, 
                  data = train_data,
                  method ="rf",
                  trControl = ctrl)

#Knn_model
knn_model <- train(mpg ~ hp + wt + am, 
                  data = train_data,
                  method ="knn",
                  trControl = ctrl)

# 3. score model
 p<- predict(model, newdata = test_data)

# 4.Evaluate model
rmse_metric(test_data$mpg,p)

# 5. save model

saveRDS(model,"linear_regression_v1.RDS")


(new_cars <- data.frame(
  hp = c(150, 200, 250),
  wt = c(1.25, 2.2, 2.5),
  am = c(0,1,1)
  
))

model <- readRDS("linear_regression_v1.RDS")

new_cars$mpg_pred <- predict(model, newdata = new_cars)

View(new_cars)

 #leverage




