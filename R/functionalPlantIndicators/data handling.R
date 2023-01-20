library(downloader)
library(sf)
library(tidyr)
library(dplyr)
library(plyr)
library(stringr)
library(tidyverse)

#### download from kartkatalogen to P-drive ####
# url <- "https://nedlasting.miljodirektoratet.no/naturovervaking/naturovervaking_eksport.gdb.zip"
download(url, dest="P:/41201785_okologisk_tilstand_2022_2023/data/naturovervaking_eksport.gdb.zip", mode="w") 
unzip ("P:/41201785_okologisk_tilstand_2022_2023/data/naturovervaking_eksport.gdb.zip", 
       exdir = "P:/41201785_okologisk_tilstand_2022_2023/data/naturovervaking_eksport.gdb2")

st_layers(dsn = "P:/41201785_okologisk_tilstand_2022_2023/data/naturovervaking_eksport.gdb2")

# SOMETHING NOT WORKING YET



#### upload data from P-drive ####
# ANO
st_layers(dsn = "P:/41201785_okologisk_tilstand_2022_2023/data/Naturovervaking_eksport.gdb")
ANO.sp <- st_read("P:/41201785_okologisk_tilstand_2022_2023/data/Naturovervaking_eksport.gdb",
                   layer="ANO_Art")
ANO.geo <- st_read("P:/41201785_okologisk_tilstand_2022_2023/data/Naturovervaking_eksport.gdb",
                  layer="ANO_SurveyPoint")
head(ANO.sp)
head(ANO.geo)

# Tyler indicator data
ind.Tyler <- read.table("P:/41201785_okologisk_tilstand_2022_2023/data/functional plant indicators/Tyler et al_Swedish plant indicators.txt",
                        sep = '\t', header=T, quote = '')
head(ind.Tyler)

# Grime CSR-values
ind.Grime <- read.csv("P:/41201785_okologisk_tilstand_2022_2023/data/functional plant indicators/Grime CSR.csv",sep=";",dec=",", header=T)
head(ind.Grime)

# generalized species lists NiN
load("P:/41201785_okologisk_tilstand_2022_2023/data/functional plant indicators//reference from NiN/Eco_State.RData")
str(Eco_State)

#### data handling - functional indicator data ####
# trimming away sub-species & co, and descriptor info
ind.Grime[,'species.orig'] <- ind.Grime[,'species']
ind.Grime[,'species'] <- word(ind.Grime[,'species'], 1,2)
names(ind.Tyler)[1] <- 'species'
ind.Tyler$species <- as.factor(ind.Tyler$species)
summary(ind.Tyler$species)
ind.Tyler <- ind.Tyler[!is.na(ind.Tyler$species),]
ind.Tyler[,'species.orig'] <- ind.Tyler[,'species']
ind.Tyler[,'species'] <- word(ind.Tyler[,'species'], 1,2)

# dealing with 'duplicates'
ind.Grime[duplicated(ind.Grime[,'species']),"species"]
ind.Grime.dup <- ind.Grime[duplicated(ind.Grime[,'species']),c("species")]
ind.Grime[ind.Grime$species %in% ind.Grime.dup,]
# getting rid of the duplicates
ind.Grime <- ind.Grime %>% filter( !(species.orig %in% list("Carex viridula brachyrrhyncha",
                                                            "Dactylorhiza fuchsii praetermissa",
                                                            "Medicago sativa varia",
                                                            "Montia fontana chondrosperma",
                                                            "Papaver dubium lecoqii",
                                                            "Sanguisorba minor muricata")
                                   ) )
ind.Grime[duplicated(ind.Grime[,'species']),"species"]

