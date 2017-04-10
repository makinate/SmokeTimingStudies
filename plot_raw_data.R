library(ggplot2)
library(readr)
library(dplyr)

raw <- read_delim("~/Git_root/SmokeTimingStudies/code/raw_table.txt", 
                  " ", escape_double = FALSE, trim_ws = TRUE)


# plot response time per participant by speed
ggplot(raw, aes(x = as.factor(sbj), y = resp, fill = as.factor(speed)))+
  geom_boxplot()+
  geom_jitter(aes(colour = as.factor(speed),x =  as.factor(sbj), y = resp), 
              position = position_jitter(width = .1), alpha = 0.5) +
  #geom_point(aes(x = sbj, y = resp, color = as.factor(speed)), position = 'jitter')
  xlab('Subject') + ylab('Response time [s]')


# filter the data to remove outliers and then plot again
# histogram of raw data
hist(raw$resp)

# define outlier threshold
outlier_threshold = mean(raw$resp) + 2 * sd(raw$resp)

# remove outliers
raw_filt = filter(raw, resp < outlier_threshold)
hist(raw_filt$resp)

# plot response time per participant by speed
ggplot(raw_filt, aes(x = as.factor(sbj), y = resp, fill = as.factor(speed)))+
  geom_boxplot()+
  geom_jitter(aes(colour = as.factor(speed),x =  as.factor(sbj), y = resp), 
              position = position_jitter(width = .1), alpha = 0.5) +
  #geom_point(aes(x = sbj, y = resp, color = as.factor(speed)), position = 'jitter')
  xlab('Subject') + ylab('Response time [s]') + ggtitle('filtered raw data; resp < 4.41 s')




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
