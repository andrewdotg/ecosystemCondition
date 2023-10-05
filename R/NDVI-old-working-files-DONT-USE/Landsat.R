#Åpen Lavland - NDVI from Landsat

#mean NDVI for each åpen lavland NiN polygon has been calculated from each available Landsat image in Google Earth Engine. 
#The code can be seen here: https://code.earthengine.google.com/da8a9279238ef26d14be08a43788b6b7
#The image collection contains Landsat imagery from june, july and august 1984-2022
#To not exceed GEE memory limits, the exported files had to be iterated over a grid which resulted in 42 separate csv files. This script merges them and then merges the dataframe to the NiN data.

library(data.table)
library(stringr, lib.loc = "/usr/lib/R/site-library")
library(tidyverse, lib.loc = "/usr/local/lib/R/site-library")
#library(tidyverse)
library(sf)

# Set up conditional file paths
dir <- substr(getwd(), 1,2)

path <- ifelse(dir == "C:", 
               "R:/GeoSpatialData/Habitats_biotopes/Norway_Miljodirektoratet_Naturtyper_nin/Original/versjon20221231/Natur_Naturtyper_nin_norge_med_svalbard_25833/Natur_Naturtyper_NiN_norge_med_svalbard_25833.gdb",
               "/data/R/GeoSpatialData/Habitats_biotopes/Norway_Miljodirektoratet_Naturtyper_nin/Original/versjon20221231/Natur_Naturtyper_nin_norge_med_svalbard_25833/Natur_Naturtyper_NiN_norge_med_svalbard_25833.gdb")

pData <- ifelse(dir == "C:", 
                 "P:/41201785_okologisk_tilstand_2022_2023/data/NDVI_åpenlavland/NDVI_data_Landsat",
                 "/data/P-Prosjekter2/41201785_okologisk_tilstand_2022_2023/data/NDVI_åpenlavland/NDVI_data_Landsat")
 
 

#############Import NiN data

nin <- st_read(path)%>%
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


##############Import Landsat NDVI Data

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
  
df<-bind_rows(df_list, .id = "column_label")

##########join NiN and NDVI data
LandsatNDVI <- full_join(nin, df, by="id")

## Not saved LandsatNDVI to the data/cache as it is huge
