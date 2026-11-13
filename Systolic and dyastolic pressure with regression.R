###############################################
##   BODY PERFORMANCE - DATA CLEANING        ##
###############################################

body <- read.csv("bodyPerformance.csv")
names(body) <- c("age","gender","height","weight","fat","diastolic","systolic",
                 "grip","bend","situps","jump","class")

dim(body)
head(body)
str(body)
sum(is.na(body)) 

# Categorical variables as factors
body$gender <- as.factor(body$gender) 
body$class  <- as.factor(body$class)  

# Some rows contain impossible values (measurement errors):
sum(body$systolic == 0)    # blood pressure = 0
sum(body$diastolic == 0)
sum(body$grip == 0)        # grip force = 0
sum(body$jump == 0)        # broad jump = 0
max(body$bend)             # 213 cm of flexibility: impossible


# Data cleaning   

body$bmi <- body$weight / (body$height / 100)^2

# (filtering criteria: Lu et al. 2020, see README)
body_clean <- subset(body, systolic >= 70 & systolic <= 250 &
                       diastolic >= 50 & diastolic <= 150 & systolic > diastolic &
                       height >= 90 & height < 240 &
                       weight > 15 & weight < 225 &
                       bmi >= 5 & bmi < 90 &
                       grip > 0 & jump > 0 &
                       bend > -30 & bend < 100 &
                       fat >= 3 & fat < 60)

nrow(body)                     
nrow(body_clean)              
nrow(body) - nrow(body_clean)  


install.packages("ggplot2")


library(ggplot2)
##############################################################################
#systolic/diastolic

ggplot(body_clean, aes(x= systolic, y=diastolic)) +
  geom_point(alpha = 0.15) + 
  geom_smooth(method = "lm", color = "purple")+
  labs(title = "systolic/diastolic (mmHg)", 
       x="systolic", y="diastolic")

# test correlation

cor(body_clean$systolic, body_clean$diastolic)
cor.test(body_clean$systolic, body_clean$diastolic)

#systolic
# 1. Scatter plot tendency line
ggplot(body_clean, aes(x = age, y = systolic)) +
geom_point(alpha = 0.15) +
geom_smooth(method = "lm", color = "red") +
labs(title = "Age/systolic Pressure",
x = "Age", y = "Systolic Pressure (mmHg)")

# 2. test correlation
cor(body_clean$age, body_clean$systolic)
cor.test(body_clean$age, body_clean$systolic)

# 3. linear regression
modello <- lm(systolic ~ age, data = body_clean)
summary(modello)

##################################################################################################################
#diastolic
# 1. Scatter plot with tendency line
ggplot(body_clean, aes(x = age, y = diastolic)) +
  geom_point(alpha = 0.15) +
  geom_smooth(method = "lm", color = "blue") +
  labs(title = "Age/Diastolic Pressure",
       x = "Age", y = "Diastolic Pressure (mmHg)")

# 2. Correlation and test
cor(body_clean$age, body_clean$systolic)
cor.test(body_clean$age, body_clean$systolic)

# 3. Linear regressio 
modello <- lm(systolic ~ age, data = body_clean)
summary(modello)

#systolic and diastolic/age

avg <- aggregate(cbind(systolic, diastolic) ~ age, data = body_clean, FUN = mean)

ggplot(avg, aes(x = age)) +
  geom_line(aes(y = systolic,  color = "Systolic"),  linewidth = 1) +
  geom_line(aes(y = diastolic, color = "Dyastolic"), linewidth = 1) +
  scale_color_manual(values = c("Systolic" = "red", "Diastolic" = "blue")) +
  labs(title = "Average pressure for Age",
       x = "Age (years)", y = "Average pressure (mmHg)", color = "Prssure")

#we could control how the correlation goes only from the late sixty since it seems the diastolic pressure 
#gets higher but not the diastolic