library(downloader)
library(sf)
library(tidyr)
library(plyr)
library(dplyr)
library(stringr)
library(tidyverse)
library(readxl)
library(tmap)
library(tmaptools)

#### getting all the data from previous scripts in ####
load("P:/41201785_okologisk_tilstand_2022_2023/data/FPI_output large files for markdown/data_natopen.RData")
load("P:/41201785_okologisk_tilstand_2022_2023/data/FPI_output large files for markdown/ref_lists_natopen.RData")
load("P:/41201785_okologisk_tilstand_2022_2023/data/FPI_output large files for markdown/results.natopen.ANO.RData")
load("P:/41201785_okologisk_tilstand_2022_2023/data/FPI_output large files for markdown/results.natopen.GRUK.RData")




#### plotting scaled values by main ecosystem type ####
## continuing with 2-sided
res.natopen.ANO <- results.natopen.ANO[['2-sided']]
colnames(res.natopen.ANO)

# make long version of the scaled value part
res.natopen.ANO <-
  res.natopen.ANO %>% 
  pivot_longer(
    cols = c("CC1","CC2",
             "SS1","SS2",
             "RR1","RR2",
             "Light1","Light2",
             "Nitrogen1","Nitrogen2",
             "Soil_disturbance1","Soil_disturbance2"),
    names_to = "fp_ind",
    values_to = "scaled_value",
    values_drop_na = FALSE
  )

# add original values as well
res.natopen.ANO <- 
  res.natopen.ANO %>% add_column(original = results.natopen.ANO[['original']] %>% 
                               pivot_longer(
                                 cols = c("CC1","CC2",
                                          "SS1","SS2",
                                          "RR1","RR2",
                                          "Light1","Light2",
                                          "Nitrogen1","Nitrogen2",
                                          "Soil_disturbance1","Soil_disturbance2"),
                                 names_to = NULL,
                                 values_to = "original",
                                 values_drop_na = FALSE
                               ) %>%
                               pull(original)
  )

summary(res.natopen.ANO$scaled_value)


summary(res.natopen.ANO[,79:81])


# similarly for GRUK
res.natopen.GRUK <- results.natopen.GRUK[['2-sided']]
colnames(res.natopen.GRUK)

# make long version of the scaled value part
res.natopen.GRUK <-
  res.natopen.GRUK %>% 
  pivot_longer(
    cols = c("CC1","CC2",
             "SS1","SS2",
             "RR1","RR2",
             "Light1","Light2",
             "Nitrogen1","Nitrogen2",
             "Soil_disturbance1","Soil_disturbance2"),
    names_to = "fp_ind",
    values_to = "scaled_value",
    values_drop_na = FALSE
  )

# add original values as well
res.natopen.GRUK <- 
  res.natopen.GRUK %>% add_column(original = results.natopen.GRUK[['original']] %>% 
                                   pivot_longer(
                                     cols = c("CC1","CC2",
                                              "SS1","SS2",
                                              "RR1","RR2",
                                              "Light1","Light2",
                                              "Nitrogen1","Nitrogen2",
                                              "Soil_disturbance1","Soil_disturbance2"),
                                     names_to = NULL,
                                     values_to = "original",
                                     values_drop_na = FALSE
                                   ) %>%
                                   pull(original)
  )

summary(res.natopen.GRUK[,52:54])

# making the plot, ANO, all indicators
ggplot(data=subset(res.natopen.ANO,!is.na(scaled_value)), aes(x=factor(kartleggingsenhet_1m2), y=scaled_value, fill=fp_ind)) + 
  geom_hline(yintercept=0.6, linetype="dashed") + 
  geom_violin(color=NA) +
  #  geom_boxplot(width=0.2, color="grey") +
  geom_point(size=1, shape=16, color="black") +
  facet_wrap(~factor(fp_ind,levels=c("CC1","SS1","RR1","Light1","Nitrogen1","Soil_disturbance1",
                                     "CC2","SS2","RR2","Light2","Nitrogen2","Soil_disturbance2")), ncol = 6) + 
  xlab("Basic ecosystem type") + 
  ylab("Scaled indicator value (ANO data)") 

# making the plot, ANO, CSR-indicators
ggplot(data=subset(res.natopen.ANO,!is.na(scaled_value) & fp_ind %in% c("CC1","SS1","RR1",
                                                                        "CC2","SS2","RR2")), 
       aes(x=factor(kartleggingsenhet_1m2), y=scaled_value, fill=fp_ind)) + 
  geom_hline(yintercept=0.6, linetype="dashed") + 
  geom_violin(color=NA) +
  #  geom_boxplot(width=0.2, color="grey") +
  geom_point(size=1, shape=16, color="black") +
  facet_wrap(~factor(fp_ind,levels=c("CC1","SS1","RR1",
                                     "CC2","SS2","RR2")), ncol = 3) + 
  xlab("Basic ecosystem type") + 
  ylab("Scaled indicator value (ANO data)") 

# making the plot, ANO, Tyler-indicators
ggplot(data=subset(res.natopen.ANO,!is.na(scaled_value) & fp_ind %in% c("Light1","Nitrogen1","Soil_disturbance1",
                                                                        "Light2","Nitrogen2","Soil_disturbance2")), 
       aes(x=factor(kartleggingsenhet_1m2), y=scaled_value, fill=fp_ind)) + 
  geom_hline(yintercept=0.6, linetype="dashed") + 
  geom_violin(color=NA) +
#  geom_boxplot(width=0.2, color="grey") +
  geom_point(size=1, shape=16, color="black") +
  facet_wrap(~factor(fp_ind,levels=c("Light1","Nitrogen1","Soil_disturbance1",
                                     "Light2","Nitrogen2","Soil_disturbance2")), ncol = 3) + 
  xlab("Basic ecosystem type") + 
  ylab("Scaled indicator value (ANO data)") 



# making the plot, GRUK
ggplot(res.natopen.GRUK, aes(x=factor(Kartleggingsenhet), y=scaled_value, fill=fp_ind)) + 
  geom_hline(yintercept=0.6, linetype="dashed") + 
  geom_violin(color = NA) +
  #  geom_boxplot(width=0.2, color="grey") +
  geom_point(size=1, shape=16, color="black") +
  facet_wrap(~factor(fp_ind,levels=c("CC1","SS1","RR1","Light1","Nitrogen1","Soil_disturbance1",
                                     "CC2","SS2","RR2","Light2","Nitrogen2","Soil_disturbance2")), ncol = 6) + 
  xlab("Basic ecosystem type") + 
  ylab("Scaled indicator value (GRUK data)") 




#### scaled value maps ####
# keep wide format and add geometry again
res.natopen.ANO2 <- results.natopen.ANO[['2-sided']]
st_geometry(res.natopen.ANO2) <- st_geometry(ANO.natopen)



## similarly for GRUK
# keep wide format and create geometry from coords in the dataframe
res.natopen.GRUK2 <- results.natopen.GRUK[['2-sided']]
# make spatial object
res.natopen.GRUK2 <- st_as_sf(res.natopen.GRUK2, coords = c("x","y"))
# add CRS
res.natopen.GRUK2 <- st_set_crs(res.natopen.GRUK2,4326)
# transform CRS to match ANO
res.natopen.GRUK2 <- res.natopen.GRUK2 %>%
  st_as_sf() %>%
  st_transform(crs = st_crs(ANO.geo))


#nor <- readRDS('P:/41201785_okologisk_tilstand_2022_2023/data/rds/norway_outline.RDS')%>%
#  st_as_sf() %>%
#  st_transform(crs = crs(ANO.geo))

nor <- st_read("data/outlineOfNorway_EPSG25833.shp")%>%
  st_as_sf() %>%
  st_transform(crs = st_crs(ANO.geo))

#reg <- st_read("P:/41201785_okologisk_tilstand_2022_2023/data/regioner/regNorway_wgs84 - MERGED.shp")%>%
#  st_as_sf() %>%
#  st_transform(crs = crs(ANO.geo))

reg <- st_read("data/regions.shp")%>%
  st_as_sf() %>%
  st_transform(crs = st_crs(ANO.geo))

# change region names to something R-friendly
reg$region
reg$region <- c("Northern Norway","Central Norway","Eastern Norway","Western Norway","Southern Norway")

regnor <- st_intersection(reg,nor)

## scaled value maps

