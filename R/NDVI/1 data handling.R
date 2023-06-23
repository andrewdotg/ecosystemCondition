#Åpen Lavland - NDVI from Sentinel

#mean NDVI for each åpen lavland NiN polygon has been calculated from each available Sentinel 2 image in Google Earth Engine. 
#The code can be seen here: https://code.earthengine.google.com/2ceb0c3e03adade9e6f6d0903184b8c4
#The image collection contains Sentinel imagery from june, july and august 2015-2022
#To not exceed GEE memory limits, the exported files had to be iterated over a grid which resulted in 42 separate csv files. This script merges them and then merges the dataframe to the NiN data.



#Åpen Lavland - NDVI from MODIS

#mean NDVI for each åpen lavland NiN polygon has been calculated from each available MODIS image in Google Earth Engine. 
#The code can be seen here: https://code.earthengine.google.com/efb84013701f1d5f6e1e81345f389b84
#The image collection contains MODIS imagery from june, july and august 2000-2022



#Åpen Lavland - NDVI from Landsat

#mean NDVI for each åpen lavland NiN polygon has been calculated from each available Landsat image in Google Earth Engine. 
#The code can be seen here: https://code.earthengine.google.com/da8a9279238ef26d14be08a43788b6b7
#The image collection contains Landsat imagery from june, july and august 1984-2022
#To not exceed GEE memory limits, the exported files had to be iterated over a grid which resulted in 42 separate csv files. This script merges them and then merges the dataframe to the NiN data.



library(downloader)
library(data.table)
library(lubridate)
library(sf)
library(plyr)
library(stringr)
library(tidyverse)
library(RColorBrewer)
library("gridExtra") 
library(ggridges)
library(tmap)
library(tmaptools)
library(betareg)
library(StepBeta)

#### data upload ####
### Import NiN data
nin <- st_read("R:\\GeoSpatialData\\Habitats_biotopes\\Norway_Miljodirektoratet_Naturtyper_nin\\Original\\versjon20221231\\Natur_Naturtyper_nin_norge_med_svalbard_25833\\Natur_Naturtyper_NiN_norge_med_svalbard_25833.gdb")


## alternatively download directly from kartkatalogen to P-drive
url <- "https://nedlasting.miljodirektoratet.no/Miljodata//Naturtyper_nin/FILEGDB/4326/Naturtyper_nin_0000_norge_4326_FILEGDB.zip"
download(url, dest="P:/41201785_okologisk_tilstand_2022_2023/data/Naturtyper_nin_0000_norge_4326_FILEGDB.zip", mode="wb") 
unzip ("P:/41201785_okologisk_tilstand_2022_2023/data/Naturtyper_nin_0000_norge_4326_FILEGDB.zip", 
       exdir = "P:/41201785_okologisk_tilstand_2022_2023/data/nin_data")
st_layers("P:/41201785_okologisk_tilstand_2022_2023/data/nin_data/Naturtyper_nin_0000_norge_4326_FILEGDB.gdb")
nin.2 <- st_read("P:/41201785_okologisk_tilstand_2022_2023/data/nin_data/Naturtyper_nin_0000_norge_4326_FILEGDB.gdb",
                 layer="naturtyper_nin_omr")



### Import region- og Norgeskart
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

### NDVI data
## Import Sentinel NDVI Data
df.s <- list.files("P:/41201785_okologisk_tilstand_2022_2023/data/NDVI_åpenlavland/NDVI_data_Sentinel/", pattern = "*.csv", full.names=TRUE) %>%
  map_df(~fread(.))
df.s

## Import MODIS NDVI Data
# MODIS NDVI is scaled by 0.0001. Mean must be divided by 10000.
df.m<- read.csv("P:\\41201785_okologisk_tilstand_2022_2023\\data\\NDVI_åpenlavland\\NDVI_data_MODIS\\modis_ndvi_ts_2000_2022.csv", )
df.m
df.m$mean<-df.m$mean/10000
df.m

## Import Landsat NDVI Data
# Set up conditional file paths
dir <- substr(getwd(), 1,2)

path <- ifelse(dir == "C:", 
               "R:/GeoSpatialData/Habitats_biotopes/Norway_Miljodirektoratet_Naturtyper_nin/Original/versjon20221231/Natur_Naturtyper_nin_norge_med_svalbard_25833/Natur_Naturtyper_NiN_norge_med_svalbard_25833.gdb",
               "/data/R/GeoSpatialData/Habitats_biotopes/Norway_Miljodirektoratet_Naturtyper_nin/Original/versjon20221231/Natur_Naturtyper_nin_norge_med_svalbard_25833/Natur_Naturtyper_NiN_norge_med_svalbard_25833.gdb")

