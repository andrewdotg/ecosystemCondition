#### Wetland analyses, Sentinel data ####

# how does NDVI vary over the years (all data)
SentinelNDVI.wetland %>%
  ggplot( aes(x=year, y=mean )) + 
  geom_point() +
  facet_grid( tilstand~hovedtype)
# 2022 stands out with the highest NDVI values missing
# the pattern is strange, suggest to omit 2022 for this analysis
SentinelNDVI.wetland <- SentinelNDVI.wetland %>%
  filter(year != '2022')

# NDVI across hovedtyper (only for NDVI data matching NiN-mapping)
SentinelNDVI.wetland %>%
  filter(year == kartleggingsaar) %>%
  ggplot( aes(x=tilstand, y=mean )) + 
  geom_violin() +
  facet_wrap( ~hovedtype)
# NDVI largely varies between hovedtyper: higher in seminat types and kaldkilde than in fens, lowest in ombrotrophic bogs
# @Tilstand: in seminat types, kaldkilde, and bogs 'god tilstand' appears to have somewhat lower NDVI than the other condition classes
# @Tilstand: in fens 'svært redusert tilstand' appears to have somewhat higher NDVI than the other condition classes

# add column for sub-ecosystem types
SentinelNDVI.wetland <- SentinelNDVI.wetland %>% mutate(subtype = substring(ninkartleggingsenheter, 4),
                                                        subtype = str_remove(subtype, '-'))

# looking at subtypes for polygons in good condition only (only for NDVI data matching NiN-mapping)
SentinelNDVI.wetland %>%
  filter(tilstand == 'God') %>%
  filter(year == kartleggingsaar) %>%
  ggplot(aes(x=subtype, y=mean )) + 
  geom_violin() +
  facet_wrap( ~hovedtype)
# NDVI varies between ecosystem subtypes
# -at least equally much as between main ecosystem types
# -stronger than between condition classes in previous plots

# looking at some single polygons
SentinelNDVI.wetland %>% 
  filter(id == 'NINFP1810041123') %>%
  ggplot(aes(x=date, y=mean )) + geom_point() + ylim(-0.1,0.6)

SentinelNDVI.wetland %>% 
  filter(id == 'NINFP2010025018') %>%
  ggplot(aes(x=date, y=mean )) + geom_point() + ylim(-0.1,0.6)

SentinelNDVI.wetland %>% 
  filter(id == 'NINFP1810042181') %>%
  ggplot(aes(x=date, y=mean )) + geom_point() #+ ylim(-0.1,0.6)


#### continue here ####


#### Seminat analyses, Sentinel data ####

# how does NDVI vary over the years (all data)
SentinelNDVI.seminat %>%
  ggplot( aes(x=year, y=mean )) + 
  geom_point() +
  facet_grid( tilstand~hovedtype)
# 2022 stands out with the highest NDVI values missing
# the pattern is strange, suggest to omit 2022 for this analysis
SentinelNDVI.seminat <- SentinelNDVI.seminat %>%
  filter(year != '2022')

# NDVI across hovedtyper (only for NDVI data matching NiN-mapping)
SentinelNDVI.seminat %>%
  filter(year == kartleggingsaar) %>%
  ggplot( aes(x=tilstand, y=mean )) + 
  geom_violin() +
  facet_wrap( ~hovedtype)
# NDVI varies between hovedtyper: highest in seminat meadows and T41 (tidligere jordbruksmark), lower in boreal heath and lowest in coastal heath, coastal meadows and T40 (earlier heavily altered) and kaldkilde than in fens, lowest in ombrotrophic bogs
# @Tilstand: higher NDVI with higher deviations from good condition

# add column for sub-ecosystem types
SentinelNDVI.seminat <- SentinelNDVI.seminat %>% mutate(subtype = substring(ninkartleggingsenheter, 4),
                                                        subtype = str_remove(subtype, '-'))

# looking at subtypes for polygons in good condition only (only for NDVI data matching NiN-mapping)
SentinelNDVI.seminat %>%
  filter(tilstand == 'God') %>%
  filter(year == kartleggingsaar) %>%
  ggplot(aes(x=subtype, y=mean )) + 
  geom_violin() +
  facet_wrap( ~hovedtype)
# NDVI varies between ecosystem subtypes
# -at least equally much as between main ecosystem types
# -stronger than between condition classes in previous plots

# looking at some single polygons
SentinelNDVI.seminat %>% 
  filter(id == 'NINFP1910030104') %>%
  ggplot(aes(x=date, y=mean )) + geom_point() + ylim(-0.1,0.9)

SentinelNDVI.seminat %>% 
  filter(id == 'NINFP2010036213') %>%
  ggplot(aes(x=date, y=mean )) + geom_point() + ylim(-0.1,0.9)



#### naturally open analyses, Sentinel data ####

# how does NDVI vary over the years (all data)
SentinelNDVI.natopen %>%
  ggplot( aes(x=year, y=mean )) + 
  geom_point() +
  facet_grid( tilstand~hovedtype)
# 2022 stands out with the highest NDVI values missing
# the pattern is strange, suggest to omit 2022 for this analysis
SentinelNDVI.natopen <- SentinelNDVI.natopen %>%
  filter(year != '2022')

# NDVI across hovedtyper (only for NDVI data matching NiN-mapping)
SentinelNDVI.natopen %>%
  filter(year == kartleggingsaar) %>%
  ggplot( aes(x=tilstand, y=mean )) + 
  geom_violin() +
  facet_wrap( ~hovedtype)
# T20 (innfrysningsmark) has only polygons in good or unknown condition -> not useful further
# NDVI varies between hovedtyper: somewhat higher in T12 (strandeng) and T18 (åpen flomfastmark) than in T2 (åpen grunnlendt mark) and T21 (sanddynemark)
# @Tilstand: hard to see any patterns

# add column for sub-ecosystem types
SentinelNDVI.natopen <- SentinelNDVI.natopen %>% mutate(subtype = substring(ninkartleggingsenheter, 4),
                                                        subtype = str_remove(subtype, '-'))

# looking at subtypes for polygons in good condition only (only for NDVI data matching NiN-mapping)
SentinelNDVI.natopen %>%
  filter(tilstand == 'God') %>%
  filter(year == kartleggingsaar) %>%
  ggplot(aes(x=subtype, y=mean )) + 
  geom_violin() +
  facet_wrap( ~hovedtype)
# NDVI varies between ecosystem subtypes
# -for T2 and T18 quite a bit compared to between main ecosystem types
# -stronger than between condition classes in previous plots

# looking at some single polygons
SentinelNDVI.natopen %>% 
  filter(id == 'NINFP1910018069') %>%
  ggplot(aes(x=date, y=mean )) + geom_point() + ylim(-0.2,0.9)

SentinelNDVI.natopen %>% 
  filter(id == 'NINFP1910019459') %>%
  ggplot(aes(x=date, y=mean )) + geom_point() + ylim(-0.2,0.9)



