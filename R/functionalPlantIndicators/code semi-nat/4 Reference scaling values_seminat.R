#### defining reference limits, mountain ####

# limit table Ellenberg and aliens, mountain, median and 95% CI
# NB! working at the 1:5000 mapping unit level !!!


## extract from mountain ref-list

# every NiN-type is represented by one 'generalisert artsliste'
# some NiN-types are represented by two species lists
# in some cases two NiN-types are represented by the same species list
head(seminat.ref.cov[[1]])
seminat.ref.cov[[1]][0,]

# NiN-types where each type is represented by one species list (including when one species list represents two NiN-types)
names(seminat.ref.cov[["Light"]])
x <- c(1,5,16,17,19,23,28,31:34)

# checking the actual NiN-types in the seminat lists
seminat.NiNtypes <- colnames(seminat.ref.cov[["Light"]])
seminat.NiNtypes[-x] <- substr(seminat.NiNtypes[-x], 1, nchar(seminat.NiNtypes[-x])-1)
seminat.NiNtypes

# 7 indicator-value indicators: Tyler's Light, Moisture, Soil_reaction_pH, Nitrogen, Phosphorus, Grazing_mowing, Soil_disturbance"
indEll.n=7
# creating a table to hold:
# Tyler: the 0.5 quantile (median), 0.05 quantile and  0.95 quantile for each NiN-type
# for every nature type (nrows)
tab <- matrix(ncol=3*indEll.n, nrow=length(unique(seminat.NiNtypes)) ) # 34 basic ecosystem types
# coercing the values into the table


for (i in 1:length(x) ) {
  tab[i,1:3] <- quantile(as.matrix(seminat.ref.cov[["Light"]][,x[i]]),probs=c(0.025,0.5,0.975),na.rm=T)
  tab[i,4:6] <- quantile(as.matrix(seminat.ref.cov[["Moisture"]][,x[i]]),probs=c(0.025,0.5,0.975),na.rm=T)
  tab[i,7:9] <- quantile(as.matrix(seminat.ref.cov[["Soil_reaction_pH"]][,x[i]]),probs=c(0.025,0.5,0.975),na.rm=T)
  tab[i,10:12] <- quantile(as.matrix(seminat.ref.cov[["Nitrogen"]][,x[i]]),probs=c(0.025,0.5,0.975),na.rm=T)
  tab[i,13:15] <- quantile(as.matrix(seminat.ref.cov[["Phosphorus"]][,x[i]]),probs=c(0.025,0.5,0.975),na.rm=T)
  tab[i,16:18] <- quantile(as.matrix(seminat.ref.cov[["Grazing_mowing"]][,x[i]]),probs=c(0.025,0.5,0.975),na.rm=T)
  tab[i,19:21] <- quantile(as.matrix(seminat.ref.cov[["Soil_disturbance"]][,x[i]]),probs=c(0.025,0.5,0.975),na.rm=T)

}

tab <- as.data.frame(tab)
tab$NiN <- NA
tab$NiN[1:length(x)] <- names(seminat.ref.cov[[1]])[x]
tab

# NiN-types represented by several species lists
seminat.NiNtypes2 <- seminat.NiNtypes[-x]
unique(seminat.NiNtypes2)
grep(pattern=unique(seminat.NiNtypes2)[1], x=seminat.NiNtypes) # finds columns in e.g. colnames(seminat.ref.cov[["Continentality"]]) that match the first NiN-type


for (i in 1:length(unique(seminat.NiNtypes2)) ) {
  tab[length(x)+i,1:3] <- quantile(as.matrix(seminat.ref.cov[["Light"]][,grep(pattern=unique(seminat.NiNtypes2)[i], x=seminat.NiNtypes)]),probs=c(0.025,0.5,0.975),na.rm=T)
  tab[length(x)+i,4:6] <- quantile(as.matrix(seminat.ref.cov[["Moisture"]][,grep(pattern=unique(seminat.NiNtypes2)[i], x=seminat.NiNtypes)]),probs=c(0.025,0.5,0.975),na.rm=T)
  tab[length(x)+i,7:9] <- quantile(as.matrix(seminat.ref.cov[["Soil_reaction_pH"]][,grep(pattern=unique(seminat.NiNtypes2)[i], x=seminat.NiNtypes)]),probs=c(0.025,0.5,0.975),na.rm=T)
  tab[length(x)+i,10:12] <- quantile(as.matrix(seminat.ref.cov[["Nitrogen"]][,grep(pattern=unique(seminat.NiNtypes2)[i], x=seminat.NiNtypes)]),probs=c(0.025,0.5,0.975),na.rm=T)
  tab[length(x)+i,13:15] <- quantile(as.matrix(seminat.ref.cov[["Phosphorus"]][,grep(pattern=unique(seminat.NiNtypes2)[i], x=seminat.NiNtypes)]),probs=c(0.025,0.5,0.975),na.rm=T)
  tab[length(x)+i,16:18] <- quantile(as.matrix(seminat.ref.cov[["Grazing_mowing"]][,grep(pattern=unique(seminat.NiNtypes2)[i], x=seminat.NiNtypes)]),probs=c(0.025,0.5,0.975),na.rm=T)
  tab[length(x)+i,19:21] <- quantile(as.matrix(seminat.ref.cov[["Soil_disturbance"]][,grep(pattern=unique(seminat.NiNtypes2)[i], x=seminat.NiNtypes)]),probs=c(0.025,0.5,0.975),na.rm=T)
  
  tab$NiN[length(x)+i] <- unique(seminat.NiNtypes2)[i]
  
}

