# ****************************************************************************
#
# DESCRIPTION ####
#
# Basic script
#
# Date: 2024-10-22
#
# Place: KI Flemingsberg NEO Gene
#
# Author: Laura Vossen Engblom
#
# ****************************************************************************

# Load R packages ####
library(ggplot2)

# Read in the data ####
caffeine.data <- read_excel("C:/Users/lauvos/OneDrive - Karolinska Institutet/Documents/CBB/CBB_workshops/Workshop table1 and ggplot2/caffeine.xlsx")
View(caffeine.data)
str(caffeine.data)

# DATA CLEANING ####

## Correct class ####
caffeine.data$subject <- as.factor(caffeine.data$subject)
caffeine.data$drink <-   as.factor(caffeine.data$drink)
caffeine.data$cups <-    as.factor(caffeine.data$cups)
caffeine.data$gender <-  as.factor(caffeine.data$gender)
caffeine.data$score <-   as.numeric(caffeine.data$score)

# Inspect the data again:
str(caffeine.data)
#View(caffeine.data)

## Change the order of the levels ####
caffeine.data$drink <- factor(caffeine.data$drink, levels=c("greentea", "coffee"))


# ... Do some plotting...






# Clear all ####
rm(list=ls())