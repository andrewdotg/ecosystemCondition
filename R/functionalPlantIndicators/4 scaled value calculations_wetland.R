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
unique(substr(wetland.ref.val$grunn,1,2)) # NiN types in reference
#### creating dataframe to holde the results for wetlands ####
# all ANO points
nrow(ANO.geo)
# all wetland ANO points
nrow(ANO.geo[ANO.geo$hovedtype_rute %in% list("V1","V2","V3","V4","V5","V6","V7","V8","V9","V10","V11","V12","V13"),])
# all wetland ANO points with a NiN-type represented in the reference
nrow(ANO.geo[ANO.geo$hovedtype_rute %in% unique(substr(wetland.ref.val$grunn,1,2)),])
# ok, we'll be losing 70 (our of 1349) that are not covered by the reference
ANO.wetland <- ANO.geo[ANO.geo$hovedtype_rute %in% list("V1","V2","V3","V4","V5","V6","V7","V8","V9","V10","V11","V12","V13"),]

head(ANO.wetland)
# update row-numbers
row.names(ANO.wetland) <- 1:nrow(ANO.wetland)
head(ANO.wetland)
dim(ANO.wetland)
colnames(ANO.wetland)

length(levels(as.factor(ANO.wetland$ano_flate_id)))
length(levels(as.factor(ANO.wetland$ano_punkt_id)))
summary(as.factor(ANO.wetland$ano_punkt_id))
# four points that are double
ANO.wetland[ANO.wetland$ano_punkt_id=="ANO0159_55",] # double registration, said so in comment. -> choose row 207 over 206
ANO.wetland <- ANO.wetland[-206,]
row.names(ANO.wetland) <- 1:nrow(ANO.wetland) # update row-numbers
ANO.wetland[ANO.wetland$ano_punkt_id=="ANO0283_22",] # 2019 & 2021. Lot of NA's in 2019 -> omit 2019
ANO.wetland <- ANO.wetland[-156,]
row.names(ANO.wetland) <- 1:nrow(ANO.wetland) # update row-numbers
ANO.wetland[ANO.wetland$ano_punkt_id=="ANO0363_24",]
ANO.wetland[ANO.wetland$ano_flate_id=="ANO0363","ano_punkt_id"] # point-ID 15 is missing, but 24 is double. Likely that registrations are valid, but wrong point-ID.  -> keep both, call the second obs the one that's missing
ANO.wetland[311,"ano_punkt_id"] <- "ANO0363_15"
ANO.wetland[ANO.wetland$ano_punkt_id=="ANO1550_64",] # point-ID 66 is missing, but 64 is double. Likely that registrations are valid, but wrong point-ID.  -> keep both
ANO.wetland[ANO.wetland$ano_flate_id=="ANO1550","ano_punkt_id"] # point-ID 66 is missing, but 64 is double. Likely that registrations are valid, but wrong point-ID.  -> keep both
ANO.wetland[1273,"ano_punkt_id"] <- "ANO1550_66"

unique(ANO.wetland$hovedoekosystem_punkt)
unique(ANO.wetland$hovedtype_rute)
unique(ANO.wetland$kartleggingsenhet_1m2)
ANO.wetland$hovedtype_rute <- factor(ANO.wetland$hovedtype_rute)
ANO.wetland$kartleggingsenhet_1m2 <- factor(ANO.wetland$kartleggingsenhet_1m2)
summary(ANO.wetland$Hovedtype_rute)
summary(ANO.wetland$Kartleggingsenhet_rute)

results.wetland <- list()
ind <- unique(wetland.ref.cov.val$Ind)
# choose columns for site description
colnames(ANO.wetland)
results.wetland[['original']] <- ANO.wetland
# drop geometry
st_geometry(results.wetland[['original']]) <- NULL
results.wetland[['original']]

