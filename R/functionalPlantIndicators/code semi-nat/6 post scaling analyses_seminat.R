#### plotting scaled values by main ecosystem type ####
## continuing with 2-sided
res.seminat <- results.seminat[['2-sided']]
colnames(res.seminat)

# make long version of the scaled value part
res.seminat <-
  res.seminat %>% 
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
res.seminat <- 
  res.seminat %>% add_column(original = results.seminat[['original']] %>% 
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

head(res.seminat[,70:76])


# summarizing the indicator scores
res.seminat %>%
  group_by(fp_ind) %>%
  dplyr::summarize(Mean = mean(scaled_value, na.rm=TRUE))


# making the plot
ggplot(res.seminat, aes(x=factor(hovedtype_rute), y=scaled_value, fill=fp_ind)) + 
  geom_hline(yintercept=0.6, linetype="dashed") + 
  geom_violin(color=NA) +
#  geom_boxplot(width=0.2, color="grey") +
  geom_point(size=1, shape=16, color="black") +
  facet_wrap(~factor(fp_ind,levels=c("Light1","Moist1","pH1","Nitrogen1","Phosphorus1","Grazing_mowing1","Soil_disturbance1",
                                     "Light2","Moist2","pH2","Nitrogen2","Phosphorus2","Grazing_mowing2","Soil_disturbance2")), ncol = 7) + 
  xlab("Main ecosystem type") + 
  ylab("Scaled indicator value (ANO data)") 




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


# summarizing the indicator scores
res.seminat.ASO %>%
  group_by(fp_ind) %>%
  dplyr::summarize(Mean = mean(scaled_value, na.rm=TRUE))


# making the plot
res.seminat.ASO$NiN_grunntype2 <- substring(res.seminat.ASO$NiN_grunntype,5)
ggplot(res.seminat.ASO, aes(x=factor(NiN_grunntype2), y=scaled_value, fill=fp_ind)) + 
  geom_hline(yintercept=0.6, linetype="dashed") + 
  geom_violin(color = NA) +
  #  geom_boxplot(width=0.2, color="grey") +
  geom_point(size=1, shape=16, color="black") +
  facet_wrap(~factor(fp_ind,levels=c("Light1","Moist1","pH1","Nitrogen1","Phosphorus1","Grazing_mowing1","Soil_disturbance1",
                                     "Light2","Moist2","pH2","Nitrogen2","Phosphorus2","Grazing_mowing2","Soil_disturbance2")), ncol = 7) + 
  xlab("T32 (semi-natural meadow) basic ecosystem type") + 
  ylab("Scaled indicator value (ASO data)") 












#### scaled value maps ####
# keep wide format and add geometry again
res.seminat2 <- results.seminat[['2-sided']]
st_geometry(res.seminat2) <- st_geometry(ANO.seminat)

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
  tm_shape(res.seminat2) +
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
  tm_shape(res.seminat2) +
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
  tm_shape(res.seminat2) +
  tm_dots('pH1',midpoint=NA, palette=tmaptools::get_brewer_pal("YlOrRd", 7, plot = FALSE), scale=1, legend.show = FALSE) + # 
  tm_layout(main.title = "pH index (lower), seminat",legend.position = c("right", "bottom"), main.title.size=1.2) + 
  tm_add_legend(type = "fill", 
                col = c(tmaptools::get_brewer_pal("YlOrRd", 7, plot = FALSE),'grey'),
                labels = c("0.3 - 0.4", "0.4 - 0.5", "0.5 - 0.6", "0.6 - 0.7", 
                           "0.7 - 0.8", "0.8 - 0.9", "0.9 - 1.0", "NA"),
                title = "index values")



## similarly for ASO
# keep wide format and add geometry again
res.seminat.ASO2 <- results.seminat.ASO[['2-sided']]
st_geometry(res.seminat.ASO2) <- st_geometry(ASO.geo)

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
  tm_shape(res.seminat.ASO2) +
  tm_dots('Light1',midpoint=NA, palette=tmaptools::get_brewer_pal("YlOrRd", 7, plot = FALSE), scale=1, legend.show = FALSE) + # 
  tm_layout(main.title = "Light index (lower), seminat.ASO",legend.position = c("right", "bottom"), main.title.size=1.2) + 
  tm_add_legend(type = "fill", 
                col = c(tmaptools::get_brewer_pal("YlOrRd", 5, plot = FALSE),'grey'),
                labels = c("0.0 - 0.2", "0.2 - 0.4", "0.4 - 0.6", 
                           "0.6 - 0.8", "0.8 - 1.0", "NA"),
                title = "index values")

# very few spots on the map with only 2022 data from ASO
# continue with ANO only





# let's look at things by region
res.seminat2 = st_join(res.seminat2, regnor, left = TRUE)
colnames(res.seminat2)

res.seminat2 %>% 
  group_by(as.factor(region)) %>% 
  dplyr::summarise(Light1.reg.mean = mean(Light1,na.rm=T))

res.seminat2 %>% 
  group_by(as.factor(region)) %>% 
  dplyr::summarise(Light2.reg.mean = mean(Light2,na.rm=T))
  


res.seminat2 %>% 
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
  


regnor <- regnor %>%
  mutate(Light1.reg.mean = c(mean(res.seminat2$Light1[res.seminat2$region=="Northern Norway"],na.rm=T),
                             mean(res.seminat2$Light1[res.seminat2$region=="Central Norway"],na.rm=T),
                             mean(res.seminat2$Light1[res.seminat2$region=="Eastern Norway"],na.rm=T),
                             mean(res.seminat2$Light1[res.seminat2$region=="Western Norway"],na.rm=T),
                             mean(res.seminat2$Light1[res.seminat2$region=="Southern Norway"],na.rm=T)),
         Light2.reg.mean = c(mean(res.seminat2$Light2[res.seminat2$region=="Northern Norway"],na.rm=T),
                             mean(res.seminat2$Light2[res.seminat2$region=="Central Norway"],na.rm=T),
                             mean(res.seminat2$Light2[res.seminat2$region=="Eastern Norway"],na.rm=T),
                             mean(res.seminat2$Light2[res.seminat2$region=="Western Norway"],na.rm=T),
                             mean(res.seminat2$Light2[res.seminat2$region=="Southern Norway"],na.rm=T)),
         Moist1.reg.mean = c(mean(res.seminat2$Moist1[res.seminat2$region=="Northern Norway"],na.rm=T),
                             mean(res.seminat2$Moist1[res.seminat2$region=="Central Norway"],na.rm=T),
                             mean(res.seminat2$Moist1[res.seminat2$region=="Eastern Norway"],na.rm=T),
                             mean(res.seminat2$Moist1[res.seminat2$region=="Western Norway"],na.rm=T),
                             mean(res.seminat2$Moist1[res.seminat2$region=="Southern Norway"],na.rm=T)),
         Moist2.reg.mean = c(mean(res.seminat2$Moist2[res.seminat2$region=="Northern Norway"],na.rm=T),
                             mean(res.seminat2$Moist2[res.seminat2$region=="Central Norway"],na.rm=T),
                             mean(res.seminat2$Moist2[res.seminat2$region=="Eastern Norway"],na.rm=T),
                             mean(res.seminat2$Moist2[res.seminat2$region=="Western Norway"],na.rm=T),
                             mean(res.seminat2$Moist2[res.seminat2$region=="Southern Norway"],na.rm=T)),
         pH1.reg.mean = c(mean(res.seminat2$pH1[res.seminat2$region=="Northern Norway"],na.rm=T),
                             mean(res.seminat2$pH1[res.seminat2$region=="Central Norway"],na.rm=T),
                             mean(res.seminat2$pH1[res.seminat2$region=="Eastern Norway"],na.rm=T),
                             mean(res.seminat2$pH1[res.seminat2$region=="Western Norway"],na.rm=T),
                             mean(res.seminat2$pH1[res.seminat2$region=="Southern Norway"],na.rm=T)),
         pH2.reg.mean = c(mean(res.seminat2$pH2[res.seminat2$region=="Northern Norway"],na.rm=T),
                             mean(res.seminat2$pH2[res.seminat2$region=="Central Norway"],na.rm=T),
                             mean(res.seminat2$pH2[res.seminat2$region=="Eastern Norway"],na.rm=T),
                             mean(res.seminat2$pH2[res.seminat2$region=="Western Norway"],na.rm=T),
                             mean(res.seminat2$pH2[res.seminat2$region=="Southern Norway"],na.rm=T)),
         Nitrogen1.reg.mean = c(mean(res.seminat2$Nitrogen1[res.seminat2$region=="Northern Norway"],na.rm=T),
                             mean(res.seminat2$Nitrogen1[res.seminat2$region=="Central Norway"],na.rm=T),
                             mean(res.seminat2$Nitrogen1[res.seminat2$region=="Eastern Norway"],na.rm=T),
                             mean(res.seminat2$Nitrogen1[res.seminat2$region=="Western Norway"],na.rm=T),
                             mean(res.seminat2$Nitrogen1[res.seminat2$region=="Southern Norway"],na.rm=T)),
         Nitrogen2.reg.mean = c(mean(res.seminat2$Nitrogen2[res.seminat2$region=="Northern Norway"],na.rm=T),
                             mean(res.seminat2$Nitrogen2[res.seminat2$region=="Central Norway"],na.rm=T),
                             mean(res.seminat2$Nitrogen2[res.seminat2$region=="Eastern Norway"],na.rm=T),
                             mean(res.seminat2$Nitrogen2[res.seminat2$region=="Western Norway"],na.rm=T),
                             mean(res.seminat2$Nitrogen2[res.seminat2$region=="Southern Norway"],na.rm=T)),
         Phosphorus1.reg.mean = c(mean(res.seminat2$Phosphorus1[res.seminat2$region=="Northern Norway"],na.rm=T),
                                mean(res.seminat2$Phosphorus1[res.seminat2$region=="Central Norway"],na.rm=T),
                                mean(res.seminat2$Phosphorus1[res.seminat2$region=="Eastern Norway"],na.rm=T),
                                mean(res.seminat2$Phosphorus1[res.seminat2$region=="Western Norway"],na.rm=T),
                                mean(res.seminat2$Phosphorus1[res.seminat2$region=="Southern Norway"],na.rm=T)),
         Phosphorus2.reg.mean = c(mean(res.seminat2$Phosphorus2[res.seminat2$region=="Northern Norway"],na.rm=T),
                                mean(res.seminat2$Phosphorus2[res.seminat2$region=="Central Norway"],na.rm=T),
                                mean(res.seminat2$Phosphorus2[res.seminat2$region=="Eastern Norway"],na.rm=T),
                                mean(res.seminat2$Phosphorus2[res.seminat2$region=="Western Norway"],na.rm=T),
                                mean(res.seminat2$Phosphorus2[res.seminat2$region=="Southern Norway"],na.rm=T)),
         Grazing_mowing1.reg.mean = c(mean(res.seminat2$Grazing_mowing1[res.seminat2$region=="Northern Norway"],na.rm=T),
                                mean(res.seminat2$Grazing_mowing1[res.seminat2$region=="Central Norway"],na.rm=T),
                                mean(res.seminat2$Grazing_mowing1[res.seminat2$region=="Eastern Norway"],na.rm=T),
                                mean(res.seminat2$Grazing_mowing1[res.seminat2$region=="Western Norway"],na.rm=T),
                                mean(res.seminat2$Grazing_mowing1[res.seminat2$region=="Southern Norway"],na.rm=T)),
         Grazing_mowing2.reg.mean = c(mean(res.seminat2$Grazing_mowing2[res.seminat2$region=="Northern Norway"],na.rm=T),
                                mean(res.seminat2$Grazing_mowing2[res.seminat2$region=="Central Norway"],na.rm=T),
                                mean(res.seminat2$Grazing_mowing2[res.seminat2$region=="Eastern Norway"],na.rm=T),
                                mean(res.seminat2$Grazing_mowing2[res.seminat2$region=="Western Norway"],na.rm=T),
                                mean(res.seminat2$Grazing_mowing2[res.seminat2$region=="Southern Norway"],na.rm=T)),
         Soil_disturbance1.reg.mean = c(mean(res.seminat2$Soil_disturbance1[res.seminat2$region=="Northern Norway"],na.rm=T),
                                mean(res.seminat2$Soil_disturbance1[res.seminat2$region=="Central Norway"],na.rm=T),
                                mean(res.seminat2$Soil_disturbance1[res.seminat2$region=="Eastern Norway"],na.rm=T),
                                mean(res.seminat2$Soil_disturbance1[res.seminat2$region=="Western Norway"],na.rm=T),
                                mean(res.seminat2$Soil_disturbance1[res.seminat2$region=="Southern Norway"],na.rm=T)),
         Soil_disturbance2.reg.mean = c(mean(res.seminat2$Soil_disturbance2[res.seminat2$region=="Northern Norway"],na.rm=T),
                                mean(res.seminat2$Soil_disturbance2[res.seminat2$region=="Central Norway"],na.rm=T),
                                mean(res.seminat2$Soil_disturbance2[res.seminat2$region=="Eastern Norway"],na.rm=T),
                                mean(res.seminat2$Soil_disturbance2[res.seminat2$region=="Western Norway"],na.rm=T),
                                mean(res.seminat2$Soil_disturbance2[res.seminat2$region=="Southern Norway"],na.rm=T)),
         
         Light1.reg.sd = c(sd(res.seminat2$Light1[res.seminat2$region=="Northern Norway"],na.rm=T),
                             sd(res.seminat2$Light1[res.seminat2$region=="Central Norway"],na.rm=T),
                             sd(res.seminat2$Light1[res.seminat2$region=="Eastern Norway"],na.rm=T),
                             sd(res.seminat2$Light1[res.seminat2$region=="Western Norway"],na.rm=T),
                             sd(res.seminat2$Light1[res.seminat2$region=="Southern Norway"],na.rm=T)),
         Light2.reg.sd = c(sd(res.seminat2$Light2[res.seminat2$region=="Northern Norway"],na.rm=T),
                             sd(res.seminat2$Light2[res.seminat2$region=="Central Norway"],na.rm=T),
                             sd(res.seminat2$Light2[res.seminat2$region=="Eastern Norway"],na.rm=T),
                             sd(res.seminat2$Light2[res.seminat2$region=="Western Norway"],na.rm=T),
                             sd(res.seminat2$Light2[res.seminat2$region=="Southern Norway"],na.rm=T)),
         Moist1.reg.sd = c(sd(res.seminat2$Moist1[res.seminat2$region=="Northern Norway"],na.rm=T),
                             sd(res.seminat2$Moist1[res.seminat2$region=="Central Norway"],na.rm=T),
                             sd(res.seminat2$Moist1[res.seminat2$region=="Eastern Norway"],na.rm=T),
                             sd(res.seminat2$Moist1[res.seminat2$region=="Western Norway"],na.rm=T),
                             sd(res.seminat2$Moist1[res.seminat2$region=="Southern Norway"],na.rm=T)),
         Moist2.reg.sd = c(sd(res.seminat2$Moist2[res.seminat2$region=="Northern Norway"],na.rm=T),
                             sd(res.seminat2$Moist2[res.seminat2$region=="Central Norway"],na.rm=T),
                             sd(res.seminat2$Moist2[res.seminat2$region=="Eastern Norway"],na.rm=T),
                             sd(res.seminat2$Moist2[res.seminat2$region=="Western Norway"],na.rm=T),
                             sd(res.seminat2$Moist2[res.seminat2$region=="Southern Norway"],na.rm=T)),
         pH1.reg.sd = c(sd(res.seminat2$pH1[res.seminat2$region=="Northern Norway"],na.rm=T),
                          sd(res.seminat2$pH1[res.seminat2$region=="Central Norway"],na.rm=T),
                          sd(res.seminat2$pH1[res.seminat2$region=="Eastern Norway"],na.rm=T),
                          sd(res.seminat2$pH1[res.seminat2$region=="Western Norway"],na.rm=T),
                          sd(res.seminat2$pH1[res.seminat2$region=="Southern Norway"],na.rm=T)),
         pH2.reg.sd = c(sd(res.seminat2$pH2[res.seminat2$region=="Northern Norway"],na.rm=T),
                          sd(res.seminat2$pH2[res.seminat2$region=="Central Norway"],na.rm=T),
                          sd(res.seminat2$pH2[res.seminat2$region=="Eastern Norway"],na.rm=T),
                          sd(res.seminat2$pH2[res.seminat2$region=="Western Norway"],na.rm=T),
                          sd(res.seminat2$pH2[res.seminat2$region=="Southern Norway"],na.rm=T)),
         Nitrogen1.reg.sd = c(sd(res.seminat2$Nitrogen1[res.seminat2$region=="Northern Norway"],na.rm=T),
                                sd(res.seminat2$Nitrogen1[res.seminat2$region=="Central Norway"],na.rm=T),
                                sd(res.seminat2$Nitrogen1[res.seminat2$region=="Eastern Norway"],na.rm=T),
                                sd(res.seminat2$Nitrogen1[res.seminat2$region=="Western Norway"],na.rm=T),
                                sd(res.seminat2$Nitrogen1[res.seminat2$region=="Southern Norway"],na.rm=T)),
         Nitrogen2.reg.sd = c(sd(res.seminat2$Nitrogen2[res.seminat2$region=="Northern Norway"],na.rm=T),
                                sd(res.seminat2$Nitrogen2[res.seminat2$region=="Central Norway"],na.rm=T),
                                sd(res.seminat2$Nitrogen2[res.seminat2$region=="Eastern Norway"],na.rm=T),
                                sd(res.seminat2$Nitrogen2[res.seminat2$region=="Western Norway"],na.rm=T),
                                sd(res.seminat2$Nitrogen2[res.seminat2$region=="Southern Norway"],na.rm=T)),
         Phosphorus1.reg.sd = c(sd(res.seminat2$Phosphorus1[res.seminat2$region=="Northern Norway"],na.rm=T),
                              sd(res.seminat2$Phosphorus1[res.seminat2$region=="Central Norway"],na.rm=T),
                              sd(res.seminat2$Phosphorus1[res.seminat2$region=="Eastern Norway"],na.rm=T),
                              sd(res.seminat2$Phosphorus1[res.seminat2$region=="Western Norway"],na.rm=T),
                              sd(res.seminat2$Phosphorus1[res.seminat2$region=="Southern Norway"],na.rm=T)),
         Phosphorus2.reg.sd = c(sd(res.seminat2$Phosphorus2[res.seminat2$region=="Northern Norway"],na.rm=T),
                              sd(res.seminat2$Phosphorus2[res.seminat2$region=="Central Norway"],na.rm=T),
                              sd(res.seminat2$Phosphorus2[res.seminat2$region=="Eastern Norway"],na.rm=T),
                              sd(res.seminat2$Phosphorus2[res.seminat2$region=="Western Norway"],na.rm=T),
                              sd(res.seminat2$Phosphorus2[res.seminat2$region=="Southern Norway"],na.rm=T)),
         Grazing_mowing1.reg.sd = c(sd(res.seminat2$Grazing_mowing1[res.seminat2$region=="Northern Norway"],na.rm=T),
                              sd(res.seminat2$Grazing_mowing1[res.seminat2$region=="Central Norway"],na.rm=T),
                              sd(res.seminat2$Grazing_mowing1[res.seminat2$region=="Eastern Norway"],na.rm=T),
                              sd(res.seminat2$Grazing_mowing1[res.seminat2$region=="Western Norway"],na.rm=T),
                              sd(res.seminat2$Grazing_mowing1[res.seminat2$region=="Southern Norway"],na.rm=T)),
         Grazing_mowing2.reg.sd = c(sd(res.seminat2$Grazing_mowing2[res.seminat2$region=="Northern Norway"],na.rm=T),
                              sd(res.seminat2$Grazing_mowing2[res.seminat2$region=="Central Norway"],na.rm=T),
                              sd(res.seminat2$Grazing_mowing2[res.seminat2$region=="Eastern Norway"],na.rm=T),
                              sd(res.seminat2$Grazing_mowing2[res.seminat2$region=="Western Norway"],na.rm=T),
                              sd(res.seminat2$Grazing_mowing2[res.seminat2$region=="Southern Norway"],na.rm=T)),
         Soil_disturbance1.reg.sd = c(sd(res.seminat2$Soil_disturbance1[res.seminat2$region=="Northern Norway"],na.rm=T),
                              sd(res.seminat2$Soil_disturbance1[res.seminat2$region=="Central Norway"],na.rm=T),
                              sd(res.seminat2$Soil_disturbance1[res.seminat2$region=="Eastern Norway"],na.rm=T),
                              sd(res.seminat2$Soil_disturbance1[res.seminat2$region=="Western Norway"],na.rm=T),
                              sd(res.seminat2$Soil_disturbance1[res.seminat2$region=="Southern Norway"],na.rm=T)),
         Soil_disturbance2.reg.sd = c(sd(res.seminat2$Soil_disturbance2[res.seminat2$region=="Northern Norway"],na.rm=T),
                              sd(res.seminat2$Soil_disturbance2[res.seminat2$region=="Central Norway"],na.rm=T),
                              sd(res.seminat2$Soil_disturbance2[res.seminat2$region=="Eastern Norway"],na.rm=T),
                              sd(res.seminat2$Soil_disturbance2[res.seminat2$region=="Western Norway"],na.rm=T),
                              sd(res.seminat2$Soil_disturbance2[res.seminat2$region=="Southern Norway"],na.rm=T)),
         
         Light1.reg.n = c(nrow(res.seminat2[res.seminat2$region=="Northern Norway" & !is.na(res.seminat2$Light1),]),
                             nrow(res.seminat2[res.seminat2$region=="Central Norway" & !is.na(res.seminat2$Light1),]),
                             nrow(res.seminat2[res.seminat2$region=="Eastern Norway" & !is.na(res.seminat2$Light1),]),
                             nrow(res.seminat2[res.seminat2$region=="Western Norway" & !is.na(res.seminat2$Light1),]),
                             nrow(res.seminat2[res.seminat2$region=="Southern Norway" & !is.na(res.seminat2$Light1),])),
         Light2.reg.n = c(nrow(res.seminat2[res.seminat2$region=="Northern Norway" & !is.na(res.seminat2$Light2),]),
                             nrow(res.seminat2[res.seminat2$region=="Central Norway" & !is.na(res.seminat2$Light2),]),
                             nrow(res.seminat2[res.seminat2$region=="Eastern Norway" & !is.na(res.seminat2$Light2),]),
                             nrow(res.seminat2[res.seminat2$region=="Western Norway" & !is.na(res.seminat2$Light2),]),
                             nrow(res.seminat2[res.seminat2$region=="Southern Norway" & !is.na(res.seminat2$Light2),])),
         Moist1.reg.n = c(nrow(res.seminat2[res.seminat2$region=="Northern Norway" & !is.na(res.seminat2$Moist1),]),
                             nrow(res.seminat2[res.seminat2$region=="Central Norway" & !is.na(res.seminat2$Moist1),]),
                             nrow(res.seminat2[res.seminat2$region=="Eastern Norway" & !is.na(res.seminat2$Moist1),]),
                             nrow(res.seminat2[res.seminat2$region=="Western Norway" & !is.na(res.seminat2$Moist1),]),
                             nrow(res.seminat2[res.seminat2$region=="Southern Norway" & !is.na(res.seminat2$Moist1),])),
         Moist2.reg.n = c(nrow(res.seminat2[res.seminat2$region=="Northern Norway" & !is.na(res.seminat2$Moist2),]),
                             nrow(res.seminat2[res.seminat2$region=="Central Norway" & !is.na(res.seminat2$Moist2),]),
                             nrow(res.seminat2[res.seminat2$region=="Eastern Norway" & !is.na(res.seminat2$Moist2),]),
                             nrow(res.seminat2[res.seminat2$region=="Western Norway" & !is.na(res.seminat2$Moist2),]),
                             nrow(res.seminat2[res.seminat2$region=="Southern Norway" & !is.na(res.seminat2$Moist2),])),
         pH1.reg.n = c(nrow(res.seminat2[res.seminat2$region=="Northern Norway" & !is.na(res.seminat2$pH1),]),
                          nrow(res.seminat2[res.seminat2$region=="Central Norway" & !is.na(res.seminat2$pH1),]),
                          nrow(res.seminat2[res.seminat2$region=="Eastern Norway" & !is.na(res.seminat2$pH1),]),
                          nrow(res.seminat2[res.seminat2$region=="Western Norway" & !is.na(res.seminat2$pH1),]),
                          nrow(res.seminat2[res.seminat2$region=="Southern Norway" & !is.na(res.seminat2$pH1),])),
         pH2.reg.n = c(nrow(res.seminat2[res.seminat2$region=="Northern Norway" & !is.na(res.seminat2$pH2),]),
                          nrow(res.seminat2[res.seminat2$region=="Central Norway" & !is.na(res.seminat2$pH2),]),
                          nrow(res.seminat2[res.seminat2$region=="Eastern Norway" & !is.na(res.seminat2$pH2),]),
                          nrow(res.seminat2[res.seminat2$region=="Western Norway" & !is.na(res.seminat2$pH2),]),
                          nrow(res.seminat2[res.seminat2$region=="Southern Norway" & !is.na(res.seminat2$pH2),])),
         Nitrogen1.reg.n = c(nrow(res.seminat2[res.seminat2$region=="Northern Norway" & !is.na(res.seminat2$Nitrogen1),]),
                                nrow(res.seminat2[res.seminat2$region=="Central Norway" & !is.na(res.seminat2$Nitrogen1),]),
                                nrow(res.seminat2[res.seminat2$region=="Eastern Norway" & !is.na(res.seminat2$Nitrogen1),]),
                                nrow(res.seminat2[res.seminat2$region=="Western Norway" & !is.na(res.seminat2$Nitrogen1),]),
                                nrow(res.seminat2[res.seminat2$region=="Southern Norway" & !is.na(res.seminat2$Nitrogen1),])),
         Nitrogen2.reg.n = c(nrow(res.seminat2[res.seminat2$region=="Northern Norway" & !is.na(res.seminat2$Nitrogen2),]),
                                nrow(res.seminat2[res.seminat2$region=="Central Norway" & !is.na(res.seminat2$Nitrogen2),]),
                                nrow(res.seminat2[res.seminat2$region=="Eastern Norway" & !is.na(res.seminat2$Nitrogen2),]),
                                nrow(res.seminat2[res.seminat2$region=="Western Norway" & !is.na(res.seminat2$Nitrogen2),]),
                                nrow(res.seminat2[res.seminat2$region=="Southern Norway" & !is.na(res.seminat2$Nitrogen2),])),
         Phosphorus1.reg.n = c(nrow(res.seminat2[res.seminat2$region=="Northern Norway" & !is.na(res.seminat2$Phosphorus1),]),
                             nrow(res.seminat2[res.seminat2$region=="Central Norway" & !is.na(res.seminat2$Phosphorus1),]),
                             nrow(res.seminat2[res.seminat2$region=="Eastern Norway" & !is.na(res.seminat2$Phosphorus1),]),
                             nrow(res.seminat2[res.seminat2$region=="Western Norway" & !is.na(res.seminat2$Phosphorus1),]),
                             nrow(res.seminat2[res.seminat2$region=="Southern Norway" & !is.na(res.seminat2$Phosphorus1),])),
         Phosphorus2.reg.n = c(nrow(res.seminat2[res.seminat2$region=="Northern Norway" & !is.na(res.seminat2$Phosphorus2),]),
                             nrow(res.seminat2[res.seminat2$region=="Central Norway" & !is.na(res.seminat2$Phosphorus2),]),
                             nrow(res.seminat2[res.seminat2$region=="Eastern Norway" & !is.na(res.seminat2$Phosphorus2),]),
                             nrow(res.seminat2[res.seminat2$region=="Western Norway" & !is.na(res.seminat2$Phosphorus2),]),
                             nrow(res.seminat2[res.seminat2$region=="Southern Norway" & !is.na(res.seminat2$Phosphorus2),])),
         Grazing_mowing1.reg.n = c(nrow(res.seminat2[res.seminat2$region=="Northern Norway" & !is.na(res.seminat2$Grazing_mowing1),]),
                             nrow(res.seminat2[res.seminat2$region=="Central Norway" & !is.na(res.seminat2$Grazing_mowing1),]),
                             nrow(res.seminat2[res.seminat2$region=="Eastern Norway" & !is.na(res.seminat2$Grazing_mowing1),]),
                             nrow(res.seminat2[res.seminat2$region=="Western Norway" & !is.na(res.seminat2$Grazing_mowing1),]),
                             nrow(res.seminat2[res.seminat2$region=="Southern Norway" & !is.na(res.seminat2$Grazing_mowing1),])),
         Grazing_mowing2.reg.n = c(nrow(res.seminat2[res.seminat2$region=="Northern Norway" & !is.na(res.seminat2$Grazing_mowing2),]),
                             nrow(res.seminat2[res.seminat2$region=="Central Norway" & !is.na(res.seminat2$Grazing_mowing2),]),
                             nrow(res.seminat2[res.seminat2$region=="Eastern Norway" & !is.na(res.seminat2$Grazing_mowing2),]),
                             nrow(res.seminat2[res.seminat2$region=="Western Norway" & !is.na(res.seminat2$Grazing_mowing2),]),
                             nrow(res.seminat2[res.seminat2$region=="Southern Norway" & !is.na(res.seminat2$Grazing_mowing2),])),
         Soil_disturbance1.reg.n = c(nrow(res.seminat2[res.seminat2$region=="Northern Norway" & !is.na(res.seminat2$Soil_disturbance1),]),
                             nrow(res.seminat2[res.seminat2$region=="Central Norway" & !is.na(res.seminat2$Soil_disturbance1),]),
                             nrow(res.seminat2[res.seminat2$region=="Eastern Norway" & !is.na(res.seminat2$Soil_disturbance1),]),
                             nrow(res.seminat2[res.seminat2$region=="Western Norway" & !is.na(res.seminat2$Soil_disturbance1),]),
                             nrow(res.seminat2[res.seminat2$region=="Southern Norway" & !is.na(res.seminat2$Soil_disturbance1),])),
         Soil_disturbance2.reg.n = c(nrow(res.seminat2[res.seminat2$region=="Northern Norway" & !is.na(res.seminat2$Soil_disturbance2),]),
                             nrow(res.seminat2[res.seminat2$region=="Central Norway" & !is.na(res.seminat2$Soil_disturbance2),]),
                             nrow(res.seminat2[res.seminat2$region=="Eastern Norway" & !is.na(res.seminat2$Soil_disturbance2),]),
                             nrow(res.seminat2[res.seminat2$region=="Western Norway" & !is.na(res.seminat2$Soil_disturbance2),]),
                             nrow(res.seminat2[res.seminat2$region=="Southern Norway" & !is.na(res.seminat2$Soil_disturbance2),]))
         )
  
  

## scaled value maps
# Light1 (lower indicator)
tm_shape(regnor) +
  tm_polygons(col="Light1.reg.mean", title="Light (lower)", style="quantile", palette=rev(get_brewer_pal(palette="OrRd", n=5, plot=FALSE))) +
  tm_text("Light1.reg.n",col="black",bg.color="grey")

# Grazing_mowing1 (lower indicator)
tm_shape(regnor) +
  tm_polygons(col="Grazing_mowing1.reg.mean", title="Grazing_mowing (lower)", style="quantile", palette=rev(get_brewer_pal(palette="OrRd", n=5, plot=FALSE))) +
  tm_text("Grazing_mowing1.reg.n",col="black",bg.color="grey")




#### how many observations are there? ####
# total ANO
length(unique(ANO.geo$ano_flate_id))
length(unique(ANO.geo$ano_punkt_id))
# total seminat
length(unique(res.seminat2$ano_flate_id))
length(unique(res.seminat2$ano_punkt_id))
# by region
length(unique(res.seminat2$ano_flate_id[res.seminat2$region=="Northern Norway"]))
length(unique(res.seminat2$ano_flate_id[res.seminat2$region=="Central Norway"]))
length(unique(res.seminat2$ano_flate_id[res.seminat2$region=="Eastern Norway"]))
length(unique(res.seminat2$ano_flate_id[res.seminat2$region=="Western Norway"]))
length(unique(res.seminat2$ano_flate_id[res.seminat2$region=="Southern Norway"]))

length(unique(res.seminat2$ano_punkt_id[res.seminat2$region=="Northern Norway"]))
length(unique(res.seminat2$ano_punkt_id[res.seminat2$region=="Central Norway"]))
length(unique(res.seminat2$ano_punkt_id[res.seminat2$region=="Eastern Norway"]))
length(unique(res.seminat2$ano_punkt_id[res.seminat2$region=="Western Norway"]))
length(unique(res.seminat2$ano_punkt_id[res.seminat2$region=="Southern Norway"]))






#### distribution comparison, reference vs. field data ####
summary(res.seminat$kartleggingsenhet_1m2)
length(unique(res.seminat$kartleggingsenhet_1m2))
# 19 NiN-types, of which T41-C-1 has 0 observations, and T32 & T34 as main types don't have a reference -> so, 16 NiN-Types to plot
colnames(seminat.ref.cov[['Light']])

### Light
x11()
par(mfrow=c(4,4))
## T32s
# T32-C-1
plot(density( as.matrix(seminat.ref.cov[['Light']][,"T32-C1C2"]) ,na.rm=T),
     xlim=c(1,7), type="l", main='T32-C1',xlab='Light value')
points(density(res.seminat[res.seminat$fp_ind=="Light1" & res.seminat$fp_ind=="Light1" & res.seminat$kartleggingsenhet_1m2=="T32-C-1",]$original,na.rm=T),
       type="l", col="red")
points(res.seminat[res.seminat$fp_ind=="Light1" & res.seminat$fp_ind=="Light1" & res.seminat$kartleggingsenhet_1m2=="T32-C-1",]$original,
       rep(0,length(res.seminat[res.seminat$fp_ind=="Light1" & res.seminat$fp_ind=="Light1" & res.seminat$kartleggingsenhet_1m2=="T32-C-1",]$original)),
       col="red")

# T32-C-2
plot(density( as.matrix(seminat.ref.cov[['Light']][,"T32-C1C2"]) ,na.rm=T),
     xlim=c(1,7), type="l", main='T32-C2',xlab='Light value')
points(density(res.seminat[res.seminat$fp_ind=="Light1" & res.seminat$kartleggingsenhet_1m2=="T32-C-2",]$original,na.rm=T),
       type="l", col="red")
points(res.seminat[res.seminat$fp_ind=="Light1" & res.seminat$kartleggingsenhet_1m2=="T32-C-2",]$original,
       rep(0,length(res.seminat[res.seminat$fp_ind=="Light1" & res.seminat$kartleggingsenhet_1m2=="T32-C-2",]$original)),
       col="red")

# T32-C-3
plot(density( as.matrix(seminat.ref.cov[['Light']][,"T32-C3C4"]) ,na.rm=T),
     xlim=c(1,7), type="l", main='T32-C3',xlab='Light value')
points(density(res.seminat[res.seminat$fp_ind=="Light1" & res.seminat$kartleggingsenhet_1m2=="T32-C-3",]$original,na.rm=T),
       type="l", col="red")
points(res.seminat[res.seminat$fp_ind=="Light1" & res.seminat$kartleggingsenhet_1m2=="T32-C-3",]$original,
       rep(0,length(res.seminat[res.seminat$fp_ind=="Light1" & res.seminat$kartleggingsenhet_1m2=="T32-C-3",]$original)),
       col="red")

# T32-C-4
plot(density( as.matrix(seminat.ref.cov[['Light']][,"T32-C3C4"]) ,na.rm=T),
     xlim=c(1,7), type="l", main='T32-C4',xlab='Light value')
points(density(res.seminat[res.seminat$fp_ind=="Light1" & res.seminat$kartleggingsenhet_1m2=="T32-C-4",]$original,na.rm=T),
       type="l", col="red")
points(res.seminat[res.seminat$fp_ind=="Light1" & res.seminat$kartleggingsenhet_1m2=="T32-C-4",]$original,
       rep(0,length(res.seminat[res.seminat$fp_ind=="Light1" & res.seminat$kartleggingsenhet_1m2=="T32-C-4",]$original)),
       col="red")

# T32-C-5
plot(density( as.matrix(seminat.ref.cov[['Light']][,c("T32-C5C20a","T32-C5C20b")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='T32-C5',xlab='Light value')
points(density(res.seminat[res.seminat$fp_ind=="Light1" & res.seminat$kartleggingsenhet_1m2=="T32-C-5",]$original,na.rm=T),
       type="l", col="red")
points(res.seminat[res.seminat$fp_ind=="Light1" & res.seminat$kartleggingsenhet_1m2=="T32-C-5",]$original,
       rep(0,length(res.seminat[res.seminat$fp_ind=="Light1" & res.seminat$kartleggingsenhet_1m2=="T32-C-5",]$original)),
       col="red")

# T32-C-6
plot(density( as.matrix(seminat.ref.cov[['Light']][,c("T32-C21C6a","T32-C21C6b")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='T32-C6',xlab='Light value')
points(density(res.seminat[res.seminat$fp_ind=="Light1" & res.seminat$kartleggingsenhet_1m2=="T32-C-6",]$original,na.rm=T),
       type="l", col="red")
points(res.seminat[res.seminat$fp_ind=="Light1" & res.seminat$kartleggingsenhet_1m2=="T32-C-6",]$original,
       rep(0,length(res.seminat[res.seminat$fp_ind=="Light1" & res.seminat$kartleggingsenhet_1m2=="T32-C-6",]$original)),
       col="red")

# T32-C-9
plot(density( as.matrix(seminat.ref.cov[['Light']][,c("T32-C9a","T32-C9b")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='T32-C9',xlab='Light value')
points(density(res.seminat[res.seminat$fp_ind=="Light1" & res.seminat$kartleggingsenhet_1m2=="T32-C-9",]$original,na.rm=T),
       type="l", col="red")
points(res.seminat[res.seminat$fp_ind=="Light1" & res.seminat$kartleggingsenhet_1m2=="T32-C-9",]$original,
       rep(0,length(res.seminat[res.seminat$fp_ind=="Light1" & res.seminat$kartleggingsenhet_1m2=="T32-C-9",]$original)),
       col="red")

# T32-C-10
plot(density( as.matrix(seminat.ref.cov[['Light']][,c("T32-C10a","T32-C10b")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='T32-C10',xlab='Light value')
points(density(res.seminat[res.seminat$fp_ind=="Light1" & res.seminat$kartleggingsenhet_1m2=="T32-C-10",]$original,na.rm=T),
       type="l", col="red")
points(res.seminat[res.seminat$fp_ind=="Light1" & res.seminat$kartleggingsenhet_1m2=="T32-C-10",]$original,
       rep(0,length(res.seminat[res.seminat$fp_ind=="Light1" & res.seminat$kartleggingsenhet_1m2=="T32-C-10",]$original)),
       col="red")

# T32-C-15
plot(density( as.matrix(seminat.ref.cov[['Light']][,c("T32-C15")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='T32-C15',xlab='Light value')
#points(density(res.seminat[res.seminat$fp_ind=="Light1" & res.seminat$kartleggingsenhet_1m2=="T32-C-15",]$original,na.rm=T),
#       type="l", col="red")
points(res.seminat[res.seminat$fp_ind=="Light1" & res.seminat$kartleggingsenhet_1m2=="T32-C-15",]$original,
       rep(0,length(res.seminat[res.seminat$fp_ind=="Light1" & res.seminat$kartleggingsenhet_1m2=="T32-C-15",]$original)),
       col="red")

# T32-C-20
plot(density( as.matrix(seminat.ref.cov[['Light']][,c("T32-C5C20a","T32-C5C20b")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='T32-C20',xlab='Light value')
points(density(res.seminat[res.seminat$fp_ind=="Light1" & res.seminat$kartleggingsenhet_1m2=="T32-C-20",]$original,na.rm=T),
       type="l", col="red")
points(res.seminat[res.seminat$fp_ind=="Light1" & res.seminat$kartleggingsenhet_1m2=="T32-C-20",]$original,
       rep(0,length(res.seminat[res.seminat$fp_ind=="Light1" & res.seminat$kartleggingsenhet_1m2=="T32-C-20",]$original)),
       col="red")


## V10s
# V10-C-1
plot(density( as.matrix(seminat.ref.cov[['Light']][,"V10-C1C2"]) ,na.rm=T),
     xlim=c(1,7), type="l", main='V10-C1',xlab='Light value')
points(density(res.seminat[res.seminat$fp_ind=="Light1" & res.seminat$kartleggingsenhet_1m2=="V10-C-1",]$original,na.rm=T),
       type="l", col="red")
points(res.seminat[res.seminat$fp_ind=="Light1" & res.seminat$kartleggingsenhet_1m2=="V10-C-1",]$original,
       rep(0,length(res.seminat[res.seminat$fp_ind=="Light1" & res.seminat$kartleggingsenhet_1m2=="V10-C-1",]$original)),
       col="red")

# V10-C-3
plot(density( as.matrix(seminat.ref.cov[['Light']][,"V10-C3"]) ,na.rm=T),
     xlim=c(1,7), type="l", main='V10-C3',xlab='Light value')
#points(density(res.seminat[res.seminat$fp_ind=="Light1" & res.seminat$kartleggingsenhet_1m2=="V10-C-3",]$original,na.rm=T),
#       type="l", col="red")
points(res.seminat[res.seminat$fp_ind=="Light1" & res.seminat$kartleggingsenhet_1m2=="V10-C-3",]$original,
       rep(0,length(res.seminat[res.seminat$fp_ind=="Light1" & res.seminat$kartleggingsenhet_1m2=="V10-C-3",]$original)),
       col="red")


## T34s
# T34-C-1
plot(density( as.matrix(seminat.ref.cov[['Light']][,"T34-C1"]) ,na.rm=T),
     xlim=c(1,7), type="l", main='T34-C1',xlab='Light value')
points(density(res.seminat[res.seminat$fp_ind=="Light1" & res.seminat$kartleggingsenhet_1m2=="T34-C-1",]$original,na.rm=T),
       type="l", col="red")
points(res.seminat[res.seminat$fp_ind=="Light1" & res.seminat$kartleggingsenhet_1m2=="T34-C-1",]$original,
       rep(0,length(res.seminat[res.seminat$fp_ind=="Light1" & res.seminat$kartleggingsenhet_1m2=="T34-C-1",]$original)),
       col="red")

# T34-C-2
plot(density( as.matrix(seminat.ref.cov[['Light']][,c("T34-C2a","T34-C2b","T34-C2c")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='T34-C2',xlab='Light value')
points(density(res.seminat[res.seminat$fp_ind=="Light1" & res.seminat$kartleggingsenhet_1m2=="T34-C-2",]$original,na.rm=T),
       type="l", col="red")
points(res.seminat[res.seminat$fp_ind=="Light1" & res.seminat$kartleggingsenhet_1m2=="T34-C-2",]$original,
       rep(0,length(res.seminat[res.seminat$fp_ind=="Light1" & res.seminat$kartleggingsenhet_1m2=="T34-C-2",]$original)),
       col="red")

# T34-C-4
plot(density( as.matrix(seminat.ref.cov[['Light']][,c("T34-C4a","T34-C4b","T34-C4c","T34-C4d")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='T34-C4',xlab='Light value')
#points(density(res.seminat[res.seminat$fp_ind=="Light1" & res.seminat$kartleggingsenhet_1m2=="T34-C-4",]$original,na.rm=T),
#       type="l", col="red")
points(res.seminat[res.seminat$fp_ind=="Light1" & res.seminat$kartleggingsenhet_1m2=="T34-C-4",]$original,
       rep(0,length(res.seminat[res.seminat$fp_ind=="Light1" & res.seminat$kartleggingsenhet_1m2=="T34-C-4",]$original)),
       col="red")


## T41
plot(density( as.matrix(seminat.ref.cov[['Light']][,c("T41a","T41b")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='T41',xlab='Light value')
points(density(res.seminat[res.seminat$fp_ind=="Light1" & res.seminat$kartleggingsenhet_1m2=="T41",]$original,na.rm=T),
       type="l", col="red")
points(res.seminat[res.seminat$fp_ind=="Light1" & res.seminat$kartleggingsenhet_1m2=="T41",]$original,
       rep(0,length(res.seminat[res.seminat$fp_ind=="Light1" & res.seminat$kartleggingsenhet_1m2=="T41",]$original)),
       col="red")
legend("topleft", legend=c("reference","field data"), pch=c(NULL,1), lty=1, col=c("black","red"))



### Grazing_mowing
x11()
par(mfrow=c(4,4))
## T32s
# T32-C-1
plot(density( as.matrix(seminat.ref.cov[['Grazing_mowing']][,"T32-C1C2"]) ,na.rm=T),
     xlim=c(1,8), type="l", main='T32-C1',xlab='Grazing_mowing value')
points(density(res.seminat[res.seminat$fp_ind=="Grazing_mowing1" & res.seminat$fp_ind=="Grazing_mowing1" & res.seminat$kartleggingsenhet_1m2=="T32-C-1",]$original,na.rm=T),
       type="l", col="red")
points(res.seminat[res.seminat$fp_ind=="Grazing_mowing1" & res.seminat$fp_ind=="Grazing_mowing1" & res.seminat$kartleggingsenhet_1m2=="T32-C-1",]$original,
       rep(0,length(res.seminat[res.seminat$fp_ind=="Grazing_mowing1" & res.seminat$fp_ind=="Grazing_mowing1" & res.seminat$kartleggingsenhet_1m2=="T32-C-1",]$original)),
       col="red")

# T32-C-2
plot(density( as.matrix(seminat.ref.cov[['Grazing_mowing']][,"T32-C1C2"]) ,na.rm=T),
     xlim=c(1,8), type="l", main='T32-C2',xlab='Grazing_mowing value')
points(density(res.seminat[res.seminat$fp_ind=="Grazing_mowing1" & res.seminat$kartleggingsenhet_1m2=="T32-C-2",]$original,na.rm=T),
       type="l", col="red")
points(res.seminat[res.seminat$fp_ind=="Grazing_mowing1" & res.seminat$kartleggingsenhet_1m2=="T32-C-2",]$original,
       rep(0,length(res.seminat[res.seminat$fp_ind=="Grazing_mowing1" & res.seminat$kartleggingsenhet_1m2=="T32-C-2",]$original)),
       col="red")

# T32-C-3
plot(density( as.matrix(seminat.ref.cov[['Grazing_mowing']][,"T32-C3C4"]) ,na.rm=T),
     xlim=c(1,8), type="l", main='T32-C3',xlab='Grazing_mowing value')
points(density(res.seminat[res.seminat$fp_ind=="Grazing_mowing1" & res.seminat$kartleggingsenhet_1m2=="T32-C-3",]$original,na.rm=T),
       type="l", col="red")
points(res.seminat[res.seminat$fp_ind=="Grazing_mowing1" & res.seminat$kartleggingsenhet_1m2=="T32-C-3",]$original,
       rep(0,length(res.seminat[res.seminat$fp_ind=="Grazing_mowing1" & res.seminat$kartleggingsenhet_1m2=="T32-C-3",]$original)),
       col="red")

# T32-C-4
plot(density( as.matrix(seminat.ref.cov[['Grazing_mowing']][,"T32-C3C4"]) ,na.rm=T),
     xlim=c(1,8), type="l", main='T32-C4',xlab='Grazing_mowing value')
points(density(res.seminat[res.seminat$fp_ind=="Grazing_mowing1" & res.seminat$kartleggingsenhet_1m2=="T32-C-4",]$original,na.rm=T),
       type="l", col="red")
points(res.seminat[res.seminat$fp_ind=="Grazing_mowing1" & res.seminat$kartleggingsenhet_1m2=="T32-C-4",]$original,
       rep(0,length(res.seminat[res.seminat$fp_ind=="Grazing_mowing1" & res.seminat$kartleggingsenhet_1m2=="T32-C-4",]$original)),
       col="red")

# T32-C-5
plot(density( as.matrix(seminat.ref.cov[['Grazing_mowing']][,c("T32-C5C20a","T32-C5C20b")]) ,na.rm=T),
     xlim=c(1,8), type="l", main='T32-C5',xlab='Grazing_mowing value')
points(density(res.seminat[res.seminat$fp_ind=="Grazing_mowing1" & res.seminat$kartleggingsenhet_1m2=="T32-C-5",]$original,na.rm=T),
       type="l", col="red")
points(res.seminat[res.seminat$fp_ind=="Grazing_mowing1" & res.seminat$kartleggingsenhet_1m2=="T32-C-5",]$original,
       rep(0,length(res.seminat[res.seminat$fp_ind=="Grazing_mowing1" & res.seminat$kartleggingsenhet_1m2=="T32-C-5",]$original)),
       col="red")

# T32-C-6
plot(density( as.matrix(seminat.ref.cov[['Grazing_mowing']][,c("T32-C21C6a","T32-C21C6b")]) ,na.rm=T),
     xlim=c(1,8), type="l", main='T32-C6',xlab='Grazing_mowing value')
points(density(res.seminat[res.seminat$fp_ind=="Grazing_mowing1" & res.seminat$kartleggingsenhet_1m2=="T32-C-6",]$original,na.rm=T),
       type="l", col="red")
points(res.seminat[res.seminat$fp_ind=="Grazing_mowing1" & res.seminat$kartleggingsenhet_1m2=="T32-C-6",]$original,
       rep(0,length(res.seminat[res.seminat$fp_ind=="Grazing_mowing1" & res.seminat$kartleggingsenhet_1m2=="T32-C-6",]$original)),
       col="red")

# T32-C-9
plot(density( as.matrix(seminat.ref.cov[['Grazing_mowing']][,c("T32-C9a","T32-C9b")]) ,na.rm=T),
     xlim=c(1,8), type="l", main='T32-C9',xlab='Grazing_mowing value')
points(density(res.seminat[res.seminat$fp_ind=="Grazing_mowing1" & res.seminat$kartleggingsenhet_1m2=="T32-C-9",]$original,na.rm=T),
       type="l", col="red")
points(res.seminat[res.seminat$fp_ind=="Grazing_mowing1" & res.seminat$kartleggingsenhet_1m2=="T32-C-9",]$original,
       rep(0,length(res.seminat[res.seminat$fp_ind=="Grazing_mowing1" & res.seminat$kartleggingsenhet_1m2=="T32-C-9",]$original)),
       col="red")

# T32-C-10
plot(density( as.matrix(seminat.ref.cov[['Grazing_mowing']][,c("T32-C10a","T32-C10b")]) ,na.rm=T),
     xlim=c(1,8), type="l", main='T32-C10',xlab='Grazing_mowing value')
points(density(res.seminat[res.seminat$fp_ind=="Grazing_mowing1" & res.seminat$kartleggingsenhet_1m2=="T32-C-10",]$original,na.rm=T),
       type="l", col="red")
points(res.seminat[res.seminat$fp_ind=="Grazing_mowing1" & res.seminat$kartleggingsenhet_1m2=="T32-C-10",]$original,
       rep(0,length(res.seminat[res.seminat$fp_ind=="Grazing_mowing1" & res.seminat$kartleggingsenhet_1m2=="T32-C-10",]$original)),
       col="red")

# T32-C-15
plot(density( as.matrix(seminat.ref.cov[['Grazing_mowing']][,c("T32-C15")]) ,na.rm=T),
     xlim=c(1,8), type="l", main='T32-C15',xlab='Grazing_mowing value')
#points(density(res.seminat[res.seminat$fp_ind=="Grazing_mowing1" & res.seminat$kartleggingsenhet_1m2=="T32-C-15",]$original,na.rm=T),
#       type="l", col="red")
points(res.seminat[res.seminat$fp_ind=="Grazing_mowing1" & res.seminat$kartleggingsenhet_1m2=="T32-C-15",]$original,
       rep(0,length(res.seminat[res.seminat$fp_ind=="Grazing_mowing1" & res.seminat$kartleggingsenhet_1m2=="T32-C-15",]$original)),
       col="red")

# T32-C-20
plot(density( as.matrix(seminat.ref.cov[['Grazing_mowing']][,c("T32-C5C20a","T32-C5C20b")]) ,na.rm=T),
     xlim=c(1,8), type="l", main='T32-C20',xlab='Grazing_mowing value')
points(density(res.seminat[res.seminat$fp_ind=="Grazing_mowing1" & res.seminat$kartleggingsenhet_1m2=="T32-C-20",]$original,na.rm=T),
       type="l", col="red")
points(res.seminat[res.seminat$fp_ind=="Grazing_mowing1" & res.seminat$kartleggingsenhet_1m2=="T32-C-20",]$original,
       rep(0,length(res.seminat[res.seminat$fp_ind=="Grazing_mowing1" & res.seminat$kartleggingsenhet_1m2=="T32-C-20",]$original)),
       col="red")


## V10s
# V10-C-1
plot(density( as.matrix(seminat.ref.cov[['Grazing_mowing']][,"V10-C1C2"]) ,na.rm=T),
     xlim=c(1,8), type="l", main='V10-C1',xlab='Grazing_mowing value')
points(density(res.seminat[res.seminat$fp_ind=="Grazing_mowing1" & res.seminat$kartleggingsenhet_1m2=="V10-C-1",]$original,na.rm=T),
       type="l", col="red")
points(res.seminat[res.seminat$fp_ind=="Grazing_mowing1" & res.seminat$kartleggingsenhet_1m2=="V10-C-1",]$original,
       rep(0,length(res.seminat[res.seminat$fp_ind=="Grazing_mowing1" & res.seminat$kartleggingsenhet_1m2=="V10-C-1",]$original)),
       col="red")

# V10-C-3
plot(density( as.matrix(seminat.ref.cov[['Grazing_mowing']][,"V10-C3"]) ,na.rm=T),
     xlim=c(1,8), type="l", main='V10-C3',xlab='Grazing_mowing value')
#points(density(res.seminat[res.seminat$fp_ind=="Grazing_mowing1" & res.seminat$kartleggingsenhet_1m2=="V10-C-3",]$original,na.rm=T),
#       type="l", col="red")
points(res.seminat[res.seminat$fp_ind=="Grazing_mowing1" & res.seminat$kartleggingsenhet_1m2=="V10-C-3",]$original,
       rep(0,length(res.seminat[res.seminat$fp_ind=="Grazing_mowing1" & res.seminat$kartleggingsenhet_1m2=="V10-C-3",]$original)),
       col="red")


## T34s
# T34-C-1
plot(density( as.matrix(seminat.ref.cov[['Grazing_mowing']][,"T34-C1"]) ,na.rm=T),
     xlim=c(1,8), type="l", main='T34-C1',xlab='Grazing_mowing value')
points(density(res.seminat[res.seminat$fp_ind=="Grazing_mowing1" & res.seminat$kartleggingsenhet_1m2=="T34-C-1",]$original,na.rm=T),
       type="l", col="red")
points(res.seminat[res.seminat$fp_ind=="Grazing_mowing1" & res.seminat$kartleggingsenhet_1m2=="T34-C-1",]$original,
       rep(0,length(res.seminat[res.seminat$fp_ind=="Grazing_mowing1" & res.seminat$kartleggingsenhet_1m2=="T34-C-1",]$original)),
       col="red")

# T34-C-2
plot(density( as.matrix(seminat.ref.cov[['Grazing_mowing']][,c("T34-C2a","T34-C2b","T34-C2c")]) ,na.rm=T),
     xlim=c(1,8), type="l", main='T34-C2',xlab='Grazing_mowing value')
points(density(res.seminat[res.seminat$fp_ind=="Grazing_mowing1" & res.seminat$kartleggingsenhet_1m2=="T34-C-2",]$original,na.rm=T),
       type="l", col="red")
points(res.seminat[res.seminat$fp_ind=="Grazing_mowing1" & res.seminat$kartleggingsenhet_1m2=="T34-C-2",]$original,
       rep(0,length(res.seminat[res.seminat$fp_ind=="Grazing_mowing1" & res.seminat$kartleggingsenhet_1m2=="T34-C-2",]$original)),
       col="red")

# T34-C-4
plot(density( as.matrix(seminat.ref.cov[['Grazing_mowing']][,c("T34-C4a","T34-C4b","T34-C4c","T34-C4d")]) ,na.rm=T),
     xlim=c(1,8), type="l", main='T34-C4',xlab='Grazing_mowing value')
#points(density(res.seminat[res.seminat$fp_ind=="Grazing_mowing1" & res.seminat$kartleggingsenhet_1m2=="T34-C-4",]$original,na.rm=T),
#       type="l", col="red")
points(res.seminat[res.seminat$fp_ind=="Grazing_mowing1" & res.seminat$kartleggingsenhet_1m2=="T34-C-4",]$original,
       rep(0,length(res.seminat[res.seminat$fp_ind=="Grazing_mowing1" & res.seminat$kartleggingsenhet_1m2=="T34-C-4",]$original)),
       col="red")


## T41
plot(density( as.matrix(seminat.ref.cov[['Grazing_mowing']][,c("T41a","T41b")]) ,na.rm=T),
     xlim=c(1,8), type="l", main='T41',xlab='Grazing_mowing value')
points(density(res.seminat[res.seminat$fp_ind=="Grazing_mowing1" & res.seminat$kartleggingsenhet_1m2=="T41",]$original,na.rm=T),
       type="l", col="red")
points(res.seminat[res.seminat$fp_ind=="Grazing_mowing1" & res.seminat$kartleggingsenhet_1m2=="T41",]$original,
       rep(0,length(res.seminat[res.seminat$fp_ind=="Grazing_mowing1" & res.seminat$kartleggingsenhet_1m2=="T41",]$original)),
       col="red")
legend("topleft", legend=c("reference","field data"), pch=c(NULL,1), lty=1, col=c("black","red"))




## similarly for ASO, here with just Grazing_mowing
summary(res.seminat.ASO$NiN_grunntype)
length(levels(res.seminat.ASO$NiN_grunntype))
# 12 NiN-types, of which C-13 and C-2 have 0 observations -> so, 10 NiN-Types to plot
colnames(seminat.ref.cov[['Grazing_mowing']])

### Grazing_mowing
x11()
par(mfrow=c(3,4))
# T32-C-1
plot(density( as.matrix(seminat.ref.cov[['Grazing_mowing']][,"T32-C1C2"]) ,na.rm=T),
     xlim=c(1,8), type="l", main='T32-C1',xlab='Grazing_mowing value')
points(density(res.seminat.ASO[res.seminat.ASO$fp_ind=="Grazing_mowing1" & res.seminat.ASO$fp_ind=="Grazing_mowing1" & res.seminat.ASO$NiN_grunntype=="T32-C-1",]$original,na.rm=T),
       type="l", col="red")
points(res.seminat.ASO[res.seminat.ASO$fp_ind=="Grazing_mowing1" & res.seminat.ASO$fp_ind=="Grazing_mowing1" & res.seminat.ASO$NiN_grunntype=="T32-C-1",]$original,
       rep(0,length(res.seminat.ASO[res.seminat.ASO$fp_ind=="Grazing_mowing1" & res.seminat.ASO$fp_ind=="Grazing_mowing1" & res.seminat.ASO$NiN_grunntype=="T32-C-1",]$original)),
       col="red")

# T32-C-3
plot(density( as.matrix(seminat.ref.cov[['Grazing_mowing']][,"T32-C3C4"]) ,na.rm=T),
     xlim=c(1,8), type="l", main='T32-C3',xlab='Grazing_mowing value')
points(density(res.seminat.ASO[res.seminat.ASO$fp_ind=="Grazing_mowing1" & res.seminat.ASO$NiN_grunntype=="T32-C-3",]$original,na.rm=T),
       type="l", col="red")
points(res.seminat.ASO[res.seminat.ASO$fp_ind=="Grazing_mowing1" & res.seminat.ASO$NiN_grunntype=="T32-C-3",]$original,
       rep(0,length(res.seminat.ASO[res.seminat.ASO$fp_ind=="Grazing_mowing1" & res.seminat.ASO$NiN_grunntype=="T32-C-3",]$original)),
       col="red")

# T32-C-4
plot(density( as.matrix(seminat.ref.cov[['Grazing_mowing']][,"T32-C3C4"]) ,na.rm=T),
     xlim=c(1,8), type="l", main='T32-C4',xlab='Grazing_mowing value')
points(density(res.seminat.ASO[res.seminat.ASO$fp_ind=="Grazing_mowing1" & res.seminat.ASO$NiN_grunntype=="T32-C-4",]$original,na.rm=T),
       type="l", col="red")
points(res.seminat.ASO[res.seminat.ASO$fp_ind=="Grazing_mowing1" & res.seminat.ASO$NiN_grunntype=="T32-C-4",]$original,
       rep(0,length(res.seminat.ASO[res.seminat.ASO$fp_ind=="Grazing_mowing1" & res.seminat.ASO$NiN_grunntype=="T32-C-4",]$original)),
       col="red")

# T32-C-5
plot(density( as.matrix(seminat.ref.cov[['Grazing_mowing']][,c("T32-C5C20a","T32-C5C20b")]) ,na.rm=T),
     xlim=c(1,8), type="l", main='T32-C5',xlab='Grazing_mowing value')
points(density(res.seminat.ASO[res.seminat.ASO$fp_ind=="Grazing_mowing1" & res.seminat.ASO$NiN_grunntype=="T32-C-5",]$original,na.rm=T),
       type="l", col="red")
points(res.seminat.ASO[res.seminat.ASO$fp_ind=="Grazing_mowing1" & res.seminat.ASO$NiN_grunntype=="T32-C-5",]$original,
       rep(0,length(res.seminat.ASO[res.seminat.ASO$fp_ind=="Grazing_mowing1" & res.seminat.ASO$NiN_grunntype=="T32-C-5",]$original)),
       col="red")

# T32-C-6
plot(density( as.matrix(seminat.ref.cov[['Grazing_mowing']][,c("T32-C21C6a","T32-C21C6b")]) ,na.rm=T),
     xlim=c(1,8), type="l", main='T32-C6',xlab='Grazing_mowing value')
points(density(res.seminat.ASO[res.seminat.ASO$fp_ind=="Grazing_mowing1" & res.seminat.ASO$NiN_grunntype=="T32-C-6",]$original,na.rm=T),
       type="l", col="red")
points(res.seminat.ASO[res.seminat.ASO$fp_ind=="Grazing_mowing1" & res.seminat.ASO$NiN_grunntype=="T32-C-6",]$original,
       rep(0,length(res.seminat.ASO[res.seminat.ASO$fp_ind=="Grazing_mowing1" & res.seminat.ASO$NiN_grunntype=="T32-C-6",]$original)),
       col="red")

# T32-C-7
plot(density( as.matrix(seminat.ref.cov[['Grazing_mowing']][,c("T32-C7C8")]) ,na.rm=T),
     xlim=c(1,8), type="l", main='T32-C7',xlab='Grazing_mowing value')
#points(density(res.seminat.ASO[res.seminat.ASO$fp_ind=="Grazing_mowing1" & res.seminat.ASO$NiN_grunntype=="T32-C-7",]$original,na.rm=T),
#       type="l", col="red")
points(res.seminat.ASO[res.seminat.ASO$fp_ind=="Grazing_mowing1" & res.seminat.ASO$NiN_grunntype=="T32-C-7",]$original,
       rep(0,length(res.seminat.ASO[res.seminat.ASO$fp_ind=="Grazing_mowing1" & res.seminat.ASO$NiN_grunntype=="T32-C-7",]$original)),
       col="red")

# T32-C-8
plot(density( as.matrix(seminat.ref.cov[['Grazing_mowing']][,c("T32-C7C8")]) ,na.rm=T),
     xlim=c(1,8), type="l", main='T32-C8',xlab='Grazing_mowing value')
points(density(res.seminat.ASO[res.seminat.ASO$fp_ind=="Grazing_mowing1" & res.seminat.ASO$NiN_grunntype=="T32-C-8",]$original,na.rm=T),
       type="l", col="red")
points(res.seminat.ASO[res.seminat.ASO$fp_ind=="Grazing_mowing1" & res.seminat.ASO$NiN_grunntype=="T32-C-8",]$original,
       rep(0,length(res.seminat.ASO[res.seminat.ASO$fp_ind=="Grazing_mowing1" & res.seminat.ASO$NiN_grunntype=="T32-C-8",]$original)),
       col="red")

# T32-C-9
plot(density( as.matrix(seminat.ref.cov[['Grazing_mowing']][,c("T32-C9a","T32-C9b")]) ,na.rm=T),
     xlim=c(1,8), type="l", main='T32-C9',xlab='Grazing_mowing value')
#points(density(res.seminat.ASO[res.seminat.ASO$fp_ind=="Grazing_mowing1" & res.seminat.ASO$NiN_grunntype=="T32-C-9",]$original,na.rm=T),
#       type="l", col="red")
points(res.seminat.ASO[res.seminat.ASO$fp_ind=="Grazing_mowing1" & res.seminat.ASO$NiN_grunntype=="T32-C-9",]$original,
       rep(0,length(res.seminat.ASO[res.seminat.ASO$fp_ind=="Grazing_mowing1" & res.seminat.ASO$NiN_grunntype=="T32-C-9",]$original)),
       col="red")

# T32-C-10
plot(density( as.matrix(seminat.ref.cov[['Grazing_mowing']][,c("T32-C10a","T32-C10b")]) ,na.rm=T),
     xlim=c(1,8), type="l", main='T32-C10',xlab='Grazing_mowing value')
#points(density(res.seminat.ASO[res.seminat.ASO$fp_ind=="Grazing_mowing1" & res.seminat.ASO$NiN_grunntype=="T32-C-10",]$original,na.rm=T),
#       type="l", col="red")
points(res.seminat.ASO[res.seminat.ASO$fp_ind=="Grazing_mowing1" & res.seminat.ASO$NiN_grunntype=="T32-C-10",]$original,
       rep(0,length(res.seminat.ASO[res.seminat.ASO$fp_ind=="Grazing_mowing1" & res.seminat.ASO$NiN_grunntype=="T32-C-10",]$original)),
       col="red")


# T32-C-20
plot(density( as.matrix(seminat.ref.cov[['Grazing_mowing']][,c("T32-C5C20a","T32-C5C20b")]) ,na.rm=T),
     xlim=c(1,8), type="l", main='T32-C20',xlab='Grazing_mowing value')
points(density(res.seminat.ASO[res.seminat.ASO$fp_ind=="Grazing_mowing1" & res.seminat.ASO$NiN_grunntype=="T32-C-20",]$original,na.rm=T),
       type="l", col="red")
points(res.seminat.ASO[res.seminat.ASO$fp_ind=="Grazing_mowing1" & res.seminat.ASO$NiN_grunntype=="T32-C-20",]$original,
       rep(0,length(res.seminat.ASO[res.seminat.ASO$fp_ind=="Grazing_mowing1" & res.seminat.ASO$NiN_grunntype=="T32-C-20",]$original)),
       col="red")



#### relating scaled values to NiN condition variables ####
ggplot(res.seminat, aes(x=bruksintensitet, y=scaled_value)) +
  geom_point() +
  facet_wrap(~fp_ind, scale="fixed")

ggplot(res.seminat.ASO, aes(x="Aktuell bruksintensitet (7JB-BA)", y=scaled_value)) +
  geom_point() +
  facet_wrap(~fp_ind, scale="fixed")
