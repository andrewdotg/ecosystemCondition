
# Trophic level biomass ratios

<br />

_Author and date:_
James D. M. Speed, Gunnar Austrheim, Erling J. Solberg

August 2023

<br />

<!-- Load all you dependencies here -->






|Ecosystem |Økologisk.egenskap                        |ECT.class                       |
|:---------|:-----------------------------------------|:-------------------------------|
|All       |Biomass distribution among trophic levels |Structural state characteristic |




<!-- Don't remove these three html lines -->
<br />
<br />
<hr />


<!-- Document you work below. Try not to change  the headers too much. Data can be stored on NINA server. Since the book is rendered on the R Server this works fine, but note that directory paths are different on the server compared to you local machine. If it is not too big you may store under /data/ on this repository -->

## Introduction

Here we will develop indicators of ecological condition for Norway, based on the distribution of biomass between trophic levels – specifically between vegetation and vertebrate consumers. This includes three trophic levels, plants, herbivores and carnivores. Indicators of trophic interactions are based on deviation between the observed biomass at each consumer trophic level from the expected biomass based on the biomass at the prey trophic level. The expected biomass estimates are derived from global relationships between plants and vertebrate herbivores ([Fløjgaard et al. 2022](https://doi.org/10.1111/1365-2664.14047)) and between vertebrate prey and predators ([Hatton et al 2015](https://doi.org/10.1126/science.aac6284)).

## About the underlying data

As the plant biomass level we use Net Primary Productivity. MODIS NPP was selected since it provides the highest temporal extent of available data sources (1999 to present). Spatial resolution is low relative to other remote sensing sources, however, the spatial resolution is still far higher than the consumer data, so the temporal extent was prioritised.

The herbivore data is an extension of the data presented in [Austrheim et al. (2008)](https://doi.org/10.2981/10-038) and [Speed et al. (2015)](https://doi.org/10.1371/journal.pone.0217166). For the development of the trophic interaction indicators the same methods were applied to herbivore data going back to 1907 (contra 1949 in the two studies above). This data was extracted by Gunnar Austrheim (livestock) and Erling J. Solberg (wild cervids). In each dataset, the metabolic biomass and the raw biomass of a given species is provided for each year and municipality. The 2007 municipalities were used. The data were rasterized to the same grid as the NPP data.

Metabolic biomass measures were used in the previous studies on Norwegian herbivores cited above. However, for consistency with the global studies used to find predicted biomass, we use raw (unscaled) biomass here.

Herbivore species are wild herbivores: moose/elg, red deer/hjort, roe deer/rådyr, wild reindeer/villrein; and livestock: cattle/storfe, sheep/sau, horses/hest, goats/geit and semi-domestic reindeer/tamrein.

The carnivore data is taken from back-cast population modelling for the large carnivores in Norway (wolf/ulv, brown bear/bjørn, lynx/gaupe and wolverine/jerv). The data was based on hunting statistics, and was collated and modelled by Anna Sobocinski in a [master thesis](https://ntnuopen.ntnu.no/ntnu-xmlui/handle/11250/3047580). The thesis also presented metabolic biomass, but we use raw biomass to make the indicators. This data was also rasterized.

We calculate indicators (1) across all ecosystems and the total consumer communities (all localities and all herbivores and all carnivores) and (2) specific indicators for each main ecosystem type.

### Representativity in time and space

The data spans 1907 to 2015, with data points roughly every 10 years. The whole of Norway is covered. Herbivore data is collated at the municipality level (with the exception of semi-domestic reindeer in Finnmark at county level) and carnivore data at the county level. Municipalities and counties valid in 2007 were used. NPP is at a pixel resolution. 

### Original units

The biomass of the trophic levels is as kg km^-2. 

### Temporal coverage

The data spans 1907 to 2015, with data points roughly every 10 years.

## Ecosystem characteristic

### Norwegain standard

This indicator is within the ecosystem characterstic "biomass distribution among trophic levels"

### SEEA EA (UN standard)

This indicator alines most closely with B2 Structural state characteristics (although arguments could be made also for B1 and B3).

## Collinearities with other indicators

Colinearities are likely to exist with climatic variables and disturbance. 

## Reference condition and values

### Reference condition

Reference values are taken from published global relationships between plants and vertebrate herbivores ([Fløjgaard et al. 2022](https://doi.org/10.1111/1365-2664.14047)) and between vertebrate prey and predators ([Hatton et al 2015](https://doi.org/10.1126/science.aac6284)). 

### Reference values, thresholds for defining _good ecological condition_, minimum and/or maximum values

Deviations from the reference (expected) biomass of consumer based on consumed trophic level biomass are expressed as a two-sided percentage. Good condition was defined as within ±40% of the reference value (i.e. that expected from global relationships). Poor condition as over ±40% of the reference level. The choice of 40% is arbitary. 

## Uncertainties

Uncertainties around the estimates have not been estimated. However, there are potential uncertainties around the reported livestock and hunting statistics and the demographic models used to estimate metabolic biomass at the population level. See Austrheim et al. (2011) and Speed et al. (2015) for further details. 

## References

Austrheim, G., Solberg, E. J., & Mysterud, A. (2011). Spatio‐temporal variation in large herbivore pressure in Norway during 1949‐1999: has decreased grazing by livestock been countered by increased browsing by cervids? Wildlife Biology, 17(3), 286-298.
Fløjgaard, C., Pedersen, P. B. M., Sandom, C. J., Svenning, J. C., & Ejrnæs, R. (2022). Exploring a natural baseline for large‐herbivore biomass in ecological restoration. Journal of Applied Ecology, 59(1), 18-24.
Hatton, I. A., McCann, K. S., Fryxell, J. M., Davies, T. J., Smerlak, M., Sinclair, A. R., & Loreau, M. (2015). The predator-prey power law: Biomass scaling across terrestrial and aquatic biomes. Science, 349(6252), aac6284.
Sobocinski, A. (2022). Mapping large carnivores in Norway across 175 years of changing policy (Master's thesis, NTNU). https://hdl.handle.net/11250/3047580 
Speed, J. D. M., Austrheim, G., Kolstad, A. L., & Solberg, E. J. (2019). Long-term changes in northern large-herbivore communities reveal differential rewilding rates in space and time. PLoS One, 14(5), e0217166.

## Additional information about the data

The raw data is available [here](https://doi.org/10.6084/m9.figshare.24015072).

## Analyses

## Part 1: Total communities

We start by calculation biomass ratios across all herbivores and carnivores, with no regard to the ecosystem type.


```r
#NPP
#Read in
npprast<-rast(paste0(pData,"/Trophic_levels/NPP.tiff"))
viltrast<-rast(paste0(pData,"/Trophic_levels/Vilt_RawBiomass.tiff"))
livestockrast<-rast(paste0(pData,"/Trophic_levels/Livestock_RawBiomass.tiff"))
carnivorerast<-rast(paste0(pData,"/Trophic_levels/Carnivores_RawBiomass.tiff"))

#Vector of years we work with
allyears_vect<-c(1907,1917,1929,1938,1949,1959,1969,1979,1989,1999,2009,2015)

#Livestock data from 1939 and vilt from 1938
names(livestockrast)<- sub(1939,1938,names(livestockrast))
#names(livestockrast)

#Norwegian counties to help plotting
norcounty_shp<-st_read(paste0(pData,"/Trophic_levels/"),"ViltdataCounty")
#> Reading layer `ViltdataCounty' from data source 
#>   `/data/P-Prosjekter2/41201785_okologisk_tilstand_2022_2023/data/Trophic_levels' 
#>   using driver `ESRI Shapefile'
#> Simple feature collection with 912 features and 8 fields
#> Geometry type: MULTIPOLYGON
#> Dimension:     XY
#> Bounding box:  xmin: -76208 ymin: 6450245 xmax: 1114929 ymax: 7939986
#> Projected CRS: ETRS89 / UTM zone 33N
#Simplify by county nr
norcounty<-norcounty_shp %>% 
  group_by(FylkeNr) %>%
  summarise(geometry = st_union(geometry)) 
```

Now we can plot the raw biomass data.

First NPP:


```r
#Select relevant years for NPP
npprast_yrs<-npprast[[names(npprast)%in%c("NPP_2000","NPP_2009","NPP_2015")]]

ggplot()+geom_sf(data=norcounty,fill="white",lwd=0.1)+
         geom_spatraster(data=npprast_yrs)+facet_grid(~lyr)+
         scale_fill_continuous(low="lightgreen",high="darkgreen",na.value=NA,expression('kg C km'^-2~'year'^-1))+theme_bw()
```

<img src="trophic_levels-biomass_indicators_files/figure-html/Plotting basic data-1.png" width="672" />

Next total herbivore biomass:


```r
#Total herbivore biomass
#For some reason need to read the raster in again
livestockrast<-rast(paste0(pData,"/Trophic_levels/Livestock_RawBiomass.tiff"))

totalherbivorebiomass<-livestockrast[[sapply(strsplit(names(livestockrast),"_"),'[',1) %in% "TotalHerbivoreBiomass"]]
names(totalherbivorebiomass)<-allyears_vect
totalherbivorebiomass
#> class       : SpatRaster 
#> dimensions  : 3378, 2701, 12  (nrow, ncol, nlyr)
#> resolution  : 440.9985, 441.0127  (x, y)
#> extent      : -76208, 1114929, 6450245, 7939986  (xmin, xmax, ymin, ymax)
#> coord. ref. : +proj=utm +zone=33 +ellps=GRS80 +units=m +no_defs 
#> source      : Livestock_RawBiomass.tiff 
#> names       :     1907,     1917,     1929,     1938,        1949,        1959, ... 
#> min values  :     0.00,     0.00,     0.00,     0.00,    36.40469,    37.53634, ... 
#> max values  : 24068.81, 32279.18, 33138.37, 36387.98, 15082.97559, 22528.81055, ...
ggplot()+geom_sf(data=norcounty,fill="white",lwd=0.1)+
  geom_spatraster(data=totalherbivorebiomass)+facet_wrap(~lyr)+
  scale_fill_continuous(trans='log10',low="lightskyblue",high="darkblue", na.value=NA,expression(atop('Herbivore \nbiomass', 'kg km'^-2)))+theme_bw()
```

<img src="trophic_levels-biomass_indicators_files/figure-html/PlotTotalHerbivoreBiomass-1.png" width="672" />

And finally total carnivore biomass:


```r
carnivorerast<-rast(paste0(pData,"/Trophic_levels/Carnivores_RawBiomass.tiff"))

totalcarnivores<-carnivorerast[[49:60]]
# alter col names to show the year in the facet strip text
names(totalcarnivores)<-gsub("TotalRawBiomassDensity_", "", names(totalcarnivores))
ggplot()+geom_sf(data=norcounty,fill="white",lwd=0.1)+
  geom_spatraster(data=totalcarnivores)+facet_wrap(~lyr)+
  scale_fill_continuous(low='white',high='red', na.value=NA, expression(atop('Carnviore\nbiomass', 'kg km'^-2)))+theme_bw()+
  theme(strip.text.x = element_text(size = 10))
```

<img src="trophic_levels-biomass_indicators_files/figure-html/Plot carnivore biomass-1.png" width="672" />

Now we use the NPP to estimate the expected herbivore biomass (Fløjgaard et al. 2015, Figure 1/Table 1, Global relationship "mean NPP1km"):


```r
expected_herbivore_biomass<-(npprast_yrs^0.47 * 0.643)#Global 
ggplot()+geom_sf(data=norcounty,fill="white",lwd=0.1)+
  ggtitle("Expected herbivore biomass")+
  geom_spatraster(data=expected_herbivore_biomass)+facet_wrap(~lyr)+theme_bw()+
  scale_fill_continuous(low='lightskyblue',high="darkblue",na.value=NA,expression('kg km'^-2))
```

<img src="trophic_levels-biomass_indicators_files/figure-html/Calculating expected herbivore biomass-1.png" width="672" />

Now we can calculate the deviation between the observed herbivore biomass and the expected herbivore biomass. We calculate this as a % change:

100 x (ActualBiomass -- ExpectedBiomass) / (ExpectedBiomass + 1)

To display this we truncated to 100%\|-100%

A value of 0 indicates that the locality has expected biomass. Value of 100 indicates that the locality has 100% (or more) higher biomass than expected. Value of -100 indicates that the locality has 100% (or more) lower biomass than expected.

«Good» condition assumed to be 0 to \|40%\|


```r
totalherbivorebiomass<-livestockrast[[sapply(strsplit(names(livestockrast),"_"),'[',1) %in% "TotalHerbivoreBiomass"]]
names(totalherbivorebiomass)<-allyears_vect
totalherbivorebiomass_npp<-totalherbivorebiomass[[names(totalherbivorebiomass) %in% c("1999","2009","2015")]]
 
 diffherb<-100*(totalherbivorebiomass_npp-expected_herbivore_biomass)/(expected_herbivore_biomass+1)
 names(diffherb)<-c("2000",'2009','2015')
   
# #Plot on a diverging colour scale around 0
 ggplot()+geom_sf(data=norcounty,fill="white",lwd=0.1)+
   geom_spatraster(data=diffherb)+
   ggtitle("Difference from expected herbivore biomass")+
   scale_fill_distiller(type="div",limit=c(-100,100),oob=squish, na.value=NA,'% difference from \nexpected biomass')+
   facet_wrap(~lyr)+theme_bw()
#> SpatRaster resampled to ncells = 500703
```

<img src="trophic_levels-biomass_indicators_files/figure-html/DifferenceHerbivoreBiomass-1.png" width="672" />

Above we see that on the West coast, Trøndelag, Oppland have double herbivore biomass than expected. There is more herbivore biomass than expected in parts of Finnmark, while Nordland and Lierne have lower herbivore biomass than expected based on NPP. Vestfold & Telemark (and parts of Viken) change from having more herbivore biomass than expected in 2000 to less than expected in 2015 (this is consistent with reduction in moose population in these regions)

-- Next we move on to estimate the expected carnivore biomass based on observed herbivore biomass and calculate the deviation as a % difference from expected as for the herbivores. This is based on Hatton et al. (2015, Figure 1, predator prey biomass relationships).


```r
totalherbivorebiomass<-livestockrast[[sapply(strsplit(names(livestockrast),"_"),'[',1) %in% "TotalHerbivoreBiomass"]]
names(totalherbivorebiomass)<-allyears_vect
#carnivorerast<-rast(paste0(pData,"/Trophic_levels/Carnivores_RawBiomass.tiff"))
totalcarnivores<-carnivorerast[[49:60]]

#Expected carnivore biomass 
#Taken from Hatton et al. Figure 1
expected_carnivore_biomass<-(totalherbivorebiomass^0.73)*0.014#African carnivore and herbivore communities
ggplot()+geom_spatraster(data=expected_carnivore_biomass)+
  ggtitle("Expected carnivore biomass")+
  facet_wrap(~lyr)+theme_bw()+
  scale_fill_continuous(low='lightskyblue',high="darkblue",na.value=NA,expression('kg km'^-2),trans='log10')
#> SpatRaster resampled to ncells = 500703
#> Warning: Transformation introduced infinite values in discrete
#> y-axis
```

<img src="trophic_levels-biomass_indicators_files/figure-html/Expected carnivore biomass-1.png" width="672" />

```r

diffcarn<-100* (totalcarnivores-expected_carnivore_biomass)/(expected_carnivore_biomass+1)
names(diffcarn)<-allyears_vect

ggplot()+geom_sf(data=norcounty,fill="white",lwd=0.1)+
  geom_spatraster(data=diffcarn)+
  ggtitle('Difference from expected carnivore biomass')+
  scale_fill_distiller(type="div",limit=c(-100,100),oob=squish,na.value=NA,"% difference from \nexpected biomass")+
  facet_wrap(~lyr)+theme_bw()
#> SpatRaster resampled to ncells = 500703
```

<img src="trophic_levels-biomass_indicators_files/figure-html/Expected carnivore biomass-2.png" width="672" />

From the above we see that Norway has had less carnivore biomass than expected based on the available herbivore biomass across the time period. Some counties and time periods (e.g. Hedmark today and Finnmark in 1907 had about the same carnivore biomass as predicted.

## Part 2 - Habitat specific biomass distributions

We now create biomass ratios for specific habitat types. To do this we need an ecosystem map and to place each consumer species within each habitat.

Indicators were not developed for mire ecosystems. This decision was taken in conversation with the mire ecosystem group, on the basis that herbivores have minimum use of the mire ecosystems.

Table of the consumer species associated with each habitat.

| Ecosystem             | Livestock               | Wild herbivores   | Carnivores        |
|------------------|-------------------|------------------|------------------|
| Forest                | Storfe                  | Elg, rådyr, hjort | Ulv, gaupe, bjørn |
| Alpine                | Sau, tamrein, geit      | Villrein          | Jerv              |
| Semi-naturlig mark    | Sau, hest, geit, storfe | Hjort             | Gaupe, ulv        |
| Naturlig åpne områder | Sau, geit, storfe       | Hjort             | Gaupe, ulv        |
| Myr                   | \-\--                   | \-\--             | \-\--             |

Since a suitable ecosystem map is still under development, we use the AR50 land-cover map as a place-holding solution. AR50 does not give a good representation of naturlig åpne områder or semi-naturlig mark, so we demonstrate the habitat specific biomass distributions using the forest class in AR50 and the species outlined above.




