#### scaled values ####
r.s <- 1    # reference value
l.s <- 0.6  # limit value
a.s <- 0    # abscence of indicator, or indicator at maximum

#### function for calculating scaled values for measured value ####

## scaling function including truncation
scal <- function() {
  # place to hold the result
  x <- numeric()
  if (maxmin < ref) {
    # values >= the reference value equal 1
    if (val >= ref) {x <- 1}
    # values < the reference value and >= the limit value can be deducted from the linear relationship between these two
    if (val < ref & val >= lim) {x <- (l.s + (val-lim) * ( (r.s-l.s) / (ref-lim) ) )}
    # values < the limit value and > maxmin can be deducted from the linear relationship between these two
    if (val < lim & val > maxmin) {x <- (a.s + (val-maxmin) * ( (l.s-a.s) / (lim-maxmin) ) )}
    # value equals or lower than maxmin
    if (val <= maxmin) {x <-0}
  } else {
    # values <= the reference value equal 1
    if (val <= ref) {x <- 1}
    # values > the reference value and <= the limit value can be deducted from the linear relationship between these two
    if (val > ref & val <= lim) {x <- ( r.s - ( (r.s - l.s) * (val - ref) / (lim - ref) ) )}
    # values > the limit value and < maxmin can be deducted from the linear relationship between these two
    if (val > lim) {x <- ( l.s - (l.s * (val - lim) / (maxmin - lim) ) )}
    # value equals or larger than maxmin
    if (val >= maxmin) {x <-0}
  }
  return(x)
  
}

## scaling function without truncation
scal.2 <- function() {
  # place to hold the result
  x <- numeric()
  if (maxmin < ref) {
    # values >= the reference value estimated from the linear relationship for lim < x < ref (line below)
    if (val >= ref) {x <- (l.s + (val-lim) * ( (r.s-l.s) / (ref-lim) ) )}
    # values < the reference value and >= the limit value can be deducted from the linear relationship between these two
    if (val < ref & val >= lim) {x <- (l.s + (val-lim) * ( (r.s-l.s) / (ref-lim) ) )}
    # values < the limit value and > maxmin can be deducted from the linear relationship between these two
    if (val < lim & val > maxmin) {x <- (a.s + (val-maxmin) * ( (l.s-a.s) / (lim-maxmin) ) )}
    # value equal or lower than maxmin
    if (val <= maxmin) {x <-0}
  } else {
    # values <= the reference value estimated from the linear relationship for lim < x < ref (line below)
    if (val <= ref) {x <- ( r.s - ( (r.s - l.s) * (val - ref) / (lim - ref) ) )}
    # values > the reference value and <= the limit value can be deducted from the linear relationship between these two
    if (val > ref & val <= lim) {x <- ( r.s - ( (r.s - l.s) * (val - ref) / (lim - ref) ) )}
    # values > the limit value and < maxmin can be deducted from the linear relationship between these two
    if (val > lim & val < maxmin) {x <- ( l.s - (l.s * (val - lim) / (maxmin - lim) ) )}
    # value equal og larger than maxmin
    if (val >= maxmin) {x <-0}
  }
  return(x)
  
}


