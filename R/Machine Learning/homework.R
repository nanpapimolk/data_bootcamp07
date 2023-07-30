library(readxl)
library(caret)

hpi <- read_excel("House Price India.xlsx")



train_test_split <- function(data, trainRatio = 0.7){
  set.seed(42)
  (n <- nrow(hpi))
  (id <- sample(1:n, size=trainRatio*n))
  
  train_data <- hpi[id,]
  test_data <- hpi[-id,]
  return(list(train=train_data,test=test_data))
  
}

splitData <- train_test_split(hpi,0.7)
train_data <- splitData[[1]]
test_data <- splitData[[2]]


#2 . model


# 2. train model
#mpg = f(hp, wt,am)
set.seed(42)
#sett metohod


ctrl <- trainControl(method = "cv", #k-fold golden standard
                     number = 5, # k= 5
                     verboseIter = TRUE) 


# 2. train model
#mpg = f(hp, wt,am)
set.seed(42)
#sett metohod


ctrl <- trainControl(method = "cv", #k-fold golden standard
                     number = 5, # k= 5
                     verboseIter = TRUE) 


#model
(lm_model <- train(log(Price) ~ living_area + grade_of_the_house + Built_Year, 
                  data = train_data,
                  method ="lm",
                  trControl = ctrl))

# 3. score model
p<- predict(lm_model, newdata = test_data)

# 4.Evaluate model
rmse_metric <- function(actual, prediction) {
  # root mean square error
  sq_error <- (actual - prediction)**2
  sqrt(mean(sq_error))
}
rmse_metric(log(test_data$Price),p)
















(knn_model <- train( log(Price) ~ living_area + grade_of_the_house + Built_Year, 
                   data = train_data,
                   method ="knn",
                   trControl = ctrl))

#model
(rf_model <- train(log(Price) ~ living_area + grade_of_the_house , 
                  data = train_data,
                  method ="rf",
                  trControl = ctrl))


