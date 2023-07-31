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
# all natopen ANO points (T2)
nrow(ANO.geo[ANO.geo$hovedtype_rute %in% list("T2"),])
# all natopen ANO points with a NiN-type represented in the reference
nrow(ANO.geo[ANO.geo$hovedtype_rute %in% unique(substr(natopen.ref.cov.val$grunn,1,2)),])
# leaving us with a total of 193 ANO-points
ANO.natopen <- ANO.geo[ANO.geo$hovedtype_rute %in% list("T2"),]

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
ANO.natopen[ANO.natopen$ano_punkt_id=="ANO0084_51",] # double registration, said so in comment. -> choose row 207 over 206
ANO.geo[ANO.geo$ano_flate_id=="ANO0084","ano_punkt_id"]

#### continue here ####

#ANO.natopen <- ANO.natopen[-206,]
#row.names(ANO.natopen) <- 1:nrow(ANO.natopen) # update row-numbers

unique(ANO.natopen$hovedoekosystem_punkt)
unique(ANO.natopen$hovedtype_rute)
unique(ANO.natopen$kartleggingsenhet_1m2)
ANO.natopen$hovedtype_rute <- as.factor(ANO.natopen$hovedtype_rute)
ANO.natopen$kartleggingsenhet_1m2 <- as.factor(ANO.natopen$kartleggingsenhet_1m2)
summary(ANO.natopen$hovedtype_rute)
summary(ANO.natopen$kartleggingsenhet_1m2)
# we have the T41 reference only for the hovedtype -> make T41-C-1 into T41
ANO.natopen[ANO.natopen$kartleggingsenhet_1m2=="T41-C-1","kartleggingsenhet_1m2"] <- "T41"
summary(ANO.natopen$kartleggingsenhet_1m2)

