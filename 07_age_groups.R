####################################
##   AGE GROUP COMPARISONS        ##
####################################
source("01_cleaning.R")
attach(body_clean)

table (age_group)
par(mfrow=c(2,2))

boxplot (fat~age_group, main='Body fat percentage: age group comparison', 
         xlab = 'Age group', ylab = 'BF%')
boxplot (bmi~age_group, main='Body Mass Index: age group comparison', 
         xlab = 'Age group', ylab = 'BMI')
boxplot (systolic~age_group, main='Systolic blood pressure: age group comparison', 
         xlab = 'Age group', ylab = 'Systolic blood pressure, mmHg')
boxplot (fat~age_group, main='Diastolic blood pressure: age group comparison', 
         xlab = 'Age group', ylab = 'Diastolic blood pressure, mmHg')


boxplot (grip~age_group, main='Grip strength: age group comparison', 
         xlab = 'Age group', ylab = 'Grip strength, kg')
boxplot (bend~age_group, main='Flexibility: age group comparison', 
         xlab = 'Age group', ylab = 'Bend, cm')
boxplot (situps~age_group, main='Number of situps: age group comparison', 
         xlab = 'Age group', ylab = 'Situps')
boxplot (jump~age_group, main='Jump length: age group comparison', 
         xlab = 'Age group', ylab = 'Jump, cm')

t.test(body_clean$grip[body_clean$age_group == "20-29"],
       body_clean$grip[body_clean$age_group == "30-39"])
t.test(body_clean$grip[body_clean$age_group == "20-29"],
       body_clean$grip[body_clean$age_group == "40-49"])
