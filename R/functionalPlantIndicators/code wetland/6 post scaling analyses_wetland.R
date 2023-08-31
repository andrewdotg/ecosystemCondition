#### getting all the data from previous scripts in ####
load("P:/41201785_okologisk_tilstand_2022_2023/data/FPI_output large files for markdown/data_wetland.RData")
load("P:/41201785_okologisk_tilstand_2022_2023/data/FPI_output large files for markdown/ref_lists_wetland.RData")
load("P:/41201785_okologisk_tilstand_2022_2023/data/FPI_output large files for markdown/results.wetland.RData")



#### plotting scaled values by main ecosystem type ####
## continuing with 2-sided
res.wetland <- results.wetland[['2-sided']]

# make long version of the scaled value part
res.wetland <-
  res.wetland %>% 
  pivot_longer(
    cols = c("Light1","Light2","Moist1","Moist2","pH1","pH2","Nitrogen1","Nitrogen2"),
    names_to = "fp_ind",
    values_to = "scaled_value",
    values_drop_na = FALSE
  )

# add original values as well
res.wetland <- 
  res.wetland %>% add_column(original = results.wetland[['original']] %>% 
                               pivot_longer(
                                 cols = c("Light1","Light2","Moist1","Moist2","pH1","pH2","Nitrogen1","Nitrogen2"),
                                 names_to = NULL,
                                 values_to = "original",
                                 values_drop_na = FALSE
                               ) %>%
                               pull(original)
  )

res.wetland <- res.wetland[!is.na(res.wetland$scaled_value) | !is.na(res.wetland$original),]



# making the plot
ggplot(res.wetland[!is.na(res.wetland$scaled_value),], aes(x=factor(hovedtype_rute), y=scaled_value, fill=fp_ind)) + 
  geom_hline(yintercept=0.6, linetype="dashed") + 
  geom_violin() +
#  geom_boxplot(width=0.2, color="grey") +
  geom_point(size=0.7, shape=16, color="grey") +
  facet_wrap(~factor(fp_ind,levels=c("Light1","Moist1","pH1","Nitrogen1","Light2","Moist2","pH2","Nitrogen2")), ncol = 4) + 
  xlab("Main ecosystem type") + 
  ylab("Scaled indicator value") 


# making the plot for V2 only
ggplot(res.wetland[res.wetland$hovedtype_rute=="V2",], aes(x=factor(kartleggingsenhet_1m2), y=scaled_value, fill=fp_ind)) + 
  geom_hline(yintercept=0.6, linetype="dashed") + 
  geom_violin() +
  #  geom_boxplot(width=0.2, color="grey") +
  geom_point(size=0.7, shape=16, color="grey") +
  facet_wrap(~factor(fp_ind,levels=c("Light1","Moist1","pH1","Nitrogen1","Light2","Moist2","pH2","Nitrogen2")), ncol = 4) + 
  xlab("Main ecosystem type") + 
  ylab("Scaled indicator value") 



#### scaled value maps ####
# keep wide format and add geometry again
res.wetland2 <- results.wetland[['2-sided']]
st_geometry(res.wetland2) <- st_geometry(ANO.wetland)

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

# pH1 (lower indicator)
tm_shape(regnor) +
  tm_fill('GID_0', labels="", title="", legend.show = FALSE) + 
  tm_borders() +
  tm_shape(res.wetland2) +
  tm_dots('pH1',midpoint=NA, palette=tmaptools::get_brewer_pal("YlOrRd", 7, plot = FALSE), scale=1, legend.show = FALSE) + # 
  tm_layout(main.title = "pH (lower), wetland",legend.position = c("right", "bottom"), main.title.size=1.2) + 
  tm_add_legend(type = "fill", 
                col = c(tmaptools::get_brewer_pal("YlOrRd", 5, plot = FALSE),'grey'),
                labels = c("0.0 - 0.2", "0.2 - 0.4", "0.4 - 0.6", 
                           "0.6 - 0.8", "0.8 - 1.0", "NA"),
                title = "index values")