pData <- ifelse(dir == "C:", 
                "P:/41201785_okologisk_tilstand_2022_2023/data/NDVI_åpenlavland/NDVI_data_Landsat",
                "/data/P-Prosjekter2/41201785_okologisk_tilstand_2022_2023/data/NDVI_åpenlavland/NDVI_data_Landsat")


# Fread doesn't like the weird path to the server version of the P drive
# hence this horrendous work around (there must be an easier way than this but I kept hitting dead-ends)
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


summary(as.factor(nin$tilstand))

nin <- nin %>% mutate(tilstand = recode(tilstand,
                                        "Dårlig" = "Redusert",
                                        "Svært redusert" = "Svaert_redusert"))
summary(as.factor(nin$tilstand))



  
# need to split the ninbeskrivelsesvariabler-column into one per variable and these then into two for the variable name and value
levels(as.factor(nin$ninbeskrivelsesvariabler))

# two attempts of doing that
nin2 <- nin %>% separate_rows(ninbeskrivelsesvariabler, sep=",") %>%
  separate(col = ninbeskrivelsesvariabler,
           into = c("NiN_variable_code", "NiN_variable_value"),
           sep = "_",
           remove=F) %>%
  mutate(NiN_variable_value = as.numeric(NiN_variable_value)) %>%
  mutate(NiN_variable_code = as.factor(NiN_variable_code)) %>%
  subset(select = -ninbeskrivelsesvariabler)

nin2 <- as.data.frame(nin2)

# or
nin2<- nin %>% 
  mutate(ninbeskrivelsesvariabler = strsplit(as.character(ninbeskrivelsesvariabler), ",")) %>% 
  unnest(ninbeskrivelsesvariabler) %>%
  separate(col=ninbeskrivelsesvariabler, into=c('NiN_variable_code', 'NiN_variable_value'), sep='_')

nin2 <- as.data.frame(nin2)

#nin2$NiN_variable_code <- as.factor(paste0("var_", nin2$NiN_variable_code, "_end",sep=""))

nin3 <- nin2 %>%
  pivot_wider(
    names_from = "NiN_variable_code",
    values_from = "NiN_variable_value"
  )

nin3 <- as.data.frame(nin3)


# continue with nin for now, ignoring the beskrivelsesvariabler and only using information from 'tilstand'
rm(nin2)
rm(nin3)




## filter out only wetland data
nin.wetland <- nin %>% 
  filter(hovedoekosystem %in% c('Vaatmark')) %>%
  mutate(id = identifikasjon_lokalid) %>%
  filter(validGeo) %>%
  drop_na(tilstand) %>%
  dplyr::select(id, hovedoekosystem, hovedtype, ninkartleggingsenheter, lokalitetskvalitet, tilstand, ninbeskrivelsesvariabler, kartleggingsaar)


# merge NiN-data with region
nin.wetland = st_join(nin.wetland, regnor, left = TRUE)
nin.wetland

colnames(nin.wetland)[c(1,9)] <- c("id","region_id")

nin.wetland <- nin.wetland %>% 
  mutate(area_meters_nin = st_area(nin.wetland)
  )
# check and edit the order of regions
levels(nin.wetland$region)
nin.wetland$region <- as.factor(nin.wetland$region)
levels(nin.wetland$region)
nin.wetland$region <- factor(nin.wetland$region, levels = c("Northern Norway","Central Norway","Eastern Norway","Western Norway","Southern Norway"))
levels(nin.wetland$region)




## filter out only seminat data
nin.seminat <- nin %>% 
  filter(hovedoekosystem %in% c('Semi_naturlig')) %>%
  mutate(id = identifikasjon_lokalid) %>%
  filter(validGeo) %>%
  drop_na(tilstand) %>%
  dplyr::select(id, hovedoekosystem, hovedtype, ninkartleggingsenheter, lokalitetskvalitet, tilstand, ninbeskrivelsesvariabler, kartleggingsaar)

# merge NiN-data with region
nin.seminat = st_join(nin.seminat, regnor, left = TRUE)
nin.seminat

colnames(nin.seminat)[c(1,9)] <- c("id","region_id")

nin.seminat <- nin.seminat %>% 
  mutate(area_meters_nin = st_area(nin.seminat)
  )
