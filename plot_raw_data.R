library(ggplot2)
library(readr)
library(dplyr)

raw <- read_delim("~/Git_root/SmokeTimingStudies/code/raw_table.txt", 
                  " ", escape_double = FALSE, trim_ws = TRUE)

raw$sbj = as.factor(sbj)
raw$density = as.factor(raw$density)
raw$speed = as.factor(raw$speed)
raw$duration = as.factor(raw$duration)
raw$distance = as.factor(raw$distance)

# plot response time per participant by speed
ggplot(raw, aes(x = sbj, y = resp, fill = speed))+
  geom_boxplot()+
  geom_jitter(aes(colour = speed,x = sbj, y = resp), 
              position = position_jitter(width = .1), alpha = 0.5) +
  #geom_point(aes(x = sbj, y = resp, color = as.factor(speed)), position = 'jitter')
  xlab('Subject') + ylab('Response time [s]')


# filter the data to remove outliers and then plot again
# histogram of raw data
hist(raw$resp)

# define outlier threshold
outlier_threshold = mean(raw$resp, na.rm = T) + 2 * sd(raw$resp, na.rm = T)

# remove outliers
raw_filt = filter(raw, resp < outlier_threshold)
hist(raw_filt$resp)

# plot response time per participant by speed
ggplot(raw_filt, aes(x = as.factor(sbj), y = resp, fill = speed))+
  geom_boxplot()+
  geom_jitter(aes(colour = speed,x =  sbj, y = resp), 
              position = position_jitter(width = .1), alpha = 0.5) +
  #geom_point(aes(x = sbj, y = resp, color = as.factor(speed)), position = 'jitter')
  xlab('Subject') + ylab('Response time [s]') + ggtitle('filtered raw data; resp < 4.41 s')


ggplot(data = raw_filt, aes(x = speed, y = resp))+
  stat_summary(fun.data = 'mean_cl_boot')+
  facet_grid(duration~density)

ggplot(data = raw_filt, aes(x = density, y = resp))+
  #geom_jitter(alpha = .1)+
  stat_summary(fun.data = 'mean_cl_boot', color = 'red')+
  facet_grid(duration~speed)



summary(aov(resp ~ density * speed * distance * duration + Error(rep|sbj), data = raw_filt))



# run ANOVA
m_1 = aov(resp ~ speed    + 
          distance + 
          duration + 
          as.factor(density) + 
          Error(as.factor(sbj)/as.factor(rep)), data = raw_filt)

# get a summary of m1
summary(m_1)


# run ANOVA
m_2 = aov(resp ~ speed    *
          distance * 
          duration * 
          as.factor(density) + 
          Error(as.factor(sbj)/as.factor(rep)), data = raw_filt)

# get a summary of m1
summary(m_2)