ANO.natopen[ANO.natopen$kartleggingsenhet_1m2=="T32",]
ANO.natopen[ANO.natopen$kartleggingsenhet_1m2=="T34",]
# for T32 og T34 without grunntype-registration there's no useful reference, these won't be processed further

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
    if (ANO.natopen$hovedtype_rute[i] %in% unique(substr(natopen.ref.cov.val$grunn,1,3)) ) {
      
      # if there is any species present in current ANO point  
      if ( length(ANO.sp.ind[ANO.sp.ind$ParentGlobalID==as.character(ANO.natopen$GlobalID[i]),'Species']) > 0 ) {
        

          
          # Light
          dat <- ANO.sp.ind[ANO.sp.ind$ParentGlobalID==as.character(ANO.natopen$GlobalID[i]),c('art_dekning','Light')]
          results.natopen.ANO[['original']][i,'richness'] <- nrow(dat)
          dat <- dat[!is.na(dat$Light),]
          
          if ( nrow(dat)>0 ) {
            
            val <- sum(dat[,'art_dekning'] * dat[,'Light'],na.rm=T) / sum(dat[,'art_dekning'],na.rm=T)
            # lower part of distribution
            ref <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Light1' & natopen.ref.cov.val$grunn==as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),'Rv']
            lim <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Light1' & natopen.ref.cov.val$grunn==as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),'Gv']
            maxmin <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Light1' & natopen.ref.cov.val$grunn==as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),'maxmin']
            # coercing x into results.natopen.ANO dataframe
            results.natopen.ANO[['scaled']][i,'Light1'] <- scal() 
            results.natopen.ANO[['non-truncated']][i,'Light1'] <- scal.2() 
            results.natopen.ANO[['original']][i,'Light1'] <- val 
            
            # upper part of distribution
            ref <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Light2' & natopen.ref.cov.val$grunn==as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),'Rv']
            lim <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Light2' & natopen.ref.cov.val$grunn==as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),'Gv']
            maxmin <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Light2' & natopen.ref.cov.val$grunn==as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),'maxmin']
            # coercing x into results.natopen.ANO dataframe
            results.natopen.ANO[['scaled']][i,'Light2'] <- scal() 
            results.natopen.ANO[['non-truncated']][i,'Light2'] <- scal.2() 
            results.natopen.ANO[['original']][i,'Light2'] <- val
          }
          
          
          # Moisture
          dat <- ANO.sp.ind[ANO.sp.ind$ParentGlobalID==as.character(ANO.natopen$GlobalID[i]),c('art_dekning','Moisture')]
          results.natopen.ANO[['original']][i,'richness'] <- nrow(dat)
          dat <- dat[!is.na(dat$Moisture),]
          
          if ( nrow(dat)>0 ) {
            
            val <- sum(dat[,'art_dekning'] * dat[,'Moisture'],na.rm=T) / sum(dat[,'art_dekning'],na.rm=T)
            # lower part of distribution
            ref <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Moist1' & natopen.ref.cov.val$grunn==as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),'Rv']
            lim <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Moist1' & natopen.ref.cov.val$grunn==as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),'Gv']
            maxmin <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Moist1' & natopen.ref.cov.val$grunn==as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),'maxmin']
            # coercing x into results.natopen.ANO dataframe
            results.natopen.ANO[['scaled']][i,'Moist1'] <- scal() 
            results.natopen.ANO[['non-truncated']][i,'Moist1'] <- scal.2() 
            results.natopen.ANO[['original']][i,'Moist1'] <- val 
            
            # upper part of distribution
            ref <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Moist2' & natopen.ref.cov.val$grunn==as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),'Rv']
            lim <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Moist2' & natopen.ref.cov.val$grunn==as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),'Gv']
            maxmin <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Moist2' & natopen.ref.cov.val$grunn==as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),'maxmin']
            # coercing x into results.natopen.ANO dataframe
            results.natopen.ANO[['scaled']][i,'Moist2'] <- scal() 
            results.natopen.ANO[['non-truncated']][i,'Moist2'] <- scal.2() 
            results.natopen.ANO[['original']][i,'Moist2'] <- val
          }
          
          
          # Soil_reaction_pH
          dat <- ANO.sp.ind[ANO.sp.ind$ParentGlobalID==as.character(ANO.natopen$GlobalID[i]),c('art_dekning','Soil_reaction_pH')]
          results.natopen.ANO[['original']][i,'richness'] <- nrow(dat)
          dat <- dat[!is.na(dat$Soil_reaction_pH),]
          
          if ( nrow(dat)>0 ) {
            
            val <- sum(dat[,'art_dekning'] * dat[,'Soil_reaction_pH'],na.rm=T) / sum(dat[,'art_dekning'],na.rm=T)
            # lower part of distribution
            ref <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='pH1' & natopen.ref.cov.val$grunn==as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),'Rv']
            lim <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='pH1' & natopen.ref.cov.val$grunn==as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),'Gv']
            maxmin <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='pH1' & natopen.ref.cov.val$grunn==as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),'maxmin']
            # coercing x into results.natopen.ANO dataframe
            results.natopen.ANO[['scaled']][i,'pH1'] <- scal() 
            results.natopen.ANO[['non-truncated']][i,'pH1'] <- scal.2() 
            results.natopen.ANO[['original']][i,'pH1'] <- val 
            
            # upper part of distribution
            ref <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='pH2' & natopen.ref.cov.val$grunn==as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),'Rv']
            lim <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='pH2' & natopen.ref.cov.val$grunn==as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),'Gv']
            maxmin <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='pH2' & natopen.ref.cov.val$grunn==as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),'maxmin']
            # coercing x into results.natopen.ANO dataframe
            results.natopen.ANO[['scaled']][i,'pH2'] <- scal() 
            results.natopen.ANO[['non-truncated']][i,'pH2'] <- scal.2() 
            results.natopen.ANO[['original']][i,'pH2'] <- val
          }
          
          
          # Nitrogen
          dat <- ANO.sp.ind[ANO.sp.ind$ParentGlobalID==as.character(ANO.natopen$GlobalID[i]),c('art_dekning','Nitrogen')]
          results.natopen.ANO[['original']][i,'richness'] <- nrow(dat)
          dat <- dat[!is.na(dat$Nitrogen),]
          
          if ( nrow(dat)>0 ) {
            
            val <- sum(dat[,'art_dekning'] * dat[,'Nitrogen'],na.rm=T) / sum(dat[,'art_dekning'],na.rm=T)
            # lower part of distribution
            ref <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Nitrogen1' & natopen.ref.cov.val$grunn==as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),'Rv']
            lim <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Nitrogen1' & natopen.ref.cov.val$grunn==as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),'Gv']
            maxmin <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Nitrogen1' & natopen.ref.cov.val$grunn==as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),'maxmin']
            # coercing x into results.natopen.ANO dataframe
            results.natopen.ANO[['scaled']][i,'Nitrogen1'] <- scal() 
            results.natopen.ANO[['non-truncated']][i,'Nitrogen1'] <- scal.2() 
            results.natopen.ANO[['original']][i,'Nitrogen1'] <- val 
            
            # upper part of distribution
            ref <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Nitrogen2' & natopen.ref.cov.val$grunn==as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),'Rv']
            lim <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Nitrogen2' & natopen.ref.cov.val$grunn==as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),'Gv']
            maxmin <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Nitrogen2' & natopen.ref.cov.val$grunn==as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),'maxmin']
            # coercing x into results.natopen.ANO dataframe
            results.natopen.ANO[['scaled']][i,'Nitrogen2'] <- scal() 
            results.natopen.ANO[['non-truncated']][i,'Nitrogen2'] <- scal.2() 
            results.natopen.ANO[['original']][i,'Nitrogen2'] <- val
          }
          
          
          # Phosphorus
          dat <- ANO.sp.ind[ANO.sp.ind$ParentGlobalID==as.character(ANO.natopen$GlobalID[i]),c('art_dekning','Phosphorus')]
          results.natopen.ANO[['original']][i,'richness'] <- nrow(dat)
          dat <- dat[!is.na(dat$Phosphorus),]
          
          if ( nrow(dat)>0 ) {
            
            val <- sum(dat[,'art_dekning'] * dat[,'Phosphorus'],na.rm=T) / sum(dat[,'art_dekning'],na.rm=T)
            # lower part of distribution
            ref <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Phosphorus1' & natopen.ref.cov.val$grunn==as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),'Rv']
            lim <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Phosphorus1' & natopen.ref.cov.val$grunn==as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),'Gv']
            maxmin <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Phosphorus1' & natopen.ref.cov.val$grunn==as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),'maxmin']
            # coercing x into results.natopen.ANO dataframe
            results.natopen.ANO[['scaled']][i,'Phosphorus1'] <- scal() 
            results.natopen.ANO[['non-truncated']][i,'Phosphorus1'] <- scal.2() 
            results.natopen.ANO[['original']][i,'Phosphorus1'] <- val 
            
            # upper part of distribution
            ref <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Phosphorus2' & natopen.ref.cov.val$grunn==as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),'Rv']
            lim <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Phosphorus2' & natopen.ref.cov.val$grunn==as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),'Gv']
            maxmin <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Phosphorus2' & natopen.ref.cov.val$grunn==as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),'maxmin']
            # coercing x into results.natopen.ANO dataframe
            results.natopen.ANO[['scaled']][i,'Phosphorus2'] <- scal() 
            results.natopen.ANO[['non-truncated']][i,'Phosphorus2'] <- scal.2() 
            results.natopen.ANO[['original']][i,'Phosphorus2'] <- val
          }
          
          
          # Grazing_mowing
          dat <- ANO.sp.ind[ANO.sp.ind$ParentGlobalID==as.character(ANO.natopen$GlobalID[i]),c('art_dekning','Grazing_mowing')]
          results.natopen.ANO[['original']][i,'richness'] <- nrow(dat)
          dat <- dat[!is.na(dat$Grazing_mowing),]
          
          if ( nrow(dat)>0 ) {
            
            val <- sum(dat[,'art_dekning'] * dat[,'Grazing_mowing'],na.rm=T) / sum(dat[,'art_dekning'],na.rm=T)
            # lower part of distribution
            ref <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Grazing_mowing1' & natopen.ref.cov.val$grunn==as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),'Rv']
            lim <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Grazing_mowing1' & natopen.ref.cov.val$grunn==as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),'Gv']
            maxmin <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Grazing_mowing1' & natopen.ref.cov.val$grunn==as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),'maxmin']
            # coercing x into results.natopen.ANO dataframe
            results.natopen.ANO[['scaled']][i,'Grazing_mowing1'] <- scal() 
            results.natopen.ANO[['non-truncated']][i,'Grazing_mowing1'] <- scal.2() 
            results.natopen.ANO[['original']][i,'Grazing_mowing1'] <- val 
            
            # upper part of distribution
            ref <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Grazing_mowing2' & natopen.ref.cov.val$grunn==as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),'Rv']
            lim <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Grazing_mowing2' & natopen.ref.cov.val$grunn==as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),'Gv']
            maxmin <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Grazing_mowing2' & natopen.ref.cov.val$grunn==as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),'maxmin']
            # coercing x into results.natopen.ANO dataframe
            results.natopen.ANO[['scaled']][i,'Grazing_mowing2'] <- scal() 
            results.natopen.ANO[['non-truncated']][i,'Grazing_mowing2'] <- scal.2() 
            results.natopen.ANO[['original']][i,'Grazing_mowing2'] <- val
          }
          
          
          # Soil_disturbance
          dat <- ANO.sp.ind[ANO.sp.ind$ParentGlobalID==as.character(ANO.natopen$GlobalID[i]),c('art_dekning','Soil_disturbance')]
          results.natopen.ANO[['original']][i,'richness'] <- nrow(dat)
          dat <- dat[!is.na(dat$Soil_disturbance),]
          
          if ( nrow(dat)>0 ) {
            
            val <- sum(dat[,'art_dekning'] * dat[,'Soil_disturbance'],na.rm=T) / sum(dat[,'art_dekning'],na.rm=T)
            # lower part of distribution
            ref <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Soil_disturbance1' & natopen.ref.cov.val$grunn==as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),'Rv']
            lim <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Soil_disturbance1' & natopen.ref.cov.val$grunn==as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),'Gv']
            maxmin <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Soil_disturbance1' & natopen.ref.cov.val$grunn==as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),'maxmin']
            # coercing x into results.natopen.ANO dataframe
            results.natopen.ANO[['scaled']][i,'Soil_disturbance1'] <- scal() 
            results.natopen.ANO[['non-truncated']][i,'Soil_disturbance1'] <- scal.2() 
            results.natopen.ANO[['original']][i,'Soil_disturbance1'] <- val 
            
            # upper part of distribution
            ref <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Soil_disturbance2' & natopen.ref.cov.val$grunn==as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),'Rv']
            lim <- natopen.ref.cov.val[natopen.ref.cov.val$Ind=='Soil_disturbance2' & natopen.ref.cov.val$grunn==as.character(results.natopen.ANO[['original']][i,"kartleggingsenhet_1m2"]),'Gv']
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
results.natopen.ANO[['2-sided']]$Moist1[results.natopen.ANO[['2-sided']]$Moist1==1]
results.natopen.ANO[['2-sided']]$Moist2[results.natopen.ANO[['2-sided']]$Moist2==1]
results.natopen.ANO[['2-sided']]$pH1[results.natopen.ANO[['2-sided']]$pH1==1]
results.natopen.ANO[['2-sided']]$pH2[results.natopen.ANO[['2-sided']]$pH2==1]
results.natopen.ANO[['2-sided']]$Nitrogen1[results.natopen.ANO[['2-sided']]$Nitrogen1==1]
results.natopen.ANO[['2-sided']]$Nitrogen2[results.natopen.ANO[['2-sided']]$Nitrogen2==1]
results.natopen.ANO[['2-sided']]$Phosphorus1[results.natopen.ANO[['2-sided']]$Phosphorus1==1]
results.natopen.ANO[['2-sided']]$Phosphorus2[results.natopen.ANO[['2-sided']]$Phosphorus2==1]
results.natopen.ANO[['2-sided']]$Grazing_mowing1[results.natopen.ANO[['2-sided']]$Grazing_mowing1==1]
results.natopen.ANO[['2-sided']]$Grazing_mowing2[results.natopen.ANO[['2-sided']]$Grazing_mowing2==1]
results.natopen.ANO[['2-sided']]$Soil_disturbance1[results.natopen.ANO[['2-sided']]$Soil_disturbance1==1]
results.natopen.ANO[['2-sided']]$Soil_disturbance2[results.natopen.ANO[['2-sided']]$Soil_disturbance2==1]



# remove values >1 for Ellenberg
results.natopen.ANO[['2-sided']]$Light1[results.natopen.ANO[['2-sided']]$Light1>1] <- NA
results.natopen.ANO[['2-sided']]$Light2[results.natopen.ANO[['2-sided']]$Light2>1] <- NA

results.natopen.ANO[['2-sided']]$Moist1[results.natopen.ANO[['2-sided']]$Moist1>1] <- NA
results.natopen.ANO[['2-sided']]$Moist2[results.natopen.ANO[['2-sided']]$Moist2>1] <- NA

results.natopen.ANO[['2-sided']]$pH1[results.natopen.ANO[['2-sided']]$pH1>1] <- NA
results.natopen.ANO[['2-sided']]$pH2[results.natopen.ANO[['2-sided']]$pH2>1] <- NA

results.natopen.ANO[['2-sided']]$Nitrogen1[results.natopen.ANO[['2-sided']]$Nitrogen1>1] <- NA
results.natopen.ANO[['2-sided']]$Nitrogen2[results.natopen.ANO[['2-sided']]$Nitrogen2>1] <- NA

results.natopen.ANO[['2-sided']]$Phosphorus1[results.natopen.ANO[['2-sided']]$Phosphorus1>1] <- NA
results.natopen.ANO[['2-sided']]$Phosphorus2[results.natopen.ANO[['2-sided']]$Phosphorus2>1] <- NA

results.natopen.ANO[['2-sided']]$Grazing_mowing1[results.natopen.ANO[['2-sided']]$Grazing_mowing1>1] <- NA
results.natopen.ANO[['2-sided']]$Grazing_mowing2[results.natopen.ANO[['2-sided']]$Grazing_mowing2>1] <- NA

results.natopen.ANO[['2-sided']]$Soil_disturbance1[results.natopen.ANO[['2-sided']]$Soil_disturbance1>1] <- NA
results.natopen.ANO[['2-sided']]$Soil_disturbance2[results.natopen.ANO[['2-sided']]$Soil_disturbance2>1] <- NA


# check distribution
x11()
par(mfrow=c(2,7))

hist(results.natopen.ANO[['2-sided']]$Light1,breaks=40)
hist(results.natopen.ANO[['2-sided']]$Light2,breaks=40)

hist(results.natopen.ANO[['2-sided']]$Moist1,breaks=40)
hist(results.natopen.ANO[['2-sided']]$Moist2,breaks=40)

hist(results.natopen.ANO[['2-sided']]$pH1,breaks=40)
hist(results.natopen.ANO[['2-sided']]$pH2,breaks=40)

hist(results.natopen.ANO[['2-sided']]$Nitrogen1,breaks=40)
hist(results.natopen.ANO[['2-sided']]$Nitrogen2,breaks=40)

hist(results.natopen.ANO[['2-sided']]$Phosphorus1,breaks=40)
hist(results.natopen.ANO[['2-sided']]$Phosphorus2,breaks=40)

hist(results.natopen.ANO[['2-sided']]$Grazing_mowing1,breaks=40)
hist(results.natopen.ANO[['2-sided']]$Grazing_mowing2,breaks=40)

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
