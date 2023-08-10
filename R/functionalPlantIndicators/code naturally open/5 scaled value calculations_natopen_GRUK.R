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


unique(GRUK.variables$Kartleggingsenhet) # NiN types in data
unique(natopen.ref.cov.val$grunn) # NiN types in reference
levels(as.factor(GRUK.variables$Kartleggingsenhet)) # NiN types in data
levels(natopen.ref.cov.val$grunn) # NiN types in reference
#### creating dataframe to hold the results for natopens ####
# all GRUK points
nrow(GRUK.variables)
GRUK.natopen <- GRUK.variables

head(GRUK.natopen)
# update row-numbers
row.names(GRUK.natopen) <- 1:nrow(GRUK.natopen)
head(GRUK.natopen)
dim(GRUK.natopen)
colnames(GRUK.natopen)

length(levels(as.factor(GRUK.natopen$Flate_ID)))
length(levels(as.factor(GRUK.natopen$uPunkt_ID)))
summary(as.factor(GRUK.natopen$uPunkt_ID))
# none are double

unique(GRUK.natopen$Kartleggingsenhet)
GRUK.natopen$Kartleggingsenhet <- as.factor(GRUK.natopen$Kartleggingsenhet)
summary(GRUK.natopen$Kartleggingsenhet)

results.natopen.GRUK <- list()
ind <- unique(natopen.ref.cov.val$Ind)
# choose columns for site description
colnames(GRUK.natopen)
results.natopen.GRUK[['original']] <- GRUK.natopen


# add columns for indicators
nvar.site <- ncol(results.natopen.GRUK[['original']])
for (i in 1:length(ind) ) {results.natopen.GRUK[['original']][,i+nvar.site] <- NA}
colnames(results.natopen.GRUK[['original']])[(nvar.site+1):(length(ind)+nvar.site)] <- paste(ind)
for (i in (nvar.site+1):(length(ind)+nvar.site) ) {results.natopen.GRUK[['original']][,i] <- as.numeric(results.natopen.GRUK[['original']][,i])}
summary(results.natopen.GRUK[['original']])
#results.natopen.GRUK[['original']]$Region <- as.factor(results.natopen.GRUK[['original']]$Region)
results.natopen.GRUK[['original']]$GlobalID <- as.factor(results.natopen.GRUK[['original']]$GlobalID)
results.natopen.GRUK[['original']]$Flate_ID <- as.factor(results.natopen.GRUK[['original']]$Flate_ID)
results.natopen.GRUK[['original']]$uPunkt_ID <- as.factor(results.natopen.GRUK[['original']]$uPunkt_ID)
results.natopen.GRUK[['original']]$Kartleggingsenhet <- as.factor(results.natopen.GRUK[['original']]$Kartleggingsenhet)


# roll out
results.natopen.GRUK[['scaled']] <- results.natopen.GRUK[['non-truncated']] <- results.natopen.GRUK[['original']]


