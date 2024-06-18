# This script creates visualizations for the analysis results.

# Load needed packages
library(ggplot2)
library(here)

# Load linear regression results
linear_regression_results <- readRDS(here::here("results", "tables", "linear_regression_results.rds"))

# Load random forest importance results
random_forest_importance <- readRDS(here::here("results", "tables", "random_forest_importance.rds"))

# Create a plot for linear regression coefficients
plot_lm <- ggplot(linear_regression_results, aes(x = term, y = estimate)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  theme_minimal() +
  labs(title = "Linear Regression Coefficients", x = "Predictor", y = "Estimate")

# Save the linear regression plot
ggsave(here("results", "figures", "linear_regression_plot.png"), plot = plot_lm)

# Create a plot for random forest feature importance
plot_rf <- ggplot(random_forest_importance, aes(x = reorder(Feature, Importance), y = Importance)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  theme_minimal() +
  labs(title = "Random Forest Feature Importance", x = "Feature", y = "Importance") 


# Save the random forest plot
ggsave(here("results", "figures", "random_forest_importance_plot.png"), plot = plot_rf)