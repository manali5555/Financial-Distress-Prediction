# Loading the necessary libraries
library(caretEnsemble)
library(ROSE)
library(caret)
library(tidyr)
library(magrittr)
library(DMwR2)
library(smotefamily)
library(tidyverse)
library(DataExplorer)
library(ggcorrplot)
library(psych)
library(dplyr)
library(randomForest)
library(pROC)
library(knitr)

# Loading the dataset
financial_data <- read.csv("/Users/manaliramchandani/Downloads/Financial_Distress.csv")

# Separating the features and target variable
features <- financial_data[, -1]
target_column <- financial_data$Financial.Distress

# Handling missing values
cleaned_financial_data <- financial_data
cleaned_financial_data[, sapply(financial_data, is.numeric)] <- lapply(financial_data[, sapply(financial_data, is.numeric)], function(x) replace_na(x, 0))

# Quantifying as a binary column
cleaned_financial_data <- cleaned_financial_data %>%
  mutate(financial_target = ifelse(Financial.Distress > -0.5, 0, 1))

# Removing company, time, financial distress (converted as financial_target)
cleaned_financial_data <- cleaned_financial_data[, -c(1:3)]
cleaned_financial_data$financial_target <- as.factor(cleaned_financial_data$financial_target)

# Splitting test and train datasets
index_train = sample(1:nrow(cleaned_financial_data), 0.7 * nrow(cleaned_financial_data))
train = cleaned_financial_data[index_train, ]
test <- cleaned_financial_data[-index_train, ]

# Under Sampling train dataset
undersampling <- ovun.sample(financial_target ~ ., data = train, 
                             p = 0.5, seed = 225, 
                             method = "under")$data

# Over Sampling train dataset
oversampling_rose <- ROSE(financial_target ~ ., data = train, seed = 542)$data
oversampling <- ovun.sample(financial_target ~ ., data = train, 
                            p = 0.28, seed = 128, 
                            method = "over")$data

# SMOTE sampling
smote_sampling <- SMOTE(train[, -which(colnames(train) == "financial_target")], train$financial_target)

smote_sampled <- smote_sampling[["data"]]
smote_sampled$class <- as.factor(smote_sampled$class)

# Summary for not-sampled train dataset
set.seed(239)
model_without_sampling <- glm(financial_target ~ .,
                              data = train, family = "binomial")

# Modelling accuracy for, not-sampled train dataset
pred <- predict(model_without_sampling, test, type = "response")
pred <- as.integer(pred > 0.5)
cm_undersampled <- confusionMatrix(as.factor(pred), test$financial_target)

# Modelling accuracy for Undersampled dataset
modeldown <- glm(financial_target ~ ., data = undersampling, family = "binomial")
undersampled_prediction <- predict(modeldown, test, type = "response")
undersampled_result <- as.integer(undersampled_prediction > 0.5)
cm_undersampled <- confusionMatrix(as.factor(undersampled_result), test$financial_target)

# Modelling accuracy for Oversampled dataset
oversampled_model <- glm(financial_target ~ ., data = oversampling_rose, family = "binomial")
oversampled_prediction <- predict(oversampled_model, test, type = "response")
oversampled_result <- as.integer(oversampled_prediction > 0.5)
cm_oversampled <- confusionMatrix(as.factor(oversampled_result), test$financial_target)

# Modelling accuracy for SMOTE sampled dataset
smote_model <- glm(class ~ ., data = smote_sampled, family = "binomial")
smote_prediction <- predict(smote_model, test, type = "response")
smote_result <- as.integer(smote_prediction > 0.5)
cm_smote <- confusionMatrix(as.factor(smote_result), test$financial_target)

# Function to calculate F1 Score from confusion matrix
calculate_F1_Score <- function(cm) {
  precision <- cm$byClass['Pos Pred Value']
  recall <- cm$byClass['Sensitivity']
  f1_score <- 2 * (precision * recall) / (precision + recall)
  return(f1_score)
}

#F1 Scores for each model
f1_undersampled <- calculate_F1_Score(cm_undersampled)
print(paste("F1 Score with Undersampling:", f1_undersampled))

f1_oversampled <- calculate_F1_Score(cm_oversampled)
print(paste("F1 Score with Oversampling:", f1_oversampled))

f1_smote <- calculate_F1_Score(cm_smote)
print(paste("F1 Score with SMOTE:", f1_smote))

# Visualizing the confusion matrix for Undersampled model
fourfoldplot(cm_undersampled$table, color = c("#CC6666", "#99CC99"), conf.level = 0, margin = 1)
title("Confusion Matrix - Undersampled Model")

# Visualizing the confusion matrix for Oversampled model
fourfoldplot(cm_oversampled$table, color = c("#CC6666", "#99CC99"), conf.level = 0, margin = 1)
title("Confusion Matrix - Oversampled Model")

# Visualizing the confusion matrix for SMOTE model
fourfoldplot(cm_smote$table, color = c("#CC6666", "#99CC99"), conf.level = 0, margin = 1)
title("Confusion Matrix - SMOTE Model")
