ibrary(downloader)
library(sf)
library(tidyr)
library(plyr)
library(dplyr)
library(stringr)
library(tidyverse)
library(readxl)
library(tmap)
library(tmaptools)
library(betareg)
library(glmmTMB)

#### getting all the data from previous scripts in ####
load("P:/41201785_okologisk_tilstand_2022_2023/data/FPI_output large files for markdown/data_seminat.RData")
load("P:/41201785_okologisk_tilstand_2022_2023/data/FPI_output large files for markdown/ref_lists_seminat.RData")
load("P:/41201785_okologisk_tilstand_2022_2023/data/FPI_output large files for markdown/results.seminat.ANO.RData")
load("P:/41201785_okologisk_tilstand_2022_2023/data/FPI_output large files for markdown/results.seminat.ASO.RData")




#### plotting scaled values by main ecosystem type ####
## continuing with 2-sided
res.seminat.ANO <- results.seminat.ANO[['2-sided']]
colnames(res.seminat.ANO)

# make long version of the scaled value part
res.seminat.ANO <-
  res.seminat.ANO %>% 
  pivot_longer(
    cols = c("Light1","Light2",
             "Moist1","Moist2",
             "pH1","pH2",
             "Nitrogen1","Nitrogen2",
             "Phosphorus1","Phosphorus2",
             "Grazing_mowing1","Grazing_mowing2",
             "Soil_disturbance1","Soil_disturbance2"),
    names_to = "fp_ind",
    values_to = "scaled_value",
    values_drop_na = FALSE
  )

# add original values as well
res.seminat.ANO <- 
  res.seminat.ANO %>% add_column(original = results.seminat.ANO[['original']] %>% 
                                   pivot_longer(
                                     cols = c("Light1","Light2",
                                              "Moist1","Moist2",
                                              "pH1","pH2",
                                              "Nitrogen1","Nitrogen2",
                                              "Phosphorus1","Phosphorus2",
                                              "Grazing_mowing1","Grazing_mowing2",
                                              "Soil_disturbance1","Soil_disturbance2"),
                                     names_to = NULL,
                                     values_to = "original",
                                     values_drop_na = FALSE
                                   ) %>%
                                   pull(original)
  )

head(res.seminat.ANO[,70:76])


# similarly for ASO
res.seminat.ASO <- results.seminat.ASO[['2-sided']]
colnames(res.seminat.ASO)

# make long version of the scaled value part
res.seminat.ASO <-
  res.seminat.ASO %>% 
  pivot_longer(
    cols = c("Light1","Light2",
             "Moist1","Moist2",
             "pH1","pH2",
             "Nitrogen1","Nitrogen2",
             "Phosphorus1","Phosphorus2",
             "Grazing_mowing1","Grazing_mowing2",
             "Soil_disturbance1","Soil_disturbance2"),
    names_to = "fp_ind",
    values_to = "scaled_value",
    values_drop_na = FALSE
  )

# add original values as well
res.seminat.ASO <- 
  res.seminat.ASO %>% add_column(original = results.seminat.ASO[['original']] %>% 
                                   pivot_longer(
                                     cols = c("Light1","Light2",
                                              "Moist1","Moist2",
                                              "pH1","pH2",
                                              "Nitrogen1","Nitrogen2",
                                              "Phosphorus1","Phosphorus2",
                                              "Grazing_mowing1","Grazing_mowing2",
                                              "Soil_disturbance1","Soil_disturbance2"),
                                     names_to = NULL,
                                     values_to = "original",
                                     values_drop_na = FALSE
                                   ) %>%
                                   pull(original)
  )

head(res.seminat.ASO[,70:76])



# making the plot, ANO
ggplot(res.seminat.ANO, aes(x=factor(hovedtype_rute), y=scaled_value, fill=fp_ind)) + 
  geom_hline(yintercept=0.6, linetype="dashed") + 
  geom_violin(color=NA) +
  #  geom_boxplot(width=0.2, color="grey") +
  geom_point(size=1, shape=16, color="black") +
  facet_wrap(~factor(fp_ind,levels=c("Light1","Moist1","pH1","Nitrogen1","Phosphorus1","Grazing_mowing1","Soil_disturbance1",
                                     "Light2","Moist2","pH2","Nitrogen2","Phosphorus2","Grazing_mowing2","Soil_disturbance2")), ncol = 7) + 
  xlab("Main ecosystem type") + 
  ylab("Scaled indicator value (ANO data)") 


# making the plot, ANO Light, Moist & pH
ggplot(data=subset(res.seminat.ANO,!is.na(scaled_value) & fp_ind %in% c("Light1","Moist1","pH1",
                                                                        "Light2","Moist2","pH2")),
       aes(x=factor(hovedtype_rute), y=scaled_value, fill=fp_ind)) + 
  geom_hline(yintercept=0.6, linetype="dashed") + 
  geom_violin(color=NA) +
  #  geom_boxplot(width=0.2, color="grey") +
  geom_point(size=1, shape=16, color="black") +
  facet_wrap(~factor(fp_ind,levels=c("Light1","Moist1","pH1",
                                     "Light2","Moist2","pH2")), ncol = 3) + 
  xlab("Main ecosystem type") + 
  ylab("Scaled indicator value (ANO data)") +
  theme(legend.position="none")

# making the plot, ANO Nitrogen, Phosphorus, Grazing_mowing, Soil_disturbance
ggplot(data=subset(res.seminat.ANO,!is.na(scaled_value) & fp_ind %in% c("Nitrogen1","Phosphorus1","Grazing_mowing1","Soil_disturbance1",
                                                                        "Nitrogen2","Phosphorus2","Grazing_mowing2","Soil_disturbance2")),
       aes(x=factor(hovedtype_rute), y=scaled_value, fill=fp_ind)) + 
  geom_hline(yintercept=0.6, linetype="dashed") + 
  geom_violin(color=NA) +
  #  geom_boxplot(width=0.2, color="grey") +
  geom_point(size=1, shape=16, color="black") +
  facet_wrap(~factor(fp_ind,levels=c("Nitrogen1","Phosphorus1","Grazing_mowing1","Soil_disturbance1",
                                     "Nitrogen2","Phosphorus2","Grazing_mowing2","Soil_disturbance2")), ncol = 4) + 
  xlab("Main ecosystem type") + 
  ylab("Scaled indicator value (ANO data)") +
  theme(legend.position="none")


# making the plot, ASO
res.seminat.ASO$NiN_grunntype2 <- as.factor(substring(res.seminat.ASO$NiN_grunntype,5))
res.seminat.ASO$NiN_grunntype2 <- factor(res.seminat.ASO$NiN_grunntype2, levels=c("C-1","C-2","C-3","C-4","C-5","C-6",
                                                                                  "C-7","C-8","C-9","C-10","C-13","C-20"))
ggplot(res.seminat.ASO, aes(x=factor(NiN_grunntype2), y=scaled_value, fill=fp_ind)) + 
  geom_hline(yintercept=0.6, linetype="dashed") + 
  geom_violin(color = NA) +
  #  geom_boxplot(width=0.2, color="grey") +
  geom_point(size=1, shape=16, color="black") +
  facet_wrap(~factor(fp_ind,levels=c("Light1","Moist1","pH1","Nitrogen1","Phosphorus1","Grazing_mowing1","Soil_disturbance1",
                                     "Light2","Moist2","pH2","Nitrogen2","Phosphorus2","Grazing_mowing2","Soil_disturbance2")), ncol = 7) + 
  xlab("T32 (semi-natural meadow) basic ecosystem type") + 
  ylab("Scaled indicator value (ASO data)") 


# making the plot, ASO Light, Moist, pH1
ggplot(data=subset(res.seminat.ASO,!is.na(scaled_value) & fp_ind %in% c("Light1","Moist1","pH1",
                                                                        "Light2","Moist2","pH2")),
       aes(x=factor(NiN_grunntype2), y=scaled_value, fill=fp_ind)) + 
  geom_hline(yintercept=0.6, linetype="dashed") + 
  geom_violin(color = NA) +
  #  geom_boxplot(width=0.2, color="grey") +
  geom_point(size=1, shape=16, color="black") +
  facet_wrap(~factor(fp_ind,levels=c("Light1","Moist1","pH1",
                                     "Light2","Moist2","pH2")), ncol = 3) + 
  xlab("T32 (semi-natural meadow) basic ecosystem type") + 
  ylab("Scaled indicator value (ASO data)") +
  theme(legend.position="none") +
  theme(axis.text.x = element_text(angle = -45, vjust = 0.5, hjust=0.2))