unique(ANO.geo$hovedtype_rute) # NiN types in data
unique(substr(natopen.ref.cov.val$grunn,1,3)) # NiN types in reference
levels(as.factor(ANO.geo$kartleggingsenhet_1m2)) # NiN types in data
levels(natopen.ref.cov.val$grunn) # NiN types in reference
#### creating dataframe to hold the results for natopens ####
# all ANO points
nrow(ANO.geo)
# all natopen ANO points
nrow(ANO.geo[ANO.geo$hovedtype_rute %in% list("T2","T8","T11","T12","T13","T15","T16","T18","T21","T24","T29") & ANO.geo$hovedoekosystem_punkt!='fjell',])
nrow(ANO.geo[ANO.geo$hovedtype_rute %in% list("T2") & ANO.geo$hovedoekosystem_punkt!='fjell',])
nrow(ANO.geo[ANO.geo$hovedtype_rute %in% list("T13") & ANO.geo$hovedoekosystem_punkt!='fjell',])
nrow(ANO.geo[ANO.geo$hovedtype_rute %in% list("T16") & ANO.geo$hovedoekosystem_punkt!='fjell',])
# all natopen ANO points with a NiN-type represented in the reference
nrow(ANO.geo[ANO.geo$hovedtype_rute %in% unique(gsub("-", "",substr(natopen.ref.cov.val$grunn,1,3))) & ANO.geo$hovedoekosystem_punkt!='fjell',])
# leaving us with a total of 272 ANO-points with naturally open ecosystems that are not in the mountains
ANO.natopen <- ANO.geo[ANO.geo$hovedtype_rute %in% unique(gsub("-", "",substr(natopen.ref.cov.val$grunn,1,3))) & ANO.geo$hovedoekosystem_punkt!='fjell',]
ANO.natopen <- ANO.natopen[!is.na(ANO.natopen$kartleggingsenhet_1m2),]
head(ANO.natopen)
# update row-numbers
row.names(ANO.natopen) <- 1:nrow(ANO.natopen)
head(ANO.natopen)
dim(ANO.natopen)
colnames(ANO.natopen)

length(levels(as.factor(ANO.natopen$ano_flate_id)))
length(levels(as.factor(ANO.natopen$ano_punkt_id)))
summary(as.factor(ANO.natopen$ano_punkt_id))
# one point is double
ANO.natopen[ANO.natopen$ano_punkt_id=="ANO0084_51",] # double registration of # 51
ANO.geo[ANO.geo$ano_punkt_id=="ANO0084_51",] # double registration of # 51

ANO.geo[ANO.geo$ano_flate_id=="ANO0084","ano_punkt_id"] # also # 62 is registered double
ANO.geo[ANO.geo$ano_punkt_id=="ANO0084_62",] # but this is not a natopen-type
# seems to be a legit registration of a naturally open type on both ANO-points # 51.
# Both points # 22, 35, 44, and 53 are missing, so we simply assign the 2nd # 51 to # 53 for this analysis
ANO.natopen[ANO.natopen$ano_punkt_id=="ANO0084_51" & !is.na(ANO.natopen$ano_punkt_id),][2,"ano_punkt_id"] <- "ANO0084_53"
ANO.natopen[ANO.natopen$ano_flate_id=="ANO0084","ano_punkt_id"]
summary(as.factor(ANO.natopen$ano_punkt_id))

#ANO.natopen <- ANO.natopen[-206,]
#row.names(ANO.natopen) <- 1:nrow(ANO.natopen) # update row-numbers

unique(ANO.natopen$hovedoekosystem_punkt)
unique(ANO.natopen$hovedtype_rute)
unique(ANO.natopen$kartleggingsenhet_1m2)
ANO.natopen$hovedtype_rute <- as.factor(ANO.natopen$hovedtype_rute)
ANO.natopen$kartleggingsenhet_1m2 <- as.factor(ANO.natopen$kartleggingsenhet_1m2)
summary(ANO.natopen$hovedtype_rute)
summary(ANO.natopen$kartleggingsenhet_1m2)
# we have no reference for overall T2 registrations, these 24 observations won't be evaluated
ANO.natopen[ANO.natopen$kartleggingsenhet_1m2=="T2",] # were largely inaccessible and thus mapped from arial pictures

results.natopen.ANO <- list()
ind <- unique(natopen.ref.cov.val$Ind)
# choose columns for site description
colnames(ANO.natopen)
results.natopen.ANO[['original']] <- ANO.natopen
# drop geometry
st_geometry(results.natopen.ANO[['original']]) <- NULL
results.natopen.ANO[['original']]

