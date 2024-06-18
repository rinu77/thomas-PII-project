###############################
# analysis script
#
#this script loads the processed, cleaned data, does a simple analysis
#and saves the results to the results folder

#load needed packages. make sure they are installed.
library(ggplot2) #for plotting
library(broom) #for cleaning up output from lm()
library(here) #for data loading/saving
library(randomForest) #for random forest analysis

#path to data
#note the use of the here() package and not absolute paths
data_location <- here::here("data","processed-data","processeddata2.rds")

#load data. 
mydata <- readRDS(data_location)


######################################
#Data fitting/statistical analysis
######################################

######################################
# Simple Models with One Predictor
######################################

# List of predictor variables
predictors <- c("age", "bmi", "children", "sex", "smoker", "region")

# Initialize a list to store results
results_list <- list()

# Loop through each predictor and fit a simple linear regression model
for (predictor in predictors) {
  formula <- as.formula(paste("charges ~", predictor))
  lmfit <- lm(formula, data = mydata)
  
  # Place results from fit into a data frame with the tidy function
  lmtable <- broom::tidy(lmfit)
  
  # Add the results to the list
  results_list[[predictor]] <- lmtable
  
  # Print the results for each model
  print(paste("Results for predictor:", predictor))
  print(lmtable)
}

# Combine all results into a single data frame
results_df <- do.call(rbind, lapply(names(results_list), function(x) {
  cbind(predictor = x, results_list[[x]])
}))

# Save the combined results table
table_file <- here("results", "tables", "simple_models_results.rds")
saveRDS(results_df, file = table_file)

# Print combined results
print(results_df)

############################
#### Linear regression analysis
# fit linear model using charges as outcome, age, bmi, children, sex, smoker and region as predictors

lmfit1 <- lm(charges ~ age + bmi + children + sex + smoker + region, mydata)


# place results from fit into a data frame with the tidy function
lmtable1 <- broom::tidy(lmfit1)

#look at fit results
print(lmtable1)

# save fit results table  
table_file1 = here("results", "tables", "linear_regression_results.rds")
saveRDS(lmtable1, file = table_file1)

############################
#### Random Forest Analysis
# let's capture complex interaction between features

model_rf <- randomForest(charges ~ ., mydata, ntree = 100)  

# Extract feature importance
importance_rf <- importance(model_rf)
importance_df <- data.frame(Feature = rownames(importance_rf), Importance = importance_rf[, 1])

# look at feature importance
print(importance_df)

# save feature importance table  
table_file2 <- here("results", "tables", "random_forest_importance.rds")
saveRDS(importance_df, file = table_file2)