tab

# when species lists represent several NiN-types
tab <- rbind(tab,tab[c(3:5,8,10,16,18),])
tab$NiN[c(3:5,8,10,16,18,21:27)] <- c("T32-C1","T32-C3","T32-C7","T45-C1",
                                      "V10-C1","T32-C5","T32-C21","T32-C2",
                                      "T32-C4","T32-C8","T45-C2","V10-C2",
                                      "T32-C20","T32-C6")
tab

# making it a proper data frame
dim(tab)
round(tab[,1:21],digits=2)

colnames(tab) <- c("Light_q2.5","Light_q50","Light_q97.5",
                   "Moist_q2.5","Moist_q50","Moist_q97.5",
                   "pH_q2.5","pH_q50","pH_q97.5",
                   "Nitrogen_q2.5","Nitrogen_q50","Nitrogen_q97.5",
                   "Phosphorus_q2.5","Phosphorus_q50","Phosphorus_q97.5",
                   "Grazing_mowing_q2.5","Grazing_mowing_q50","Grazing_mowing_q97.5",
                   "Soil_disturbance_q2.5","Soil_disturbance_q50","Soil_disturbance_q97.5",
                   
                   "NiN")
summary(tab)
tab$NiN <- gsub("C", "C-", tab$NiN) # add extra hyphen after C for NiN-types
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

y.Phosphorus <- numeric(length=nrow(tab)*2)
y.Phosphorus[((1:dim(tab)[1])*2)-1] <- tab$Phosphorus_q2.5 
y.Phosphorus[((1:dim(tab)[1])*2)] <- tab$Phosphorus_q97.5 

y.Grazing_mowing <- numeric(length=nrow(tab)*2)
y.Grazing_mowing[((1:dim(tab)[1])*2)-1] <- tab$Grazing_mowing_q2.5 
y.Grazing_mowing[((1:dim(tab)[1])*2)] <- tab$Grazing_mowing_q97.5 

y.Soil_disturbance <- numeric(length=nrow(tab)*2)
y.Soil_disturbance[((1:dim(tab)[1])*2)-1] <- tab$Soil_disturbance_q2.5 
y.Soil_disturbance[((1:dim(tab)[1])*2)] <- tab$Soil_disturbance_q97.5 

# creating final objects holding the reference and limit values for all indicators

# ref object for indicators
seminat.ref.cov.val <- data.frame(N1=rep('seminat',(nrow(tab)*2*indEll.n)),
                              hoved=c(rep('NA',(nrow(tab)*2*indEll.n))),
                              grunn=c(rep(rep(tab$NiN,each=2),indEll.n)),
                              county=rep('all',(nrow(tab)*2*indEll.n)),
                              region=rep('all',(nrow(tab)*2*indEll.n)),
                              Ind=c(rep(c('Light1','Light2'),nrow(tab)),
                                    rep(c('Moist1','Moist2'),nrow(tab)),
                                    rep(c('pH1','pH2'),nrow(tab)),
                                    rep(c('Nitrogen1','Nitrogen2'),nrow(tab)),
                                    rep(c('Phosphorus1','Phosphorus2'),nrow(tab)),
                                    rep(c('Grazing_mowing1','Grazing_mowing2'),nrow(tab)),
                                    rep(c('Soil_disturbance1','Soil_disturbance2'),nrow(tab))
                              ),
                              Rv=c(rep(tab$Light_q50,each=2),
                                   rep(tab$Moist_q50,each=2),
                                   rep(tab$pH_q50,each=2),
                                   rep(tab$Nitrogen_q50,each=2),
                                   rep(tab$Phosphorus_q50,each=2),
                                   rep(tab$Grazing_mowing_q50,each=2),
                                   rep(tab$Soil_disturbance_q50,each=2)
                              ),
                              Gv=c(y.Light,y.Moist,y.pH,y.Nitrogen,y.Phosphorus,y.Grazing_mowing,y.Soil_disturbance),
                              maxmin=c(rep(c(1,7),nrow(tab)), # 7 levels of Light
                                       rep(c(1,12),nrow(tab)), # 12 levels of Moisture
                                       rep(c(1,8),nrow(tab)), # 8 levels of Soil_reaction_pH
                                       rep(c(1,9),nrow(tab)),  # 9 levels of Nitrogen
                                       rep(c(1,9),nrow(tab)),  # 5 levels of Phosphorus
                                       rep(c(1,9),nrow(tab)),  # 8 levels of Grazing_mowing
                                       rep(c(1,9),nrow(tab))  # 9 levels of Soil_disturbance
                              )
)

seminat.ref.cov.val
seminat.ref.cov.val$grunn <- as.factor(seminat.ref.cov.val$grunn)
seminat.ref.cov.val$Ind <- as.factor(seminat.ref.cov.val$Ind)
summary(seminat.ref.cov.val)



#write.table(seminat.ref, file='output/ref_for_scaling/mount_ref_ANO.txt',quote=FALSE,sep="\t",col.names=TRUE,row.names=FALSE,dec=".")

