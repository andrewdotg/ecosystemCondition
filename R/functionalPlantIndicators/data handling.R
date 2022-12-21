library(sf)
library(tidyr)
library(dplyr)
library(plyr)
library(stringr)
library(tidyverse)


# url <- "https://nedlasting.miljodirektoratet.no/naturovervaking/naturovervaking_eksport.gdb.zip"

# download from P-drive

# ANO
st_layers(dsn = "P:/41201785_okologisk_tilstand_2022_2023/data/Naturovervaking_eksport.gdb")
ANO.dat <- st_read("P:/41201785_okologisk_tilstand_2022_2023/data/Naturovervaking_eksport.gdb")
head(ANO.dat)

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

