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
unique(substr(seminat.ref.cov.val$grunn,1,2)) # NiN types in reference
#### creating dataframe to hold the results for seminats ####
# all ANO points
nrow(ANO.geo)
# all seminat ANO points (incl. T41 and T45)
nrow(ANO.geo[ANO.geo$hovedtype_rute %in% list("T31","T32","T34","T40","T41","T45","V10"),])
# all seminat ANO points with a NiN-type represented in the reference
nrow(ANO.geo[ANO.geo$hovedtype_rute %in% unique(substr(seminat.ref.cov.val$grunn,1,3)),])
nrow(ANO.geo[ANO.geo$hovedtype_rute %in% list("T32"),])
nrow(ANO.geo[ANO.geo$hovedtype_rute %in% list("T34"),])

nrow(ANO.geo[ANO.geo$hovedtype_rute %in% list("T31"),])
nrow(ANO.geo[ANO.geo$hovedtype_rute %in% list("T40"),])
# ok, we'll be losing 258 T31 and 10 T40, as T31 and T40 are not covered by reference data
# which leaves us with 329 points, of which...
nrow(ANO.geo[ANO.geo$hovedtype_rute %in% list("T41"),])
nrow(ANO.geo[ANO.geo$hovedtype_rute %in% list("T45"),])
# 29 points are T41 (heavily altered meadows appearing as semi-natural after decades of extensive use)
# 96 points are T45 (intensive and regular soil manipulation)
# we omit T45
nrow(ANO.geo[ANO.geo$hovedtype_rute %in% list("V10"),])
# 6 points are semi-natural wetlands

nrow(ANO.geo[ANO.geo$hovedtype_rute %in% list("T32","T34","T41","V10"),])
# leaving us with a total of 233 ANO-points
ANO.seminat <- ANO.geo[ANO.geo$hovedtype_rute %in% list("T32","T34","T41","V10"),]

head(ANO.seminat)
# update row-numbers
row.names(ANO.seminat) <- 1:nrow(ANO.seminat)
head(ANO.seminat)
dim(ANO.seminat)
colnames(ANO.seminat)

length(levels(as.factor(ANO.seminat$ano_flate_id)))
length(levels(as.factor(ANO.seminat$ano_punkt_id)))
summary(as.factor(ANO.seminat$ano_punkt_id))
# no points that are double

unique(ANO.seminat$hovedoekosystem_punkt)
unique(ANO.seminat$hovedtype_rute)
unique(ANO.seminat$kartleggingsenhet_1m2)
ANO.seminat$hovedtype_rute <- as.factor(ANO.seminat$hovedtype_rute)
ANO.seminat$kartleggingsenhet_1m2 <- as.factor(ANO.seminat$kartleggingsenhet_1m2)
summary(ANO.seminat$hovedtype_rute)
summary(ANO.seminat$kartleggingsenhet_1m2)
# we have the T41 reference only for the hovedtype -> make T41-C-1 into T41
ANO.seminat[ANO.seminat$kartleggingsenhet_1m2=="T41-C-1","kartleggingsenhet_1m2"] <- "T41"
summary(ANO.seminat$kartleggingsenhet_1m2)

ANO.seminat[ANO.seminat$kartleggingsenhet_1m2=="T32",]
ANO.seminat[ANO.seminat$kartleggingsenhet_1m2=="T34",]
# for T32 og T34 without grunntype-registration there's no useful reference, these won't be processed further

results.seminat <- list()
ind <- unique(seminat.ref.cov.val$Ind)
# choose columns for site description
colnames(ANO.seminat)
results.seminat[['original']] <- ANO.seminat
# drop geometry
st_geometry(results.seminat[['original']]) <- NULL
results.seminat[['original']]

