# ****************************************************************************
#
# DESCRIPTION ####
#
# Script for KI CBB workshop on Table 1 and ggplot2 
#
# Date: 2024-05-17
#
# Place: KI Flemingsberg NEO Gene
#
# Author: Laura Vossen Engblom
#
# ****************************************************************************

# INSTALL AND LOAD ####

## Install R packages ####
# Only needs to be done once for each device
install.packages("writexl")   # for reading in excel files
install.packages("readxl")    # for exporting to excel
install.packages("tidyverse") # set of packages, incl. dplyr package
install.packages("gtsummary") # for table 1
install.packages("ggplot2")   # for plotting
install.packages("survival")  # for survival analysis 
install.packages("survminer") # for Kaplan Meier curves

## Load R packages ####
library(writexl)  
library(readxl)   
library(tidyverse)
library(gtsummary)
library(ggplot2)
library(survival)
library(survminer)

## Read in the data ####
caffeine.data <- read_excel("C:/Users/lauvos/OneDrive - Karolinska Institutet/Documents/CBB/CBB_workshops/Workshop data exploration/caffeine.xlsx")



## Inspect the data ####
View(caffeine.data)
str(caffeine.data)

# In R, each variable has a class or data types:
# numeric   : numbers or counts (e.g. 10.5, 55, -787.997) 
# factor    : categorical factor (e.g. Treatment) with X levels (e.g. "control", "treated")
# logical   : a.k.a. boolean (TRUE or FALSE)
# character : a.k.a. string or text variable

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








# ___________________________________________ ####
# USEFUL COMMANDS ####
# From the dplyr package, part of the tidyverse

# Cheatsheet ####
#https://rstudio.github.io/cheatsheets/data-transformation.pdf
# All cheatsheets:
#https://rstudio.github.io/cheatsheets/

## select() ####
# This command selects (a) particular variable(s) or columns from your dataset

# Simplest code:
dplyr::select(caffeine.data, score)

# Select only the score variable
scores.data <-
  caffeine.data %>%   # New syntax: |>
  select(
    score
  )
scores.data

# remove the subject ids from the dataset
noid.data <-
  caffeine.data %>%
  select(
    -subject
  )
noid.data




## filter() ####
# This command selects particular rows from your dataset
# Filter only the subjects that had coffee
coffee.data <-
  caffeine.data %>%
  dplyr::filter(drink=="coffee") # I am using dplyr::filter() here to indicate I want the filter() command from the dplyr package (and not from another package)
View(coffee.data)

## *** Exercise 1 *** ####
# a) Select only the greentea data 

# b) Select only females who drank coffee



## mutate() ####
# mutate() simply adds a new column to the dataset
caffeine.data <-
  caffeine.data %>%
  mutate(
    group = paste(cups, drink, sep="_")
  )
caffeine.data$group <- as.factor(caffeine.data$group)



# ___________________________________________ ####
# TABLE 1 ####

# Cheatsheet ####
# gtsummary package website:
# https://www.danieldsjoberg.com/gtsummary/index.html
# Download the cheatsheet by clicking in the top menu on Articles > cheat sheet

# Table 1 of caffeine.data ####

## Simplest ####
## The simplest possible coding:
tbl_summary(caffeine.data)

## The same simple table 1 but using pipe notation, and naming the table1 object:
table1_simple <-
  caffeine.data %>%
  tbl_summary()
table1_simple


## Select variables #### 
## *** Exercise 2 ***####
# a) Remove variable 'subject' 


# b) Remove variable 'subject' and 'score'. Name this object table1


















## Per group ####
table1_groups <-
  caffeine.data %>%
  select(
    -subject
  ) %>%
  tbl_summary(by = group) # <--
table1_groups



## Change statistic ####
table1_mean <-
  caffeine.data %>%
  select(
    -subject
  ) %>%
  tbl_summary(
    by = group,
    statistic = list(all_continuous() ~ "{mean} ({sd})", all_categorical() ~ "{n} ({p}%)") # <--
  )
table1_mean


## Add total column ####
table1_total <-
  caffeine.data %>%
  select(
    -subject
  ) %>%
  tbl_summary(
    by = group
  ) %>%
  add_overall() # <--
table1_total


## Add p-values ####
table1_p <-
  caffeine.data %>%
  select(
    -subject
  ) %>%
  tbl_summary(
    by = group
  ) %>%
  add_p() # <--
table1_p

## Add adjusted p-values ####
table1_q <-
  table1_p %>%
  add_q()  # <--
table1_q

