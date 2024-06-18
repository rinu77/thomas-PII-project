###############################
# analysis script for simple model with one predictor
#
#this script loads the processed, cleaned data, does a simple analysis
#and saves the results to the results folder

#load needed packages. make sure they are installed.
library(ggplot2) #for plotting
library(broom) #for cleaning up output from lm()
library(here) #for data loading/saving

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