# Moist1 (lower indicator)
tm_shape(regnor) +
  tm_fill('GID_0', labels="", title="", legend.show = FALSE) + 
  tm_borders() +
  tm_shape(res.wetland2) +
  tm_dots('Moist1',midpoint=NA, palette=tmaptools::get_brewer_pal("YlOrRd", 7, plot = FALSE), scale=1, legend.show = FALSE) + # 
  tm_layout(main.title = "Moisture index (lower), wetland",legend.position = c("right", "bottom"), main.title.size=1.2) + 
  tm_add_legend(type = "fill", 
                col = c(tmaptools::get_brewer_pal("YlOrRd", 6, plot = FALSE),'grey'),
                labels = c("0.4 - 0.5", "0.5 - 0.6", "0.6 - 0.7", 
                           "0.7 - 0.8", "0.8 - 0.9", "0.9 - 1.0", "NA"),
                title = "index values")

# Moist2 (upper indicator)
tm_shape(regnor) +
  tm_fill('GID_0', labels="", title="", legend.show = FALSE) + 
  tm_borders() +
  tm_shape(res.wetland2) +
  tm_dots('Moist2',midpoint=NA, palette=tmaptools::get_brewer_pal("YlOrRd", 7, plot = FALSE), scale=1, legend.show = FALSE) + # 
  tm_layout(main.title = "Moisture index (lower), wetland",legend.position = c("right", "bottom"), main.title.size=1.2) + 
  tm_add_legend(type = "fill", 
                col = c(tmaptools::get_brewer_pal("YlOrRd", 7, plot = FALSE),'grey'),
                labels = c("0.3 - 0.4", "0.4 - 0.5", "0.5 - 0.6", "0.6 - 0.7", 
                           "0.7 - 0.8", "0.8 - 0.9", "0.9 - 1.0", "NA"),
                title = "index values")



# let's look at things by region
res.wetland2 = st_join(res.wetland2, regnor, left = TRUE)
colnames(res.wetland2)

# simple means, not appropriate with 0-1 bound data
res.wetland2 %>% 
  group_by(as.factor(region)) %>% 
  mutate(Light1.reg.mean = mean(Light1,na.rm=T)) %>%
  mutate(Light2.reg.mean = mean(Light1,na.rm=T)) %>%
  mutate(Moist1.reg.mean = mean(Moist1,na.rm=T)) %>%
  mutate(Moist2.reg.mean = mean(Moist1,na.rm=T)) %>%
  mutate(pH1.reg.mean = mean(pH1,na.rm=T)) %>%
  mutate(pH2.reg.mean = mean(pH1,na.rm=T)) %>%
  mutate(Nitrogen1.reg.mean = mean(Nitrogen1,na.rm=T)) %>%
  mutate(Nitrogen2.reg.mean = mean(Nitrogen2,na.rm=T))
  

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



indmean.beta(df=res.wetland2[res.wetland2$region=="Northern Norway",c("pH1","ano_flate_id")])




regnor <- regnor %>%
  mutate(
    pH1.reg.mean = c(indmean.beta(df=res.wetland2[res.wetland2$region=="Northern Norway",c("pH1","ano_flate_id")])[1],
                     indmean.beta(df=res.wetland2[res.wetland2$region=="Central Norway",c("pH1","ano_flate_id")])[1],
                     indmean.beta(df=res.wetland2[res.wetland2$region=="Eastern Norway",c("pH1","ano_flate_id")])[1],
                     indmean.beta(df=res.wetland2[res.wetland2$region=="Western Norway",c("pH1","ano_flate_id")])[1],
                     indmean.beta(df=res.wetland2[res.wetland2$region=="Southern Norway",c("pH1","ano_flate_id")])[1]
    ),
    pH1.reg.se = c(indmean.beta(df=res.wetland2[res.wetland2$region=="Northern Norway",c("pH1","ano_flate_id")])[2],
                   indmean.beta(df=res.wetland2[res.wetland2$region=="Central Norway",c("pH1","ano_flate_id")])[2],
                   indmean.beta(df=res.wetland2[res.wetland2$region=="Eastern Norway",c("pH1","ano_flate_id")])[2],
                   indmean.beta(df=res.wetland2[res.wetland2$region=="Western Norway",c("pH1","ano_flate_id")])[2],
                   indmean.beta(df=res.wetland2[res.wetland2$region=="Southern Norway",c("pH1","ano_flate_id")])[2]
    ),
    pH1.reg.n = c(nrow(res.wetland2[res.wetland2$region=="Northern Norway" & !is.na(res.wetland2$pH1),]),
                  nrow(res.wetland2[res.wetland2$region=="Central Norway" & !is.na(res.wetland2$pH1),]),
                  nrow(res.wetland2[res.wetland2$region=="Eastern Norway" & !is.na(res.wetland2$pH1),]),
                  nrow(res.wetland2[res.wetland2$region=="Western Norway" & !is.na(res.wetland2$pH1),]),
                  nrow(res.wetland2[res.wetland2$region=="Southern Norway" & !is.na(res.wetland2$pH1),])
    )
  )


