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