# add columns for indicators
nvar.site <- ncol(results.natopen.ANO[['original']])
for (i in 1:length(ind) ) {results.natopen.ANO[['original']][,i+nvar.site] <- NA}
colnames(results.natopen.ANO[['original']])[(nvar.site+1):(length(ind)+nvar.site)] <- paste(ind)
for (i in (nvar.site+1):(length(ind)+nvar.site) ) {results.natopen.ANO[['original']][,i] <- as.numeric(results.natopen.ANO[['original']][,i])}
summary(results.natopen.ANO[['original']])
#results.natopen.ANO[['original']]$Region <- as.factor(results.natopen.ANO[['original']]$Region)
results.natopen.ANO[['original']]$GlobalID <- as.factor(results.natopen.ANO[['original']]$GlobalID)
results.natopen.ANO[['original']]$ano_flate_id <- as.factor(results.natopen.ANO[['original']]$ano_flate_id)
results.natopen.ANO[['original']]$ano_punkt_id <- as.factor(results.natopen.ANO[['original']]$ano_punkt_id)
results.natopen.ANO[['original']]$hovedoekosystem_punkt <- as.factor(results.natopen.ANO[['original']]$hovedoekosystem_punkt)
#results.natopen.ANO[['original']]$Hovedoekosystem_rute  <- as.factor(results.natopen.ANO[['original']]$Hovedoekosystem_rute )
results.natopen.ANO[['original']]$kartleggingsenhet_1m2 <- as.factor(results.natopen.ANO[['original']]$kartleggingsenhet_1m2)
results.natopen.ANO[['original']]$hovedtype_rute    <- as.factor(results.natopen.ANO[['original']]$hovedtype_rute)


# roll out
results.natopen.ANO[['scaled']] <- results.natopen.ANO[['non-truncated']] <- results.natopen.ANO[['original']]


