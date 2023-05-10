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

colnames(ASO.geo)
levels(as.factor(ASO.geo$NiN_grunntype)) # NiN types in data
levels(seminat.ref.cov.val$grunn) # NiN types in reference
#### creating dataframe to hold the results for seminats ####
# all ASO meadows
nrow(ASO.geo)
# all ASO meadows that are T32-C-13 (the one type we don't have a reference for)
nrow(ASO.geo[ASO.geo$NiN_grunntype %in% list("T32-C-13"),])
# only losing 1 meadow

length(levels(as.factor(ASO.geo$Omradenummer_flatenummer)))
length(levels(as.factor(ASO.geo$ASO_ID)))
length(levels(as.factor(ASO.geo$Eng_ID)))
summary(as.factor(ASO.geo$ASO_ID))
# two meadows that are double: 020_142_3 & 029_336_2
# 020_142_3
as.data.frame(ASO.geo[ASO.geo$ASO_ID=="020_142_3",]) # GlobalID 91b54a01-77ce-498f-bdbf-f1727b32ec0d is empty -> drop it
ASO.geo <- ASO.geo[ASO.geo$GlobalID!="91b54a01-77ce-498f-bdbf-f1727b32ec0d",]
# 029_336_2
as.data.frame(ASO.geo[ASO.geo$ASO_ID=="029_336_2",]) # both are identical -> drop one
ASO.geo <- ASO.geo[ASO.geo$GlobalID!="ca0b9892-cbe0-4aee-b3d3-c46973293ce4",]
summary(as.factor(ASO.geo$ASO_ID))

unique(ASO.geo$NiN_grunntype)
ASO.geo$NiN_grunntype <- as.factor(ASO.geo$NiN_grunntype)
summary(ASO.geo$NiN_grunntype)
# 230 out of 381 ASO-meadows are not T32
# for anything that is not T32 no data were registered, these won't be processed further
# which leaves us with 151 ASO-meadows we can expect a result for


results.seminat.ASO <- list()
ind <- unique(seminat.ref.cov.val$Ind)
# choose columns for site description
colnames(ASO.geo)
results.seminat.ASO[['original']] <- ASO.geo
# drop geometry
st_geometry(results.seminat.ASO[['original']]) <- NULL
results.seminat.ASO[['original']] <- as.data.frame(results.seminat.ASO[['original']])

# add columns for indicators
nvar.site <- ncol(results.seminat.ASO[['original']])
for (i in 1:length(ind) ) {results.seminat.ASO[['original']][,i+nvar.site] <- NA}
colnames(results.seminat.ASO[['original']])[(nvar.site+1):(length(ind)+nvar.site)] <- paste(ind)
for (i in (nvar.site+1):(length(ind)+nvar.site) ) {results.seminat.ASO[['original']][,i] <- as.numeric(results.seminat.ASO[['original']][,i])}
summary(results.seminat.ASO[['original']])
#results.seminat.ASO[['original']]$Region <- as.factor(results.seminat.ASO[['original']]$Region)
results.seminat.ASO[['original']]$GlobalID <- as.factor(results.seminat.ASO[['original']]$GlobalID)
results.seminat.ASO[['original']]$Omradenummer_flatenummer <- as.factor(results.seminat.ASO[['original']]$Omradenummer_flatenummer)
results.seminat.ASO[['original']]$ASO_ID <- as.factor(results.seminat.ASO[['original']]$ASO_ID)
#results.seminat.ASO[['original']]$hovedoekosystem_punkt <- as.factor(results.seminat.ASO[['original']]$hovedoekosystem_punkt)
#results.seminat.ASO[['original']]$Hovedoekosystem_rute  <- as.factor(results.seminat.ASO[['original']]$Hovedoekosystem_rute )
results.seminat.ASO[['original']]$NiN_grunntype <- as.factor(results.seminat.ASO[['original']]$NiN_grunntype)
#results.seminat.ASO[['original']]$hovedtype_rute    <- as.factor(results.seminat.ASO[['original']]$hovedtype_rute)


