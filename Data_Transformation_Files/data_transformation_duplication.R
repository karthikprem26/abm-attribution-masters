# install packages
install.packages("tidyr")
install.packages("dplyr")
install.packages("tibble")
install.packages("randomGLM")

# load libraries
library(tidyr)
library(dplyr)  
library(reshape)
library(reshape2)
library(randomGLM)


# Note: Please excuse badly named variables, will fix it soon

# Load the Data
customer_details <- read.csv("customer-details.csv", stringsAsFactors = F)
logs <- read.csv("raw-level-logs.csv", stringsAsFactors = F)


###################################################
# Removing duplicates and increasing conversion time by 1
###################################################

logs_filter_initial <- logs[!(logs$current.channel == "converted" & logs$conversion.value == 0) & logs$current.channel != "0",]
logs_filter <- logs_filter_initial

logs_filter <- logs_filter %>%  dplyr::mutate(ticks = ifelse(current.channel == "converted", as.numeric(ticks) + 1, as.numeric(ticks)))

###################################################
# Ranking Data
###################################################
ranked_data <- logs_filter %>%
  dplyr::group_by(who,purchase.no) %>%
  dplyr::mutate(rank = row_number()) %>%
  dplyr::arrange(who,purchase.no)


###################################################
# Data for Bagged Logistic Regression
###################################################
# create time difference for each touchpoint at who and purchase number level
temp <- ranked_data %>% dplyr::group_by(who,purchase.no) %>% dplyr::mutate(time_diff = (max(ticks) - ticks))

# select relevant data and select average time difference for touchpoints repeated at who and purchase number level
temp_blr <- temp %>% dplyr::select(who,purchase.no,current.channel,time_diff) %>% dplyr::group_by(who,purchase.no,current.channel) %>% dplyr::summarise(t_diff = mean(time_diff))

# spread the data to form customer paths
temp_blr_time <- data.frame(tidyr::spread(data = temp_blr, key = current.channel, value = t_diff))

# change NAs in converted column to non-conversion flag and others to conversion flag
temp_blr_time$converted <- ifelse(is.na(temp_blr_time$converted),0,1) 

# set all other NAs to zero
temp_blr_time[is.na(temp_blr_time)] <- 0

############################################################################
# Data for Markov chain
############################################################################

# select relevant columns
temp_channels <- ranked_data %>% dplyr::select(who,purchase.no,current.channel,rank)

# spread and transform to customer path
temp_channels <- tidyr::spread(data = temp_channels, key = rank, value = current.channel)

############################################################################
# Performing Bagged Logistic Regression
############################################################################
x_train <- temp_blr_time[,4:ncol(temp_blr_time)]
y_train <-  as.vector(temp_blr_time[,3])

RGLM <- randomGLM(x_train, y_train, classify = TRUE, replace = TRUE, nBags = 30, nFeaturesInBag = ncol(x_train), nCandidateCovariates = ncol(x_train), keepModels = TRUE, nThreads = 1)
RGLM$models[[1]]

