source('01_cleaning.R')

# In South Korea, adult obesity starts at a 
# Body Mass Index (BMI) of 25.0 kg/m² or higher, 
# following the World Health Organization (WHO) Asia-Pacific criteria 
# and guidelines from the Korean Society for the Study of Obesity (KSSO).

body_clean$obesitybmi <- as.factor(ifelse(body_clean$bmi<25,'normal','obese'))

# body fat percentae based thresholds from 
# Chul-Hyun Kim, Hye Soon Park, Mira Park, Hyeoijin Kim, Chan Kim,
# Optimal cutoffs of percentage body fat for predicting obesity-related cardiovascular disease risk factors in Korean adults123,
# The American Journal of Clinical Nutrition,
# https://doi.org/10.3945/ajcn.110.001867.

body_clean$obesitybf <- as.factor(ifelse
                                  (body_clean$gender=='M',
                                    ifelse(body_clean$fat<21,'normal','obese'),
                                    ifelse(body_clean$fat<37,'normal','obese')))
attach(body_clean)

compare_obesity <- function(col,obescol){
  boxplot(body_clean[[col]]~body_clean[[obescol]], xlab = "obesity", ylab = col, 
  col=c('#68b07c','#f8c372'))
  c(obese=mean(body_clean[[col]][body_clean[[obescol]]=='obese']),
    normal=mean(body_clean[[col]][body_clean[[obescol]]=='normal']))
}
#############################

summary(obesitybmi)

compare_obesity('fat','obesitybmi')
compare_obesity('systolic','obesitybmi')
compare_obesity('diastolic','obesitybmi')

compare_obesity('grip','obesitybmi')
compare_obesity('jump','obesitybmi')
compare_obesity('situps','obesitybmi')
compare_obesity('bend','obesitybmi')

###########################

summary (obesitybf)

compare_obesity('bmi','obesitybf')
compare_obesity('systolic','obesitybf')
compare_obesity('diastolic','obesitybf')

compare_obesity('grip','obesitybf')
compare_obesity('jump','obesitybf')
compare_obesity('situps','obesitybf')
compare_obesity('bend','obesitybf')

########################

table(obesitybf,obesitybmi) # 78.1% agreement

men   <- subset(body_clean, gender == "M")
women <- subset(body_clean, gender == "F")

table(men$obesitybf, men$obesitybmi) # 70.8% agreement
table(women$obesitybf, women$obesitybmi) # 90.7% agreement

z_test <- function(x1, x2, delta0 = 0, conf = 0.95) {
  se   <- sqrt(var(x1)/length(x1) + var(x2)/length(x2))
  diff <- mean(x1) - mean(x2)
  z0   <- (diff - delta0) / se
  pval <- 2 * (1 - pnorm(abs(z0)))
  q    <- qnorm(1 - (1 - conf)/2)
  c(diff = diff, z = z0, p = pval, lower = diff - q*se, upper = diff + q*se)
}

z_test(men$systolic[men$obesitybf == "obese"],
       men$systolic[men$obesitybf == "normal"])
z_test(men$systolic[men$obesitybmi == "obese"],
       men$systolic[men$obesitybmi == "normal"])
z_test(women$systolic[women$obesitybf == "obese"],
       women$systolic[women$obesitybf == "normal"])
z_test(women$systolic[women$obesitybmi == "obese"],
       women$systolic[women$obesitybmi == "normal"])

body_clean$highbp <- ifelse(body_clean$systolic >= 140 | body_clean$diastolic >= 90, "yes", "no")
chisq.test(table(body_clean$obesitybf,  body_clean$highbp))
chisq.test(table(body_clean$obesitybmi, body_clean$highbp))

z_test(men$grip[men$obesitybf == "obese"],
       men$grip[men$obesitybf == "normal"])
z_test(men$grip[men$obesitybmi == "obese"],
       men$grip[men$obesitybmi == "normal"])
z_test(women$grip[women$obesitybf == "obese"],
       women$grip[women$obesitybf == "normal"])
z_test(women$grip[women$obesitybmi == "obese"],
       women$grip[women$obesitybmi == "normal"])