# add columns for indicators
nvar.site <- ncol(results.wetland[['original']])
for (i in 1:length(ind) ) {results.wetland[['original']][,i+nvar.site] <- NA}
colnames(results.wetland[['original']])[(nvar.site+1):(length(ind)+nvar.site)] <- paste(ind)
for (i in (nvar.site+1):(length(ind)+nvar.site) ) {results.wetland[['original']][,i] <- as.numeric(results.wetland[['original']][,i])}
summary(results.wetland[['original']])
#results.wetland[['original']]$Region <- as.factor(results.wetland[['original']]$Region)
results.wetland[['original']]$GlobalID <- as.factor(results.wetland[['original']]$GlobalID)
results.wetland[['original']]$ano_flate_id <- as.factor(results.wetland[['original']]$ano_flate_id)
results.wetland[['original']]$ano_punkt_id <- as.factor(results.wetland[['original']]$ano_punkt_id)
results.wetland[['original']]$hovedoekosystem_punkt <- as.factor(results.wetland[['original']]$hovedoekosystem_punkt)
#results.wetland[['original']]$Hovedoekosystem_rute  <- as.factor(results.wetland[['original']]$Hovedoekosystem_rute )
results.wetland[['original']]$kartleggingsenhet_1m2 <- as.factor(results.wetland[['original']]$kartleggingsenhet_1m2)
results.wetland[['original']]$hovedtype_rute    <- as.factor(results.wetland[['original']]$hovedtype_rute)


# roll out
results.wetland[['scaled']] <- results.wetland[['non-truncated']] <- results.wetland[['original']]


