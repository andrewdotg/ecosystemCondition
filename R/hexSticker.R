#### hexSticker

library(hexSticker)
library(tmap)
library(sf)
library(ggplot2)

nor <- sf::read_sf("data/outlineOfNorway_EPSG25833.shp")

p <- ggplot(data = nor) + 
  geom_sf(colour = "black",
          fill = "darkgreen")+
  theme_void() + 
  theme_transparent()

p

#outline <- tm_shape(nor)+
#  tmap::tm_borders(aes(colour = "blue"))+
#  tm_layout(frame = FALSE)

#getwd()

s <- sticker(p, package="Condition", 
             p_size=15, 
             p_x = .65, 
             p_y = 1.3, 
             s_x=1.2, 
             s_y=.9, 
             s_width=1.3, 
             s_height=2,
             h_fill="#5FBF46", 
             h_color="#3B8A27",
             p_color = "#000000",
             spotlight = T,
        filename="images/hexSticker_EC.png")

plot(s)
