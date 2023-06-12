library(betareg)
library(glmmTMB)
SentinelNDVI.wetland$mean_beta <- (SentinelNDVI.wetland$mean + 1) / 2


SentinelNDVI.wetland.max <- SentinelNDVI.wetland %>%
  filter(year != '2022') %>%
  
  filter(year == kartleggingsaar) %>%
  
  group_by(id, year) %>%
  filter(mean == max(mean, na.rm=TRUE))

# make an extra numeric condition variable
unique(SentinelNDVI.wetland.max$tilstand)
SentinelNDVI.wetland.max <- SentinelNDVI.wetland.max %>% mutate(tilstand_num = recode(tilstand, 
                                            "God" = '1',
                                            "Moderat" = '2',
                                            "Redusert" = '3',
                                            "Svært redusert" = '4'))
SentinelNDVI.wetland.max$tilstand_num <- as.numeric(SentinelNDVI.wetland.max$tilstand_num)

summary(SentinelNDVI.wetland.max$tilstand_num)
  
  

summary( betareg(mean_beta~tilstand_num*region,data=SentinelNDVI.wetland.max) )

summary( betareg(mean_beta~tilstand*region,data=SentinelNDVI.wetland.max) )


summary( glmmTMB(mean_beta~tilstand_num*region +(1|hovedtype/id), family=beta_family(),data=SentinelNDVI.wetland.max) )

summary( betareg(mean_beta~tilstand_num + region + hovedtype + tilstand_num:hovedtype, data=SentinelNDVI.wetland.max) )
summary( glmmTMB(mean_beta~tilstand_num + region + hovedtype + tilstand_num:hovedtype +(1|id), family=beta_family(),data=SentinelNDVI.wetland.max) )

summary( betareg(mean_beta~tilstand + region + hovedtype + tilstand:hovedtype, data=SentinelNDVI.wetland.max) )
summary( glmmTMB(mean_beta~tilstand + region + hovedtype + tilstand:hovedtype +(1|id), family=beta_family(),data=SentinelNDVI.wetland.max) )


SentinelNDVI.wetland.max %>%
  filter(region=="Northern Norway") %>%
  
  ggplot( aes(x=tilstand, y=mean )) + 
  geom_violin() +
  facet_wrap( ~hovedtype)

SentinelNDVI.wetland.max %>%

  ggplot( aes(x=tilstand, y=mean )) + 
  geom_violin() +
  facet_grid(region~hovedtype)






sample(
  x = c(1,0.6,0.4,0.2),
  size = 1,
  replace = FALSE,
  prob = c(0.1,0.2,0.3,0.4)
)


rm(list= ls()[!(ls() %in% c('SentinelNDVI.wetland','SentinelNDVI.wetland.max','SentinelNDVI.seminat','SentinelNDVI.natopen'))])


dbeta()

https://stats.stackexchange.com/questions/12232/calculating-the-parameters-of-a-beta-distribution-using-the-mean-and-variance


mod_wetland <- betareg(mean_beta~tilstand + region + hovedtype + tilstand:hovedtype, data=SentinelNDVI.wetland.max)

coef(mod_wetland)
summary(mod_wetland)

str(summary(mod_wetland))

# logit-link function and inverse
logit <- function(p) log( p / (1-p) )
expit <- function(L) exp(L) / (1+exp(L)) 

phi <- coef(mod_wetland)[25]
# V3, Central, god
mu <- expit(sum(coef(mod_wetland)[c(1,10)]))

dbeta(seq(0,1,0.01), mu+phi, phi*(1-mu))
plot(seq(0,1,0.01),
     dbeta(seq(0,1,0.01), mu+phi, phi*(1-mu)))