# add columns for indicators
nvar.site <- ncol(results.seminat[['original']])
for (i in 1:length(ind) ) {results.seminat[['original']][,i+nvar.site] <- NA}
colnames(results.seminat[['original']])[(nvar.site+1):(length(ind)+nvar.site)] <- paste(ind)
for (i in (nvar.site+1):(length(ind)+nvar.site) ) {results.seminat[['original']][,i] <- as.numeric(results.seminat[['original']][,i])}
summary(results.seminat[['original']])
#results.seminat[['original']]$Region <- as.factor(results.seminat[['original']]$Region)
results.seminat[['original']]$GlobalID <- as.factor(results.seminat[['original']]$GlobalID)
results.seminat[['original']]$ano_flate_id <- as.factor(results.seminat[['original']]$ano_flate_id)
results.seminat[['original']]$ano_punkt_id <- as.factor(results.seminat[['original']]$ano_punkt_id)
results.seminat[['original']]$hovedoekosystem_punkt <- as.factor(results.seminat[['original']]$hovedoekosystem_punkt)
#results.seminat[['original']]$Hovedoekosystem_rute  <- as.factor(results.seminat[['original']]$Hovedoekosystem_rute )
results.seminat[['original']]$kartleggingsenhet_1m2 <- as.factor(results.seminat[['original']]$kartleggingsenhet_1m2)
results.seminat[['original']]$hovedtype_rute    <- as.factor(results.seminat[['original']]$hovedtype_rute)


# roll out
results.seminat[['scaled']] <- results.seminat[['non-truncated']] <- results.seminat[['original']]