#### calculating scaled and non-truncated values for the indicators based on the dataset ####
for (i in 1:nrow(ANO.wetland) ) {  #
  tryCatch({
    print(i)
    print(paste(ANO.wetland$ano_flate_id[i]))
    print(paste(ANO.wetland$ano_punkt_id[i]))
#    ANO.wetland$Hovedoekosystem_sirkel[i]
#    ANO.wetland$Hovedoekosystem_rute[i]



    
    if (ANO.wetland$hovedtype_rute[i] %in% unique(substr(wetland.ref.val$grunn,1,2)) ) {
      
      # species indicator values  
      if ( length(ANO.sp.ind[ANO.sp.ind$ParentGlobalID==as.character(ANO.wetland$GlobalID[i]),'Species']) > 0 ) {
        
        
          # Continentality
          dat <- ANO.sp.ind[ANO.sp.ind$ParentGlobalID==as.character(ANO.wetland$GlobalID[i]),c('art_dekning','Continentality','kartleggingsenhet_1m2')]
          results.wetland[['original']][i,'richness'] <- nrow(dat)
          dat <- dat[!is.na(dat$Continentality),]
          
          if ( nrow(dat)>0 ) {
            
            val <- sum(dat[,'art_dekning'] * dat[,'Continentality'],na.rm=T) / sum(dat[,'art_dekning'],na.rm=T)
            # lower part of distribution
            ref <- wetland.ref.cov.val[wetland.ref.cov.val$Ind=='Cont1' & wetland.ref.cov.val$grunn==as.character(unique(dat$kartleggingsenhet_1m2)),'Rv']
            lim <- wetland.ref.cov.val[wetland.ref.cov.val$Ind=='Cont1' & wetland.ref.cov.val$grunn==as.character(unique(dat$kartleggingsenhet_1m2)),'Gv']
            maxmin <- wetland.ref.cov.val[wetland.ref.cov.val$Ind=='Cont1' & wetland.ref.cov.val$grunn==as.character(unique(dat$kartleggingsenhet_1m2)),'maxmin']
            # coercing x into results.wetland dataframe
            results.wetland[['scaled']][i,'EllN1'] <- scal() 
            results.wetland[['non-truncated']][i,'EllN1'] <- scal.2() 
            results.wetland[['original']][i,'EllN1'] <- val 
            
            # upper part of distribution
            ref <- wetland.ref.cov.val[wetland.ref.cov.val$Ind=='EllN2' & wetland.ref.cov.val$grunn==as.character(unique(dat$Kartleggingsenhet_rute)),'Rv']
            lim <- wetland.ref.cov.val[wetland.ref.cov.val$Ind=='EllN2' & wetland.ref.cov.val$grunn==as.character(unique(dat$Kartleggingsenhet_rute)),'Gv']
            maxmin <- wetland.ref.cov.val[wetland.ref.cov.val$Ind=='EllN2' & wetland.ref.cov.val$grunn==as.character(unique(dat$Kartleggingsenhet_rute)),'maxmin']
            # coercing x into results.wetland dataframe
            results.wetland[['scaled']][i,'EllN2'] <- scal() 
            results.wetland[['non-truncated']][i,'EllN2'] <- scal.2() 
            results.wetland[['original']][i,'EllN2'] <- val
          }
          
          #Ellenberg L
          dat <- ANO.sp.ind[ANO.sp.ind$ParentGlobalID==as.character(ANO.wetland$GlobalID[i]),c('Dekning','L','Kartleggingsenhet_rute')]
          dat <- dat[!is.na(dat$L),]
          
          if ( nrow(dat)>0 ) {
            
            val <- sum(dat[,'Dekning'] * dat[,'L'],na.rm=T) / sum(dat[,'Dekning'],na.rm=T)
            # lower part of distribution
            ref <- wetland.cov.ref[wetland.cov.ref$Ind=='EllL1' & wetland.cov.ref$grunn==as.character(unique(dat$Kartleggingsenhet_rute)),'Rv']
            lim <- wetland.cov.ref[wetland.cov.ref$Ind=='EllL1' & wetland.cov.ref$grunn==as.character(unique(dat$Kartleggingsenhet_rute)),'Gv']
            maxmin <- wetland.cov.ref[wetland.cov.ref$Ind=='EllL1' & wetland.cov.ref$grunn==as.character(unique(dat$Kartleggingsenhet_rute)),'maxmin']
            # coercing x into results.wetland dataframe
            results.wetland[['scaled']][i,'EllL1'] <- scal() 
            results.wetland[['non-truncated']][i,'EllL1'] <- scal.2() 
            results.wetland[['original']][i,'EllL1'] <- val 
            
            # upper part of distribution
            ref <- wetland.cov.ref[wetland.cov.ref$Ind=='EllL2' & wetland.cov.ref$grunn==as.character(unique(dat$Kartleggingsenhet_rute)),'Rv']
            lim <- wetland.cov.ref[wetland.cov.ref$Ind=='EllL2' & wetland.cov.ref$grunn==as.character(unique(dat$Kartleggingsenhet_rute)),'Gv']
            maxmin <- wetland.cov.ref[wetland.cov.ref$Ind=='EllL2' & wetland.cov.ref$grunn==as.character(unique(dat$Kartleggingsenhet_rute)),'maxmin']
            # coercing x into results.wetland dataframe
            results.wetland[['scaled']][i,'EllL2'] <- scal() 
            results.wetland[['non-truncated']][i,'EllL2'] <- scal.2() 
            results.wetland[['original']][i,'EllL2'] <- val
          }
          
          #Ellenberg R
          dat <- ANO.sp.ind[ANO.sp.ind$ParentGlobalID==as.character(ANO.wetland$GlobalID[i]),c('Dekning','R','Kartleggingsenhet_rute')]
          dat <- dat[!is.na(dat$R),]
          
          if ( nrow(dat)>0 ) {
            
            val <- sum(dat[,'Dekning'] * dat[,'R'],na.rm=T) / sum(dat[,'Dekning'],na.rm=T)
            # lower part of distribution
            ref <- wetland.cov.ref[wetland.cov.ref$Ind=='EllR1' & wetland.cov.ref$grunn==as.character(unique(dat$Kartleggingsenhet_rute)),'Rv']
            lim <- wetland.cov.ref[wetland.cov.ref$Ind=='EllR1' & wetland.cov.ref$grunn==as.character(unique(dat$Kartleggingsenhet_rute)),'Gv']
            maxmin <- wetland.cov.ref[wetland.cov.ref$Ind=='EllR1' & wetland.cov.ref$grunn==as.character(unique(dat$Kartleggingsenhet_rute)),'maxmin']
            # coercing x into results.wetland dataframe
            results.wetland[['scaled']][i,'EllR1'] <- scal() 
            results.wetland[['non-truncated']][i,'EllR1'] <- scal.2() 
            results.wetland[['original']][i,'EllR1'] <- val 
            
            # upper part of distribution
            ref <- wetland.cov.ref[wetland.cov.ref$Ind=='EllR2' & wetland.cov.ref$grunn==as.character(unique(dat$Kartleggingsenhet_rute)),'Rv']
            lim <- wetland.cov.ref[wetland.cov.ref$Ind=='EllR2' & wetland.cov.ref$grunn==as.character(unique(dat$Kartleggingsenhet_rute)),'Gv']
            maxmin <- wetland.cov.ref[wetland.cov.ref$Ind=='EllR2' & wetland.cov.ref$grunn==as.character(unique(dat$Kartleggingsenhet_rute)),'maxmin']
            # coercing x into results.wetland dataframe
            results.wetland[['scaled']][i,'EllR2'] <- scal() 
            results.wetland[['non-truncated']][i,'EllR2'] <- scal.2() 
            results.wetland[['original']][i,'EllR2'] <- val
          }
          
          
        }
      }
      

    
  }, error=function(e){cat("ERROR :",conditionMessage(e), "\n")})
}

