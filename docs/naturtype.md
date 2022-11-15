# (PART\*) GENERAL TOPICS {.unnumbered}

# Nature types {#naturtype}

**On the application of the nature type dataset**

*Data exploration and an analyses of thematic coverage*

<br />




Author: Anders L. Kolstad

Date: 2022-11-15

<br />

Here I will investigate a specific data set, [Naturtyper - Miljødirektoratets instruks](https://kartkatalog.geonorge.no/metadata/naturtyper-miljoedirektoratets-instruks/eb48dd19-03da-41e1-afd9-7ebc3079265c) and try to evaluate its usability for designing indicators for ecosystem condition. This involves assessing both the spatial and temporal representation, as well as conceptual alignment with the [Norwegian system for ecosystem condition assessments](https://www.regjeringen.no/no/dokumenter/fagsystem-for-fastsetting-av-god-okologisk-tilstand/id2558481/).

The precision in field mapping will not be assess in itself. We assume some, or even considerable, sampling error, but this is inherent to all field data.

The first part of this analysis is simply to get an overview of the data, making it ready for part 2 where we look at the thematic coverage of nature types and how the NiN variables are used.


## Import data and general summary statistics

```r
# local path
#path <- "data/R:/GeoSpatialData/Habitats_biotopes/Norway_Miljodirektoratet_Naturtyper_nin/Original/Natur_Naturtyper_NiN_norge_med_svalbard_25833.gdb"

# server path
path <- "/data/P-Prosjekter2/41201785_okologisk_tilstand_2022_2023/data/Natur_Naturtyper_NiN_norge_med_svalbard_25833.gdb"

# temporary path 
#path <- "/data/Egenutvikling/41001581_egenutvikling_anders_kolstad/data/Natur_Naturtyper_NiN_norge_med_svalbard_25833.g#db"
dat <- sf::st_read(dsn = path)
```

Fix non-valid polygons:

```r
dat <- sf::st_make_valid(dat)
```

The dataset has 95k polygons, each with 36 variables:

```r
dim(dat)
#> [1] 95469    36
```

It therefore takes a little minute to render a plot, but this is the code to do it:

```r
nor <- sf::read_sf("data/outlineOfNorway_EPSG25833.shp")
tmap_mode("view")
tm_shape(dat) + 
  tm_polygons(col="tilstand")+
  tm_shape(nor)+
  tm_polygons(alpha = 0,border.col = "black")
```


## Area
Calculating the area for each polygon/locality

```r
dat$area <- sf::st_area(dat)
summary(dat$area)
#>    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#>      20     722    2891   17677    9026 8532702
```
The smallest polygons are 20 m2, and the biggest is 8.5 km2.

The largest polygon is a 

```
#> [1] "Boreal hei"
```

The smallest polygon is a 

```
#> [1] "Sørlig kaldkilde"
```

Sum of mapped area divided by Norwegian mainland area:

```r
#Import outline of mainland Norway
nor <- sf::read_sf("data/outlineOfNorway_EPSG25833.shp")
sum(dat$area)/sf::st_area(nor)
#> 0.005181438 [1]
```
About 0.5% of Norway has been mapped (note that a bigger area than this has been surveyed, but only a small fraction is delineated). It is therefore essential that these 0.5% are representative.

## Temporal trend

```r
dat$kartleggingsår <- as.numeric(dat$kartleggingsår)
```


```r
area_year <- as.data.frame(tapply(dat$area, dat$kartleggingsår, sum))
names(area_year) <- "area"
area_year$year <- row.names(area_year)
area_year$area_km2 <- area_year$area/10^6
```


```r
ggplot(area_year)+
  geom_bar(aes(x = year, y = area_km2),
           stat = "identity",
           fill = "grey",
           colour="black",
           size = 1.2)+
  theme_bw(base_size = 12)+
  labs(x = "Year", y = "Total mapped area (km/2)")
```

<div class="figure">
<img src="naturtype_files/figure-html/unnamed-chunk-11-1.png" alt="Temproal trend in nature type mapping using Miljødirektoratets Instruks" width="672" />
<p class="caption">(\#fig:unnamed-chunk-11)Temproal trend in nature type mapping using Miljødirektoratets Instruks</p>
</div>

The rate of nature type mapping is strongly positive last three years. There are some differences in the field mapping instructions between the years. I will need to decide whether to include all years, or to perhaps exclude the first year.


## Condition
A quick overview of the condition scores 

```r
barplot(tapply(dat$area/10^6, factor(dat$tilstand), sum))
```

<div class="figure">
<img src="naturtype_files/figure-html/unnamed-chunk-12-1.png" alt="The overal distribution of condition scores" width="672" />
<p class="caption">(\#fig:unnamed-chunk-12)The overal distribution of condition scores</p>
</div>

Most sites/polygons are in either good or moderately good condition. I'm not sure what the first class represents. It seems like some polygons don't have a condition score. Looking at just the data set, and also the online *faktaark* for some of these localities, does not give the answer:

```r
View(dat[dat$tilstand=="",])
```

This figure show that these cases are not restricted to just one field season.

```r
barplot(table(dat$kartleggingsår[dat$tilstand==""]), 
        ylab="Number of localities without condition scores",
        xlab="Year")
```

<div class="figure">
<img src="naturtype_files/figure-html/unnamed-chunk-14-1.png" alt="Temporal trend in localities without condition scores." width="672" />
<p class="caption">(\#fig:unnamed-chunk-14)Temporal trend in localities without condition scores.</p>
</div>


```r
par(mar=c(5,20,1,1))
barplot(table(dat$hovedøkosystem[dat$tilstand==""]),
        horiz = T, las=2,
        xlab="Number of localities without condition scores")
```

<div class="figure">
<img src="naturtype_files/figure-html/unnamed-chunk-15-1.png" alt="Main ecosystems with localities missing condition scores." width="672" />
<p class="caption">(\#fig:unnamed-chunk-15)Main ecosystems with localities missing condition scores.</p>
</div>

These cases are restricted to two main ecosystems, and one class where the main ecosystem is not recorded. Looking at some of those cases it is clear that they are not relevant for our work here, I and I don't know why they are in the data set to begin with.

```r
par(mar=c(5,20,1,1))
barplot(table(dat$naturtype[dat$tilstand==""]),
        horiz = T, las=2,
        xlab="Number of localities without condition scores")
```

<div class="figure">
<img src="naturtype_files/figure-html/unnamed-chunk-16-1.png" alt="Nature types with localities missing condition scores." width="672" />
<p class="caption">(\#fig:unnamed-chunk-16)Nature types with localities missing condition scores.</p>
</div>

There are only six nature types (if you exclude those that are not mapped) that don't have a condition score.

`Snøleieblokkmark` and `rabbeblokkmark` do not have a protocol for assessing condition status. `Leirskredgrop`, `leirravine` and `grotte` were nature types in 2018 (not mapped in 2021), and was similarly not assessed for condition scores. `Isinnfrysingsmark` is assessed for condition now, but not in 2018. We can therefore exclude these localities from our data set:

```r
dat_rm <- dat
dat <- dat_rm[dat_rm$tilstand!="",]
```

This resulted in the deletion of 270 rows, or 0.28 % of the data.




## Mosaic types
The field mapping instruction include and option for delineating mosaic types. Let's investigate these cases.

When an area displays a repeating pattern of mixed nature types that each are smaller than the minimum mapping unit MMU, these are grouped into as many overlapping polygons as there are unique nature types. Within the nature type polygons, these will have the same distribution of NiN-grunntyper (online you can see the percentage distribution, but our data set only has the presence/absence data) but be assigned different nature types (nature types is the Environmental agencies classification). The condition scoring can be unique to each overlapping nature type in the mosaic. But we don't know the precise location of the NiN-grunntyper that are part of mosaic nature types.


```r
barplot(table(dat$mosaikk),
        xlab = "Mosaic", ylab="Number of localities")
```

<div class="figure">
<img src="naturtype_files/figure-html/unnamed-chunk-19-1.png" alt="The number of mosaic localities is relatively small." width="672" />
<p class="caption">(\#fig:unnamed-chunk-19)The number of mosaic localities is relatively small.</p>
</div>
Mosaic localities occur in many main ecosystems (and many nature types therein). 

```r
# Fix duplicated `hovedøkosystem`
#unique(dat$hovedøkosystem)
dat$hovedøkosystem[dat$hovedøkosystem=="Naturlig åpne områder i lavlandet"] <- "Naturlig åpne områder under skoggrensa"
```


```r
par(mar=c(5,20,1,1))
barplot(table(dat$hovedøkosystem[dat$mosaikk=="Ja"]),
        horiz = T, las=2,
        xlab="Number of mosaic localities")
```

<div class="figure">
<img src="naturtype_files/figure-html/unnamed-chunk-21-1.png" alt="Distribution of mosaic nature types across hovedøkosystem" width="672" />
<p class="caption">(\#fig:unnamed-chunk-21)Distribution of mosaic nature types across hovedøkosystem</p>
</div>

Some conclusion here could be that

1. Mosaic localities CANNOT be used to pin-point NiN grunntyper (e.g. for remote sensing purposes).
1. Mosaic localities CAN be used to extract condition scores for nature types, but these should not be tied to all the *NiN grunntype* listed in that polygon, because that will include some that belong to the other part(s) of the mosaic.


## NiN types across main ecosystems
The NiN main types can be extracted from the column `ninkartleggingsenheter`. This is the mapping NiN mapping units recorded in the field. The NiN main type makes up the first part of this mapping unit code. The variable is oddly concatenated. Let's tease it apart.


```r
#dat$ninkartleggingsenheter[1:10]
dat$ninkartleggingsenheter2 <- gsub("NA_", dat$ninkartleggingsenheter, replacement = "")
#dat$ninkartleggingsenheter2[1:30]
dat$ninkartleggingsenheter2 <- str_replace_all(dat$ninkartleggingsenheter2, ".[CE].[\\d]{1,}", replacement = "")
#dat$ninkartleggingsenheter2[1:30]
dat$ninkartleggingsenheter2 <- str_replace_all(dat$ninkartleggingsenheter2, "-.", replacement = "")
uni <- function(x){paste(unique(unlist(strsplit(x, ","))), collapse = ",")}
dat$ninkartleggingsenheter3 <- lapply(dat$ninkartleggingsenheter2, uni)
n_uni <- function(x){length(unique(unlist(strsplit(x, ","))))}
dat$n_ninkartleggingsenheter <- lapply(dat$ninkartleggingsenheter2, n_uni)
dat$n_ninkartleggingsenheter <- as.numeric(dat$n_ninkartleggingsenheter) 

par(mfrow=c(1,3))
barplot(table(dat$n_ninkartleggingsenheter),
        xlab = "Number of NiN main types",
        ylab = "Number of localities")
barplot(table(dat$n_ninkartleggingsenheter[dat$mosaikk=="Nei"]),
        xlab = "Number of NiN main types\n(Mosaic localities excluded)")
barplot(table(dat$n_ninkartleggingsenheter[dat$mosaikk=="Ja"]),
        xlab = "Number of NiN main types\n(Mosaic localities only)")
```

<div class="figure">
<img src="naturtype_files/figure-html/unnamed-chunk-22-1.png" alt="The number of NiN main types within one locality should normally be one, except for mosaic localities." width="672" />
<p class="caption">(\#fig:unnamed-chunk-22)The number of NiN main types within one locality should normally be one, except for mosaic localities.</p>
</div>

Mosaic localities (right pane) have a much higher likelihood of including multiple NiN main types, but it also occurs in non-mosaic localities (about 8000 cases). Most, if not all, nature types are defined within a single NiN main type, so we need to see whats going on there.

First I need to melt the data frame in order to tally the number of NiN min types within each `hovedøkosystem`.

```r
dat_melt <- tidyr::separate_rows(dat, ninkartleggingsenheter3)
```


```r
ggplot(dat_melt[dat_melt$mosaikk!="Ja",])+
  geom_bar(aes(x = ninkartleggingsenheter3))+
  coord_flip()+
  theme_bw(base_size = 12)+
  facet_wrap("hovedøkosystem",
             scales = "free")
```

<div class="figure">
<img src="naturtype_files/figure-html/unnamed-chunk-24-1.png" alt="Figure showing the number of localities for each NiN main type. One locality can have more than one NiN main type. Mosaic localities are excluded in this figure." width="672" />
<p class="caption">(\#fig:unnamed-chunk-24)Figure showing the number of localities for each NiN main type. One locality can have more than one NiN main type. Mosaic localities are excluded in this figure.</p>
</div>

There is a lot of miss-match between NiN main types and *hovedøkosystem*. 
Taking one example: T2 (åpen grunnledt mark) is not found in mountains, but there is one case where this occurs. If I view that case


```r
View(dat_melt[dat_melt$mosaikk!="Ja" & dat_melt$hovedøkosystem=="Fjell" & dat_melt$ninkartleggingsenheter3=="T2",])
```

.. and find the online fact sheet for that locality, I see that it is actually NOT a mosaic. It is a nature type called *Kalkfattig og intermediær fjellhei, leside og tundra* which is defined as strictly T3, but the field surveyor has recorded lots of NiN mapping units (and hence, main NiN types) in addition. This is a mistake. Online I can see that the locality is 50% T3, but this information is not in the data set that we have available. Miljødirektoratet could consider adding this information to the downloadable dataset. The order of the NiN types in the `ninkartleggingsenheter` column is not reflecting the commonness of the types ether. 

If there was a way to extract the defining NiN type from the `naturtype` column, that would be nice. Miljødirektoratet may consider adding this as well. If we exclude all localities that are not mosaics, but that have multiple NiN main types, we first need to know if there are not any `naturtype` which allow for multiple NiN main types.

As this next figure show, these cases are not restricted to mapping year, and hence to any changes in the field protocol. Rather this phenomenon is increasing in commonness.

```r
par(mar=c(2,6,2,2))
temp <- dat[dat$n_ninkartleggingsenheter>1 & dat$mosaikk!="Ja",]
barplot(table(temp$kartleggingsår), ylab="Number of localities with more than one NiN main type\n(mosaic localitie excluded) ")
```

<div class="figure">
<img src="naturtype_files/figure-html/unnamed-chunk-26-1.png" alt="Temporal trend in the recording of non-mosaic localities that are recorded as consisting of multiple NiN mapping units from different NiN main types." width="672" />
<p class="caption">(\#fig:unnamed-chunk-26)Temporal trend in the recording of non-mosaic localities that are recorded as consisting of multiple NiN mapping units from different NiN main types.</p>
</div>

Lets look at the most common nature types that are recorded this way.

```r
temp2 <- as.data.frame(table(temp$naturtype, temp$n_ninkartleggingsenheter))
temp2 <- temp2[base::order(temp2$Freq, decreasing = T),][1:10,]
par(mar=c(8,20,1,1))
barplot(temp2$Freq, names.arg = temp2$Var1, las=2,
        horiz = T, xlab = "Number of localities with >1 NiN main type")
```

<div class="figure">
<img src="naturtype_files/figure-html/unnamed-chunk-27-1.png" alt="The ten most common nature types and the number of localities with with multiple NiN main types" width="672" />
<p class="caption">(\#fig:unnamed-chunk-27)The ten most common nature types and the number of localities with with multiple NiN main types</p>
</div>

'Hule eiker' is a special case because these are recorded as points and not polygons, and they can be found in any NiN main type and any *hovedøkosystem*. 

```r
DT::datatable(
  dat[dat$naturtype=="Hule eiker",][1:5,c("naturtype", "hovedøkosystem", "ninkartleggingsenheter")])
```

```{=html}
<div id="htmlwidget-729b4c403d7a7200b951" style="width:100%;height:auto;" class="datatables html-widget"></div>
<script type="application/json" data-for="htmlwidget-729b4c403d7a7200b951">{"x":{"filter":"none","vertical":false,"data":[["3","8","19","33","38"],["Hule eiker","Hule eiker","Hule eiker","Hule eiker","Hule eiker"],["Semi-naturlig mark","Skog","Skog","Semi-naturlig mark","Skog"],["NA_T4-C-3","NA_T43-C-1","NA_T35-C-2,NA_T4-C-7","NA_T4-C-2","NA_T4-C-7"],[{"type":"MultiPolygon","coordinates":[[[[257373.1209,6576294.7663],[257373.089,6576293.79],[257372.9932,6576292.8179],[257372.8341,6576291.8541],[257372.6123,6576290.9029],[257372.3288,6576289.9681],[257371.9847,6576289.0539],[257371.5816,6576288.1642],[257371.1211,6576287.3027],[257370.6053,6576286.4732],[257370.0363,6576285.6793],[257369.4166,6576284.9242],[257368.7489,6576284.2112],[257368.036,6576283.5435],[257367.2809,6576282.9238],[257366.4869,6576282.3549],[257365.6574,6576281.8391],[257364.796,6576281.3786],[257363.9062,6576280.9755],[257362.992,6576280.6314],[257362.0573,6576280.3478],[257361.106,6576280.126],[257360.1423,6576279.9669],[257359.1702,6576279.8712],[257358.1939,6576279.8392],[257357.2176,6576279.8712],[257356.2455,6576279.9669],[257355.2818,6576280.126],[257354.3305,6576280.3478],[257353.3957,6576280.6314],[257352.4816,6576280.9755],[257351.5918,6576281.3786],[257350.7304,6576281.8391],[257349.9009,6576282.3549],[257349.1069,6576282.9238],[257348.3518,6576283.5435],[257347.6389,6576284.2112],[257346.9711,6576284.9242],[257346.3515,6576285.6793],[257345.7825,6576286.4732],[257345.2667,6576287.3027],[257344.8062,6576288.1642],[257344.4031,6576289.0539],[257344.059,6576289.9681],[257343.7755,6576290.9029],[257343.5537,6576291.8541],[257343.3945,6576292.8179],[257343.2988,6576293.79],[257343.2668,6576294.7663],[257343.2988,6576295.7425],[257343.3945,6576296.7146],[257343.5537,6576297.6784],[257343.7755,6576298.6297],[257344.059,6576299.5644],[257344.4031,6576300.4786],[257344.8062,6576301.3683],[257345.2667,6576302.2298],[257345.7825,6576303.0593],[257346.3515,6576303.8533],[257346.9711,6576304.6084],[257347.6389,6576305.3213],[257348.3518,6576305.989],[257349.1069,6576306.6087],[257349.9009,6576307.1777],[257350.7304,6576307.6935],[257351.5918,6576308.1539],[257352.4816,6576308.5571],[257353.3957,6576308.9011],[257354.3305,6576309.1847],[257355.2818,6576309.4065],[257356.2455,6576309.5656],[257357.2176,6576309.6614],[257358.1939,6576309.6933],[257359.1702,6576309.6614],[257360.1423,6576309.5656],[257361.106,6576309.4065],[257362.0573,6576309.1847],[257362.992,6576308.9011],[257363.9062,6576308.5571],[257364.796,6576308.1539],[257365.6574,6576307.6935],[257366.4869,6576307.1777],[257367.2809,6576306.6087],[257368.036,6576305.989],[257368.7489,6576305.3213],[257369.4166,6576304.6084],[257370.0363,6576303.8533],[257370.6053,6576303.0593],[257371.1211,6576302.2298],[257371.5816,6576301.3683],[257371.9847,6576300.4786],[257372.3288,6576299.5644],[257372.6123,6576298.6297],[257372.8341,6576297.6784],[257372.9932,6576296.7146],[257373.089,6576295.7425],[257373.1209,6576294.7663]]]]},{"type":"MultiPolygon","coordinates":[[[[230205.4737,6612351.6694],[230205.4418,6612350.6931],[230205.346,6612349.721],[230205.1869,6612348.7573],[230204.9651,6612347.806],[230204.6815,6612346.8713],[230204.3375,6612345.9571],[230203.9343,6612345.0673],[230203.4739,6612344.2059],[230202.9581,6612343.3764],[230202.3891,6612342.5824],[230201.7694,6612341.8273],[230201.1017,6612341.1144],[230200.3888,6612340.4467],[230199.6337,6612339.827],[230198.8397,6612339.258],[230198.0102,6612338.7422],[230197.1487,6612338.2817],[230196.259,6612337.8786],[230195.3448,6612337.5345],[230194.4101,6612337.251],[230193.4588,6612337.0292],[230192.495,6612336.8701],[230191.5229,6612336.7743],[230190.5467,6612336.7424],[230189.5704,6612336.7743],[230188.5983,6612336.8701],[230187.6345,6612337.0292],[230186.6833,6612337.251],[230185.7485,6612337.5345],[230184.8343,6612337.8786],[230183.9446,6612338.2817],[230183.0831,6612338.7422],[230182.2536,6612339.258],[230181.4597,6612339.827],[230180.7046,6612340.4467],[230179.9917,6612341.1144],[230179.3239,6612341.8273],[230178.7042,6612342.5824],[230178.1353,6612343.3764],[230177.6195,6612344.2059],[230177.159,6612345.0673],[230176.7559,6612345.9571],[230176.4118,6612346.8713],[230176.1282,6612347.806],[230175.9064,6612348.7573],[230175.7473,6612349.721],[230175.6516,6612350.6931],[230175.6196,6612351.6694],[230175.6516,6612352.6457],[230175.7473,6612353.6178],[230175.9064,6612354.5815],[230176.1282,6612355.5328],[230176.4118,6612356.4676],[230176.7559,6612357.3817],[230177.159,6612358.2715],[230177.6195,6612359.1329],[230178.1353,6612359.9624],[230178.7042,6612360.7564],[230179.3239,6612361.5115],[230179.9917,6612362.2244],[230180.7046,6612362.8922],[230181.4597,6612363.5118],[230182.2536,6612364.0808],[230183.0831,6612364.5966],[230183.9446,6612365.0571],[230184.8343,6612365.4602],[230185.7485,6612365.8043],[230186.6833,6612366.0878],[230187.6345,6612366.3096],[230188.5983,6612366.4688],[230189.5704,6612366.5645],[230190.5467,6612366.5965],[230191.5229,6612366.5645],[230192.495,6612366.4688],[230193.4588,6612366.3096],[230194.4101,6612366.0878],[230195.3448,6612365.8043],[230196.259,6612365.4602],[230197.1487,6612365.0571],[230198.0102,6612364.5966],[230198.8397,6612364.0808],[230199.6337,6612363.5118],[230200.3888,6612362.8922],[230201.1017,6612362.2244],[230201.7694,6612361.5115],[230202.3891,6612360.7564],[230202.9581,6612359.9624],[230203.4739,6612359.1329],[230203.9343,6612358.2715],[230204.3375,6612357.3817],[230204.6815,6612356.4676],[230204.9651,6612355.5328],[230205.1869,6612354.5815],[230205.346,6612353.6178],[230205.4418,6612352.6457],[230205.4737,6612351.6694]]]]},{"type":"MultiPolygon","coordinates":[[[[234886.4963,6595819.1304],[234886.4644,6595818.1541],[234886.3686,6595817.1821],[234886.2095,6595816.2183],[234885.9877,6595815.267],[234885.7041,6595814.3323],[234885.3601,6595813.4181],[234884.9569,6595812.5284],[234884.4965,6595811.6669],[234883.9807,6595810.8374],[234883.4117,6595810.0434],[234882.792,6595809.2883],[234882.1243,6595808.5754],[234881.4114,6595807.9077],[234880.6563,6595807.288],[234879.8623,6595806.719],[234879.0328,6595806.2032],[234878.1713,6595805.7428],[234877.2816,6595805.3396],[234876.3674,6595804.9955],[234875.4327,6595804.712],[234874.4814,6595804.4902],[234873.5176,6595804.3311],[234872.5455,6595804.2353],[234871.5693,6595804.2034],[234870.593,6595804.2353],[234869.6209,6595804.3311],[234868.6571,6595804.4902],[234867.7059,6595804.712],[234866.7711,6595804.9955],[234865.8569,6595805.3396],[234864.9672,6595805.7428],[234864.1057,6595806.2032],[234863.2762,6595806.719],[234862.4822,6595807.288],[234861.7272,6595807.9077],[234861.0142,6595808.5754],[234860.3465,6595809.2883],[234859.7268,6595810.0434],[234859.1579,6595810.8374],[234858.6421,6595811.6669],[234858.1816,6595812.5284],[234857.7785,6595813.4181],[234857.4344,6595814.3323],[234857.1508,6595815.267],[234856.929,6595816.2183],[234856.7699,6595817.1821],[234856.6742,6595818.1541],[234856.6422,6595819.1304],[234856.6742,6595820.1067],[234856.7699,6595821.0788],[234856.929,6595822.0425],[234857.1508,6595822.9938],[234857.4344,6595823.9286],[234857.7785,6595824.8428],[234858.1816,6595825.7325],[234858.6421,6595826.594],[234859.1579,6595827.4235],[234859.7268,6595828.2174],[234860.3465,6595828.9725],[234861.0142,6595829.6854],[234861.7272,6595830.3532],[234862.4822,6595830.9729],[234863.2762,6595831.5418],[234864.1057,6595832.0576],[234864.9672,6595832.5181],[234865.8569,6595832.9212],[234866.7711,6595833.2653],[234867.7059,6595833.5489],[234868.6571,6595833.7707],[234869.6209,6595833.9298],[234870.593,6595834.0255],[234871.5693,6595834.0575],[234872.5455,6595834.0255],[234873.5176,6595833.9298],[234874.4814,6595833.7707],[234875.4327,6595833.5489],[234876.3674,6595833.2653],[234877.2816,6595832.9212],[234878.1713,6595832.5181],[234879.0328,6595832.0576],[234879.8623,6595831.5418],[234880.6563,6595830.9729],[234881.4114,6595830.3532],[234882.1243,6595829.6854],[234882.792,6595828.9725],[234883.4117,6595828.2174],[234883.9807,6595827.4235],[234884.4965,6595826.594],[234884.9569,6595825.7325],[234885.3601,6595824.8428],[234885.7041,6595823.9286],[234885.9877,6595822.9938],[234886.2095,6595822.0425],[234886.3686,6595821.0788],[234886.4644,6595820.1067],[234886.4963,6595819.1304]]]]},{"type":"MultiPolygon","coordinates":[[[[246942.6116,6656594.3792],[246942.5796,6656593.403],[246942.4839,6656592.4309],[246942.3248,6656591.4671],[246942.1029,6656590.5158],[246941.8194,6656589.5811],[246941.4753,6656588.6669],[246941.0722,6656587.7772],[246940.6117,6656586.9157],[246940.0959,6656586.0862],[246939.5269,6656585.2922],[246938.9073,6656584.5372],[246938.2395,6656583.8242],[246937.5266,6656583.1565],[246936.7715,6656582.5368],[246935.9775,6656581.9679],[246935.148,6656581.452],[246934.2866,6656580.9916],[246933.3969,6656580.5884],[246932.4827,6656580.2444],[246931.5479,6656579.9608],[246930.5966,6656579.739],[246929.6329,6656579.5799],[246928.6608,6656579.4842],[246927.6845,6656579.4522],[246926.7082,6656579.4842],[246925.7361,6656579.5799],[246924.7724,6656579.739],[246923.8211,6656579.9608],[246922.8864,6656580.2444],[246921.9722,6656580.5884],[246921.0825,6656580.9916],[246920.221,6656581.452],[246919.3915,6656581.9679],[246918.5975,6656582.5368],[246917.8424,6656583.1565],[246917.1295,6656583.8242],[246916.4618,6656584.5372],[246915.8421,6656585.2922],[246915.2731,6656586.0862],[246914.7573,6656586.9157],[246914.2969,6656587.7772],[246913.8937,6656588.6669],[246913.5496,6656589.5811],[246913.2661,6656590.5158],[246913.0443,6656591.4671],[246912.8852,6656592.4309],[246912.7894,6656593.403],[246912.7575,6656594.3792],[246912.7894,6656595.3555],[246912.8852,6656596.3276],[246913.0443,6656597.2914],[246913.2661,6656598.2427],[246913.5496,6656599.1774],[246913.8937,6656600.0916],[246914.2969,6656600.9813],[246914.7573,6656601.8428],[246915.2731,6656602.6723],[246915.8421,6656603.4663],[246916.4618,6656604.2213],[246917.1295,6656604.9343],[246917.8424,6656605.602],[246918.5975,6656606.2217],[246919.3915,6656606.7906],[246920.221,6656607.3065],[246921.0825,6656607.7669],[246921.9722,6656608.17],[246922.8864,6656608.5141],[246923.8211,6656608.7977],[246924.7724,6656609.0195],[246925.7361,6656609.1786],[246926.7082,6656609.2743],[246927.6845,6656609.3063],[246928.6608,6656609.2743],[246929.6329,6656609.1786],[246930.5966,6656609.0195],[246931.5479,6656608.7977],[246932.4827,6656608.5141],[246933.3969,6656608.17],[246934.2866,6656607.7669],[246935.148,6656607.3065],[246935.9775,6656606.7906],[246936.7715,6656606.2217],[246937.5266,6656605.602],[246938.2395,6656604.9343],[246938.9073,6656604.2213],[246939.5269,6656603.4663],[246940.0959,6656602.6723],[246940.6117,6656601.8428],[246941.0722,6656600.9813],[246941.4753,6656600.0916],[246941.8194,6656599.1774],[246942.1029,6656598.2427],[246942.3248,6656597.2914],[246942.4839,6656596.3276],[246942.5796,6656595.3555],[246942.6116,6656594.3792]]]]},{"type":"MultiPolygon","coordinates":[[[[34307.7715999996,6459711.1272],[34307.7396999998,6459710.151],[34307.6438999996,6459709.1789],[34307.4847999997,6459708.2151],[34307.2630000003,6459707.2638],[34306.9793999996,6459706.3291],[34306.6354,6459705.4149],[34306.2322000004,6459704.5252],[34305.7718000002,6459703.6637],[34305.2560000001,6459702.8342],[34304.6869999999,6459702.0402],[34304.0673000002,6459701.2852],[34303.3996000001,6459700.5722],[34302.6867000004,6459699.9045],[34301.9315999998,6459699.2848],[34301.1376,6459698.7159],[34300.3081,6459698.2],[34299.4466000004,6459697.7396],[34298.5569000002,6459697.3364],[34297.6426999997,6459696.9924],[34296.7079999996,6459696.7088],[34295.7566999998,6459696.487],[34294.7928999998,6459696.3279],[34293.8207999999,6459696.2322],[34292.8446000004,6459696.2002],[34291.8683000002,6459696.2322],[34290.8962000003,6459696.3279],[34289.9324000003,6459696.487],[34288.9812000003,6459696.7088],[34288.0464000003,6459696.9924],[34287.1321999999,6459697.3364],[34286.2424999997,6459697.7396],[34285.3810000001,6459698.2],[34284.5515000001,6459698.7159],[34283.7576000001,6459699.2848],[34283.0025000004,6459699.9045],[34282.2895,6459700.5722],[34281.6217999998,6459701.2852],[34281.0021000002,6459702.0402],[34280.4331999999,6459702.8342],[34279.9173999997,6459703.6637],[34279.4568999996,6459704.5252],[34279.0537999999,6459705.4149],[34278.7096999995,6459706.3291],[34278.4260999998,6459707.2638],[34278.2043000003,6459708.2151],[34278.0451999996,6459709.1789],[34277.9495000001,6459710.151],[34277.9175000004,6459711.1272],[34277.9495000001,6459712.1035],[34278.0451999996,6459713.0756],[34278.2043000003,6459714.0394],[34278.4260999998,6459714.9907],[34278.7096999995,6459715.9254],[34279.0537999999,6459716.8396],[34279.4568999996,6459717.7293],[34279.9173999997,6459718.5908],[34280.4331999999,6459719.4203],[34281.0021000002,6459720.2143],[34281.6217999998,6459720.9693],[34282.2895,6459721.6823],[34283.0025000004,6459722.35],[34283.7576000001,6459722.9697],[34284.5515000001,6459723.5386],[34285.3810000001,6459724.0545],[34286.2424999997,6459724.5149],[34287.1321999999,6459724.918],[34288.0464000003,6459725.2621],[34288.9812000003,6459725.5457],[34289.9324000003,6459725.7675],[34290.8962000003,6459725.9266],[34291.8683000002,6459726.0223],[34292.8446000004,6459726.0543],[34293.8207999999,6459726.0223],[34294.7928999998,6459725.9266],[34295.7566999998,6459725.7675],[34296.7079999996,6459725.5457],[34297.6426999997,6459725.2621],[34298.5569000002,6459724.918],[34299.4466000004,6459724.5149],[34300.3081,6459724.0545],[34301.1376,6459723.5386],[34301.9315999998,6459722.9697],[34302.6867000004,6459722.35],[34303.3996000001,6459721.6823],[34304.0673000002,6459720.9693],[34304.6869999999,6459720.2143],[34305.2560000001,6459719.4203],[34305.7718000002,6459718.5908],[34306.2322000004,6459717.7293],[34306.6354,6459716.8396],[34306.9793999996,6459715.9254],[34307.2630000003,6459714.9907],[34307.4847999997,6459714.0394],[34307.6438999996,6459713.0756],[34307.7396999998,6459712.1035],[34307.7715999996,6459711.1272]]]]}]],"container":"<table class=\"display\">\n  <thead>\n    <tr>\n      <th> <\/th>\n      <th>naturtype<\/th>\n      <th>hovedøkosystem<\/th>\n      <th>ninkartleggingsenheter<\/th>\n      <th>SHAPE<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"order":[],"autoWidth":false,"orderClasses":false,"columnDefs":[{"orderable":false,"targets":0}]}},"evals":[],"jsHooks":[]}</script>
```

*Kystlynghei* often occurs as a mosaic, but figure \@ref(fig:multipleNiN) has excluded the mosaic localities, and then *kystlynghei* is strictly defined to T34.
The same is true for *naturbeitemark* which is restricted to T32.
Maybe these localities should all have been recorded as mosaic localities. In any case, we cannot automatically extract the main NiN type from these rows now. 

The remaining option is to manually assign the defining NiN main type to each nature type. This data is not included in the data set, and would need to be sourced from the mapping protocols for all the different field seasons.

For a deeper analyses into the causes for localities being mapped to NiN main types outside the definition of the nature type, see [Appendix 1].

## Assigning NiN main types to Nature types
The NiN main types need to be added manually to the nature types, as the field recorded data is error prone, and the defining NiN units for each nature type is not included in the data set.

I will start by excluding all but the three target ecosystems.

```r
target <- c("Semi-naturlig mark","Våtmark","Naturlig åpne områder under skoggrensa")
dat <- dat[dat$hovedøkosystem %in% target,]
```

I will also exclude `Hule eiker`, as this nature type is not easy to tie to a single main ecosystem


```r
dat <- dat[dat$naturtype != "Hule eiker",]
```

Get the unique nature types

```r
ntyp <- unique(dat$naturtype)
```

Extract the year when these were mapped

```r
years <- NULL
for(i in 1:length(ntyp)){
years[i] <- paste(sort(unique(dat$kartleggingsår[dat$naturtype == ntyp[i]])), collapse = ", ")
}
```

Extract the associated ecosystem

```r
eco <- NULL
for(i in 1:length(ntyp)){
eco[i] <- paste(unique(dat$hovedøkosystem[dat$naturtype == ntyp[i]]), collapse = ", ")
}
```

Combine into one data frame

```r
ntypDF <- data.frame(
  "Nature_type" = ntyp,
  "Year"        = years,
  "Ecosystem"   = eco
)
```

We have 66 nature types to consider. Some of the wetland types can actually be excluded because of the way we limited this ecosystem to mean *open* wetland.


```r
excl_nt <- c("Kalkrik myr- og sumpskogsmark",
             #"Flommyr, myrkant og myrskogsmark",  # Only V9 is relevant. This type also includes V2 and V8
             "Gammel fattig sumpskog",
             "Rik gransumpskog",
             "Grankildeskog",
             "Rik svartorsumpskog",
             "Rik gråorsumpskog",
             "Rik svartorstrandskog",
             "Saltpåvirket svartorstrandskog",
             "Kilde-edellauvskog",
             "Saltpåvirket strand- og sumpskogsmark",
             "Svak kilde og kildeskogsmark",
             "Rik vierstrandskog",
             "Varmekjær kildelauvskog"
             )
`%!in%` <- Negate(`%in%`)
ntypDF <- ntypDF[ntypDF$Nature_type %!in% excl_nt,]
```


```r
DT::datatable(ntypDF)
```

<div class="figure">

```{=html}
<div id="htmlwidget-c6a36a2dd3321fb17495" style="width:100%;height:auto;" class="datatables html-widget"></div>
<script type="application/json" data-for="htmlwidget-c6a36a2dd3321fb17495">{"x":{"filter":"none","vertical":false,"data":[["1","2","3","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","23","25","28","29","30","31","33","34","35","36","38","39","40","41","42","43","44","45","46","47","48","50","51","52","53","54","58","59","60","62","63","65","66"],["Slåttemark","Kystlynghei","Naturbeitemark","Slåttemyr","Boreal hei","Åpen myrflate i boreonemoral til nordboreal sone","Semi-naturlig eng","Platåhøymyr","Strandeng","Hagemark","Semi-naturlig våteng","Eksentrisk høymyr","Rik åpen jordvannsmyr i mellomboreal sone","Sørlig slåttemyr","Terrengdekkende myr","Semi-naturlig myr","Åpen flomfastmark","Svært tørkeutsatt sørlig kalkberg","Flommyr, myrkant og myrskogsmark","Isinnfrysingsmark","Eng-aktig sterkt endret fastmark","Høgereligende og nordlig nedbørsmyr","Øyblandingsmyr","Semi-naturlig strandeng","Lauveng","Kalkrik helofyttsump","Kalkrik åpen jordvannsmyr i boreonemoral til nordboreal sone","Sørlig nedbørsmyr","Rik åpen sørlig jordvannsmyr","Fossepåvirket berg","Aktiv skredmark","Palsmyr","Silt og leirskred","Nakent tørkeutsatt kalkberg","Sørlig kaldkilde","Kystnedbørsmyr","Åpen grunnlendt kalkrik mark i boreonemoral sone","Kaldkilde under skoggrensa","Sørlig etablert sanddynemark","Atlantisk høymyr","Rik åpen jordvannsmyr i nordboreal og lavalpin sone","Sanddynemark","Åpen grunnlendt kalkrik mark i sørboreal sone","Fuglefjell-eng og fugletopp","Fosseberg","Kanthøymyr","Sentrisk høgmyr","Tørt kalkrikt berg i kontinentale områder","Fosse-eng","Sørlig strandeng","Øvre sandstrand uten pionervegetasjon","Konsentrisk høymyr","Åpen myrflate i lavalpin sone"],["2018, 2019, 2020, 2021","2018, 2019, 2020, 2021","2018, 2019, 2020, 2021","2018, 2019, 2020, 2021","2018, 2019, 2020, 2021","2018","2018, 2019, 2020, 2021","2019, 2020, 2021","2018, 2019, 2020, 2021","2018, 2019, 2020, 2021","2018, 2019, 2020, 2021","2019, 2020, 2021","2019, 2020, 2021","2019, 2020, 2021","2019, 2020, 2021","2019, 2020, 2021","2018, 2019, 2020, 2021","2019, 2020, 2021","2018","2018, 2019, 2020, 2021","2018, 2019, 2020, 2021","2019, 2020, 2021","2019, 2020, 2021","2018, 2019, 2020, 2021","2019, 2020","2019, 2020, 2021","2018","2019, 2020, 2021","2018, 2019, 2020, 2021","2019, 2020, 2021","2019, 2020, 2021","2021","2019, 2020, 2021","2018, 2019, 2020, 2021","2018, 2019, 2020, 2021","2018","2018, 2019, 2020, 2021","2018","2018, 2019, 2020, 2021","2019, 2020, 2021","2018, 2019, 2020, 2021","2018, 2019, 2020, 2021","2019, 2020, 2021","2019, 2020, 2021","2021","2019, 2020, 2021","2018","2019","2019, 2020","2018","2019, 2020, 2021","2019, 2020","2018"],["Semi-naturlig mark","Semi-naturlig mark","Semi-naturlig mark","Våtmark","Semi-naturlig mark","Våtmark","Semi-naturlig mark","Våtmark","Naturlig åpne områder under skoggrensa","Semi-naturlig mark","Våtmark","Våtmark","Våtmark","Våtmark","Våtmark","Våtmark","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Våtmark","Naturlig åpne områder under skoggrensa","Semi-naturlig mark","Våtmark","Våtmark","Semi-naturlig mark","Semi-naturlig mark","Våtmark","Våtmark","Våtmark","Våtmark","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Våtmark","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Våtmark","Våtmark","Naturlig åpne områder under skoggrensa","Våtmark","Naturlig åpne områder under skoggrensa","Våtmark","Våtmark","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Våtmark","Våtmark","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Våtmark","Våtmark"]],"container":"<table class=\"display\">\n  <thead>\n    <tr>\n      <th> <\/th>\n      <th>Nature_type<\/th>\n      <th>Year<\/th>\n      <th>Ecosystem<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"order":[],"autoWidth":false,"orderClasses":false,"columnDefs":[{"orderable":false,"targets":0}]}},"evals":[],"jsHooks":[]}</script>
```

<p class="caption">(\#fig:unnamed-chunk-35)List of nature types showing the years when that nature type was mapped.</p>
</div>

I will also now exclude nature types that were only mapped in 2018 and/or 2019 and not after that. These nature types will not only not get more data in the future, but also they were mapped in a time when the methodology was quite unstable. 


```r
ntypDF2 <- ntypDF[ntypDF$Year != "2018" &
                  ntypDF$Year != "2019" & 
                  ntypDF$Year != "2018, 2019"# no types were mappend in 2018 & 2019 only
                  ,]
```


Next I want to add the NiN main types. I need to look at the definition of each nature type and get the NiN code from there. I could also extract the NiN sub types (grunntyper), but it would become too messy. Therefor I will create a second column with a textual/categorical description of the degree of thematic coverage.

I will look at the definitions of the nature type in the first and last year when that type was mapped, but not for the years in between.

### Add NiN main type and degree of representativity

```r
ntypDF2$hovedgruppe[ntypDF2$Nature_type == "Aktiv skredmark"                                    ] <- "T17 | all (if including sub-types)"
ntypDF2$hovedgruppe[ntypDF2$Nature_type == "Åpen flomfastmark"                                  ] <- "T18 | all"
ntypDF2$hovedgruppe[ntypDF2$Nature_type == "Åpen grunnlendt kalkrik mark i boreonemoral sone"   ] <- "T2  | calcareous"
ntypDF2$hovedgruppe[ntypDF2$Nature_type == "Åpen grunnlendt kalkrik mark i sørboreal sone"      ] <- "T2  | calcareous"
ntypDF2$hovedgruppe[ntypDF2$Nature_type == "Atlantisk høymyr"                                   ] <- "V3  | all (if including sub-types)" # can also include smaller areas of V1
ntypDF2$hovedgruppe[ntypDF2$Nature_type == "Boreal hei"                                         ] <- "T31 | all"
ntypDF2$hovedgruppe[ntypDF2$Nature_type == "Eksentrisk høymyr"                                  ] <- "V3  | all (if including sub-types)" # can also include smaller areas of V1
ntypDF2$hovedgruppe[ntypDF2$Nature_type == "Eng-aktig sterkt endret fastmark"                   ] <- "T41 | all"
ntypDF2$hovedgruppe[ntypDF2$Nature_type == "Fosse-eng"                                          ] <- "T15 | all"
ntypDF2$hovedgruppe[ntypDF2$Nature_type == "Fosseberg"                                          ] <- "T1  | extra wet"
ntypDF2$hovedgruppe[ntypDF2$Nature_type == "Fossepåvirket berg"                                 ] <- "T1  | extra wet"
ntypDF2$hovedgruppe[ntypDF2$Nature_type == "Fuglefjell-eng og fugletopp"                        ] <- "T8  | all"
ntypDF2$hovedgruppe[ntypDF2$Nature_type == "Hagemark"                                           ] <- "T32 | all (if including sub-types)"
ntypDF2$hovedgruppe[ntypDF2$Nature_type == "Høgereligende og nordlig nedbørsmyr"                ] <- "V3  | all (if including sub-types)" # torvmarksformene are excluded
ntypDF2$hovedgruppe[ntypDF2$Nature_type == "Isinnfrysingsmark"                                  ] <- "T20 | all"
ntypDF2$hovedgruppe[ntypDF2$Nature_type == "Kalkrik helofyttsump"                               ] <- "L4 | calcareous"
ntypDF2$hovedgruppe[ntypDF2$Nature_type == "Kanthøymyr"                                         ] <- "V3  | all (if including sub-types)" # can also include smaller areas of V1
ntypDF2$hovedgruppe[ntypDF2$Nature_type == "Konsentrisk høymyr"                                 ] <- "V3  | all (if including sub-types)" # can also include smaller areas of V1
ntypDF2$hovedgruppe[ntypDF2$Nature_type == "Kystlynghei"                                        ] <- "T34 | all"
ntypDF2$hovedgruppe[ntypDF2$Nature_type == "Lauveng"                                            ] <- "T32 | all (if including sub-types)"
ntypDF2$hovedgruppe[ntypDF2$Nature_type == "Nakent tørkeutsatt kalkberg"                        ] <- "T1  | calcareous and dry"
ntypDF2$hovedgruppe[ntypDF2$Nature_type == "Naturbeitemark"                                     ] <- "T32 | all (if including sub-types)"
ntypDF2$hovedgruppe[ntypDF2$Nature_type == "Øvre sandstrand uten pionervegetasjon"              ] <- "T29 | sandy and vegetated"
ntypDF2$hovedgruppe[ntypDF2$Nature_type == "Øyblandingsmyr"                                     ] <- "V1  | partial" # also includes V3
ntypDF2$hovedgruppe[ntypDF2$Nature_type == "Palsmyr"                                            ] <- "V3  | all (if including sub-types)"
ntypDF2$hovedgruppe[ntypDF2$Nature_type == "Platåhøymyr"                                        ] <- "V3  | all (if including sub-types)" # can also include smaller areas of V1
ntypDF2$hovedgruppe[ntypDF2$Nature_type == "Rik åpen jordvannsmyr i mellomboreal sone"          ] <- "V1  | calcareous"
ntypDF2$hovedgruppe[ntypDF2$Nature_type == "Rik åpen jordvannsmyr i nordboreal og lavalpin sone"] <- "V1  | calcareous"
ntypDF2$hovedgruppe[ntypDF2$Nature_type == "Rik åpen sørlig jordvannsmyr"                       ] <- "V1  | calcareous"
ntypDF2$hovedgruppe[ntypDF2$Nature_type == "Sanddynemark"                                       ] <- "T21 | all (if including sub-types)"
ntypDF2$hovedgruppe[ntypDF2$Nature_type == "Semi-naturlig eng"                                  ] <- "T32 | all (if including sub-types)"
# This might be called Kulturmarkseng in the 2018 protocol, but Semi-naturlig eng in the data set. 
# Kulturmarkseng also includes V10
ntypDF2$hovedgruppe[ntypDF2$Nature_type == "Semi-naturlig myr"                                  ] <- "V9  | all (if including sub-types)"
ntypDF2$hovedgruppe[ntypDF2$Nature_type == "Semi-naturlig strandeng"                            ] <- "T33 | all (-2018)" # could perhaps be used in 2018, but it's defined awkwardly
ntypDF2$hovedgruppe[ntypDF2$Nature_type == "Semi-naturlig våteng"                               ] <- "V10 | all (-2018)"
ntypDF2$hovedgruppe[ntypDF2$Nature_type == "Silt og leirskred"                                  ] <- "T17 | all (if including sub-types)"
ntypDF2$hovedgruppe[ntypDF2$Nature_type == "Slåttemark"                                         ] <- "T32 | all (if including sub-types)"
ntypDF2$hovedgruppe[ntypDF2$Nature_type == "Slåttemyr"                                          ] <- "V9  | all (if including sub-types)"
ntypDF2$hovedgruppe[ntypDF2$Nature_type == "Sørlig etablert sanddynemark"                       ] <- "T21 | all (if including sub-types)"
ntypDF2$hovedgruppe[ntypDF2$Nature_type == "Sørlig kaldkilde"                                   ] <- "V4  | southern"
ntypDF2$hovedgruppe[ntypDF2$Nature_type == "Sørlig nedbørsmyr"                                  ] <- "V3  | all (if including sub-types)"
ntypDF2$hovedgruppe[ntypDF2$Nature_type == "Sørlig slåttemyr"                                   ] <- "V9  | all (if including sub-types)"
ntypDF2$hovedgruppe[ntypDF2$Nature_type == "Strandeng"                                          ] <- "T12 | all (-2018)"
ntypDF2$hovedgruppe[ntypDF2$Nature_type == "Svært tørkeutsatt sørlig kalkberg"                  ] <- "T1  | calcareous and dry"
ntypDF2$hovedgruppe[ntypDF2$Nature_type == "Terrengdekkende myr"                                ] <- "V3  | all (if including sub-types)"
```

Split this new column in two.

```r
ntypDF2 <- ntypDF2 %>%
  tidyr::separate(col = hovedgruppe,
                  into = c("NiN_mainType", "NiN_mainTypeCoverage"),
                  #sep = "|",
                  remove=T,
                  extra = "merge"
              )
```

## Add NiN variables

Preparing the data:

```r
#Exclude non-relevant forest wetland types
dat2 <- dat[dat$naturtype %!in% excl_nt,]

# Melt data
dat2L <- tidyr::separate_rows(dat2, ninbeskrivelsesvariabler, sep=",")

# Split the code and the value into separate columns
dat2L <- tidyr::separate(dat2L, 
                              col = ninbeskrivelsesvariabler,
                              into = c("NiN_variable_code", "NiN_variable_value"),
                              sep = "_",
                              remove=F
                              )
#> Warning: Expected 2 pieces. Missing pieces filled with `NA`
#> in 1 rows [319462].
# One NA produced here, but I check it, and it's fine.

# Convert values to numeric. This causes some NA's which I will go through below
dat2L$NiN_variable_value <- as.numeric(dat2L$NiN_variable_value)
#> Warning: NAs introduced by coercion
```

Here are all the NiN variable codes:

```r
unique(sort(dat2L$NiN_variable_code))
#>  [1] "1AG-A-0"   "1AG-A-E"   "1AG-A-G"   "1AG-B"    
#>  [5] "1AG-C"     "1AR-C-L"   "3TO-BØ"    "3TO-HA"   
#>  [9] "3TO-HE"    "3TO-HK"    "3TO-HN"    "3TO-HP"   
#> [13] "3TO-PA"    "3TO-TE"    "4DL-S-0"   "4DL-SS-0" 
#> [17] "4TG-BL"    "4TG-EL"    "4TG-GF"    "4TL-BS"   
#> [21] "4TL-HE"    "4TL-HL"    "4TL-RB"    "4TL-SB"   
#> [25] "5AB-0"     "5AB-DO-TT" "5BY-0"     "6SE"      
#> [29] "6SO"       "7FA"       "7GR-GI"    "7JB-BA"   
#> [33] "7JB-BT"    "7JB-GJ"    "7JB-HT-SL" "7JB-HT-ST"
#> [37] "7JB-KU-BY" "7JB-KU-DE" "7JB-KU-MO" "7JB-KU-PI"
#> [41] "7RA-BH"    "7RA-SJ"    "7SD-0"     "7SD-NS"   
#> [45] "7SE"       "7TK"       "7VR-RI"    "LKMKI"    
#> [49] "LKMSP"     "PRAK"      "PRAM"      "PRH"      
#> [53] "PRHA"      "PRHT"      "PRKA"      "PRKU"     
#> [57] "PRMY"      "PRRL-CR"   "PRRL-DD"   "PRRL-EN"  
#> [61] "PRRL-NT"   "PRRL-VU"   "PRSE-KA"   "PRSE-PA"  
#> [65] "PRSE-SH"   "PRSL"      "PRTK"      "PRTO"     
#> [69] "PRVS"
```

Converting NiN_variable_value to numeric also introduced NA's for these categories: 

```r
sort(unique(dat2L$NiN_variable_code[is.na(dat2L$NiN_variable_value)]))
#>  [1] "4DL-S-0"   "4DL-SS-0"  "5AB-0"     "5BY-0"    
#>  [5] "7FA"       "7GR-GI"    "7JB-BA"    "7JB-BT"   
#>  [9] "7JB-GJ"    "7JB-KU-BY" "7JB-KU-DE" "7JB-KU-MO"
#> [13] "7JB-KU-PI" "7RA-SJ"    "7SD-0"     "7SD-NS"   
#> [17] "7SE"       "7TK"       "7VR-RI"    "LKMKI"    
#> [21] "LKMSP"     "PRH"       "PRVS"
```
When I now go through the variable codes separately I will also judge if these NA's are real, or if they for example should be coded as zeros or something. I will exclude variables that are part of the biodiversity assessment of the localities, since these are not assessed for localities that have a very poor condition (this bias is not possible to correct).

### 1AG-A (sjiktdekningsvariabler)
These are different variables describing the cover in different vegetation strata and/or species

* 1AG-A-0 = Total tre canopy cover
* 1AG-B = Total shrub cover
* 1AG-C = Total field layer cover
* 1AG-A-E = 'Overstandere'
* 1AG-A-G = 'gjenveksttrær'


### 1AR-C-L (Andel vedvekster i fletsjiktet)
A condition variable in some mire nature types

### 3TO (Torvmarksformer)
These are defining variables, and not part of the condition assessment.

```r
exclude <- c("3TO-BØ",
             "3TO-HA",
             "3TO-HE",
             "3TO-HK",
             "3TO-HN",
             "3TO-HP",
             "3TO-PA",
             "3TO-TE")
```


### 4DL (Coarse dead wood)
4DL-SS-0 and 4DL-S-0 has to do with the total amount of coarse woody debris/logs. It was only recorded for one nature type in 2018, and then as a a *biodiversity variable*, and not a state variable. 


```r
exclude <- c(exclude,
             "4DL-SS-0",
             "4DL-S-0")
```


### 4TG (old trees)
These three variables are used as *biodiversity variables* in  2018.

```r
exclude <- c(exclude,
             "4TG-BL",
             "4TG-EL",
             "4TG-GF")
```


### 4TL (trees with fire scars)
These five variables are used together with 4TG as *biodiversity variables* in 2018.

```r
exclude <- c(exclude,
             "4TL-BS",
             "4TL-HE",
             "4TL-HL",
             "4TL-RB",
             "4TL-SB")
```

### 5AB and 5BY (arealbruksklasser og byggningstyper)
These area land use types and building types, respectively, and the values are not numeric, but categorical, and represents presence or absence of these land uses or objects. These are not suited for automatically determining ecosystem condition as this is done subjectively in the field.

```r
exclude <- c(exclude,
             "5AB-0",
             "5AB-DO-TT",
             "5BY-0"
             )
```

### 6SE and 6SO (Bioclimatical sections and sones)
Not relevant here as condition variables.

```r
exclude <- c(exclude,
             "6SE",
             "6SO")
```

### 7FA (fremmedartsinnslag)
Should not have been allowed the value X, so Ok to keep these as NA.

### 7GR-GI
7GR-GI (grøftingsintensitet) should not have the value X either, so OK to exclude these NA's. But we keep the variable, even though its clearly a pressure indicator, we might want to use it as a surrogate for mire hydrology.


### 7JB-BA (Aktuell bruksintensitet)
A common condition/pressure variable in semi-natural nature types.

Overview of cases where the value is set as *X*.

```r
temp <- dat2L[dat2L$ninbeskrivelsesvariabler == "7JB-BA_X",]
table(temp$kartleggingsår, temp$naturtype)
#>       
#>        Eng-aktig sterkt endret fastmark Hagemark
#>   2018                                0        0
#>   2020                                1        0
#>   2021                                0        1
#>       
#>        Semi-naturlig eng Semi-naturlig strandeng Slåttemark
#>   2018                 0                       0          0
#>   2020                 0                       0          0
#>   2021                 1                       1          1
#>       
#>        Strandeng
#>   2018        27
#>   2020         0
#>   2021         0
```
These are just a few cases, mostly from 2018. OK to treat as NA.

### 7JB-BT (Beitetrykk)
Similar variable to the above.

```r
temp <- dat2L[dat2L$ninbeskrivelsesvariabler == "7JB-BT_X",]
table(temp$kartleggingsår, temp$naturtype)
#>       
#>        Åpen flomfastmark Kystlynghei Sanddynemark
#>   2019                 3           0            0
#>   2020                 1           1            2
#>   2021                 3           0            0
```
OK to treat X's as NA's.

### 7JB-GJ (Gjødsling)
Similar variable to the two above.

```r
temp <- dat2L[dat2L$ninbeskrivelsesvariabler == "7JB-BT_X",]
table(temp$kartleggingsår, temp$naturtype)
#>       
#>        Åpen flomfastmark Kystlynghei Sanddynemark
#>   2019                 3           0            0
#>   2020                 1           1            2
#>   2021                 3           0            0
```
OK to treat as X's NA's.

This variable is used as a condition indicator, but it is perhaps strictly speaking a pressure indicator. Secondly, many semi-natural areas were fertilized, also in the reference condition. The people that made the meadows would probably not agree that a productive field/meadow has poor condition. This condition variable is therefor more directly tuned towards the maintenance of biodiversity.


### 7JB-HT (Høsting av tresjiktet)
Used for *Lauveng* in 2019 and 2020.

```r
temp <- dat2L[dat2L$NiN_variable_code == "7JB-HT-ST" | 
               dat2L$NiN_variable_code == "7JB-HT-SL" ,]
table(temp$kartleggingsår, temp$naturtype)
#>       
#>        Lauveng
#>   2019      14
#>   2020       8
```
This is so marginal that I will exclude these already now.

```r
exclude <- c(exclude,
             "7JB-HT-SL",
             "7JB-HT-ST")
```

### 7JB-KU (Kystlyngheias utviklingsfaser)

* BY = byggefase
* DE = degenereringsfase
* MO = moden fase
* PI = pionerfase

This variable is used as in the *biodiversity assessment*, and can therefore not be used in the condition assessment because localities with *very poor* conditions have not been mapped/assessed.

```r
exclude <- c(exclude, 
             "7JB-KU-BY", 
             "7JB-KU-DE", 
             "7JB-KU-MO", 
             "7JB-KU-PI")
```

I will nonetheless explore this variable a bit more since this variable has been suggested previously as a condition variable.
NiN defines the possible values for these as numeric between 0 and 4 (shifted to become 1-5 in the data set), but there are 998 cases where it has been given then value *X*.

```r
temp <- dat2L[dat2L$ninbeskrivelsesvariabler == "7JB-KU-BY_X" |
                     dat2L$ninbeskrivelsesvariabler == "7JB-KU-DE_X" |
                dat2L$ninbeskrivelsesvariabler == "7JB-KU-MO_X" |
                     dat2L$ninbeskrivelsesvariabler == "7JB-KU-PI_X",]
table(temp$kartleggingsår, temp$naturtype)
#>       
#>        Kystlynghei
#>   2018         510
#>   2019         132
#>   2020          21
#>   2021         326
```

The reason could be that this variable is used in the biodiversity assessment, which is not performed if the condition is *very poor*, but the following table shows that the localities where this variable has been given the value X is spread across all condition scores: 

```r
table(temp$tilstand)
#> 
#>         Dårlig            God        Moderat Svært redusert 
#>            181             72            727              9
```

We can also make a note that a big proportion of the total number of localities of *Kystlynghei* had very poor (svært redusert) condition, and therefore this variable 7JB-KU was not recorded in a large proportion of the localities.

```r
KU <- dat2[dat2$naturtype=="Kystlynghei",]
barplot(table(KU$tilstand))
```

<div class="figure">
<img src="naturtype_files/figure-html/unnamed-chunk-56-1.png" alt="The distribution of condition scores for Kystlynghei." width="672" />
<p class="caption">(\#fig:unnamed-chunk-56)The distribution of condition scores for Kystlynghei.</p>
</div>

The percentage of localities with very poor condition is 23%.

Each *kystlynghei* locality should have values for all four parameters (7BA-BY/DE/MO/PI), but if we look at some cases in more detail, to understand why some of these values have been set as X (probably means they were left blank), for example like this:

```r
#View(dat2L[dat2L$NiN_variable_code == "7JB-KU-BY" & is.na(dat2L$NiN_variable_value),])
#View(dat2L[dat2L$identifikasjon_lokalid =="NINFP1810002975",]) # None of the 7JB-KU variables have values
#View(dat2L[dat2L$identifikasjon_lokalid =="NINFP2110057689",]) # Two of the 7JB-KU variables have values
```
 ... we can see that sometimes <4 but >0 of the variables/phases has been given a score, but sometimes none have. This makes it problematic to set these NA's to be zeros. 
 
For this variable to be used in as an indicator for Ecological Condition in the future, the variable needs to be assessed for all localities, and the field protocol and/or field app needs to be revised to that it is not possible to record blank or NA values.


### 7RA-BH and 7RA-SJ (rask suksesjon i boreal hei og i i semi-naturlig og sterkt endret jordbruksmark inkludert våteng)
Condition variables.
There are some very few cases where 7RA-SJ has the value X. It should be numeric 1-4, so the value X is a mistake here I think. We can exclude these (i.e. allow them to be NA's).

### 7SD-0 and 7SD- NS (Natur- og normalskogsdynamikk)
7SD-NS and 7SD-0 was also only used for only one nature type (which is not forest), and then only for wooded localities of *Flommyr, myrkant og myrskogsmark*. *X* therefore means *not relevant*, and we can also exclude the parameters from the dataset all together.


```r
exclude <- c(exclude, 
             "7SD-0",     
             "7SD-NS")
```

### 7TK and 7SE (kjørespor & slitasje)
7TK (kjørespor) and 7SE (slitasje) are not allowed the value X, but it happened on some rare occasions (24) anyhow. It's fine to treat these as NA's.

### 7VR-RI (Reguleringsintensitet)
This variable is defined as numeric between 1-5. There are, however, quite a few cases where it is X.

```r
temp <- dat2L[dat2L$ninbeskrivelsesvariabler == "7VR-RI_X",]
table(temp$kartleggingsår, temp$naturtype)
#>       
#>        Åpen flomfastmark
#>   2019                96
#>   2020                 1
#>   2021                11
```
I cannot explain these, but in any case, this variable is not a good indicator for condition as it rather represents a pressure/driver. So OK to treat as NA's.

*LKMs*  
LKM's (lokal kompleks miljøvariabel) are not relevant to us here.

### LKMKI
    + Kalk (lime)
    + Exclude

### LKMSP
    + Slåttemarkspreg
    + Exclude
    
*MdirPR-variables*
These are Miljødirektoratets own variables (usually variations on existing NiN-variables)

### PRAK
    + Antall NiN-kartleggingsenheter
    + Used in the biodiversity assessment
    + Exclude

### PRAM
    + Menneskeskapte objekter
    + Related to 5BY and 5AB
    + Exclude (see 5BY and 5AB)

### PRH
    + This is perhaps a mistake and should be PRHA or PRHT
    + Exclude

### PRHA
    + Habitat spesifikke arter
    + Used in the biodiversity assessment
    + Exclude

### PRHT
    + Høsting av tresjiktet

### PRKA
    + Kalkindikatorer
    + Used in the biodiversity assessment
    + Exclude

### PRKU
    + Kystlyngheias utviklingsfaser
    + Related to 7JB-KU
    + Used in the biodiversity assessment
    + Exclude

### PRMY
    + Myrstruktur
    + Used in the biodiversity assessment
    + Exclude

### PRRL-CR/DD/EN/NT/VU
    + Red list categories
    + Used in the biodiversity assessment
    + Exclude

### PRSE-KA
    + Strukturer, elementer og torvmarksformer (in 2018)
    + See PRSE-PA

### PRSE-PA
    + Strukturer, elementer og torvmarksformer
    + Used in the biodiversity assessment
    + Exclude

### PRSE-SH
    + Strukturer, elementer og torvmarksformer (in 2018)
    + See PRSE-PA

### PRSL
    + Slitasje
    + Related to 7SE
    
### PRTK
    + Spor av tunge kjøretøyer
    + Related to 7TK
    
### PRTO
    + Torvuttak
    + Strictly speaking a pressure variable

### PRVS
    + Variasjon i vannsprutintensitet
    + Used in the biodiversity assessment
    + Exclude


```r
exclude <- c(exclude,
             "LKMKI",     
          "LKMSP",
          "PRAK",
          "PRAM",
          "PRH",
          "PRHA",
          "PRKA",
          "PRKU",
          "PRMY",
          "PRRL-DD",   "PRRL-VU",   "PRRL-NT",   "PRRL-EN",   "PRRL-CR",  
          "PRSE-KA",
          "PRSE-PA",
          "PRSE-SH",
          "PRVS"
          )
```


## Subset

```r
# Exclude NAs
dat2L2 <- dat2L[!is.na(dat2L$NiN_variable_value),]

# Exclude selected NiN variables 
dat2L2 <- dat2L2[dat2L2$NiN_variable_code %!in% exclude,]
```
Now we are now down to 20 possible condition variables.

`dat2L2` includes only the three target ecosystems. Hule eiker are excluded. Mosaics are included. Several non-relevant NiN variables are excluded. The localities are duplicated in as many rows as there are NiN variables for that locality.

## Combine Naturetypes, NiN variables and  NiN main types


```r
ntyp_vars <- as.data.frame(table(dat2L2$naturtype, dat2L2$NiN_variable_code))
names(ntyp_vars) <- c("Nature_type", "NiN_variable_code", "NiN_variable_count")
ntyp_vars <- ntyp_vars[ntyp_vars$NiN_variable_count >0,]
head(ntyp_vars)
#>                                          Nature_type
#> 3   Åpen grunnlendt kalkrik mark i boreonemoral sone
#> 16                                          Hagemark
#> 28                                    Naturbeitemark
#> 69                                          Hagemark
#> 79                                           Lauveng
#> 144                                Semi-naturlig myr
#>     NiN_variable_code NiN_variable_count
#> 3             1AG-A-0                 41
#> 16            1AG-A-0                348
#> 28            1AG-A-0                  1
#> 69            1AG-A-E               1445
#> 79            1AG-A-E                 11
#> 144           1AG-A-G                693
```

Add a column for the total number of localities for each nature type and get the percentage of localities where each NiN main type has been recorded.

```r
#options(scipen=999) # suppress exp notation
count <- as.data.frame(table(dat2$naturtype))
names(count) <- c("Nature_type", "totalLocations")
ntyp_vars$totalLocations <- count$totalLocations[match(ntyp_vars$Nature_type, count$Nature_type)]
ntyp_vars$percentageUse <- round((ntyp_vars$NiN_variable_count/ntyp_vars$totalLocations)*100, 1)
```

Cast to get NiN codes as columns

```r
# should switch to pivot_wider
ntyp_vars_wide <- data.table::dcast(setDT(ntyp_vars),
                                    Nature_type~NiN_variable_code,
                                    value.var = "percentageUse")
```

This data set contains the nature types that were only mapped in 2018 or 2019, and which we removed from ntypDF2. Let's exclude these nature types now

```r
ntyp_vars_wide <- ntyp_vars_wide[ntyp_vars_wide$Nature_type %in% ntypDF2$Nature_type]
```

Combine datasets

```r
ntyp_fill <- cbind(ntypDF2, ntyp_vars_wide[,-1][match(ntypDF2$Nature_type, ntyp_vars_wide$Nature_type)])
```


### Add number of location and total area mapped

```r
dat2$km2 <- units::drop_units(dat2$area/10^6)

num <- as.data.frame(dat2) %>%
  group_by(naturtype)%>%
  summarise(km2 = sum(km2),
            numberOfLocalities = n())

ntyp_fill <- cbind(ntyp_fill, num[,-1][match(ntyp_fill$Nature_type, num$naturtype),])
```



## Plots

### The total mapped area

```r

mySize <- 8
gg_area <- ntyp_fill %>%
  arrange(km2) %>%
  mutate(Nature_type=factor(Nature_type, levels=Nature_type)) %>%   # This trick update the factor levels
  ggplot( aes(x = Nature_type,
                   y = km2)) +
        geom_segment( aes(xend=Nature_type, yend=0)) +
        geom_point( size=4, aes(group = Ecosystem,
                                colour= Ecosystem)) +
        coord_flip() +
        theme_bw(base_size = mySize) +
        xlab("")+
        ylab(expression(km^2))+
      theme(legend.position = "top",
        legend.key.size =  unit(.05, 'cm'),
            legend.background = element_rect(fill = "white", color = "black")
            )

gg_locs <- ntyp_fill %>%
  arrange(km2) %>%
  mutate(Nature_type=factor(Nature_type, levels=Nature_type)) %>%    # also sorted after km2
  ggplot( aes(x = Nature_type,
                   y = numberOfLocalities)) +
        geom_segment( aes(xend=Nature_type, yend=0)) +
        geom_point( size=4, aes(group = Ecosystem,
                                colour= Ecosystem)) +
        coord_flip() +
        theme_bw(base_size = mySize) +
        xlab("")+
        ylab("Number of localities")+
  theme(legend.position = "none",
        axis.text.y = element_blank())


egg::ggarrange(gg_area, gg_locs, 
                        ncol = 2)
```

<div class="figure">
<img src="naturtype_files/figure-html/unnamed-chunk-68-1.png" alt="The total mapped area for nature types associated with three selected main ecosystems" width="672" />
<p class="caption">(\#fig:unnamed-chunk-68)The total mapped area for nature types associated with three selected main ecosystems</p>
</div>

### Area of localities per NiN main type
First I will add the NiN main types that are not covered by any nature types.


```r
open <- c(
  "T1",
  "T2",
  "T6",
  "T8",
  "T11",
  "T12",
  "T13",
  "T15",
  "T16",
  "T17",
  "T18",
  "T20",
  "T21",
  "T23",
  "T24",
  "T25",
  "T26",
  "T27",
  "T29"
)

semi <- c(
  "T31",
  "T32",
  "T33",
  "T34",
  "T40",  # are these included
  "T41"   # are these included
)

wetland <- c(
  "V1",
  "V3",
  "V4",
  "V6",
  "V9",
  "V10",
  "L4"    # this will probably not be part of the assessments
  
)
```

Adding the non-mapped open types

```r
open[open %!in% ntyp_fill$NiN_mainType]
#> [1] "T6"  "T11" "T13" "T16" "T23" "T24" "T25" "T26" "T27"
```


```r
ntyp_fill2 <- ntyp_fill %>%
  add_row(NiN_mainType = "T6", Ecosystem = "Naturlig åpne områder under skoggrensa", NiN_mainTypeCoverage = "Not mapped", km2 = 0) %>%
  add_row(NiN_mainType = "T11", Ecosystem = "Naturlig åpne områder under skoggrensa", NiN_mainTypeCoverage = "Not mapped", km2 = 0) %>%
  add_row(NiN_mainType = "T13", Ecosystem = "Naturlig åpne områder under skoggrensa", NiN_mainTypeCoverage = "Not mapped", km2 = 0) %>%
  add_row(NiN_mainType = "T16", Ecosystem = "Naturlig åpne områder under skoggrensa", NiN_mainTypeCoverage = "Not mapped", km2 = 0) %>%
  add_row(NiN_mainType = "T23", Ecosystem = "Naturlig åpne områder under skoggrensa", NiN_mainTypeCoverage = "Not mapped", km2 = 0) %>%
  add_row(NiN_mainType = "T24", Ecosystem = "Naturlig åpne områder under skoggrensa", NiN_mainTypeCoverage = "Not mapped", km2 = 0) %>%
  add_row(NiN_mainType = "T25", Ecosystem = "Naturlig åpne områder under skoggrensa", NiN_mainTypeCoverage = "Not mapped", km2 = 0) %>%
  add_row(NiN_mainType = "T26", Ecosystem = "Naturlig åpne områder under skoggrensa", NiN_mainTypeCoverage = "Not mapped", km2 = 0) %>%
  add_row(NiN_mainType = "T27", Ecosystem = "Naturlig åpne områder under skoggrensa", NiN_mainTypeCoverage = "Not mapped", km2 = 0) 
```


Adding the non-mapped semi-natural types

```r
semi[semi %!in% ntyp_fill$NiN_mainType]
#> [1] "T40"
```

```r
ntyp_fill2 <- ntyp_fill2 %>%
  add_row(NiN_mainType = "T40", Ecosystem = "Semi-naturlig mark", NiN_mainTypeCoverage = "Not mapped", km2 = 0)
```


Adding the non-mapped wetland types

```r
wetland[wetland %!in% ntyp_fill$NiN_mainType]
#> [1] "V6"
```
V6 is *Våtsnøleie*, and my guess is that it *is* mapped, but grouped with the alpine ecosystem. I'll therefore not add it in here, but mention it in the figure caption below.


```r
mySize <- 10
ntyp_fill2 %>%
  # combining two classes to get a better colour palette
  mutate(NiN_mainTypeCoverage = 
           replace(NiN_mainTypeCoverage, NiN_mainTypeCoverage == "southern", "partial"),
         NiN_mainTypeCoverage = 
           replace(NiN_mainTypeCoverage, NiN_mainTypeCoverage == "calcareous and dry", "calcareous")) %>%
  
  group_by(NiN_mainType, NiN_mainTypeCoverage) %>%
  mutate(km2 = sum(km2)) %>%
  slice_head()%>%
  select(Ecosystem,
         NiN_mainType,
         NiN_mainTypeCoverage,
         km2)%>%
  ungroup() %>%
  mutate(NiN_mainType = forcats::fct_reorder(NiN_mainType, km2)) %>%
  ggplot(aes(x = NiN_mainType,
             y = km2,
             fill = NiN_mainTypeCoverage))+
    geom_bar(stat = "identity",
             colour = "grey40",
             position = "stack")+
    theme_bw(base_size = mySize)+
    coord_flip()+
  labs(x = "NiN main type",
       y = expression(km^2),
       fill = "Spatial coverage")+
  scale_fill_brewer(palette = "Set1")+
  facet_wrap(vars(Ecosystem),
             scales = "free",
             labeller = label_wrap_gen(width=25))
```

<div class="figure">
<img src="naturtype_files/figure-html/unnamed-chunk-75-1.png" alt="The areas mapped for each NiN main type, and the degree of spatial representativity (or coverage) of the mapping units (nature types). V6 Våtsnøleie og snøleiekilde is not included." width="672" />
<p class="caption">(\#fig:unnamed-chunk-75)The areas mapped for each NiN main type, and the degree of spatial representativity (or coverage) of the mapping units (nature types). V6 Våtsnøleie og snøleiekilde is not included.</p>
</div>

### Number of localities per NiN main type



```r
mySize <- 10
ntyp_fill2 %>%
  # combining two classes to get a better colour palette
  mutate(NiN_mainTypeCoverage = 
           replace(NiN_mainTypeCoverage, NiN_mainTypeCoverage == "southern", "partial"),
         NiN_mainTypeCoverage = 
           replace(NiN_mainTypeCoverage, NiN_mainTypeCoverage == "calcareous and dry", "calcareous")) %>%
  
  group_by(NiN_mainType, NiN_mainTypeCoverage) %>%
  mutate(count = sum(numberOfLocalities)) %>%
  slice_head()%>%
  select(Ecosystem,
         NiN_mainType,
         NiN_mainTypeCoverage,
         count)%>%
  ungroup() %>%
  mutate(NiN_mainType = fct_reorder(NiN_mainType, count)) %>%
  ggplot(aes(x = NiN_mainType,
             y = count,
             fill = NiN_mainTypeCoverage))+
    geom_bar(stat = "identity",
             colour = "grey40",
             position = "stack")+
    theme_bw(base_size = mySize)+
    coord_flip()+
  labs(x = "NiN main type",
       y = "Number of localities",
       fill = "Spatial coverage")+
  scale_fill_brewer(palette = "Set1")+
  facet_wrap(vars(Ecosystem),
             scales = "free",
             labeller = label_wrap_gen(width=25))
#> Warning: Removed 10 rows containing missing values
#> (position_stack).
```

<div class="figure">
<img src="naturtype_files/figure-html/unnamed-chunk-76-1.png" alt="The number of localities mapped for each NiN main type, and the degree of spatial representativity (or coverage) of the mapping units (nature types). V6 Våtsnøleie og snøleiekilde is not included. NiN main types are arranged rougly by decreasing order, except for types that are not mapped at all, which are arranged on top." width="672" />
<p class="caption">(\#fig:unnamed-chunk-76)The number of localities mapped for each NiN main type, and the degree of spatial representativity (or coverage) of the mapping units (nature types). V6 Våtsnøleie og snøleiekilde is not included. NiN main types are arranged rougly by decreasing order, except for types that are not mapped at all, which are arranged on top.</p>
</div>


From the figure above I take that *Naturlig åpne områder* is very poorly represented in general as there are many NiN main types that are completely missing from the dataset. The three most common types by area, however, have complete thematic coverage (if excluding the year 2018 and including all sub-types). I will need to investigate especially if there are some NiN variables for the nature types mapping T18 Åpen flomfastmark, T12 Strandeng and T21 Sanddynemark which we can use. 

For *Semi-naturlig mark* we have quite good thematic coverage for the three main types (by area). The other three types probably makes up a considerably smaller area, but note that T33 has some coverage, and is classes as *all (-2018)*. Of the three main ecosystems, semi-naturlig mark dominates clearly in ters of area and in terms of number of localities. 

For *Våtmark* we have good thematic coverage for V3 nedbørsmyr and V9 semi-naturlig myr, but for V1 åpen jordvassmyr only calcareous localities are mapped and assessed. A question is then whether, for a given NiN variable, that calcareous localities can be representative for all mires (poor and rich) or if this will introduce too much bias in one way or another. Another important bias for this main ecosystem is related to the lower size limit for mapping units (MMU), which is quite big for V3. We need to think about whether small bogs are more or less prone to different pressures compared to big bogs.

### Commonness of NiN variables

I want to see how common the different NiN variables are, and if we can use this to select core variables (kjernevariabler).

First I will get the total area mappe per main ecosystem

```r
areaSum <- ntyp_fill2 %>%
  group_by(Ecosystem) %>%
  summarise(km2 = sum(km2)) %>%
  tibble::add_column(.before=1,
                     NiN_code = rep("Combined", 3))
```


```r
ntyp_fill2 %>%
  pivot_longer(cols = unique(ntyp_vars$NiN_variable_code)) %>%
  drop_na(value) %>%
  rename(NiN_code = name,
         useFrequency = value) %>%
  filter(useFrequency > 0) %>%
  group_by(NiN_code, Ecosystem, NiN_mainType) %>%  # NiN main type could be replaced with Nature_type
  summarise(km2 = sum(km2)) %>%
  
  # create a truncated fill variable 
  group_by(Ecosystem) %>%
  mutate(myFill = fct_lump(NiN_mainType, 3, w = km2)) %>%
  
  # qick fix to sort variable across facets (dont work after adding 'Nature_type' in the first group_by)
  #mutate(lab = paste(NiN_code, substr(Ecosystem, start = 1, stop = 1), sep = " ")) %>%
  #ungroup()%>%
  #mutate(lab = forcats::fct_reorder(lab, km2)) %>%
  
  
  # plot
  ggplot(aes(x = NiN_code,
              y = km2,
             fill = myFill
                ))+
  geom_bar(stat = "identity",
           colour = "grey40",
           #fill = "grey80",
           position = "stack")+
  geom_hline(data = areaSum,
             aes(yintercept = km2),
             colour = "red",
             linetype = "dashed")+
  facet_wrap(vars(Ecosystem),
             scales = "free",
             labeller = label_wrap_gen(width=25))+
  labs(x = "",
       y = expression(km^2),
       fill = "")+
  coord_flip()+
  scale_fill_brewer(palette = "Set1")+
  theme_bw(base_size = mySize)
#> `summarise()` has grouped output by 'NiN_code', 'Ecosystem'. You can override using the `.groups` argument.
#> Warning in RColorBrewer::brewer.pal(n, pal): n too large, allowed maximum for palette Set1 is 9
#> Returning the palette you asked for with that many colors
```

<div class="figure">
<img src="naturtype_files/figure-html/unnamed-chunk-78-1.png" alt="Barplot showing the proportion area for which each NiN variable is recorded. The total mapped area for each main ecosystem (the facets) is shown as a dashed red line. The three most dominant NiN main types for each ecosystem is given a uniqe colour, and all the remaining are grouped as 'other'." width="672" />
<p class="caption">(\#fig:unnamed-chunk-78)Barplot showing the proportion area for which each NiN variable is recorded. The total mapped area for each main ecosystem (the facets) is shown as a dashed red line. The three most dominant NiN main types for each ecosystem is given a uniqe colour, and all the remaining are grouped as 'other'.</p>
</div>

This figure, in combination with the above, points to he most obvious NiN variable candidates. 

7SE and 7TK are good candidates for *Naturlig åpne områder*. 7JA-BT is probably more appropriately classed as a pressure indicator. Same with 7VR-RI with is recorded for all T18 localities. 

The same two variables (7SE and 7TK) are the best candidates also for *Semi-natural areas*. 7JB-BT is a pressure variable (*beitetrykk*). 7RA-SJ/BH are related to *gjengoing* which will be covered by another indicator informed from remote sensing (LiDAR), and we therefor don't need to describe this with a field-based indicator as well.

For *Våtmark*, 7GR-Gi is the most common variables, but this is a pressure variable (*grøfting*). But, perhaps it could be used as a surrogate indicator. I think this is justifiable, especially since the relationship between the pressure (grøfting) and the condition (hydrology) is so well known. 7SE+PRSL and 7TK+PRTK are other good candidates. PRTO is only relevant for V3, but covers a relatively large area. It is, however,, more like a pressure indicator.


## Tables
Here are some output tables with numbers the numbers underlying the above figures. 


```r
DT::datatable(ntyp_fill2,
              #extensions = "FixedColumns",
  options = list(
    scrollX = T,
    scrollY=T,
    pageLength = 10))
```

<div class="figure">

```{=html}
<div id="htmlwidget-66fb2299fbbd3370fa78" style="width:100%;height:auto;" class="datatables html-widget"></div>
<script type="application/json" data-for="htmlwidget-66fb2299fbbd3370fa78">{"x":{"filter":"none","vertical":false,"data":[["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54"],["Slåttemark","Kystlynghei","Naturbeitemark","Slåttemyr","Boreal hei","Semi-naturlig eng","Platåhøymyr","Strandeng","Hagemark","Semi-naturlig våteng","Eksentrisk høymyr","Rik åpen jordvannsmyr i mellomboreal sone","Sørlig slåttemyr","Terrengdekkende myr","Semi-naturlig myr","Åpen flomfastmark","Svært tørkeutsatt sørlig kalkberg","Isinnfrysingsmark","Eng-aktig sterkt endret fastmark","Høgereligende og nordlig nedbørsmyr","Øyblandingsmyr","Semi-naturlig strandeng","Lauveng","Kalkrik helofyttsump","Sørlig nedbørsmyr","Rik åpen sørlig jordvannsmyr","Fossepåvirket berg","Aktiv skredmark","Palsmyr","Silt og leirskred","Nakent tørkeutsatt kalkberg","Sørlig kaldkilde","Åpen grunnlendt kalkrik mark i boreonemoral sone","Sørlig etablert sanddynemark","Atlantisk høymyr","Rik åpen jordvannsmyr i nordboreal og lavalpin sone","Sanddynemark","Åpen grunnlendt kalkrik mark i sørboreal sone","Fuglefjell-eng og fugletopp","Fosseberg","Kanthøymyr","Fosse-eng","Øvre sandstrand uten pionervegetasjon","Konsentrisk høymyr",null,null,null,null,null,null,null,null,null,null],["2018, 2019, 2020, 2021","2018, 2019, 2020, 2021","2018, 2019, 2020, 2021","2018, 2019, 2020, 2021","2018, 2019, 2020, 2021","2018, 2019, 2020, 2021","2019, 2020, 2021","2018, 2019, 2020, 2021","2018, 2019, 2020, 2021","2018, 2019, 2020, 2021","2019, 2020, 2021","2019, 2020, 2021","2019, 2020, 2021","2019, 2020, 2021","2019, 2020, 2021","2018, 2019, 2020, 2021","2019, 2020, 2021","2018, 2019, 2020, 2021","2018, 2019, 2020, 2021","2019, 2020, 2021","2019, 2020, 2021","2018, 2019, 2020, 2021","2019, 2020","2019, 2020, 2021","2019, 2020, 2021","2018, 2019, 2020, 2021","2019, 2020, 2021","2019, 2020, 2021","2021","2019, 2020, 2021","2018, 2019, 2020, 2021","2018, 2019, 2020, 2021","2018, 2019, 2020, 2021","2018, 2019, 2020, 2021","2019, 2020, 2021","2018, 2019, 2020, 2021","2018, 2019, 2020, 2021","2019, 2020, 2021","2019, 2020, 2021","2021","2019, 2020, 2021","2019, 2020","2019, 2020, 2021","2019, 2020",null,null,null,null,null,null,null,null,null,null],["Semi-naturlig mark","Semi-naturlig mark","Semi-naturlig mark","Våtmark","Semi-naturlig mark","Semi-naturlig mark","Våtmark","Naturlig åpne områder under skoggrensa","Semi-naturlig mark","Våtmark","Våtmark","Våtmark","Våtmark","Våtmark","Våtmark","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Semi-naturlig mark","Våtmark","Våtmark","Semi-naturlig mark","Semi-naturlig mark","Våtmark","Våtmark","Våtmark","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Våtmark","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Våtmark","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Våtmark","Våtmark","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Våtmark","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Våtmark","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Semi-naturlig mark"],["T32","T34","T32","V9","T31","T32","V3","T12","T32","V10","V3","V1","V9","V3","V9","T18","T1","T20","T41","V3","V1","T33","T32","L4","V3","V1","T1","T17","V3","T17","T1","V4","T2","T21","V3","V1","T21","T2","T8","T1","V3","T15","T29","V3","T6","T11","T13","T16","T23","T24","T25","T26","T27","T40"],["all (if including sub-types)","all","all (if including sub-types)","all (if including sub-types)","all","all (if including sub-types)","all (if including sub-types)","all (-2018)","all (if including sub-types)","all (-2018)","all (if including sub-types)","calcareous","all (if including sub-types)","all (if including sub-types)","all (if including sub-types)","all","calcareous and dry","all","all","all (if including sub-types)","partial","all (-2018)","all (if including sub-types)","calcareous","all (if including sub-types)","calcareous","extra wet","all (if including sub-types)","all (if including sub-types)","all (if including sub-types)","calcareous and dry","southern","calcareous","all (if including sub-types)","all (if including sub-types)","calcareous","all (if including sub-types)","calcareous","all","extra wet","all (if including sub-types)","all","sandy and vegetated","all (if including sub-types)","Not mapped","Not mapped","Not mapped","Not mapped","Not mapped","Not mapped","Not mapped","Not mapped","Not mapped","Not mapped"],[null,null,0,null,null,null,null,null,19.4,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,9.3,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],[null,null,null,null,null,null,null,null,80.5,null,null,null,null,null,null,null,null,null,null,null,null,null,100,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],[null,null,null,100,null,null,null,null,null,null,null,null,100,null,100,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],[null,null,null,100,null,null,null,null,null,null,null,null,100,null,100,null,null,null,null,null,null,null,null,100,null,null,null,null,null,null,null,null,99.5,null,null,null,null,100,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],[null,null,0,null,null,null,null,null,19.3,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],[null,null,null,42.6,null,null,null,null,null,null,null,null,39.1,null,36.5,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],[99.7,99.9,99.9,7.4,100,99.9,null,99.9,99.9,99.8,null,100,null,null,null,66.6,100,null,100,null,null,98.9,100,100,null,100,null,null,null,null,100,null,99.8,100,null,5.5,100,100,null,null,null,null,100,null,null,null,null,null,null,null,null,null,null,null],[null,null,null,99.8,null,null,100,null,null,null,100,100,100,100,100,null,null,null,null,99.7,100,null,null,100,100,98.9,null,null,100,null,null,98.4,null,null,100,94.5,null,null,null,null,100,null,null,100,null,null,null,null,null,null,null,null,null,null],[99.9,null,100,null,null,99.9,null,2.5,100,100,null,null,null,null,null,null,null,null,99.8,null,null,98.7,100,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],[null,99.9,null,null,100,null,null,null,null,null,null,null,null,null,null,86.5,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,100,null,null,98.9,null,100,null,null,100,100,null,null,null,null,null,null,null,null,null,null,null],[98.5,null,99.7,null,null,99.2,null,null,99.8,99.7,null,null,null,null,null,null,null,null,99.3,null,null,null,100,null,null,null,null,null,null,null,null,null,null,100,null,null,98.9,null,null,null,null,null,100,null,null,null,null,null,null,null,null,null,null,null],[null,0,null,null,100,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],[99.9,99.9,100,null,null,99.9,null,1.8,99.9,100,null,null,null,null,null,null,null,null,99.3,null,null,98.6,100,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],[null,45.2,null,7.4,32.4,null,100,99.9,null,null,100,100,null,100,null,86.7,100,88.9,99.5,99.7,100,15.8,null,null,100,100,100,null,100,null,100,9.4,99.5,100,100,100,100,100,100,null,100,100,100,100,null,null,null,null,null,null,null,null,null,null],[null,54.2,null,100,67.4,null,null,99.9,null,null,null,null,100,null,100,86.6,null,88.9,null,null,null,null,null,100,null,17.4,null,100,null,100,14.6,null,99.5,100,null,5.5,100,100,null,null,null,100,100,null,null,null,null,null,null,null,null,null,null,null],[null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,93,null,null,null,null,null,null,null,null,null,null,100,null,null,null,null,null,null,null,null,null,null,null,null,100,null,100,null,null,null,null,null,null,null,null,null,null,null,null],[null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,100,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],[null,null,null,92.6,null,null,null,null,null,null,null,null,100,null,100,null,null,null,null,null,null,83.2,null,100,null,null,null,null,null,null,null,90.6,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],[null,null,null,null,null,null,100,null,null,null,100,100,null,100,null,null,null,null,null,99.7,100,null,null,null,100,82.6,null,null,100,null,null,null,null,null,100,94.5,null,null,null,null,100,null,null,100,null,null,null,null,null,null,null,null,null,null],[null,null,null,null,null,null,100,null,null,null,100,null,null,100,null,null,null,null,null,99.7,null,null,null,null,100,null,null,null,null,null,null,null,null,null,100,null,null,null,null,null,100,null,null,100,null,null,null,null,null,null,null,null,null,null],[6.81956356593571,446.638733529904,108.83795146733,8.94881563070796,311.179910500879,25.6749258232426,3.64513842004613,4.18015991464149,13.9306785922215,4.99997030545661,5.40129720245494,6.67459600985544,0.849630753543558,16.951171252332,6.97532795463438,10.2576622102261,0.0939286599663424,0.0172138593255082,1.1136383496571,12.3792368582634,4.23571529897774,3.40471202718152,0.0276215101012527,1.9365690032333,12.3314095299565,4.41543153836709,0.0459278897347861,0.405816768116717,1.30286814519671,0.022958446379465,1.48426109399653,0.0528799856375842,0.68576061110412,0.333717528775667,3.32734000458103,0.212262234086063,1.89650385103741,0.156271240033891,0.248655085415105,0.00792215845906082,0.109073191077505,0.00237313203080123,0.0165918400637099,0.35986377082405,0,0,0,0,0,0,0,0,0,0],[1577,7444,9657,554,4887,3402,73,1376,1796,1000,106,797,133,326,693,1554,74,9,565,361,189,935,11,250,766,755,21,155,38,37,342,127,440,55,85,55,284,124,20,11,17,3,19,9,null,null,null,null,null,null,null,null,null,null]],"container":"<table class=\"display\">\n  <thead>\n    <tr>\n      <th> <\/th>\n      <th>Nature_type<\/th>\n      <th>Year<\/th>\n      <th>Ecosystem<\/th>\n      <th>NiN_mainType<\/th>\n      <th>NiN_mainTypeCoverage<\/th>\n      <th>1AG-A-0<\/th>\n      <th>1AG-A-E<\/th>\n      <th>1AG-A-G<\/th>\n      <th>1AG-B<\/th>\n      <th>1AG-C<\/th>\n      <th>1AR-C-L<\/th>\n      <th>7FA<\/th>\n      <th>7GR-GI<\/th>\n      <th>7JB-BA<\/th>\n      <th>7JB-BT<\/th>\n      <th>7JB-GJ<\/th>\n      <th>7RA-BH<\/th>\n      <th>7RA-SJ<\/th>\n      <th>7SE<\/th>\n      <th>7TK<\/th>\n      <th>7VR-RI<\/th>\n      <th>PRHT<\/th>\n      <th>PRSL<\/th>\n      <th>PRTK<\/th>\n      <th>PRTO<\/th>\n      <th>km2<\/th>\n      <th>numberOfLocalities<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"scrollX":true,"scrollY":true,"pageLength":10,"columnDefs":[{"className":"dt-right","targets":[6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27]},{"orderable":false,"targets":0}],"order":[],"autoWidth":false,"orderClasses":false}},"evals":[],"jsHooks":[]}</script>
```

<p class="caption">(\#fig:unnamed-chunk-79)List of 45 nature types additionam data, including the proportion of localities for which there is data for each of the NiN variables.</p>
</div>


```r
DT::datatable(
  ntyp_fill2 %>%
  pivot_longer(cols = unique(ntyp_vars$NiN_variable_code)) %>%
  drop_na(value) %>%
  rename(NiN_code = name,
         useFrequency = value) %>%
  filter(useFrequency > 0) %>%
  group_by(NiN_code, Ecosystem, NiN_mainType) %>%  # NiN main type could be replaced with Nature_type
  summarise(km2 = sum(km2)),
  options = list(
    scrollX = T,
    scrollY=T,
    pageLength = 10))
#> `summarise()` has grouped output by 'NiN_code', 'Ecosystem'. You can override using the `.groups` argument.
```

<div class="figure">

```{=html}
<div id="htmlwidget-8cc8ee20485b438bc757" style="width:100%;height:auto;" class="datatables html-widget"></div>
<script type="application/json" data-for="htmlwidget-8cc8ee20485b438bc757">{"x":{"filter":"none","vertical":false,"data":[["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59","60","61","62","63","64","65","66","67","68","69","70","71","72","73","74","75","76","77","78","79","80","81","82","83","84","85","86","87","88","89","90","91","92","93","94","95"],["1AG-A-0","1AG-A-0","1AG-A-E","1AG-A-G","1AG-B","1AG-B","1AG-B","1AG-C","1AR-C-L","7FA","7FA","7FA","7FA","7FA","7FA","7FA","7FA","7FA","7FA","7FA","7FA","7FA","7FA","7FA","7GR-GI","7GR-GI","7GR-GI","7GR-GI","7GR-GI","7JB-BA","7JB-BA","7JB-BA","7JB-BA","7JB-BA","7JB-BT","7JB-BT","7JB-BT","7JB-BT","7JB-BT","7JB-BT","7JB-BT","7JB-GJ","7JB-GJ","7JB-GJ","7JB-GJ","7JB-GJ","7RA-BH","7RA-SJ","7RA-SJ","7RA-SJ","7RA-SJ","7RA-SJ","7RA-SJ","7SE","7SE","7SE","7SE","7SE","7SE","7SE","7SE","7SE","7SE","7SE","7SE","7SE","7SE","7SE","7SE","7SE","7TK","7TK","7TK","7TK","7TK","7TK","7TK","7TK","7TK","7TK","7TK","7TK","7TK","7TK","7VR-RI","7VR-RI","7VR-RI","PRHT","PRSL","PRSL","PRSL","PRSL","PRTK","PRTK","PRTO"],["Naturlig åpne områder under skoggrensa","Semi-naturlig mark","Semi-naturlig mark","Våtmark","Naturlig åpne områder under skoggrensa","Våtmark","Våtmark","Semi-naturlig mark","Våtmark","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Semi-naturlig mark","Semi-naturlig mark","Semi-naturlig mark","Semi-naturlig mark","Semi-naturlig mark","Våtmark","Våtmark","Våtmark","Våtmark","Våtmark","Våtmark","Våtmark","Våtmark","Våtmark","Naturlig åpne områder under skoggrensa","Semi-naturlig mark","Semi-naturlig mark","Semi-naturlig mark","Våtmark","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Semi-naturlig mark","Semi-naturlig mark","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Semi-naturlig mark","Semi-naturlig mark","Våtmark","Semi-naturlig mark","Naturlig åpne områder under skoggrensa","Semi-naturlig mark","Semi-naturlig mark","Semi-naturlig mark","Semi-naturlig mark","Våtmark","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Semi-naturlig mark","Semi-naturlig mark","Semi-naturlig mark","Semi-naturlig mark","Våtmark","Våtmark","Våtmark","Våtmark","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Semi-naturlig mark","Semi-naturlig mark","Våtmark","Våtmark","Våtmark","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Semi-naturlig mark","Semi-naturlig mark","Våtmark","Våtmark","Våtmark","Våtmark","Våtmark","Våtmark"],["T2","T32","T32","V9","T2","L4","V9","T32","V9","T1","T12","T18","T2","T21","T29","T31","T32","T33","T34","T41","L4","V1","V10","V9","L4","V1","V3","V4","V9","T12","T32","T33","T41","V10","T15","T18","T21","T29","T8","T31","T34","T21","T29","T32","T41","V10","T31","T12","T32","T33","T34","T41","V10","T1","T12","T15","T18","T2","T20","T21","T29","T8","T31","T33","T34","T41","V1","V3","V4","V9","T1","T12","T15","T17","T18","T2","T20","T21","T29","T31","T34","L4","V1","V9","T1","T15","T18","T32","T33","L4","V4","V9","V1","V3","V3"],[0.68576061110412,13.9306785922215,13.9583001023227,16.7737743388859,0.842031851138011,1.9365690032333,16.7737743388859,13.9306785922215,16.7737743388859,1.57818975396287,4.18015991464149,10.2576622102261,0.842031851138011,2.23022137981308,0.0165918400637099,311.179910500879,155.290740958831,3.40471202718152,446.638733529904,1.1136383496571,1.9365690032333,11.3022897823086,4.99997030545661,8.94881563070796,1.9365690032333,15.5380050812863,55.8073983747322,0.0528799856375842,16.7737743388859,4.18015991464149,155.290740958831,3.40471202718152,1.1136383496571,4.99997030545661,0.00237313203080123,10.2576622102261,2.23022137981308,0.0165918400637099,0.248655085415105,311.179910500879,446.638733529904,2.23022137981308,0.0165918400637099,155.290740958831,1.1136383496571,4.99997030545661,311.179910500879,4.18015991464149,155.290740958831,3.40471202718152,446.638733529904,1.1136383496571,4.99997030545661,1.62411764369765,4.18015991464149,0.00237313203080123,10.2576622102261,0.842031851138011,0.0172138593255082,2.23022137981308,0.0165918400637099,0.248655085415105,311.179910500879,3.40471202718152,446.638733529904,1.1136383496571,15.5380050812863,55.8073983747322,0.0528799856375842,8.94881563070796,1.48426109399653,4.18015991464149,0.00237313203080123,0.428775214496182,10.2576622102261,0.842031851138011,0.0172138593255082,2.23022137981308,0.0165918400637099,311.179910500879,446.638733529904,1.9365690032333,4.62769377245315,16.7737743388859,0.0538500481938469,0.00237313203080123,10.2576622102261,0.0276215101012527,3.40471202718152,1.9365690032333,0.0528799856375842,16.7737743388859,15.5380050812863,55.8073983747322,54.5045302295355]],"container":"<table class=\"display\">\n  <thead>\n    <tr>\n      <th> <\/th>\n      <th>NiN_code<\/th>\n      <th>Ecosystem<\/th>\n      <th>NiN_mainType<\/th>\n      <th>km2<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"scrollX":true,"scrollY":true,"pageLength":10,"columnDefs":[{"className":"dt-right","targets":4},{"orderable":false,"targets":0}],"order":[],"autoWidth":false,"orderClasses":false}},"evals":[],"jsHooks":[]}</script>
```

<p class="caption">(\#fig:unnamed-chunk-80)List of unique combinatios of NiN variable codes and naturetypes with the summed area for which we have this data.</p>
</div>

## Export data
Exporting the table with the summary statistics and other information that I compled for each nature type in the three main ecosystems. This can be merged with the main dataset in order to subset according to a specific research question. 


```r
saveRDS(ntyp_fill2, "data/naturetypes/natureType_summary.rds")
```


Note also that the main dataset still contains some localities where there is a mis-match between the nature type definition and the NiN mapping uits recorded in the field. Each researcher should decide to include or exclude these. 

The main data set also includes mosaic localities, that are less suitable to use as ground trouth data for remote sensing methods.



## Appendix 1
Here is a deeper look into the causes for why some localities are recorded with seemingly erroneous NiN mapping units (and hence NiN main types)

Lets have a look at how the NiN main types (recorded in the field) cover the different *hovedøkosystem* when we exclude *Hule eiker* and all localities that have more than one NiN main type.

```r
dat_red <- dat_melt[dat_melt$n_ninkartleggingsenheter==1 & 
                      dat_melt$naturtype != "Hule eiker" &
                      dat_melt$mosaikk == "Nei",]
```


Let's focus in on our three targeted ecosystems.

```r
dat_red_tally <- stats::aggregate(data = dat_red,
                                  area~hovedøkosystem+ninkartleggingsenheter3, FUN = length)
names(dat_red_tally)[3] <- "count"
```


```r
target <- c("Semi-naturlig mark",
            "Våtmark",
            "Naturlig åpne områder under skoggrensa")
```


```r
ggplot(dat_red_tally[dat_red_tally$hovedøkosystem %in% target,],
       aes(x = ninkartleggingsenheter3,
               y = count))+
  geom_bar(
           fill="grey",
           colour="black",
           stat="identity")+
  coord_flip()+
  theme_bw(base_size = 12)+
  labs(y = "Number of localities",
       x = "NiN main types")+
  scale_y_continuous(position = "left",
                   expand = expansion(mult=c(.0,.3)))+
  geom_text(aes(label=count), hjust=-0.25)+
    facet_wrap("hovedøkosystem",
             scales = "free",
             ncol = 3)
```

<div class="figure">
<img src="naturtype_files/figure-html/unnamed-chunk-85-1.png" alt="Number of localities for each combination of main ecosystem and NiN main type" width="672" />
<p class="caption">(\#fig:unnamed-chunk-85)Number of localities for each combination of main ecosystem and NiN main type</p>
</div>

Still some weird cases which I will look at in turn below, trying to understand how they came to be recorded in this way.

#### Naturlig åpne områder under skoggrensa
Listing the NiN main types recorded for nature types belonging to *Naturlig åpne områder under skoggrensa*, but which clearly don't belong there:

* V10 (semi-naturlig våteng)
    + One case of Åpen flomfastmark wrongly associated with V10 whan it should be T18.
* T33 (Semi naturlig strandeng)
    + These are cases where either the `naturtype` should have been `semi-naturlig strandeng` (and hence the hovedøkosystem would be Semi-nat), or the `naturtype` is correctly recorded as `Strandeng` but then the NiN type should be `T12`.
* T32 (Semi-naturlig eng)
    + Obvious error
* T30 (Flomskogsmark)
    + Obvious error

Listing the remaining NiN main types:
* T8 (fulglefjelleng og fugltopp)
* T6 (Standberg)
* T29 (Grus og steindominert strand og strandlinje)
* T21 (Sanddynemark)
* T20 (Isinnfrysingsmark)
* T2 (Åpen grunlendt mark)
* T18 (Åpne flomfastmark)
* T17 (Aktiv skredmark)
* T15 (Fosse-eng)
* T13 (Rasmark)
* T12 (Strandeng)
* T1 (Nakent berg)



```r
`%!in%` <- Negate(`%in%`)
dat_red2 <- dat_red[
  dat_red$hovedøkosystem!="Naturlig åpne områder under skoggrensa" |
  dat_red$hovedøkosystem=="Naturlig åpne områder under skoggrensa" & 
    dat_red$ninkartleggingsenheter3 %!in% c("T30", "T32", "T33", "V10"),]
```

This resulted in deleting 19m localities.

#### Semi-naturlig mark
Listing the NiN main types recorded for nature types belonging to *Semi-naturlig mark*, but which clearly don't belong there:

* V9 (Semi-naturlig myr)
   + Kystlynghei recorded as mire
* T4 (Fastmarksskogsmark)
   + These should all be T32 (naturbeitemark, lauveng, hagemark, +++)
* T35 (Sterkt endret fastmark med løsmassedekke)
   + Wrong NiN type given to eng-aktig sterkt endret fastmark (it should be T40)
* T3 (Fjellhei, leside og tundra)
   + Boreal hei (should've been T31)
* T12 (Strandeng)
   + Should probably have been T33
* T1 (Nakent berg)
   + Obvious mistake
  
Listing the remaining NiN-main types:
* V10 (semi-nat våteng)
* T41 (Oppdyrket mark med preg av semi-naturlig eng)
* T40 (Sterkt endret fastmark med preg av semi-naturlig eng)
* T31-34

  


```r
dat_red3 <- dat_red2[
  dat_red2$hovedøkosystem!="Semi-naturlig mark" |
  dat_red2$hovedøkosystem=="Semi-naturlig mark" & dat_red2$ninkartleggingsenheter3 %!in% c("V9", "T4", "T35", "T3", "T12", "T1"),]
```

This resulted in the deletion of 57 localities.

#### Våtmark
Listing the NiN main types recorded for nature types belonging to *Våtmark*, but which clearly don't belong there.

Våtmark doesn't distinguish between semi-natural and natural, so all V-types are correct, except the strongly modified V11-V13.

* V11 (Torvtak)
  + Obvious mistake
* V12 (Grøftet åpne torvmark)
  + Obvious mistake
* V13 (Ny våtmark)
  + Obvious mistake
* T4 (skog)
  +   some that should've been T2 and some other strange things
* T30-T32
  + Someone switching the semi-natural and natural equivalents



```r
dat_red4 <- dat_red3[
  dat_red3$hovedøkosystem!="Våtmark" |
  dat_red3$hovedøkosystem=="Våtmark" & dat_red3$ninkartleggingsenheter3 %!in% c("T4", "T30", "T31", "T32", "V11", "V12", "V13"),]
```
This resulted in the deletion of 31 localities.


