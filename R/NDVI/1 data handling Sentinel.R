#Åpen Lavland - NDVI from Sentinel

#mean NDVI for each åpen lavland NiN polygon has been calculated from each available Sentinel 2 image in Google Earth Engine. 
#The code can be seen here: https://code.earthengine.google.com/2ceb0c3e03adade9e6f6d0903184b8c4
#The image collection contains Sentinel imagery from june, july and august 2015-2022
#To not exceed GEE memory limits, the exported files had to be iterated over a grid which resulted in 42 separate csv files. This script merges them and then merges the dataframe to the NiN data.

library(data.table)
library(tidyverse)
library(lubridate)
library(sf)

#### data import ####
## Import NiN data
nin <- st_read("R:\\GeoSpatialData\\Habitats_biotopes\\Norway_Miljodirektoratet_Naturtyper_nin\\Original\\versjon20221231\\Natur_Naturtyper_nin_norge_med_svalbard_25833\\Natur_Naturtyper_NiN_norge_med_svalbard_25833.gdb")
#nin.andel <- st_read("P:/41201785_okologisk_tilstand_2022_2023/data/NiN/naturtyper_nin_20230516.gdb/naturtyper_nin_20230516.gdb")

## Import Sentinel NDVI Data
df <- list.files("P:/41201785_okologisk_tilstand_2022_2023/data/NDVI_åpenlavland/NDVI_data_Sentinel/", pattern = "*.csv", full.names=TRUE) %>%
  map_df(~fread(.))
df

#### data handling NiN ####

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
summary(as.factor(nin$hovedtype[nin$hovedoekosystem=="Semi_naturlig"]))
summary(as.factor(nin$hovedtype[nin$hovedoekosystem=="Naturlig_aapne"]))
summary(as.factor(nin$hovedtype[nin$hovedoekosystem=="Skog"]))
summary(as.factor(nin$hovedtype[nin$hovedoekosystem=="Fjell"]))
# making a new variable for the overarching ecosystem types based on the main ecosystem types
nin$hovedoekosystem.orig <- nin$hovedoekosystem

nin <- nin %>%
  mutate(hovedoekosystem = case_when(hovedtype %in% paste("V",c(1,3:7,9:10),sep="") ~ 'Vaatmark',
                                     hovedtype %in% paste("V",11:13,sep="") ~ 'Vaatmark_sterkt_endret',
                                     hovedtype %in% paste("T",c(31:34,40:41),sep="") ~ 'Semi_naturlig',
                                     hovedtype %in% paste("T",c(2,12,18,20:21),sep="") ~ 'Naturlig_aapent',
                                     hovedtype %in% c(paste("T",c(4,30,38),sep=""),paste("V",c(2,8),sep="")) ~ 'Skog',
                                     hovedtype %in% c(paste("T",c(3,7,9,10,14,22,26),sep=""),paste("V",c(6,7),sep="")) ~ 'Fjell',
                                     TRUE ~ 'NA'))

# need to split the ninbeskrivelsesvariabler-column into one per variable and these then into two for the variable name and value
levels(as.factor(nin$ninbeskrivelsesvariabler))

nin2 <- nin %>% separate_rows(ninbeskrivelsesvariabler, sep=",") %>%
  separate(col = ninbeskrivelsesvariabler,
           into = c("NiN_variable_code", "NiN_variable_value"),
           sep = "_",
           remove=F) %>%
  mutate(NiN_variable_value = as.numeric(NiN_variable_value)) %>%
  mutate(NiN_variable_code = as.factor(NiN_variable_code))

nin2$NiN_variable_code <- as.factor(paste0("var_", nin2$NiN_variable_code, "_end",sep=""))

nin3 <- nin2 %>%
  pivot_wider(
    names_from = "NiN_variable_code",
    values_from = "NiN_variable_value"
  )
# this does not do what it is expected to do. nrow(nin3) should go down towards nrow(nin), but it stays at almost nrow(nin2)
# continue with nin for now, ignoring the beskrivelsesvariabler and only using information from 'tilstand'
rm(nin2)
rm(nin3)
summary(as.factor(nin$tilstand))

nin <- nin %>% mutate(tilstand = recode(tilstand,
                                        "Dårlig" = "Redusert",
                                        "Svært redusert" = "Svaert_redusert"))
summary(as.factor(nin$tilstand))




#### wetland data ####
## filter out only wetland data
nin.wetland <- nin %>% 
  filter(hovedoekosystem %in% c('Vaatmark')) %>%
  mutate(id = identifikasjon_lokalid) %>%
  filter(validGeo) %>%
  drop_na(tilstand) %>%
  dplyr::select(id, hovedoekosystem, hovedtype, ninkartleggingsenheter, lokalitetskvalitet, tilstand, kartleggingsaar)

nin.wetland %>% 
  mutate(area_meters = st_area(nin.wetland)
  )

