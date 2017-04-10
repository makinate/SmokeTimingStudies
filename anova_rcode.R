library(readr)
library(dplyr)
library(psych) 

source("~/Git_root/SmokeTimingStudies/multiplot.r")
dat <- read_delim("~/Git_root/SmokeTimingStudies/code/ANOVA_table.txt"," ", escape_double = FALSE, trim_ws = TRUE)


# Describe the resp variable by the IVs
describeBy(dat$resp, group = dat$speed)
describeBy(dat$resp, group = dat$distance)
describeBy(dat$resp, group = dat$density)
describeBy(dat$resp, group = dat$duration)



# test for normality
shapiro.test(dat$resp)
hist(dat$resp)

# define outlier threshold
outlier_threshold = mean(dat$resp) + 3 * sd(dat$resp)

# remove outliers
dat_filt = filter(dat, resp < outlier_threshold)

# test for main effects (data is not normally distributed)
m = aov(resp ~ speed    + 
        distance + 
        duration + 
        as.factor(density) + 
        Error(as.factor(sbj)), data = dat_filt)

# get a summary of m1
summary(m)

# get the residuals
m.pr <- proj(m)                   
m.res = m.pr[[3]][, "Residuals"]

shapiro.test(m.res)
hist(m.res)


# test for interaction effects (data is not normally distributed)
m = aov(resp ~ speed * 
               distance * 
               duration * 
               as.factor(density) + 
               Error(as.factor(sbj)), 
        data = dat_filt)

# get a summary of m1
summary(m)

# get the residuals
m.pr <- proj(m)                   
m.res = m.pr[[3]][, "Residuals"]

shapiro.test(m.res)
hist(m.res)