#### calculating scaled and non-truncated values for the indicators based on the dataset ####
for (i in 1:nrow(GRUK.natopen) ) {  #
  tryCatch({
    print(i)
    print(paste(GRUK.natopen$Flate_ID[i]))
    print(paste(GRUK.natopen$uPunkt_ID[i]))
    #    GRUK.natopen$Hovedoekosystem_sirkel[i]
    #    GRUK.natopen$Hovedoekosystem_rute[i]
    
    
    
    # if the GRUK.hovedtype exists in the reference
#    if (GRUK.natopen$hovedtype_rute[i] %in% unique(substr(natopen.ref.cov.val$grunn,1,2)) ) {
      
      # if there is any species present in current GRUK point  
      if ( length(GRUK.species.ind[GRUK.species.ind$ParentGlobalID==as.character(GRUK.natopen$GlobalID[i]),'Species']) > 0 ) {
        
        
        # Grime's C
        
        dat <- GRUK.species.ind[GRUK.species.ind$ParentGlobalID==as.character(GRUK.natopen$GlobalID[i]),c('art_dekning','CC')]
        results.natopen.GRUK[['original']][i,'richness'] <- nrow(dat)
        dat <- dat[!is.na(dat$CC),]
        
        if ( nrow(dat)>0 ) {
          
          val <- sum(dat[,'art_dekning'] * dat[,'CC'],na.rm=T) / sum(dat[,'art_dekning'],na.rm=T)
          # lower part of distribution
          ref <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='CC1' & natopen.ref.cov.val$grunn==as.character(results.natopen.GRUK[['original']][i,"Kartleggingsenhet"]),'Rv']
          lim <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='CC1' & natopen.ref.cov.val$grunn==as.character(results.natopen.GRUK[['original']][i,"Kartleggingsenhet"]),'Gv']
          maxmin <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='CC1' & natopen.ref.cov.val$grunn==as.character(results.natopen.GRUK[['original']][i,"Kartleggingsenhet"]),'maxmin']
          # coercing x into results.natopen.GRUK dataframe
          results.natopen.GRUK[['scaled']][i,'CC1'] <- scal() 
          results.natopen.GRUK[['non-truncated']][i,'CC1'] <- scal.2() 
          results.natopen.GRUK[['original']][i,'CC1'] <- val 
          
          # upper part of distribution
          ref <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='CC2' & natopen.ref.cov.val$grunn==as.character(results.natopen.GRUK[['original']][i,"Kartleggingsenhet"]),'Rv']
          lim <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='CC2' & natopen.ref.cov.val$grunn==as.character(results.natopen.GRUK[['original']][i,"Kartleggingsenhet"]),'Gv']
          maxmin <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='CC2' & natopen.ref.cov.val$grunn==as.character(results.natopen.GRUK[['original']][i,"Kartleggingsenhet"]),'maxmin']
          # coercing x into results.natopen.GRUK dataframe
          results.natopen.GRUK[['scaled']][i,'CC2'] <- scal() 
          results.natopen.GRUK[['non-truncated']][i,'CC2'] <- scal.2() 
          results.natopen.GRUK[['original']][i,'CC2'] <- val
        }
        
        
        # Grime's S
        dat <- GRUK.species.ind[GRUK.species.ind$ParentGlobalID==as.character(GRUK.natopen$GlobalID[i]),c('art_dekning','SS')]
        results.natopen.GRUK[['original']][i,'richness'] <- nrow(dat)
        dat <- dat[!is.na(dat$SS),]
        
        if ( nrow(dat)>0 ) {
          
          val <- sum(dat[,'art_dekning'] * dat[,'SS'],na.rm=T) / sum(dat[,'art_dekning'],na.rm=T)
          # lower part of distribution
          ref <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='SS1' & natopen.ref.cov.val$grunn==as.character(results.natopen.GRUK[['original']][i,"Kartleggingsenhet"]),'Rv']
          lim <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='SS1' & natopen.ref.cov.val$grunn==as.character(results.natopen.GRUK[['original']][i,"Kartleggingsenhet"]),'Gv']
          maxmin <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='SS1' & natopen.ref.cov.val$grunn==as.character(results.natopen.GRUK[['original']][i,"Kartleggingsenhet"]),'maxmin']
          # coercing x into results.natopen.GRUK dataframe
          results.natopen.GRUK[['scaled']][i,'SS1'] <- scal() 
          results.natopen.GRUK[['non-truncated']][i,'SS1'] <- scal.2() 
          results.natopen.GRUK[['original']][i,'SS1'] <- val 
          
          # upper part of distribution
          ref <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='SS2' & natopen.ref.cov.val$grunn==as.character(results.natopen.GRUK[['original']][i,"Kartleggingsenhet"]),'Rv']
          lim <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='SS2' & natopen.ref.cov.val$grunn==as.character(results.natopen.GRUK[['original']][i,"Kartleggingsenhet"]),'Gv']
          maxmin <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='SS2' & natopen.ref.cov.val$grunn==as.character(results.natopen.GRUK[['original']][i,"Kartleggingsenhet"]),'maxmin']
          # coercing x into results.natopen.GRUK dataframe
          results.natopen.GRUK[['scaled']][i,'SS2'] <- scal() 
          results.natopen.GRUK[['non-truncated']][i,'SS2'] <- scal.2() 
          results.natopen.GRUK[['original']][i,'SS2'] <- val
        }
        
        
        # Grime's R
        dat <- GRUK.species.ind[GRUK.species.ind$ParentGlobalID==as.character(GRUK.natopen$GlobalID[i]),c('art_dekning','RR')]
        results.natopen.GRUK[['original']][i,'richness'] <- nrow(dat)
        dat <- dat[!is.na(dat$RR),]
        
        if ( nrow(dat)>0 ) {
          
          val <- sum(dat[,'art_dekning'] * dat[,'RR'],na.rm=T) / sum(dat[,'art_dekning'],na.rm=T)
          # lower part of distribution
          ref <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='RR1' & natopen.ref.cov.val$grunn==as.character(results.natopen.GRUK[['original']][i,"Kartleggingsenhet"]),'Rv']
          lim <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='RR1' & natopen.ref.cov.val$grunn==as.character(results.natopen.GRUK[['original']][i,"Kartleggingsenhet"]),'Gv']
          maxmin <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='RR1' & natopen.ref.cov.val$grunn==as.character(results.natopen.GRUK[['original']][i,"Kartleggingsenhet"]),'maxmin']
          # coercing x into results.natopen.GRUK dataframe
          results.natopen.GRUK[['scaled']][i,'RR1'] <- scal() 
          results.natopen.GRUK[['non-truncated']][i,'RR1'] <- scal.2() 
          results.natopen.GRUK[['original']][i,'RR1'] <- val 
          
          # upper part of distribution
          ref <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='RR2' & natopen.ref.cov.val$grunn==as.character(results.natopen.GRUK[['original']][i,"Kartleggingsenhet"]),'Rv']
          lim <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='RR2' & natopen.ref.cov.val$grunn==as.character(results.natopen.GRUK[['original']][i,"Kartleggingsenhet"]),'Gv']
          maxmin <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='RR2' & natopen.ref.cov.val$grunn==as.character(results.natopen.GRUK[['original']][i,"Kartleggingsenhet"]),'maxmin']
          # coercing x into results.natopen.GRUK dataframe
          results.natopen.GRUK[['scaled']][i,'RR2'] <- scal() 
          results.natopen.GRUK[['non-truncated']][i,'RR2'] <- scal.2() 
          results.natopen.GRUK[['original']][i,'RR2'] <- val
        }
        
        
        # Light
        dat <- GRUK.species.ind[GRUK.species.ind$ParentGlobalID==as.character(GRUK.natopen$GlobalID[i]),c('art_dekning','Light')]
        results.natopen.GRUK[['original']][i,'richness'] <- nrow(dat)
        dat <- dat[!is.na(dat$Light),]
        
        if ( nrow(dat)>0 ) {
          
          val <- sum(dat[,'art_dekning'] * dat[,'Light'],na.rm=T) / sum(dat[,'art_dekning'],na.rm=T)
          # lower part of distribution
          ref <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Light1' & natopen.ref.cov.val$grunn==as.character(results.natopen.GRUK[['original']][i,"Kartleggingsenhet"]),'Rv']
          lim <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Light1' & natopen.ref.cov.val$grunn==as.character(results.natopen.GRUK[['original']][i,"Kartleggingsenhet"]),'Gv']
          maxmin <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Light1' & natopen.ref.cov.val$grunn==as.character(results.natopen.GRUK[['original']][i,"Kartleggingsenhet"]),'maxmin']
          # coercing x into results.natopen.GRUK dataframe
          results.natopen.GRUK[['scaled']][i,'Light1'] <- scal() 
          results.natopen.GRUK[['non-truncated']][i,'Light1'] <- scal.2() 
          results.natopen.GRUK[['original']][i,'Light1'] <- val 
          
          # upper part of distribution
          ref <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Light2' & natopen.ref.cov.val$grunn==as.character(results.natopen.GRUK[['original']][i,"Kartleggingsenhet"]),'Rv']
          lim <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Light2' & natopen.ref.cov.val$grunn==as.character(results.natopen.GRUK[['original']][i,"Kartleggingsenhet"]),'Gv']
          maxmin <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Light2' & natopen.ref.cov.val$grunn==as.character(results.natopen.GRUK[['original']][i,"Kartleggingsenhet"]),'maxmin']
          # coercing x into results.natopen.GRUK dataframe
          results.natopen.GRUK[['scaled']][i,'Light2'] <- scal() 
          results.natopen.GRUK[['non-truncated']][i,'Light2'] <- scal.2() 
          results.natopen.GRUK[['original']][i,'Light2'] <- val
        }
        
        
        
        
        # Nitrogen
        dat <- GRUK.species.ind[GRUK.species.ind$ParentGlobalID==as.character(GRUK.natopen$GlobalID[i]),c('art_dekning','Nitrogen')]
        results.natopen.GRUK[['original']][i,'richness'] <- nrow(dat)
        dat <- dat[!is.na(dat$Nitrogen),]
        
        if ( nrow(dat)>0 ) {
          
          val <- sum(dat[,'art_dekning'] * dat[,'Nitrogen'],na.rm=T) / sum(dat[,'art_dekning'],na.rm=T)
          # lower part of distribution
          ref <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Nitrogen1' & natopen.ref.cov.val$grunn==as.character(results.natopen.GRUK[['original']][i,"Kartleggingsenhet"]),'Rv']
          lim <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Nitrogen1' & natopen.ref.cov.val$grunn==as.character(results.natopen.GRUK[['original']][i,"Kartleggingsenhet"]),'Gv']
          maxmin <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Nitrogen1' & natopen.ref.cov.val$grunn==as.character(results.natopen.GRUK[['original']][i,"Kartleggingsenhet"]),'maxmin']
          # coercing x into results.natopen.GRUK dataframe
          results.natopen.GRUK[['scaled']][i,'Nitrogen1'] <- scal() 
          results.natopen.GRUK[['non-truncated']][i,'Nitrogen1'] <- scal.2() 
          results.natopen.GRUK[['original']][i,'Nitrogen1'] <- val 
          
          # upper part of distribution
          ref <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Nitrogen2' & natopen.ref.cov.val$grunn==as.character(results.natopen.GRUK[['original']][i,"Kartleggingsenhet"]),'Rv']
          lim <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Nitrogen2' & natopen.ref.cov.val$grunn==as.character(results.natopen.GRUK[['original']][i,"Kartleggingsenhet"]),'Gv']
          maxmin <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Nitrogen2' & natopen.ref.cov.val$grunn==as.character(results.natopen.GRUK[['original']][i,"Kartleggingsenhet"]),'maxmin']
          # coercing x into results.natopen.GRUK dataframe
          results.natopen.GRUK[['scaled']][i,'Nitrogen2'] <- scal() 
          results.natopen.GRUK[['non-truncated']][i,'Nitrogen2'] <- scal.2() 
          results.natopen.GRUK[['original']][i,'Nitrogen2'] <- val
        }
        
        
        
        
        
        
        # Soil_disturbance
        dat <- GRUK.species.ind[GRUK.species.ind$ParentGlobalID==as.character(GRUK.natopen$GlobalID[i]),c('art_dekning','Soil_disturbance')]
        results.natopen.GRUK[['original']][i,'richness'] <- nrow(dat)
        dat <- dat[!is.na(dat$Soil_disturbance),]
        
        if ( nrow(dat)>0 ) {
          
          val <- sum(dat[,'art_dekning'] * dat[,'Soil_disturbance'],na.rm=T) / sum(dat[,'art_dekning'],na.rm=T)
          # lower part of distribution
          ref <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Soil_disturbance1' & natopen.ref.cov.val$grunn==as.character(results.natopen.GRUK[['original']][i,"Kartleggingsenhet"]),'Rv']
          lim <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Soil_disturbance1' & natopen.ref.cov.val$grunn==as.character(results.natopen.GRUK[['original']][i,"Kartleggingsenhet"]),'Gv']
          maxmin <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Soil_disturbance1' & natopen.ref.cov.val$grunn==as.character(results.natopen.GRUK[['original']][i,"Kartleggingsenhet"]),'maxmin']
          # coercing x into results.natopen.GRUK dataframe
          results.natopen.GRUK[['scaled']][i,'Soil_disturbance1'] <- scal() 
          results.natopen.GRUK[['non-truncated']][i,'Soil_disturbance1'] <- scal.2() 
          results.natopen.GRUK[['original']][i,'Soil_disturbance1'] <- val 
          
          # upper part of distribution
          ref <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Soil_disturbance2' & natopen.ref.cov.val$grunn==as.character(results.natopen.GRUK[['original']][i,"Kartleggingsenhet"]),'Rv']
          lim <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Soil_disturbance2' & natopen.ref.cov.val$grunn==as.character(results.natopen.GRUK[['original']][i,"Kartleggingsenhet"]),'Gv']
          maxmin <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Soil_disturbance2' & natopen.ref.cov.val$grunn==as.character(results.natopen.GRUK[['original']][i,"Kartleggingsenhet"]),'maxmin']
          # coercing x into results.natopen.GRUK dataframe
          results.natopen.GRUK[['scaled']][i,'Soil_disturbance2'] <- scal() 
          results.natopen.GRUK[['non-truncated']][i,'Soil_disturbance2'] <- scal.2() 
          results.natopen.GRUK[['original']][i,'Soil_disturbance2'] <- val
        }
        
        
        
      }