## join NiN and NDVI data
SentinelNDVI.wetland <- full_join(nin.wetland, df, by="id")

summary(SentinelNDVI.wetland)
SentinelNDVI.wetland <- SentinelNDVI.wetland %>%
  mutate(hovedoekosystem = as.factor(hovedoekosystem),
         hovedtype = as.factor(hovedtype),
         ninkartleggingsenheter = as.factor(ninkartleggingsenheter), 
         lokalitetskvalitet = as.factor(lokalitetskvalitet),
         tilstand = as.factor(tilstand),
         area_meters = st_area(SentinelNDVI.wetland))
summary(SentinelNDVI.wetland)
# get rid of NAs (i.e. NDVI cells that were not in wetland polygons)
SentinelNDVI.wetland <- SentinelNDVI.wetland %>% filter(!is.na(hovedtype))
SentinelNDVI.wetland <- SentinelNDVI.wetland %>% filter(!is.na(mean))
summary(SentinelNDVI.wetland)

# split date into year, month & day
SentinelNDVI.wetland <- SentinelNDVI.wetland %>%
  dplyr::mutate(year = lubridate::year(date), 
                month = lubridate::month(date), 
                day = lubridate::day(date))

summary(SentinelNDVI.wetland)


#### seminat data ####
## filter out only wetland data
nin.seminat <- nin %>% 
  filter(hovedoekosystem %in% c('Semi_naturlig')) %>%
  mutate(id = identifikasjon_lokalid) %>%
  filter(validGeo) %>%
  drop_na(tilstand) %>%
  dplyr::select(id, hovedoekosystem, hovedtype, ninkartleggingsenheter, lokalitetskvalitet, tilstand, kartleggingsaar)

nin.seminat %>% 
  mutate(area_meters = st_area(nin.seminat)
  )

## join NiN and NDVI data
SentinelNDVI.seminat <- full_join(nin.seminat, df, by="id")

summary(SentinelNDVI.seminat)
SentinelNDVI.seminat <- SentinelNDVI.seminat %>%
  mutate(hovedoekosystem = as.factor(hovedoekosystem),
         hovedtype = as.factor(hovedtype),
         ninkartleggingsenheter = as.factor(ninkartleggingsenheter), 
         lokalitetskvalitet = as.factor(lokalitetskvalitet),
         tilstand = as.factor(tilstand),
         area_meters = st_area(SentinelNDVI.seminat))
summary(SentinelNDVI.seminat)
# get rid of NAs (i.e. NDVI cells that were not in wetland polygons)
SentinelNDVI.seminat <- SentinelNDVI.seminat %>% filter(!is.na(hovedtype))
SentinelNDVI.seminat <- SentinelNDVI.seminat %>% filter(!is.na(mean))
summary(SentinelNDVI.seminat)

# split date into year, month & day
SentinelNDVI.seminat <- SentinelNDVI.seminat %>%
  dplyr::mutate(year = lubridate::year(date), 
                month = lubridate::month(date), 
                day = lubridate::day(date))

summary(SentinelNDVI.seminat)


#### naturally open data ####
## filter out only wetland data
nin.natopen <- nin %>% 
  filter(hovedoekosystem %in% c('Naturlig_aapent')) %>%
  mutate(id = identifikasjon_lokalid) %>%
  filter(validGeo) %>%
  drop_na(tilstand) %>%
  dplyr::select(id, hovedoekosystem, hovedtype, ninkartleggingsenheter, lokalitetskvalitet, tilstand, kartleggingsaar)

nin.natopen %>% 
  mutate(area_meters = st_area(nin.natopen)
  )

## join NiN and NDVI data
SentinelNDVI.natopen <- full_join(nin.natopen, df, by="id")

summary(SentinelNDVI.natopen)
SentinelNDVI.natopen <- SentinelNDVI.natopen %>%
  mutate(hovedoekosystem = as.factor(hovedoekosystem),
         hovedtype = as.factor(hovedtype),
         ninkartleggingsenheter = as.factor(ninkartleggingsenheter), 
         lokalitetskvalitet = as.factor(lokalitetskvalitet),
         tilstand = as.factor(tilstand),
         area_meters = st_area(SentinelNDVI.natopen))
summary(SentinelNDVI.natopen)
# get rid of NAs (i.e. NDVI cells that were not in wetland polygons)
SentinelNDVI.natopen <- SentinelNDVI.natopen %>% filter(!is.na(hovedtype))
SentinelNDVI.natopen <- SentinelNDVI.natopen %>% filter(!is.na(mean))
summary(SentinelNDVI.natopen)

# split date into year, month & day
SentinelNDVI.natopen <- SentinelNDVI.natopen %>%
  dplyr::mutate(year = lubridate::year(date), 
                month = lubridate::month(date), 
                day = lubridate::day(date))

summary(SentinelNDVI.natopen)


#### continue here ####




