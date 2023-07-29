#### defining reference limits, mountain ####

# limit table Ellenberg and aliens, mountain, median and 95% CI
# NB! working at the 1:5000 mapping unit level !!!


## extract from mountain ref-list

# every NiN-type is represented by one 'generalisert artsliste'
# some NiN-types are represented by two species lists
# in some cases two NiN-types are represented by the same species list
head(natopen.ref.cov[[1]])
natopen.ref.cov[[1]][0,]

# NiN-types where each type is represented by one species list (including when one species list represents two NiN-types)
names(natopen.ref.cov[["Light"]])
x <- 1:10

# checking the actual NiN-types in the natopen lists
natopen.NiNtypes <- colnames(natopen.ref.cov[["Light"]])
natopen.NiNtypes[-x] <- substr(natopen.NiNtypes[-x], 1, nchar(natopen.NiNtypes[-x])-1)
natopen.NiNtypes

# 7 indicator-value indicators: Tyler's Light, Moisture, Soil_reaction_pH, Nitrogen, Phosphorus, Grazing_mowing, Soil_disturbance"
indEll.n=6
# creating a table to hold:
# Tyler: the 0.5 quantile (median), 0.05 quantile and  0.95 quantile for each NiN-type
# for every nature type (nrows)
tab <- matrix(ncol=3*indEll.n, nrow=length(unique(natopen.NiNtypes)) ) # 10 basic ecosystem types
# coercing the values into the table


for (i in 1:length(x) ) {
  tab[i,1:3] <- quantile(as.matrix(natopen.ref.cov[["CC"]][,x[i]]),probs=c(0.025,0.5,0.975),na.rm=T)
  tab[i,4:6] <- quantile(as.matrix(natopen.ref.cov[["SS"]][,x[i]]),probs=c(0.025,0.5,0.975),na.rm=T)
  tab[i,7:9] <- quantile(as.matrix(natopen.ref.cov[["RR"]][,x[i]]),probs=c(0.025,0.5,0.975),na.rm=T)
  tab[i,10:12] <- quantile(as.matrix(natopen.ref.cov[["Light"]][,x[i]]),probs=c(0.025,0.5,0.975),na.rm=T)
  tab[i,13:15] <- quantile(as.matrix(natopen.ref.cov[["Nitrogen"]][,x[i]]),probs=c(0.025,0.5,0.975),na.rm=T)
  tab[i,16:18] <- quantile(as.matrix(natopen.ref.cov[["Soil_disturbance"]][,x[i]]),probs=c(0.025,0.5,0.975),na.rm=T)

}

tab <- as.data.frame(tab)
tab$NiN <- NA
tab$NiN[1:length(x)] <- names(natopen.ref.cov[[1]])[x]
tab


# making it a proper data frame
dim(tab)
round(tab[,1:21],digits=2)

colnames(tab) <- c("CC_q2.5","CC_q50","CC_q97.5",
                   "SS_q2.5","SS_q50","SS_q97.5",
                   "RR_q2.5","RR_q50","RR_q97.5",
                   "Light_q2.5","Light_q50","Light_q97.5",
                   "Nitrogen_q2.5","Nitrogen_q50","Nitrogen_q97.5",
                   "Soil_disturbance_q2.5","Soil_disturbance_q50","Soil_disturbance_q97.5",

                   "NiN")
summary(tab)
tab$NiN <- gsub("C", "C-", tab$NiN) # add extra hyphen after C for NiN-types
tab


# restructuring into separate indicators for lower (q2.5) and higher (q97.5) than reference value (=median, q50)
y.Light <- numeric(length=nrow(tab)*2)
y.Light[((1:dim(tab)[1])*2)-1] <- tab$Light_q2.5 
y.Light[((1:dim(tab)[1])*2)] <- tab$Light_q97.5 

y.CC <- numeric(length=nrow(tab)*2)
y.CC[((1:dim(tab)[1])*2)-1] <- tab$CC_q2.5 
y.CC[((1:dim(tab)[1])*2)] <- tab$CC_q97.5 

y.SS <- numeric(length=nrow(tab)*2)
y.SS[((1:dim(tab)[1])*2)-1] <- tab$SS_q2.5 
y.SS[((1:dim(tab)[1])*2)] <- tab$SS_q97.5 

y.Nitrogen <- numeric(length=nrow(tab)*2)
y.Nitrogen[((1:dim(tab)[1])*2)-1] <- tab$Nitrogen_q2.5 
y.Nitrogen[((1:dim(tab)[1])*2)] <- tab$Nitrogen_q97.5 

y.RR <- numeric(length=nrow(tab)*2)
y.RR[((1:dim(tab)[1])*2)-1] <- tab$RR_q2.5 
y.RR[((1:dim(tab)[1])*2)] <- tab$RR_q97.5 

y.Soil_disturbance <- numeric(length=nrow(tab)*2)
y.Soil_disturbance[((1:dim(tab)[1])*2)-1] <- tab$Soil_disturbance_q2.5 
y.Soil_disturbance[((1:dim(tab)[1])*2)] <- tab$Soil_disturbance_q97.5 

# creating final objects holding the reference and limit values for all indicators

# ref object for indicators
natopen.ref.cov.val <- data.frame(N1=rep('natopen',(nrow(tab)*2*indEll.n)),
                              hoved=c(rep('NA',(nrow(tab)*2*indEll.n))),
                              grunn=c(rep(rep(tab$NiN,each=2),indEll.n)),
                              county=rep('all',(nrow(tab)*2*indEll.n)),
                              region=rep('all',(nrow(tab)*2*indEll.n)),
                              Ind=c(rep(c('CC1','CC2'),nrow(tab)),
                                    rep(c('SS1','SS2'),nrow(tab)),
                                    rep(c('RR1','RR2'),nrow(tab)),
                                    rep(c('Light1','Light2'),nrow(tab)),
                                    rep(c('Nitrogen1','Nitrogen2'),nrow(tab)),
                                    rep(c('Soil_disturbance1','Soil_disturbance2'),nrow(tab))
                              ),
                              Rv=c(rep(tab$CC_q50,each=2),
                                   rep(tab$SS_q50,each=2),
                                   rep(tab$RR_q50,each=2),
                                   rep(tab$Light_q50,each=2),
                                   rep(tab$Nitrogen_q50,each=2),
                                   rep(tab$Soil_disturbance_q50,each=2)
                              ),
                              Gv=c(y.CC,y.SS,y.RR,y.Light,y.Nitrogen,y.Soil_disturbance),
                              maxmin=c(rep(c(0,1),nrow(tab)), # CC
                                       rep(c(0,1),nrow(tab)), # SS
                                       rep(c(0,1),nrow(tab)), # RR
                                       rep(c(1,7),nrow(tab)),  # 9 levels of Light
                                       rep(c(1,9),nrow(tab)),  # 5 levels of Nitrogen
                                       rep(c(1,9),nrow(tab))  # 9 levels of Soil_disturbance
                              )
)

natopen.ref.cov.val
natopen.ref.cov.val$grunn <- as.factor(natopen.ref.cov.val$grunn)
natopen.ref.cov.val$Ind <- as.factor(natopen.ref.cov.val$Ind)
summary(natopen.ref.cov.val)



#write.table(natopen.ref, file='output/ref_for_scaling/mount_ref_ANO.txt',quote=FALSE,sep="\t",col.names=TRUE,row.names=FALSE,dec=".")