#    }
    
    
    
  }, error=function(e){cat("ERROR :",conditionMessage(e), "\n")})
}

summary(results.natopen.GRUK[['original']])
summary(results.natopen.GRUK[['scaled']])

# for using both sides of the Ellenberg indicator
results.natopen.GRUK[['2-sided']] <- results.natopen.GRUK[['non-truncated']]

# check if there are values equalling exactly 1
results.natopen.GRUK[['2-sided']]$Light1[results.natopen.GRUK[['2-sided']]$Light1==1]
results.natopen.GRUK[['2-sided']]$Light2[results.natopen.GRUK[['2-sided']]$Light2==1]
results.natopen.GRUK[['2-sided']]$Nitrogen1[results.natopen.GRUK[['2-sided']]$Nitrogen1==1]
results.natopen.GRUK[['2-sided']]$Nitrogen2[results.natopen.GRUK[['2-sided']]$Nitrogen2==1]
results.natopen.GRUK[['2-sided']]$Soil_disturbance1[results.natopen.GRUK[['2-sided']]$Soil_disturbance1==1]
results.natopen.GRUK[['2-sided']]$Soil_disturbance2[results.natopen.GRUK[['2-sided']]$Soil_disturbance2==1]



# remove values >1 for Ellenberg

results.natopen.GRUK[['2-sided']]$CC1[results.natopen.GRUK[['2-sided']]$CC1>1] <- NA
results.natopen.GRUK[['2-sided']]$CC2[results.natopen.GRUK[['2-sided']]$CC2>1] <- NA

