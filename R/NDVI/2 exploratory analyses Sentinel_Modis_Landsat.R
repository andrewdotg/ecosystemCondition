#### running a regression for the temporal trend of NDVI for each region, separately for the ecosystems and for the satellites ####
library(betareg)
library(glmmTMB)
library(tidyverse)
library(broom)
library("gridExtra")

## make NDVI variable fit for regression analyses
# NDVI is bound between -1 and +1
# transforming it by (x+1)/2 to be bound between 0 and 1
# then we can use a beta regression for analysis
SentinelNDVI.seminat$mean_beta <- (SentinelNDVI.seminat$mean + 1) / 2
ModisNDVI.seminat$mean_beta <- (ModisNDVI.seminat$mean + 1) / 2
LandsatNDVI.seminat$mean_beta <- (LandsatNDVI.seminat$mean + 1) / 2



Sentinel.seminat.ndviTrends <- SentinelNDVI.seminat  %>% 
  group_by(id) %>% 
  nest()%>% 
  mutate(model = map(data, ~betareg(mean_beta ~ year, data = .x))) %>%
  mutate(tidy = map(model, tidy),
         glance = map(model, glance),
         augment = map(model, augment),
         rsq = glance %>% map_dbl('r.squared'),
         pvalue = glance %>% map_dbl('p.value'),
         intercept = tidy %>% map_dbl(~ filter(.x, term == "(Intercept)") %>% pull(estimate)),
         slope = tidy %>% map_dbl(~ filter(.x, term == "year") %>% pull(estimate))) %>%
  dplyr::select(id, intercept, slope, rsq, pvalue)

Sentinel.seminat.ndviTrends



Sentinel.seminat.ndviTrends <- SentinelNDVI.seminat  %>% 
  group_by(region_id) %>% 
  nest()%>% 
  mutate(model = map(data, ~betareg(mean_beta ~ year, data = .x))) %>%
  mutate(tidy = map(model, tidy),
         glance = map(model, glance),
         augment = map(model, augment),
         rsq = glance %>% map_dbl('r.squared'),
         pvalue = glance %>% map_dbl('p.value'),
         intercept = tidy %>% map_dbl(~ filter(.x, term == "(Intercept)") %>% pull(estimate)),
         slope = tidy %>% map_dbl(~ filter(.x, term == "year") %>% pull(estimate))) %>%
  dplyr::select(region_id, intercept, slope, rsq, pvalue)

SentinelNDVI.seminat %>% 
  group_by(id, year) %>%
  filter(mean == max(mean, na.rm=TRUE)) %>%
  summary(lm(mean ~ year))


Sentinel.seminat.ndviTrends <- SentinelNDVI.seminat  %>% 
  group_by(id, year) %>%
  filter(mean == max(mean, na.rm=TRUE)) %>%
  mutate(model = map(data, ~betareg(mean_beta ~ year, data = .x))) %>%
  mutate(tidy = map(model, tidy),
         glance = map(model, glance),
         augment = map(model, augment),
         rsq = glance %>% map_dbl('r.squared'),
         pvalue = glance %>% map_dbl('p.value'),
         intercept = tidy %>% map_dbl(~ filter(.x, term == "(Intercept)") %>% pull(estimate)),
         slope = tidy %>% map_dbl(~ filter(.x, term == "year") %>% pull(estimate))) %>%
  dplyr::select(intercept, slope, rsq, pvalue)