# ANO
# CC2 (upper indicator)
tm_shape(regnor) +
  tm_fill('GID_0', labels="", title="", legend.show = FALSE) + 
  tm_borders() +
  tm_shape(res.natopen.ANO2) +
  tm_dots('CC2',midpoint=NA, palette=tmaptools::get_brewer_pal("YlOrRd", 7, plot = FALSE), scale=2, legend.show = FALSE) + # 
  tm_layout(main.title = "Competition index (upper), natopen ANO",legend.position = c("right", "bottom"), main.title.size=1.2) + 
  tm_add_legend(type = "fill", 
                col = c(tmaptools::get_brewer_pal("YlOrRd", 5, plot = FALSE),'grey'),
                labels = c("0.0 - 0.2", "0.2 - 0.4", "0.4 - 0.6", 
                           "0.6 - 0.8", "0.8 - 1.0", "NA"),
                title = "index values")



# RR1 (upper indicator)
tm_shape(regnor) +
  tm_fill('GID_0', labels="", title="", legend.show = FALSE) + 
  tm_borders() +
  tm_shape(res.natopen.ANO2) +
  tm_dots('RR1',midpoint=NA, palette=tmaptools::get_brewer_pal("YlOrRd", 7, plot = FALSE), scale=2, legend.show = FALSE) + # 
  tm_layout(main.title = "Ruderal index (lower), natopen ANO",legend.position = c("right", "bottom"), main.title.size=1.2) + 
  tm_add_legend(type = "fill", 
                col = c(tmaptools::get_brewer_pal("YlOrRd", 6, plot = FALSE),'grey'),
                labels = c("0.4 - 0.5", "0.5 - 0.6", "0.6 - 0.7", 
                           "0.7 - 0.8", "0.8 - 0.9", "0.9 - 1.0", "NA"),
                title = "index values")



# GRUK
# CC2 (upper indicator)
tm_shape(regnor) +
  tm_fill('GID_0', labels="", title="", legend.show = FALSE) + 
  tm_borders() +
  tm_shape(res.natopen.GRUK2) +
  tm_dots('CC2',midpoint=NA, palette=tmaptools::get_brewer_pal("YlOrRd", 7, plot = FALSE), scale=2, legend.show = FALSE) + # 
  tm_layout(main.title = "Competition index (upper), natopen GRUK",legend.position = c("right", "bottom"), main.title.size=1.2) + 
  tm_add_legend(type = "fill", 
                col = c(tmaptools::get_brewer_pal("YlOrRd", 5, plot = FALSE),'grey'),
                labels = c("0.0 - 0.2", "0.2 - 0.4", "0.4 - 0.6", 
                           "0.6 - 0.8", "0.8 - 1.0", "NA"),
                title = "index values")



# RR2 (upper indicator)
tm_shape(regnor) +
  tm_fill('GID_0', labels="", title="", legend.show = FALSE) + 
  tm_borders() +
  tm_shape(res.natopen.GRUK2) +
  tm_dots('RR2',midpoint=NA, palette=tmaptools::get_brewer_pal("YlOrRd", 7, plot = FALSE), scale=2, legend.show = FALSE) + # 
  tm_layout(main.title = "Ruderal index (upper), natopen GRUK",legend.position = c("right", "bottom"), main.title.size=1.2) + 
  tm_add_legend(type = "fill", 
                col = c(tmaptools::get_brewer_pal("YlOrRd", 6, plot = FALSE),'grey'),
                labels = c("0.4 - 0.5", "0.5 - 0.6", "0.6 - 0.7", 
                           "0.7 - 0.8", "0.8 - 0.9", "0.9 - 1.0", "NA"),
                title = "index values")

# Nitrogen2 (upper indicator)
tm_shape(regnor) +
  tm_fill('GID_0', labels="", title="", legend.show = FALSE) + 
  tm_borders() +
  tm_shape(res.natopen.GRUK2) +
  tm_dots('Nitrogen2',midpoint=NA, palette=tmaptools::get_brewer_pal("YlOrRd", 7, plot = FALSE), scale=2, legend.show = FALSE) + # 
  tm_layout(main.title = "Nitrogen index (upper), natopen GRUK",legend.position = c("right", "bottom"), main.title.size=1.2) + 
  tm_add_legend(type = "fill", 
                col = c(tmaptools::get_brewer_pal("YlOrRd", 7, plot = FALSE),'grey'),
                labels = c("0.3 - 0.4", "0.4 - 0.5", "0.5 - 0.6", "0.6 - 0.7", 
                           "0.7 - 0.8", "0.8 - 0.9", "0.9 - 1.0", "NA"),
                title = "index values")


# let's look at things by region
res.natopen.ANO2 = st_join(res.natopen.ANO2, regnor, left = TRUE)
colnames(res.natopen.ANO2)

res.natopen.GRUK2 = st_join(res.natopen.GRUK2, regnor, left = TRUE)
colnames(res.natopen.GRUK2)

# simple means, inappropriate for 0-1 bound data
res.natopen.ANO2 %>% 
  group_by(as.factor(region)) %>% 
  mutate(CC1.reg.mean = mean(CC1,na.rm=T)) %>%
  mutate(CC2.reg.mean = mean(CC2,na.rm=T)) %>%
  mutate(SS1.reg.mean = mean(SS1,na.rm=T)) %>%
  mutate(SS2.reg.mean = mean(SS1,na.rm=T)) %>%
  mutate(RR1.reg.mean = mean(RR1,na.rm=T)) %>%
  mutate(RR2.reg.mean = mean(RR1,na.rm=T)) %>%
  mutate(Light1.reg.mean = mean(Light1,na.rm=T)) %>%
  mutate(Light2.reg.mean = mean(Light1,na.rm=T)) %>%
  mutate(Nitrogen1.reg.mean = mean(Nitrogen1,na.rm=T)) %>%
  mutate(Nitrogen2.reg.mean = mean(Nitrogen2,na.rm=T)) %>%
  mutate(Soil_disturbance1.reg.mean = mean(Soil_disturbance1,na.rm=T)) %>%
  mutate(Soil_disturbance2.reg.mean = mean(Soil_disturbance2,na.rm=T))
  
# and for GRUK
res.natopen.GRUK2 %>% 
  group_by(as.factor(region)) %>% 
  mutate(CC1.reg.mean = mean(CC1,na.rm=T)) %>%
  mutate(CC2.reg.mean = mean(CC2,na.rm=T)) %>%
  mutate(SS1.reg.mean = mean(SS1,na.rm=T)) %>%
  mutate(SS2.reg.mean = mean(SS1,na.rm=T)) %>%
  mutate(RR1.reg.mean = mean(RR1,na.rm=T)) %>%
  mutate(RR2.reg.mean = mean(RR1,na.rm=T)) %>%
  mutate(Light1.reg.mean = mean(Light1,na.rm=T)) %>%
  mutate(Light2.reg.mean = mean(Light1,na.rm=T)) %>%
  mutate(Nitrogen1.reg.mean = mean(Nitrogen1,na.rm=T)) %>%
  mutate(Nitrogen2.reg.mean = mean(Nitrogen2,na.rm=T)) %>%
  mutate(Soil_disturbance1.reg.mean = mean(Soil_disturbance1,na.rm=T)) %>%
  mutate(Soil_disturbance2.reg.mean = mean(Soil_disturbance2,na.rm=T))


# rather use beta-regression
expit <- function(L) exp(L) / (1+exp(L))
library(betareg)
library(glmmTMB)


indmean.beta <- function(df) {
  
  st_geometry(df) <- NULL
  colnames(df) <- c("y","ran")
  
  if ( nrow(df[!is.na(df[,1]),]) >= 2 ) {
    
    if ( length(unique(df[!is.na(df[,1]),2])) >=5 ) {
      
      mod1 <- glmmTMB(y ~ 1 +(1|ran), family=beta_family(), data=df)
      
      return(c(
        expit(summary( mod1 )$coefficients$cond[1]),
        
        expit( summary( mod1 )$coefficients$cond[1] + 
                 summary( mod1 )$coefficients$cond[2] )-
          expit( summary( mod1 )$coefficients$cond[1] ),
        
        nrow(df[!is.na(df$y),]),
        summary( mod1 )$coefficients$cond[1],
        summary( mod1 )$coefficients$cond[2]
      ))
      
    } else {
      
      mod2 <- betareg(y ~ 1, data=df)
      
      return(c(
        expit(summary( mod2 )$coefficients$mean[1]),
        expit( summary( mod2 )$coefficients$mean[1] + 
                 summary( mod2 )$coefficients$mean[2] )-
          expit( summary( mod2 )$coefficients$mean[1] ),
        nrow(df[!is.na(df$y),]),
        summary( mod2 )$coefficients$mean[1],
        summary( mod2 )$coefficients$mean[2]
      ))
      
    }
    
  } else {
    
    return(c(df$y,NA,1,NA,NA))
    
  }
  
}



