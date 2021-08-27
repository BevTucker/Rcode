

#install.packages("recipes" , repos = "http://cran.r-project.org", type = "binary")
library(recipes)
#install.packages(c("lme4","e1071","arm","mnormt"))
library(lme4)
library(e1071)
library(arm)
library(mnormt)
#install.packages("caret")
library(caret)
library(dplyr)




head(EURO)


#split the data for training and test
#TRAINING DATA

set.seed(2)
slice_sample(EURO,prop=0.75)->EURO1
tail(EURO1)


#TEST DATA
setdiff(EURO,EURO1)->EURO2
tail(EURO2)

# Train the data
train(CLASS ~ VARIANCE + SKEWNESS + CURTOSIS + ENTROPY)

# If you have to many variables we canuse the . after the tilda like train(CLASS.,)
#Use the data in EURO1 and train a KNN model that predicts the CLASS of a Euro banknote
#i.e. forged or genuine. Preprocess the predictors so that they all have similar scales.
#Regardless of the range of the original data, 
#Z Scores typically range from ≈−3 to +3. • When we convert all predictors to Z Scores, they all have similar scales

#find out the best seend for the model
set.seed(1)
train(CLASS ~ .,data = EURO1, method="knn", preProcess=c("center", "scale"),tuneLength = 20)-> FORGER
FORGER

set.seed(9)
train(CLASS ~ .,data = EURO1, method="knn", preProcess=c("center", "scale"),tuneLength = 20)-> FORGER
FORGER


tail(EURO2)


predict(FORGER,EURO2)-> GUESS
tail(GUESS)



confusionMatrix(GUESS,EURO2$CLASS)

#Correct predictions: 161 + 211 = 372 
#All predictions: 160 + 211 + 0 + 0 = 372 
#372/372 = 1
#Accuracy: 100

tail(EURO1)



data.frame(VARIANCE= -0.57, SKEWNESS= -10.33, CURTOSIS = 8.78, ENTROPY= -2.11)->DOUGH
DOUGH


predict(FORGER,DOUGH)


predict(FORGER,DOUGH, type="prob")

#0.8571429*7 = 6 is forged
#0.1428571*7 =1 is genuine
