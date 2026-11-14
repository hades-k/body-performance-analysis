###############################################
##   BODY PERFORMANCE - HEIGHT               ##
###############################################
source("01_cleaning.R")
attach(body_clean)


## Distribution  

summary(height)
mean(height)
median(height)
sd(height)

hist(height, main = 'Height', xlab = 'Height (cm)')
boxplot(height, main = 'Height', ylab = 'Height (cm)')


## Males vs females   

boxplot(height ~ gender, col = c('plum2','slateblue'),
        names = c('Females','Males'), ylab = 'Height (cm)',
        main = 'Height by gender')

summary(height[gender == 'F'])
summary(height[gender == 'M'])


## Relationships     

plot(height, weight, xlab = 'Height  (cm)', ylab = 'Weight (kg)',
     main = 'Height vs weight', col=ifelse(gender=='M', 'slateblue', 'plum2'))
legend("topleft", legend = c("Male", "Female"),
       col    = c("slateblue", "plum2"), pch    = 1)
cor(weight, height)

plot(height, jump, xlab = 'Height (cm)', ylab = 'Broad jump (cm)',
     main = 'Height vs jump length', 
     col=ifelse(gender=='M', 'slateblue', 'plum2'))
legend("topleft", legend = c("Male", "Female"),
       col    = c("slateblue", "plum2"), pch    = 1)
cor(height, jump)

detach(body_clean)
