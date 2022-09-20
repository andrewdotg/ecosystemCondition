library(sf)
library(tmap)
library(data.table)

nor <- sf::read_sf("data/outlineOfNorway_EPSG25833.shp")
reg <- st_read("data/regions.shp")
reg$region[reg$region=="Ã\u0098stlandet"] <- "Østlandet"
reg$region[reg$region=="SÃ¸rlandet"] <- "Sørlandet"
reg_clipped <- st_intersection(reg, nor)
reg_clipped$region
# Verdier er ikke helt akuratt
reg_clipped$Fjell <- c(0.68, 0.71, 0.68, 0.68, 0.64)
reg_clipped$Skog <- c(0.42, 0.42, 0.42, 0.37, 0.42)

reg_clipped2 <- data.table::melt(setDT(reg_clipped),
                                 measure.vars = c("Fjell", "Skog"),
                                 variable.name = "Økosystem",
                                 value.name = "Indeksverdi")

reg_clipped3 <- st_as_sf(reg_clipped2)

png("R/output/alpineMountains.png", width = 1200, height = 600, 
    units ="px", res =300)
tm_shape(reg_clipped3) + 
  tm_polygons(col="Indeksverdi", 
              border.col = "black",
              palette="RdYlGn", 
              style="fixed",
              breaks=seq(0,1,0.1))+
    tm_facets(by="Økosystem", ncol  =2)

dev.off()