z_test(men$bend[men$obesitybf == "obese"],
       men$bend[men$obesitybf == "normal"])
z_test(men$bend[men$obesitybmi == "obese"],
       men$bend[men$obesitybmi == "normal"])
z_test(women$bend[women$obesitybf == "obese"],
       women$bend[women$obesitybf == "normal"])
z_test(women$bend[women$obesitybmi == "obese"],
       women$bend[women$obesitybmi == "normal"])

z_test(men$jump[men$obesitybf == "obese"],
       men$jump[men$obesitybf == "normal"])
z_test(men$jump[men$obesitybmi == "obese"],
       men$jump[men$obesitybmi == "normal"])
z_test(women$jump[women$obesitybf == "obese"],
       women$jump[women$obesitybf == "normal"])
z_test(women$jump[women$obesitybmi == "obese"],
       women$jump[women$obesitybmi == "normal"])

z_test(men$situps[men$obesitybf == "obese"],
       men$situps[men$obesitybf == "normal"])
z_test(men$situps[men$obesitybmi == "obese"],
       men$situps[men$obesitybmi == "normal"])
z_test(women$situps[women$obesitybf == "obese"],
       women$situps[women$obesitybf == "normal"])
z_test(women$situps[women$obesitybmi == "obese"],
       women$situps[women$obesitybmi == "normal"])

########################

# age adjusted differences
# obese people are older (by body fat: men 39.5 vs 33.7, women 46.5 vs 37.0)
# and age itself lowers performance / raises BP, so part of the gaps above is just age
# lm: outcome ~ obesity + age + age^2 -> obesity coefficient = difference at the same age
# age^2 because age is not linear for some outcomes (grip peaks ~late 30s)

age_adj <- function(d, col, obescol) {
  m <- lm(as.formula(paste(col, "~", obescol, "+ age + I(age^2)")), data = d)
  term <- paste0(obescol, "obese")
  ci <- confint(m)[term, ]
  c(raw      = mean(d[[col]][d[[obescol]] == "obese"]) -
               mean(d[[col]][d[[obescol]] == "normal"]),
    adjusted = unname(coef(m)[term]),
    lower    = unname(ci[1]),
    upper    = unname(ci[2]),
    p        = summary(m)$coefficients[term, 4])
}

# raw = z-test difference from above, adjusted = same comparison at the same age
for (col in c("systolic", "diastolic", "grip", "jump", "situps", "bend")) {
  cat("\n", col, "\n")
  print(round(rbind(men_bf    = age_adj(men, col, "obesitybf"),
                    men_bmi   = age_adj(men, col, "obesitybmi"),
                    women_bf  = age_adj(women, col, "obesitybf"),
                    women_bmi = age_adj(women, col, "obesitybmi")), 3))
}

# high BP: odds ratio obese vs normal, same age and gender
# (1 = no difference, 2 = twice the odds of high BP)
exp(coef(glm(I(highbp == "yes") ~ obesitybf + age + gender,
             family = binomial, data = body_clean)))["obesitybfobese"]
exp(coef(glm(I(highbp == "yes") ~ obesitybmi + age + gender,
             family = binomial, data = body_clean)))["obesitybmiobese"]

########################

summary(men[men$obesitybf=='normal' & men$obesitybmi=='obese',])
summary(men[men$obesitybf=='obese' & men$obesitybmi=='normal',])

body_clean$group <- with(body_clean,
                         ifelse(obesitybmi == "obese"  & obesitybf == "obese",  "obese-obese",
                                ifelse(obesitybmi == "normal" & obesitybf == "normal", "normal-normal",
                                       ifelse(obesitybmi == "normal" & obesitybf == "obese",  "normal-weight obese",
                                              "muscular"))))

body_clean$group <- factor(body_clean$group,
                           levels = c("normal-normal", "muscular", "normal-weight obese", "obese-obese"))

table(body_clean$group, body_clean$gender)  

# colorblind safe set (old: "#68b07c", "#7fa7d9", "#f8c372", "#e07b6a" were too pale / too similar)
cols <- c("#2a78d6", "#eb6834", "#1baf7a", "#eda100")