indmean.beta(df=res.natopen.ANO2[res.natopen.ANO2$region=="Northern Norway",c("CC1","ano_flate_id")])

indmean.beta(df=res.natopen.GRUK2[res.natopen.GRUK2$region=="Northern Norway",c("CC1","Flate_ID")])

res.natopen.ANO2$RR1[res.natopen.ANO2$RR1==1] <- 0.999
res.natopen.ANO2$RR1[res.natopen.ANO2$RR1==0] <- 0.001

regnor <- regnor %>%
  mutate(
    RR1.ANO.reg.mean = c(indmean.beta(df=res.natopen.ANO2[res.natopen.ANO2$region=="Northern Norway",c("RR1","ano_flate_id")])[1],
                                 indmean.beta(df=res.natopen.ANO2[res.natopen.ANO2$region=="Central Norway",c("RR1","ano_flate_id")])[1],
                                 indmean.beta(df=res.natopen.ANO2[res.natopen.ANO2$region=="Eastern Norway",c("RR1","ano_flate_id")])[1],
                                 indmean.beta(df=res.natopen.ANO2[res.natopen.ANO2$region=="Western Norway",c("RR1","ano_flate_id")])[1],
                                 indmean.beta(df=res.natopen.ANO2[res.natopen.ANO2$region=="Southern Norway",c("RR1","ano_flate_id")])[1]
    ),
    RR1.ANO.reg.se = c(indmean.beta(df=res.natopen.ANO2[res.natopen.ANO2$region=="Northern Norway",c("RR1","ano_flate_id")])[2],
                               indmean.beta(df=res.natopen.ANO2[res.natopen.ANO2$region=="Central Norway",c("RR1","ano_flate_id")])[2],
                               indmean.beta(df=res.natopen.ANO2[res.natopen.ANO2$region=="Eastern Norway",c("RR1","ano_flate_id")])[2],
                               indmean.beta(df=res.natopen.ANO2[res.natopen.ANO2$region=="Western Norway",c("RR1","ano_flate_id")])[2],
                               indmean.beta(df=res.natopen.ANO2[res.natopen.ANO2$region=="Southern Norway",c("RR1","ano_flate_id")])[2]
    ),
    RR1.ANO.reg.n = c(nrow(res.natopen.ANO2[res.natopen.ANO2$region=="Northern Norway" & !is.na(res.natopen.ANO2$RR1),]),
                              nrow(res.natopen.ANO2[res.natopen.ANO2$region=="Central Norway" & !is.na(res.natopen.ANO2$RR1),]),
                              nrow(res.natopen.ANO2[res.natopen.ANO2$region=="Eastern Norway" & !is.na(res.natopen.ANO2$RR1),]),
                              nrow(res.natopen.ANO2[res.natopen.ANO2$region=="Western Norway" & !is.na(res.natopen.ANO2$RR1),]),
                              nrow(res.natopen.ANO2[res.natopen.ANO2$region=="Southern Norway" & !is.na(res.natopen.ANO2$RR1),])
    )
  )

# and adding the values for GRUK
res.natopen.GRUK2$Nitrogen2[res.natopen.GRUK2$Nitrogen2==1] <- 0.999
res.natopen.GRUK2$Nitrogen2[res.natopen.GRUK2$Nitrogen2==0] <- 0.001

regnor <- regnor %>%
  mutate(
    Nitrogen2.GRUK.reg.mean = c(indmean.beta(df=res.natopen.GRUK2[res.natopen.GRUK2$region=="Northern Norway",c("Nitrogen2","Flate_ID")])[1],
                               indmean.beta(df=res.natopen.GRUK2[res.natopen.GRUK2$region=="Central Norway",c("Nitrogen2","Flate_ID")])[1],
                               indmean.beta(df=res.natopen.GRUK2[res.natopen.GRUK2$region=="Eastern Norway",c("Nitrogen2","Flate_ID")])[1],
                               indmean.beta(df=res.natopen.GRUK2[res.natopen.GRUK2$region=="Western Norway",c("Nitrogen2","Flate_ID")])[1],
                               indmean.beta(df=res.natopen.GRUK2[res.natopen.GRUK2$region=="Southern Norway",c("Nitrogen2","Flate_ID")])[1]
    ),
    Nitrogen2.GRUK.reg.se = c(indmean.beta(df=res.natopen.GRUK2[res.natopen.GRUK2$region=="Northern Norway",c("Nitrogen2","Flate_ID")])[2],
                             indmean.beta(df=res.natopen.GRUK2[res.natopen.GRUK2$region=="Central Norway",c("Nitrogen2","Flate_ID")])[2],
                             indmean.beta(df=res.natopen.GRUK2[res.natopen.GRUK2$region=="Eastern Norway",c("Nitrogen2","Flate_ID")])[2],
                             indmean.beta(df=res.natopen.GRUK2[res.natopen.GRUK2$region=="Western Norway",c("Nitrogen2","Flate_ID")])[2],
                             indmean.beta(df=res.natopen.GRUK2[res.natopen.GRUK2$region=="Southern Norway",c("Nitrogen2","Flate_ID")])[2]
    ),
    Nitrogen2.GRUK.reg.n = c(0,
                            0,
                            nrow(res.natopen.GRUK2[res.natopen.GRUK2$region=="Eastern Norway" & !is.na(res.natopen.GRUK2$Nitrogen2),]),
                            0,
                            nrow(res.natopen.GRUK2[res.natopen.GRUK2$region=="Southern Norway" & !is.na(res.natopen.GRUK2$Nitrogen2),]))
  )

res.natopen.GRUK2$RR2[res.natopen.GRUK2$RR2==1] <- 0.999
res.natopen.GRUK2$RR2[res.natopen.GRUK2$RR2==0] <- 0.001

regnor <- regnor %>%
  mutate(
    RR2.GRUK.reg.mean = c(indmean.beta(df=res.natopen.GRUK2[res.natopen.GRUK2$region=="Northern Norway",c("RR2","Flate_ID")])[1],
                                indmean.beta(df=res.natopen.GRUK2[res.natopen.GRUK2$region=="Central Norway",c("RR2","Flate_ID")])[1],
                                indmean.beta(df=res.natopen.GRUK2[res.natopen.GRUK2$region=="Eastern Norway",c("RR2","Flate_ID")])[1],
                                indmean.beta(df=res.natopen.GRUK2[res.natopen.GRUK2$region=="Western Norway",c("RR2","Flate_ID")])[1],
                                indmean.beta(df=res.natopen.GRUK2[res.natopen.GRUK2$region=="Southern Norway",c("RR2","Flate_ID")])[1]
    ),
    RR2.GRUK.reg.se = c(indmean.beta(df=res.natopen.GRUK2[res.natopen.GRUK2$region=="Northern Norway",c("RR2","Flate_ID")])[2],
                              indmean.beta(df=res.natopen.GRUK2[res.natopen.GRUK2$region=="Central Norway",c("RR2","Flate_ID")])[2],
                              indmean.beta(df=res.natopen.GRUK2[res.natopen.GRUK2$region=="Eastern Norway",c("RR2","Flate_ID")])[2],
                              indmean.beta(df=res.natopen.GRUK2[res.natopen.GRUK2$region=="Western Norway",c("RR2","Flate_ID")])[2],
                              indmean.beta(df=res.natopen.GRUK2[res.natopen.GRUK2$region=="Southern Norway",c("RR2","Flate_ID")])[2]
    ),
    RR2.GRUK.reg.n = c(0,
                             0,
                             nrow(res.natopen.GRUK2[res.natopen.GRUK2$region=="Eastern Norway" & !is.na(res.natopen.GRUK2$RR2),]),
                             0,
                             nrow(res.natopen.GRUK2[res.natopen.GRUK2$region=="Southern Norway" & !is.na(res.natopen.GRUK2$RR2),]))
  )

