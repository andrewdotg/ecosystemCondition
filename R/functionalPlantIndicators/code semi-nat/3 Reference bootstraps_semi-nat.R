#### running bootstraps - seminats ####
colnames(NiN.seminat)
seminat.ref <- indBoot(sp=NiN.seminat[,1],abun=NiN.seminat[,2:35],ind=NiN.seminat[,36:42],
                       iter=1000,obl=6,rat=2/3,var.abun=T)


seminat.ref.cov <- indBoot.freq(sp=NiN.seminat.cov[,1],abun=NiN.seminat.cov[,2:35],ind=NiN.seminat.cov[,36:42],
                                iter=1000,obl=1,rat=2/3,var.abun=T)

### saving backups
#seminat.ref.backup <- seminat.ref
#seminat.ref.cov.backup <- seminat.ref.cov

### fixing NaN's
for (i in 1:length(seminat.ref) ) {
  for (j in 1:ncol(seminat.ref[[i]]) ) {
    v <- seminat.ref[[i]][,j]
    v[is.nan(v)] <- NA
    seminat.ref[[i]][,j] <- v
  }
}

for (i in 1:length(seminat.ref.cov) ) {
  for (j in 1:ncol(seminat.ref.cov[[i]]) ) {
    v <- seminat.ref.cov[[i]][,j]
    v[is.nan(v)] <- NA
    seminat.ref.cov[[i]][,j] <- v
  }
}





#### checking NiN-types with several species lists ####
str(seminat.ref.cov)

indID <- colnames(ind.dat[,c("Light", "Moisture", "Soil_reaction_pH", "Nitrogen","Phosphorus","Grazing_mowing","Soil_disturbance")])
NiNID <- colnames(seminat.ref.cov[[1]])

for (i in indID) {
  
  dirOutput <- "C:/Users/joachim.topper/OneDrive - NINA/work/R projects/github/ecosystemCondition/R/functionalPlantIndicators/testoutput"
  setwd(dirOutput)
  name <- paste('seminat',i,'.jpg',sep='')
  jpeg(filename=name,width=8000,height=4000,res=300)
  
  par(mfrow=c(5,7))
  for (j in NiNID) {
    plot(density(seminat.ref.cov[[i]][,j],na.rm=T),main=j,xlim=c(-2,10))
  }
  dev.off()
}

## omit V1-C1a & V1-C8a
#str(seminat.ref.cov)

#seminat.ref.cov <- lapply(seminat.ref.cov, function(x) x[!(names(x) %in% c("V1-C1a", "V1-C8a"))])
#seminat.ref <- lapply(seminat.ref, function(x) x[!(names(x) %in% c("V1-C1a", "V1-C8a"))])


#### storing reference lists ####
#rm(list= ls()[!(ls() %in% c('forest.ind.list','mire.ind.list','semiNat.ind.list','heath.ind.list','seminat.ref','ind.dat'))])
#rm(list= ls()[!(ls() %in% c('seminat.ref.backup','seminat.ref','seminat.ref.cov.backup','seminat.ref.cov', 'ANO.sp.ind', 'NiN.seminat.cov','ind.dat'))])
settings <- "iter=1000,obl=1,rat=2/3,var.abun=T"
rm(list= ls()[!(ls() %in% c('seminat.ref.cov', 'seminat.ref.cov.backup','settings'))])
save.image("C:/Users/joachim.topper/OneDrive - NINA/work/R projects/github/ecosystemCondition/R/functionalPlantIndicators/output large files for markdown/ref_lists_seminat.RData")