compare_groups <- function(col) {
  par(mfrow = c(1, 2))
  for (g in c("M", "F")) {
    d <- subset(body_clean, gender == g)
    boxplot(d[[col]] ~ d$group, col = cols, main = paste(col, "-", g),
            xlab = "", ylab = col, las = 2, cex.axis = 0.7)
  }
  par(mfrow = c(1, 1))
}

compare_groups("systolic")
compare_groups("situps")
compare_groups("bend")
compare_groups("grip")
compare_groups("jump")

# same groups, age adjusted
# numbers = difference from normal-normal at the same age
group_adj <- function(g, col) {
  d <- subset(body_clean, gender == g)
  m <- lm(as.formula(paste(col, "~ group + age + I(age^2)")), data = d)
  coef(m)[2:4]
}

for (g in c("M", "F")) {
  cat("\n", g, "\n")
  print(round(rbind(systolic = group_adj(g, "systolic"),
                    grip     = group_adj(g, "grip"),
                    jump     = group_adj(g, "jump"),
                    situps   = group_adj(g, "situps"),
                    bend     = group_adj(g, "bend")), 2))
}

########################
## PLOTS FOR THE REPORT

# 1. BMI vs body fat, the two definitions and the 4 groups
# dashed lines = cutoffs, each corner is one group
par(mfrow = c(1, 2))
for (g in c("M", "F")) {
  d <- subset(body_clean, gender == g)
  plot(d$bmi, d$fat, col = adjustcolor(cols[d$group], 0.35), pch = 16, cex = 0.4,
       xlab = "BMI", ylab = "body fat %",
       main = ifelse(g == "M", "men", "women"))
  abline(v = 25, lty = 2)
  abline(h = ifelse(g == "M", 21, 37), lty = 2)
  legend("bottomright", legend = paste0(levels(d$group), " (", table(d$group), ")"),
         col = cols, pch = 16, cex = 0.7, bty = "n")
}
par(mfrow = c(1, 1))

# 2. age by group -> why we need to adjust for age
par(mar = c(9, 4, 3, 1)) # room for the long group names
compare_groups("age")
par(mar = c(5, 4, 4, 2) + 0.1)

# 3. age adjusted average per group, with 95% CI
# lm per gender: outcome ~ group + age + age^2, then predict every group at the
# average age of that gender -> groups compared at the same age
# dashed line = normal-normal, so you can see how far each group is from it

adj_means <- function(g, col) {
  d <- subset(body_clean, gender == g)
  m <- lm(as.formula(paste(col, "~ group + age + I(age^2)")), data = d)
  new <- data.frame(group = factor(levels(d$group), levels = levels(d$group)),
                    age = mean(d$age))
  predict(m, new, interval = "confidence") # columns: fit, lwr, upr
}

units <- c(systolic = "mmHg", grip = "kg", jump = "cm", situps = "count")
group_labels <- c("normal-\nnormal", "muscular", "normal-wt\nobese", "obese-\nobese")

plot_means <- function(g, v) {
  p <- adj_means(g, v)
  top <- max(p[, "upr"]) + 0.15 * diff(range(p))
  plot(1:4, p[, "fit"], ylim = c(min(p[, "lwr"]), top), xlim = c(0.5, 4.5),
       pch = 19, cex = 1.8, col = cols, xaxt = "n", xlab = "",
       ylab = units[v], main = paste(v, "-", ifelse(g == "M", "men", "women")))
  abline(h = p[1, "fit"], lty = 2, col = "gray60")
  arrows(1:4, p[, "lwr"], 1:4, p[, "upr"], angle = 90, code = 3,
         length = 0.05, lwd = 2, col = cols)
  text(1:4, p[, "upr"], round(p[, "fit"], 1), pos = 3, cex = 0.9)
  axis(1, at = 1:4, labels = group_labels, padj = 0.5, cex.axis = 0.85)
}

par(mfrow = c(2, 4), mar = c(5, 4, 3, 1))
for (g in c("M", "F")) for (v in names(units)) plot_means(g, v)
par(mfrow = c(1, 1), mar = c(5, 4, 4, 2) + 0.1)
