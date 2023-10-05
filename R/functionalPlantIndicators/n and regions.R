nrow(res.natopen.GRUK2[!is.na(res.natopen.GRUK2$region) & !is.na(res.natopen.GRUK2$uPunkt_ID) & res.natopen.GRUK2$region=="Northern Norway",])
nrow(res.natopen.GRUK2[!is.na(res.natopen.GRUK2$region) & !is.na(res.natopen.GRUK2$uPunkt_ID) & res.natopen.GRUK2$region=="Central Norway",])
nrow(res.natopen.GRUK2[!is.na(res.natopen.GRUK2$region) & !is.na(res.natopen.GRUK2$uPunkt_ID) & res.natopen.GRUK2$region=="Western Norway",])
nrow(res.natopen.GRUK2[!is.na(res.natopen.GRUK2$region) & !is.na(res.natopen.GRUK2$uPunkt_ID) & res.natopen.GRUK2$region=="Eastern Norway",])
nrow(res.natopen.GRUK2[!is.na(res.natopen.GRUK2$region) & !is.na(res.natopen.GRUK2$uPunkt_ID) & res.natopen.GRUK2$region=="Southern Norway",])

xxx <- ANO.geo.reg %>%
  group_by(hovedtype_rute, region) %>%
  count() %>%
  pivot_wider(names_from = "region", values_from = "n") %>%
  st_drop_geometry()

write.table(xxx, file='C:/Users/joachim.topper/OneDrive - NINA/work/R projects/github/ecosystemCondition/R/output/ANO_punktstat.txt',quote=FALSE,sep=";",col.names=TRUE,row.names=FALSE,dec=".")
