#Åpen Lavland - NDVI from Sentinel

#mean NDVI for each åpen lavland NiN polygon has been calculated from each available Sentinel 2 image in Google Earth Engine. 
#The code can be seen here: https://code.earthengine.google.com/2ceb0c3e03adade9e6f6d0903184b8c4
#The image collection contains Sentinel imagery from june, july and august 2015-2022
#To not exceed GEE memory limits, the exported files had to be iterated over a grid which resulted in 42 separate csv files. This script merges them and then merges the dataframe to the NiN data.

library(data.table)
library(stringr, lib.loc = "/usr/lib/R/site-library")
library(tidyverse, lib.loc = "/usr/local/lib/R/site-library")
#library(tidyverse)
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


##############Import Sentinel NDVI Data
df <-
  list.files("P:\\41201785_okologisk_tilstand_2022_2023\\data\\NDVI_åpenlavland\\NDVI_data_Sentinel\\", pattern = "*.csv") %>%
  map_df(~fread(.))
df

##########join NiN and NDVI data
SentinelNDVI <- full_join(nin, df, by="id")