# roll out
results.seminat.ASO[['scaled']] <- results.seminat.ASO[['non-truncated']] <- results.seminat.ASO[['original']]


#### calculating scaled and non-truncated values for the indicators based on the dataset ####
for (i in 1:nrow(ASO.geo) ) {  #
  tryCatch({
    print(i)
    print(paste(ASO.geo$ASO_ID[i]))


    # if the ASO.grunntype exists in the reference
    if (ASO.geo$NiN_grunntype[i] %in% unique(seminat.ref.cov.val$grunn) ) {
      
      # if there is any species present in current ASO point  
      if ( length(ASO.sp.ind[ASO.sp.ind$ParentGlobalID==as.character(ASO.geo$GlobalID[i]),'Species']) > 0 ) {
        

          
          # Light
          dat <- ASO.sp.ind[ASO.sp.ind$ParentGlobalID==as.character(ASO.geo$GlobalID[i]),c('art_dekning','Light')]
          results.seminat.ASO[['original']][i,'richness'] <- nrow(dat)
          dat <- dat[!is.na(dat$Light),]
          
          if ( nrow(dat)>0 ) {
            
            val <- sum(dat[,'art_dekning'] * dat[,'Light'],na.rm=T) / sum(dat[,'art_dekning'],na.rm=T)
            # lower part of distribution
            ref <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='Light1' & seminat.ref.cov.val$grunn==as.character(results.seminat.ASO[['original']][i,"NiN_grunntype"]),'Rv']
            lim <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='Light1' & seminat.ref.cov.val$grunn==as.character(results.seminat.ASO[['original']][i,"NiN_grunntype"]),'Gv']
            maxmin <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='Light1' & seminat.ref.cov.val$grunn==as.character(results.seminat.ASO[['original']][i,"NiN_grunntype"]),'maxmin']
            # coercing x into results.seminat.ASO dataframe
            results.seminat.ASO[['scaled']][i,'Light1'] <- scal() 
            results.seminat.ASO[['non-truncated']][i,'Light1'] <- scal.2() 
            results.seminat.ASO[['original']][i,'Light1'] <- val 
            
            # upper part of distribution
            ref <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='Light2' & seminat.ref.cov.val$grunn==as.character(results.seminat.ASO[['original']][i,"NiN_grunntype"]),'Rv']
            lim <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='Light2' & seminat.ref.cov.val$grunn==as.character(results.seminat.ASO[['original']][i,"NiN_grunntype"]),'Gv']
            maxmin <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='Light2' & seminat.ref.cov.val$grunn==as.character(results.seminat.ASO[['original']][i,"NiN_grunntype"]),'maxmin']
            # coercing x into results.seminat.ASO dataframe
            results.seminat.ASO[['scaled']][i,'Light2'] <- scal() 
            results.seminat.ASO[['non-truncated']][i,'Light2'] <- scal.2() 
            results.seminat.ASO[['original']][i,'Light2'] <- val
          }
          
          
          # Moisture
          dat <- ASO.sp.ind[ASO.sp.ind$ParentGlobalID==as.character(ASO.geo$GlobalID[i]),c('art_dekning','Moisture')]
          results.seminat.ASO[['original']][i,'richness'] <- nrow(dat)
          dat <- dat[!is.na(dat$Moisture),]
          
          if ( nrow(dat)>0 ) {
            
            val <- sum(dat[,'art_dekning'] * dat[,'Moisture'],na.rm=T) / sum(dat[,'art_dekning'],na.rm=T)
            # lower part of distribution
            ref <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='Moist1' & seminat.ref.cov.val$grunn==as.character(results.seminat.ASO[['original']][i,"NiN_grunntype"]),'Rv']
            lim <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='Moist1' & seminat.ref.cov.val$grunn==as.character(results.seminat.ASO[['original']][i,"NiN_grunntype"]),'Gv']
            maxmin <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='Moist1' & seminat.ref.cov.val$grunn==as.character(results.seminat.ASO[['original']][i,"NiN_grunntype"]),'maxmin']
            # coercing x into results.seminat.ASO dataframe
            results.seminat.ASO[['scaled']][i,'Moist1'] <- scal() 
            results.seminat.ASO[['non-truncated']][i,'Moist1'] <- scal.2() 
            results.seminat.ASO[['original']][i,'Moist1'] <- val 
            
            # upper part of distribution
            ref <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='Moist2' & seminat.ref.cov.val$grunn==as.character(results.seminat.ASO[['original']][i,"NiN_grunntype"]),'Rv']
            lim <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='Moist2' & seminat.ref.cov.val$grunn==as.character(results.seminat.ASO[['original']][i,"NiN_grunntype"]),'Gv']
            maxmin <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='Moist2' & seminat.ref.cov.val$grunn==as.character(results.seminat.ASO[['original']][i,"NiN_grunntype"]),'maxmin']
            # coercing x into results.seminat.ASO dataframe
            results.seminat.ASO[['scaled']][i,'Moist2'] <- scal() 
            results.seminat.ASO[['non-truncated']][i,'Moist2'] <- scal.2() 
            results.seminat.ASO[['original']][i,'Moist2'] <- val
          }
          
          
          # Soil_reaction_pH
          dat <- ASO.sp.ind[ASO.sp.ind$ParentGlobalID==as.character(ASO.geo$GlobalID[i]),c('art_dekning','Soil_reaction_pH')]
          results.seminat.ASO[['original']][i,'richness'] <- nrow(dat)
          dat <- dat[!is.na(dat$Soil_reaction_pH),]
          
          if ( nrow(dat)>0 ) {
            
            val <- sum(dat[,'art_dekning'] * dat[,'Soil_reaction_pH'],na.rm=T) / sum(dat[,'art_dekning'],na.rm=T)
            # lower part of distribution
            ref <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='pH1' & seminat.ref.cov.val$grunn==as.character(results.seminat.ASO[['original']][i,"NiN_grunntype"]),'Rv']
            lim <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='pH1' & seminat.ref.cov.val$grunn==as.character(results.seminat.ASO[['original']][i,"NiN_grunntype"]),'Gv']
            maxmin <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='pH1' & seminat.ref.cov.val$grunn==as.character(results.seminat.ASO[['original']][i,"NiN_grunntype"]),'maxmin']
            # coercing x into results.seminat.ASO dataframe
            results.seminat.ASO[['scaled']][i,'pH1'] <- scal() 
            results.seminat.ASO[['non-truncated']][i,'pH1'] <- scal.2() 
            results.seminat.ASO[['original']][i,'pH1'] <- val 
            
            # upper part of distribution
            ref <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='pH2' & seminat.ref.cov.val$grunn==as.character(results.seminat.ASO[['original']][i,"NiN_grunntype"]),'Rv']
            lim <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='pH2' & seminat.ref.cov.val$grunn==as.character(results.seminat.ASO[['original']][i,"NiN_grunntype"]),'Gv']
            maxmin <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='pH2' & seminat.ref.cov.val$grunn==as.character(results.seminat.ASO[['original']][i,"NiN_grunntype"]),'maxmin']
            # coercing x into results.seminat.ASO dataframe
            results.seminat.ASO[['scaled']][i,'pH2'] <- scal() 
            results.seminat.ASO[['non-truncated']][i,'pH2'] <- scal.2() 
            results.seminat.ASO[['original']][i,'pH2'] <- val
          }
          
          
          # Nitrogen
          dat <- ASO.sp.ind[ASO.sp.ind$ParentGlobalID==as.character(ASO.geo$GlobalID[i]),c('art_dekning','Nitrogen')]
          results.seminat.ASO[['original']][i,'richness'] <- nrow(dat)
          dat <- dat[!is.na(dat$Nitrogen),]
          
          if ( nrow(dat)>0 ) {
            
            val <- sum(dat[,'art_dekning'] * dat[,'Nitrogen'],na.rm=T) / sum(dat[,'art_dekning'],na.rm=T)
            # lower part of distribution
            ref <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='Nitrogen1' & seminat.ref.cov.val$grunn==as.character(results.seminat.ASO[['original']][i,"NiN_grunntype"]),'Rv']
            lim <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='Nitrogen1' & seminat.ref.cov.val$grunn==as.character(results.seminat.ASO[['original']][i,"NiN_grunntype"]),'Gv']
            maxmin <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='Nitrogen1' & seminat.ref.cov.val$grunn==as.character(results.seminat.ASO[['original']][i,"NiN_grunntype"]),'maxmin']
            # coercing x into results.seminat.ASO dataframe
            results.seminat.ASO[['scaled']][i,'Nitrogen1'] <- scal() 
            results.seminat.ASO[['non-truncated']][i,'Nitrogen1'] <- scal.2() 
            results.seminat.ASO[['original']][i,'Nitrogen1'] <- val 
            
            # upper part of distribution
            ref <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='Nitrogen2' & seminat.ref.cov.val$grunn==as.character(results.seminat.ASO[['original']][i,"NiN_grunntype"]),'Rv']
            lim <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='Nitrogen2' & seminat.ref.cov.val$grunn==as.character(results.seminat.ASO[['original']][i,"NiN_grunntype"]),'Gv']
            maxmin <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='Nitrogen2' & seminat.ref.cov.val$grunn==as.character(results.seminat.ASO[['original']][i,"NiN_grunntype"]),'maxmin']
            # coercing x into results.seminat.ASO dataframe
            results.seminat.ASO[['scaled']][i,'Nitrogen2'] <- scal() 
            results.seminat.ASO[['non-truncated']][i,'Nitrogen2'] <- scal.2() 
            results.seminat.ASO[['original']][i,'Nitrogen2'] <- val
          }
          
          
          # Phosphorus
          dat <- ASO.sp.ind[ASO.sp.ind$ParentGlobalID==as.character(ASO.geo$GlobalID[i]),c('art_dekning','Phosphorus')]
          results.seminat.ASO[['original']][i,'richness'] <- nrow(dat)
          dat <- dat[!is.na(dat$Phosphorus),]
          
          if ( nrow(dat)>0 ) {
            
            val <- sum(dat[,'art_dekning'] * dat[,'Phosphorus'],na.rm=T) / sum(dat[,'art_dekning'],na.rm=T)
            # lower part of distribution
            ref <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='Phosphorus1' & seminat.ref.cov.val$grunn==as.character(results.seminat.ASO[['original']][i,"NiN_grunntype"]),'Rv']
            lim <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='Phosphorus1' & seminat.ref.cov.val$grunn==as.character(results.seminat.ASO[['original']][i,"NiN_grunntype"]),'Gv']
            maxmin <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='Phosphorus1' & seminat.ref.cov.val$grunn==as.character(results.seminat.ASO[['original']][i,"NiN_grunntype"]),'maxmin']
            # coercing x into results.seminat.ASO dataframe
            results.seminat.ASO[['scaled']][i,'Phosphorus1'] <- scal() 
            results.seminat.ASO[['non-truncated']][i,'Phosphorus1'] <- scal.2() 
            results.seminat.ASO[['original']][i,'Phosphorus1'] <- val 
            
            # upper part of distribution
            ref <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='Phosphorus2' & seminat.ref.cov.val$grunn==as.character(results.seminat.ASO[['original']][i,"NiN_grunntype"]),'Rv']
            lim <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='Phosphorus2' & seminat.ref.cov.val$grunn==as.character(results.seminat.ASO[['original']][i,"NiN_grunntype"]),'Gv']
            maxmin <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='Phosphorus2' & seminat.ref.cov.val$grunn==as.character(results.seminat.ASO[['original']][i,"NiN_grunntype"]),'maxmin']
            # coercing x into results.seminat.ASO dataframe
            results.seminat.ASO[['scaled']][i,'Phosphorus2'] <- scal() 
            results.seminat.ASO[['non-truncated']][i,'Phosphorus2'] <- scal.2() 
            results.seminat.ASO[['original']][i,'Phosphorus2'] <- val
          }
          
          
          # Grazing_mowing
          dat <- ASO.sp.ind[ASO.sp.ind$ParentGlobalID==as.character(ASO.geo$GlobalID[i]),c('art_dekning','Grazing_mowing')]
          results.seminat.ASO[['original']][i,'richness'] <- nrow(dat)
          dat <- dat[!is.na(dat$Grazing_mowing),]
          
          if ( nrow(dat)>0 ) {
            
            val <- sum(dat[,'art_dekning'] * dat[,'Grazing_mowing'],na.rm=T) / sum(dat[,'art_dekning'],na.rm=T)
            # lower part of distribution
            ref <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='Grazing_mowing1' & seminat.ref.cov.val$grunn==as.character(results.seminat.ASO[['original']][i,"NiN_grunntype"]),'Rv']
            lim <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='Grazing_mowing1' & seminat.ref.cov.val$grunn==as.character(results.seminat.ASO[['original']][i,"NiN_grunntype"]),'Gv']
            maxmin <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='Grazing_mowing1' & seminat.ref.cov.val$grunn==as.character(results.seminat.ASO[['original']][i,"NiN_grunntype"]),'maxmin']
            # coercing x into results.seminat.ASO dataframe
            results.seminat.ASO[['scaled']][i,'Grazing_mowing1'] <- scal() 
            results.seminat.ASO[['non-truncated']][i,'Grazing_mowing1'] <- scal.2() 
            results.seminat.ASO[['original']][i,'Grazing_mowing1'] <- val 
            
            # upper part of distribution
            ref <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='Grazing_mowing2' & seminat.ref.cov.val$grunn==as.character(results.seminat.ASO[['original']][i,"NiN_grunntype"]),'Rv']
            lim <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='Grazing_mowing2' & seminat.ref.cov.val$grunn==as.character(results.seminat.ASO[['original']][i,"NiN_grunntype"]),'Gv']
            maxmin <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='Grazing_mowing2' & seminat.ref.cov.val$grunn==as.character(results.seminat.ASO[['original']][i,"NiN_grunntype"]),'maxmin']
            # coercing x into results.seminat.ASO dataframe
            results.seminat.ASO[['scaled']][i,'Grazing_mowing2'] <- scal() 
            results.seminat.ASO[['non-truncated']][i,'Grazing_mowing2'] <- scal.2() 
            results.seminat.ASO[['original']][i,'Grazing_mowing2'] <- val
          }
          
          
          # Soil_disturbance
          dat <- ASO.sp.ind[ASO.sp.ind$ParentGlobalID==as.character(ASO.geo$GlobalID[i]),c('art_dekning','Soil_disturbance')]
          results.seminat.ASO[['original']][i,'richness'] <- nrow(dat)
          dat <- dat[!is.na(dat$Soil_disturbance),]
          
          if ( nrow(dat)>0 ) {
            
            val <- sum(dat[,'art_dekning'] * dat[,'Soil_disturbance'],na.rm=T) / sum(dat[,'art_dekning'],na.rm=T)
            # lower part of distribution
            ref <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='Soil_disturbance1' & seminat.ref.cov.val$grunn==as.character(results.seminat.ASO[['original']][i,"NiN_grunntype"]),'Rv']
            lim <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='Soil_disturbance1' & seminat.ref.cov.val$grunn==as.character(results.seminat.ASO[['original']][i,"NiN_grunntype"]),'Gv']
            maxmin <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='Soil_disturbance1' & seminat.ref.cov.val$grunn==as.character(results.seminat.ASO[['original']][i,"NiN_grunntype"]),'maxmin']
            # coercing x into results.seminat.ASO dataframe
            results.seminat.ASO[['scaled']][i,'Soil_disturbance1'] <- scal() 
            results.seminat.ASO[['non-truncated']][i,'Soil_disturbance1'] <- scal.2() 
            results.seminat.ASO[['original']][i,'Soil_disturbance1'] <- val 
            
            # upper part of distribution
            ref <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='Soil_disturbance2' & seminat.ref.cov.val$grunn==as.character(results.seminat.ASO[['original']][i,"NiN_grunntype"]),'Rv']
            lim <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='Soil_disturbance2' & seminat.ref.cov.val$grunn==as.character(results.seminat.ASO[['original']][i,"NiN_grunntype"]),'Gv']
            maxmin <- seminat.ref.cov.val[seminat.ref.cov.val$Ind=='Soil_disturbance2' & seminat.ref.cov.val$grunn==as.character(results.seminat.ASO[['original']][i,"NiN_grunntype"]),'maxmin']
            # coercing x into results.seminat.ASO dataframe
            results.seminat.ASO[['scaled']][i,'Soil_disturbance2'] <- scal() 
            results.seminat.ASO[['non-truncated']][i,'Soil_disturbance2'] <- scal.2() 
            results.seminat.ASO[['original']][i,'Soil_disturbance2'] <- val
          }
          
          
          
        }
      }
      

    
  }, error=function(e){cat("ERROR :",conditionMessage(e), "\n")})
}

