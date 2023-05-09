expit <- function(L) exp(L) / (1+exp(L))

res.seminat3 <- res.seminat2
st_geometry(res.seminat3) <- NULL

dfx <- res.seminat3[res.seminat3$region=="Northern Norway",]

mean(dfx$Grazing_mowing1,na.rm=T)

nrow(dfx[!is.na(dfx$Grazing_mowing1),])

sd(dfx$Grazing_mowing1,na.rm=T)/sqrt(nrow(dfx[!is.na(dfx$Grazing_mowing1),]))


library(betareg)
summary( betareg(Grazing_mowing1 ~ 1, data=dfx) )
expit(coefficients(betareg(Grazing_mowing1 ~ 1, data=dfx))[1])

str(summary( betareg(Grazing_mowing1 ~ 1, data=dfx) ))

expit(summary(betareg(Grazing_mowing1 ~ 1, data=dfx))$coefficients$mean[1])
summary(betareg(Grazing_mowing1 ~ 1, data=dfx))$coefficients$mean[2]

expit( summary(betareg(Grazing_mowing1 ~ 1, data=dfx))$coefficients$mean[1] + 
         summary(betareg(Grazing_mowing1 ~ 1, data=dfx))$coefficients$mean[2] )-
  expit( summary(betareg(Grazing_mowing1 ~ 1, data=dfx))$coefficients$mean[1] )

library(glmmTMB)

summary( glmmTMB(Grazing_mowing1 ~ 1 +(1|ano_flate_id), family=beta_family(), data=dfx) )

expit(summary( glmmTMB(Grazing_mowing1 ~ 1 +(1|ano_flate_id), family=beta_family(), data=dfx) )$coefficients$cond[1])
summary( glmmTMB(Grazing_mowing1 ~ 1 +(1|ano_flate_id), family=beta_family(), data=dfx) )$coefficients$cond[2]

expit( summary( glmmTMB(Grazing_mowing1 ~ 1 +(1|ano_flate_id), family=beta_family(), data=dfx) )$coefficients$cond[1] + 
         summary( glmmTMB(Grazing_mowing1 ~ 1 +(1|ano_flate_id), family=beta_family(), data=dfx) )$coefficients$cond[2] )-
  expit( summary( glmmTMB(Grazing_mowing1 ~ 1 +(1|ano_flate_id), family=beta_family(), data=dfx) )$coefficients$cond[1] )


indmean.beta <- function(df) {

  st_geometry(df) <- NULL
  colnames(df) <- c("y","ran")
  
  if ( nrow(df[!is.na(df[,1]),]) >= 2 ) {
    
    if ( length(unique(df[!is.na(df[,1]),2])) >=5 ) {
      
      mod1 <- glmmTMB(y ~ 1 +(1|ran), family=beta_family(), data=df)
      
      return(c(
        expit(summary( mod1 )$coefficients$cond[1]),
        expit( summary( mod1 )$coefficients$cond[1] + 
                 summary( mod1 )$coefficients$cond[2] )-
          expit( summary( mod1 )$coefficients$cond[1] ),
        nrow(df[!is.na(df$y),])
      ))
      
    } else {
      
      mod2 <- betareg(y ~ 1, data=df)
      
      return(c(
        expit(summary( mod2 )$coefficients$mean[1]),
        expit( summary( mod2 )$coefficients$mean[1] + 
                 summary( mod2 )$coefficients$mean[2] )-
          expit( summary( mod2 )$coefficients$mean[1] ),
        nrow(df[!is.na(df$y),])
      ))
      
    }
    
  } else {
    
    return(c(df$y,NA,1))
    
  }

}

indmean.beta(df=dfx[,c("Grazing_mowing1","ano_flate_id")])



indmean.beta(df=res.seminat2[res.seminat2$region=="Northern Norway",c("Grazing_mowing1","ano_flate_id")])

indmean.beta(df=res.seminat.ASO2[res.seminat.ASO2$region=="Northern Norway",c("Grazing_mowing1","Omradenummer_flatenummer")])



