###############################################
##   BODY PERFORMANCE - BLOOD PRESSURE       ##
###############################################
source("01_cleaning.R")

# Boxplot to check the outliers
boxplot(body_clean$diastolic, body_clean$systolic,
        names = c("Diastolic", "Systolic"), ylab = "mmHg",
        col = c("steelblue", "orchid"))


## Descriptive statistics 

summary(body_clean[, c("diastolic", "systolic")])

## Gender differences 

summary((body_clean[gender=='M', c("diastolic", "systolic")]))
summary((body_clean[gender=='F', c("diastolic", "systolic")]))