summary(results.seminat.ASO[['original']])
summary(results.seminat.ASO[['scaled']])

# for using both sides of the Ellenberg indicator
results.seminat.ASO[['2-sided']] <- results.seminat.ASO[['non-truncated']]

# check if there are values equalling exactly 1
results.seminat.ASO[['2-sided']]$Light1[results.seminat.ASO[['2-sided']]$Light1==1]
results.seminat.ASO[['2-sided']]$Light2[results.seminat.ASO[['2-sided']]$Light2==1]
results.seminat.ASO[['2-sided']]$Moist1[results.seminat.ASO[['2-sided']]$Moist1==1]
results.seminat.ASO[['2-sided']]$Moist2[results.seminat.ASO[['2-sided']]$Moist2==1]
results.seminat.ASO[['2-sided']]$pH1[results.seminat.ASO[['2-sided']]$pH1==1]
results.seminat.ASO[['2-sided']]$pH2[results.seminat.ASO[['2-sided']]$pH2==1]
results.seminat.ASO[['2-sided']]$Nitrogen1[results.seminat.ASO[['2-sided']]$Nitrogen1==1]
results.seminat.ASO[['2-sided']]$Nitrogen2[results.seminat.ASO[['2-sided']]$Nitrogen2==1]
results.seminat.ASO[['2-sided']]$Phosphorus1[results.seminat.ASO[['2-sided']]$Phosphorus1==1]
results.seminat.ASO[['2-sided']]$Phosphorus2[results.seminat.ASO[['2-sided']]$Phosphorus2==1]
results.seminat.ASO[['2-sided']]$Grazing_mowing1[results.seminat.ASO[['2-sided']]$Grazing_mowing1==1]
results.seminat.ASO[['2-sided']]$Grazing_mowing2[results.seminat.ASO[['2-sided']]$Grazing_mowing2==1]
results.seminat.ASO[['2-sided']]$Soil_disturbance1[results.seminat.ASO[['2-sided']]$Soil_disturbance1==1]
results.seminat.ASO[['2-sided']]$Soil_disturbance2[results.seminat.ASO[['2-sided']]$Soil_disturbance2==1]



