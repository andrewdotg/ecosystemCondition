#### running a regression for the temporal trend of NDVI for each region, separately for the ecosystems and for the satellites ####

## make NDVI variable fit for regression analyses
# NDVI is bound between -1 and +1
# transforming it by (x+1)/2 to be bound between 0 and 1
# then we can use a beta regression for analysis
SentinelNDVI.seminat$mean_beta <- (SentinelNDVI.seminat$mean + 1) / 2
ModisNDVI.seminat$mean_beta <- (ModisNDVI.seminat$mean + 1) / 2
LandsatNDVI.seminat$mean_beta <- (LandsatNDVI.seminat$mean + 1) / 2


