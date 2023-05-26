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

## Import region- og Norgeskart
nor <- st_read("data/outlineOfNorway_EPSG25833.shp")%>%
  st_as_sf() %>%
  st_transform(crs = st_crs(nin))

reg <- st_read("data/regions.shp")%>%
  st_as_sf() %>%
  st_transform(crs = st_crs(nin))

# change region names to something R-friendly
reg$region
reg$region <- c("Northern Norway","Central Norway","Eastern Norway","Western Norway","Southern Norway")

regnor <- st_intersection(reg,nor)

## Import Landsat NDVI Data
# Set up conditional file paths
dir <- substr(getwd(), 1,2)

path <- ifelse(dir == "C:", 
               "R:/GeoSpatialData/Habitats_biotopes/Norway_Miljodirektoratet_Naturtyper_nin/Original/versjon20221231/Natur_Naturtyper_nin_norge_med_svalbard_25833/Natur_Naturtyper_NiN_norge_med_svalbard_25833.gdb",
               "/data/R/GeoSpatialData/Habitats_biotopes/Norway_Miljodirektoratet_Naturtyper_nin/Original/versjon20221231/Natur_Naturtyper_nin_norge_med_svalbard_25833/Natur_Naturtyper_NiN_norge_med_svalbard_25833.gdb")

pData <- ifelse(dir == "C:", 
                "P:/41201785_okologisk_tilstand_2022_2023/data/NDVI_åpenlavland/NDVI_data_Landsat",
                "/data/P-Prosjekter2/41201785_okologisk_tilstand_2022_2023/data/NDVI_åpenlavland/NDVI_data_Landsat")


## Fread doesn't like the weird path to the server version of the P drive
## hence this horrendous work around (there must be an easier way than this but I kept hitting dead-ends)
files=list.files(pData, pattern = "*.csv", full.names = TRUE)

df_list<-list()# initialise a list of dataframes
# read in a dataframe in each slot of the df_list
for (i in files){
  name <- gsub("-",".",i)
  name <- gsub(".csv","",name)  
  i <- paste(i,sep="")
  df_list[[i]]=assign(name,read.csv(i, header=TRUE))
}  

df.l<-bind_rows(df_list, .id = "column_label")
df.l

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



## filter out only wetland data
nin.wetland <- nin %>% 
  filter(hovedoekosystem %in% c('Vaatmark')) %>%
  mutate(id = identifikasjon_lokalid) %>%
  filter(validGeo) %>%
  drop_na(tilstand) %>%
  dplyr::select(id, hovedoekosystem, hovedtype, ninkartleggingsenheter, lokalitetskvalitet, tilstand, kartleggingsaar)


# merge NiN-data with region
nin.wetland = st_join(nin.wetland, regnor, left = TRUE)
nin.wetland

nin.wetland %>% 
  mutate(area_meters = st_area(nin.wetland)
  )



## filter out only seminat data
nin.seminat <- nin %>% 
  filter(hovedoekosystem %in% c('Semi_naturlig')) %>%
  mutate(id = identifikasjon_lokalid) %>%
  filter(validGeo) %>%
  drop_na(tilstand) %>%
  dplyr::select(id, hovedoekosystem, hovedtype, ninkartleggingsenheter, lokalitetskvalitet, tilstand, kartleggingsaar)

# merge NiN-data with region
nin.seminat = st_join(nin.seminat, regnor, left = TRUE)
nin.seminat

nin.seminat %>% 
  mutate(area_meters = st_area(nin.seminat)
  )

## filter out only naturally open data
nin.natopen <- nin %>% 
  filter(hovedoekosystem %in% c('Naturlig_aapent')) %>%
  mutate(id = identifikasjon_lokalid) %>%
  filter(validGeo) %>%
  drop_na(tilstand) %>%
  dplyr::select(id, hovedoekosystem, hovedtype, ninkartleggingsenheter, lokalitetskvalitet, tilstand, kartleggingsaar)