#### calculating scaled and non-truncated values for the indicators based on the dataset ####
for (i in 1:nrow(ANO.seminat) ) {  #
  tryCatch({
    print(i)
    print(paste(ANO.seminat$ano_flate_id[i]))
    print(paste(ANO.seminat$ano_punkt_id[i]))
#    ANO.seminat$Hovedoekosystem_sirkel[i]
#    ANO.seminat$Hovedoekosystem_rute[i]



    # if the ANO.hovedtype exists in the reference
    if (ANO.seminat$hovedtype_rute[i] %in% unique(substr(seminat.ref.cov.val$grunn,1,3)) ) {
      
      # if there is any species present in current ANO point  
      if ( length(ANO.sp.ind[ANO.sp.ind$ParentGlobalID==as.character(ANO.seminat$GlobalID[i]),'Species']) > 0 ) {
        

          
          # Light
          dat <- ANO.sp.ind[ANO.sp.ind$ParentGlobalID==as.character(ANO.seminat$GlobalID[i]),c('art_dekning','Light')]
          results.seminat[['original']][i,'richness'] <- nrow(dat)
          dat <- dat[!is.na(dat$Light),]
          
          if ( nrow(dat)>0 ) {
            
            val <- sum(dat[,'art_dekning'] * dat[,'Light'],na.rm=T) / sum(dat[,'art_dekning'],na.rm=T)
            # lower part of distribution
            ref <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='Light1' & seminat.ref.cov.val$grunn==as.character(results.seminat[['original']][i,"kartleggingsenhet_1m2"]),'Rv']
            lim <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='Light1' & seminat.ref.cov.val$grunn==as.character(results.seminat[['original']][i,"kartleggingsenhet_1m2"]),'Gv']
            maxmin <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='Light1' & seminat.ref.cov.val$grunn==as.character(results.seminat[['original']][i,"kartleggingsenhet_1m2"]),'maxmin']
            # coercing x into results.seminat dataframe
            results.seminat[['scaled']][i,'Light1'] <- scal() 
            results.seminat[['non-truncated']][i,'Light1'] <- scal.2() 
            results.seminat[['original']][i,'Light1'] <- val 
            
            # upper part of distribution
            ref <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='Light2' & seminat.ref.cov.val$grunn==as.character(results.seminat[['original']][i,"kartleggingsenhet_1m2"]),'Rv']
            lim <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='Light2' & seminat.ref.cov.val$grunn==as.character(results.seminat[['original']][i,"kartleggingsenhet_1m2"]),'Gv']
            maxmin <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='Light2' & seminat.ref.cov.val$grunn==as.character(results.seminat[['original']][i,"kartleggingsenhet_1m2"]),'maxmin']
            # coercing x into results.seminat dataframe
            results.seminat[['scaled']][i,'Light2'] <- scal() 
            results.seminat[['non-truncated']][i,'Light2'] <- scal.2() 
            results.seminat[['original']][i,'Light2'] <- val
          }
          
          
          # Moisture
          dat <- ANO.sp.ind[ANO.sp.ind$ParentGlobalID==as.character(ANO.seminat$GlobalID[i]),c('art_dekning','Moisture')]
          results.seminat[['original']][i,'richness'] <- nrow(dat)
          dat <- dat[!is.na(dat$Moisture),]
          
          if ( nrow(dat)>0 ) {
            
            val <- sum(dat[,'art_dekning'] * dat[,'Moisture'],na.rm=T) / sum(dat[,'art_dekning'],na.rm=T)
            # lower part of distribution
            ref <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='Moist1' & seminat.ref.cov.val$grunn==as.character(results.seminat[['original']][i,"kartleggingsenhet_1m2"]),'Rv']
            lim <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='Moist1' & seminat.ref.cov.val$grunn==as.character(results.seminat[['original']][i,"kartleggingsenhet_1m2"]),'Gv']
            maxmin <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='Moist1' & seminat.ref.cov.val$grunn==as.character(results.seminat[['original']][i,"kartleggingsenhet_1m2"]),'maxmin']
            # coercing x into results.seminat dataframe
            results.seminat[['scaled']][i,'Moist1'] <- scal() 
            results.seminat[['non-truncated']][i,'Moist1'] <- scal.2() 
            results.seminat[['original']][i,'Moist1'] <- val 
            
            # upper part of distribution
            ref <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='Moist2' & seminat.ref.cov.val$grunn==as.character(results.seminat[['original']][i,"kartleggingsenhet_1m2"]),'Rv']
            lim <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='Moist2' & seminat.ref.cov.val$grunn==as.character(results.seminat[['original']][i,"kartleggingsenhet_1m2"]),'Gv']
            maxmin <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='Moist2' & seminat.ref.cov.val$grunn==as.character(results.seminat[['original']][i,"kartleggingsenhet_1m2"]),'maxmin']
            # coercing x into results.seminat dataframe
            results.seminat[['scaled']][i,'Moist2'] <- scal() 
            results.seminat[['non-truncated']][i,'Moist2'] <- scal.2() 
            results.seminat[['original']][i,'Moist2'] <- val
          }
          
          
          # Soil_reaction_pH
          dat <- ANO.sp.ind[ANO.sp.ind$ParentGlobalID==as.character(ANO.seminat$GlobalID[i]),c('art_dekning','Soil_reaction_pH')]
          results.seminat[['original']][i,'richness'] <- nrow(dat)
          dat <- dat[!is.na(dat$Soil_reaction_pH),]
          
          if ( nrow(dat)>0 ) {
            
            val <- sum(dat[,'art_dekning'] * dat[,'Soil_reaction_pH'],na.rm=T) / sum(dat[,'art_dekning'],na.rm=T)
            # lower part of distribution
            ref <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='pH1' & seminat.ref.cov.val$grunn==as.character(results.seminat[['original']][i,"kartleggingsenhet_1m2"]),'Rv']
            lim <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='pH1' & seminat.ref.cov.val$grunn==as.character(results.seminat[['original']][i,"kartleggingsenhet_1m2"]),'Gv']
            maxmin <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='pH1' & seminat.ref.cov.val$grunn==as.character(results.seminat[['original']][i,"kartleggingsenhet_1m2"]),'maxmin']
            # coercing x into results.seminat dataframe
            results.seminat[['scaled']][i,'pH1'] <- scal() 
            results.seminat[['non-truncated']][i,'pH1'] <- scal.2() 
            results.seminat[['original']][i,'pH1'] <- val 
            
            # upper part of distribution
            ref <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='pH2' & seminat.ref.cov.val$grunn==as.character(results.seminat[['original']][i,"kartleggingsenhet_1m2"]),'Rv']
            lim <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='pH2' & seminat.ref.cov.val$grunn==as.character(results.seminat[['original']][i,"kartleggingsenhet_1m2"]),'Gv']
            maxmin <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='pH2' & seminat.ref.cov.val$grunn==as.character(results.seminat[['original']][i,"kartleggingsenhet_1m2"]),'maxmin']
            # coercing x into results.seminat dataframe
            results.seminat[['scaled']][i,'pH2'] <- scal() 
            results.seminat[['non-truncated']][i,'pH2'] <- scal.2() 
            results.seminat[['original']][i,'pH2'] <- val
          }
          
          
          # Nitrogen
          dat <- ANO.sp.ind[ANO.sp.ind$ParentGlobalID==as.character(ANO.seminat$GlobalID[i]),c('art_dekning','Nitrogen')]
          results.seminat[['original']][i,'richness'] <- nrow(dat)
          dat <- dat[!is.na(dat$Nitrogen),]
          
          if ( nrow(dat)>0 ) {
            
            val <- sum(dat[,'art_dekning'] * dat[,'Nitrogen'],na.rm=T) / sum(dat[,'art_dekning'],na.rm=T)
            # lower part of distribution
            ref <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='Nitrogen1' & seminat.ref.cov.val$grunn==as.character(results.seminat[['original']][i,"kartleggingsenhet_1m2"]),'Rv']
            lim <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='Nitrogen1' & seminat.ref.cov.val$grunn==as.character(results.seminat[['original']][i,"kartleggingsenhet_1m2"]),'Gv']
            maxmin <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='Nitrogen1' & seminat.ref.cov.val$grunn==as.character(results.seminat[['original']][i,"kartleggingsenhet_1m2"]),'maxmin']
            # coercing x into results.seminat dataframe
            results.seminat[['scaled']][i,'Nitrogen1'] <- scal() 
            results.seminat[['non-truncated']][i,'Nitrogen1'] <- scal.2() 
            results.seminat[['original']][i,'Nitrogen1'] <- val 
            
            # upper part of distribution
            ref <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='Nitrogen2' & seminat.ref.cov.val$grunn==as.character(results.seminat[['original']][i,"kartleggingsenhet_1m2"]),'Rv']
            lim <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='Nitrogen2' & seminat.ref.cov.val$grunn==as.character(results.seminat[['original']][i,"kartleggingsenhet_1m2"]),'Gv']
            maxmin <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='Nitrogen2' & seminat.ref.cov.val$grunn==as.character(results.seminat[['original']][i,"kartleggingsenhet_1m2"]),'maxmin']
            # coercing x into results.seminat dataframe
            results.seminat[['scaled']][i,'Nitrogen2'] <- scal() 
            results.seminat[['non-truncated']][i,'Nitrogen2'] <- scal.2() 
            results.seminat[['original']][i,'Nitrogen2'] <- val
          }
          
          
          # Phosphorus
          dat <- ANO.sp.ind[ANO.sp.ind$ParentGlobalID==as.character(ANO.seminat$GlobalID[i]),c('art_dekning','Phosphorus')]
          results.seminat[['original']][i,'richness'] <- nrow(dat)
          dat <- dat[!is.na(dat$Phosphorus),]
          
          if ( nrow(dat)>0 ) {
            
            val <- sum(dat[,'art_dekning'] * dat[,'Phosphorus'],na.rm=T) / sum(dat[,'art_dekning'],na.rm=T)
            # lower part of distribution
            ref <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='Phosphorus1' & seminat.ref.cov.val$grunn==as.character(results.seminat[['original']][i,"kartleggingsenhet_1m2"]),'Rv']
            lim <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='Phosphorus1' & seminat.ref.cov.val$grunn==as.character(results.seminat[['original']][i,"kartleggingsenhet_1m2"]),'Gv']
            maxmin <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='Phosphorus1' & seminat.ref.cov.val$grunn==as.character(results.seminat[['original']][i,"kartleggingsenhet_1m2"]),'maxmin']
            # coercing x into results.seminat dataframe
            results.seminat[['scaled']][i,'Phosphorus1'] <- scal() 
            results.seminat[['non-truncated']][i,'Phosphorus1'] <- scal.2() 
            results.seminat[['original']][i,'Phosphorus1'] <- val 
            
            # upper part of distribution
            ref <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='Phosphorus2' & seminat.ref.cov.val$grunn==as.character(results.seminat[['original']][i,"kartleggingsenhet_1m2"]),'Rv']
            lim <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='Phosphorus2' & seminat.ref.cov.val$grunn==as.character(results.seminat[['original']][i,"kartleggingsenhet_1m2"]),'Gv']
            maxmin <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='Phosphorus2' & seminat.ref.cov.val$grunn==as.character(results.seminat[['original']][i,"kartleggingsenhet_1m2"]),'maxmin']
            # coercing x into results.seminat dataframe
            results.seminat[['scaled']][i,'Phosphorus2'] <- scal() 
            results.seminat[['non-truncated']][i,'Phosphorus2'] <- scal.2() 
            results.seminat[['original']][i,'Phosphorus2'] <- val
          }
          
          
          # Grazing_mowing
          dat <- ANO.sp.ind[ANO.sp.ind$ParentGlobalID==as.character(ANO.seminat$GlobalID[i]),c('art_dekning','Grazing_mowing')]
          results.seminat[['original']][i,'richness'] <- nrow(dat)
          dat <- dat[!is.na(dat$Grazing_mowing),]
          
          if ( nrow(dat)>0 ) {
            
            val <- sum(dat[,'art_dekning'] * dat[,'Grazing_mowing'],na.rm=T) / sum(dat[,'art_dekning'],na.rm=T)
            # lower part of distribution
            ref <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='Grazing_mowing1' & seminat.ref.cov.val$grunn==as.character(results.seminat[['original']][i,"kartleggingsenhet_1m2"]),'Rv']
            lim <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='Grazing_mowing1' & seminat.ref.cov.val$grunn==as.character(results.seminat[['original']][i,"kartleggingsenhet_1m2"]),'Gv']
            maxmin <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='Grazing_mowing1' & seminat.ref.cov.val$grunn==as.character(results.seminat[['original']][i,"kartleggingsenhet_1m2"]),'maxmin']
            # coercing x into results.seminat dataframe
            results.seminat[['scaled']][i,'Grazing_mowing1'] <- scal() 
            results.seminat[['non-truncated']][i,'Grazing_mowing1'] <- scal.2() 
            results.seminat[['original']][i,'Grazing_mowing1'] <- val 
            
            # upper part of distribution
            ref <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='Grazing_mowing2' & seminat.ref.cov.val$grunn==as.character(results.seminat[['original']][i,"kartleggingsenhet_1m2"]),'Rv']
            lim <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='Grazing_mowing2' & seminat.ref.cov.val$grunn==as.character(results.seminat[['original']][i,"kartleggingsenhet_1m2"]),'Gv']
            maxmin <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='Grazing_mowing2' & seminat.ref.cov.val$grunn==as.character(results.seminat[['original']][i,"kartleggingsenhet_1m2"]),'maxmin']
            # coercing x into results.seminat dataframe
            results.seminat[['scaled']][i,'Grazing_mowing2'] <- scal() 
            results.seminat[['non-truncated']][i,'Grazing_mowing2'] <- scal.2() 
            results.seminat[['original']][i,'Grazing_mowing2'] <- val
          }
          
          
          # Soil_disturbance
          dat <- ANO.sp.ind[ANO.sp.ind$ParentGlobalID==as.character(ANO.seminat$GlobalID[i]),c('art_dekning','Soil_disturbance')]
          results.seminat[['original']][i,'richness'] <- nrow(dat)
          dat <- dat[!is.na(dat$Soil_disturbance),]
          
          if ( nrow(dat)>0 ) {
            
            val <- sum(dat[,'art_dekning'] * dat[,'Soil_disturbance'],na.rm=T) / sum(dat[,'art_dekning'],na.rm=T)
            # lower part of distribution
            ref <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='Soil_disturbance1' & seminat.ref.cov.val$grunn==as.character(results.seminat[['original']][i,"kartleggingsenhet_1m2"]),'Rv']
            lim <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='Soil_disturbance1' & seminat.ref.cov.val$grunn==as.character(results.seminat[['original']][i,"kartleggingsenhet_1m2"]),'Gv']
            maxmin <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='Soil_disturbance1' & seminat.ref.cov.val$grunn==as.character(results.seminat[['original']][i,"kartleggingsenhet_1m2"]),'maxmin']
            # coercing x into results.seminat dataframe
            results.seminat[['scaled']][i,'Soil_disturbance1'] <- scal() 
            results.seminat[['non-truncated']][i,'Soil_disturbance1'] <- scal.2() 
            results.seminat[['original']][i,'Soil_disturbance1'] <- val 
            
            # upper part of distribution
            ref <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='Soil_disturbance2' & seminat.ref.cov.val$grunn==as.character(results.seminat[['original']][i,"kartleggingsenhet_1m2"]),'Rv']
            lim <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='Soil_disturbance2' & seminat.ref.cov.val$grunn==as.character(results.seminat[['original']][i,"kartleggingsenhet_1m2"]),'Gv']
            maxmin <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='Soil_disturbance2' & seminat.ref.cov.val$grunn==as.character(results.seminat[['original']][i,"kartleggingsenhet_1m2"]),'maxmin']
            # coercing x into results.seminat dataframe
            results.seminat[['scaled']][i,'Soil_disturbance2'] <- scal() 
            results.seminat[['non-truncated']][i,'Soil_disturbance2'] <- scal.2() 
            results.seminat[['original']][i,'Soil_disturbance2'] <- val
          }
          
          
          
        }
      }
      

    
  }, error=function(e){cat("ERROR :",conditionMessage(e), "\n")})
}