#### calculating scaled and non-truncated values for the indicators based on the dataset ####
for (i in 1:nrow(ANO.natopen) ) {  #
  tryCatch({
    print(i)
    print(paste(ANO.natopen$ano_flate_id[i]))
    print(paste(ANO.natopen$ano_punkt_id[i]))
#    ANO.natopen$Hovedoekosystem_sirkel[i]
#    ANO.natopen$Hovedoekosystem_rute[i]



    # if the ANO.hovedtype exists in the reference
    if (ANO.natopen$hovedtype_rute[i] %in% gsub("-","",unique(substr(natopen.ref.cov.val$grunn,1,3))) ) {
      
      # if there is any species present in current ANO point  
      if ( length(ANO.sp.ind[ANO.sp.ind$ParentGlobalID==as.character(ANO.natopen$GlobalID[i]),'Species']) > 0 ) {
        

        # Grime's C
        
        dat <- ANO.sp.ind[ANO.sp.ind$ParentGlobalID==as.character(ANO.natopen$GlobalID[i]),c('art_dekning','CC')]
        results.natopen.ANO[['original']][i,'richness'] <- nrow(dat)
        dat <- dat[!is.na(dat$CC),]
        
        if ( nrow(dat)>0 ) {
          
          val <- sum(dat[,'art_dekning'] * dat[,'CC'],na.rm=T) / sum(dat[,'art_dekning'],na.rm=T)
          # lower part of distribution
          if( ANO.natopen$kartleggingsenhet_1m2[i] %in% c("T2-C-7","T2-C-8") ) {
            ref <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='CC1' & natopen.ref.cov.val$grunn==paste(as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),"_BN",sep=""),'Rv']
            lim <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='CC1' & natopen.ref.cov.val$grunn==paste(as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),"_BN",sep=""),'Gv']
          } else {
            ref <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='CC1' & natopen.ref.cov.val$grunn==as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),'Rv']
            lim <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='CC1' & natopen.ref.cov.val$grunn==as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),'Gv']
          }
          maxmin <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='CC1' & natopen.ref.cov.val$grunn==as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),'maxmin']
          # coercing x into results.natopen.ANO dataframe
          results.natopen.ANO[['scaled']][i,'CC1'] <- scal() 
          results.natopen.ANO[['non-truncated']][i,'CC1'] <- scal.2() 
          results.natopen.ANO[['original']][i,'CC1'] <- val 
          
          # upper part of distribution
          if( ANO.natopen$kartleggingsenhet_1m2[i] %in% c("T2-C-7","T2-C-8") ) {
            ref <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='CC2' & natopen.ref.cov.val$grunn==paste(as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),"_BN",sep=""),'Rv']
            lim <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='CC2' & natopen.ref.cov.val$grunn==paste(as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),"_BN",sep=""),'Gv']
          } else {
            ref <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='CC2' & natopen.ref.cov.val$grunn==as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),'Rv']
            lim <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='CC2' & natopen.ref.cov.val$grunn==as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),'Gv']
          }          
          maxmin <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='CC2' & natopen.ref.cov.val$grunn==as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),'maxmin']
          # coercing x into results.natopen.ANO dataframe
          results.natopen.ANO[['scaled']][i,'CC2'] <- scal() 
          results.natopen.ANO[['non-truncated']][i,'CC2'] <- scal.2() 
          results.natopen.ANO[['original']][i,'CC2'] <- val
        }
          
        
        # Grime's S
        dat <- ANO.sp.ind[ANO.sp.ind$ParentGlobalID==as.character(ANO.natopen$GlobalID[i]),c('art_dekning','SS')]
        results.natopen.ANO[['original']][i,'richness'] <- nrow(dat)
        dat <- dat[!is.na(dat$SS),]
        
        if ( nrow(dat)>0 ) {
          
          val <- sum(dat[,'art_dekning'] * dat[,'SS'],na.rm=T) / sum(dat[,'art_dekning'],na.rm=T)
          # lower part of distribution
          if( ANO.natopen$kartleggingsenhet_1m2[i] %in% c("T2-C-7","T2-C-8") ) {
            ref <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='SS1' & natopen.ref.cov.val$grunn==paste(as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),"_BN",sep=""),'Rv']
            lim <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='SS1' & natopen.ref.cov.val$grunn==paste(as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),"_BN",sep=""),'Gv']
          } else {
            ref <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='SS1' & natopen.ref.cov.val$grunn==as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),'Rv']
            lim <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='SS1' & natopen.ref.cov.val$grunn==as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),'Gv']
          }          
          maxmin <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='SS1' & natopen.ref.cov.val$grunn==as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),'maxmin']
          # coercing x into results.natopen.ANO dataframe
          results.natopen.ANO[['scaled']][i,'SS1'] <- scal() 
          results.natopen.ANO[['non-truncated']][i,'SS1'] <- scal.2() 
          results.natopen.ANO[['original']][i,'SS1'] <- val 
          
          # upper part of distribution
          if( ANO.natopen$kartleggingsenhet_1m2[i] %in% c("T2-C-7","T2-C-8") ) {
            ref <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='SS2' & natopen.ref.cov.val$grunn==paste(as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),"_BN",sep=""),'Rv']
            lim <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='SS2' & natopen.ref.cov.val$grunn==paste(as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),"_BN",sep=""),'Gv']
          } else {
            ref <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='SS2' & natopen.ref.cov.val$grunn==as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),'Rv']
            lim <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='SS2' & natopen.ref.cov.val$grunn==as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),'Gv']
          }          
          maxmin <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='SS2' & natopen.ref.cov.val$grunn==as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),'maxmin']
          # coercing x into results.natopen.ANO dataframe
          results.natopen.ANO[['scaled']][i,'SS2'] <- scal() 
          results.natopen.ANO[['non-truncated']][i,'SS2'] <- scal.2() 
          results.natopen.ANO[['original']][i,'SS2'] <- val
        }
        
        
        # Grime's R
        dat <- ANO.sp.ind[ANO.sp.ind$ParentGlobalID==as.character(ANO.natopen$GlobalID[i]),c('art_dekning','RR')]
        results.natopen.ANO[['original']][i,'richness'] <- nrow(dat)
        dat <- dat[!is.na(dat$RR),]
        
        if ( nrow(dat)>0 ) {
          
          val <- sum(dat[,'art_dekning'] * dat[,'RR'],na.rm=T) / sum(dat[,'art_dekning'],na.rm=T)
          # lower part of distribution
          if( ANO.natopen$kartleggingsenhet_1m2[i] %in% c("T2-C-7","T2-C-8") ) {
            ref <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='RR1' & natopen.ref.cov.val$grunn==paste(as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),"_BN",sep=""),'Rv']
            lim <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='RR1' & natopen.ref.cov.val$grunn==paste(as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),"_BN",sep=""),'Gv']
          } else {
            ref <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='RR1' & natopen.ref.cov.val$grunn==as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),'Rv']
            lim <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='RR1' & natopen.ref.cov.val$grunn==as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),'Gv']
          }          
          maxmin <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='RR1' & natopen.ref.cov.val$grunn==as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),'maxmin']
          # coercing x into results.natopen.ANO dataframe
          results.natopen.ANO[['scaled']][i,'RR1'] <- scal() 
          results.natopen.ANO[['non-truncated']][i,'RR1'] <- scal.2() 
          results.natopen.ANO[['original']][i,'RR1'] <- val 
          
          # upper part of distribution
          if( ANO.natopen$kartleggingsenhet_1m2[i] %in% c("T2-C-7","T2-C-8") ) {
            ref <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='RR2' & natopen.ref.cov.val$grunn==paste(as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),"_BN",sep=""),'Rv']
            lim <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='RR2' & natopen.ref.cov.val$grunn==paste(as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),"_BN",sep=""),'Gv']
          } else {
            ref <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='RR2' & natopen.ref.cov.val$grunn==as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),'Rv']
            lim <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='RR2' & natopen.ref.cov.val$grunn==as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),'Gv']
          }          
          maxmin <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='RR2' & natopen.ref.cov.val$grunn==as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),'maxmin']
          # coercing x into results.natopen.ANO dataframe
          results.natopen.ANO[['scaled']][i,'RR2'] <- scal() 
          results.natopen.ANO[['non-truncated']][i,'RR2'] <- scal.2() 
          results.natopen.ANO[['original']][i,'RR2'] <- val
        }
        
        
          # Light
          dat <- ANO.sp.ind[ANO.sp.ind$ParentGlobalID==as.character(ANO.natopen$GlobalID[i]),c('art_dekning','Light')]
          results.natopen.ANO[['original']][i,'richness'] <- nrow(dat)
          dat <- dat[!is.na(dat$Light),]
          
          if ( nrow(dat)>0 ) {
            
            val <- sum(dat[,'art_dekning'] * dat[,'Light'],na.rm=T) / sum(dat[,'art_dekning'],na.rm=T)
            # lower part of distribution
            if( ANO.natopen$kartleggingsenhet_1m2[i] %in% c("T2-C-7","T2-C-8") ) {
              ref <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Light1' & natopen.ref.cov.val$grunn==paste(as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),"_BN",sep=""),'Rv']
              lim <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Light1' & natopen.ref.cov.val$grunn==paste(as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),"_BN",sep=""),'Gv']
            } else {
              ref <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Light1' & natopen.ref.cov.val$grunn==as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),'Rv']
              lim <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Light1' & natopen.ref.cov.val$grunn==as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),'Gv']
            }            
            maxmin <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Light1' & natopen.ref.cov.val$grunn==as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),'maxmin']
            # coercing x into results.natopen.ANO dataframe
            results.natopen.ANO[['scaled']][i,'Light1'] <- scal() 
            results.natopen.ANO[['non-truncated']][i,'Light1'] <- scal.2() 
            results.natopen.ANO[['original']][i,'Light1'] <- val 
            
            # upper part of distribution
            if( ANO.natopen$kartleggingsenhet_1m2[i] %in% c("T2-C-7","T2-C-8") ) {
              ref <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Light2' & natopen.ref.cov.val$grunn==paste(as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),"_BN",sep=""),'Rv']
              lim <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Light2' & natopen.ref.cov.val$grunn==paste(as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),"_BN",sep=""),'Gv']
            } else {
              ref <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Light2' & natopen.ref.cov.val$grunn==as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),'Rv']
              lim <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Light2' & natopen.ref.cov.val$grunn==as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),'Gv']
            }            
            maxmin <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Light2' & natopen.ref.cov.val$grunn==as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),'maxmin']
            # coercing x into results.natopen.ANO dataframe
            results.natopen.ANO[['scaled']][i,'Light2'] <- scal() 
            results.natopen.ANO[['non-truncated']][i,'Light2'] <- scal.2() 
            results.natopen.ANO[['original']][i,'Light2'] <- val
          }
          
          
         
          
          # Nitrogen
          dat <- ANO.sp.ind[ANO.sp.ind$ParentGlobalID==as.character(ANO.natopen$GlobalID[i]),c('art_dekning','Nitrogen')]
          results.natopen.ANO[['original']][i,'richness'] <- nrow(dat)
          dat <- dat[!is.na(dat$Nitrogen),]
          
          if ( nrow(dat)>0 ) {
            
            val <- sum(dat[,'art_dekning'] * dat[,'Nitrogen'],na.rm=T) / sum(dat[,'art_dekning'],na.rm=T)
            # lower part of distribution
            if( ANO.natopen$kartleggingsenhet_1m2[i] %in% c("T2-C-7","T2-C-8") ) {
              ref <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Nitrogen1' & natopen.ref.cov.val$grunn==paste(as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),"_BN",sep=""),'Rv']
              lim <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Nitrogen1' & natopen.ref.cov.val$grunn==paste(as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),"_BN",sep=""),'Gv']
            } else {
              ref <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Nitrogen1' & natopen.ref.cov.val$grunn==as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),'Rv']
              lim <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Nitrogen1' & natopen.ref.cov.val$grunn==as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),'Gv']
            }            
            maxmin <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Nitrogen1' & natopen.ref.cov.val$grunn==as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),'maxmin']
            # coercing x into results.natopen.ANO dataframe
            results.natopen.ANO[['scaled']][i,'Nitrogen1'] <- scal() 
            results.natopen.ANO[['non-truncated']][i,'Nitrogen1'] <- scal.2() 
            results.natopen.ANO[['original']][i,'Nitrogen1'] <- val 
            
            # upper part of distribution
            if( ANO.natopen$kartleggingsenhet_1m2[i] %in% c("T2-C-7","T2-C-8") ) {
              ref <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Nitrogen2' & natopen.ref.cov.val$grunn==paste(as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),"_BN",sep=""),'Rv']
              lim <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Nitrogen2' & natopen.ref.cov.val$grunn==paste(as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),"_BN",sep=""),'Gv']
            } else {
              ref <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Nitrogen2' & natopen.ref.cov.val$grunn==as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),'Rv']
              lim <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Nitrogen2' & natopen.ref.cov.val$grunn==as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),'Gv']
            }            
            maxmin <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Nitrogen2' & natopen.ref.cov.val$grunn==as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),'maxmin']
            # coercing x into results.natopen.ANO dataframe
            results.natopen.ANO[['scaled']][i,'Nitrogen2'] <- scal() 
            results.natopen.ANO[['non-truncated']][i,'Nitrogen2'] <- scal.2() 
            results.natopen.ANO[['original']][i,'Nitrogen2'] <- val
          }
          
          


          
          
          # Soil_disturbance
          dat <- ANO.sp.ind[ANO.sp.ind$ParentGlobalID==as.character(ANO.natopen$GlobalID[i]),c('art_dekning','Soil_disturbance')]
          results.natopen.ANO[['original']][i,'richness'] <- nrow(dat)
          dat <- dat[!is.na(dat$Soil_disturbance),]
          
          if ( nrow(dat)>0 ) {
            
            val <- sum(dat[,'art_dekning'] * dat[,'Soil_disturbance'],na.rm=T) / sum(dat[,'art_dekning'],na.rm=T)
            # lower part of distribution
            if( ANO.natopen$kartleggingsenhet_1m2[i] %in% c("T2-C-7","T2-C-8") ) {
              ref <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Soil_disturbance1' & natopen.ref.cov.val$grunn==paste(as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),"_BN",sep=""),'Rv']
              lim <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Soil_disturbance1' & natopen.ref.cov.val$grunn==paste(as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),"_BN",sep=""),'Gv']
            } else {
              ref <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Soil_disturbance1' & natopen.ref.cov.val$grunn==as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),'Rv']
              lim <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Soil_disturbance1' & natopen.ref.cov.val$grunn==as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),'Gv']
            }           
            maxmin <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Soil_disturbance1' & natopen.ref.cov.val$grunn==as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),'maxmin']
            # coercing x into results.natopen.ANO dataframe
            results.natopen.ANO[['scaled']][i,'Soil_disturbance1'] <- scal() 
            results.natopen.ANO[['non-truncated']][i,'Soil_disturbance1'] <- scal.2() 
            results.natopen.ANO[['original']][i,'Soil_disturbance1'] <- val 
            
            # upper part of distribution
            if( ANO.natopen$kartleggingsenhet_1m2[i] %in% c("T2-C-7","T2-C-8") ) {
              ref <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Soil_disturbance2' & natopen.ref.cov.val$grunn==paste(as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),"_BN",sep=""),'Rv']
              lim <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Soil_disturbance2' & natopen.ref.cov.val$grunn==paste(as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),"_BN",sep=""),'Gv']
            } else {
              ref <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Soil_disturbance2' & natopen.ref.cov.val$grunn==as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),'Rv']
              lim <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Soil_disturbance2' & natopen.ref.cov.val$grunn==as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),'Gv']
            }
            maxmin <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Soil_disturbance2' & natopen.ref.cov.val$grunn==as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),'maxmin']
            # coercing x into results.natopen.ANO dataframe
            results.natopen.ANO[['scaled']][i,'Soil_disturbance2'] <- scal() 
            results.natopen.ANO[['non-truncated']][i,'Soil_disturbance2'] <- scal.2() 
            results.natopen.ANO[['original']][i,'Soil_disturbance2'] <- val
          }
          
          
          
        }
      }
      

    
  }, error=function(e){cat("ERROR :",conditionMessage(e), "\n")})
}

