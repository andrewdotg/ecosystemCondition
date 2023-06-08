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

summary( betareg(mean_beta~tilstand_num + region + hovedtype + tilstand_num:region + tilstand_num:hovedtype, data=SentinelNDVI.wetland.max) )
summary( glmmTMB(mean_beta~tilstand_num + region + hovedtype + tilstand_num:region + tilstand_num:hovedtype +(1|id), family=beta_family(),data=SentinelNDVI.wetland.max) )

summary( betareg(mean_beta~tilstand + region + hovedtype + tilstand:region + tilstand:hovedtype, data=SentinelNDVI.wetland.max) )
summary( glmmTMB(mean_beta~tilstand + region + hovedtype + tilstand:region + tilstand:hovedtype +(1|id), family=beta_family(),data=SentinelNDVI.wetland.max) )


SentinelNDVI.wetland.max %>%
  filter(region=="Northern Norway") %>%
  
  ggplot( aes(x=tilstand, y=mean )) + 
  geom_violin() +
  facet_wrap( ~hovedtype)

SentinelNDVI.wetland.max %>%

  ggplot( aes(x=tilstand, y=mean )) + 
  geom_violin() +
  facet_grid(region~hovedtype)
