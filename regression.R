###############################################
##   REGRESSION + CROSS VALIDATION           ##
###############################################

source("01_cleaning.R")

smp_size <- floor(0.75 * nrow(body_clean))

set.seed(1234)

train_ind <- sample(seq_len(nrow(body_clean)), size = smp_size)
train <- body_clean[train_ind, ]
test <- body_clean[-train_ind, ]

##################

# same folds for every model 
k <- 5
folds <- sample(rep(1:k, length.out = nrow(train)))

# threshold: final model can be at most 1% worse (CV RMSE) than using all variables
# using % instead of raw RMSE so the same rule works for grip (kg) and the rest (cm, count)
threshold <- 0.01

# variables we start with
# removed reduntant variables such as
# bmi is calculated from height and weight
# class is derived from everything else
# also removed all other 'performance' metrics
# age^2 is its own candidate: for some outcomes age is not linear
# (grip goes up, peaks in mid 30s, then declines), for others it's way more linear
# so CV decides per outcome if the curve is worth keeping

vars <- c("age", "I(age^2)", "gender", "height", "weight", "fat",
          "diastolic", "systolic")

make_formula <- function(y, vars) {
  as.formula(paste(y, "~", paste(vars, collapse = " + ")))
}

# avg RMSE over the 5 folds for one formula
cv_rmse <- function(formula) {
  y <- all.vars(formula)[1]
  rmse <- c()
  for (i in 1:k) {
    fit  <- lm(formula, data = train[folds != i, ])
    hold <- train[folds == i, ]
    rmse[i] <- sqrt(mean((hold[[y]] - predict(fit, hold))^2))
  }
  mean(rmse)
}

# stepwise: drop variables one at a time
# each round: try removing every variable that's left, find the one that hurts least
# if the model without it is still within the threshold of using everything -> drop it
# repeat until dropping anything else would go over the threshold
# (one at a time because variables overlap, e.g. height and gender,
#  each looks useless alone but dropping both together hurts)
pick_vars <- function(y) {
  rmse_all <- cv_rmse(make_formula(y, vars))
  keep <- vars
  while (length(keep) > 1) {
    worse <- c()
    for (v in keep) {
      # can't drop age while age^2 is still in (age^2 alone makes no sense)
      if (v == "age" && "I(age^2)" %in% keep) next
      worse[v] <- cv_rmse(make_formula(y, keep[keep != v])) / rmse_all - 1
    }
    print(round(worse * 100, 2)) # % worse than using everything
    weakest <- names(which.min(worse))
    if (worse[weakest] >= threshold) break
    cat("drop", weakest, "\n\n")
    keep <- keep[keep != weakest]
  }
  keep
}

# RMSE on the test set, only for the final models
test_rmse <- function(model) {
  y <- all.vars(formula(model))[1]
  sqrt(mean((test[[y]] - predict(model, test))^2))
}

## GRIP #######################################

grip_vars <- pick_vars("grip")
m_grip <- lm(make_formula("grip", grip_vars), data = train)
summary(m_grip)
plot(m_grip)

# 3 most extreme points in plots 1-3:
train[c('8543', '5806', '10802'),] #men with low grip strength 
#recording error? real injury? no way to tell

max(cooks.distance(m_grip))
model2 <- update(m_grip, data = train[!rownames(train) %in% c('8543','5806','10802'), ])
cbind(coef(m_grip), coef(model2))

# low grip-strength males were not influential 
# (maximum Cook's distance across all observations = 0.014)
# and refitting the model without them left the coefficients essentially unchanged.

bg <- coef(m_grip)
-bg["age"] / (2 * bg["I(age^2)"]) #max grip age

## BEND #######################################

bend_vars <- pick_vars("bend")
m_bend <- lm(make_formula("bend", bend_vars), data = train)
summary(m_bend)
plot(m_bend)

# overall not a great model ie cannot easily predict flexibility
# predictors are significantly associated with the response (F = 952.8, p < 2.2e-16)
# but they only explain 22% of the variance 

## JUMP #######################################

jump_vars <- pick_vars("jump")
m_jump <- lm(make_formula("jump", jump_vars), data = train)
summary(m_jump)
plot(m_jump)

bj <- coef(m_jump)
-bj["age"] / (2 * bj["I(age^2)"]) #max jump age

train[c('8750', '11033', '3735'),] 

max(cooks.distance(m_jump))
model2 <- update(m_jump, data = train[!rownames(train) %in% c('8750', '11033', '3735'), ])
cbind(coef(m_jump), coef(model2))

# ouliers with lower jump distance than predicted
# not influential 
# removing them does not change coeffcints much 

## SITUPS #####################################

situps_vars <- pick_vars("situps")
m_situps <- lm(make_formula("situps", situps_vars), data = train)
summary(m_situps)
plot(m_situps)

train[c('5090','6871','5636'),]

# unfinished 

## FINAL MODELS ON TEST ########################

# first and only time we touch test
final <- data.frame(
  outcome   = c("grip", "bend", "jump", "situps"),
  kept      = c(paste(grip_vars, collapse = ", "),
                paste(bend_vars, collapse = ", "),
                paste(jump_vars, collapse = ", "),
                paste(situps_vars, collapse = ", ")),
  cv_rmse   = c(cv_rmse(formula(m_grip)), cv_rmse(formula(m_bend)),
                cv_rmse(formula(m_jump)), cv_rmse(formula(m_situps))),
  test_rmse = c(test_rmse(m_grip), test_rmse(m_bend),
                test_rmse(m_jump), test_rmse(m_situps)),
  r2        = c(summary(m_grip)$r.squared, summary(m_bend)$r.squared,
                summary(m_jump)$r.squared, summary(m_situps)$r.squared)
)
final