# remove values >1 for Ellenberg
results.seminat.ASO[['2-sided']]$Light1[results.seminat.ASO[['2-sided']]$Light1>1] <- NA
results.seminat.ASO[['2-sided']]$Light2[results.seminat.ASO[['2-sided']]$Light2>1] <- NA

results.seminat.ASO[['2-sided']]$Moist1[results.seminat.ASO[['2-sided']]$Moist1>1] <- NA
results.seminat.ASO[['2-sided']]$Moist2[results.seminat.ASO[['2-sided']]$Moist2>1] <- NA

results.seminat.ASO[['2-sided']]$pH1[results.seminat.ASO[['2-sided']]$pH1>1] <- NA
results.seminat.ASO[['2-sided']]$pH2[results.seminat.ASO[['2-sided']]$pH2>1] <- NA

results.seminat.ASO[['2-sided']]$Nitrogen1[results.seminat.ASO[['2-sided']]$Nitrogen1>1] <- NA
results.seminat.ASO[['2-sided']]$Nitrogen2[results.seminat.ASO[['2-sided']]$Nitrogen2>1] <- NA

results.seminat.ASO[['2-sided']]$Phosphorus1[results.seminat.ASO[['2-sided']]$Phosphorus1>1] <- NA
results.seminat.ASO[['2-sided']]$Phosphorus2[results.seminat.ASO[['2-sided']]$Phosphorus2>1] <- NA