# RR1 (lower indicator), mean
tm_shape(regnor) +
  tm_polygons(col="RR1.ANO.reg.mean", title="CSR-R (lower), mean", style="quantile", palette=rev(get_brewer_pal(palette="OrRd", n=5, plot=FALSE))) +
  tm_text("RR1.ANO.reg.n",col="black",bg.color="grey")

# RR1 (lower indicator), se
tm_shape(regnor) +
  tm_polygons(col="RR1.ANO.reg.se", title="CSR-R (lower)", style="quantile", palette=(get_brewer_pal(palette="OrRd", n=5, plot=FALSE))) +
  tm_text("RR1.ANO.reg.n",col="black",bg.color="grey")

# GRUK

# RR2 (upper indicator), mean
tm_shape(regnor) +
  tm_polygons(col="RR2.GRUK.reg.mean", title="RR (upper)", style="quantile", palette=rev(get_brewer_pal(palette="OrRd", n=5, plot=FALSE))) +
  tm_text("RR2.GRUK.reg.n",col="black",bg.color="grey")
# RR2 (upper indicator), se
tm_shape(regnor) +
  tm_polygons(col="RR2.GRUK.reg.se", title="RR (upper)", style="quantile", palette=(get_brewer_pal(palette="OrRd", n=5, plot=FALSE))) +
  tm_text("RR2.GRUK.reg.n",col="black",bg.color="grey")


# Nitrogen2 (upper indicator), mean
tm_shape(regnor) +
  tm_polygons(col="Nitrogen2.GRUK.reg.mean", title="Nitrogen (upper)", style="quantile", palette=rev(get_brewer_pal(palette="OrRd", n=5, plot=FALSE))) +
  tm_text("Nitrogen2.GRUK.reg.n",col="black",bg.color="grey")
# Nitrogen2 (upper indicator), se
tm_shape(regnor) +
  tm_polygons(col="Nitrogen2.GRUK.reg.se", title="Nitrogen (upper)", style="quantile", palette=(get_brewer_pal(palette="OrRd", n=5, plot=FALSE))) +
  tm_text("Nitrogen2.GRUK.reg.n",col="black",bg.color="grey")



#### continue here ####

#### how many observations are there? ####
# total ANO
length(unique(ANO.geo$ano_flate_id))
length(unique(ANO.geo$ano_punkt_id))
# total natopen
length(unique(res.natopen.ANO2$ano_flate_id))
length(unique(res.natopen.ANO2$ano_punkt_id))
# by region
length(unique(res.natopen.ANO2$ano_flate_id[res.natopen.ANO2$region=="Northern Norway"]))
length(unique(res.natopen.ANO2$ano_flate_id[res.natopen.ANO2$region=="Central Norway"]))
length(unique(res.natopen.ANO2$ano_flate_id[res.natopen.ANO2$region=="Eastern Norway"]))
length(unique(res.natopen.ANO2$ano_flate_id[res.natopen.ANO2$region=="Western Norway"]))
length(unique(res.natopen.ANO2$ano_flate_id[res.natopen.ANO2$region=="Southern Norway"]))

length(unique(res.natopen.ANO2$ano_punkt_id[res.natopen.ANO2$region=="Northern Norway"]))
length(unique(res.natopen.ANO2$ano_punkt_id[res.natopen.ANO2$region=="Central Norway"]))
length(unique(res.natopen.ANO2$ano_punkt_id[res.natopen.ANO2$region=="Eastern Norway"]))
length(unique(res.natopen.ANO2$ano_punkt_id[res.natopen.ANO2$region=="Western Norway"]))
length(unique(res.natopen.ANO2$ano_punkt_id[res.natopen.ANO2$region=="Southern Norway"]))






#### distribution comparison, reference vs. field data ####
summary(res.natopen.ANO$kartleggingsenhet_1m2)
length(unique(res.natopen.ANO$kartleggingsenhet_1m2))
# 19 NiN-types, of which T41-C-1 has 0 observations, and T32 & T34 as main types don't have a reference -> so, 16 NiN-Types to plot
colnames(natopen.ref.cov[['Light']])

### Light
x11()
par(mfrow=c(4,4))
## T32s
# T32-C-1
plot(density( as.matrix(natopen.ref.cov[['Light']][,"T32-C1C2"]) ,na.rm=T),
     xlim=c(1,7), type="l", main='T32-C1',xlab='Light value')
points(density(res.natopen.ANO[res.natopen.ANO$fp_ind=="Light1" & res.natopen.ANO$fp_ind=="Light1" & res.natopen.ANO$kartleggingsenhet_1m2=="T32-C-1",]$original,na.rm=T),
       type="l", col="red")
points(res.natopen.ANO[res.natopen.ANO$fp_ind=="Light1" & res.natopen.ANO$fp_ind=="Light1" & res.natopen.ANO$kartleggingsenhet_1m2=="T32-C-1",]$original,
       rep(0,length(res.natopen.ANO[res.natopen.ANO$fp_ind=="Light1" & res.natopen.ANO$fp_ind=="Light1" & res.natopen.ANO$kartleggingsenhet_1m2=="T32-C-1",]$original)),
       col="red")

# T32-C-2
plot(density( as.matrix(natopen.ref.cov[['Light']][,"T32-C1C2"]) ,na.rm=T),
     xlim=c(1,7), type="l", main='T32-C2',xlab='Light value')
points(density(res.natopen.ANO[res.natopen.ANO$fp_ind=="Light1" & res.natopen.ANO$kartleggingsenhet_1m2=="T32-C-2",]$original,na.rm=T),
       type="l", col="red")
points(res.natopen.ANO[res.natopen.ANO$fp_ind=="Light1" & res.natopen.ANO$kartleggingsenhet_1m2=="T32-C-2",]$original,
       rep(0,length(res.natopen.ANO[res.natopen.ANO$fp_ind=="Light1" & res.natopen.ANO$kartleggingsenhet_1m2=="T32-C-2",]$original)),
       col="red")

# T32-C-3
plot(density( as.matrix(natopen.ref.cov[['Light']][,"T32-C3C4"]) ,na.rm=T),
     xlim=c(1,7), type="l", main='T32-C3',xlab='Light value')
points(density(res.natopen.ANO[res.natopen.ANO$fp_ind=="Light1" & res.natopen.ANO$kartleggingsenhet_1m2=="T32-C-3",]$original,na.rm=T),
       type="l", col="red")
points(res.natopen.ANO[res.natopen.ANO$fp_ind=="Light1" & res.natopen.ANO$kartleggingsenhet_1m2=="T32-C-3",]$original,
       rep(0,length(res.natopen.ANO[res.natopen.ANO$fp_ind=="Light1" & res.natopen.ANO$kartleggingsenhet_1m2=="T32-C-3",]$original)),
       col="red")

# T32-C-4
plot(density( as.matrix(natopen.ref.cov[['Light']][,"T32-C3C4"]) ,na.rm=T),
     xlim=c(1,7), type="l", main='T32-C4',xlab='Light value')
points(density(res.natopen.ANO[res.natopen.ANO$fp_ind=="Light1" & res.natopen.ANO$kartleggingsenhet_1m2=="T32-C-4",]$original,na.rm=T),
       type="l", col="red")
points(res.natopen.ANO[res.natopen.ANO$fp_ind=="Light1" & res.natopen.ANO$kartleggingsenhet_1m2=="T32-C-4",]$original,
       rep(0,length(res.natopen.ANO[res.natopen.ANO$fp_ind=="Light1" & res.natopen.ANO$kartleggingsenhet_1m2=="T32-C-4",]$original)),
       col="red")