summary(results.natopen.ANO[['original']])
summary(results.natopen.ANO[['scaled']])

# for using both sides of the Ellenberg indicator
results.natopen.ANO[['2-sided']] <- results.natopen.ANO[['non-truncated']]

# check if there are values equalling exactly 1
results.natopen.ANO[['2-sided']]$Light1[results.natopen.ANO[['2-sided']]$Light1==1]
results.natopen.ANO[['2-sided']]$Light2[results.natopen.ANO[['2-sided']]$Light2==1]
results.natopen.ANO[['2-sided']]$Nitrogen1[results.natopen.ANO[['2-sided']]$Nitrogen1==1]
results.natopen.ANO[['2-sided']]$Nitrogen2[results.natopen.ANO[['2-sided']]$Nitrogen2==1]
results.natopen.ANO[['2-sided']]$Soil_disturbance1[results.natopen.ANO[['2-sided']]$Soil_disturbance1==1]
results.natopen.ANO[['2-sided']]$Soil_disturbance2[results.natopen.ANO[['2-sided']]$Soil_disturbance2==1]



# remove values >1 for Ellenberg

results.natopen.ANO[['2-sided']]$CC1[results.natopen.ANO[['2-sided']]$CC1>1] <- NA
results.natopen.ANO[['2-sided']]$CC2[results.natopen.ANO[['2-sided']]$CC2>1] <- NA

