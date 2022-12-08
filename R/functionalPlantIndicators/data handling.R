library(sf)
library(tidyr)
library(stringr)


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
csr.dat[,'species'] <- word(csr.dat[,'species'], 1,2)
ell.dat[,'species'] <- word(ell.dat[,'species'], 1,2)
names(Dahl)[3] <- 'Dahls_R'
Dahl$species <- as.factor(Dahl$species)
Dahl <- Dahl[Dahl$species!="",]
Dahl[,'species'] <- word(Dahl[,'species'], 1,2)
#names(Gottfried)[2] <- 'species'
#Gottfried$species <- as.factor(Gottfried$species)
#summary(Gottfried$species)
#Gottfried[,'species'] <- word(Gottfried[,'species'], 1,2)
names(ind_swe)[1] <- 'species'
ind_swe$species <- as.factor(ind_swe$species)
summary(ind_swe$species)
ind_swe <- ind_swe[!is.na(ind_swe$species),]
ind_swe[,'species'] <- word(ind_swe[,'species'], 1,2)

# dealing with 'duplicates'
csr.dat[duplicated(csr.dat[,'species']),"species"]
csr.dup <- csr.dat[duplicated(csr.dat[,'species']),"species"]
csr.dat[csr.dat$species %in% csr.dup,]
csr.dat <- csr.dat[!duplicated(csr.dat[,'species']),]
csr.dat[csr.dat$species %in% csr.dup,]
csr.dat[duplicated(csr.dat[,'species']),"species"]

ell.dat[duplicated(ell.dat[,'species']),"species"]
ell.dup <- ell.dat[duplicated(ell.dat[,'species']),"species"]
ell.dat[ell.dat$species %in% ell.dup,]
ell.dat <- ell.dat[!duplicated(ell.dat[,'species']),]
ell.dat[ell.dat$species %in% ell.dup,]
ell.dat[duplicated(ell.dat[,'species']),"species"]

Dahl[duplicated(Dahl[,'species']),"species"]
Dahl.dup <- Dahl[duplicated(Dahl[,'species']),"species"]
Dahl[Dahl$species %in% Dahl.dup,]
Dahl <- Dahl[!duplicated(Dahl[,'species']),]
Dahl[Dahl$species %in% Dahl.dup,]
Dahl$species <- as.factor(Dahl$species)
Dahl <- Dahl[!is.na(Dahl$species),]
Dahl[duplicated(Dahl[,'species']),"species"]

ind_swe[duplicated(ind_swe[,'species']),"species"]
ind_swe.dup <- ind_swe[duplicated(ind_swe[,'species']),"species"]
ind_swe[ind_swe$species %in% ind_swe.dup,]
ind_swe <- ind_swe[!duplicated(ind_swe[,'species']),]
ind_swe[ind_swe$species %in% ind_swe.dup,]
ind_swe$species <- as.factor(ind_swe$species)
ind_swe[duplicated(ind_swe[,'species']),"species"]
summary(ind_swe$species)
#ind_swe <- ind_swe[!is.na(ind_swe$species),]

ind.dat <- merge(ell.dat,csr.dat, by="species", all=T)
summary(ind.dat)
ind.dat[duplicated(ind.dat[,'species']),"species"]
ind.dat <- merge(ind.dat,Dahl, by="species", all=T)
summary(ind.dat)
ind.dat[duplicated(ind.dat[,'species']),"species"]
ind.dat$Dahls_R_max <- ind.dat$Dahls_R
summary(ind.dat)
#ind.dat <- merge(ind.dat,Gottfried, by="species", all=T)
#summary(ind.dat)
#ind.dat[duplicated(ind.dat[,'species']),"species"]
ind.dat <- merge(ind.dat,ind_swe, by="species", all=T)
summary(ind.dat)
ind.dat[duplicated(ind.dat[,'species']),"species"]