#ind.Tyler2 <- ind.Tyler
ind.Tyler <- ind.Tyler2
ind.Tyler[duplicated(ind.Tyler[,'species']),"species"]
ind.Tyler.dup <- ind.Tyler[duplicated(ind.Tyler[,'species']),"species"]
ind.Tyler[ind.Tyler$species %in% ind.Tyler.dup,c("Light","Moisture","Soil_reaction_pH","Nitrogen","species.orig","species")]
ind.Tyler <- ind.Tyler %>% filter( !(species.orig %in% list("Ammophila arenaria x Calamagrostis epigejos",
                                                            "Anemone nemorosa x ranunculoides",
                                                            "Armeria maritima ssp. elongata",
                                                            "Asplenium trichomanes ssp. quadrivalens",
                                                            "Calystegia sepium ssp. spectabilis",
                                                            "Campanula glomerata 'Superba'",
                                                            "Dactylorhiza maculata ssp. fuchsii",
                                                            "Erigeron acris ssp. droebachensis",
                                                            "Erigeron acris ssp. politus",
                                                            "Erysimum cheiranthoides L. ssp. alatum",
                                                            "Euphrasia nemorosa x stricta var. brevipila",
                                                            "Galium mollugo x verum",
                                                            "Geum rivale x urbanum",
                                                            "Hylotelephium telephium (ssp. maximum)",
                                                            "Juncus alpinoarticulatus ssp. rariflorus",
                                                            "Lamiastrum galeobdolon ssp. argentatum",
                                                            "Lathyrus latifolius ssp. heterophyllus",
                                                            "Medicago sativa ssp. falcata",
                                                            "Medicago sativa ssp. x varia",
                                                            "Monotropa hypopitys ssp. hypophegea",
                                                            "Ononis spinosa ssp. hircina",
                                                            "Ononis spinosa ssp. procurrens",
                                                            "Pilosella aurantiaca ssp. decolorans",
                                                            "Pilosella aurantiaca ssp. dimorpha",
                                                            "Pilosella cymosa ssp. gotlandica",
                                                            "Pilosella cymosa ssp. praealta",
                                                            "Pilosella officinarum ssp. peleteranum",
                                                            "Poa x jemtlandica (Almq.) K. Richt.",
                                                            "Poa x herjedalica Harry Sm.",
                                                            "Ranunculus peltatus ssp. baudotii",
                                                            "Sagittaria natans x sagittifolia",
                                                            "Salix repens ssp. rosmarinifolia",
                                                            "Stellaria nemorum L. ssp. montana",
                                                            "Trichophorum cespitosum ssp. germanicum")
) )
ind.Tyler[duplicated(ind.Tyler[,'species']),"species"]
ind.Tyler.dup <- ind.Tyler[duplicated(ind.Tyler[,'species']),"species"]
ind.Tyler[ind.Tyler$species %in% ind.Tyler.dup,c("Light","Moisture","Soil_reaction_pH","Nitrogen","species.orig","species")]
# getting rid of sect. for Hieracium
ind.Tyler <- ind.Tyler %>% mutate(species=gsub("sect. ","",species.orig))
ind.Tyler[,'species'] <- word(ind.Tyler[,'species'], 1,2)

ind.Tyler[duplicated(ind.Tyler[,'species']),"species"]
ind.Tyler.dup <- ind.Tyler[duplicated(ind.Tyler[,'species']),"species"]
ind.Tyler[ind.Tyler$species %in% ind.Tyler.dup,c("Light","Moisture","Soil_reaction_pH","Nitrogen","species.orig","species")]
# only hybrids left -> get rid of these
ind.Tyler <- ind.Tyler[!duplicated(ind.Tyler[,'species']),]
ind.Tyler[duplicated(ind.Tyler[,'species']),"species"]

ind.Tyler$species <- as.factor(ind.Tyler$species)
summary(ind.Tyler$species)
# no duplicates left

# merge indicator data
ind.dat <- merge(ind.Grime,ind.Tyler, by="species", all=T)
summary(ind.dat)
ind.dat[duplicated(ind.dat[,'species']),"species"]
ind.dat$species <- as.factor(ind.dat$species)
summary(ind.dat$species)
head(ind.dat)

#### data handling - ANO data ####
head(ANO.sp)
head(ANO.geo)

# fix species names
ANO.sp$Species <- ANO.sp$art_navn
unique(as.factor(ANO.sp$Species))
#ANO.sp$Species <- sub(".*?_", "", ANO.sp$Species) # lose the Norwegian name in the front
ANO.sp[,'Species'] <- word(ANO.sp[,'Species'], 1,2) # lose subspecies
ANO.sp$Species <- str_to_title(ANO.sp$Species) # make first letter capital
#ANO.sp$Species <- gsub("_", " ", ANO.sp$Species) # replace underscore with space
ANO.sp$Species <- gsub("( .*)","\\L\\1",ANO.sp$Species,perl=TRUE) # make capital letters after hyphon to lowercase
ANO.sp$Species <- gsub("( .*)","\\L\\1",ANO.sp$Species,perl=TRUE) # make capital letters after space to lowercase

## merge species data with indicators
ANO.sp <- merge(x=ANO.sp[,c("Species", "art_dekning", "ParentGlobalID")], 
                y= ind.dat[,c("species","CC", "SS", "RR", "Light", "Moisture", "Soil_reaction_pH", "Nitrogen", "Grazing_mowing")],
                by.x="Species", by.y="species", all.x=T)
summary(ANO.sp)

## adding information on ecosystem and condition variables
ANO.sp <- merge(x=ANO.sp, 
                y=ANO.geo[,c("GlobalID","ano_flate_id","ano_punkt_id","ssb_id","aar",
                             "hovedoekosystem_punkt","hovedtype_1m2","kartleggingsenhet_1m2",
                             "vedplanter_total_dekning","busker_dekning","tresjikt_dekning","roesslyng_dekning")], 
            by.x="ParentGlobalID", by.y="GlobalID", all.x=T)
# trimming away the points without information on NiN, species or cover
ANO.sp <- ANO.sp[!is.na(ANO.sp$Species),]
ANO.sp <- ANO.sp[!is.na(ANO.sp$art_dekning),]






#ANO.sp <- ANO.sp[!is.na(ANO.sp$Hovedoekosystem_rute),] # need to check
unique(as.factor(ANO.sp$hovedoekosystem_punkt))
unique(as.factor(ANO.sp$hovedtype_1m2))
unique(as.factor(ANO.sp$kartleggingsenhet_1m2))

summary(ANO.sp)
head(ANO.sp)

#### data handling - reference data ####