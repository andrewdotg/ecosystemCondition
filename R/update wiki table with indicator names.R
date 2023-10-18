library(flextable)
library(tidyverse)
library(readr)
mytab <- read_delim("data/indicatorNames.csv", 
                             delim = ";", escape_double = FALSE, locale = locale(encoding = "ISO-8859-1"), 
                             trim_ws = TRUE)



tab2 <- flextable(mytab) %>%
  bg(bg = "white", part="body") %>%
  bg(bg = "wheat", part="header") %>%
  theme_vanilla() %>%
  set_table_properties(layout = "autofit")

tab2

save_as_image(tab2, path = "images/wikiTable.png")