summary(results.seminat[['original']])
summary(results.seminat[['scaled']])

# for using both sides of the Ellenberg indicator
results.seminat[['2-sided']] <- results.seminat[['non-truncated']]

# check if there are values equalling exactly 1
results.seminat[['2-sided']]$Light1[results.seminat[['2-sided']]$Light1==1]
results.seminat[['2-sided']]$Light2[results.seminat[['2-sided']]$Light2==1]
results.seminat[['2-sided']]$Moist1[results.seminat[['2-sided']]$Moist1==1]
results.seminat[['2-sided']]$Moist2[results.seminat[['2-sided']]$Moist2==1]
results.seminat[['2-sided']]$pH1[results.seminat[['2-sided']]$pH1==1]
results.seminat[['2-sided']]$pH2[results.seminat[['2-sided']]$pH2==1]
results.seminat[['2-sided']]$Nitrogen1[results.seminat[['2-sided']]$Nitrogen1==1]
results.seminat[['2-sided']]$Nitrogen2[results.seminat[['2-sided']]$Nitrogen2==1]
results.seminat[['2-sided']]$Phosphorus1[results.seminat[['2-sided']]$Phosphorus1==1]
results.seminat[['2-sided']]$Phosphorus2[results.seminat[['2-sided']]$Phosphorus2==1]
results.seminat[['2-sided']]$Grazing_mowing1[results.seminat[['2-sided']]$Grazing_mowing1==1]
results.seminat[['2-sided']]$Grazing_mowing2[results.seminat[['2-sided']]$Grazing_mowing2==1]
results.seminat[['2-sided']]$Soil_disturbance1[results.seminat[['2-sided']]$Soil_disturbance1==1]
results.seminat[['2-sided']]$Soil_disturbance2[results.seminat[['2-sided']]$Soil_disturbance2==1]