regnor <- regnor %>%
  mutate(
    Grazing_mowing1.reg.mean = c(indmean.beta(df=res.seminat2[res.seminat2$region=="Northern Norway",c("Grazing_mowing1","ano_flate_id")])[1],
                                 indmean.beta(df=res.seminat2[res.seminat2$region=="Central Norway",c("Grazing_mowing1","ano_flate_id")])[1],
                                 indmean.beta(df=res.seminat2[res.seminat2$region=="Eastern Norway",c("Grazing_mowing1","ano_flate_id")])[1],
                                 indmean.beta(df=res.seminat2[res.seminat2$region=="Western Norway",c("Grazing_mowing1","ano_flate_id")])[1],
                                 indmean.beta(df=res.seminat2[res.seminat2$region=="Southern Norway",c("Grazing_mowing1","ano_flate_id")])[1]
                                 ),
    Grazing_mowing1.reg.se = c(indmean.beta(df=res.seminat2[res.seminat2$region=="Northern Norway",c("Grazing_mowing1","ano_flate_id")])[2],
                               indmean.beta(df=res.seminat2[res.seminat2$region=="Central Norway",c("Grazing_mowing1","ano_flate_id")])[2],
                               indmean.beta(df=res.seminat2[res.seminat2$region=="Eastern Norway",c("Grazing_mowing1","ano_flate_id")])[2],
                               indmean.beta(df=res.seminat2[res.seminat2$region=="Western Norway",c("Grazing_mowing1","ano_flate_id")])[2],
                               indmean.beta(df=res.seminat2[res.seminat2$region=="Southern Norway",c("Grazing_mowing1","ano_flate_id")])[2]
                               ),
    Grazing_mowing1.reg.n = c(nrow(res.seminat2[res.seminat2$region=="Northern Norway" & !is.na(res.seminat2$Grazing_mowing1),]),
                              nrow(res.seminat2[res.seminat2$region=="Central Norway" & !is.na(res.seminat2$Grazing_mowing1),]),
                              nrow(res.seminat2[res.seminat2$region=="Eastern Norway" & !is.na(res.seminat2$Grazing_mowing1),]),
                              nrow(res.seminat2[res.seminat2$region=="Western Norway" & !is.na(res.seminat2$Grazing_mowing1),]),
                              nrow(res.seminat2[res.seminat2$region=="Southern Norway" & !is.na(res.seminat2$Grazing_mowing1),])
                              )
  )

# and adding the values for ASO
regnor <- regnor %>%
  mutate(
    Nitrogen2.ASO.reg.mean = c(indmean.beta(df=res.seminat.ASO2[res.seminat.ASO2$region=="Northern Norway",c("Nitrogen2","Omradenummer_flatenummer")])[1],
                               indmean.beta(df=res.seminat.ASO2[res.seminat.ASO2$region=="Central Norway",c("Nitrogen2","Omradenummer_flatenummer")])[1],
                               indmean.beta(df=res.seminat.ASO2[res.seminat.ASO2$region=="Eastern Norway",c("Nitrogen2","Omradenummer_flatenummer")])[1],
                               indmean.beta(df=res.seminat.ASO2[res.seminat.ASO2$region=="Western Norway",c("Nitrogen2","Omradenummer_flatenummer")])[1],
                               indmean.beta(df=res.seminat.ASO2[res.seminat.ASO2$region=="Southern Norway",c("Nitrogen2","Omradenummer_flatenummer")])[1]
                               ),
    Nitrogen2.ASO.reg.se = c(indmean.beta(df=res.seminat.ASO2[res.seminat.ASO2$region=="Northern Norway",c("Nitrogen2","Omradenummer_flatenummer")])[2],
                             indmean.beta(df=res.seminat.ASO2[res.seminat.ASO2$region=="Central Norway",c("Nitrogen2","Omradenummer_flatenummer")])[2],
                             indmean.beta(df=res.seminat.ASO2[res.seminat.ASO2$region=="Eastern Norway",c("Nitrogen2","Omradenummer_flatenummer")])[2],
                             indmean.beta(df=res.seminat.ASO2[res.seminat.ASO2$region=="Western Norway",c("Nitrogen2","Omradenummer_flatenummer")])[2],
                             indmean.beta(df=res.seminat.ASO2[res.seminat.ASO2$region=="Southern Norway",c("Nitrogen2","Omradenummer_flatenummer")])[2]
                             ),
    Nitrogen2.ASO.reg.n = c(nrow(res.seminat.ASO2[res.seminat.ASO2$region=="Northern Norway" & !is.na(res.seminat.ASO2$Nitrogen2),]),
                            nrow(res.seminat.ASO2[res.seminat.ASO2$region=="Central Norway" & !is.na(res.seminat.ASO2$Nitrogen2),]),
                            nrow(res.seminat.ASO2[res.seminat.ASO2$region=="Eastern Norway" & !is.na(res.seminat.ASO2$Nitrogen2),]),
                            nrow(res.seminat.ASO2[res.seminat.ASO2$region=="Western Norway" & !is.na(res.seminat.ASO2$Nitrogen2),]),
                            nrow(res.seminat.ASO2[res.seminat.ASO2$region=="Southern Norway" & !is.na(res.seminat.ASO2$Nitrogen2),]))
  )


tm_shape(regnor) +
  tm_polygons(col="Grazing_mowing1.reg.mean", title="Grazing_mowing (lower), mean", style="quantile", palette=rev(get_brewer_pal(palette="OrRd", n=5, plot=FALSE))) +
  tm_text("Grazing_mowing1.reg.n",col="black",bg.color="grey")
