library(ggplot2)
library(readr)
library(dplyr)

source("~/Git_root/SmokeTimingStudies/multiplot.r")
dat <- read_delim("~/Git_root/SmokeTimingStudies/code/ANOVA_table.txt"," ", escape_double = FALSE, trim_ws = TRUE)

#computation of the standard error of the mean
sem <- function(x) sd(x)/sqrt(length(x))

#95% confidence intervals of the mean
#c(mean(x)-2*sem,mean(x)+2*sem)


# do some basic plotting
ggplot(dat, aes(as.factor(density), resp, fill = as.factor(distance)))+
  geom_boxplot()+
  facet_grid(as.factor(speed)~as.factor(duration))+
  xlab('Density') + ylab('Response time [s]')+
  guides(fill=guide_legend(title="Distance"))

dat_smoke = filter(dat, density != 99)
dat_disk  = filter(dat, density == 99)

# calculate mean and sd for double checking of main effects
# create two different data frames for smoke and disk
smoke_speed = aggregate(dat_smoke[, 6], list(dat_smoke$speed), FUN = function(dat_smoke) c(mn = mean(dat_smoke), SEM = sem(dat_smoke) ))
smoke_density = aggregate(dat_smoke[, 6], list(dat_smoke$density), FUN = function(dat_smoke) c(mn = mean(dat_smoke), SEM = sem(dat_smoke) ))
smoke_duration = aggregate(dat_smoke[, 6], list(dat_smoke$duration), FUN = function(dat_smoke) c(mn = mean(dat_smoke), SEM = sem(dat_smoke) ))
smoke_distance = aggregate(dat_smoke, list(dat_smoke$distance), FUN = function(dat_smoke) c(mn = mean(dat_smoke), SEM = sem(dat_smoke) ))

disk_speed = aggregate(dat_disk[, 6], list(dat_disk$speed), FUN = function(dat_disk) c(mn = mean(dat_disk), SEM = sem(dat_disk) ))
disk_density = aggregate(dat_disk[, 6], list(dat_disk$density), FUN = function(dat_disk) c(mn = mean(dat_disk), SEM = sem(dat_disk) ))
disk_duration = aggregate(dat_disk[, 6], list(dat_disk$duration), FUN = function(dat_disk) c(mn = mean(dat_disk), SEM = sem(dat_disk) ))
disk_distance = aggregate(dat_disk, list(dat_disk$distance), FUN = function(dat_disk) c(mn = mean(dat_disk), SEM = sem(dat_disk) ))

# plot main effects
p1 = ggplot()+
  geom_point    (data = smoke_speed, aes(x = Group.1, y = resp[,1], color = 'smoke'))+
  geom_line     (data = smoke_speed, aes(x = Group.1, y = resp[,1], color = 'smoke')) +
  geom_errorbar (data = smoke_speed, 
                 aes(x = Group.1, 
                     ymax = resp[,1] + resp[,2], 
                     ymin = resp[,1] - resp[,2]), 
                     width = 0.25) +
  geom_point  (data = disk_speed, aes(x = disk_speed$Group.1 - 0.5, y = disk_speed$resp[,1], color = 'disk'))+
  geom_line   (data = disk_speed, aes(x = disk_speed$Group.1 - 0.5, y = disk_speed$resp[,1], color = 'disk')) +
  geom_errorbar (data = disk_speed, aes(x = Group.1- 0.5, ymax = resp[,1] + resp[,2], 
                                         ymin = resp[,1] - resp[,2]), 
                 width = 0.25)+
  xlab('speed') + ylab('Response time [s]')
  
p2 = ggplot()+
  geom_point    (data = smoke_duration, aes(x = Group.1, y = resp[,1], color = 'smoke'))+
  geom_line     (data = smoke_duration, aes(x = Group.1, y = resp[,1], color = 'smoke')) +
  geom_errorbar (data = smoke_duration, 
                 aes(x = Group.1, 
                     ymax = resp[,1] + resp[,2], 
                     ymin = resp[,1] - resp[,2]), 
                 width = 0.25) +
  geom_point  (data = disk_duration, aes(x = Group.1 - 0.5, y = resp[,1], color = 'disk'))+
  geom_line   (data = disk_duration, aes(x = Group.1 - 0.5, y = resp[,1], color = 'disk')) +
  geom_errorbar (data = disk_duration, aes(x = Group.1- 0.5, ymax = resp[,1] + resp[,2], 
                                        ymin = resp[,1] - resp[,2]), 
                 width = 0.25)+
  xlab('duration') + ylab('Response time [s]')


p3 = ggplot()+
  geom_point    (data = smoke_density, aes(x = Group.1, y = resp[,1], color = 'smoke'))+
  geom_line     (data = smoke_density, aes(x = Group.1, y = resp[,1], color = 'smoke')) +
  geom_errorbar (data = smoke_density, 
                 aes(x = Group.1, 
                     ymax = resp[,1] + resp[,2], 
                     ymin = resp[,1] - resp[,2]), 
                 width = 0.25) +
  geom_point  (data = disk_density, aes(x = 9.5, y = resp[,1], color = 'disk'))+
  geom_line   (data = disk_density, aes(x = 9.5, y = resp[,1], color = 'disk')) +
  geom_errorbar (data = disk_density, aes(x = 9.5, ymax = resp[,1] + resp[,2], 
                                           ymin = resp[,1] - resp[,2]), 
                 width = 0.25)+
  xlab('density') + ylab('Response time [s]')

p4 = ggplot()+
  geom_point    (data = smoke_distance, aes(x = Group.1, y = resp[,1], color = 'smoke'))+
  geom_line     (data = smoke_distance, aes(x = Group.1, y = resp[,1], color = 'smoke')) +
  geom_errorbar (data = smoke_distance, 
                 aes(x = Group.1, 
                     ymax = resp[,1] + resp[,2], 
                     ymin = resp[,1] - resp[,2]), 
                 width = 0.25) +
  geom_point  (data = disk_distance, aes(x = Group.1 - 0.5, y = resp[,1], color = 'disk'))+
  geom_line   (data = disk_distance, aes(x = Group.1 - 0.5, y = resp[,1], color = 'disk')) +
  geom_errorbar (data = disk_distance, aes(x = Group.1- 0.5, ymax = resp[,1] + resp[,2], 
                                           ymin = resp[,1] - resp[,2]), 
                 width = 0.25)+
  xlab('distance') + ylab('Response time [s]')

# put all the plots into a single plot (need to call multiplot.r first)
multiplot(p1, p3, p2, p4, cols=2)


# plot response time as a function of sbj and color
ggplot(dat, aes(x = sbj, y = resp, color = as.factor(speed)))+
  geom_point()+
  scale_x_continuous(name="Subject", limits=c(0, 11), breaks = c(1:11))+
  ylab('Response time [s]')

ggplot(dat, aes(x = as.factor(sbj), y = resp, fill = as.factor(speed)))+
  geom_boxplot()+
  geom_jitter(aes(colour = as.factor(speed),x =  as.factor(sbj), y = resp), 
              position = position_jitter(width = .1), alpha = 0.5) +
  #geom_point(aes(x = sbj, y = resp, color = as.factor(speed)), position = 'jitter')
  xlab('Subject') + ylab('Response time [s]')