# making the plot, ASO Nitrogen, Phosphorus, Grazing_mowing, Soil_disturbance
ggplot(data=subset(res.seminat.ASO,!is.na(scaled_value) & fp_ind %in% c("Nitrogen1","Phosphorus1","Grazing_mowing1","Soil_disturbance1",
                                                                        "Nitrogen2","Phosphorus2","Grazing_mowing2","Soil_disturbance2")),
       aes(x=factor(NiN_grunntype2), y=scaled_value, fill=fp_ind)) + 
  geom_hline(yintercept=0.6, linetype="dashed") + 
  geom_violin(color = NA) +
  #  geom_boxplot(width=0.2, color="grey") +
  geom_point(size=1, shape=16, color="black") +
  facet_wrap(~factor(fp_ind,levels=c("Nitrogen1","Phosphorus1","Grazing_mowing1","Soil_disturbance1",
                                     "Nitrogen2","Phosphorus2","Grazing_mowing2","Soil_disturbance2")), ncol = 4) + 
  xlab("T32 (semi-natural meadow) basic ecosystem type") + 
  ylab("Scaled indicator value (ASO data)")  +
  theme(legend.position="none") +
  theme(axis.text.x = element_text(angle = -45, vjust = 0.5, hjust=0.2))


#### scaled value maps ####
# keep wide format and add geometry again
res.seminat.ANO2 <- results.seminat.ANO[['2-sided']]
st_geometry(res.seminat.ANO2) <- st_geometry(ANO.seminat)

## similarly for ASO
# keep wide format and add geometry again
res.seminat.ASO2 <- results.seminat.ASO[['2-sided']]
st_geometry(res.seminat.ASO2) <- st_geometry(ASO.geo)
res.seminat.ASO2 <- res.seminat.ASO2 %>% st_transform(crs = st_crs(res.seminat.ANO2))


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

# Light1 (lower indicator)
tm_shape(regnor) +
  tm_fill('GID_0', labels="", title="", legend.show = FALSE) + 
  tm_borders() +
  tm_shape(res.seminat.ANO2) +
  tm_dots('Light1',midpoint=NA, palette=tmaptools::get_brewer_pal("YlOrRd", 7, plot = FALSE), scale=1, legend.show = FALSE) + # 
  tm_layout(main.title = "Light index (lower), seminat",legend.position = c("right", "bottom"), main.title.size=1.2) + 
  tm_add_legend(type = "fill", 
                col = c(tmaptools::get_brewer_pal("YlOrRd", 5, plot = FALSE),'grey'),
                labels = c("0.0 - 0.2", "0.2 - 0.4", "0.4 - 0.6", 
                           "0.6 - 0.8", "0.8 - 1.0", "NA"),
                title = "index values")



# Grazing_mowing1 (lower indicator)
tm_shape(regnor) +
  tm_fill('GID_0', labels="", title="", legend.show = FALSE) + 
  tm_borders() +
  tm_shape(res.seminat.ANO2) +
  tm_dots('Grazing_mowing1',midpoint=NA, palette=tmaptools::get_brewer_pal("YlOrRd", 7, plot = FALSE), scale=1, legend.show = FALSE) + # 
  tm_layout(main.title = "Grazing_mowing index (lower), seminat",legend.position = c("right", "bottom"), main.title.size=1.2) + 
  tm_add_legend(type = "fill", 
                col = c(tmaptools::get_brewer_pal("YlOrRd", 6, plot = FALSE),'grey'),
                labels = c("0.4 - 0.5", "0.5 - 0.6", "0.6 - 0.7", 
                           "0.7 - 0.8", "0.8 - 0.9", "0.9 - 1.0", "NA"),
                title = "index values")

# pH1 (upper indicator)
tm_shape(regnor) +
  tm_fill('GID_0', labels="", title="", legend.show = FALSE) + 
  tm_borders() +
  tm_shape(res.seminat.ANO2) +
  tm_dots('pH1',midpoint=NA, palette=tmaptools::get_brewer_pal("YlOrRd", 7, plot = FALSE), scale=1, legend.show = FALSE) + # 
  tm_layout(main.title = "pH index (lower), seminat",legend.position = c("right", "bottom"), main.title.size=1.2) + 
  tm_add_legend(type = "fill", 
                col = c(tmaptools::get_brewer_pal("YlOrRd", 7, plot = FALSE),'grey'),
                labels = c("0.3 - 0.4", "0.4 - 0.5", "0.5 - 0.6", "0.6 - 0.7", 
                           "0.7 - 0.8", "0.8 - 0.9", "0.9 - 1.0", "NA"),
                title = "index values")




# ASO nitrogen2 (upper indicator)
tm_shape(regnor) +
  tm_fill('GID_0', labels="", title="", legend.show = FALSE) + 
  tm_borders() +
  tm_shape(res.seminat.ASO2) +
  tm_dots('Nitrogen2',midpoint=NA, palette=tmaptools::get_brewer_pal("YlOrRd", 7, plot = FALSE), scale=1, legend.show = FALSE) + # 
  tm_layout(main.title = "Nitrogen index (upper), seminat",legend.position = c("right", "bottom"), main.title.size=1.2) + 
  tm_add_legend(type = "fill", 
                col = c(tmaptools::get_brewer_pal("YlOrRd", 7, plot = FALSE),'grey'),
                labels = c("0.3 - 0.4", "0.4 - 0.5", "0.5 - 0.6", "0.6 - 0.7", 
                           "0.7 - 0.8", "0.8 - 0.9", "0.9 - 1.0", "NA"),
                title = "index values")

# very few spots on the map with only 2022 data from ASO



# let's look at things by region
res.seminat.ANO2 = st_join(res.seminat.ANO2, regnor, left = TRUE)
colnames(res.seminat.ANO2)

res.seminat.ASO2 = st_join(res.seminat.ASO2, regnor, left = TRUE)
colnames(res.seminat.ASO2)

# simple means, inappropriate for 0-1 bound data
res.seminat.ANO2 %>% 
  group_by(as.factor(region)) %>% 
  mutate(Light1.reg.mean = mean(Light1,na.rm=T)) %>%
  mutate(Light2.reg.mean = mean(Light1,na.rm=T)) %>%
  mutate(Moist1.reg.mean = mean(Moist1,na.rm=T)) %>%
  mutate(Moist2.reg.mean = mean(Moist1,na.rm=T)) %>%
  mutate(pH1.reg.mean = mean(pH1,na.rm=T)) %>%
  mutate(pH2.reg.mean = mean(pH1,na.rm=T)) %>%
  mutate(Nitrogen1.reg.mean = mean(Nitrogen1,na.rm=T)) %>%
  mutate(Nitrogen2.reg.mean = mean(Nitrogen2,na.rm=T)) %>%
  mutate(Phosphorus1.reg.mean = mean(Phosphorus1,na.rm=T)) %>%
  mutate(Phosphorus2.reg.mean = mean(Phosphorus2,na.rm=T)) %>%
  mutate(Grazing_mowing1.reg.mean = mean(Grazing_mowing1,na.rm=T)) %>%
  mutate(Grazing_mowing2.reg.mean = mean(Grazing_mowing2,na.rm=T)) %>%
  mutate(Soil_disturbance1.reg.mean = mean(Soil_disturbance1,na.rm=T)) %>%
  mutate(Soil_disturbance2.reg.mean = mean(Soil_disturbance2,na.rm=T))

