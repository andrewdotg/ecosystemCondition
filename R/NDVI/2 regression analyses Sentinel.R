# make sure to run these if not running script '2 exploratory analyses Sentinel'
SentinelNDVI.wetland <- SentinelNDVI.wetland %>%
  group_by(id, year) %>%
  filter(mean == max(mean, na.rm=TRUE))
SentinelNDVI.wetland <- SentinelNDVI.wetland %>% filter(year != '2022')


# NDVI across hovedtyper (only for NDVI years data matching NiN-mapping years)
SentinelNDVI.wetland %>%
  filter(year != '2022') %>%
  
  group_by(id, year) %>%
  filter(mean == max(mean, na.rm=TRUE)) %>%
  
  filter(year == kartleggingsaar) %>%
  ggplot( aes(x=tilstand, y=mean )) + 
  geom_violin() +
  facet_grid( region~hovedtype)
# V4 has lacking data for quite some condition classes in most regions

#library(glmmTMB)
library(betareg)
library(StepBeta)
SentinelNDVI.wetland$mean_beta <- (SentinelNDVI.wetland$mean + 1) / 2

# NDVI data from the year of NiN-mapping (and thus with condition assessment) to train the condition models
# we drop V4 for the analysis as it lacks data for most combinations of condition and region
SentinelNDVI.wetland.train <- SentinelNDVI.wetland %>%
  filter(year == kartleggingsaar) %>%
  filter(hovedtype != 'V4')

# make an extra numeric condition variable
unique(SentinelNDVI.wetland.train$tilstand)
SentinelNDVI.wetland.train <- SentinelNDVI.wetland.train %>% mutate(tilstand_num = recode(tilstand, 
                                            "God" = '0',
                                            "Moderat" = '1',
                                            "Redusert" = '2',
                                            "Svært redusert" = '3'))
SentinelNDVI.wetland.train$tilstand_num <- as.numeric(SentinelNDVI.wetland.train$tilstand_num)

summary(SentinelNDVI.wetland.train$tilstand_num)
  
  

model.wetland.cond.Sent <- betareg(mean_beta~tilstand_num*region*hovedtype, data=SentinelNDVI.wetland.train)
model.wetland.cond.Sent <- StepBeta(model.wetland.cond.Sent)
summary(model.wetland.cond.Sent)

#summary( glmmTMB(mean_beta~tilstand*region*hovedtype +(1|id), family=beta_family(),data=SentinelNDVI.wetland.train) )


# separate models per region
model.wetland.cond.Sent.N <- betareg(mean_beta~tilstand_num*hovedtype, data=SentinelNDVI.wetland.train[SentinelNDVI.wetland.train$region=="Northern Norway",])
model.wetland.cond.Sent.C <- betareg(mean_beta~tilstand_num*hovedtype, data=SentinelNDVI.wetland.train[SentinelNDVI.wetland.train$region=="Central Norway",])
model.wetland.cond.Sent.W <- betareg(mean_beta~tilstand_num*hovedtype, data=SentinelNDVI.wetland.train[SentinelNDVI.wetland.train$region=="Western Norway",])
model.wetland.cond.Sent.E <- betareg(mean_beta~tilstand_num*hovedtype, data=SentinelNDVI.wetland.train[SentinelNDVI.wetland.train$region=="Eastern Norway",])
model.wetland.cond.Sent.S <- betareg(mean_beta~tilstand_num*hovedtype, data=SentinelNDVI.wetland.train[SentinelNDVI.wetland.train$region=="Southern Norway",])



SentinelNDVI.wetland.train %>%
  filter(!is.na(region)) %>%

  ggplot( aes(x=tilstand, y=mean )) + 
  geom_violin() +
  geom_point(size=0.7, shape=16, color="grey") +
  facet_grid(region~hovedtype)


summary(model.wetland.cond.Sent.N)
summary(model.wetland.cond.Sent.C)
summary(model.wetland.cond.Sent.E)
summary(model.wetland.cond.Sent.W)
summary(model.wetland.cond.Sent.S)















# playing with probability density functions