# remove values >1 for Ellenberg
results.seminat[['2-sided']]$Light1[results.seminat[['2-sided']]$Light1>1] <- NA
results.seminat[['2-sided']]$Light2[results.seminat[['2-sided']]$Light2>1] <- NA

results.seminat[['2-sided']]$Moist1[results.seminat[['2-sided']]$Moist1>1] <- NA
results.seminat[['2-sided']]$Moist2[results.seminat[['2-sided']]$Moist2>1] <- NA

results.seminat[['2-sided']]$pH1[results.seminat[['2-sided']]$pH1>1] <- NA
results.seminat[['2-sided']]$pH2[results.seminat[['2-sided']]$pH2>1] <- NA

results.seminat[['2-sided']]$Nitrogen1[results.seminat[['2-sided']]$Nitrogen1>1] <- NA
results.seminat[['2-sided']]$Nitrogen2[results.seminat[['2-sided']]$Nitrogen2>1] <- NA

results.seminat[['2-sided']]$Phosphorus1[results.seminat[['2-sided']]$Phosphorus1>1] <- NA
results.seminat[['2-sided']]$Phosphorus2[results.seminat[['2-sided']]$Phosphorus2>1] <- NA

results.seminat[['2-sided']]$Grazing_mowing1[results.seminat[['2-sided']]$Grazing_mowing1>1] <- NA
results.seminat[['2-sided']]$Grazing_mowing2[results.seminat[['2-sided']]$Grazing_mowing2>1] <- NA

