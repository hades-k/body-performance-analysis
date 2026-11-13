###############################################
##   BODY PERFORMANCE - FITNESS TESTS        ##
###############################################
source("01_cleaning.R")
attach(body_clean)

## Distribution   

par(mfrow = c(1, 2)) 
hist(grip, main = 'Grip force distribution', xlab = 'Grip force (kg)')
hist(jump, main = 'Jump length distribution', xlab = 'Jump length (cm)')
par(mfrow = c(1, 1))  


## HYPOTHESIS 1: grip strength, men vs women      

# H0: men and women have the same grip strength (on average)
# H1: men have a higher grip strength than women

boxplot(grip ~ gender, col = c('plum2','slateblue'),
        names = c('Females','Males'), ylab = 'Grip force (kg)',
        main = 'Grip force - Males and females')

summary(grip[gender == 'F'])
summary(grip[gender == 'M'])


## HYPOTHESIS 2: flexibility, women vs men

# H0: men and women have the same flexibility
# H1: women are more flexible than men

boxplot(bend ~ gender, col = c('plum2','slateblue'),
        names = c('Females','Males'), ylab = 'Sit and bend forward (cm)',
        main = 'Flexibility - Males and females')

summary(bend[gender == 'F'])
summary(bend[gender == 'M'])


## HYPOTHESIS 3: sit-ups and age            

# H0: the number of sit-ups does not depend on age
# H1: older people do fewer sit-ups

plot(age, situps, xlab = 'Age', ylab = 'Sit-ups',
     main = 'Scatterplot of sit-ups against age')

cor(age, situps)

## HYPOTHESIS 4: broad jump and grip strength      

# H0: jump and grip strength are not related
# H1: people with a stronger grip jump further

plot(grip, jump, xlab = 'Grip force (kg)', ylab = 'Broad jump (cm)',
     main = 'Scatterplot of jump against grip')
cor(grip, jump)

## is grip strength a good predictor? 

plot(grip, situps, xlab = 'Grip force (kg)', ylab = 'Number of situps',
     main = 'Scatterplot of situps against grip')
cor(grip, situps)

cor(fat,grip)
cor(bend,grip)

# Bonus: other relationships
cor(fat, jump)
cor(age, jump)

detach(body_clean)

