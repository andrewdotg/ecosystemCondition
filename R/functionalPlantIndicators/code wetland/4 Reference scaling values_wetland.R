#### defining reference limits, mountain ####

# limit table Ellenberg and aliens, mountain, median and 95% CI
# NB! working at the 1:5000 mapping unit level !!!


# every NiN-type is represented by one 'generalisert artsliste'
# some NiN-types are represented by two species lists
# in some cases two NiN-types are represented by the same species list
head(wetland.ref.cov[[1]])
wetland.ref.cov[[1]][0,]

# checking the actual NiN-types in the wetland lists
wetland.NiNtypes <- colnames(wetland.ref.cov[["Light"]])
wetland.NiNtypes <- substr(wetland.NiNtypes,1,5)
# 4 indicator-value indicators: Tyler's Light, Moisture, Soil_reaction_pH, "Nitrogen"
indEll.n=4
# creating a table to hold:
# Tyler: the 0.5 quantile (median), 0.05 quantile and  0.95 quantile for each NiN-type
# for every nature type (nrows)
tab <- matrix(ncol=3*indEll.n, nrow=length(unique(wetland.NiNtypes)) ) # 43 basic ecosystem types
# coercing the values into the table
# NiN-types where each type is represented by one species list (including when one species list represents two NiN-types)
names(wetland.ref.cov[["Light"]])
x <- c(27,28,41:45)

for (i in 1:length(x) ) {
  tab[i,1:3] <- quantile(as.matrix(wetland.ref.cov[["Light"]][,x[i]]),probs=c(0.025,0.5,0.975),na.rm=T)
  tab[i,4:6] <- quantile(as.matrix(wetland.ref.cov[["Moisture"]][,x[i]]),probs=c(0.025,0.5,0.975),na.rm=T)
  tab[i,7:9] <- quantile(as.matrix(wetland.ref.cov[["Soil_reaction_pH"]][,x[i]]),probs=c(0.025,0.5,0.975),na.rm=T)
  tab[i,10:12] <- quantile(as.matrix(wetland.ref.cov[["Nitrogen"]][,x[i]]),probs=c(0.025,0.5,0.975),na.rm=T)
}

tab <- as.data.frame(tab)
tab$NiN <- NA
tab$NiN[1:length(x)] <- names(wetland.ref.cov[[1]])[x]

# NiN-types represented by several species lists
wetland.NiNtypes2 <- wetland.NiNtypes[-x]
unique(wetland.NiNtypes2)
grep(pattern=unique(wetland.NiNtypes2)[1], x=wetland.NiNtypes) # finds columns in e.g. colnames(wetland.ref.cov[["Continentality"]]) that match the first NiN-type


for (i in 1:length(unique(wetland.NiNtypes2)) ) {
  tab[length(x)+i,1:3] <- quantile(as.matrix(wetland.ref.cov[["Light"]][,grep(pattern=unique(wetland.NiNtypes2)[i], x=wetland.NiNtypes)]),probs=c(0.025,0.5,0.975),na.rm=T)
  tab[length(x)+i,4:6] <- quantile(as.matrix(wetland.ref.cov[["Moisture"]][,grep(pattern=unique(wetland.NiNtypes2)[i], x=wetland.NiNtypes)]),probs=c(0.025,0.5,0.975),na.rm=T)
  tab[length(x)+i,7:9] <- quantile(as.matrix(wetland.ref.cov[["Soil_reaction_pH"]][,grep(pattern=unique(wetland.NiNtypes2)[i], x=wetland.NiNtypes)]),probs=c(0.025,0.5,0.975),na.rm=T)
  tab[length(x)+i,10:12] <- quantile(as.matrix(wetland.ref.cov[["Nitrogen"]][,grep(pattern=unique(wetland.NiNtypes2)[i], x=wetland.NiNtypes)]),probs=c(0.025,0.5,0.975),na.rm=T)
  tab$NiN[length(x)+i] <- unique(wetland.NiNtypes2)[i]
  
}

tab

# making it a proper data frame
round(tab[,1:12],digits=2)

colnames(tab) <- c("Light_q2.5","Light_q50","Light_q97.5",
                   "Moist_q2.5","Moist_q50","Moist_q97.5",
                   "pH_q2.5","pH_q50","pH_q97.5",
                   "Nitrogen_q2.5","Nitrogen_q50","Nitrogen_q97.5",
                   "NiN")
summary(tab)
tab$NiN <- gsub("C", "C-", tab$NiN) # add extra hyphon after C for NiN-types
tab



# restructuring into separate indicators for lower (q2.5) and higher (q97.5) than reference value (=median, q50)
y.Light <- numeric(length=nrow(tab)*2)
y.Light[((1:dim(tab)[1])*2)-1] <- tab$Light_q2.5 
y.Light[((1:dim(tab)[1])*2)] <- tab$Light_q97.5 

y.Moist <- numeric(length=nrow(tab)*2)
y.Moist[((1:dim(tab)[1])*2)-1] <- tab$Moist_q2.5 
y.Moist[((1:dim(tab)[1])*2)] <- tab$Moist_q97.5 

y.pH <- numeric(length=nrow(tab)*2)
y.pH[((1:dim(tab)[1])*2)-1] <- tab$pH_q2.5 
y.pH[((1:dim(tab)[1])*2)] <- tab$pH_q97.5 

y.Nitrogen <- numeric(length=nrow(tab)*2)
y.Nitrogen[((1:dim(tab)[1])*2)-1] <- tab$Nitrogen_q2.5 
y.Nitrogen[((1:dim(tab)[1])*2)] <- tab$Nitrogen_q97.5 

# creating final objects holding the reference and limit values for all indicators

# ref object for indicators
wetland.ref.cov.val <- data.frame(N1=rep('wetland',(nrow(tab)*2*indEll.n)),
                              hoved=c(rep('NA',(nrow(tab)*2*indEll.n))),
                              grunn=c(rep(rep(tab$NiN,each=2),indEll.n)),
                              county=rep('all',(nrow(tab)*2*indEll.n)),
                              region=rep('all',(nrow(tab)*2*indEll.n)),
                              Ind=c(rep(c('Light1','Light2'),nrow(tab)),
                                    rep(c('Moist1','Moist2'),nrow(tab)),
                                    rep(c('pH1','pH2'),nrow(tab)),
                                    rep(c('Nitrogen1','Nitrogen2'),nrow(tab))
                              ),
                              Rv=c(rep(tab$Light_q50,each=2),
                                   rep(tab$Moist_q50,each=2),
                                   rep(tab$pH_q50,each=2),
                                   rep(tab$Nitrogen_q50,each=2)
                              ),
                              Gv=c(y.Light,y.Moist,y.pH,y.Nitrogen),
                              maxmin=c(rep(c(1,7),nrow(tab)), # 7 levels of light
                                       rep(c(1,12),nrow(tab)), # 12 levels of moisture
                                       rep(c(1,8),nrow(tab)), # 8 levels of soil reaction pH
                                       rep(c(1,9),nrow(tab))  # 9 levels of nitrogen
                              )
)

wetland.ref.cov.val
wetland.ref.cov.val$grunn <- as.factor(wetland.ref.cov.val$grunn)
wetland.ref.cov.val$Ind <- as.factor(wetland.ref.cov.val$Ind)
summary(wetland.ref.cov.val)



#write.table(wetland.ref, file='output/ref_for_scaling/mount_ref_ANO.txt',quote=FALSE,sep="\t",col.names=TRUE,row.names=FALSE,dec=".")

