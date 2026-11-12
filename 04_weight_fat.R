###############################################
##   BODY PERFORMANCE - WEIGHT AND BODY FAT  ##
###############################################
source("01_cleaning.R")
attach(body_clean)


## Distribution      

summary(weight)
summary(fat)

par(mfrow = c(1, 2))  
hist(weight, main = 'Weight distribution', xlab = 'Weight (kg)')
hist(fat, main = 'Body fat distribution', xlab = 'Body fat (%)')
par(mfrow = c(1, 1))  


## Males vs females  

par(mfrow = c(2, 1))   
hist(fat[gender == 'M'], main = 'Body fat - Males', 
     xlab = 'Body fat (%)', col = 'slateblue')
hist(fat[gender == 'F'], main = 'Body fat - Females', 
     xlab = 'Body fat (%)', col = 'plum2')
par(mfrow = c(1, 1))

summary(fat[gender == 'F'])
summary(fat[gender == 'M'])


## Relationships      
plot(fat, weight, xlab = 'Body fat (%)', ylab = 'Weight (kg)',
     main = 'Body fat vs weight')
cor(fat, weight)

## HYPOTHESIS: body fat and performance class        

# H0: body fat is the same in all the classes
# H1: the better the class (A is the best), the lower the body fat

boxplot(fat ~ class, col = c('green3','yellowgreen','orange','red'),
        xlab = 'Class', ylab = 'Body fat (%)',
        main = 'Body fat by class')

mean(fat[class == 'A'])
mean(fat[class == 'B'])
mean(fat[class == 'C'])
mean(fat[class == 'D'])

detach(body_clean)