results.seminat[['2-sided']]$Soil_disturbance1[results.seminat[['2-sided']]$Soil_disturbance1>1] <- NA
results.seminat[['2-sided']]$Soil_disturbance2[results.seminat[['2-sided']]$Soil_disturbance2>1] <- NA


# check distribution
x11()
par(mfrow=c(2,7))

hist(results.seminat[['2-sided']]$Light1,breaks=40)
hist(results.seminat[['2-sided']]$Light2,breaks=40)

hist(results.seminat[['2-sided']]$Moist1,breaks=40)
hist(results.seminat[['2-sided']]$Moist2,breaks=40)

hist(results.seminat[['2-sided']]$pH1,breaks=40)
hist(results.seminat[['2-sided']]$pH2,breaks=40)

hist(results.seminat[['2-sided']]$Nitrogen1,breaks=40)
hist(results.seminat[['2-sided']]$Nitrogen2,breaks=40)

hist(results.seminat[['2-sided']]$Phosphorus1,breaks=40)
hist(results.seminat[['2-sided']]$Phosphorus2,breaks=40)

hist(results.seminat[['2-sided']]$Grazing_mowing1,breaks=40)
hist(results.seminat[['2-sided']]$Grazing_mowing2,breaks=40)

hist(results.seminat[['2-sided']]$Soil_disturbance1,breaks=40)
hist(results.seminat[['2-sided']]$Soil_disturbance2,breaks=40)






#write.table(results.seminat[['scaled']], file='output/scaled data/results.seminat_scaled.txt',
#            quote=FALSE,sep="\t",col.names=TRUE,row.names=FALSE,dec=".")
#write.table(results.seminat[['non-truncated']], file='output/scaled data/results.seminat_non-truncated.txt',
#            quote=FALSE,sep="\t",col.names=TRUE,row.names=FALSE,dec=".")
write.table(results.seminat[['original']], file='P:/41201785_okologisk_tilstand_2022_2023/data/FPI_output large files for markdown/results.seminat_original.txt',
            quote=FALSE,sep="\t",col.names=TRUE,row.names=FALSE,dec=".")
write.table(results.seminat[['2-sided']], file='P:/41201785_okologisk_tilstand_2022_2023/data/FPI_output large files for markdown/results.seminat_2-sided.txt',
            quote=FALSE,sep="\t",col.names=TRUE,row.names=FALSE,dec=".")


rm(list= ls()[!(ls() %in% c('results.seminat','settings'))])
save.image("P:/41201785_okologisk_tilstand_2022_2023/data/FPI_output large files for markdown/results.seminat.RData")