# and for ASO
res.seminat.ASO2 %>% 
  group_by(as.factor(region)) %>% 
  mutate(Light1.reg.mean = mean(Light1,na.rm=T)) %>%
  mutate(Light2.reg.mean = mean(Light1,na.rm=T)) %>%
  mutate(Moist1.reg.mean = mean(Moist1,na.rm=T)) %>%
  mutate(Moist2.reg.mean = mean(Moist1,na.rm=T)) %>%
  mutate(pH1.reg.mean = mean(pH1,na.rm=T)) %>%
  mutate(pH2.reg.mean = mean(pH1,na.rm=T)) %>%
  mutate(Nitrogen1.reg.mean = mean(Nitrogen1,na.rm=T)) %>%
  mutate(Nitrogen2.reg.mean = mean(Nitrogen2,na.rm=T)) %>%
  mutate(Phosphorus1.reg.mean = mean(Phosphorus1,na.rm=T)) %>%
  mutate(Phosphorus2.reg.mean = mean(Phosphorus2,na.rm=T)) %>%
  mutate(Grazing_mowing1.reg.mean = mean(Grazing_mowing1,na.rm=T)) %>%
  mutate(Grazing_mowing2.reg.mean = mean(Grazing_mowing2,na.rm=T)) %>%
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



indmean.beta(df=res.seminat.ANO2[res.seminat.ANO2$region=="Northern Norway",c("Grazing_mowing1","ano_flate_id")])

indmean.beta(df=res.seminat.ASO2[res.seminat.ASO2$region=="Northern Norway",c("Grazing_mowing1","Omradenummer_flatenummer")])



regnor <- regnor %>%
  mutate(
    Grazing_mowing1.ANO.reg.mean = c(indmean.beta(df=res.seminat.ANO2[res.seminat.ANO2$region=="Northern Norway",c("Grazing_mowing1","ano_flate_id")])[1],
                                     indmean.beta(df=res.seminat.ANO2[res.seminat.ANO2$region=="Central Norway",c("Grazing_mowing1","ano_flate_id")])[1],
                                     indmean.beta(df=res.seminat.ANO2[res.seminat.ANO2$region=="Eastern Norway",c("Grazing_mowing1","ano_flate_id")])[1],
                                     indmean.beta(df=res.seminat.ANO2[res.seminat.ANO2$region=="Western Norway",c("Grazing_mowing1","ano_flate_id")])[1],
                                     indmean.beta(df=res.seminat.ANO2[res.seminat.ANO2$region=="Southern Norway",c("Grazing_mowing1","ano_flate_id")])[1]
    ),
    Grazing_mowing1.ANO.reg.se = c(indmean.beta(df=res.seminat.ANO2[res.seminat.ANO2$region=="Northern Norway",c("Grazing_mowing1","ano_flate_id")])[2],
                                   indmean.beta(df=res.seminat.ANO2[res.seminat.ANO2$region=="Central Norway",c("Grazing_mowing1","ano_flate_id")])[2],
                                   indmean.beta(df=res.seminat.ANO2[res.seminat.ANO2$region=="Eastern Norway",c("Grazing_mowing1","ano_flate_id")])[2],
                                   indmean.beta(df=res.seminat.ANO2[res.seminat.ANO2$region=="Western Norway",c("Grazing_mowing1","ano_flate_id")])[2],
                                   indmean.beta(df=res.seminat.ANO2[res.seminat.ANO2$region=="Southern Norway",c("Grazing_mowing1","ano_flate_id")])[2]
    ),
    Grazing_mowing1.ANO.reg.n = c(nrow(res.seminat.ANO2[res.seminat.ANO2$region=="Northern Norway" & !is.na(res.seminat.ANO2$Grazing_mowing1),]),
                                  nrow(res.seminat.ANO2[res.seminat.ANO2$region=="Central Norway" & !is.na(res.seminat.ANO2$Grazing_mowing1),]),
                                  nrow(res.seminat.ANO2[res.seminat.ANO2$region=="Eastern Norway" & !is.na(res.seminat.ANO2$Grazing_mowing1),]),
                                  nrow(res.seminat.ANO2[res.seminat.ANO2$region=="Western Norway" & !is.na(res.seminat.ANO2$Grazing_mowing1),]),
                                  nrow(res.seminat.ANO2[res.seminat.ANO2$region=="Southern Norway" & !is.na(res.seminat.ANO2$Grazing_mowing1),])
    )
  )

# and adding the values for ASO
regnor <- regnor %>%
  mutate(
    Nitrogen2.ASO.reg.mean = c(indmean.beta(df=res.seminat.ASO2[res.seminat.ASO2$region=="Northern Norway",c("Nitrogen2","Omradenummer_flatenummer")])[1],
                               indmean.beta(df=res.seminat.ASO2[res.seminat.ASO2$region=="Central Norway",c("Nitrogen2","Omradenummer_flatenummer")])[1],
                               indmean.beta(df=res.seminat.ASO2[res.seminat.ASO2$region=="Eastern Norway",c("Nitrogen2","Omradenummer_flatenummer")])[1],
                               indmean.beta(df=res.seminat.ASO2[res.seminat.ASO2$region=="Western Norway",c("Nitrogen2","Omradenummer_flatenummer")])[1],
                               indmean.beta(df=res.seminat.ASO2[res.seminat.ASO2$region=="Southern Norway",c("Nitrogen2","Omradenummer_flatenummer")])[1]
    ),
    Nitrogen2.ASO.reg.se = c(indmean.beta(df=res.seminat.ASO2[res.seminat.ASO2$region=="Northern Norway",c("Nitrogen2","Omradenummer_flatenummer")])[2],
                             indmean.beta(df=res.seminat.ASO2[res.seminat.ASO2$region=="Central Norway",c("Nitrogen2","Omradenummer_flatenummer")])[2],
                             indmean.beta(df=res.seminat.ASO2[res.seminat.ASO2$region=="Eastern Norway",c("Nitrogen2","Omradenummer_flatenummer")])[2],
                             indmean.beta(df=res.seminat.ASO2[res.seminat.ASO2$region=="Western Norway",c("Nitrogen2","Omradenummer_flatenummer")])[2],
                             indmean.beta(df=res.seminat.ASO2[res.seminat.ASO2$region=="Southern Norway",c("Nitrogen2","Omradenummer_flatenummer")])[2]
    ),
    Nitrogen2.ASO.reg.n = c(nrow(res.seminat.ASO2[res.seminat.ASO2$region=="Northern Norway" & !is.na(res.seminat.ASO2$Nitrogen2),]),
                            nrow(res.seminat.ASO2[res.seminat.ASO2$region=="Central Norway" & !is.na(res.seminat.ASO2$Nitrogen2),]),
                            nrow(res.seminat.ASO2[res.seminat.ASO2$region=="Eastern Norway" & !is.na(res.seminat.ASO2$Nitrogen2),]),
                            nrow(res.seminat.ASO2[res.seminat.ASO2$region=="Western Norway" & !is.na(res.seminat.ASO2$Nitrogen2),]),
                            nrow(res.seminat.ASO2[res.seminat.ASO2$region=="Southern Norway" & !is.na(res.seminat.ASO2$Nitrogen2),]))
  )

# Grazing_mowing1 (lower indicator), mean
tm_shape(regnor) +
  tm_polygons(col="Grazing_mowing1.ANO.reg.mean", title="Grazing_mowing (lower), mean", style="quantile", palette=rev(get_brewer_pal(palette="OrRd", n=5, plot=FALSE))) +
  tm_text("Grazing_mowing1.ANO.reg.n",col="black",bg.color="grey")

# Grazing_mowing1 (lower indicator), se
tm_shape(regnor) +
  tm_polygons(col="Grazing_mowing1.ANO.reg.se", title="Grazing_mowing (lower)", style="quantile", palette=(get_brewer_pal(palette="OrRd", n=5, plot=FALSE))) +
  tm_text("Grazing_mowing1.ANO.reg.n",col="black",bg.color="grey")

#ASO
# Nitrogen2 (upper indicator), mean
tm_shape(regnor) +
  tm_polygons(col="Nitrogen2.ASO.reg.mean", title="Nitrogen (upper)", style="quantile", palette=rev(get_brewer_pal(palette="OrRd", n=5, plot=FALSE))) +
  tm_text("Nitrogen2.ASO.reg.n",col="black",bg.color="grey")
# Nitrogen2 (lower indicator), se
tm_shape(regnor) +
  tm_polygons(col="Nitrogen2.ASO.reg.se", title="Nitrogen (upper)", style="quantile", palette=(get_brewer_pal(palette="OrRd", n=5, plot=FALSE))) +
  tm_text("Nitrogen2.ASO.reg.n",col="black",bg.color="grey")