results.natopen.ANO[['2-sided']]$SS1[results.natopen.ANO[['2-sided']]$SS1>1] <- NA
results.natopen.ANO[['2-sided']]$SS2[results.natopen.ANO[['2-sided']]$SS2>1] <- NA

results.natopen.ANO[['2-sided']]$RR1[results.natopen.ANO[['2-sided']]$RR1>1] <- NA
results.natopen.ANO[['2-sided']]$RR2[results.natopen.ANO[['2-sided']]$RR2>1] <- NA

results.natopen.ANO[['2-sided']]$Light1[results.natopen.ANO[['2-sided']]$Light1>1] <- NA
results.natopen.ANO[['2-sided']]$Light2[results.natopen.ANO[['2-sided']]$Light2>1] <- NA

results.natopen.ANO[['2-sided']]$Nitrogen1[results.natopen.ANO[['2-sided']]$Nitrogen1>1] <- NA
results.natopen.ANO[['2-sided']]$Nitrogen2[results.natopen.ANO[['2-sided']]$Nitrogen2>1] <- NA

results.natopen.ANO[['2-sided']]$Soil_disturbance1[results.natopen.ANO[['2-sided']]$Soil_disturbance1>1] <- NA
results.natopen.ANO[['2-sided']]$Soil_disturbance2[results.natopen.ANO[['2-sided']]$Soil_disturbance2>1] <- NA