# merge NiN-data with region
nin.natopen = st_join(nin.natopen, regnor, left = TRUE)
nin.natopen

nin.natopen %>% 
  mutate(area_meters = st_area(nin.natopen)
  )


#### join NiN and NDVI data ####


## wetland
LandsatNDVI.wetland <- full_join(nin.wetland, df.l, by="id")

summary(LandsatNDVI.wetland)
LandsatNDVI.wetland <- LandsatNDVI.wetland %>%
  mutate(hovedoekosystem = as.factor(hovedoekosystem),
         hovedtype = as.factor(hovedtype),
         ninkartleggingsenheter = as.factor(ninkartleggingsenheter), 
         lokalitetskvalitet = as.factor(lokalitetskvalitet),
         tilstand = as.factor(tilstand),
         area_meters = st_area(LandsatNDVI.wetland))
summary(LandsatNDVI.wetland)
# get rid of NAs (i.e. NDVI cells that were not in wetland polygons)
LandsatNDVI.wetland <- LandsatNDVI.wetland %>% filter(!is.na(hovedtype))
LandsatNDVI.wetland <- LandsatNDVI.wetland %>% filter(!is.na(mean))
summary(LandsatNDVI.wetland)

# split date into year, month & day
LandsatNDVI.wetland <- LandsatNDVI.wetland %>%
  dplyr::mutate(year = lubridate::year(date), 
                month = lubridate::month(date), 
                day = lubridate::day(date))

summary(LandsatNDVI.wetland)


## seminat
LandsatNDVI.seminat <- full_join(nin.seminat, df.l, by="id")

summary(LandsatNDVI.seminat)
LandsatNDVI.seminat <- LandsatNDVI.seminat %>%
  mutate(hovedoekosystem = as.factor(hovedoekosystem),
         hovedtype = as.factor(hovedtype),
         ninkartleggingsenheter = as.factor(ninkartleggingsenheter), 
         lokalitetskvalitet = as.factor(lokalitetskvalitet),
         tilstand = as.factor(tilstand),
         area_meters = st_area(LandsatNDVI.seminat))
summary(LandsatNDVI.seminat)
# get rid of NAs (i.e. NDVI cells that were not in wetland polygons)
LandsatNDVI.seminat <- LandsatNDVI.seminat %>% filter(!is.na(hovedtype))
LandsatNDVI.seminat <- LandsatNDVI.seminat %>% filter(!is.na(mean))
summary(LandsatNDVI.seminat)

# split date into year, month & day
LandsatNDVI.seminat <- LandsatNDVI.seminat %>%
  dplyr::mutate(year = lubridate::year(date), 
                month = lubridate::month(date), 
                day = lubridate::day(date))

summary(LandsatNDVI.seminat)


## naturally open
LandsatNDVI.natopen <- full_join(nin.natopen, df.l, by="id")

summary(LandsatNDVI.natopen)
LandsatNDVI.natopen <- LandsatNDVI.natopen %>%
  mutate(hovedoekosystem = as.factor(hovedoekosystem),
         hovedtype = as.factor(hovedtype),
         ninkartleggingsenheter = as.factor(ninkartleggingsenheter), 
         lokalitetskvalitet = as.factor(lokalitetskvalitet),
         tilstand = as.factor(tilstand),
         area_meters = st_area(LandsatNDVI.natopen))
summary(LandsatNDVI.natopen)
# get rid of NAs (i.e. NDVI cells that were not in wetland polygons)
LandsatNDVI.natopen <- LandsatNDVI.natopen %>% filter(!is.na(hovedtype))
LandsatNDVI.natopen <- LandsatNDVI.natopen %>% filter(!is.na(mean))
summary(LandsatNDVI.natopen)

# split date into year, month & day
LandsatNDVI.natopen <- LandsatNDVI.natopen %>%
  dplyr::mutate(year = lubridate::year(date), 
                month = lubridate::month(date), 
                day = lubridate::day(date))

summary(LandsatNDVI.natopen)


#### continue here ####