results.seminat.ASO[['2-sided']]$Grazing_mowing1[results.seminat.ASO[['2-sided']]$Grazing_mowing1>1] <- NA
results.seminat.ASO[['2-sided']]$Grazing_mowing2[results.seminat.ASO[['2-sided']]$Grazing_mowing2>1] <- NA

results.seminat.ASO[['2-sided']]$Soil_disturbance1[results.seminat.ASO[['2-sided']]$Soil_disturbance1>1] <- NA
results.seminat.ASO[['2-sided']]$Soil_disturbance2[results.seminat.ASO[['2-sided']]$Soil_disturbance2>1] <- NA


# check distribution
x11()
par(mfrow=c(2,7))

hist(results.seminat.ASO[['2-sided']]$Light1,breaks=40)
hist(results.seminat.ASO[['2-sided']]$Light2,breaks=40)

hist(results.seminat.ASO[['2-sided']]$Moist1,breaks=40)
hist(results.seminat.ASO[['2-sided']]$Moist2,breaks=40)

hist(results.seminat.ASO[['2-sided']]$pH1,breaks=40)
hist(results.seminat.ASO[['2-sided']]$pH2,breaks=40)

hist(results.seminat.ASO[['2-sided']]$Nitrogen1,breaks=40)
hist(results.seminat.ASO[['2-sided']]$Nitrogen2,breaks=40)