sample(
  x = c(1,0.6,0.4,0.2),
  size = 1,
  replace = FALSE,
  prob = c(0.1,0.2,0.3,0.4)
)


rm(list= ls()[!(ls() %in% c('SentinelNDVI.wetland','SentinelNDVI.wetland.train','SentinelNDVI.seminat','SentinelNDVI.natopen'))])


dbeta()

https://stats.stackexchange.com/questions/12232/calculating-the-parameters-of-a-beta-distribution-using-the-mean-and-variance


mod_wetland.full <- betareg(mean_beta~tilstand_num*region*hovedtype, data=SentinelNDVI.wetland.train)
mod_wetland.1 <- betareg(mean_beta~tilstand_num + region + hovedtype + tilstand_num:hovedtype + tilstand_num:region + hovedtype:region, data=SentinelNDVI.wetland.train)
summary(mod_wetland.1)
mod_wetland.2 <- betareg(mean_beta~tilstand_num + region + hovedtype + tilstand_num:hovedtype + tilstand_num:region, data=SentinelNDVI.wetland.train)
summary(mod_wetland.2)

StepBeta(mod_wetland.1)

coef(mod_wetland)
summary(mod_wetland)
summary(mod_wetland.full)
str(summary(mod_wetland))

# logit-link function and inverse
logit <- function(p) log( p / (1-p) )
expit <- function(L) exp(L) / (1+exp(L)) 

phi <- coef(mod_wetland)[25]

par(mfrow=c(4,1))
# V3, Central, god
mu <- expit(sum(coef(mod_wetland)[c(1,10)]))
plot(seq(0,1,0.01),xlim=c(0.6,1),
     dbeta(seq(0,1,0.01), mu*phi, phi*(1-mu)))
abline(v=0.75,lty=2)

# V3, Central, moderat
mu <- expit(sum(coef(mod_wetland)[c(1,10,2,16)]))
plot(seq(0,1,0.01),xlim=c(0.6,1),
     dbeta(seq(0,1,0.01), mu*phi, phi*(1-mu)))
abline(v=0.75,lty=2)

# V3, Central, redusert
mu <- expit(sum(coef(mod_wetland)[c(1,10,3,17)]))
plot(seq(0,1,0.01),xlim=c(0.6,1),
     dbeta(seq(0,1,0.01), mu*phi, phi*(1-mu)))
abline(v=0.75,lty=2)

# V3, Central, svært redusert
mu <- expit(sum(coef(mod_wetland)[c(1,10,4,18)]))
plot(seq(0,1,0.01),xlim=c(0.6,1),
     dbeta(seq(0,1,0.01), mu*phi, phi*(1-mu)))
abline(v=0.75,lty=2)


# V3, central, ndvi = 0.75
test_ndvi <- 0.86
# mu for all 4 conditions in V3, central
mus <- c(
  expit(sum(coef(mod_wetland)[c(1,10)])),
  expit(sum(coef(mod_wetland)[c(1,10,2,16)])),
  expit(sum(coef(mod_wetland)[c(1,10,3,17)])),
  expit(sum(coef(mod_wetland)[c(1,10,4,18)]))
)
# probability densities for a given ndvi-value for these mu's
pds <- c(
  dbeta(test_ndvi, mus[1]*phi, phi*(1-mus[1])),
  dbeta(test_ndvi, mus[2]*phi, phi*(1-mus[2])),
  dbeta(test_ndvi, mus[3]*phi, phi*(1-mus[3])),
  dbeta(test_ndvi, mus[4]*phi, phi*(1-mus[4]))
)
# scale the pd's to 0-1 (probabalities)
pds <- pds/sum(pds)
# calculate a pd-weighted condition index
sum(
  c(
    pds[1]*sample(seq(0.8,1,0.05),1),
    pds[2]*sample(seq(0.6,0.79,0.05),1),
    pds[3]*sample(seq(0.4,0.59,0.05),1),
    pds[4]*sample(seq(0.05,0.39,0.05),1)
  )
)

#### works technically, but cannot handle deviations towards low NDVI