library(ggplot2)
library(readr)
library(dplyr)

source("~/Git_root/SmokeTimingStudies/multiplot.r")
dat <- read_delim("~/Git_root/SmokeTimingStudies/code/ANOVA_table.txt"," ", escape_double = FALSE, trim_ws = TRUE)

dat = filter(dat, speed == 20)

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
smoke_speed    = aggregate(dat_smoke[, 6], list(dat_smoke$speed), FUN = function(dat_smoke) c(mn = mean(dat_smoke), SEM = sem(dat_smoke) ))
smoke_density  = aggregate(dat_smoke[, 6], list(dat_smoke$density), FUN = function(dat_smoke) c(mn = mean(dat_smoke), SEM = sem(dat_smoke) ))
smoke_duration = aggregate(dat_smoke[, 6], list(dat_smoke$duration), FUN = function(dat_smoke) c(mn = mean(dat_smoke), SEM = sem(dat_smoke) ))
smoke_distance = aggregate(dat_smoke, list(dat_smoke$distance), FUN = function(dat_smoke) c(mn = mean(dat_smoke), SEM = sem(dat_smoke) ))

disk_speed    = aggregate(dat_disk[, 6], list(dat_disk$speed), FUN = function(dat_disk) c(mn = mean(dat_disk), SEM = sem(dat_disk) ))
disk_density  = aggregate(dat_disk[, 6], list(dat_disk$density), FUN = function(dat_disk) c(mn = mean(dat_disk), SEM = sem(dat_disk) ))
disk_duration = aggregate(dat_disk[, 6], list(dat_disk$duration), FUN = function(dat_disk) c(mn = mean(dat_disk), SEM = sem(dat_disk) ))
disk_distance = aggregate(dat_disk, list(dat_disk$distance), FUN = function(dat_disk) c(mn = mean(dat_disk), SEM = sem(dat_disk) ))

# plot main effects
dat$s_d = ifelse(dat$density == 99, 'disk', 'smoke')
d.sum = summarySE(data = dat, measurevar = 'resp', groupvars = c('s_d'))
d.sum$s_d = ifelse(d.sum$density == 99, 'disk', 'smoke')
#d.sum = aggregate(dat[, 6], list(dat$density), FUN = function(dat) c(mn = mean(dat), SEM = sem(dat) ))

p1 = ggplot(data = d.sum, aes(x = as.factor(s_d), y = resp))+
  geom_bar(stat = 'identity', width = 0.5, aes(fill = as.factor(s_d)))+
  geom_errorbar(aes(ymax = resp + se, ymin = resp - se), width = 0.25)+
  xlab('Stimulus') + ylab('Response time [s]')+
  scale_fill_brewer(palette="Set1")+
  coord_cartesian(ylim=c(0.8,1.3)) +
  theme(legend.position="none")


# p1 = ggplot()+
#   geom_point    (data = smoke_speed, aes(x = Group.1, y = resp[,1], color = 'smoke'))+
#   geom_line     (data = smoke_speed, aes(x = Group.1, y = resp[,1], color = 'smoke')) +
#   geom_errorbar (data = smoke_speed, 
#                  aes(x = Group.1, 
#                      ymax = resp[,1] + resp[,2], 
#                      ymin = resp[,1] - resp[,2]), 
#                      width = 0.25) +
#   geom_point  (data = disk_speed, aes(x = disk_speed$Group.1 - 0.5, y = disk_speed$resp[,1], color = 'disk'))+
#   geom_line   (data = disk_speed, aes(x = disk_speed$Group.1 - 0.5, y = disk_speed$resp[,1], color = 'disk')) +
#   geom_errorbar (data = disk_speed, aes(x = Group.1- 0.5, ymax = resp[,1] + resp[,2], 
#                                          ymin = resp[,1] - resp[,2]), 
#                  width = 0.25)+
#   xlab('speed') + ylab('Response time [s]')
#   
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
  xlab('duration') + ylab('Response time [s]')+
  ylim(0.8, 1.3)+
  scale_color_brewer(palette="Set1")

smoke_density$dens = ifelse(smoke_density$Group.1 == 1, '0low', 
                     ifelse(smoke_density$Group.1 == 10, '1medium', '2high'))

p3 = ggplot()+
  #geom_point    (data = smoke_density, aes(x = dens, y = resp[,1], color = 'smoke'))+
  geom_bar      (data = smoke_density, stat = 'identity', width = 0.5, aes(x = dens, y = resp[,1],fill = 'smoke'))+
  #geom_line     (data = smoke_density, aes(x = dens, y = resp[,1], color = 'smoke')) +
  geom_errorbar (data = smoke_density, 
                 aes(x = dens, 
                     ymax = resp[,1] + resp[,2], 
                     ymin = resp[,1] - resp[,2]), 
                 width = 0.25) +
  #geom_point  (data = disk_density, aes(x = '3disk', y = resp[,1], color = 'disk'))+
  #geom_line   (data = disk_density, aes(x = '3disk', y = resp[,1], color = 'disk')) +
  geom_bar      (data = disk_density, stat = 'identity', width = 0.5, aes(x = '3disk', y = resp[,1],fill = 'disk'))+
  geom_errorbar (data = disk_density, aes(x = '3disk', ymax = resp[,1] + resp[,2], 
                                           ymin = resp[,1] - resp[,2]), 
                 width = 0.25)+
  xlab('density') + ylab('Response time [s]')+ 
  coord_cartesian(ylim=c(0.8,1.3)) +
  #annotate("text", x = '3disk', y = 1.19, label = "disk")+
  scale_fill_brewer(palette="Set1") + theme(legend.position="none")+
  scale_x_discrete(labels=c("low","medium","high", 'disk'))

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
  xlab('distance') + ylab('Response time [s]')+
  scale_color_brewer(palette="Set1")

# put all the plots into a single plot (need to call multiplot.r first)
multiplot(p1, p3, p2, p4, cols=2)
multiplot(p1,p3, cols = 2)

# plot response time as a function of sbj and speed
ggplot(dat, aes(x = as.factor(sbj), y = resp, fill = as.factor(speed)))+
  geom_boxplot()+
  geom_jitter(aes(colour = as.factor(speed),x =  as.factor(sbj), y = resp), 
              position = position_jitter(width = .1), alpha = 0.5) +
  #facet_grid(. ~ density)+
  xlab('Subject') + ylab('Response time [s]')


# ANOVA
head(dat)
dat$stim = as.factor(ifelse(dat$density == 99, 'disk', 'smoke'))

summary(aov(resp ~ stim + Error(as.character(sbj)), data = dat))
summary(aov(resp ~ as.factor(density) + Error(as.character(sbj)), data = filter(dat, density != 99)))

l.d = filter(dat, density == 1)
m.d = filter(dat, density == 10)
h.d = filter(dat, density == 20)

t.test(l.d$resp,m.d$resp, paired = T)
t.test(l.d$resp,h.d$resp, paired = T)
t.test(m.d$resp,h.d$resp, paired = T)