hist(results.seminat.ASO[['2-sided']]$Phosphorus1,breaks=40)
hist(results.seminat.ASO[['2-sided']]$Phosphorus2,breaks=40)

hist(results.seminat.ASO[['2-sided']]$Grazing_mowing1,breaks=40)
hist(results.seminat.ASO[['2-sided']]$Grazing_mowing2,breaks=40)

hist(results.seminat.ASO[['2-sided']]$Soil_disturbance1,breaks=40)
hist(results.seminat.ASO[['2-sided']]$Soil_disturbance2,breaks=40)






#write.table(results.seminat.ASO[['scaled']], file='output/scaled data/results.seminat.ASO_scaled.txt',
#            quote=FALSE,sep="\t",col.names=TRUE,row.names=FALSE,dec=".")
#write.table(results.seminat.ASO[['non-truncated']], file='output/scaled data/results.seminat.ASO_non-truncated.txt',
#            quote=FALSE,sep="\t",col.names=TRUE,row.names=FALSE,dec=".")
#write.table(results.seminat.ASO[['original']], file='P:/41201785_okologisk_tilstand_2022_2023/data/FPI_output large files for markdown/results.seminat.ASO_original.txt',
#            quote=FALSE,sep="\t",col.names=TRUE,row.names=FALSE,dec=".")
#write.table(results.seminat.ASO[['2-sided']], file='P:/41201785_okologisk_tilstand_2022_2023/data/FPI_output large files for markdown/results.seminat.ASO_2-sided.txt',
#            quote=FALSE,sep="\t",col.names=TRUE,row.names=FALSE,dec=".")

saveRDS(results.seminat.ASO, "data/cache/results.seminat.ASO.RDS")
rm(list= ls()[!(ls() %in% c('ASO.geo','seminat.ref.cov.val','results.seminat.ASO','settings'))])
save.image("P:/41201785_okologisk_tilstand_2022_2023/data/FPI_output large files for markdown/results.seminat.ASO.RData")

load("P:/41201785_okologisk_tilstand_2022_2023/data/FPI_output large files for markdown/results.seminat.ASO.RData")