# check and edit the order of regions
levels(nin.seminat$region)
nin.seminat$region <- as.factor(nin.seminat$region)
levels(nin.seminat$region)
nin.seminat$region <- factor(nin.seminat$region, levels = c("Northern Norway","Central Norway","Eastern Norway","Western Norway","Southern Norway"))
levels(nin.seminat$region)




## filter out only naturally open data
nin.natopen <- nin %>% 
  filter(hovedoekosystem %in% c('Naturlig_aapent')) %>%
  mutate(id = identifikasjon_lokalid) %>%
  filter(validGeo) %>%
  drop_na(tilstand) %>%
  dplyr::select(id, hovedoekosystem, hovedtype, ninkartleggingsenheter, lokalitetskvalitet, tilstand, ninbeskrivelsesvariabler, kartleggingsaar)

# merge NiN-data with region
nin.natopen = st_join(nin.natopen, regnor, left = TRUE)
nin.natopen

colnames(nin.natopen)[c(1,9)] <- c("id","region_id")

nin.natopen <- nin.natopen %>% 
  mutate(area_meters_nin = st_area(nin.natopen)
  )
# check and edit the order of regions
levels(nin.wetland$region)
nin.wetland$region <- as.factor(nin.wetland$region)
levels(nin.wetland$region)
nin.wetland$region <- factor(nin.wetland$region, levels = c("Northern Norway","Central Norway","Eastern Norway","Western Norway","Southern Norway"))
levels(nin.wetland$region)





#### save and load processed NiN-data from cache ####
saveRDS(nin, "data/cache/nin.RDS")
saveRDS(nin.wetland, "data/cache/nin.wetland.RDS")
saveRDS(nin.seminat, "data/cache/nin.seminat.RDS")
saveRDS(nin.natopen, "data/cache/nin.natopen.RDS")
nin <- readRDS(paste0(here::here(),"/data/cache/nin.RDS"))
nin.wetland <- readRDS(paste0(here::here(),"/data/cache/nin.wetland.RDS"))
nin.seminat <- readRDS(paste0(here::here(),"/data/cache/nin.seminat.RDS"))
nin.natopen <- readRDS(paste0(here::here(),"/data/cache/nin.natopen.RDS"))

#### save and load raw NDVI data to and from desktop cache ####
saveRDS(df.s, "C:/Users/joachim.topper/OneDrive - NINA/Desktop/ndvi.Sentinel.raw.RDS")
saveRDS(df.m, "C:/Users/joachim.topper/OneDrive - NINA/Desktop/ndvi.Modis.raw.RDS")
saveRDS(df.l, "C:/Users/joachim.topper/OneDrive - NINA/Desktop/ndvi.Landsat.raw.RDS")
df.s <- readRDS("C:/Users/joachim.topper/OneDrive - NINA/Desktop/ndvi.Sentinel.raw.RDS")
df.m <- readRDS("C:/Users/joachim.topper/OneDrive - NINA/Desktop/ndvi.Modis.raw.RDS")
df.l <- readRDS("C:/Users/joachim.topper/OneDrive - NINA/Desktop/ndvi.Landsat.raw.RDS")

#### Sentinel NDVI data ####

## join nin.wetland & Sentinel NDVI data
SentinelNDVI.wetland <- full_join(nin.wetland, df.s, by="id")

#summary(SentinelNDVI.wetland)
SentinelNDVI.wetland <- SentinelNDVI.wetland %>%
  mutate(hovedoekosystem = as.factor(hovedoekosystem),
         hovedtype = as.factor(hovedtype),
         ninkartleggingsenheter = as.factor(ninkartleggingsenheter), 
         lokalitetskvalitet = as.factor(lokalitetskvalitet),
         tilstand = as.factor(tilstand),
         area_meters = st_area(SentinelNDVI.wetland))
#summary(SentinelNDVI.wetland)
# get rid of NAs (i.e. NDVI cells that were not in wetland polygons)
SentinelNDVI.wetland <- SentinelNDVI.wetland %>% filter(!is.na(hovedtype))
SentinelNDVI.wetland <- SentinelNDVI.wetland %>% filter(!is.na(mean))
#summary(SentinelNDVI.wetland)
# get rid of any nin-polygons smaller than the Sentinel grid cell size (100 sqm)
dim(SentinelNDVI.wetland)
SentinelNDVI.wetland <- SentinelNDVI.wetland %>% filter(as.numeric(area_meters) >= 100)
dim(SentinelNDVI.wetland)
# split date into year, month & day
SentinelNDVI.wetland <- SentinelNDVI.wetland %>%
  dplyr::mutate(year = lubridate::year(date), 
                month = lubridate::month(date), 
                day = lubridate::day(date))