#### how many observations are there? ####
# total ANO
length(unique(ANO.geo$ano_flate_id))
length(unique(ANO.geo$ano_punkt_id))
# total seminat
length(unique(res.seminat.ANO2$ano_flate_id))
length(unique(res.seminat.ANO2$ano_punkt_id))
# by region
length(unique(res.seminat.ANO2$ano_flate_id[!is.na(res.seminat.ANO2$region) & res.seminat.ANO2$region=="Northern Norway"]))
length(unique(res.seminat.ANO2$ano_flate_id[!is.na(res.seminat.ANO2$region) & res.seminat.ANO2$region=="Central Norway"]))
length(unique(res.seminat.ANO2$ano_flate_id[!is.na(res.seminat.ANO2$region) & res.seminat.ANO2$region=="Eastern Norway"]))
length(unique(res.seminat.ANO2$ano_flate_id[!is.na(res.seminat.ANO2$region) & res.seminat.ANO2$region=="Western Norway"]))
length(unique(res.seminat.ANO2$ano_flate_id[!is.na(res.seminat.ANO2$region) & res.seminat.ANO2$region=="Southern Norway"]))

length(unique(res.seminat.ANO2$ano_punkt_id[!is.na(res.seminat.ANO2$region) & res.seminat.ANO2$region=="Northern Norway"]))
length(unique(res.seminat.ANO2$ano_punkt_id[!is.na(res.seminat.ANO2$region) & res.seminat.ANO2$region=="Central Norway"]))
length(unique(res.seminat.ANO2$ano_punkt_id[!is.na(res.seminat.ANO2$region) & res.seminat.ANO2$region=="Eastern Norway"]))
length(unique(res.seminat.ANO2$ano_punkt_id[!is.na(res.seminat.ANO2$region) & res.seminat.ANO2$region=="Western Norway"]))
length(unique(res.seminat.ANO2$ano_punkt_id[!is.na(res.seminat.ANO2$region) & res.seminat.ANO2$region=="Southern Norway"]))

# total ASO
nrow(res.seminat.ASO2)
length(unique(res.seminat.ASO2$Omradenummer_flatenummer))
length(unique(res.seminat.ASO2$Eng_ID))
length(unique(res.seminat.ASO2$ASO_ID))
# by region
length(unique(res.seminat.ASO2$ASO_ID[!is.na(res.seminat.ASO2$region) & res.seminat.ASO2$region=="Northern Norway"]))
length(unique(res.seminat.ASO2$ASO_ID[!is.na(res.seminat.ASO2$region) & res.seminat.ASO2$region=="Central Norway"]))
length(unique(res.seminat.ASO2$ASO_ID[!is.na(res.seminat.ASO2$region) & res.seminat.ASO2$region=="Eastern Norway"]))
length(unique(res.seminat.ASO2$ASO_ID[!is.na(res.seminat.ASO2$region) & res.seminat.ASO2$region=="Western Norway"]))
length(unique(res.seminat.ASO2$ASO_ID[!is.na(res.seminat.ASO2$region) & res.seminat.ASO2$region=="Southern Norway"]))

length(unique(res.seminat.ASO2$ASO_ID[is.na(res.seminat.ASO2$region)]))




#### distribution comparison, reference vs. field data ####
summary(res.seminat.ANO$kartleggingsenhet_1m2)
length(unique(res.seminat.ANO$kartleggingsenhet_1m2))
# 19 NiN-types, of which T41-C-1 has 0 observations, and T32 & T34 as main types don't have a reference -> so, 16 NiN-Types to plot
colnames(seminat.ref.cov[['Light']])

### Light
x11()
par(mfrow=c(4,4))
## T32s
# T32-C-1
plot(density( as.matrix(seminat.ref.cov[['Light']][,"T32-C1C2"]) ,na.rm=T),
     xlim=c(1,7), type="l", main='T32-C1',xlab='Light value')
points(density(res.seminat.ANO[res.seminat.ANO$fp_ind=="Light1" & res.seminat.ANO$fp_ind=="Light1" & res.seminat.ANO$kartleggingsenhet_1m2=="T32-C-1",]$original,na.rm=T),
       type="l", col="red")
points(res.seminat.ANO[res.seminat.ANO$fp_ind=="Light1" & res.seminat.ANO$fp_ind=="Light1" & res.seminat.ANO$kartleggingsenhet_1m2=="T32-C-1",]$original,
       rep(0,length(res.seminat.ANO[res.seminat.ANO$fp_ind=="Light1" & res.seminat.ANO$fp_ind=="Light1" & res.seminat.ANO$kartleggingsenhet_1m2=="T32-C-1",]$original)),
       col="red")

# T32-C-2
plot(density( as.matrix(seminat.ref.cov[['Light']][,"T32-C1C2"]) ,na.rm=T),
     xlim=c(1,7), type="l", main='T32-C2',xlab='Light value')
points(density(res.seminat.ANO[res.seminat.ANO$fp_ind=="Light1" & res.seminat.ANO$kartleggingsenhet_1m2=="T32-C-2",]$original,na.rm=T),
       type="l", col="red")
points(res.seminat.ANO[res.seminat.ANO$fp_ind=="Light1" & res.seminat.ANO$kartleggingsenhet_1m2=="T32-C-2",]$original,
       rep(0,length(res.seminat.ANO[res.seminat.ANO$fp_ind=="Light1" & res.seminat.ANO$kartleggingsenhet_1m2=="T32-C-2",]$original)),
       col="red")

# T32-C-3
plot(density( as.matrix(seminat.ref.cov[['Light']][,"T32-C3C4"]) ,na.rm=T),
     xlim=c(1,7), type="l", main='T32-C3',xlab='Light value')
points(density(res.seminat.ANO[res.seminat.ANO$fp_ind=="Light1" & res.seminat.ANO$kartleggingsenhet_1m2=="T32-C-3",]$original,na.rm=T),
       type="l", col="red")
points(res.seminat.ANO[res.seminat.ANO$fp_ind=="Light1" & res.seminat.ANO$kartleggingsenhet_1m2=="T32-C-3",]$original,
       rep(0,length(res.seminat.ANO[res.seminat.ANO$fp_ind=="Light1" & res.seminat.ANO$kartleggingsenhet_1m2=="T32-C-3",]$original)),
       col="red")

# T32-C-4
plot(density( as.matrix(seminat.ref.cov[['Light']][,"T32-C3C4"]) ,na.rm=T),
     xlim=c(1,7), type="l", main='T32-C4',xlab='Light value')
points(density(res.seminat.ANO[res.seminat.ANO$fp_ind=="Light1" & res.seminat.ANO$kartleggingsenhet_1m2=="T32-C-4",]$original,na.rm=T),
       type="l", col="red")
points(res.seminat.ANO[res.seminat.ANO$fp_ind=="Light1" & res.seminat.ANO$kartleggingsenhet_1m2=="T32-C-4",]$original,
       rep(0,length(res.seminat.ANO[res.seminat.ANO$fp_ind=="Light1" & res.seminat.ANO$kartleggingsenhet_1m2=="T32-C-4",]$original)),
       col="red")

