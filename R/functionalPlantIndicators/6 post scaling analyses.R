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
res.wetland <- results.wetland[['2-sided']]
st_geometry(res.wetland) <- st_geometry(ANO.wetland)


nor <- readRDS('P:/41201785_okologisk_tilstand_2022_2023/data/rds/norway_outline.RDS')%>%
  st_as_sf()


## scaled value maps
# Moist1 (lower indicator)
tm_shape(nor) +
  tm_fill('GID_0', labels="", title="") + #tm_borders() +
  tm_shape(res.wetland) +
  tm_dots('Moist1',midpoint=NA, palette=tmaptools::get_brewer_pal("YlOrRd", 7, plot = FALSE), scale=1, legend.show = FALSE) + # 
  tm_layout(main.title = "Moisture index (lower), wetland",legend.position = c("right", "bottom"), main.title.size=1.2) + 
  tm_add_legend(type = "fill", 
                col = c(tmaptools::get_brewer_pal("YlOrRd", 5, plot = FALSE),'grey'),
                labels = c("0.4", "...", "...", 
                           "...", "1", "NA"),
                title = "index values")

# Moist2 (upper indicator)
tm_shape(nor) +
  tm_fill('GID_0', labels="", title="") + #tm_borders() +
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


