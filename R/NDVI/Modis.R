#Åpen Lavland - NDVI from MODIS

#mean NDVI for each åpen lavland NiN polygon has been calculated from each available MODIS image in Google Earth Engine. 
#The code can be seen here: https://code.earthengine.google.com/efb84013701f1d5f6e1e81345f389b84
#The image collection contains MODIS imagery from june, july and august 2000-2022


library(data.table)
library(tidyverse)
library(sf)

#############Import NiN data

nin <- st_read("R:\\GeoSpatialData\\Habitats_biotopes\\Norway_Miljodirektoratet_Naturtyper_nin\\Original\\versjon20221231\\Natur_Naturtyper_nin_norge_med_svalbard_25833\\Natur_Naturtyper_NiN_norge_med_svalbard_25833.gdb")%>%
  mutate(hovedøkosystem = recode(hovedøkosystem, 
                                 "Våtmark" = 'Våtmark',
                                 "Skog" = "Skog",
                                 "Ingen" = "Ingen",
                                 "Fjell" = "Fjell",
                                 "Semi-naturlig mark" = 'Semi-naturlig',
                                 "Naturlig åpne områder i lavlandet" = 'Naturlig åpne',
                                 "Naturlig åpne områder under skoggrensa" = 'Naturlig åpne')) %>% 
  mutate(validGeo = st_is_valid(SHAPE)) %>%
  filter(!hovedøkosystem %in% c('Skog','Ingen','Fjell')) %>%
  mutate(hovedtype = substr(ninkartleggingsenheter, 4, 6),
         hovedtype = str_remove(hovedtype, '-'),
         id = identifikasjon_lokalid) %>%
  filter(validGeo) %>%
  drop_na(tilstand) %>%
  dplyr::select(id, hovedøkosystem, hovedtype, naturtypekode, tilstand)

nin
##############Import MODIS NDVI Data
#MODIS NDVI is scaled by 0.0001. Mean must be divided by 10000.
df<- read.csv("P:\\41201785_okologisk_tilstand_2022_2023\\data\\NDVI_åpenlavland\\NDVI_data_MODIS\\modis_ndvi_ts_2000_2022.csv", )
df
df$mean<-df$mean/10000
df

##########join NiN and NDVI data
MODISNDVI <- full_join(nin, df, by="id")
