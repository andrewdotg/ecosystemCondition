#Åpen Lavland - NDVI from Sentinel

#mean NDVI for each åpen lavland NiN polygon has been calculated from each available Sentinel 2 image in Google Earth Engine. 
#The code can be seen here: https://code.earthengine.google.com/2ceb0c3e03adade9e6f6d0903184b8c4
#The image collection contains Sentinel imagery from june, july and august 2015-2022
#To not exceed GEE memory limits, the exported files had to be iterated over a grid which resulted in 42 separate csv files. This script merges them and then merges the dataframe to the NiN data.

library(data.table)
library(tidyverse)
library(sf)

#############Import NiN data
nin <- st_read("R:\\GeoSpatialData\\Habitats_biotopes\\Norway_Miljodirektoratet_Naturtyper_nin\\Original\\versjon20221231\\Natur_Naturtyper_nin_norge_med_svalbard_25833\\Natur_Naturtyper_NiN_norge_med_svalbard_25833.gdb")

colnames(nin)[c(3,8,17,26,31,33,34)] <- c("hovedoekosystem","kartleggingsaar","noyaktighet",
                                       "omraadenavn","uk_naertruet","uk_sentraloekosystemfunksjon",
                                       "uk_spesieltdaarligkartlagt")
unique(nin$hovedoekosystem)
nin$hovedoekosystem <- as.factor(nin$hovedoekosystem)
levels(nin$hovedoekosystem)
levels(nin$hovedoekosystem)[c(3,4,6)] <- c("Vaatmark","Naturlig_aapne_lav","Naturlig_aapne_uskog")

nin <- nin %>%
  mutate(hovedoekosystem = recode(hovedoekosystem, 
                                 "Våtmark" = 'Vaatmark',
                                 "Skog" = "Skog",
                                 "Ingen" = "Ingen",
                                 "Fjell" = "Fjell",
                                 "Semi-naturlig mark" = 'Semi-naturlig',
                                 "Naturlig åpne områder i lavlandet" = 'Naturlig_aapne_lav',
                                 "Naturlig åpne områder under skoggrensa" = 'Naturlig_aapne_uskog'))




nin[nin$hovedoekosystem=="Fjell",]
unique(nin[nin$hovedoekosystem=="Naturlig åpne områder i lavlandet","naturtype"])



nin %>% 
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