# check distribution
x11()
par(mfrow=c(2,6))

hist(results.natopen.ANO[['2-sided']]$CC1,breaks=40)
hist(results.natopen.ANO[['2-sided']]$CC2,breaks=40)

hist(results.natopen.ANO[['2-sided']]$SS1,breaks=40)
hist(results.natopen.ANO[['2-sided']]$SS2,breaks=40)

hist(results.natopen.ANO[['2-sided']]$RR1,breaks=40)
hist(results.natopen.ANO[['2-sided']]$RR2,breaks=40)

hist(results.natopen.ANO[['2-sided']]$Light1,breaks=40)
hist(results.natopen.ANO[['2-sided']]$Light2,breaks=40)

hist(results.natopen.ANO[['2-sided']]$Nitrogen1,breaks=40)
hist(results.natopen.ANO[['2-sided']]$Nitrogen2,breaks=40)

hist(results.natopen.ANO[['2-sided']]$Soil_disturbance1,breaks=40)
hist(results.natopen.ANO[['2-sided']]$Soil_disturbance2,breaks=40)






#write.table(results.natopen.ANO[['scaled']], file='output/scaled data/results.natopen.ANO_scaled.txt',
#            quote=FALSE,sep="\t",col.names=TRUE,row.names=FALSE,dec=".")
#write.table(results.natopen.ANO[['non-truncated']], file='output/scaled data/results.natopen.ANO_non-truncated.txt',
#            quote=FALSE,sep="\t",col.names=TRUE,row.names=FALSE,dec=".")
#write.table(results.natopen.ANO[['original']], file='P:/41201785_okologisk_tilstand_2022_2023/data/FPI_output large files for markdown/results.natopen.ANO_original.ANO.txt',
#            quote=FALSE,sep="\t",col.names=TRUE,row.names=FALSE,dec=".")
#write.table(results.natopen.ANO[['2-sided']], file='P:/41201785_okologisk_tilstand_2022_2023/data/FPI_output large files for markdown/results.natopen.ANO_2-sided.ANO.txt',
#            quote=FALSE,sep="\t",col.names=TRUE,row.names=FALSE,dec=".")

saveRDS(results.natopen.ANO, "data/cache/results.natopen.ANO.RDS")
rm(list= ls()[!(ls() %in% c('natopen.ref.cov.val','ANO.natopen','results.natopen.ANO','settings'))])
save.image("P:/41201785_okologisk_tilstand_2022_2023/data/FPI_output large files for markdown/results.natopen.ANO.RData")

load("P:/41201785_okologisk_tilstand_2022_2023/data/FPI_output large files for markdown/results.natopen.ANO.RData")