# T32-C-5
plot(density( as.matrix(natopen.ref.cov[['Light']][,c("T32-C5C20a","T32-C5C20b")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='T32-C5',xlab='Light value')
points(density(res.natopen.ANO[res.natopen.ANO$fp_ind=="Light1" & res.natopen.ANO$kartleggingsenhet_1m2=="T32-C-5",]$original,na.rm=T),
       type="l", col="red")
points(res.natopen.ANO[res.natopen.ANO$fp_ind=="Light1" & res.natopen.ANO$kartleggingsenhet_1m2=="T32-C-5",]$original,
       rep(0,length(res.natopen.ANO[res.natopen.ANO$fp_ind=="Light1" & res.natopen.ANO$kartleggingsenhet_1m2=="T32-C-5",]$original)),
       col="red")

# T32-C-6
plot(density( as.matrix(natopen.ref.cov[['Light']][,c("T32-C21C6a","T32-C21C6b")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='T32-C6',xlab='Light value')
points(density(res.natopen.ANO[res.natopen.ANO$fp_ind=="Light1" & res.natopen.ANO$kartleggingsenhet_1m2=="T32-C-6",]$original,na.rm=T),
       type="l", col="red")
points(res.natopen.ANO[res.natopen.ANO$fp_ind=="Light1" & res.natopen.ANO$kartleggingsenhet_1m2=="T32-C-6",]$original,
       rep(0,length(res.natopen.ANO[res.natopen.ANO$fp_ind=="Light1" & res.natopen.ANO$kartleggingsenhet_1m2=="T32-C-6",]$original)),
       col="red")

# T32-C-9
plot(density( as.matrix(natopen.ref.cov[['Light']][,c("T32-C9a","T32-C9b")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='T32-C9',xlab='Light value')
points(density(res.natopen.ANO[res.natopen.ANO$fp_ind=="Light1" & res.natopen.ANO$kartleggingsenhet_1m2=="T32-C-9",]$original,na.rm=T),
       type="l", col="red")
points(res.natopen.ANO[res.natopen.ANO$fp_ind=="Light1" & res.natopen.ANO$kartleggingsenhet_1m2=="T32-C-9",]$original,
       rep(0,length(res.natopen.ANO[res.natopen.ANO$fp_ind=="Light1" & res.natopen.ANO$kartleggingsenhet_1m2=="T32-C-9",]$original)),
       col="red")

# T32-C-10
plot(density( as.matrix(natopen.ref.cov[['Light']][,c("T32-C10a","T32-C10b")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='T32-C10',xlab='Light value')
points(density(res.natopen.ANO[res.natopen.ANO$fp_ind=="Light1" & res.natopen.ANO$kartleggingsenhet_1m2=="T32-C-10",]$original,na.rm=T),
       type="l", col="red")
points(res.natopen.ANO[res.natopen.ANO$fp_ind=="Light1" & res.natopen.ANO$kartleggingsenhet_1m2=="T32-C-10",]$original,
       rep(0,length(res.natopen.ANO[res.natopen.ANO$fp_ind=="Light1" & res.natopen.ANO$kartleggingsenhet_1m2=="T32-C-10",]$original)),
       col="red")

# T32-C-15
plot(density( as.matrix(natopen.ref.cov[['Light']][,c("T32-C15")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='T32-C15',xlab='Light value')
#points(density(res.natopen.ANO[res.natopen.ANO$fp_ind=="Light1" & res.natopen.ANO$kartleggingsenhet_1m2=="T32-C-15",]$original,na.rm=T),
#       type="l", col="red")
points(res.natopen.ANO[res.natopen.ANO$fp_ind=="Light1" & res.natopen.ANO$kartleggingsenhet_1m2=="T32-C-15",]$original,
       rep(0,length(res.natopen.ANO[res.natopen.ANO$fp_ind=="Light1" & res.natopen.ANO$kartleggingsenhet_1m2=="T32-C-15",]$original)),
       col="red")

# T32-C-20
plot(density( as.matrix(natopen.ref.cov[['Light']][,c("T32-C5C20a","T32-C5C20b")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='T32-C20',xlab='Light value')
points(density(res.natopen.ANO[res.natopen.ANO$fp_ind=="Light1" & res.natopen.ANO$kartleggingsenhet_1m2=="T32-C-20",]$original,na.rm=T),
       type="l", col="red")
points(res.natopen.ANO[res.natopen.ANO$fp_ind=="Light1" & res.natopen.ANO$kartleggingsenhet_1m2=="T32-C-20",]$original,
       rep(0,length(res.natopen.ANO[res.natopen.ANO$fp_ind=="Light1" & res.natopen.ANO$kartleggingsenhet_1m2=="T32-C-20",]$original)),
       col="red")


## V10s
# V10-C-1
plot(density( as.matrix(natopen.ref.cov[['Light']][,"V10-C1C2"]) ,na.rm=T),
     xlim=c(1,7), type="l", main='V10-C1',xlab='Light value')
points(density(res.natopen.ANO[res.natopen.ANO$fp_ind=="Light1" & res.natopen.ANO$kartleggingsenhet_1m2=="V10-C-1",]$original,na.rm=T),
       type="l", col="red")
points(res.natopen.ANO[res.natopen.ANO$fp_ind=="Light1" & res.natopen.ANO$kartleggingsenhet_1m2=="V10-C-1",]$original,
       rep(0,length(res.natopen.ANO[res.natopen.ANO$fp_ind=="Light1" & res.natopen.ANO$kartleggingsenhet_1m2=="V10-C-1",]$original)),
       col="red")

# V10-C-3
plot(density( as.matrix(natopen.ref.cov[['Light']][,"V10-C3"]) ,na.rm=T),
     xlim=c(1,7), type="l", main='V10-C3',xlab='Light value')
#points(density(res.natopen.ANO[res.natopen.ANO$fp_ind=="Light1" & res.natopen.ANO$kartleggingsenhet_1m2=="V10-C-3",]$original,na.rm=T),
#       type="l", col="red")
points(res.natopen.ANO[res.natopen.ANO$fp_ind=="Light1" & res.natopen.ANO$kartleggingsenhet_1m2=="V10-C-3",]$original,
       rep(0,length(res.natopen.ANO[res.natopen.ANO$fp_ind=="Light1" & res.natopen.ANO$kartleggingsenhet_1m2=="V10-C-3",]$original)),
       col="red")


## T34s
# T34-C-1
plot(density( as.matrix(natopen.ref.cov[['Light']][,"T34-C1"]) ,na.rm=T),
     xlim=c(1,7), type="l", main='T34-C1',xlab='Light value')
points(density(res.natopen.ANO[res.natopen.ANO$fp_ind=="Light1" & res.natopen.ANO$kartleggingsenhet_1m2=="T34-C-1",]$original,na.rm=T),
       type="l", col="red")
points(res.natopen.ANO[res.natopen.ANO$fp_ind=="Light1" & res.natopen.ANO$kartleggingsenhet_1m2=="T34-C-1",]$original,
       rep(0,length(res.natopen.ANO[res.natopen.ANO$fp_ind=="Light1" & res.natopen.ANO$kartleggingsenhet_1m2=="T34-C-1",]$original)),
       col="red")

# T34-C-2
plot(density( as.matrix(natopen.ref.cov[['Light']][,c("T34-C2a","T34-C2b","T34-C2c")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='T34-C2',xlab='Light value')
points(density(res.natopen.ANO[res.natopen.ANO$fp_ind=="Light1" & res.natopen.ANO$kartleggingsenhet_1m2=="T34-C-2",]$original,na.rm=T),
       type="l", col="red")
points(res.natopen.ANO[res.natopen.ANO$fp_ind=="Light1" & res.natopen.ANO$kartleggingsenhet_1m2=="T34-C-2",]$original,
       rep(0,length(res.natopen.ANO[res.natopen.ANO$fp_ind=="Light1" & res.natopen.ANO$kartleggingsenhet_1m2=="T34-C-2",]$original)),
       col="red")

# T34-C-4
plot(density( as.matrix(natopen.ref.cov[['Light']][,c("T34-C4a","T34-C4b","T34-C4c","T34-C4d")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='T34-C4',xlab='Light value')
#points(density(res.natopen.ANO[res.natopen.ANO$fp_ind=="Light1" & res.natopen.ANO$kartleggingsenhet_1m2=="T34-C-4",]$original,na.rm=T),
#       type="l", col="red")
points(res.natopen.ANO[res.natopen.ANO$fp_ind=="Light1" & res.natopen.ANO$kartleggingsenhet_1m2=="T34-C-4",]$original,
       rep(0,length(res.natopen.ANO[res.natopen.ANO$fp_ind=="Light1" & res.natopen.ANO$kartleggingsenhet_1m2=="T34-C-4",]$original)),
       col="red")


## T41
plot(density( as.matrix(natopen.ref.cov[['Light']][,c("T41a","T41b")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='T41',xlab='Light value')
points(density(res.natopen.ANO[res.natopen.ANO$fp_ind=="Light1" & res.natopen.ANO$kartleggingsenhet_1m2=="T41",]$original,na.rm=T),
       type="l", col="red")
points(res.natopen.ANO[res.natopen.ANO$fp_ind=="Light1" & res.natopen.ANO$kartleggingsenhet_1m2=="T41",]$original,
       rep(0,length(res.natopen.ANO[res.natopen.ANO$fp_ind=="Light1" & res.natopen.ANO$kartleggingsenhet_1m2=="T41",]$original)),
       col="red")
legend("topleft", legend=c("reference","field data"), pch=c(NULL,1), lty=1, col=c("black","red"))



### Grazing_mowing
x11()
par(mfrow=c(4,4))
## T32s
# T32-C-1
plot(density( as.matrix(natopen.ref.cov[['Grazing_mowing']][,"T32-C1C2"]) ,na.rm=T),
     xlim=c(1,8), type="l", main='T32-C1',xlab='Grazing_mowing value')
points(density(res.natopen.ANO[res.natopen.ANO$fp_ind=="Grazing_mowing1" & res.natopen.ANO$fp_ind=="Grazing_mowing1" & res.natopen.ANO$kartleggingsenhet_1m2=="T32-C-1",]$original,na.rm=T),
       type="l", col="red")
points(res.natopen.ANO[res.natopen.ANO$fp_ind=="Grazing_mowing1" & res.natopen.ANO$fp_ind=="Grazing_mowing1" & res.natopen.ANO$kartleggingsenhet_1m2=="T32-C-1",]$original,
       rep(0,length(res.natopen.ANO[res.natopen.ANO$fp_ind=="Grazing_mowing1" & res.natopen.ANO$fp_ind=="Grazing_mowing1" & res.natopen.ANO$kartleggingsenhet_1m2=="T32-C-1",]$original)),
       col="red")

# T32-C-2
plot(density( as.matrix(natopen.ref.cov[['Grazing_mowing']][,"T32-C1C2"]) ,na.rm=T),
     xlim=c(1,8), type="l", main='T32-C2',xlab='Grazing_mowing value')
points(density(res.natopen.ANO[res.natopen.ANO$fp_ind=="Grazing_mowing1" & res.natopen.ANO$kartleggingsenhet_1m2=="T32-C-2",]$original,na.rm=T),
       type="l", col="red")
points(res.natopen.ANO[res.natopen.ANO$fp_ind=="Grazing_mowing1" & res.natopen.ANO$kartleggingsenhet_1m2=="T32-C-2",]$original,
       rep(0,length(res.natopen.ANO[res.natopen.ANO$fp_ind=="Grazing_mowing1" & res.natopen.ANO$kartleggingsenhet_1m2=="T32-C-2",]$original)),
       col="red")

# T32-C-3
plot(density( as.matrix(natopen.ref.cov[['Grazing_mowing']][,"T32-C3C4"]) ,na.rm=T),
     xlim=c(1,8), type="l", main='T32-C3',xlab='Grazing_mowing value')
points(density(res.natopen.ANO[res.natopen.ANO$fp_ind=="Grazing_mowing1" & res.natopen.ANO$kartleggingsenhet_1m2=="T32-C-3",]$original,na.rm=T),
       type="l", col="red")
points(res.natopen.ANO[res.natopen.ANO$fp_ind=="Grazing_mowing1" & res.natopen.ANO$kartleggingsenhet_1m2=="T32-C-3",]$original,
       rep(0,length(res.natopen.ANO[res.natopen.ANO$fp_ind=="Grazing_mowing1" & res.natopen.ANO$kartleggingsenhet_1m2=="T32-C-3",]$original)),
       col="red")

# T32-C-4
plot(density( as.matrix(natopen.ref.cov[['Grazing_mowing']][,"T32-C3C4"]) ,na.rm=T),
     xlim=c(1,8), type="l", main='T32-C4',xlab='Grazing_mowing value')
points(density(res.natopen.ANO[res.natopen.ANO$fp_ind=="Grazing_mowing1" & res.natopen.ANO$kartleggingsenhet_1m2=="T32-C-4",]$original,na.rm=T),
       type="l", col="red")
points(res.natopen.ANO[res.natopen.ANO$fp_ind=="Grazing_mowing1" & res.natopen.ANO$kartleggingsenhet_1m2=="T32-C-4",]$original,
       rep(0,length(res.natopen.ANO[res.natopen.ANO$fp_ind=="Grazing_mowing1" & res.natopen.ANO$kartleggingsenhet_1m2=="T32-C-4",]$original)),
       col="red")

# T32-C-5
plot(density( as.matrix(natopen.ref.cov[['Grazing_mowing']][,c("T32-C5C20a","T32-C5C20b")]) ,na.rm=T),
     xlim=c(1,8), type="l", main='T32-C5',xlab='Grazing_mowing value')
points(density(res.natopen.ANO[res.natopen.ANO$fp_ind=="Grazing_mowing1" & res.natopen.ANO$kartleggingsenhet_1m2=="T32-C-5",]$original,na.rm=T),
       type="l", col="red")
points(res.natopen.ANO[res.natopen.ANO$fp_ind=="Grazing_mowing1" & res.natopen.ANO$kartleggingsenhet_1m2=="T32-C-5",]$original,
       rep(0,length(res.natopen.ANO[res.natopen.ANO$fp_ind=="Grazing_mowing1" & res.natopen.ANO$kartleggingsenhet_1m2=="T32-C-5",]$original)),
       col="red")

# T32-C-6
plot(density( as.matrix(natopen.ref.cov[['Grazing_mowing']][,c("T32-C21C6a","T32-C21C6b")]) ,na.rm=T),
     xlim=c(1,8), type="l", main='T32-C6',xlab='Grazing_mowing value')
points(density(res.natopen.ANO[res.natopen.ANO$fp_ind=="Grazing_mowing1" & res.natopen.ANO$kartleggingsenhet_1m2=="T32-C-6",]$original,na.rm=T),
       type="l", col="red")
points(res.natopen.ANO[res.natopen.ANO$fp_ind=="Grazing_mowing1" & res.natopen.ANO$kartleggingsenhet_1m2=="T32-C-6",]$original,
       rep(0,length(res.natopen.ANO[res.natopen.ANO$fp_ind=="Grazing_mowing1" & res.natopen.ANO$kartleggingsenhet_1m2=="T32-C-6",]$original)),
       col="red")

# T32-C-9
plot(density( as.matrix(natopen.ref.cov[['Grazing_mowing']][,c("T32-C9a","T32-C9b")]) ,na.rm=T),
     xlim=c(1,8), type="l", main='T32-C9',xlab='Grazing_mowing value')
points(density(res.natopen.ANO[res.natopen.ANO$fp_ind=="Grazing_mowing1" & res.natopen.ANO$kartleggingsenhet_1m2=="T32-C-9",]$original,na.rm=T),
       type="l", col="red")
points(res.natopen.ANO[res.natopen.ANO$fp_ind=="Grazing_mowing1" & res.natopen.ANO$kartleggingsenhet_1m2=="T32-C-9",]$original,
       rep(0,length(res.natopen.ANO[res.natopen.ANO$fp_ind=="Grazing_mowing1" & res.natopen.ANO$kartleggingsenhet_1m2=="T32-C-9",]$original)),
       col="red")

# T32-C-10
plot(density( as.matrix(natopen.ref.cov[['Grazing_mowing']][,c("T32-C10a","T32-C10b")]) ,na.rm=T),
     xlim=c(1,8), type="l", main='T32-C10',xlab='Grazing_mowing value')
points(density(res.natopen.ANO[res.natopen.ANO$fp_ind=="Grazing_mowing1" & res.natopen.ANO$kartleggingsenhet_1m2=="T32-C-10",]$original,na.rm=T),
       type="l", col="red")
points(res.natopen.ANO[res.natopen.ANO$fp_ind=="Grazing_mowing1" & res.natopen.ANO$kartleggingsenhet_1m2=="T32-C-10",]$original,
       rep(0,length(res.natopen.ANO[res.natopen.ANO$fp_ind=="Grazing_mowing1" & res.natopen.ANO$kartleggingsenhet_1m2=="T32-C-10",]$original)),
       col="red")

# T32-C-15
plot(density( as.matrix(natopen.ref.cov[['Grazing_mowing']][,c("T32-C15")]) ,na.rm=T),
     xlim=c(1,8), type="l", main='T32-C15',xlab='Grazing_mowing value')
#points(density(res.natopen.ANO[res.natopen.ANO$fp_ind=="Grazing_mowing1" & res.natopen.ANO$kartleggingsenhet_1m2=="T32-C-15",]$original,na.rm=T),
#       type="l", col="red")
points(res.natopen.ANO[res.natopen.ANO$fp_ind=="Grazing_mowing1" & res.natopen.ANO$kartleggingsenhet_1m2=="T32-C-15",]$original,
       rep(0,length(res.natopen.ANO[res.natopen.ANO$fp_ind=="Grazing_mowing1" & res.natopen.ANO$kartleggingsenhet_1m2=="T32-C-15",]$original)),
       col="red")

# T32-C-20
plot(density( as.matrix(natopen.ref.cov[['Grazing_mowing']][,c("T32-C5C20a","T32-C5C20b")]) ,na.rm=T),
     xlim=c(1,8), type="l", main='T32-C20',xlab='Grazing_mowing value')
points(density(res.natopen.ANO[res.natopen.ANO$fp_ind=="Grazing_mowing1" & res.natopen.ANO$kartleggingsenhet_1m2=="T32-C-20",]$original,na.rm=T),
       type="l", col="red")
points(res.natopen.ANO[res.natopen.ANO$fp_ind=="Grazing_mowing1" & res.natopen.ANO$kartleggingsenhet_1m2=="T32-C-20",]$original,
       rep(0,length(res.natopen.ANO[res.natopen.ANO$fp_ind=="Grazing_mowing1" & res.natopen.ANO$kartleggingsenhet_1m2=="T32-C-20",]$original)),
       col="red")


## V10s
# V10-C-1
plot(density( as.matrix(natopen.ref.cov[['Grazing_mowing']][,"V10-C1C2"]) ,na.rm=T),
     xlim=c(1,8), type="l", main='V10-C1',xlab='Grazing_mowing value')
points(density(res.natopen.ANO[res.natopen.ANO$fp_ind=="Grazing_mowing1" & res.natopen.ANO$kartleggingsenhet_1m2=="V10-C-1",]$original,na.rm=T),
       type="l", col="red")
points(res.natopen.ANO[res.natopen.ANO$fp_ind=="Grazing_mowing1" & res.natopen.ANO$kartleggingsenhet_1m2=="V10-C-1",]$original,
       rep(0,length(res.natopen.ANO[res.natopen.ANO$fp_ind=="Grazing_mowing1" & res.natopen.ANO$kartleggingsenhet_1m2=="V10-C-1",]$original)),
       col="red")

# V10-C-3
plot(density( as.matrix(natopen.ref.cov[['Grazing_mowing']][,"V10-C3"]) ,na.rm=T),
     xlim=c(1,8), type="l", main='V10-C3',xlab='Grazing_mowing value')
#points(density(res.natopen.ANO[res.natopen.ANO$fp_ind=="Grazing_mowing1" & res.natopen.ANO$kartleggingsenhet_1m2=="V10-C-3",]$original,na.rm=T),
#       type="l", col="red")
points(res.natopen.ANO[res.natopen.ANO$fp_ind=="Grazing_mowing1" & res.natopen.ANO$kartleggingsenhet_1m2=="V10-C-3",]$original,
       rep(0,length(res.natopen.ANO[res.natopen.ANO$fp_ind=="Grazing_mowing1" & res.natopen.ANO$kartleggingsenhet_1m2=="V10-C-3",]$original)),
       col="red")


## T34s
# T34-C-1
plot(density( as.matrix(natopen.ref.cov[['Grazing_mowing']][,"T34-C1"]) ,na.rm=T),
     xlim=c(1,8), type="l", main='T34-C1',xlab='Grazing_mowing value')
points(density(res.natopen.ANO[res.natopen.ANO$fp_ind=="Grazing_mowing1" & res.natopen.ANO$kartleggingsenhet_1m2=="T34-C-1",]$original,na.rm=T),
       type="l", col="red")
points(res.natopen.ANO[res.natopen.ANO$fp_ind=="Grazing_mowing1" & res.natopen.ANO$kartleggingsenhet_1m2=="T34-C-1",]$original,
       rep(0,length(res.natopen.ANO[res.natopen.ANO$fp_ind=="Grazing_mowing1" & res.natopen.ANO$kartleggingsenhet_1m2=="T34-C-1",]$original)),
       col="red")

# T34-C-2
plot(density( as.matrix(natopen.ref.cov[['Grazing_mowing']][,c("T34-C2a","T34-C2b","T34-C2c")]) ,na.rm=T),
     xlim=c(1,8), type="l", main='T34-C2',xlab='Grazing_mowing value')
points(density(res.natopen.ANO[res.natopen.ANO$fp_ind=="Grazing_mowing1" & res.natopen.ANO$kartleggingsenhet_1m2=="T34-C-2",]$original,na.rm=T),
       type="l", col="red")
points(res.natopen.ANO[res.natopen.ANO$fp_ind=="Grazing_mowing1" & res.natopen.ANO$kartleggingsenhet_1m2=="T34-C-2",]$original,
       rep(0,length(res.natopen.ANO[res.natopen.ANO$fp_ind=="Grazing_mowing1" & res.natopen.ANO$kartleggingsenhet_1m2=="T34-C-2",]$original)),
       col="red")

# T34-C-4
plot(density( as.matrix(natopen.ref.cov[['Grazing_mowing']][,c("T34-C4a","T34-C4b","T34-C4c","T34-C4d")]) ,na.rm=T),
     xlim=c(1,8), type="l", main='T34-C4',xlab='Grazing_mowing value')
#points(density(res.natopen.ANO[res.natopen.ANO$fp_ind=="Grazing_mowing1" & res.natopen.ANO$kartleggingsenhet_1m2=="T34-C-4",]$original,na.rm=T),
#       type="l", col="red")
points(res.natopen.ANO[res.natopen.ANO$fp_ind=="Grazing_mowing1" & res.natopen.ANO$kartleggingsenhet_1m2=="T34-C-4",]$original,
       rep(0,length(res.natopen.ANO[res.natopen.ANO$fp_ind=="Grazing_mowing1" & res.natopen.ANO$kartleggingsenhet_1m2=="T34-C-4",]$original)),
       col="red")


## T41
plot(density( as.matrix(natopen.ref.cov[['Grazing_mowing']][,c("T41a","T41b")]) ,na.rm=T),
     xlim=c(1,8), type="l", main='T41',xlab='Grazing_mowing value')
points(density(res.natopen.ANO[res.natopen.ANO$fp_ind=="Grazing_mowing1" & res.natopen.ANO$kartleggingsenhet_1m2=="T41",]$original,na.rm=T),
       type="l", col="red")
points(res.natopen.ANO[res.natopen.ANO$fp_ind=="Grazing_mowing1" & res.natopen.ANO$kartleggingsenhet_1m2=="T41",]$original,
       rep(0,length(res.natopen.ANO[res.natopen.ANO$fp_ind=="Grazing_mowing1" & res.natopen.ANO$kartleggingsenhet_1m2=="T41",]$original)),
       col="red")
legend("topleft", legend=c("reference","field data"), pch=c(NA,1), lty=1, col=c("black","red"))




## similarly for ASO, here with just Nitrogen
summary(res.natopen.ASO$NiN_grunntype)
length(levels(res.natopen.ASO$NiN_grunntype))
# 12 NiN-types, of which C-13 and C-2 have 0 observations -> so, 10 NiN-Types to plot
colnames(natopen.ref.cov[['Nitrogen']])

### Nitrogen
x11()
par(mfrow=c(3,4))
# T32-C-1
plot(density( as.matrix(natopen.ref.cov[['Nitrogen']][,"T32-C1C2"]) ,na.rm=T),
     xlim=c(1,8), type="l", main='T32-C1',xlab='Nitrogen value')
points(density(res.natopen.ASO[res.natopen.ASO$fp_ind=="Nitrogen2" & res.natopen.ASO$fp_ind=="Nitrogen2" & res.natopen.ASO$NiN_grunntype=="T32-C-1",]$original,na.rm=T),
       type="l", col="red")
points(res.natopen.ASO[res.natopen.ASO$fp_ind=="Nitrogen2" & res.natopen.ASO$fp_ind=="Nitrogen2" & res.natopen.ASO$NiN_grunntype=="T32-C-1",]$original,
       rep(0,length(res.natopen.ASO[res.natopen.ASO$fp_ind=="Nitrogen2" & res.natopen.ASO$fp_ind=="Nitrogen2" & res.natopen.ASO$NiN_grunntype=="T32-C-1",]$original)),
       col="red")

# T32-C-3
plot(density( as.matrix(natopen.ref.cov[['Nitrogen']][,"T32-C3C4"]) ,na.rm=T),
     xlim=c(1,8), type="l", main='T32-C3',xlab='Nitrogen value')
points(density(res.natopen.ASO[res.natopen.ASO$fp_ind=="Nitrogen2" & res.natopen.ASO$NiN_grunntype=="T32-C-3",]$original,na.rm=T),
       type="l", col="red")
points(res.natopen.ASO[res.natopen.ASO$fp_ind=="Nitrogen2" & res.natopen.ASO$NiN_grunntype=="T32-C-3",]$original,
       rep(0,length(res.natopen.ASO[res.natopen.ASO$fp_ind=="Nitrogen2" & res.natopen.ASO$NiN_grunntype=="T32-C-3",]$original)),
       col="red")

# T32-C-4
plot(density( as.matrix(natopen.ref.cov[['Nitrogen']][,"T32-C3C4"]) ,na.rm=T),
     xlim=c(1,8), type="l", main='T32-C4',xlab='Nitrogen value')
points(density(res.natopen.ASO[res.natopen.ASO$fp_ind=="Nitrogen2" & res.natopen.ASO$NiN_grunntype=="T32-C-4",]$original,na.rm=T),
       type="l", col="red")
points(res.natopen.ASO[res.natopen.ASO$fp_ind=="Nitrogen2" & res.natopen.ASO$NiN_grunntype=="T32-C-4",]$original,
       rep(0,length(res.natopen.ASO[res.natopen.ASO$fp_ind=="Nitrogen2" & res.natopen.ASO$NiN_grunntype=="T32-C-4",]$original)),
       col="red")

# T32-C-5
plot(density( as.matrix(natopen.ref.cov[['Nitrogen']][,c("T32-C5C20a","T32-C5C20b")]) ,na.rm=T),
     xlim=c(1,8), type="l", main='T32-C5',xlab='Nitrogen value')
points(density(res.natopen.ASO[res.natopen.ASO$fp_ind=="Nitrogen2" & res.natopen.ASO$NiN_grunntype=="T32-C-5",]$original,na.rm=T),
       type="l", col="red")
points(res.natopen.ASO[res.natopen.ASO$fp_ind=="Nitrogen2" & res.natopen.ASO$NiN_grunntype=="T32-C-5",]$original,
       rep(0,length(res.natopen.ASO[res.natopen.ASO$fp_ind=="Nitrogen2" & res.natopen.ASO$NiN_grunntype=="T32-C-5",]$original)),
       col="red")

# T32-C-6
plot(density( as.matrix(natopen.ref.cov[['Nitrogen']][,c("T32-C21C6a","T32-C21C6b")]) ,na.rm=T),
     xlim=c(1,8), type="l", main='T32-C6',xlab='Nitrogen value')
points(density(res.natopen.ASO[res.natopen.ASO$fp_ind=="Nitrogen2" & res.natopen.ASO$NiN_grunntype=="T32-C-6",]$original,na.rm=T),
       type="l", col="red")
points(res.natopen.ASO[res.natopen.ASO$fp_ind=="Nitrogen2" & res.natopen.ASO$NiN_grunntype=="T32-C-6",]$original,
       rep(0,length(res.natopen.ASO[res.natopen.ASO$fp_ind=="Nitrogen2" & res.natopen.ASO$NiN_grunntype=="T32-C-6",]$original)),
       col="red")

# T32-C-7
plot(density( as.matrix(natopen.ref.cov[['Nitrogen']][,c("T32-C7C8")]) ,na.rm=T),
     xlim=c(1,8), type="l", main='T32-C7',xlab='Nitrogen value')
#points(density(res.natopen.ASO[res.natopen.ASO$fp_ind=="Nitrogen2" & res.natopen.ASO$NiN_grunntype=="T32-C-7",]$original,na.rm=T),
#       type="l", col="red")
points(res.natopen.ASO[res.natopen.ASO$fp_ind=="Nitrogen2" & res.natopen.ASO$NiN_grunntype=="T32-C-7",]$original,
       rep(0,length(res.natopen.ASO[res.natopen.ASO$fp_ind=="Nitrogen2" & res.natopen.ASO$NiN_grunntype=="T32-C-7",]$original)),
       col="red")

# T32-C-8
plot(density( as.matrix(natopen.ref.cov[['Nitrogen']][,c("T32-C7C8")]) ,na.rm=T),
     xlim=c(1,8), type="l", main='T32-C8',xlab='Nitrogen value')
points(density(res.natopen.ASO[res.natopen.ASO$fp_ind=="Nitrogen2" & res.natopen.ASO$NiN_grunntype=="T32-C-8",]$original,na.rm=T),
       type="l", col="red")
points(res.natopen.ASO[res.natopen.ASO$fp_ind=="Nitrogen2" & res.natopen.ASO$NiN_grunntype=="T32-C-8",]$original,
       rep(0,length(res.natopen.ASO[res.natopen.ASO$fp_ind=="Nitrogen2" & res.natopen.ASO$NiN_grunntype=="T32-C-8",]$original)),
       col="red")

# T32-C-9
plot(density( as.matrix(natopen.ref.cov[['Nitrogen']][,c("T32-C9a","T32-C9b")]) ,na.rm=T),
     xlim=c(1,8), type="l", main='T32-C9',xlab='Nitrogen value')
#points(density(res.natopen.ASO[res.natopen.ASO$fp_ind=="Nitrogen2" & res.natopen.ASO$NiN_grunntype=="T32-C-9",]$original,na.rm=T),
#       type="l", col="red")
points(res.natopen.ASO[res.natopen.ASO$fp_ind=="Nitrogen2" & res.natopen.ASO$NiN_grunntype=="T32-C-9",]$original,
       rep(0,length(res.natopen.ASO[res.natopen.ASO$fp_ind=="Nitrogen2" & res.natopen.ASO$NiN_grunntype=="T32-C-9",]$original)),
       col="red")

# T32-C-10
plot(density( as.matrix(natopen.ref.cov[['Nitrogen']][,c("T32-C10a","T32-C10b")]) ,na.rm=T),
     xlim=c(1,8), type="l", main='T32-C10',xlab='Nitrogen value')
#points(density(res.natopen.ASO[res.natopen.ASO$fp_ind=="Nitrogen2" & res.natopen.ASO$NiN_grunntype=="T32-C-10",]$original,na.rm=T),
#       type="l", col="red")
points(res.natopen.ASO[res.natopen.ASO$fp_ind=="Nitrogen2" & res.natopen.ASO$NiN_grunntype=="T32-C-10",]$original,
       rep(0,length(res.natopen.ASO[res.natopen.ASO$fp_ind=="Nitrogen2" & res.natopen.ASO$NiN_grunntype=="T32-C-10",]$original)),
       col="red")


# T32-C-20
plot(density( as.matrix(natopen.ref.cov[['Nitrogen']][,c("T32-C5C20a","T32-C5C20b")]) ,na.rm=T),
     xlim=c(1,8), type="l", main='T32-C20',xlab='Nitrogen value')
points(density(res.natopen.ASO[res.natopen.ASO$fp_ind=="Nitrogen2" & res.natopen.ASO$NiN_grunntype=="T32-C-20",]$original,na.rm=T),
       type="l", col="red")
points(res.natopen.ASO[res.natopen.ASO$fp_ind=="Nitrogen2" & res.natopen.ASO$NiN_grunntype=="T32-C-20",]$original,
       rep(0,length(res.natopen.ASO[res.natopen.ASO$fp_ind=="Nitrogen2" & res.natopen.ASO$NiN_grunntype=="T32-C-20",]$original)),
       col="red")

legend("topleft", legend=c("reference","field data"), pch=c(NA,1), lty=1, col=c("black","red"))


#### relating scaled values to NiN condition variables ####
ggplot(res.natopen.ANO, aes(x=bruksintensitet, y=scaled_value)) +
  geom_point() +
  facet_wrap(~fp_ind, scale="fixed")

ggplot(res.natopen.ASO, aes(x=bruksintensitet, y=scaled_value)) +
  geom_point() +
  facet_wrap(~fp_ind, scale="fixed")
