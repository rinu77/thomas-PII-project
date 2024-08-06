###############################
# analysis script to perform comprehensive analysis involve training and testing the data
# running linear regression and random forest models and 
# finally conducting model evaluation

#this script loads the processed, cleaned data, does a linear regression and
# random forest analysis
#and saves the results to the results folder

# Load needed packages
library(ggplot2) # for plotting
library(broom) # for cleaning up output from lm()
library(here) # for data loading/saving
library(randomForest) # for random forest analysis
library(caret) # for train-test split and model evaluation

# Path to data
data_location <- here::here("data","processed-data","processeddata2.rds")

# Load data
mydata <- readRDS(data_location)

# Split the data into training and testing sets
set.seed(123) # for reproducibility
trainIndex <- createDataPartition(mydata$charges, p = 0.8, list = FALSE)
data_train <- mydata[trainIndex, ]
data_test <- mydata[-trainIndex, ]

# Fit Linear Regression Model
lmfit <- lm(charges ~ age + bmi + children + sex + smoker + region, data = data_train)

# Predict on the test set
lm_predictions <- predict(lmfit, newdata = data_test)

# Evaluate Linear Regression Model
lm_rmse <- sqrt(mean((data_test$charges - lm_predictions)^2))
lm_mae <- mean(abs(data_test$charges - lm_predictions))
lm_r2 <- 1 - sum((data_test$charges - lm_predictions)^2) / sum((data_test$charges - mean(data_test$charges))^2)

cat("Linear Regression Model Evaluation:\n")
cat("RMSE: ", lm_rmse, "\n")
cat("MAE: ", lm_mae, "\n")
cat("R-squared: ", lm_r2, "\n")

# Save Linear Regression Results
lmtable <- broom::tidy(lmfit)
table_file1 <- here("results", "tables", "linear_regression_results.rds")
saveRDS(lmtable, file = table_file1)

# Create a plot for linear regression coefficients
plot_lm <- ggplot(lmtable, aes(x = reorder(term, estimate), y = estimate, fill = term)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  theme_minimal() +
  labs(title = "Linear Regression Coefficients", x = "Term", y = "Estimate") +
  scale_fill_brewer(palette = "Set2")

# Save the linear regression plot
ggsave(here("results", "figures", "linear_regression_plot.png"), plot = plot_lm)

# Fit Random Forest Model
model_rf <- randomForest(charges ~ ., data = data_train, ntree = 100)

# Predict on the test set
rf_predictions <- predict(model_rf, newdata = data_test)

# Evaluate Random Forest Model
rf_rmse <- sqrt(mean((data_test$charges - rf_predictions)^2))
rf_mae <- mean(abs(data_test$charges - rf_predictions))
rf_r2 <- 1 - sum((data_test$charges - rf_predictions)^2) / sum((data_test$charges - mean(data_test$charges))^2)

cat("\nRandom Forest Model Evaluation:\n")
cat("RMSE: ", rf_rmse, "\n")
cat("MAE: ", rf_mae, "\n")
cat("R-squared: ", rf_r2, "\n")

# Extract and save feature importance from Random Forest Model
importance_rf <- importance(model_rf)
importance_df <- data.frame(Feature = rownames(importance_rf), Importance = importance_rf[, 1])
table_file2 <- here("results", "tables", "random_forest_importance.rds")
saveRDS(importance_df, file = table_file2)

# Create a plot for random forest feature importance with color
plot_rf <- ggplot(importance_df, aes(x = reorder(Feature, Importance), y = Importance, fill = Feature)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  theme_minimal() +
  labs(title = "Random Forest Feature Importance", x = "Feature", y = "Importance") +
  scale_fill_brewer(palette = "Set3")

# Save the random forest plot
ggsave(here("results", "figures", "random_forest_importance_plot.png"), plot = plot_rf)

# Print the plot to the console
print(plot_rf)
