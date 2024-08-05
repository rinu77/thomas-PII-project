###############################
# processing script
#
#this script loads the raw data, processes and cleans it 
#and saves it as Rds file in the processed-data folder
#
# Note the ## ---- name ---- notation
# This is done so one can pull in the chunks of code into the Quarto document
# see here: https://bookdown.org/yihui/rmarkdown-cookbook/read-chunk.html
###############################


## ---- packages --------
#load needed packages. make sure they are installed.
library(readxl) #for loading Excel files
library(dplyr) #for data processing/cleaning
library(tidyr) #for data processing/cleaning
library(skimr) #for nice visualization of data 
library(here) #to set paths


## ---- loaddata --------
#path to data
#note the use of the here() package and not absolute paths
data_location <- here::here("data","raw-data","medical_insurance2.csv")
#load data. 
#note that for functions that come from specific packages (instead of base R)
# I often specify both package and function like so
#package::function() that's not required one could just call the function
#specifying the package makes it clearer where the function "lives",
#but it adds typing. You can do it either way.
rawdata <- read.csv(data_location)


## ---- exploredata --------
#take a look at the data
dplyr::glimpse(rawdata)
#another way to look at the data
summary(rawdata)
#yet another way to get an idea of the data
head(rawdata)
#this is a nice way to look at data
skimr::skim(rawdata)

# Convert categorical variables to factors
rawdata$sex <- as.factor(rawdata$sex)
rawdata$smoker <- as.factor(rawdata$smoker)
rawdata$region <- as.factor(rawdata$region)

## ---- savedata --------
# all done, data is clean now. 
# Let's assign at the end to some final variable
# makes it easier to add steps above
processeddata <- rawdata
# location to save file
save_data_location <- here::here("data","processed-data","processeddata2.rds")
saveRDS(processeddata, file = save_data_location)


