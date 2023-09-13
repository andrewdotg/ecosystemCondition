## data handling for time series analysis
# Sentinel time series checked in exploratory analysis script
SentinelNDVI.wetland <- SentinelNDVI.wetland %>%
  group_by(id, year) %>%
  filter(mean == max(mean, na.rm=TRUE))
SentinelNDVI.wetland <- SentinelNDVI.wetland %>% filter(year != '2022')

# checking time series for MODIS
ModisNDVI.wetland %>%
  group_by(id, year) %>%
  filter(mean == max(mean, na.rm=TRUE)) %>%
  ggplot( aes(x=year, y=mean )) + 
  geom_point() +
  facet_wrap(~hovedtype)
# 2022 does not stand out as in the Sentinel data, so we keep it
ModisNDVI.wetland <- ModisNDVI.wetland %>%
  group_by(id, year) %>%
  filter(mean == max(mean, na.rm=TRUE))

# checking time series for Landsat
LandsatNDVI.wetland %>%
  group_by(id, year) %>%
  filter(mean == max(mean, na.rm=TRUE)) %>%
  ggplot( aes(x=year, y=mean )) + 
  geom_point() +
  facet_wrap(~hovedtype)
# nothing worrying to see here either
LandsatNDVI.wetland <- LandsatNDVI.wetland %>%
  group_by(id, year) %>%
  filter(mean == max(mean, na.rm=TRUE))

# transformation of NDVI scale to beta scale
#SentinelNDVI.wetland$mean_beta <- (SentinelNDVI.wetland$mean + 1) / 2
ModisNDVI.wetland$mean_beta <- (ModisNDVI.wetland$mean + 1) / 2
LandsatNDVI.wetland$mean_beta <- (LandsatNDVI.wetland$mean + 1) / 2

# check if there's any 0s or 1s (which beta cannot handle)
summary(SentinelNDVI.wetland$mean_beta)
summary(ModisNDVI.wetland$mean_beta)
summary(LandsatNDVI.wetland$mean_beta)
# replace 1s in Landsat data with 0.9999
LandsatNDVI.wetland <- LandsatNDVI.wetland %>%
  mutate(mean_beta = replace(mean_beta, mean_beta == 1, 0.9999))

# check if the three Sattelite objects have the same structure (for concatenating them)
names(SentinelNDVI.wetland)
names(ModisNDVI.wetland)
names(LandsatNDVI.wetland)
# Sentinel and Landsat have each an extra column -> omit them when concatenating further below
# one column is named slightly differently in the Sentinel data -> rename it
SentinelNDVI.wetland <- SentinelNDVI.wetland %>%
  rename('system.index' = 'system:index')

# check if they have the same geometry
st_crs(SentinelNDVI.wetland)
st_crs(ModisNDVI.wetland)
st_crs(LandsatNDVI.wetland)
# all good

# add an increment to the year variable to avoid overlapping data being hidden in figures
SentinelNDVI.wetland$year_jit <- SentinelNDVI.wetland$year + 0.3
ModisNDVI.wetland$year_jit <- ModisNDVI.wetland$year - 0.3
LandsatNDVI.wetland$year_jit <- LandsatNDVI.wetland$year

# concatenate the three Satellite objects
allSatNDVI.wetland <- rbind(
SentinelNDVI.wetland[,!names(SentinelNDVI.wetland) %in% "subtype"],
ModisNDVI.wetland,
LandsatNDVI.wetland[,!names(LandsatNDVI.wetland) %in% "column_label"]
)
# add variable for Satellite indentity
allSatNDVI.wetland$Sat <- c(
  rep("Sentinel",nrow(SentinelNDVI.wetland)),
  rep("Modis",nrow(ModisNDVI.wetland)),
  rep("Landsat",nrow(LandsatNDVI.wetland))
)
allSatNDVI.wetland$Sat <- factor(allSatNDVI.wetland$Sat,levels=c("Sentinel","Modis","Landsat"))
levels(allSatNDVI.wetland$Sat)

# plot the time series for each satellite separately for each main ecosystem type
allSatNDVI.wetland %>%
  ggplot( aes(x=year_jit, y=mean, color=Sat )) + 
  geom_point() +
  facet_wrap(~hovedtype, ncol = 1)



# modeling NDVI as a function of year and main ecosystem type separately for each Satellite
# only good condition
model.wetland.time.GodTilst.Sent <- glmmTMB(mean_beta~year*hovedtype + (1|id), family=beta_family(),data=SentinelNDVI.wetland[SentinelNDVI.wetland$tilstand=="God",])
model.wetland.time.GodTilst.Modi <- glmmTMB(mean_beta~year*hovedtype + (1|id), family=beta_family(),data=ModisNDVI.wetland[ModisNDVI.wetland$tilstand=="God",])
model.wetland.time.GodTilst.Land <- glmmTMB(mean_beta~year*hovedtype + (1|id), family=beta_family(),data=LandsatNDVI.wetland[LandsatNDVI.wetland$tilstand=="God",])

summary(model.wetland.time.GodTilst.Sent)$coefficients$cond
summary(model.wetland.time.GodTilst.Modi)$coefficients$cond
summary(model.wetland.time.GodTilst.Land)$coefficients$cond

# all condition
model.wetland.time.Sent <- glmmTMB(mean_beta~year*hovedtype + (1|id), family=beta_family(),data=SentinelNDVI.wetland)
model.wetland.time.Modi <- glmmTMB(mean_beta~year*hovedtype + (1|id), family=beta_family(),data=ModisNDVI.wetland)
model.wetland.time.Land <- glmmTMB(mean_beta~year*hovedtype + (1|id), family=beta_family(),data=LandsatNDVI.wetland)

summary(model.wetland.time.Sent)$coefficients$cond
summary(model.wetland.time.Modi)$coefficients$cond
summary(model.wetland.time.Land)$coefficients$cond