## Change variable names ####
table1_labels <-
  caffeine.data %>%
  select(
    -subject
  ) %>%
  tbl_summary(
    by = group,
    label = list(                 # <--
      gender ~ "Gender",          # <--
      age ~ "Age (years)")        # <--
  ) %>%
  add_overall()
table1_labels

## Change theme ####
# Use the lancet format
theme_gtsummary_journal(journal = "lancet")
theme_gtsummary_compact()
table1_total
reset_gtsummary_theme()

# Table 1 of other datasets ####
# Using a theme on another dataset
table1_mgus <-
  survival::mgus %>%   # The mgus dataset comes with the survival package
  select(
    -id
  ) %>%
  tbl_summary(by=pcdx) 
table1_mgus
# Use the NEJM format
theme_gtsummary_journal(journal = "nejm")
theme_gtsummary_compact()
table1_mgus
reset_gtsummary_theme()


# Export to excel ####
table1_labels %>%
  gtsummary::as_tibble() %>% 
  writexl::write_xlsx(., "Table1_20240520.xlsx")


# More instructions ####
?tbl_summary()
# Vignette:
#https://www.danieldsjoberg.com/gtsummary/articles/tbl_summary.html
# Powerpoint presentation, presented in video by developer:
#https://www.danieldsjoberg.com/gtsummary/index.html            # scroll down for video!

















# ___________________________________________ ####
# DATA VISUALIZATION ####

# Cheatsheet ####
# ggplot2 cheatsheet 
# https://rstudio.github.io/cheatsheets/data-visualization.pdf

# Commonly used plots ####
## Boxplot ####
# Simplest
ggplot(caffeine.data, aes(x=group, y=score)) +
  geom_boxplot()

# add color
ggplot(caffeine.data, aes(x=cups, y=score, fill=drink)) +    # <-- add fill
  geom_boxplot() +
  scale_fill_manual(values=c("darkgreen", "brown"))          # <-- beginners mistake would be to write scale_COLOR_manual

# NB: col is the line color!
ggplot(caffeine.data, aes(x=cups, y=score, col=drink)) +     # <-- add col
  geom_boxplot() +
  scale_color_manual(values=c("darkgreen", "brown"))         # <-- NB! Use scale_COLOR_manual

# separate into facets
ggplot(caffeine.data, aes(x=cups, y=score)) +
  geom_boxplot() +
  facet_grid(. ~ drink)            # <--

# change y gridlines
ggplot(caffeine.data, aes(x=group, y=score)) +
  geom_boxplot() +
  scale_y_continuous(breaks=seq(0,100,10), minor_breaks = seq(0,100,5)) +    # <--
  xlab("Cups and drink") +
  ylab("Score on cognitive test (points)")

# change y limits
ggplot(caffeine.data, aes(x=group, y=score)) +
  geom_boxplot() +
  scale_y_continuous(breaks=seq(0,100,10), minor_breaks = seq(0,100,5)) +
  coord_cartesian(ylim=c(0,100)) +              # <--
  xlab("Cups and drink") +
  ylab("Score on cognitive test (points)")

# Change axis labels
ggplot(caffeine.data, aes(x=group, y=score)) +
  geom_boxplot() +
  xlab("Cups and drink") +                      # <--
  ylab("Score on cognitive test (points)")      # <--

# Change tickmark labels
# For this you need to change the levels of your original variable
caffeine.data$group <- 
  recode_factor(
    caffeine.data$group, 
    `1_coffee` = "1 cup of coffee", 
    `1_greentea` = "1 cup of greentea", 
    `5_coffee` = "5 cups of coffee", 
    `5_greentea` = "5 cups of greentea")
ggplot(caffeine.data, aes(x=group, y=score)) +
  geom_boxplot() +
  xlab("Cups and drink") +
  ylab("Score on cognitive test (points)")

# change theme
ggplot(caffeine.data, aes(x=cups, y=score, fill=drink)) +
  geom_boxplot() +
  theme_bw()            # <--
  #theme_classic() 
  #theme_grey()
  #theme_void()

?theme()

## Barplot Mean +/- SE ####
ggplot(caffeine.data, aes(x=cups, y=score, fill=drink)) +
  stat_summary(fun = mean,
               fun.min = function(x) mean(x) - (sd(x)/ sqrt(length(x))), 
               fun.max = function(x) mean(x) + (sd(x)/ sqrt(length(x))), 
               geom = "errorbar",
               position=position_dodge(.9),
               width=.5) +
  stat_summary(fun = mean,
               geom = "bar",
               position=position_dodge(.9),
               col="black")  +
  theme_bw()

## *** Exercise 3 *** ####
# a) Change the colors of the barplot to darkgreen and brown.

