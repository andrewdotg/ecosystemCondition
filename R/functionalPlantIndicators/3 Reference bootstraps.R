#### running bootstraps - wetlands ####
colnames(NiN.wetland)
mount.ind.list <- indBoot(sp=NiN.wetland[,1],abun=NiN.wetland[,2:46],ind=NiN.wetland[,47:51],
                          iter=10000,obl=6,rat=1/3,var.abun=T)

mount.ind.list.cov <- indBoot(sp=NiN.wetland.cov[,1],abun=NiN.wetland.cov[,2:46],ind=NiN.wetland.cov[,47:51],
                          iter=10000,obl=1,rat=1/3,var.abun=T)

### saving backups
#mount.ind.list.backup <- mount.ind.list
#mount.ind.list.cov.backup <- mount.ind.list.cov


### fixing NaN's
for (i in 1:length(mount.ind.list) ) {
  for (j in 1:ncol(mount.ind.list[[i]]) ) {
    v <- mount.ind.list[[i]][,j]
    v[is.nan(v)] <- NA
    mount.ind.list[[i]][,j] <- v
  }
}

for (i in 1:length(mount.ind.list.cov) ) {
  for (j in 1:ncol(mount.ind.list.cov[[i]]) ) {
    v <- mount.ind.list.cov[[i]][,j]
    v[is.nan(v)] <- NA
    mount.ind.list.cov[[i]][,j] <- v
  }
}


#### checking NiN-types with several species lists ####
# mountain
str(mount.ind.list)
# L, F, R, N, S, HM, T
#indID <- colnames(ind.dat)[c(3:8)]
indID <- colnames(ind.dat)[c(3,5,6)]
NiNID <- colnames(mount.ind.list[[1]])

for (i in indID) {
  
  dirOutput <- "C:/Users/joachim.topper/OneDrive - NINA/work/R projects/projects/økol tilst indikatorverdier/output/checks/mountain"
  setwd(dirOutput)
  name <- paste('Ellenberg',i,'.jpg',sep='')
  jpeg(filename=name,width=4000,height=4000,res=300)
  
  par(mfrow=c(5,5))
  for (j in NiNID) {
    plot(density(mount.ind.list[[i]][,j],na.rm=T),main=j,xlim=c(3,8))
  }
  dev.off()
}




#### checking NiN-types with several species lists ####
# mountain
str(mount.ind.list.cov)
# L, F, R, N, S, HM, T
#indID <- colnames(ind.dat)[c(3:8)]
indID <- colnames(ind.dat)[c(3,5,6)]
NiNID <- colnames(mount.ind.list.cov[[1]])

for (i in indID) {
  
  dirOutput <- "C:/Users/joachim.topper/OneDrive - NINA/work/R projects/projects/økol tilst indikatorverdier/output/checks/mountain"
  setwd(dirOutput)
  name <- paste('Ellenberg',i,'.jpg',sep='')
  jpeg(filename=name,width=4000,height=4000,res=300)
  
  par(mfrow=c(5,5))
  for (j in NiNID) {
    plot(density(mount.ind.list.cov[[i]][,j],na.rm=T),main=j,xlim=c(3,8))
  }
  dev.off()
}



#### storing reference lists ####
#rm(list= ls()[!(ls() %in% c('forest.ind.list','mire.ind.list','semiNat.ind.list','heath.ind.list','mount.ind.list','ind.dat'))])
#rm(list= ls()[!(ls() %in% c('mount.ind.list.backup','mount.ind.list','mount.ind.list.cov.backup','mount.ind.list.cov','ind.dat'))])

# settings <- "iter=10000,obl=6,rat=1/3,var.abun=T"
#save.image("C:/Users/joachim.topper/OneDrive - NINA/work/R projects/projects/?kol tilst fjell 2021/input/reference/reference list/ref_lists_mount211123_10000.RData")

