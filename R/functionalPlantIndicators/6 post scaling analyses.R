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
    values_drop_na = TRUE
  )


# summarizing the indicator scores
res.wetland %>%
  group_by(fp_ind) %>%
  dplyr::summarize(Mean = mean(scaled_value, na.rm=TRUE))


# making the plot
ggplot(res.wetland, aes(x=factor(hovedtype_rute), y=scaled_value, fill=fp_ind)) + 
  geom_hline(yintercept=0.6, linetype="dashed") + 
  geom_violin() +
#  geom_boxplot(width=0.2, color="grey") +
  geom_point(size=0.7, shape=16, color="grey") +
  facet_wrap(~factor(fp_ind,levels=c("Light1","Moist1","pH1","Nitrogen1","Light2","Moist2","pH2","Nitrogen2")), ncol = 4) + 
  xlab("Main ecosystem type") + 
  ylab("Scaled indicator value") 












#### getting scaled AND original values ####
res.wetland <- results.wetland[['2-sided']]

# make long version of the scaled value part
res.wetland <-
  res.wetland %>% 
  pivot_longer(
    cols = c("Light1","Light2","Moist1","Moist2","pH1","pH2","Nitrogen1","Nitrogen2"),
    names_to = "fp_ind",
    values_to = "scaled_value",
    values_drop_na = TRUE
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

head(res.wetland[,70:76])


#### scaled value maps ####
# keep wide format and add geometry again
res.wetland2 <- results.wetland[['2-sided']]
st_geometry(res.wetland2) <- st_geometry(ANO.wetland)

nor <- readRDS('P:/41201785_okologisk_tilstand_2022_2023/data/rds/norway_outline.RDS')%>%
  st_as_sf() %>%
  st_transform(crs = crs(ANO.geo))
reg <- st_read("P:/41201785_okologisk_tilstand_2022_2023/data/regioner/regNorway_wgs84 - MERGED.shp")%>%
  st_as_sf() %>%
  st_transform(crs = crs(ANO.geo))
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

res.wetland2 %>% 
  group_by(as.factor(region)) %>% 
  dplyr::summarise(Light1.reg.mean = mean(Light1,na.rm=T))

res.wetland2 %>% 
  group_by(as.factor(region)) %>% 
  dplyr::summarise(Light2.reg.mean = mean(Light2,na.rm=T))
  


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
  


regnor <- regnor %>%
  mutate(Light1.reg.mean = c(mean(res.wetland2$Light1[res.wetland2$region=="Northern Norway"],na.rm=T),
                             mean(res.wetland2$Light1[res.wetland2$region=="Central Norway"],na.rm=T),
                             mean(res.wetland2$Light1[res.wetland2$region=="Eastern Norway"],na.rm=T),
                             mean(res.wetland2$Light1[res.wetland2$region=="Western Norway"],na.rm=T),
                             mean(res.wetland2$Light1[res.wetland2$region=="Southern Norway"],na.rm=T)),
         Light2.reg.mean = c(mean(res.wetland2$Light2[res.wetland2$region=="Northern Norway"],na.rm=T),
                             mean(res.wetland2$Light2[res.wetland2$region=="Central Norway"],na.rm=T),
                             mean(res.wetland2$Light2[res.wetland2$region=="Eastern Norway"],na.rm=T),
                             mean(res.wetland2$Light2[res.wetland2$region=="Western Norway"],na.rm=T),
                             mean(res.wetland2$Light2[res.wetland2$region=="Southern Norway"],na.rm=T)),
         Moist1.reg.mean = c(mean(res.wetland2$Moist1[res.wetland2$region=="Northern Norway"],na.rm=T),
                             mean(res.wetland2$Moist1[res.wetland2$region=="Central Norway"],na.rm=T),
                             mean(res.wetland2$Moist1[res.wetland2$region=="Eastern Norway"],na.rm=T),
                             mean(res.wetland2$Moist1[res.wetland2$region=="Western Norway"],na.rm=T),
                             mean(res.wetland2$Moist1[res.wetland2$region=="Southern Norway"],na.rm=T)),
         Moist2.reg.mean = c(mean(res.wetland2$Moist2[res.wetland2$region=="Northern Norway"],na.rm=T),
                             mean(res.wetland2$Moist2[res.wetland2$region=="Central Norway"],na.rm=T),
                             mean(res.wetland2$Moist2[res.wetland2$region=="Eastern Norway"],na.rm=T),
                             mean(res.wetland2$Moist2[res.wetland2$region=="Western Norway"],na.rm=T),
                             mean(res.wetland2$Moist2[res.wetland2$region=="Southern Norway"],na.rm=T)),
         pH1.reg.mean = c(mean(res.wetland2$pH1[res.wetland2$region=="Northern Norway"],na.rm=T),
                             mean(res.wetland2$pH1[res.wetland2$region=="Central Norway"],na.rm=T),
                             mean(res.wetland2$pH1[res.wetland2$region=="Eastern Norway"],na.rm=T),
                             mean(res.wetland2$pH1[res.wetland2$region=="Western Norway"],na.rm=T),
                             mean(res.wetland2$pH1[res.wetland2$region=="Southern Norway"],na.rm=T)),
         pH2.reg.mean = c(mean(res.wetland2$pH2[res.wetland2$region=="Northern Norway"],na.rm=T),
                             mean(res.wetland2$pH2[res.wetland2$region=="Central Norway"],na.rm=T),
                             mean(res.wetland2$pH2[res.wetland2$region=="Eastern Norway"],na.rm=T),
                             mean(res.wetland2$pH2[res.wetland2$region=="Western Norway"],na.rm=T),
                             mean(res.wetland2$pH2[res.wetland2$region=="Southern Norway"],na.rm=T)),
         Nitrogen1.reg.mean = c(mean(res.wetland2$Nitrogen1[res.wetland2$region=="Northern Norway"],na.rm=T),
                             mean(res.wetland2$Nitrogen1[res.wetland2$region=="Central Norway"],na.rm=T),
                             mean(res.wetland2$Nitrogen1[res.wetland2$region=="Eastern Norway"],na.rm=T),
                             mean(res.wetland2$Nitrogen1[res.wetland2$region=="Western Norway"],na.rm=T),
                             mean(res.wetland2$Nitrogen1[res.wetland2$region=="Southern Norway"],na.rm=T)),
         Nitrogen2.reg.mean = c(mean(res.wetland2$Nitrogen2[res.wetland2$region=="Northern Norway"],na.rm=T),
                             mean(res.wetland2$Nitrogen2[res.wetland2$region=="Central Norway"],na.rm=T),
                             mean(res.wetland2$Nitrogen2[res.wetland2$region=="Eastern Norway"],na.rm=T),
                             mean(res.wetland2$Nitrogen2[res.wetland2$region=="Western Norway"],na.rm=T),
                             mean(res.wetland2$Nitrogen2[res.wetland2$region=="Southern Norway"],na.rm=T)),
         
         Light1.reg.sd = c(sd(res.wetland2$Light1[res.wetland2$region=="Northern Norway"],na.rm=T),
                             sd(res.wetland2$Light1[res.wetland2$region=="Central Norway"],na.rm=T),
                             sd(res.wetland2$Light1[res.wetland2$region=="Eastern Norway"],na.rm=T),
                             sd(res.wetland2$Light1[res.wetland2$region=="Western Norway"],na.rm=T),
                             sd(res.wetland2$Light1[res.wetland2$region=="Southern Norway"],na.rm=T)),
         Light2.reg.sd = c(sd(res.wetland2$Light2[res.wetland2$region=="Northern Norway"],na.rm=T),
                             sd(res.wetland2$Light2[res.wetland2$region=="Central Norway"],na.rm=T),
                             sd(res.wetland2$Light2[res.wetland2$region=="Eastern Norway"],na.rm=T),
                             sd(res.wetland2$Light2[res.wetland2$region=="Western Norway"],na.rm=T),
                             sd(res.wetland2$Light2[res.wetland2$region=="Southern Norway"],na.rm=T)),
         Moist1.reg.sd = c(sd(res.wetland2$Moist1[res.wetland2$region=="Northern Norway"],na.rm=T),
                             sd(res.wetland2$Moist1[res.wetland2$region=="Central Norway"],na.rm=T),
                             sd(res.wetland2$Moist1[res.wetland2$region=="Eastern Norway"],na.rm=T),
                             sd(res.wetland2$Moist1[res.wetland2$region=="Western Norway"],na.rm=T),
                             sd(res.wetland2$Moist1[res.wetland2$region=="Southern Norway"],na.rm=T)),
         Moist2.reg.sd = c(sd(res.wetland2$Moist2[res.wetland2$region=="Northern Norway"],na.rm=T),
                             sd(res.wetland2$Moist2[res.wetland2$region=="Central Norway"],na.rm=T),
                             sd(res.wetland2$Moist2[res.wetland2$region=="Eastern Norway"],na.rm=T),
                             sd(res.wetland2$Moist2[res.wetland2$region=="Western Norway"],na.rm=T),
                             sd(res.wetland2$Moist2[res.wetland2$region=="Southern Norway"],na.rm=T)),
         pH1.reg.sd = c(sd(res.wetland2$pH1[res.wetland2$region=="Northern Norway"],na.rm=T),
                          sd(res.wetland2$pH1[res.wetland2$region=="Central Norway"],na.rm=T),
                          sd(res.wetland2$pH1[res.wetland2$region=="Eastern Norway"],na.rm=T),
                          sd(res.wetland2$pH1[res.wetland2$region=="Western Norway"],na.rm=T),
                          sd(res.wetland2$pH1[res.wetland2$region=="Southern Norway"],na.rm=T)),
         pH2.reg.sd = c(sd(res.wetland2$pH2[res.wetland2$region=="Northern Norway"],na.rm=T),
                          sd(res.wetland2$pH2[res.wetland2$region=="Central Norway"],na.rm=T),
                          sd(res.wetland2$pH2[res.wetland2$region=="Eastern Norway"],na.rm=T),
                          sd(res.wetland2$pH2[res.wetland2$region=="Western Norway"],na.rm=T),
                          sd(res.wetland2$pH2[res.wetland2$region=="Southern Norway"],na.rm=T)),
         Nitrogen1.reg.sd = c(sd(res.wetland2$Nitrogen1[res.wetland2$region=="Northern Norway"],na.rm=T),
                                sd(res.wetland2$Nitrogen1[res.wetland2$region=="Central Norway"],na.rm=T),
                                sd(res.wetland2$Nitrogen1[res.wetland2$region=="Eastern Norway"],na.rm=T),
                                sd(res.wetland2$Nitrogen1[res.wetland2$region=="Western Norway"],na.rm=T),
                                sd(res.wetland2$Nitrogen1[res.wetland2$region=="Southern Norway"],na.rm=T)),
         Nitrogen2.reg.sd = c(sd(res.wetland2$Nitrogen2[res.wetland2$region=="Northern Norway"],na.rm=T),
                                sd(res.wetland2$Nitrogen2[res.wetland2$region=="Central Norway"],na.rm=T),
                                sd(res.wetland2$Nitrogen2[res.wetland2$region=="Eastern Norway"],na.rm=T),
                                sd(res.wetland2$Nitrogen2[res.wetland2$region=="Western Norway"],na.rm=T),
                                sd(res.wetland2$Nitrogen2[res.wetland2$region=="Southern Norway"],na.rm=T)),
         
         Light1.reg.n = c(nrow(res.wetland2[res.wetland2$region=="Northern Norway" & !is.na(res.wetland2$Light1),]),
                             nrow(res.wetland2[res.wetland2$region=="Central Norway" & !is.na(res.wetland2$Light1),]),
                             nrow(res.wetland2[res.wetland2$region=="Eastern Norway" & !is.na(res.wetland2$Light1),]),
                             nrow(res.wetland2[res.wetland2$region=="Western Norway" & !is.na(res.wetland2$Light1),]),
                             nrow(res.wetland2[res.wetland2$region=="Southern Norway" & !is.na(res.wetland2$Light1),])),
         Light2.reg.n = c(nrow(res.wetland2[res.wetland2$region=="Northern Norway" & !is.na(res.wetland2$Light2),]),
                             nrow(res.wetland2[res.wetland2$region=="Central Norway" & !is.na(res.wetland2$Light2),]),
                             nrow(res.wetland2[res.wetland2$region=="Eastern Norway" & !is.na(res.wetland2$Light2),]),
                             nrow(res.wetland2[res.wetland2$region=="Western Norway" & !is.na(res.wetland2$Light2),]),
                             nrow(res.wetland2[res.wetland2$region=="Southern Norway" & !is.na(res.wetland2$Light2),])),
         Moist1.reg.n = c(nrow(res.wetland2[res.wetland2$region=="Northern Norway" & !is.na(res.wetland2$Moist1),]),
                             nrow(res.wetland2[res.wetland2$region=="Central Norway" & !is.na(res.wetland2$Moist1),]),
                             nrow(res.wetland2[res.wetland2$region=="Eastern Norway" & !is.na(res.wetland2$Moist1),]),
                             nrow(res.wetland2[res.wetland2$region=="Western Norway" & !is.na(res.wetland2$Moist1),]),
                             nrow(res.wetland2[res.wetland2$region=="Southern Norway" & !is.na(res.wetland2$Moist1),])),
         Moist2.reg.n = c(nrow(res.wetland2[res.wetland2$region=="Northern Norway" & !is.na(res.wetland2$Moist2),]),
                             nrow(res.wetland2[res.wetland2$region=="Central Norway" & !is.na(res.wetland2$Moist2),]),
                             nrow(res.wetland2[res.wetland2$region=="Eastern Norway" & !is.na(res.wetland2$Moist2),]),
                             nrow(res.wetland2[res.wetland2$region=="Western Norway" & !is.na(res.wetland2$Moist2),]),
                             nrow(res.wetland2[res.wetland2$region=="Southern Norway" & !is.na(res.wetland2$Moist2),])),
         pH1.reg.n = c(nrow(res.wetland2[res.wetland2$region=="Northern Norway" & !is.na(res.wetland2$pH1),]),
                          nrow(res.wetland2[res.wetland2$region=="Central Norway" & !is.na(res.wetland2$pH1),]),
                          nrow(res.wetland2[res.wetland2$region=="Eastern Norway" & !is.na(res.wetland2$pH1),]),
                          nrow(res.wetland2[res.wetland2$region=="Western Norway" & !is.na(res.wetland2$pH1),]),
                          nrow(res.wetland2[res.wetland2$region=="Southern Norway" & !is.na(res.wetland2$pH1),])),
         pH2.reg.n = c(nrow(res.wetland2[res.wetland2$region=="Northern Norway" & !is.na(res.wetland2$pH2),]),
                          nrow(res.wetland2[res.wetland2$region=="Central Norway" & !is.na(res.wetland2$pH2),]),
                          nrow(res.wetland2[res.wetland2$region=="Eastern Norway" & !is.na(res.wetland2$pH2),]),
                          nrow(res.wetland2[res.wetland2$region=="Western Norway" & !is.na(res.wetland2$pH2),]),
                          nrow(res.wetland2[res.wetland2$region=="Southern Norway" & !is.na(res.wetland2$pH2),])),
         Nitrogen1.reg.n = c(nrow(res.wetland2[res.wetland2$region=="Northern Norway" & !is.na(res.wetland2$Nitrogen1),]),
                                nrow(res.wetland2[res.wetland2$region=="Central Norway" & !is.na(res.wetland2$Nitrogen1),]),
                                nrow(res.wetland2[res.wetland2$region=="Eastern Norway" & !is.na(res.wetland2$Nitrogen1),]),
                                nrow(res.wetland2[res.wetland2$region=="Western Norway" & !is.na(res.wetland2$Nitrogen1),]),
                                nrow(res.wetland2[res.wetland2$region=="Southern Norway" & !is.na(res.wetland2$Nitrogen1),])),
         Nitrogen2.reg.n = c(nrow(res.wetland2[res.wetland2$region=="Northern Norway" & !is.na(res.wetland2$Nitrogen2),]),
                                nrow(res.wetland2[res.wetland2$region=="Central Norway" & !is.na(res.wetland2$Nitrogen2),]),
                                nrow(res.wetland2[res.wetland2$region=="Eastern Norway" & !is.na(res.wetland2$Nitrogen2),]),
                                nrow(res.wetland2[res.wetland2$region=="Western Norway" & !is.na(res.wetland2$Nitrogen2),]),
                                nrow(res.wetland2[res.wetland2$region=="Southern Norway" & !is.na(res.wetland2$Nitrogen2),]))
         )
  
  

## scaled value maps
# pH1 (lower indicator)
tm_shape(regnor) +
  tm_polygons(col="pH1.reg.mean", title="pH (lower)", style="quantile", palette=rev(get_brewer_pal(palette="OrRd", n=5, plot=FALSE)))

# Moist2 (upper indicator)
tm_shape(regnor) +
  tm_polygons(col="Light1.reg.mean", title="Light (upper)", style="quantile", palette=get_brewer_pal(palette="OrRd", n=5, plot=FALSE))

  
  tm_fill('GID_0', labels="", title="") + tm_borders() +
  tm_shape(res.wetland) +
  tm_dots('Moist2',midpoint=NA, palette=tmaptools::get_brewer_pal("YlOrRd", 7, plot = FALSE), scale=1, legend.show = FALSE) + # 
  tm_layout(main.title = "Moisture index (upper), wetland",legend.position = c("right", "bottom"), main.title.size=1.2) + 
  tm_add_legend(type = "fill", 
                col = c(tmaptools::get_brewer_pal("YlOrRd", 5, plot = FALSE),'grey'),
                labels = c("0.4", "...", "...", 
                           "...", "1", "NA"),
                title = "index values")








#### distribution comparison, reference vs. data ####
summary(results.wetland[['original']]$kartleggingsenhet_1m2) #V1-C1 & V1-C5 are the most abundant ecosystem types


x11()
par(mfrow=c(2,2))
hist(wetland.ref.cov[['Moisture']][,8],
     xlim=c(4,10),
     main='NiN reference V1-C1',xlab='Moisture value')
hist(wetland.ref.cov[['Moisture']][,28],
     xlim=c(4,10),
     ,main='NiN reference V1-C5',xlab='Moisture value')

hist(results.wetland[['original']][results.wetland[['original']]$kartleggingsenhet_1m2=="V1-C-5",'Moist1'],
     xlim=c(4,10),
     main='ANO data V1-C1',xlab='Moisture value')
hist(results.wetland[['original']][results.wetland[['original']]$kartleggingsenhet_1m2=="V1-C-5",'Moist1'],
     xlim=c(4,10),
     main='ANO data V1-C5',xlab='Moisture value')


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