# b) Add facets for males and females.



## Violin plot ####
ggplot(caffeine.data, aes(x=cups, y=score, fill=drink, col=drink)) +
  geom_violin(alpha=0.25) 

# with datapoints
ggplot(caffeine.data, aes(x=cups, y=score, fill=drink, col=drink)) +
  geom_violin() +
  geom_point(
    position=position_dodge(.9),
    col="black") 



## Dotplot ####
ggplot(caffeine.data, aes(x=group, y=score, fill=drink)) +
  geom_dotplot(
    binaxis = "y", 
    stackdir = "center", 
    binwidth = 1) 


## Jitterplot ####
ggplot(caffeine.data, aes(x=group, y=score, fill=drink)) +
  geom_jitter(width=.1)


## Histogram ####
# simple
ggplot(caffeine.data, aes(age)) +
  geom_histogram(binwidth = 1)

# per group
ggplot(caffeine.data, aes(age, fill=gender)) +
  geom_histogram()

# bars next to each other
ggplot(caffeine.data, aes(age, fill=gender)) +
  geom_histogram(position=position_dodge(.5))

# one facet per group
ggplot(caffeine.data, aes(score, fill=group)) +
  geom_histogram() +
  facet_wrap(vars(group))


## Longitudinal data ####
# This dataset is courtesy of Alessio Crippa, KI MEB
# load(url("http://alecri.github.io/downloads/data/dental.RData"))
# Read in the data
dental.data <- read_excel("C:/Users/lauvos/OneDrive - Karolinska Institutet/Documents/CBB/CBB_workshops/Workshop data exploration/dental.xlsx")

# Correct classes
str(dental.data)
dental.data$id <- as.factor(dental.data$id)
dental.data$sex <- as.factor(dental.data$sex)
dental.data$measurement <- as.factor(dental.data$measurement)

# One patient per line
ggplot(dental.data, aes(age, distance, col = factor(id), group = id)) +
  geom_point() +
  geom_line() +
  labs(x = "Age (years)", y = "Dental growth (mm)", col = "Child id") 

# One patient per facet
ggplot(dental.data, aes(age, distance, col = factor(id), group = id)) +
  geom_point() +
  geom_line() +
  facet_wrap(~ id) +
  labs(x = "Age (years)", y = "Dental growth (mm)", col = "Child id") 
  

## Kaplan-Meier curve ####
# Read in the colon dataset from the survival package
colon.data <- survival::colon
View(colon.data)

# Description of the dataset
?survival::colon

# Create survfit object
fit <- survfit( Surv(time, status) ~ sex, data = colon.data )

# Kaplan Meier curve
ggsurvplot(fit, data = colon.data)

# with risk table and CI's
ggsurvplot(fit, data = colon.data, risk.table= TRUE, conf.int = TRUE)

# add the result of the log-rank test 
ggsurvplot(fit, data = colon.data, risk.table= TRUE, conf.int = TRUE, pval = TRUE)

# with facets
ggsurvplot_facet(fit, data = colon, facet.by = "rx", pval = TRUE)

# change color palette
ggsurvplot_facet(fit, data = colon, facet.by = "rx", palette = "jco", pval = TRUE)
# Here are some other color palettes
# https://www.datanovia.com/en/blog/top-r-color-palettes-to-know-for-great-data-visualization/

# manually set color 
ggsurvplot_facet(fit, data = colon, facet.by = "rx", palette = c("#00AFBB", "#E7B800"), pval = TRUE)



# Export as image ####
# pdf
ggsave("P:/laura.vossen/Marie_Lof/CBB_support_sessions/Session5/Histogram_age.pdf")

# tiff with dpi=300:
ggsave("P:/laura.vossen/Marie_Lof/CBB_support_sessions/Session5/Histogram_age.tiff", dpi=300)


# More instructions ####
# R graph gallery:
#https://r-graph-gallery.com/index.html

# Regarding colors:
# Using built-in color names, a list:
#https://www.datanovia.com/en/blog/awesome-list-of-657-r-color-names/
# By hexidecimal code:
#http://www.sthda.com/english/wiki/colors-in-r#specifying-colors-by-hexadecimal-code
# Using packages with color palettes, like RColorBrewer or wesanderson:
#install.packages("RColorBrewer")
#library("RColorBrewer")
#display.brewer.all()
#https://rforpoliticalscience.com/2020/07/26/make-wes-anderson-themed-graphs-with-wesanderson-package-in-r/
#install.packages("wesanderson")
#library(wesanderson)




# Clear all ####
rm(list=ls())

