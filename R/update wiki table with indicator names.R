library(flextable)
library(tidyverse)
mytab <- read.csv("data/indicatorNames.csv", sep = ";")


tab2 <- flextable(mytab) %>%
  bg(bg = "white", part="body") %>%
  bg(bg = "wheat", part="header")
save_as_image(tab2, path = "images/wikiTable.png")
