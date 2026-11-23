#####################################
##   PAIRS AND CORRELATIONS        ##
#####################################
source("01_cleaning.R")
attach(body_clean)

age_cols <- c('20-29' = '#ffa600', '30-39' = '#ff5f66',
              '40-49' = '#bc4c96', '50-59' = '#594e90', '60-69' = '#003d5c') 

gen_cols <- c('M'= 'steelblue', 'F'='plum2')


#pairs(~age+height+weight+fat+diastolic+systolic+grip+bend+situps+jump)
pairs(~grip+bend+situps+jump, col=age_cols[as.character(body_clean$age_group)])

pairs(~grip+bend+situps+jump, col=gen_cols[as.character(body_clean$gender)])

pairs(~height+weight+fat+grip+bend+situps+jump, 
      col=gen_cols[as.character(body_clean$gender)])

library(corrplot)
num_vars <- c("age", "height", "weight", "fat", "diastolic", "systolic",
          "grip", "bend", "situps", "jump")

cor_overall <- cor(body_clean[, num_vars], use = "complete.obs")
corrplot.mixed(cor_overall)

cor_m <- cor(body_clean[gender=='M', num_vars], use = "complete.obs")
corrplot.mixed(cor_m)

cor_f <- cor(body_clean[gender=='F', num_vars], use = "complete.obs")
corrplot.mixed(cor_f)