summary(results.wetland[['original']])
summary(results.wetland[['scaled']])

# for using both sides of the Ellenberg indicator
results.wetland[['2-sided_Ellenberg']] <- results.wetland[['non-truncated']]

# check if there are values equalling exactly 1
results.wetland[['2-sided_Ellenberg']]$EllN1[results.wetland[['2-sided_Ellenberg']]$EllN1==1]
results.wetland[['2-sided_Ellenberg']]$EllN2[results.wetland[['2-sided_Ellenberg']]$EllN2==1]
results.wetland[['2-sided_Ellenberg']]$EllR1[results.wetland[['2-sided_Ellenberg']]$EllN1==1]
results.wetland[['2-sided_Ellenberg']]$EllR2[results.wetland[['2-sided_Ellenberg']]$EllN2==1]
results.wetland[['2-sided_Ellenberg']]$EllL1[results.wetland[['2-sided_Ellenberg']]$EllN1==1]
results.wetland[['2-sided_Ellenberg']]$EllL2[results.wetland[['2-sided_Ellenberg']]$EllN2==1]

# remove values >1 for Ellenberg
results.wetland[['2-sided_Ellenberg']]$EllN1[results.wetland[['2-sided_Ellenberg']]$EllN1>1] <- NA
results.wetland[['2-sided_Ellenberg']]$EllN2[results.wetland[['2-sided_Ellenberg']]$EllN2>1] <- NA

results.wetland[['2-sided_Ellenberg']]$EllR1[results.wetland[['2-sided_Ellenberg']]$EllR1>1] <- NA
results.wetland[['2-sided_Ellenberg']]$EllR2[results.wetland[['2-sided_Ellenberg']]$EllR2>1] <- NA

results.wetland[['2-sided_Ellenberg']]$EllL1[results.wetland[['2-sided_Ellenberg']]$EllL1>1] <- NA
results.wetland[['2-sided_Ellenberg']]$EllL2[results.wetland[['2-sided_Ellenberg']]$EllL2>1] <- NA


# check distributions
par(mfrow=c(3,2))
hist(results.wetland[['2-sided_Ellenberg']]$EllN1,breaks=40)
hist(results.wetland[['2-sided_Ellenberg']]$EllN2,breaks=40)

hist(results.wetland[['2-sided_Ellenberg']]$EllR1,breaks=40)
hist(results.wetland[['2-sided_Ellenberg']]$EllR2,breaks=40)

hist(results.wetland[['2-sided_Ellenberg']]$EllL1,breaks=40)
hist(results.wetland[['2-sided_Ellenberg']]$EllL2,breaks=40)



write.table(results.wetland[['scaled']], file='output/scaled data/results.wetland_scaled.txt',
            quote=FALSE,sep="\t",col.names=TRUE,row.names=FALSE,dec=".")
write.table(results.wetland[['non-truncated']], file='output/scaled data/results.wetland_non-truncated.txt',
            quote=FALSE,sep="\t",col.names=TRUE,row.names=FALSE,dec=".")
write.table(results.wetland[['original']], file='output/scaled data/results.wetland_original.txt',
            quote=FALSE,sep="\t",col.names=TRUE,row.names=FALSE,dec=".")
write.table(results.wetland[['2-sided_Ellenberg']], file='output/scaled data/results.wetland_2-sided_Ellenberg.txt',
            quote=FALSE,sep="\t",col.names=TRUE,row.names=FALSE,dec=".")
