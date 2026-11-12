###############################################
##   BODY PERFORMANCE - GROUP PROJECT  ##
###############################################
rm(list = ls())
graphics.off()
setwd('Users/irene/Downloads')   # put here the folder where bodyPerformance.csv is

########################
## Data import        ##
########################
body <- read.csv("bodyPerformance.csv")
names(body) <- c("age","gender","height","weight","fat","diastolic","systolic",
                 "grip","bend","situps","jump","class")

dim(body)
head(body)
str(body)
sum(is.na(body))     # missing values

# Categorical variables as factors
body$gender <- as.factor(body$gender)   # F = female, M = male
body$class  <- as.factor(body$class)    # A (best) ... D (worst)

########################
## Data cleaning      ##
########################
# Some rows contain impossible values (measurement errors):
sum(body$systolic == 0)    # blood pressure = 0
sum(body$grip == 0)        # grip force = 0
sum(body$jump == 0)        # broad jump = 0
max(body$bend)             # 213 cm of flexibility: impossible

# Keep only the valid rows
body_clean <- body[body$systolic > 0 & body$diastolic > 0 &
                     body$grip > 0 & body$jump > 0 & body$bend < 100 & body$bend > 0 & body$fat< 70, ]
dim(body_clean)

attach(body_clean)

########################
## General overview   ##
########################
summary(body_clean)

table(gender)
prop.table(table(gender))
table(class)

#######################################################
## HYPOTHESIS 1: grip strength, men vs women         ##
#######################################################
# H0: men and women have the same grip strength (on average)
# H1: men have a higher grip strength than women

boxplot(grip ~ gender, col = c('plum2','slateblue'),
        names = c('Females','Males'), ylab = 'Grip force (kg)',
        main = 'Grip force - Males and females')

summary(grip[gender == 'F'])
summary(grip[gender == 'M'])
mean(grip[gender == 'F'])
mean(grip[gender == 'M'])
# Conclusion: compare the boxplots, the means and the medians.
# Is the difference small or big compared with the spread (sd) of the data?

#######################################################
## HYPOTHESIS 2: flexibility, women vs men           ##
#######################################################
# H0: men and women have the same flexibility
# H1: women are more flexible than men

boxplot(bend ~ gender, col = c('plum2','slateblue'),
        names = c('Females','Males'), ylab = 'Sit and bend forward (cm)',
        main = 'Flexibility - Males and females')

summary(bend[gender == 'F'])
summary(bend[gender == 'M'])

#######################################################
## HYPOTHESIS 3: body fat and performance class      ##
#######################################################
# H0: body fat is the same in all the classes
# H1: the better the class (A is the best), the lower the body fat

boxplot(fat ~ class, col = c('green3','yellowgreen','orange','red'),
        xlab = 'Class', ylab = 'Body fat (%)',
        main = 'Body fat by class')

mean(fat[class == 'A'])
mean(fat[class == 'B'])
mean(fat[class == 'C'])
mean(fat[class == 'D'])

#######################################################
## HYPOTHESIS 4: sit-ups and age                     ##
#######################################################
# H0: the number of sit-ups does not depend on age
# H1: older people do fewer sit-ups

plot(age, situps, xlab = 'Age', ylab = 'Sit-ups',
     main = 'Scatterplot of sit-ups against age')

cor(age, situps)
# Reminder: correlation goes from -1 to 1.
# Close to 0 -> no linear relation; close to -1 -> negative relation.

#######################################################
## HYPOTHESIS 5: gender and class                    ##
#######################################################
# H0: the distribution of the classes is the same for men and women
# H1: men and women are not distributed in the same way among the classes

tab <- table(gender, class)
tab                                   # absolute frequencies
tab_rel <- prop.table(tab, margin = 1)  # relative frequencies inside each gender
round(tab_rel, 3)

barplot(tab_rel, beside = TRUE, col = c('plum2','slateblue'),
        legend.text = c('Females','Males'),
        xlab = 'Class', ylab = 'Relative frequencies',
        main = 'Classes by gender')

#######################################################
## HYPOTHESIS 6: broad jump and grip strength        ##
#######################################################
# H0: jump and grip strength are not related
# H1: people with a stronger grip jump further

plot(grip, jump, xlab = 'Grip force (kg)', ylab = 'Broad jump (cm)',
     main = 'Scatterplot of jump against grip')
cor(grip, jump)

# Bonus: other relationships
cor(fat, jump)
cor(age, jump)

detach(body_clean)
