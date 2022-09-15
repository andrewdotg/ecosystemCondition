# (PART\*) GENERAL TOPICS {.unnumbered}

# On the application of the naturetype dataset {#naturtype}

<br />



*Work in progress*

Author: Anders L. Kolstad

Date: 2022-09-14

Here I will investigate a specific data set, [Naturtyper - Miljødirektoratets instruks](https://kartkatalog.geonorge.no/metadata/naturtyper-miljoedirektoratets-instruks/eb48dd19-03da-41e1-afd9-7ebc3079265c) and try to evaluate its usability for designing indicators for ecosystem condition. This involves assessing both the spatial and temporal representativity, as well as conseptual alignment with the [Norwegian system for ecosystem condition assessments](https://www.regjeringen.no/no/dokumenter/fagsystem-for-fastsetting-av-god-okologisk-tilstand/id2558481/).

The precision in field mapping will not be assess in itself. We assume some, or even considerable, sampling error, but this is inherent to all field data.

## Import data and general summary statistics

-   Total mapped area
-   Temporal trend
-   Histogram of conditions (shiny?)


```r
# local path
#path <- "data/R:/GeoSpatialData/Habitats_biotopes/Norway_Miljodirektoratet_Naturtyper_nin/Original/Natur_Naturtyper_NiN_norge_med_svalbard_25833.gdb"

# server path
#path <- "/data/P-Prosjekter/41201785_okologisk_tilstand_2022_2023/data/Natur_Naturtyper_NiN_norge_med_svalbard_25833.gdb"

# temporary path 
path <- "/data/Egenutvikling/41001581_egenutvikling_anders_kolstad/data/Natur_Naturtyper_NiN_norge_med_svalbard_25833.gdb"


dat <- sf::st_read(dsn = path)
#> Reading layer `Naturtyper_NiN_norge_med_svalbard' from data source `/data/Egenutvikling/41001581_egenutvikling_anders_kolstad/data/Natur_Naturtyper_NiN_norge_med_svalbard_25833.gdb' 
#>   using driver `OpenFileGDB'
#> Simple feature collection with 95469 features and 35 fields
#> Geometry type: MULTIPOLYGON
#> Dimension:     XY
#> Bounding box:  xmin: -74953.5 ymin: 6448986 xmax: 1075080 ymax: 7921283
#> Projected CRS: ETRS89 / UTM zone 33N
names(dat)
#>  [1] "identifikasjon_lokalid"     
#>  [2] "faktaark"                   
#>  [3] "hovedøkosystem"             
#>  [4] "identifikasjon_navnerom"    
#>  [5] "kartlegger"                 
#>  [6] "kartleggingsdato"           
#>  [7] "kartleggingsinstruks"       
#>  [8] "kartleggingsår"             
#>  [9] "kommuner"                   
#> [10] "naturmangfoldbeskrivelse"   
#> [11] "naturomradeid"              
#> [12] "naturtype"                  
#> [13] "naturtypekode"              
#> [14] "lokalitetskvalitet"         
#> [15] "mosaikk"                    
#> [16] "naturmangfold"              
#> [17] "nøyaktighet"                
#> [18] "oppdragsgiver"              
#> [19] "tilstand"                   
#> [20] "tilstandbeskrivelse"        
#> [21] "usikkerhet"                 
#> [22] "usikkerhetsbeskrivelse"     
#> [23] "ninbeskrivelsesvariabler"   
#> [24] "ninkartleggingsenheter"     
#> [25] "objtype"                    
#> [26] "områdenavn"                 
#> [27] "oppdragstaker"              
#> [28] "prosjektid"                 
#> [29] "prosjektnavn"               
#> [30] "uk_ingenstatus"             
#> [31] "uk_nærtruet"                
#> [32] "uk_sebekrivelsenaturtype"   
#> [33] "uk_sentraløkosystemfunksjon"
#> [34] "uk_spesieltdårligkartlagt"  
#> [35] "uk_truet"                   
#> [36] "SHAPE"
```

Fix non-valid polygons


```r
dat <- sf::st_make_valid(dat)
```

Import outline of Norway


```r
nor <- sf::read_sf("data/outlineOfNorway_EPSG25833.shp")
```

The dataset has 95k polygons, each with 36 variables:


```r
dim(dat)
#> [1] 95469    36
```

It therefore takes a little minute to render a plot, but this is the code to do it:


```r
tmap_mode("view")
tm_shape(dat) + 
  tm_polygons(col="tilstand")+
  tm_shape(nor)+
  tm_polygons(alpha = 0,border.col = "black")
```

### Area

Calculating the area


```r
dat$area <- sf::st_area(dat)
summary(dat$area)
#>    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#>      20     722    2891   17677    9026 8532702
```

The smallest polygons are 20 m2, and the biggset is 8.5 km2

Sum of mapped area divided by Norwegian mainland area


```r
sum(dat$area)/sf::st_area(nor)
#> 0.005181438 [1]
```

About 0.5% has been mapped. It is therefore essential that these 0.5% are representative (of the remaining 99.5%).

## Overview of nature types

-   What are the dominant ecosystem groups recorded.


```r
ggplot(dat, aes(x = hovedøkosystem))+
  geom_bar()+
  coord_flip()
```

<img src="naturtype_files/figure-html/unnamed-chunk-9-1.png" width="672" />

This project is concerned only with wetlands (våtmark), semi-natural areas (semi-naturlig mark) and naturally open areas below the forest line (naturlig åpne områder i lavlandet/under skoggrensa).


```r
dat$hovedøkosystem[dat$hovedøkosystem == "Naturlig åpne områder i lavlandet"] <- "Naturlig åpne områder under skoggrensa"
```


```r
unique(dat$hovedøkosystem)
#> [1] "Skog"                                  
#> [2] "Semi-naturlig mark"                    
#> [3] "Våtmark"                               
#> [4] "Naturlig åpne områder under skoggrensa"
#> [5] "Fjell"                                 
#> [6] "Ingen"
utvlagt <- c("Semi-naturlig mark",
             "Våtmark",
             "Naturlig åpne områder under skoggrensa")
dat2 <- dat[dat$hovedøkosystem %in% utvlagt,]
```


```r
temp <- tapply(dat2$area, dat2$hovedøkosystem, sum)
temp <- data.frame(eco = row.names(temp),
                   area = temp)
ggplot(temp, aes(x = eco, y=area))+
  geom_bar(stat="identity")+
  coord_flip()
```

<img src="naturtype_files/figure-html/unnamed-chunk-12-1.png" width="672" />

The same bias towards sami-natural areas are seen when looking at the area mapped, as when looking the number of polygons.

-   What are the dominant nature types recorded.


```r


temp <- dat2[dat2$hovedøkosystem=="Våtmark",]

temp <- tapply(temp$area, temp$naturtype, sum)
temp <- data.frame(nat = row.names(temp),
                   area = temp)

ggplot(temp[order(temp$area),], 
       aes(x = nat,
           y = area))+
  geom_bar(stat = "identity")+
  coord_flip()
```

<img src="naturtype_files/figure-html/unnamed-chunk-13-1.png" width="672" />

-   Can we group these into main ecosystem type categories?
-   Are there any regional differences

## Environmental space

-   Extract environmental data from the polygons and compare against reference data points.
-   Uni-variate (e.g. *boreal hei* plotted against elevation, oceanity, distance from roads, etc)

## Represntaivity in mapping units

Only a subset of nature types are mapped. How well do the mapped units represent, or cover, the range of nature types that is included for each main ecosystem group?

## Conclution 1

Conclude about which main ecosystem types that can reliably assess using the available mapping units?

What about suitability for defining reference values?

## Suitability

In the subset of mapping units that can be said to represent an ecosystem group, which NiN or MdirPRAM variables should we use?

## Concrete examples

### Andel lynghei med minst to faser i kystlynghei

### Areal uten skadet og/eller død røsslyng i kystlynghei

### Aktuell bruksintensitet