#summary(SentinelNDVI.wetland)


## join nin.seminat & Sentinel NDVI data
SentinelNDVI.seminat <- full_join(nin.seminat, df.s, by="id")

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
# get rid of any nin-polygons smaller than the Sentinel grid cell size (100 sqm)
dim(SentinelNDVI.seminat)
SentinelNDVI.seminat <- SentinelNDVI.seminat %>% filter(as.numeric(area_meters) >= 100)
dim(SentinelNDVI.seminat)
# split date into year, month & day
SentinelNDVI.seminat <- SentinelNDVI.seminat %>%
  dplyr::mutate(year = lubridate::year(date), 
                month = lubridate::month(date), 
                day = lubridate::day(date))

summary(SentinelNDVI.seminat)


## join nin.natopen & Sentinel NDVI data
SentinelNDVI.natopen <- full_join(nin.natopen, df.s, by="id")

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
# get rid of any nin-polygons smaller than the Sentinel grid cell size (100 sqm)
dim(SentinelNDVI.natopen)
SentinelNDVI.natopen <- SentinelNDVI.natopen %>% filter(as.numeric(area_meters) >= 100)
dim(SentinelNDVI.natopen)
# split date into year, month & day
SentinelNDVI.natopen <- SentinelNDVI.natopen %>%
  dplyr::mutate(year = lubridate::year(date), 
                month = lubridate::month(date), 
                day = lubridate::day(date))

summary(SentinelNDVI.natopen)



#### Modis NDVI data ####

## join nin.wetland and Modis NDVI data
ModisNDVI.wetland <- full_join(nin.wetland, df.m, by="id")

#summary(ModisNDVI.wetland)
ModisNDVI.wetland <- ModisNDVI.wetland %>%
  mutate(hovedoekosystem = as.factor(hovedoekosystem),
         hovedtype = as.factor(hovedtype),
         ninkartleggingsenheter = as.factor(ninkartleggingsenheter), 
         lokalitetskvalitet = as.factor(lokalitetskvalitet),
         tilstand = as.factor(tilstand),
         area_meters = st_area(ModisNDVI.wetland))
#summary(ModisNDVI.wetland)
# get rid of NAs (i.e. NDVI cells that were not in wetland polygons)
ModisNDVI.wetland <- ModisNDVI.wetland %>% filter(!is.na(hovedtype))
ModisNDVI.wetland <- ModisNDVI.wetland %>% filter(!is.na(mean))
#summary(ModisNDVI.wetland)
# get rid of any nin-polygons smaller than the Modis grid cell size (62500 sqm)
dim(ModisNDVI.wetland)
ModisNDVI.wetland <- ModisNDVI.wetland %>% filter(as.numeric(area_meters) >= 62500)
dim(ModisNDVI.wetland)
# split date into year, month & day
ModisNDVI.wetland <- ModisNDVI.wetland %>%
  dplyr::mutate(year = lubridate::year(date), 
                month = lubridate::month(date), 
                day = lubridate::day(date))

#summary(ModisNDVI.wetland)


## join nin.seminat and Modis NDVI data
ModisNDVI.seminat <- full_join(nin.seminat, df.m, by="id")

summary(ModisNDVI.seminat)
ModisNDVI.seminat <- ModisNDVI.seminat %>%
  mutate(hovedoekosystem = as.factor(hovedoekosystem),
         hovedtype = as.factor(hovedtype),
         ninkartleggingsenheter = as.factor(ninkartleggingsenheter), 
         lokalitetskvalitet = as.factor(lokalitetskvalitet),
         tilstand = as.factor(tilstand),
         area_meters = st_area(ModisNDVI.seminat))
summary(ModisNDVI.seminat)
# get rid of NAs (i.e. NDVI cells that were not in wetland polygons)
ModisNDVI.seminat <- ModisNDVI.seminat %>% filter(!is.na(hovedtype))
ModisNDVI.seminat <- ModisNDVI.seminat %>% filter(!is.na(mean))
summary(ModisNDVI.seminat)
# get rid of any nin-polygons smaller than the Modis grid cell size (62500 sqm)
dim(ModisNDVI.seminat)
ModisNDVI.seminat <- ModisNDVI.seminat %>% filter(as.numeric(area_meters) >= 62500)
dim(ModisNDVI.seminat)
# split date into year, month & day
ModisNDVI.seminat <- ModisNDVI.seminat %>%
  dplyr::mutate(year = lubridate::year(date), 
                month = lubridate::month(date), 
                day = lubridate::day(date))

summary(ModisNDVI.seminat)