tm_shape(regnor) +
  tm_polygons(col="pH1.reg.mean", title="pH (lower), mean", style="quantile", palette=rev(get_brewer_pal(palette="OrRd", n=5, plot=FALSE))) +
  tm_text("pH1.reg.n",col="black",bg.color="grey")

tm_shape(regnor) +
  tm_polygons(col="pH1.reg.se", title="pH (lower), se", style="quantile", palette=(get_brewer_pal(palette="OrRd", n=5, plot=FALSE))) +
  tm_text("pH1.reg.n",col="black",bg.color="grey")







#### how many observations are there? ####
# total ANO
length(unique(ANO.geo$ano_flate_id))
length(unique(ANO.geo$ano_punkt_id))
# total wetland
length(unique(res.wetland2$ano_flate_id))
length(unique(res.wetland2$ano_punkt_id))
# by region
length(unique(res.wetland2$ano_flate_id[res.wetland2$region=="Northern Norway"]))
length(unique(res.wetland2$ano_flate_id[res.wetland2$region=="Central Norway"]))
length(unique(res.wetland2$ano_flate_id[res.wetland2$region=="Eastern Norway"]))
length(unique(res.wetland2$ano_flate_id[res.wetland2$region=="Western Norway"]))
length(unique(res.wetland2$ano_flate_id[res.wetland2$region=="Southern Norway"]))

length(unique(res.wetland2$ano_punkt_id[res.wetland2$region=="Northern Norway"]))
length(unique(res.wetland2$ano_punkt_id[res.wetland2$region=="Central Norway"]))
length(unique(res.wetland2$ano_punkt_id[res.wetland2$region=="Eastern Norway"]))
length(unique(res.wetland2$ano_punkt_id[res.wetland2$region=="Western Norway"]))
length(unique(res.wetland2$ano_punkt_id[res.wetland2$region=="Southern Norway"]))



#### distribution comparison, reference vs. data ####

summary(res.wetland$kartleggingsenhet_1m2)
length(unique(res.wetland$kartleggingsenhet_1m2))
# 16 NiN-types to plot
colnames(wetland.ref.cov[['Soil_reaction_pH']])