results.natopen.GRUK[['2-sided']]$SS1[results.natopen.GRUK[['2-sided']]$SS1>1] <- NA
results.natopen.GRUK[['2-sided']]$SS2[results.natopen.GRUK[['2-sided']]$SS2>1] <- NA

results.natopen.GRUK[['2-sided']]$RR1[results.natopen.GRUK[['2-sided']]$RR1>1] <- NA
results.natopen.GRUK[['2-sided']]$RR2[results.natopen.GRUK[['2-sided']]$RR2>1] <- NA

results.natopen.GRUK[['2-sided']]$Light1[results.natopen.GRUK[['2-sided']]$Light1>1] <- NA
results.natopen.GRUK[['2-sided']]$Light2[results.natopen.GRUK[['2-sided']]$Light2>1] <- NA

results.natopen.GRUK[['2-sided']]$Nitrogen1[results.natopen.GRUK[['2-sided']]$Nitrogen1>1] <- NA
results.natopen.GRUK[['2-sided']]$Nitrogen2[results.natopen.GRUK[['2-sided']]$Nitrogen2>1] <- NA

results.natopen.GRUK[['2-sided']]$Soil_disturbance1[results.natopen.GRUK[['2-sided']]$Soil_disturbance1>1] <- NA
results.natopen.GRUK[['2-sided']]$Soil_disturbance2[results.natopen.GRUK[['2-sided']]$Soil_disturbance2>1] <- NA


