bp <- read.csv("bodyPerformance.csv")
head(bp)

#BLOOD PRESSURE ANALYSIS

par(mfrow = c(1, 2))   # two plots in one row
hist(bp$diastolic, breaks = 30, main = "Diastolic blood pressure", xlab = "mmHg", col = "steelblue")
hist(bp$systolic,  breaks = 30, main = "Systolic blood pressure",  xlab = "mmHg", col = "orchid")
par(mfrow = c(1, 1))   # reset




# How many rows would be removed?
summary(bp[, c("diastolic", "systolic")])
sum(bp$systolic < 50 | bp$systolic > 370)
sum(bp$diastolic < 30 | bp$diastolic > 250)
sum(bp$systolic <= bp$diastolic)             #because systolic is always supposed to be higher than diastolic



summary(bp[, c("diastolic", "systolic")])
sum(bp$diastolic == 0)
sum(bp$systolic == 0)






# Cleaning values
bp_clean <- subset(bp,
                   systolic  >= 70 & systolic  <= 250 &
                     diastolic >= 40 & diastolic <= 150 &
                     systolic > diastolic)

nrow(bp)          # rows before
nrow(bp_clean)    # rows after
nrow(bp) - nrow(bp_clean)   # how many removed




#New cleaned plots
par(mfrow = c(1, 2))   # two plots in one row
hist(bp_clean$diastolic, breaks = 30, main = "Diastolic blood pressure", xlab = "mmHg", col = "steelblue")
hist(bp_clean$systolic,  breaks = 30, main = "Systolic blood pressure",  xlab = "mmHg", col = "orchid")
par(mfrow = c(1, 1))



# Boxplot to check the outliers etc
summary(bp_clean[, c("diastolic", "systolic")])

boxplot(bp_clean$diastolic, bp_clean$systolic,
        names = c("Diastolic blood pressure", "Systolic blood pressure"), ylab = "mmHg",
        col = c("steelblue", "orchid"))




#Descriptive statistics
summary(bp_clean[, c("diastolic", "systolic")])

#Full
stats <- function(x) c(N = length(x),
                       Mean = mean(x),
                       Median = median(x),
                       SD = sd(x),
                       Min = min(x),
                       Q1 = quantile(x, 0.25),
                       Q3 = quantile(x, 0.75),
                       Max = max(x),
                       IQR = IQR(x))

round(sapply(bp_clean[, c("diastolic", "systolic")], stats), 1)


#Gender differences
aggregate(cbind(diastolic, systolic) ~ gender, data = bp_clean,
          FUN = function(x) round(c(mean = mean(x), median = median(x), sd = sd(x)), 1))



