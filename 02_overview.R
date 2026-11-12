###############################################
##   BODY PERFORMANCE - GENERAL OVERVIEW     ##
###############################################
source("01_cleaning.R")
attach(body_clean)

summary(body_clean)

########################
## Gender             ##
########################
table(gender)
prop.table(table(gender))
barplot(table(gender), col = c('plum2','slateblue'), main = 'Gender')

########################
## Class              ##
########################
table(class)
pie(table(class), main = 'Class')

#######################################################
## HYPOTHESIS: gender and class                      ##
#######################################################
# H0: the distribution of the classes is the same for men and women
# H1: men and women are not distributed in the same way among the classes

tab <- table(gender, class)
tab                                     # absolute frequencies
tab_rel <- prop.table(tab, margin = 1)  # relative frequencies inside each gender
round(tab_rel, 3)

barplot(tab_rel, beside = TRUE, col = c('plum2','slateblue'),
        legend.text = c('Females','Males'),
        xlab = 'Class', ylab = 'Relative frequencies',
        main = 'Classes by gender')

detach(body_clean)