# check distribution
x11()
par(mfrow=c(2,6))

hist(results.natopen.GRUK[['2-sided']]$CC1,breaks=40)
hist(results.natopen.GRUK[['2-sided']]$CC2,breaks=40)

hist(results.natopen.GRUK[['2-sided']]$SS1,breaks=40)
hist(results.natopen.GRUK[['2-sided']]$SS2,breaks=40)

hist(results.natopen.GRUK[['2-sided']]$RR1,breaks=40)
hist(results.natopen.GRUK[['2-sided']]$RR2,breaks=40)

hist(results.natopen.GRUK[['2-sided']]$Light1,breaks=40)
hist(results.natopen.GRUK[['2-sided']]$Light2,breaks=40)

hist(results.natopen.GRUK[['2-sided']]$Nitrogen1,breaks=40)
hist(results.natopen.GRUK[['2-sided']]$Nitrogen2,breaks=40)

hist(results.natopen.GRUK[['2-sided']]$Soil_disturbance1,breaks=40)
hist(results.natopen.GRUK[['2-sided']]$Soil_disturbance2,breaks=40)






#write.table(results.natopen.GRUK[['scaled']], file='output/scaled data/results.natopen.GRUK_scaled.txt',
#            quote=FALSE,sep="\t",col.names=TRUE,row.names=FALSE,dec=".")
#write.table(results.natopen.GRUK[['non-truncated']], file='output/scaled data/results.natopen.GRUK_non-truncated.txt',
#            quote=FALSE,sep="\t",col.names=TRUE,row.names=FALSE,dec=".")
#write.table(results.natopen.GRUK[['original']], file='P:/41201785_okologisk_tilstand_2022_2023/data/FPI_output large files for markdown/results.natopen.GRUK_original.GRUK.txt',
#            quote=FALSE,sep="\t",col.names=TRUE,row.names=FALSE,dec=".")
#write.table(results.natopen.GRUK[['2-sided']], file='P:/41201785_okologisk_tilstand_2022_2023/data/FPI_output large files for markdown/results.natopen.GRUK_2-sided.GRUK.txt',
#            quote=FALSE,sep="\t",col.names=TRUE,row.names=FALSE,dec=".")

saveRDS(results.natopen.GRUK, "data/cache/results.natopen.GRUK.RDS")
rm(list= ls()[!(ls() %in% c('natopen.ref.cov.val','GRUK.natopen','results.natopen.GRUK','settings'))])
save.image("P:/41201785_okologisk_tilstand_2022_2023/data/FPI_output large files for markdown/results.natopen.GRUK.RData")

load("P:/41201785_okologisk_tilstand_2022_2023/data/FPI_output large files for markdown/results.natopen.GRUK.RData")
