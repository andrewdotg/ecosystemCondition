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

# fixing variable- and ecosystem-names with special characters
colnames(nin)
colnames(nin)[c(3,8,17,26,31,33,34)] <- c("hovedoekosystem","kartleggingsaar","noyaktighet",
                                       "omraadenavn","uk_naertruet","uk_sentraloekosystemfunksjon",
                                       "uk_spesieltdaarligkartlagt")
unique(nin$hovedoekosystem)

nin <- nin %>% mutate(hovedoekosystem = recode(hovedoekosystem, 
                                 "Våtmark" = 'Vaatmark',
                                 "Semi-naturlig mark" = 'Semi_naturlig',
                                 "Naturlig åpne områder i lavlandet" = 'Naturlig-aapne',
                                 "Naturlig åpne områder under skoggrensa" = 'Naturlig_aapne')) %>%
  mutate(validGeo = st_is_valid(SHAPE))

# checking how many polygons have multiple ecosystem types
unique(nin$ninkartleggingsenheter)

nrow(nin)
# 95469 polygons altogether
nrow(nin %>%
  filter(grepl(',', ninkartleggingsenheter))
)
# 21094 polygons have more than 1 ecosystem type (they are separated by commas in the ninkartleggingsenheter-variable)

nrow(nin %>%
       filter(!grepl(',', ninkartleggingsenheter))
)
# 74375 polygons should have only 1 ecosystem type

# there's no information on the proportion of ecosystem types in the polygons, so we got to omit all polygons with multiple ecosystem types :(
nin <- nin %>%
  filter(!grepl(',', ninkartleggingsenheter))

# fix the content in the ninkartleggingsenheter-variable
summary(as.factor(nin$ninkartleggingsenheter))
# get rid of the NA- in the beginning
nin <- nin %>% mutate(ninkartleggingsenheter = str_remove(ninkartleggingsenheter, 'NA_'))
# making a main ecosystem type variable
nin <- nin %>% mutate(hovedtype = substr(ninkartleggingsenheter, 1, 3),
               hovedtype = str_remove(hovedtype, '-'))
# checking mapping unit against main ecosystem type
nin[,c("hovedoekosystem","hovedtype")]
summary(as.factor(nin$hovedtype[nin$hovedoekosystem=="Vaatmark"]))
summary(as.factor(nin$hovedtype[nin$hovedoekosystem=="Semi-naturlig"]))
summary(as.factor(nin$hovedtype[nin$hovedoekosystem=="Naturlig_aapne"]))
# making a new variable for the overarching ecosystem types based on the main ecosystem types


#### continue here ####






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