# T32-C-5
plot(density( as.matrix(seminat.ref.cov[['Light']][,c("T32-C5C20a","T32-C5C20b")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='T32-C5',xlab='Light value')
points(density(res.seminat.ANO[res.seminat.ANO$fp_ind=="Light1" & res.seminat.ANO$kartleggingsenhet_1m2=="T32-C-5",]$original,na.rm=T),
       type="l", col="red")
points(res.seminat.ANO[res.seminat.ANO$fp_ind=="Light1" & res.seminat.ANO$kartleggingsenhet_1m2=="T32-C-5",]$original,
       rep(0,length(res.seminat.ANO[res.seminat.ANO$fp_ind=="Light1" & res.seminat.ANO$kartleggingsenhet_1m2=="T32-C-5",]$original)),
       col="red")

# T32-C-6
plot(density( as.matrix(seminat.ref.cov[['Light']][,c("T32-C21C6a","T32-C21C6b")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='T32-C6',xlab='Light value')
points(density(res.seminat.ANO[res.seminat.ANO$fp_ind=="Light1" & res.seminat.ANO$kartleggingsenhet_1m2=="T32-C-6",]$original,na.rm=T),
       type="l", col="red")
points(res.seminat.ANO[res.seminat.ANO$fp_ind=="Light1" & res.seminat.ANO$kartleggingsenhet_1m2=="T32-C-6",]$original,
       rep(0,length(res.seminat.ANO[res.seminat.ANO$fp_ind=="Light1" & res.seminat.ANO$kartleggingsenhet_1m2=="T32-C-6",]$original)),
       col="red")

# T32-C-9
plot(density( as.matrix(seminat.ref.cov[['Light']][,c("T32-C9a","T32-C9b")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='T32-C9',xlab='Light value')
points(density(res.seminat.ANO[res.seminat.ANO$fp_ind=="Light1" & res.seminat.ANO$kartleggingsenhet_1m2=="T32-C-9",]$original,na.rm=T),
       type="l", col="red")
points(res.seminat.ANO[res.seminat.ANO$fp_ind=="Light1" & res.seminat.ANO$kartleggingsenhet_1m2=="T32-C-9",]$original,
       rep(0,length(res.seminat.ANO[res.seminat.ANO$fp_ind=="Light1" & res.seminat.ANO$kartleggingsenhet_1m2=="T32-C-9",]$original)),
       col="red")

# T32-C-10
plot(density( as.matrix(seminat.ref.cov[['Light']][,c("T32-C10a","T32-C10b")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='T32-C10',xlab='Light value')
points(density(res.seminat.ANO[res.seminat.ANO$fp_ind=="Light1" & res.seminat.ANO$kartleggingsenhet_1m2=="T32-C-10",]$original,na.rm=T),
       type="l", col="red")
points(res.seminat.ANO[res.seminat.ANO$fp_ind=="Light1" & res.seminat.ANO$kartleggingsenhet_1m2=="T32-C-10",]$original,
       rep(0,length(res.seminat.ANO[res.seminat.ANO$fp_ind=="Light1" & res.seminat.ANO$kartleggingsenhet_1m2=="T32-C-10",]$original)),
       col="red")

# T32-C-15
plot(density( as.matrix(seminat.ref.cov[['Light']][,c("T32-C15")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='T32-C15',xlab='Light value')
#points(density(res.seminat.ANO[res.seminat.ANO$fp_ind=="Light1" & res.seminat.ANO$kartleggingsenhet_1m2=="T32-C-15",]$original,na.rm=T),
#       type="l", col="red")
points(res.seminat.ANO[res.seminat.ANO$fp_ind=="Light1" & res.seminat.ANO$kartleggingsenhet_1m2=="T32-C-15",]$original,
       rep(0,length(res.seminat.ANO[res.seminat.ANO$fp_ind=="Light1" & res.seminat.ANO$kartleggingsenhet_1m2=="T32-C-15",]$original)),
       col="red")

# T32-C-20
plot(density( as.matrix(seminat.ref.cov[['Light']][,c("T32-C5C20a","T32-C5C20b")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='T32-C20',xlab='Light value')
points(density(res.seminat.ANO[res.seminat.ANO$fp_ind=="Light1" & res.seminat.ANO$kartleggingsenhet_1m2=="T32-C-20",]$original,na.rm=T),
       type="l", col="red")
points(res.seminat.ANO[res.seminat.ANO$fp_ind=="Light1" & res.seminat.ANO$kartleggingsenhet_1m2=="T32-C-20",]$original,
       rep(0,length(res.seminat.ANO[res.seminat.ANO$fp_ind=="Light1" & res.seminat.ANO$kartleggingsenhet_1m2=="T32-C-20",]$original)),
       col="red")


## V10s
# V10-C-1
plot(density( as.matrix(seminat.ref.cov[['Light']][,"V10-C1C2"]) ,na.rm=T),
     xlim=c(1,7), type="l", main='V10-C1',xlab='Light value')
points(density(res.seminat.ANO[res.seminat.ANO$fp_ind=="Light1" & res.seminat.ANO$kartleggingsenhet_1m2=="V10-C-1",]$original,na.rm=T),
       type="l", col="red")
points(res.seminat.ANO[res.seminat.ANO$fp_ind=="Light1" & res.seminat.ANO$kartleggingsenhet_1m2=="V10-C-1",]$original,
       rep(0,length(res.seminat.ANO[res.seminat.ANO$fp_ind=="Light1" & res.seminat.ANO$kartleggingsenhet_1m2=="V10-C-1",]$original)),
       col="red")

# V10-C-3
plot(density( as.matrix(seminat.ref.cov[['Light']][,"V10-C3"]) ,na.rm=T),
     xlim=c(1,7), type="l", main='V10-C3',xlab='Light value')
#points(density(res.seminat.ANO[res.seminat.ANO$fp_ind=="Light1" & res.seminat.ANO$kartleggingsenhet_1m2=="V10-C-3",]$original,na.rm=T),
#       type="l", col="red")
points(res.seminat.ANO[res.seminat.ANO$fp_ind=="Light1" & res.seminat.ANO$kartleggingsenhet_1m2=="V10-C-3",]$original,
       rep(0,length(res.seminat.ANO[res.seminat.ANO$fp_ind=="Light1" & res.seminat.ANO$kartleggingsenhet_1m2=="V10-C-3",]$original)),
       col="red")


## T34s
# T34-C-1
plot(density( as.matrix(seminat.ref.cov[['Light']][,"T34-C1"]) ,na.rm=T),
     xlim=c(1,7), type="l", main='T34-C1',xlab='Light value')
points(density(res.seminat.ANO[res.seminat.ANO$fp_ind=="Light1" & res.seminat.ANO$kartleggingsenhet_1m2=="T34-C-1",]$original,na.rm=T),
       type="l", col="red")
points(res.seminat.ANO[res.seminat.ANO$fp_ind=="Light1" & res.seminat.ANO$kartleggingsenhet_1m2=="T34-C-1",]$original,
       rep(0,length(res.seminat.ANO[res.seminat.ANO$fp_ind=="Light1" & res.seminat.ANO$kartleggingsenhet_1m2=="T34-C-1",]$original)),
       col="red")

# T34-C-2
plot(density( as.matrix(seminat.ref.cov[['Light']][,c("T34-C2a","T34-C2b","T34-C2c")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='T34-C2',xlab='Light value')
points(density(res.seminat.ANO[res.seminat.ANO$fp_ind=="Light1" & res.seminat.ANO$kartleggingsenhet_1m2=="T34-C-2",]$original,na.rm=T),
       type="l", col="red")
points(res.seminat.ANO[res.seminat.ANO$fp_ind=="Light1" & res.seminat.ANO$kartleggingsenhet_1m2=="T34-C-2",]$original,
       rep(0,length(res.seminat.ANO[res.seminat.ANO$fp_ind=="Light1" & res.seminat.ANO$kartleggingsenhet_1m2=="T34-C-2",]$original)),
       col="red")

# T34-C-4
plot(density( as.matrix(seminat.ref.cov[['Light']][,c("T34-C4a","T34-C4b","T34-C4c","T34-C4d")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='T34-C4',xlab='Light value')
#points(density(res.seminat.ANO[res.seminat.ANO$fp_ind=="Light1" & res.seminat.ANO$kartleggingsenhet_1m2=="T34-C-4",]$original,na.rm=T),
#       type="l", col="red")
points(res.seminat.ANO[res.seminat.ANO$fp_ind=="Light1" & res.seminat.ANO$kartleggingsenhet_1m2=="T34-C-4",]$original,
       rep(0,length(res.seminat.ANO[res.seminat.ANO$fp_ind=="Light1" & res.seminat.ANO$kartleggingsenhet_1m2=="T34-C-4",]$original)),
       col="red")


## T41
plot(density( as.matrix(seminat.ref.cov[['Light']][,c("T41a","T41b")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='T41',xlab='Light value')
points(density(res.seminat.ANO[res.seminat.ANO$fp_ind=="Light1" & res.seminat.ANO$kartleggingsenhet_1m2=="T41",]$original,na.rm=T),
       type="l", col="red")
points(res.seminat.ANO[res.seminat.ANO$fp_ind=="Light1" & res.seminat.ANO$kartleggingsenhet_1m2=="T41",]$original,
       rep(0,length(res.seminat.ANO[res.seminat.ANO$fp_ind=="Light1" & res.seminat.ANO$kartleggingsenhet_1m2=="T41",]$original)),
       col="red")
legend("topleft", legend=c("reference","field data"), pch=c(NULL,1), lty=1, col=c("black","red"))



### Grazing_mowing
x11()
par(mfrow=c(4,4))
## T32s
# T32-C-1
plot(density( as.matrix(seminat.ref.cov[['Grazing_mowing']][,"T32-C1C2"]) ,na.rm=T),
     xlim=c(1,8), type="l", main='T32-C1',xlab='Grazing_mowing value')
points(density(res.seminat.ANO[res.seminat.ANO$fp_ind=="Grazing_mowing1" & res.seminat.ANO$fp_ind=="Grazing_mowing1" & res.seminat.ANO$kartleggingsenhet_1m2=="T32-C-1",]$original,na.rm=T),
       type="l", col="red")
points(res.seminat.ANO[res.seminat.ANO$fp_ind=="Grazing_mowing1" & res.seminat.ANO$fp_ind=="Grazing_mowing1" & res.seminat.ANO$kartleggingsenhet_1m2=="T32-C-1",]$original,
       rep(0,length(res.seminat.ANO[res.seminat.ANO$fp_ind=="Grazing_mowing1" & res.seminat.ANO$fp_ind=="Grazing_mowing1" & res.seminat.ANO$kartleggingsenhet_1m2=="T32-C-1",]$original)),
       col="red")

# T32-C-2
plot(density( as.matrix(seminat.ref.cov[['Grazing_mowing']][,"T32-C1C2"]) ,na.rm=T),
     xlim=c(1,8), type="l", main='T32-C2',xlab='Grazing_mowing value')
points(density(res.seminat.ANO[res.seminat.ANO$fp_ind=="Grazing_mowing1" & res.seminat.ANO$kartleggingsenhet_1m2=="T32-C-2",]$original,na.rm=T),
       type="l", col="red")
points(res.seminat.ANO[res.seminat.ANO$fp_ind=="Grazing_mowing1" & res.seminat.ANO$kartleggingsenhet_1m2=="T32-C-2",]$original,
       rep(0,length(res.seminat.ANO[res.seminat.ANO$fp_ind=="Grazing_mowing1" & res.seminat.ANO$kartleggingsenhet_1m2=="T32-C-2",]$original)),
       col="red")

# T32-C-3
plot(density( as.matrix(seminat.ref.cov[['Grazing_mowing']][,"T32-C3C4"]) ,na.rm=T),
     xlim=c(1,8), type="l", main='T32-C3',xlab='Grazing_mowing value')
points(density(res.seminat.ANO[res.seminat.ANO$fp_ind=="Grazing_mowing1" & res.seminat.ANO$kartleggingsenhet_1m2=="T32-C-3",]$original,na.rm=T),
       type="l", col="red")
points(res.seminat.ANO[res.seminat.ANO$fp_ind=="Grazing_mowing1" & res.seminat.ANO$kartleggingsenhet_1m2=="T32-C-3",]$original,
       rep(0,length(res.seminat.ANO[res.seminat.ANO$fp_ind=="Grazing_mowing1" & res.seminat.ANO$kartleggingsenhet_1m2=="T32-C-3",]$original)),
       col="red")

# T32-C-4
plot(density( as.matrix(seminat.ref.cov[['Grazing_mowing']][,"T32-C3C4"]) ,na.rm=T),
     xlim=c(1,8), type="l", main='T32-C4',xlab='Grazing_mowing value')
points(density(res.seminat.ANO[res.seminat.ANO$fp_ind=="Grazing_mowing1" & res.seminat.ANO$kartleggingsenhet_1m2=="T32-C-4",]$original,na.rm=T),
       type="l", col="red")
points(res.seminat.ANO[res.seminat.ANO$fp_ind=="Grazing_mowing1" & res.seminat.ANO$kartleggingsenhet_1m2=="T32-C-4",]$original,
       rep(0,length(res.seminat.ANO[res.seminat.ANO$fp_ind=="Grazing_mowing1" & res.seminat.ANO$kartleggingsenhet_1m2=="T32-C-4",]$original)),
       col="red")

# T32-C-5
plot(density( as.matrix(seminat.ref.cov[['Grazing_mowing']][,c("T32-C5C20a","T32-C5C20b")]) ,na.rm=T),
     xlim=c(1,8), type="l", main='T32-C5',xlab='Grazing_mowing value')
points(density(res.seminat.ANO[res.seminat.ANO$fp_ind=="Grazing_mowing1" & res.seminat.ANO$kartleggingsenhet_1m2=="T32-C-5",]$original,na.rm=T),
       type="l", col="red")
points(res.seminat.ANO[res.seminat.ANO$fp_ind=="Grazing_mowing1" & res.seminat.ANO$kartleggingsenhet_1m2=="T32-C-5",]$original,
       rep(0,length(res.seminat.ANO[res.seminat.ANO$fp_ind=="Grazing_mowing1" & res.seminat.ANO$kartleggingsenhet_1m2=="T32-C-5",]$original)),
       col="red")

# T32-C-6
plot(density( as.matrix(seminat.ref.cov[['Grazing_mowing']][,c("T32-C21C6a","T32-C21C6b")]) ,na.rm=T),
     xlim=c(1,8), type="l", main='T32-C6',xlab='Grazing_mowing value')
points(density(res.seminat.ANO[res.seminat.ANO$fp_ind=="Grazing_mowing1" & res.seminat.ANO$kartleggingsenhet_1m2=="T32-C-6",]$original,na.rm=T),
       type="l", col="red")
points(res.seminat.ANO[res.seminat.ANO$fp_ind=="Grazing_mowing1" & res.seminat.ANO$kartleggingsenhet_1m2=="T32-C-6",]$original,
       rep(0,length(res.seminat.ANO[res.seminat.ANO$fp_ind=="Grazing_mowing1" & res.seminat.ANO$kartleggingsenhet_1m2=="T32-C-6",]$original)),
       col="red")

# T32-C-9
plot(density( as.matrix(seminat.ref.cov[['Grazing_mowing']][,c("T32-C9a","T32-C9b")]) ,na.rm=T),
     xlim=c(1,8), type="l", main='T32-C9',xlab='Grazing_mowing value')
points(density(res.seminat.ANO[res.seminat.ANO$fp_ind=="Grazing_mowing1" & res.seminat.ANO$kartleggingsenhet_1m2=="T32-C-9",]$original,na.rm=T),
       type="l", col="red")
points(res.seminat.ANO[res.seminat.ANO$fp_ind=="Grazing_mowing1" & res.seminat.ANO$kartleggingsenhet_1m2=="T32-C-9",]$original,
       rep(0,length(res.seminat.ANO[res.seminat.ANO$fp_ind=="Grazing_mowing1" & res.seminat.ANO$kartleggingsenhet_1m2=="T32-C-9",]$original)),
       col="red")

# T32-C-10
plot(density( as.matrix(seminat.ref.cov[['Grazing_mowing']][,c("T32-C10a","T32-C10b")]) ,na.rm=T),
     xlim=c(1,8), type="l", main='T32-C10',xlab='Grazing_mowing value')
points(density(res.seminat.ANO[res.seminat.ANO$fp_ind=="Grazing_mowing1" & res.seminat.ANO$kartleggingsenhet_1m2=="T32-C-10",]$original,na.rm=T),
       type="l", col="red")
points(res.seminat.ANO[res.seminat.ANO$fp_ind=="Grazing_mowing1" & res.seminat.ANO$kartleggingsenhet_1m2=="T32-C-10",]$original,
       rep(0,length(res.seminat.ANO[res.seminat.ANO$fp_ind=="Grazing_mowing1" & res.seminat.ANO$kartleggingsenhet_1m2=="T32-C-10",]$original)),
       col="red")

# T32-C-15
plot(density( as.matrix(seminat.ref.cov[['Grazing_mowing']][,c("T32-C15")]) ,na.rm=T),
     xlim=c(1,8), type="l", main='T32-C15',xlab='Grazing_mowing value')
#points(density(res.seminat.ANO[res.seminat.ANO$fp_ind=="Grazing_mowing1" & res.seminat.ANO$kartleggingsenhet_1m2=="T32-C-15",]$original,na.rm=T),
#       type="l", col="red")
points(res.seminat.ANO[res.seminat.ANO$fp_ind=="Grazing_mowing1" & res.seminat.ANO$kartleggingsenhet_1m2=="T32-C-15",]$original,
       rep(0,length(res.seminat.ANO[res.seminat.ANO$fp_ind=="Grazing_mowing1" & res.seminat.ANO$kartleggingsenhet_1m2=="T32-C-15",]$original)),
       col="red")

# T32-C-20
plot(density( as.matrix(seminat.ref.cov[['Grazing_mowing']][,c("T32-C5C20a","T32-C5C20b")]) ,na.rm=T),
     xlim=c(1,8), type="l", main='T32-C20',xlab='Grazing_mowing value')
points(density(res.seminat.ANO[res.seminat.ANO$fp_ind=="Grazing_mowing1" & res.seminat.ANO$kartleggingsenhet_1m2=="T32-C-20",]$original,na.rm=T),
       type="l", col="red")
points(res.seminat.ANO[res.seminat.ANO$fp_ind=="Grazing_mowing1" & res.seminat.ANO$kartleggingsenhet_1m2=="T32-C-20",]$original,
       rep(0,length(res.seminat.ANO[res.seminat.ANO$fp_ind=="Grazing_mowing1" & res.seminat.ANO$kartleggingsenhet_1m2=="T32-C-20",]$original)),
       col="red")


## V10s
# V10-C-1
plot(density( as.matrix(seminat.ref.cov[['Grazing_mowing']][,"V10-C1C2"]) ,na.rm=T),
     xlim=c(1,8), type="l", main='V10-C1',xlab='Grazing_mowing value')
points(density(res.seminat.ANO[res.seminat.ANO$fp_ind=="Grazing_mowing1" & res.seminat.ANO$kartleggingsenhet_1m2=="V10-C-1",]$original,na.rm=T),
       type="l", col="red")
points(res.seminat.ANO[res.seminat.ANO$fp_ind=="Grazing_mowing1" & res.seminat.ANO$kartleggingsenhet_1m2=="V10-C-1",]$original,
       rep(0,length(res.seminat.ANO[res.seminat.ANO$fp_ind=="Grazing_mowing1" & res.seminat.ANO$kartleggingsenhet_1m2=="V10-C-1",]$original)),
       col="red")

# V10-C-3
plot(density( as.matrix(seminat.ref.cov[['Grazing_mowing']][,"V10-C3"]) ,na.rm=T),
     xlim=c(1,8), type="l", main='V10-C3',xlab='Grazing_mowing value')
#points(density(res.seminat.ANO[res.seminat.ANO$fp_ind=="Grazing_mowing1" & res.seminat.ANO$kartleggingsenhet_1m2=="V10-C-3",]$original,na.rm=T),
#       type="l", col="red")
points(res.seminat.ANO[res.seminat.ANO$fp_ind=="Grazing_mowing1" & res.seminat.ANO$kartleggingsenhet_1m2=="V10-C-3",]$original,
       rep(0,length(res.seminat.ANO[res.seminat.ANO$fp_ind=="Grazing_mowing1" & res.seminat.ANO$kartleggingsenhet_1m2=="V10-C-3",]$original)),
       col="red")


## T34s
# T34-C-1
plot(density( as.matrix(seminat.ref.cov[['Grazing_mowing']][,"T34-C1"]) ,na.rm=T),
     xlim=c(1,8), type="l", main='T34-C1',xlab='Grazing_mowing value')
points(density(res.seminat.ANO[res.seminat.ANO$fp_ind=="Grazing_mowing1" & res.seminat.ANO$kartleggingsenhet_1m2=="T34-C-1",]$original,na.rm=T),
       type="l", col="red")
points(res.seminat.ANO[res.seminat.ANO$fp_ind=="Grazing_mowing1" & res.seminat.ANO$kartleggingsenhet_1m2=="T34-C-1",]$original,
       rep(0,length(res.seminat.ANO[res.seminat.ANO$fp_ind=="Grazing_mowing1" & res.seminat.ANO$kartleggingsenhet_1m2=="T34-C-1",]$original)),
       col="red")

# T34-C-2
plot(density( as.matrix(seminat.ref.cov[['Grazing_mowing']][,c("T34-C2a","T34-C2b","T34-C2c")]) ,na.rm=T),
     xlim=c(1,8), type="l", main='T34-C2',xlab='Grazing_mowing value')
points(density(res.seminat.ANO[res.seminat.ANO$fp_ind=="Grazing_mowing1" & res.seminat.ANO$kartleggingsenhet_1m2=="T34-C-2",]$original,na.rm=T),
       type="l", col="red")
points(res.seminat.ANO[res.seminat.ANO$fp_ind=="Grazing_mowing1" & res.seminat.ANO$kartleggingsenhet_1m2=="T34-C-2",]$original,
       rep(0,length(res.seminat.ANO[res.seminat.ANO$fp_ind=="Grazing_mowing1" & res.seminat.ANO$kartleggingsenhet_1m2=="T34-C-2",]$original)),
       col="red")

# T34-C-4
plot(density( as.matrix(seminat.ref.cov[['Grazing_mowing']][,c("T34-C4a","T34-C4b","T34-C4c","T34-C4d")]) ,na.rm=T),
     xlim=c(1,8), type="l", main='T34-C4',xlab='Grazing_mowing value')
#points(density(res.seminat.ANO[res.seminat.ANO$fp_ind=="Grazing_mowing1" & res.seminat.ANO$kartleggingsenhet_1m2=="T34-C-4",]$original,na.rm=T),
#       type="l", col="red")
points(res.seminat.ANO[res.seminat.ANO$fp_ind=="Grazing_mowing1" & res.seminat.ANO$kartleggingsenhet_1m2=="T34-C-4",]$original,
       rep(0,length(res.seminat.ANO[res.seminat.ANO$fp_ind=="Grazing_mowing1" & res.seminat.ANO$kartleggingsenhet_1m2=="T34-C-4",]$original)),
       col="red")


## T41
plot(density( as.matrix(seminat.ref.cov[['Grazing_mowing']][,c("T41a","T41b")]) ,na.rm=T),
     xlim=c(1,8), type="l", main='T41',xlab='Grazing_mowing value')
points(density(res.seminat.ANO[res.seminat.ANO$fp_ind=="Grazing_mowing1" & res.seminat.ANO$kartleggingsenhet_1m2=="T41",]$original,na.rm=T),
       type="l", col="red")
points(res.seminat.ANO[res.seminat.ANO$fp_ind=="Grazing_mowing1" & res.seminat.ANO$kartleggingsenhet_1m2=="T41",]$original,
       rep(0,length(res.seminat.ANO[res.seminat.ANO$fp_ind=="Grazing_mowing1" & res.seminat.ANO$kartleggingsenhet_1m2=="T41",]$original)),
       col="red")
legend("topleft", legend=c("reference","field data"), pch=c(NA,1), lty=1, col=c("black","red"))




## similarly for ASO, here with just Nitrogen
summary(res.seminat.ASO$NiN_grunntype)
length(levels(res.seminat.ASO$NiN_grunntype))
# 12 NiN-types, of which C-13 and C-2 have 0 observations -> so, 10 NiN-Types to plot
colnames(seminat.ref.cov[['Nitrogen']])

### Nitrogen
x11()
par(mfrow=c(3,4))
# T32-C-1
plot(density( as.matrix(seminat.ref.cov[['Nitrogen']][,"T32-C1C2"]) ,na.rm=T),
     xlim=c(1,8), type="l", main='T32-C1',xlab='Nitrogen value')
points(density(res.seminat.ASO[res.seminat.ASO$fp_ind=="Nitrogen2" & res.seminat.ASO$fp_ind=="Nitrogen2" & res.seminat.ASO$NiN_grunntype=="T32-C-1",]$original,na.rm=T),
       type="l", col="red")
points(res.seminat.ASO[res.seminat.ASO$fp_ind=="Nitrogen2" & res.seminat.ASO$fp_ind=="Nitrogen2" & res.seminat.ASO$NiN_grunntype=="T32-C-1",]$original,
       rep(0,length(res.seminat.ASO[res.seminat.ASO$fp_ind=="Nitrogen2" & res.seminat.ASO$fp_ind=="Nitrogen2" & res.seminat.ASO$NiN_grunntype=="T32-C-1",]$original)),
       col="red")

# T32-C-3
plot(density( as.matrix(seminat.ref.cov[['Nitrogen']][,"T32-C3C4"]) ,na.rm=T),
     xlim=c(1,8), type="l", main='T32-C3',xlab='Nitrogen value')
points(density(res.seminat.ASO[res.seminat.ASO$fp_ind=="Nitrogen2" & res.seminat.ASO$NiN_grunntype=="T32-C-3",]$original,na.rm=T),
       type="l", col="red")
points(res.seminat.ASO[res.seminat.ASO$fp_ind=="Nitrogen2" & res.seminat.ASO$NiN_grunntype=="T32-C-3",]$original,
       rep(0,length(res.seminat.ASO[res.seminat.ASO$fp_ind=="Nitrogen2" & res.seminat.ASO$NiN_grunntype=="T32-C-3",]$original)),
       col="red")

# T32-C-4
plot(density( as.matrix(seminat.ref.cov[['Nitrogen']][,"T32-C3C4"]) ,na.rm=T),
     xlim=c(1,8), type="l", main='T32-C4',xlab='Nitrogen value')
points(density(res.seminat.ASO[res.seminat.ASO$fp_ind=="Nitrogen2" & res.seminat.ASO$NiN_grunntype=="T32-C-4",]$original,na.rm=T),
       type="l", col="red")
points(res.seminat.ASO[res.seminat.ASO$fp_ind=="Nitrogen2" & res.seminat.ASO$NiN_grunntype=="T32-C-4",]$original,
       rep(0,length(res.seminat.ASO[res.seminat.ASO$fp_ind=="Nitrogen2" & res.seminat.ASO$NiN_grunntype=="T32-C-4",]$original)),
       col="red")

# T32-C-5
plot(density( as.matrix(seminat.ref.cov[['Nitrogen']][,c("T32-C5C20a","T32-C5C20b")]) ,na.rm=T),
     xlim=c(1,8), type="l", main='T32-C5',xlab='Nitrogen value')
points(density(res.seminat.ASO[res.seminat.ASO$fp_ind=="Nitrogen2" & res.seminat.ASO$NiN_grunntype=="T32-C-5",]$original,na.rm=T),
       type="l", col="red")
points(res.seminat.ASO[res.seminat.ASO$fp_ind=="Nitrogen2" & res.seminat.ASO$NiN_grunntype=="T32-C-5",]$original,
       rep(0,length(res.seminat.ASO[res.seminat.ASO$fp_ind=="Nitrogen2" & res.seminat.ASO$NiN_grunntype=="T32-C-5",]$original)),
       col="red")

# T32-C-6
plot(density( as.matrix(seminat.ref.cov[['Nitrogen']][,c("T32-C21C6a","T32-C21C6b")]) ,na.rm=T),
     xlim=c(1,8), type="l", main='T32-C6',xlab='Nitrogen value')
points(density(res.seminat.ASO[res.seminat.ASO$fp_ind=="Nitrogen2" & res.seminat.ASO$NiN_grunntype=="T32-C-6",]$original,na.rm=T),
       type="l", col="red")
points(res.seminat.ASO[res.seminat.ASO$fp_ind=="Nitrogen2" & res.seminat.ASO$NiN_grunntype=="T32-C-6",]$original,
       rep(0,length(res.seminat.ASO[res.seminat.ASO$fp_ind=="Nitrogen2" & res.seminat.ASO$NiN_grunntype=="T32-C-6",]$original)),
       col="red")

# T32-C-7
plot(density( as.matrix(seminat.ref.cov[['Nitrogen']][,c("T32-C7C8")]) ,na.rm=T),
     xlim=c(1,8), type="l", main='T32-C7',xlab='Nitrogen value')
#points(density(res.seminat.ASO[res.seminat.ASO$fp_ind=="Nitrogen2" & res.seminat.ASO$NiN_grunntype=="T32-C-7",]$original,na.rm=T),
#       type="l", col="red")
points(res.seminat.ASO[res.seminat.ASO$fp_ind=="Nitrogen2" & res.seminat.ASO$NiN_grunntype=="T32-C-7",]$original,
       rep(0,length(res.seminat.ASO[res.seminat.ASO$fp_ind=="Nitrogen2" & res.seminat.ASO$NiN_grunntype=="T32-C-7",]$original)),
       col="red")

# T32-C-8
plot(density( as.matrix(seminat.ref.cov[['Nitrogen']][,c("T32-C7C8")]) ,na.rm=T),
     xlim=c(1,8), type="l", main='T32-C8',xlab='Nitrogen value')
points(density(res.seminat.ASO[res.seminat.ASO$fp_ind=="Nitrogen2" & res.seminat.ASO$NiN_grunntype=="T32-C-8",]$original,na.rm=T),
       type="l", col="red")
points(res.seminat.ASO[res.seminat.ASO$fp_ind=="Nitrogen2" & res.seminat.ASO$NiN_grunntype=="T32-C-8",]$original,
       rep(0,length(res.seminat.ASO[res.seminat.ASO$fp_ind=="Nitrogen2" & res.seminat.ASO$NiN_grunntype=="T32-C-8",]$original)),
       col="red")

# T32-C-9
plot(density( as.matrix(seminat.ref.cov[['Nitrogen']][,c("T32-C9a","T32-C9b")]) ,na.rm=T),
     xlim=c(1,8), type="l", main='T32-C9',xlab='Nitrogen value')
#points(density(res.seminat.ASO[res.seminat.ASO$fp_ind=="Nitrogen2" & res.seminat.ASO$NiN_grunntype=="T32-C-9",]$original,na.rm=T),
#       type="l", col="red")
points(res.seminat.ASO[res.seminat.ASO$fp_ind=="Nitrogen2" & res.seminat.ASO$NiN_grunntype=="T32-C-9",]$original,
       rep(0,length(res.seminat.ASO[res.seminat.ASO$fp_ind=="Nitrogen2" & res.seminat.ASO$NiN_grunntype=="T32-C-9",]$original)),
       col="red")

# T32-C-10
plot(density( as.matrix(seminat.ref.cov[['Nitrogen']][,c("T32-C10a","T32-C10b")]) ,na.rm=T),
     xlim=c(1,8), type="l", main='T32-C10',xlab='Nitrogen value')
#points(density(res.seminat.ASO[res.seminat.ASO$fp_ind=="Nitrogen2" & res.seminat.ASO$NiN_grunntype=="T32-C-10",]$original,na.rm=T),
#       type="l", col="red")
points(res.seminat.ASO[res.seminat.ASO$fp_ind=="Nitrogen2" & res.seminat.ASO$NiN_grunntype=="T32-C-10",]$original,
       rep(0,length(res.seminat.ASO[res.seminat.ASO$fp_ind=="Nitrogen2" & res.seminat.ASO$NiN_grunntype=="T32-C-10",]$original)),
       col="red")


# T32-C-20
plot(density( as.matrix(seminat.ref.cov[['Nitrogen']][,c("T32-C5C20a","T32-C5C20b")]) ,na.rm=T),
     xlim=c(1,8), type="l", main='T32-C20',xlab='Nitrogen value')
points(density(res.seminat.ASO[res.seminat.ASO$fp_ind=="Nitrogen2" & res.seminat.ASO$NiN_grunntype=="T32-C-20",]$original,na.rm=T),
       type="l", col="red")
points(res.seminat.ASO[res.seminat.ASO$fp_ind=="Nitrogen2" & res.seminat.ASO$NiN_grunntype=="T32-C-20",]$original,
       rep(0,length(res.seminat.ASO[res.seminat.ASO$fp_ind=="Nitrogen2" & res.seminat.ASO$NiN_grunntype=="T32-C-20",]$original)),
       col="red")

plot.new()

legend("topleft", legend=c("reference","field data"), pch=c(NA,1), lty=1, col=c("black","red"))


#### relating scaled values to NiN condition variables ####
ggplot(res.seminat.ANO, aes(x=bruksintensitet, y=scaled_value)) +
  geom_point() +
  facet_wrap(~fp_ind, scale="fixed")

ggplot(res.seminat.ASO, aes(x=bruksintensitet, y=scaled_value)) +
  geom_point() +
  facet_wrap(~fp_ind, scale="fixed")