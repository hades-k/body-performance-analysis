####################################
##   AGE GROUP COMPARISONS        ##
####################################
source("01_cleaning.R")
attach(body_clean)

table (age_group)
par(mfrow=c(2,2))

grp_cols <- c('20-29' = '#ffa600', '30-39' = '#ff5f66',
              '40-49' = '#bc4c96', '50-59' = '#594e90', '60-69' = '#003d5c') 

boxplot (fat~age_group, main='Body fat percentage: age group comparison', 
         xlab = 'Age group', ylab = 'BF%', col=grp_cols, range = 3)
boxplot (bmi~age_group, main='Body Mass Index: age group comparison', 
         xlab = 'Age group', ylab = 'BMI', col=grp_cols,range = 3)
boxplot (systolic~age_group, main='Systolic blood pressure: age group comparison', 
         xlab = 'Age group', ylab = 'Systolic blood pressure, mmHg', 
         col=grp_cols,range = 3)
boxplot (fat~age_group, main='Diastolic blood pressure: age group comparison', 
         xlab = 'Age group', ylab = 'Diastolic blood pressure, mmHg', 
         col=grp_cols,range = 3)


boxplot (grip~age_group, main='Grip strength: age group comparison', 
         xlab = 'Age group', ylab = 'Grip strength, kg', col=grp_cols,range = 3)
boxplot (bend~age_group, main='Flexibility: age group comparison', 
         xlab = 'Age group', ylab = 'Bend, cm', col=grp_cols, range = 3)
boxplot (situps~age_group, main='Number of situps: age group comparison', 
         xlab = 'Age group', ylab = 'Situps', col=grp_cols,range = 3)
boxplot (jump~age_group, main='Jump length: age group comparison', 
         xlab = 'Age group', ylab = 'Jump, cm', col=grp_cols, range = 3)

par(mfrow=c(1,1))

plot(weight~grip, col=grp_cols) #ignore,not informative

t.test(body_clean$grip[body_clean$age_group == "20-29"],
       body_clean$grip[body_clean$age_group == "30-39"])
t.test(body_clean$grip[body_clean$age_group == "20-29"],
       body_clean$grip[body_clean$age_group == "40-49"])

plot(situps~age_group, main = 'Situp count vs Age', xlab = 'Age Group', 
     ylab = 'Number of Situps')

gen_cols <- c('M'= 'steelblue', 'F'='plum2')

#limiting number of outliers in these boxplots
boxplot(fat ~ gender + age_group, col=gen_cols[levels(body_clean$gender)], 
        las = 2, main = 'Body fat percentage by age and sex', ylab = 'BF%', 
        range=3)
boxplot(bmi ~ gender + age_group, col=gen_cols[levels(body_clean$gender)], 
        las = 2, main = 'BMI by age and sex', ylab = 'BMI', range=3)

#ignore below
body_clean$FMI  <- body_clean$bmi * body_clean$fat / 100
body_clean$FFMI <- body_clean$bmi * (1 - body_clean$fat / 100)

boxplot(FFMI ~ gender:age_group)
summary(lm(FFMI ~ age * gender))      # does lean mass fall with age?
summary(lm(fat ~ age * gender + bmi))  # does BF% rise at the same BMI?
