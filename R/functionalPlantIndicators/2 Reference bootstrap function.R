# function to calculate community weighted means of selected indicator values (ind)
# for species lists (sp) with given abundances (on a scale from 1 to 6) in one or more 'sites' (abun)
# with a given number of iterations (iter),
# with species given a certain minimum abundance ocurring in all bootstraps (obl), and
# with a given resampling ratio of the original species list (rat)
# in every bootstrap iteration the abundance of the sampled species can be 
  # randomly changed by +/-1 if wished (var.abun)


indBoot <- function(sp,abun,ind,iter,obl,rat=2/3,var.abun=F) {
  
  ind.b <- matrix(nrow=iter,ncol=length(colnames(abun)))
  colnames(ind.b) <- colnames(abun)
  ind.b <- as.data.frame(ind.b)  
  
  ind <- as.data.frame(ind)
  ind.list <- as.list(1:length(colnames(ind)))
  names(ind.list) <- colnames(ind)
  
  for (k in 1:length(colnames(ind)) ) {
     ind.list[[k]] <- ind.b }
  
  for (j in 1:length(colnames(abun)) ) {
    
    dat <- cbind(sp,abun[,j],ind)
    dat <- dat[dat[,2]>0,]            # only species that are present in the ecoystem
    dat <- dat[!is.na(dat[,3]),]      # only species that have Ellenberg values
    
    for (i in 1:iter) {
      
      speciesSample <- sample(dat$sp[dat[,2] < obl], size=round( (length(dat$sp)-length(dat$sp[dat[,2]>=obl])) *rat,0), replace=F)  
      dat.b <- rbind(dat[dat[,2] >= obl,],
                     dat[match(speciesSample,dat$sp),]
                     )
      
      if (var.abun==T) {
        for (l in 1: nrow(dat.b)) { dat.b[l,2] <- dat.b[l,2] + sample(c(-1,0,1),size=1) }
        dat.b[!is.na(dat.b[,2]) & dat.b[,2]==(0),2] <- 1
        dat.b[!is.na(dat.b[,2]) & dat.b[,2]==7,2] <- 6
      }
      
      for (k in 1:length(colnames(ind))) {
        
        if ( nrow(dat.b)>2 ) {
          
          ind.b <- sum(dat.b[!is.na(dat.b[,2+k]),2] * dat.b[!is.na(dat.b[,2+k]),2+k] , na.rm=T) / sum(dat.b[!is.na(dat.b[,2+k]),2],na.rm=T)
          ind.list[[k]][i,j] <- ind.b
          
        } else {ind.list[[k]][i,j] <- NA}
        
      }
      #      su <- sum(ind.list[["CC"]][i,j],ind.list[["SS"]][i,j],ind.list[["RR"]][i,j])
      #      print(paste(i,"",j,su))   
      print(paste(i,"",j)) 
    }
    
  }
  return(ind.list)
}