## join nin.natopen and Modis NDVI data
ModisNDVI.natopen <- full_join(nin.natopen, df.m, by="id")

summary(ModisNDVI.natopen)
ModisNDVI.natopen <- ModisNDVI.natopen %>%
  mutate(hovedoekosystem = as.factor(hovedoekosystem),
         hovedtype = as.factor(hovedtype),
         ninkartleggingsenheter = as.factor(ninkartleggingsenheter), 
         lokalitetskvalitet = as.factor(lokalitetskvalitet),
         tilstand = as.factor(tilstand),
         area_meters = st_area(ModisNDVI.natopen))
summary(ModisNDVI.natopen)
# get rid of NAs (i.e. NDVI cells that were not in wetland polygons)
ModisNDVI.natopen <- ModisNDVI.natopen %>% filter(!is.na(hovedtype))
ModisNDVI.natopen <- ModisNDVI.natopen %>% filter(!is.na(mean))
summary(ModisNDVI.natopen)
# get rid of any nin-polygons smaller than the Modis grid cell size (62500 sqm)
dim(ModisNDVI.natopen)
ModisNDVI.natopen <- ModisNDVI.natopen %>% filter(as.numeric(area_meters) >= 62500)
dim(ModisNDVI.natopen)
# split date into year, month & day
ModisNDVI.natopen <- ModisNDVI.natopen %>%
  dplyr::mutate(year = lubridate::year(date), 
                month = lubridate::month(date), 
                day = lubridate::day(date))

summary(ModisNDVI.natopen)


#### Landsat NDVI data ####

## join nin.wetland & Landsat NDVI data
LandsatNDVI.wetland <- full_join(nin.wetland, df.l, by="id")

#summary(LandsatNDVI.wetland)
LandsatNDVI.wetland <- LandsatNDVI.wetland %>%
  mutate(hovedoekosystem = as.factor(hovedoekosystem),
         hovedtype = as.factor(hovedtype),
         ninkartleggingsenheter = as.factor(ninkartleggingsenheter), 
         lokalitetskvalitet = as.factor(lokalitetskvalitet),
         tilstand = as.factor(tilstand),
         area_meters = st_area(LandsatNDVI.wetland))
#summary(LandsatNDVI.wetland)
# get rid of NAs (i.e. NDVI cells that were not in wetland polygons)
LandsatNDVI.wetland <- LandsatNDVI.wetland %>% filter(!is.na(hovedtype))
LandsatNDVI.wetland <- LandsatNDVI.wetland %>% filter(!is.na(mean))
#summary(LandsatNDVI.wetland)
# get rid of any nin-polygons smaller than the Landsat grid cell size (900 sqm)
dim(LandsatNDVI.wetland)
LandsatNDVI.wetland <- LandsatNDVI.wetland %>% filter(as.numeric(area_meters) >= 900)
dim(LandsatNDVI.wetland)
# split date into year, month & day
LandsatNDVI.wetland <- LandsatNDVI.wetland %>%
  dplyr::mutate(year = lubridate::year(date), 
                month = lubridate::month(date), 
                day = lubridate::day(date))

#summary(LandsatNDVI.wetland)


## join nin.seminat & Landsat NDVI data
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
# get rid of any nin-polygons smaller than the Landsat grid cell size (900 sqm)
dim(LandsatNDVI.seminat)
LandsatNDVI.seminat <- LandsatNDVI.seminat %>% filter(as.numeric(area_meters) >= 900)
dim(LandsatNDVI.seminat)
# split date into year, month & day
LandsatNDVI.seminat <- LandsatNDVI.seminat %>%
  dplyr::mutate(year = lubridate::year(date), 
                month = lubridate::month(date), 
                day = lubridate::day(date))

summary(LandsatNDVI.seminat)


## join nin.natopen & Landsat NDVI data
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
# get rid of any nin-polygons smaller than the Landsat grid cell size (900 sqm)
dim(LandsatNDVI.natopen)
LandsatNDVI.natopen <- LandsatNDVI.natopen %>% filter(as.numeric(area_meters) >= 900)
dim(LandsatNDVI.natopen)
# split date into year, month & day
LandsatNDVI.natopen <- LandsatNDVI.natopen %>%
  dplyr::mutate(year = lubridate::year(date), 
                month = lubridate::month(date), 
                day = lubridate::day(date))

summary(LandsatNDVI.natopen)


#### continue here ####




#rm(list= ls()[!(ls() %in% c('SentinelNDVI.wetland','ModisNDVI.wetland','LandsatNDVI.wetland'))])