### pH
x11()
par(mfrow=c(4,4))
## V1s
# V1-C-1
plot(density( as.matrix(wetland.ref.cov[['Soil_reaction_pH']][,c("V1-C1a","V1-C1b","V1-C1c","V1-C1d","V1-C1e")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='V1-C1',xlab='pH value')
points(density(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V1-C-1",]$original,na.rm=T),
       type="l", col="red")
points(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V1-C-1",]$original,
       rep(0,length(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V1-C-1",]$original)),
       col="red")

# V1-C-2
plot(density( as.matrix(wetland.ref.cov[['Soil_reaction_pH']][,c("V1-C2a","V1-C2b","V1-C2c","V1-C2d")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='V1-C2',xlab='pH value')
points(density(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V1-C-2",]$original,na.rm=T),
       type="l", col="red")
points(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V1-C-2",]$original,
       rep(0,length(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V1-C-2",]$original)),
       col="red")

# V1-C-3
plot(density( as.matrix(wetland.ref.cov[['Soil_reaction_pH']][,c("V1-C3a","V1-C3b","V1-C3c","V1-C3d")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='V1-C3',xlab='pH value')
points(density(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V1-C-3",]$original,na.rm=T),
       type="l", col="red")
points(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V1-C-3",]$original,
       rep(0,length(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V1-C-3",]$original)),
       col="red")

# V1-C-4
plot(density( as.matrix(wetland.ref.cov[['Soil_reaction_pH']][,c("V1-C4a","V1-C4b","V1-C4c","V1-C4d","V1-C4e","V1-C4f","V1-C4g","V1-C4h")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='V1-C4',xlab='pH value')
points(density(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V1-C-4",]$original,na.rm=T),
       type="l", col="red")
points(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V1-C-4",]$original,
       rep(0,length(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V1-C-4",]$original)),
       col="red")

# V1-C-5
plot(density( as.matrix(wetland.ref.cov[['Soil_reaction_pH']][,c("V1-C5")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='V1-C5',xlab='pH value')
points(density(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V1-C-5",]$original,na.rm=T),
       type="l", col="red")
points(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V1-C-5",]$original,
       rep(0,length(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V1-C-5",]$original)),
       col="red")

# V1-C-6
plot(density( as.matrix(wetland.ref.cov[['Soil_reaction_pH']][,c("V1-C6a","V1-C6b")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='V1-C6',xlab='pH value')
points(density(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V1-C-6",]$original,na.rm=T),
       type="l", col="red")
points(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V1-C-6",]$original,
       rep(0,length(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V1-C-6",]$original)),
       col="red")

# V1-C-7
plot(density( as.matrix(wetland.ref.cov[['Soil_reaction_pH']][,c("V1-C7a","V1-C7b")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='V1-C7',xlab='pH value')
points(density(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V1-C-7",]$original,na.rm=T),
       type="l", col="red")
points(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V1-C-7",]$original,
       rep(0,length(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V1-C-7",]$original)),
       col="red")

# V1-C-8
plot(density( as.matrix(wetland.ref.cov[['Soil_reaction_pH']][,c("V1-C8a","V1-C8b")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='V1-C8',xlab='pH value')
points(density(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V1-C-8",]$original,na.rm=T),
       type="l", col="red")
points(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V1-C-8",]$original,
       rep(0,length(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V1-C-8",]$original)),
       col="red")


## V2s
# V2-C-1
plot(density( as.matrix(wetland.ref.cov[['Soil_reaction_pH']][,c("V2-C1a","V2-C1b")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='V2-C1',xlab='pH value')
points(density(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V2-C-1",]$original,na.rm=T),
       type="l", col="red")
points(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V2-C-1",]$original,
       rep(0,length(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V2-C-1",]$original)),
       col="red")

# V2-C-2
plot(density( as.matrix(wetland.ref.cov[['Soil_reaction_pH']][,c("V2-C2a","V2-C2b")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='V2-C2',xlab='pH value')
points(density(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V2-C-2",]$original,na.rm=T),
       type="l", col="red")
points(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V2-C-2",]$original,
       rep(0,length(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V2-C-2",]$original)),
       col="red")

# V2-C-3
plot(density( as.matrix(wetland.ref.cov[['Soil_reaction_pH']][,c("V2-C3a","V2-C3b")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='V2-C3',xlab='pH value')
points(density(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V2-C-3",]$original,na.rm=T),
       type="l", col="red")
points(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V2-C-3",]$original,
       rep(0,length(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V2-C-3",]$original)),
       col="red")

## V3s
# V3-C-1
plot(density( as.matrix(wetland.ref.cov[['Soil_reaction_pH']][,c("V3-C1a","V3-C1b","V3-C1c","V3-C1d","V3-C1e")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='V3-C1',xlab='pH value')
points(density(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V3-C-1",]$original,na.rm=T),
       type="l", col="red")
points(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V3-C-1",]$original,
       rep(0,length(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V3-C-1",]$original)),
       col="red")

# V3-C-2
plot(density( as.matrix(wetland.ref.cov[['Soil_reaction_pH']][,c("V3-C2")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='V3-C2',xlab='pH value')
points(density(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V3-C-2",]$original,na.rm=T),
       type="l", col="red")
points(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V3-C-2",]$original,
       rep(0,length(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V3-C-2",]$original)),
       col="red")

## V4s
# V4-C-2
plot(density( as.matrix(wetland.ref.cov[['Soil_reaction_pH']][,c("V4-C2")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='V4-C2',xlab='pH value')
points(density(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V4-C-2",]$original,na.rm=T),
       type="l", col="red")
points(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V4-C-2",]$original,
       rep(0,length(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V4-C-2",]$original)),
       col="red")

# V4-C-3
#plot(density( as.matrix(wetland.ref.cov[['Soil_reaction_pH']][,c("V4-C3")]) ,na.rm=T),
#     xlim=c(1,7), type="l", main='V4-C3',xlab='pH value')
#points(density(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V4-C-3",]$original,na.rm=T),
#       type="l", col="red")
#points(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V4-C-3",]$original,
#       rep(0,length(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V4-C-3",]$original)),
#       col="red")

## V8s
# V8-C-1
plot(density( as.matrix(wetland.ref.cov[['Soil_reaction_pH']][,c("V8-C1")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='V8-C1',xlab='pH value')
#points(density(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V8-C-1",]$original,na.rm=T),
#       type="l", col="red")
points(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V8-C-1",]$original,
       rep(0,length(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V8-C-1",]$original)),
       col="red")

# V8-C-2
plot(density( as.matrix(wetland.ref.cov[['Soil_reaction_pH']][,c("V8-C2")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='V8-C2',xlab='pH value')
#points(density(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V8-C-2",]$original,na.rm=T),
#       type="l", col="red")
points(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V8-C-2",]$original,
       rep(0,length(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V8-C-2",]$original)),
       col="red")

# V8-C-3
#plot(density( as.matrix(wetland.ref.cov[['Soil_reaction_pH']][,c("V8-C3")]) ,na.rm=T),
#     xlim=c(1,7), type="l", main='V8-C3',xlab='pH value')
#points(density(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V8-C-3",]$original,na.rm=T),
#       type="l", col="red")
#points(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V8-C-3",]$original,
#       rep(0,length(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V8-C-3",]$original)),
#       col="red")




### Nitrogen
x11()
par(mfrow=c(4,4))
## V1s
# V1-C-1
plot(density( as.matrix(wetland.ref.cov[['Nitrogen']][,c("V1-C1a","V1-C1b","V1-C1c","V1-C1d","V1-C1e")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='V1-C1',xlab='Nitrogen value')
points(density(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V1-C-1",]$original,na.rm=T),
       type="l", col="red")
points(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V1-C-1",]$original,
       rep(0,length(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V1-C-1",]$original)),
       col="red")

# V1-C-2
plot(density( as.matrix(wetland.ref.cov[['Nitrogen']][,c("V1-C2a","V1-C2b","V1-C2c","V1-C2d")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='V1-C2',xlab='Nitrogen value')
points(density(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V1-C-2",]$original,na.rm=T),
       type="l", col="red")
points(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V1-C-2",]$original,
       rep(0,length(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V1-C-2",]$original)),
       col="red")

# V1-C-3
plot(density( as.matrix(wetland.ref.cov[['Nitrogen']][,c("V1-C3a","V1-C3b","V1-C3c","V1-C3d")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='V1-C3',xlab='Nitrogen value')
points(density(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V1-C-3",]$original,na.rm=T),
       type="l", col="red")
points(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V1-C-3",]$original,
       rep(0,length(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V1-C-3",]$original)),
       col="red")

# V1-C-4
plot(density( as.matrix(wetland.ref.cov[['Nitrogen']][,c("V1-C4a","V1-C4b","V1-C4c","V1-C4d","V1-C4e","V1-C4f","V1-C4g","V1-C4h")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='V1-C4',xlab='Nitrogen value')
points(density(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V1-C-4",]$original,na.rm=T),
       type="l", col="red")
points(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V1-C-4",]$original,
       rep(0,length(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V1-C-4",]$original)),
       col="red")

# V1-C-5
plot(density( as.matrix(wetland.ref.cov[['Nitrogen']][,c("V1-C5")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='V1-C5',xlab='Nitrogen value')
points(density(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V1-C-5",]$original,na.rm=T),
       type="l", col="red")
points(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V1-C-5",]$original,
       rep(0,length(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V1-C-5",]$original)),
       col="red")

# V1-C-6
plot(density( as.matrix(wetland.ref.cov[['Nitrogen']][,c("V1-C6a","V1-C6b")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='V1-C6',xlab='Nitrogen value')
points(density(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V1-C-6",]$original,na.rm=T),
       type="l", col="red")
points(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V1-C-6",]$original,
       rep(0,length(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V1-C-6",]$original)),
       col="red")

# V1-C-7
plot(density( as.matrix(wetland.ref.cov[['Nitrogen']][,c("V1-C7a","V1-C7b")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='V1-C7',xlab='Nitrogen value')
points(density(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V1-C-7",]$original,na.rm=T),
       type="l", col="red")
points(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V1-C-7",]$original,
       rep(0,length(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V1-C-7",]$original)),
       col="red")

# V1-C-8
plot(density( as.matrix(wetland.ref.cov[['Nitrogen']][,c("V1-C8a","V1-C8b")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='V1-C8',xlab='Nitrogen value')
points(density(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V1-C-8",]$original,na.rm=T),
       type="l", col="red")
points(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V1-C-8",]$original,
       rep(0,length(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V1-C-8",]$original)),
       col="red")


## V2s
# V2-C-1
plot(density( as.matrix(wetland.ref.cov[['Nitrogen']][,c("V2-C1a","V2-C1b")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='V2-C1',xlab='Nitrogen value')
points(density(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V2-C-1",]$original,na.rm=T),
       type="l", col="red")
points(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V2-C-1",]$original,
       rep(0,length(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V2-C-1",]$original)),
       col="red")

# V2-C-2
plot(density( as.matrix(wetland.ref.cov[['Nitrogen']][,c("V2-C2a","V2-C2b")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='V2-C2',xlab='Nitrogen value')
points(density(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V2-C-2",]$original,na.rm=T),
       type="l", col="red")
points(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V2-C-2",]$original,
       rep(0,length(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V2-C-2",]$original)),
       col="red")

# V2-C-3
plot(density( as.matrix(wetland.ref.cov[['Nitrogen']][,c("V2-C3a","V2-C3b")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='V2-C3',xlab='Nitrogen value')
points(density(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V2-C-3",]$original,na.rm=T),
       type="l", col="red")
points(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V2-C-3",]$original,
       rep(0,length(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V2-C-3",]$original)),
       col="red")

## V3s
# V3-C-1
plot(density( as.matrix(wetland.ref.cov[['Nitrogen']][,c("V3-C1a","V3-C1b","V3-C1c","V3-C1d","V3-C1e")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='V3-C1',xlab='Nitrogen value')
points(density(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V3-C-1",]$original,na.rm=T),
       type="l", col="red")
points(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V3-C-1",]$original,
       rep(0,length(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V3-C-1",]$original)),
       col="red")

# V3-C-2
plot(density( as.matrix(wetland.ref.cov[['Nitrogen']][,c("V3-C2")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='V3-C2',xlab='Nitrogen value')
points(density(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V3-C-2",]$original,na.rm=T),
       type="l", col="red")
points(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V3-C-2",]$original,
       rep(0,length(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V3-C-2",]$original)),
       col="red")

## V4s
# V4-C-2
plot(density( as.matrix(wetland.ref.cov[['Nitrogen']][,c("V4-C2")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='V4-C2',xlab='Nitrogen value')
points(density(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V4-C-2",]$original,na.rm=T),
       type="l", col="red")
points(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V4-C-2",]$original,
       rep(0,length(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V4-C-2",]$original)),
       col="red")

# V4-C-3
#plot(density( as.matrix(wetland.ref.cov[['Nitrogen']][,c("V4-C3")]) ,na.rm=T),
#     xlim=c(1,7), type="l", main='V4-C3',xlab='Nitrogen value')
#points(density(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V4-C-3",]$original,na.rm=T),
#       type="l", col="red")
#points(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V4-C-3",]$original,
#       rep(0,length(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V4-C-3",]$original)),
#       col="red")

## V8s
# V8-C-1
plot(density( as.matrix(wetland.ref.cov[['Nitrogen']][,c("V8-C1")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='V8-C1',xlab='Nitrogen value')
#points(density(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V8-C-1",]$original,na.rm=T),
#       type="l", col="red")
points(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V8-C-1",]$original,
       rep(0,length(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V8-C-1",]$original)),
       col="red")

# V8-C-2
plot(density( as.matrix(wetland.ref.cov[['Nitrogen']][,c("V8-C2")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='V8-C2',xlab='Nitrogen value')
#points(density(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V8-C-2",]$original,na.rm=T),
#       type="l", col="red")
points(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V8-C-2",]$original,
       rep(0,length(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V8-C-2",]$original)),
       col="red")

# V8-C-3
#plot(density( as.matrix(wetland.ref.cov[['Nitrogen']][,c("V8-C3")]) ,na.rm=T),
#     xlim=c(1,7), type="l", main='V8-C3',xlab='Nitrogen value')
#points(density(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V8-C-3",]$original,na.rm=T),
#       type="l", col="red")
#points(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V8-C-3",]$original,
#       rep(0,length(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V8-C-3",]$original)),
#       col="red")



# ?
#The figure shows that deviations mainly occur in V2-C1, which represents limestone-poor swamp forests. According to the functional signature from the plant community composition many of the occurrences of this ecosystem type are too acidic and may have too low availability of nitrogen.



#### regressions vs. ANO variables ####


head(results.wetland[['original']])
colnames(results.wetland[['original']])[c(42:47,54:56)]

with(results.wetland[['original']],plot(tresjikt_dekning,Cont1))
with(results.wetland[['original']],plot(tresjikt_dekning,Light1))
with(results.wetland[['original']],plot(tresjikt_dekning,Moist1))
with(results.wetland[['original']],plot(tresjikt_dekning,pH1))
with(results.wetland[['original']],plot(tresjikt_dekning,Nitrogen1))

with(results.wetland[['original']],plot(groeftingsintensitet,Cont1))
with(results.wetland[['original']],plot(groeftingsintensitet,Light1))
with(results.wetland[['original']],plot(groeftingsintensitet,Moist1))
with(results.wetland[['original']],plot(groeftingsintensitet,pH1))
with(results.wetland[['original']],plot(groeftingsintensitet,Nitrogen1))

with(results.wetland[['original']],plot(slitasje,Cont1))
with(results.wetland[['original']],plot(slitasje,Light1))
with(results.wetland[['original']],plot(slitasje,Moist1))
with(results.wetland[['original']],plot(slitasje,pH1))
with(results.wetland[['original']],plot(slitasje,Nitrogen1))

df <- results.wetland[['scaled']][results.wetland[['scaled']]$hovedtype_rute!='V2',]
df <- df[df$hovedtype_rute!='V8',]
with(df,plot(tresjikt_dekning,Moist1,xlim=c(0,100)))
with(results.wetland[['scaled']][results.wetland[['scaled']]$hovedtype_rute=='V8',],points(tresjikt_dekning,Moist1,col='blue'))
with(results.wetland[['scaled']][results.wetland[['scaled']]$hovedtype_rute=='V2',],points(tresjikt_dekning,Moist1,col='blue'))
with(df,points(tresjikt_dekning,Moist1, pch=16))

summary(lm(Moist1~tresjikt_dekning, data=df ))
points(0:100,predict(lm(Moist1~tresjikt_dekning, data=df ),
                     newdata=data.frame(tresjikt_dekning=0:100) ),
       type='l', lty=2, lwd=3)


library(betareg)
summary( betareg(Moist1 ~ tresjikt_dekning, data=df[!is.na(df$Moist1),]) )

#with(results.wetland[['scaled']],plot(busker_dekning,Light1))
#summary(lm(Light1~busker_dekning, data=results.wetland[['scaled']]))
#points(0:100,predict(lm(Light1~busker_dekning, data=results.wetland[['scaled']]),
#                     newdata=data.frame(busker_dekning=0:100) ),
#       type='l', col='red', lwd=2)

#with(results.wetland[['scaled']],plot(groeftingsintensitet,Moist1))
#summary(lm(Moist1~groeftingsintensitet, data=results.wetland[['scaled']]))
#points(1:5,predict(lm(Moist1~groeftingsintensitet, data=results.wetland[['scaled']]),
#                     newdata=data.frame(groeftingsintensitet=1:5) ),
#       type='l', col='red', lwd=2)


