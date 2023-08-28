#### running bootstraps - natopens ####
colnames(NiN.natopen)
natopen.ref <- indBoot(sp=NiN.natopen[,1],abun=NiN.natopen[,6:71],ind=NiN.natopen[,74:79],
                       iter=1000,obl=6,rat=1/3,var.abun=T)


natopen.ref.cov <- indBoot.freq(sp=NiN.natopen.cov[,1],abun=NiN.natopen.cov[,6:71],ind=NiN.natopen.cov[,74:79],
                                iter=1000,obl=1,rat=1/3,var.abun=T)

### saving backups
#natopen.ref.backup <- natopen.ref
#natopen.ref.cov.backup <- natopen.ref.cov

### fixing NaN's
for (i in 1:length(natopen.ref) ) {
  for (j in 1:ncol(natopen.ref[[i]]) ) {
    v <- natopen.ref[[i]][,j]
    v[is.nan(v)] <- NA
    natopen.ref[[i]][,j] <- v
  }
}

for (i in 1:length(natopen.ref.cov) ) {
  for (j in 1:ncol(natopen.ref.cov[[i]]) ) {
    v <- natopen.ref.cov[[i]][,j]
    v[is.nan(v)] <- NA
    natopen.ref.cov[[i]][,j] <- v
  }
}





#### checking NiN-types with several species lists ####
str(natopen.ref.cov)

indID <- colnames(ind.dat[,c("Light", "Nitrogen", "Soil_disturbance")])
NiNID <- colnames(natopen.ref.cov[[1]])

for (i in indID) {
  
  dirOutput <- "C:/Users/joachim.topper/OneDrive - NINA/work/R projects/github/ecosystemCondition/R/functionalPlantIndicators/testoutput"
  setwd(dirOutput)
  name <- paste('natopen',i,'.jpg',sep='')
  jpeg(filename=name,width=8000,height=4000,res=300)
  
  par(mfrow=c(5,7))
  for (j in NiNID) {
    plot(density(natopen.ref.cov[[i]][,j],na.rm=T),main=j,xlim=c(-2,10))
  }
  dev.off()
}


indID <- colnames(ind.dat[,c("CC", "SS", "RR")])

for (i in indID) {
  
  dirOutput <- "C:/Users/joachim.topper/OneDrive - NINA/work/R projects/github/ecosystemCondition/R/functionalPlantIndicators/testoutput"
  setwd(dirOutput)
  name <- paste('natopen',i,'.jpg',sep='')
  jpeg(filename=name,width=8000,height=4000,res=300)
  
  par(mfrow=c(5,7))
  for (j in NiNID) {
    plot(density(natopen.ref.cov[[i]][,j],na.rm=T),main=j,xlim=c(0,1))
  }
  dev.off()
}

# resetting working directory
setwd("C:/Users/joachim.topper/OneDrive - NINA/work/R projects/github/ecosystemCondition")

## omit V1-C1a & V1-C8a
#str(natopen.ref.cov)

#natopen.ref.cov <- lapply(natopen.ref.cov, function(x) x[!(names(x) %in% c("V1-C1a", "V1-C8a"))])
#natopen.ref <- lapply(natopen.ref, function(x) x[!(names(x) %in% c("V1-C1a", "V1-C8a"))])


#### storing reference lists ####
#rm(list= ls()[!(ls() %in% c('natopen.ref.cov.backup','natopen.ref.cov', 'ANO.sp.ind', 'ANO.geo', 'ASO.sp.ind', 'ASO.geo', 'NiN.natopen.cov','ind.dat'))])
settings <- "iter=1000,obl=1,rat=1/3,var.abun=T"

saveRDS(natopen.ref.cov, "data/cache/natopen.ref.cov.RDS")
rm(list= ls()[!(ls() %in% c('natopen.ref.cov', 'natopen.ref.cov.backup','settings'))])
save.image("P:/41201785_okologisk_tilstand_2022_2023/data/FPI_output large files for markdown/ref_lists_natopen.RData")

load("P:/41201785_okologisk_tilstand_2022_2023/data/FPI_output large files for markdown/ref_lists_natopen.RData")
