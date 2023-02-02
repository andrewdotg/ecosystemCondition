# (PART\*) INDICATORS{-}

# Slitasje og kjørespor

*Author and date:* Anders L. Kolstad






|Ecosystem                                                           |Økologisk.egenskap                       |ECT.class                      |
|:-------------------------------------------------------------------|:----------------------------------------|:------------------------------|
|Våtmark, Naturlig åpne områder under skoggrensa, Semi-naturlig mark |Primærproduksjon (evt. Abiotiske fohold) |Physical state characteristics |

<hr/>

## Introduction
This indicator represent human cause terrain damage from hiking or off-road vehicle traffic. The data come from a combination non-random field surveys and area-representative surveys. Therefore extra care is taken not to over-extrapolate, and we use local reference area in the form of _homogeneous impact areas_. 

1.  Import [Nature type data](#NTM) data set (incl. GRUK) and [ANO data
    set](#ANO-import)

2.  Identify the [relevant](#naturtype) nature types and [subset](#NTM)
    the data

3.  Convert [ANO points to polygons](#ANO-points-to-poly)

4.  For each polygon, extract the NiN-variable that has the lowest value
    (one-out all-out principle), e.g. Fig. \@ref(fig:slitasje-naturetype).

5.  [Combine](#combine-nt-ano) data sets

6.  [Scale](#scale-slitasje-ind) the `slitasje` variable based on
    reference values.

7.  Define [homogeneous impact areas](#HIA) (HIA)

8.  [Aggregate and spread](#spread-slitasje) indicator value across HIAs
    and assessment regions

9.  Confirm relationship between infrastructure index and indicator
    values to justify the extrapolation

10. Sample 1000 random points from an ecosystem delineation and extract
    indicator values and sd at those points.

11. Export indicator maps and regional extrapolated maps

## About the underlying data

The indicator uses a data set from a standardised field survey of nature
types. You can read more about the preliminary analyses
[here](#naturtype). See also the [official
site](https://www.miljodirektoratet.no/ansvarsomrader/overvaking-arealplanlegging/naturkartlegging/naturtyper/)
of the Environment Agency. I also import a data set called
[ANO](#ANO-import), which you can read about
[here](https://www.miljodirektoratet.no/ansvarsomrader/overvaking-arealplanlegging/miljoovervaking/overvakingsprogrammer/natur-pa-land/arealrepresentativ-naturovervakning-ano/)

### Representativity in time and space

The nature type mapping is not random and cannot be said to be area
representative. The ANO data set however, is area representative. The
data is from 2018 to present. The data from one field season usually
becomes available early the following year.

### Original units

The variables are recorded on a coarse four-step ordinal scale (Fig.
\@ref(fig:four-step)).

### Temporal coverage

The data goes back to 2018, but is because of data shortage, it is
bulked into one time step. I then use the mean date for the raw data,
and define the variable as belonging to the year 2020 (read more
[here](#scaled-slitasje-variable)).

### Aditional comments about the dataset

For a run through of the data set, see [here](#naturtype).

## Ecosystem characteristic

### Norwegain standard

The indicator is tagged to the *Økologisk egenskap* called
**Primærproduksjon** (Primary productivity). This is tentative, and
perhaps *abiotiske forhold* is more suited. But the thought behind the
choise is that *sliatsje* affect the potential for primary productivity.

### UN standard

The indicator is tagged as a **Physical state characteristics**
indicator. This is quite clear. It's a type of abiotic characteristic that
has to do with the physical structure rather than the chemical
composition.

## Collinearities with other indicators

_Slitasje_ is not thought to exhibit collinearity with any other indicator at
the present.

## Reference condition and values

### Reference condition

The reference condition is one with minimal negative human impact. This
is also true for semi-natural ecosystems. For example, in the reference
condition, *slitasje* in semi-natural ecosystems is defined to be zero,
even though at no point in time would this condition be realized.

### Reference values, thresholds for defining *good ecological condition*, minimum and/or maximum values

* Upper = 0%

* Threshold = 10%

* Lower = 100%

The upper reference value is 0 (no *slitasje*), and the lower reference
value is 100%. Note that 100% _slitasje_ does not mean that all the area
must be scarred or damaged, but that all hypothetical quadrats around a
point is affected (the variable is frequency-driven, and not
amount-driven). The threshold for good ecosystem condition is 10%
damage. This is on the conservative side. Perhaps is should be set
somewhat higher, like 20 or 30%.

Read about the normalisation [here](##scaled-slitasje-variable).

## Uncertainties

Uncertainties/errors are estimated for aggregated indicator values by
bootstrapping individual indicator values 1000 times and calculating a
distribution of area weighted means. When aggregating a second time,
from homogeneous impact areas to accounting areas, we assume a normal
distribution around the indicator values, with the already mentioned
errors, and sample _n_ times from these and combine the resamples into an
a new, area weighted, distribution. The errors for the accounting areas
thus represents both the spatial variation, and the precision, of the
indicator values within the accounting areas.

## References

No additional references.

## Analyses

### Data sets

#### Nature type mapping {#NTM}

This indicator uses the data set
`Naturtyper etter Miljødirektoratets Instruks`, which can be found
[here](https://kartkatalog.geonorge.no/metadata/naturtyper-miljoedirektoratets-instruks/eb48dd19-03da-41e1-afd9-7ebc3079265c).
See also [here](#naturtype) for a detailed description of the data set.

<!-- Importing the full data set can be done like this, but because it can -->

<!-- take a few seconds due to its size, I will cache the data on the P -->

<!-- server after subsetting. -->


```r
naturetypes <- sf::st_read(dsn = paste0(pData, "Natur_Naturtyper_NiN_norge_med_svalbard_25833.gdb"))
```

We also have a separate [summary file](##exp-natureType-summary) where
the nature types are manually mapped to the correct NiN-main types. We
can use this to find the nature types associated with the NiN main types
that we are interested in.


```r
naturetypes_summary <- readRDS("data/naturetypes/natureType_summary.rds")
```

We are only interested in a few NiN main types and their mapping units
(see [here](#naturtype) for justification)


```r
main_NiN_types <- c("T12",
          "T18",
          "T21",
          "T31",
          "T33",
          "T34",
          "V1",
          "V3")
```


```r
naturetypes_summary <- naturetypes_summary[naturetypes_summary$NiN_mainType %in% main_NiN_types,]
```

Sub-setting the main data file:


```r
naturetypes <- naturetypes[naturetypes$naturtype %in% naturetypes_summary$Nature_type,]
```

Fix duplicated name for an ecosystem


```r
naturetypes$hovedøkosystem[naturetypes$hovedøkosystem=="Naturlig åpne områder i lavlandet"] <- "Naturlig åpne områder under skoggrensa"
```

Export subsetted data set


```r
saveRDS(naturetypes, "/data/P-Prosjekter2/41201785_okologisk_tilstand_2022_2023/data/rds/naturtyper.rds")
```




```r
ggplot(data = naturetypes, aes(x = naturtype, fill = hovedøkosystem))+
  geom_bar()+
  coord_flip()+
  theme_bw(base_size = 12)+
  theme(legend.position = "top",
        legend.title = element_blank(),
        legend.direction = "vertical")+
  #guides(fill = "none")+
  xlab("")+
  ylab("Number of localities")
```

<div class="figure">
<img src="slitasje_files/figure-html/unnamed-chunk-11-1.png" alt="An overview of the naturetypes for which we will calculate the indicator. Colours refer to the main ecosystem affiliation." width="672" />
<p class="caption">(\#fig:unnamed-chunk-11)An overview of the naturetypes for which we will calculate the indicator. Colours refer to the main ecosystem affiliation.</p>
</div>

Calculate area for each polygon.


```r
naturetypes$area <- sf::st_area(naturetypes)
```

The NiN variables are combined into a single field which we need to spit
apart.


```r
naturetypes <- tidyr::separate_rows(naturetypes,
                                    ninbeskrivelsesvariabler,
                                    sep=",") %>%
  separate(col = ninbeskrivelsesvariabler,
           into = c("NiN_variable_code", "NiN_variable_value"),
           sep = "_",
           remove=F
           )
```

Convert the value column to numeric. Ignore NA's.


```r
naturetypes$NiN_variable_value <- as.numeric(naturetypes$NiN_variable_value)
#> Warning: NAs introduced by coercion
```

Keep only the four relevant variables.


```r
myVars <- c(
  #"7FA",     #treated separately in a different indicator
  "7SE", "7TK", "PRTK", "PRSL")
naturetypes <- filter(naturetypes,
                      NiN_variable_code %in% myVars)
```

Column names starting with a number is problematic, so adding a prefix


```r
naturetypes$NiN_variable_code <- paste0("var_", naturetypes$NiN_variable_code)
```

Now I need to create a single row per locality with a new variable which
is a product/function of the four variables "7SE", "7TK", "PRTK" and
"PRSL". I will create a new data table where I calculate the new
variable which I then paste back into the sf object.


```r
naturetypes_wide <- pivot_wider(naturetypes,
                                names_from = "NiN_variable_code",
                                values_from = "NiN_variable_value",
                                id_cols = "identifikasjon_lokalid")
naturetypes_wide <- as.data.frame(naturetypes_wide)
head(naturetypes_wide)
#>   identifikasjon_lokalid var_7SE var_7TK var_PRTK var_PRSL
#> 1        NINFP1810016162       0      NA       NA       NA
#> 2        NINFP2010000946      NA       0       NA       NA
#> 3        NINFP2110041452      NA       0       NA       NA
#> 4        NINFP2010029659      NA       0       NA       NA
#> 5        NINFP1810043949       0      NA       NA       NA
#> 6        NINFP2010006882       2      NA        0       NA
```

The variables use slightly different scales. PRSL and PRTK use this 8
step scale:


```r
knitr::include_graphics("images/mdirPRscale.PNG")
```

<div class="figure">
<img src="images/mdirPRscale.PNG" alt="Eight step condition scale" width="314" />
<p class="caption">(\#fig:eight-step)Eight step condition scale</p>
</div>

7TK and 7SE use a 4 step scale


```r
knitr::include_graphics("images/ninAR4b.PNG")
```

<div class="figure">
<img src="images/ninAR4b.PNG" alt="Four step condition scale" width="554" />
<p class="caption">(\#fig:four-step)Four step condition scale</p>
</div>

I want to base this indicator on whichever of the variables have the
highest value (worst condition). This table shows that a locality may
have been assessed with both a PR variable and a NiN variable:


```r
table(naturetypes_wide$var_7SE, naturetypes_wide$var_PRTK)
#>    
#>        0    1    2    3    4    5    6    7
#>   0 2228  201   84   33   12    9    2    1
#>   1  418  271   70   34    8    7    1    0
#>   2   25    7    7    5    5    1    1    0
#>   3    9    0    1    1    0    0    1    0
```

Therefore I need to reconcile these scales. The only way I can think of
is to decrease the resolution of the PR variables to the ar4b scale.
This is of course a shame to loose this detail.

A locality will never have values for both 7SE and PRSL


```r
table(naturetypes_wide$var_7SE, naturetypes_wide$var_PRSL)
#>    
#>     0 1 2 3 4 5 6 7
#>   0 0 0 0 0 0 0 0 0
#>   1 0 0 0 0 0 0 0 0
#>   2 0 0 0 0 0 0 0 0
#>   3 0 0 0 0 0 0 0 0
```

nor 7TK and PRTK


```r
table(naturetypes_wide$var_7TK, naturetypes_wide$var_PRTK)
#>    
#>     0 1 2 3 4 5 6 7
#>   0 0 0 0 0 0 0 0 0
#>   1 0 0 0 0 0 0 0 0
#>   2 0 0 0 0 0 0 0 0
#>   3 0 0 0 0 0 0 0 0
```


```r
naturetypes_wide$var_7TK <-  ifelse(is.na(naturetypes_wide$var_7TK),
                              ifelse(naturetypes_wide$var_PRTK == 0, 0,
                                ifelse(naturetypes_wide$var_PRTK < 3, 1,
                                  ifelse(naturetypes_wide$var_PRTK < 6, 2, 3))),
                            naturetypes_wide$var_7TK)
```

Checking that I successfully combined classes 1+2, 3+4+5 and 6+7.


```r
table(naturetypes_wide$var_7TK, naturetypes_wide$var_PRTK,
      deparse.level = 2)
#>                         naturetypes_wide$var_PRTK
#> naturetypes_wide$var_7TK    0    1    2    3    4    5    6
#>                        0 2680    0    0    0    0    0    0
#>                        1    0  479  162    0    0    0    0
#>                        2    0    0    0   73   25   17    0
#>                        3    0    0    0    0    0    0    5
#>                         naturetypes_wide$var_PRTK
#> naturetypes_wide$var_7TK    7
#>                        0    0
#>                        1    0
#>                        2    0
#>                        3    1
```

That looks fine. Now doing the same for the other variable PRSL:


```r
naturetypes_wide$var_7SE <-  ifelse(is.na(naturetypes_wide$var_7SE),
                              ifelse(naturetypes_wide$var_PRSL == 0, 0,
                                ifelse(naturetypes_wide$var_PRSL < 3, 1,
                                  ifelse(naturetypes_wide$var_PRSL < 6, 2, 3))),
                            naturetypes_wide$var_7SE)
```

Remove the old PR variables.


```r
naturetypes_wide <- select(naturetypes_wide,
                           -var_PRTK,
                           -var_PRSL)
```

There are some very few cells with X's. These are NA's.


```r
naturetypes_wide$var_7SE[naturetypes_wide$var_7SE == "X"] <- NA
naturetypes_wide$var_7TK[naturetypes_wide$var_7TK == "X"] <- NA

naturetypes_wide$var_7SE <- as.numeric(naturetypes_wide$var_7SE)
naturetypes_wide$var_7TK <- as.numeric(naturetypes_wide$var_7TK)
```


```r
head(naturetypes_wide)
#>   identifikasjon_lokalid var_7SE var_7TK
#> 1        NINFP1810016162       0      NA
#> 2        NINFP2010000946      NA       0
#> 3        NINFP2110041452      NA       0
#> 4        NINFP2010029659      NA       0
#> 5        NINFP1810043949       0      NA
#> 6        NINFP2010006882       2       0
```


```r
anyDuplicated(naturetypes_wide$identifikasjon_lokalid)
#> [1] 0
```

7SE has 7341
NA's, and 7TK has
5888.


```r
temp <- naturetypes_wide %>%
  group_by(var_7SE) %>%
  summarise(sum = n())

ggplot(temp, aes(x = factor(var_7SE),
                 y = sum))+
  geom_bar(stat="identity",
           fill="grey",
           colour = "black")+
  theme_bw(base_size = 12)+
  labs(x = "7SE score",
       y = "Number of localities")
```

<div class="figure">
<img src="slitasje_files/figure-html/unnamed-chunk-28-1.png" alt="7SE scores in the naturetype dataset" width="288" />
<p class="caption">(\#fig:unnamed-chunk-28)7SE scores in the naturetype dataset</p>
</div>

The NA fraction is quite big. These are localities with 7TK recorded,
but not 7SE.


```r
temp <- naturetypes_wide %>%
  group_by(var_7TK) %>%
  summarise(sum = n())

ggplot(temp, aes(x = factor(var_7TK),
                 y = sum))+
  geom_bar(stat="identity",
           fill="grey",
           colour = "black")+
  theme_bw(base_size = 12)+
  labs(x = "7TK score",
       y = "Number of localities")
```

<div class="figure">
<img src="slitasje_files/figure-html/unnamed-chunk-29-1.png" alt="7TK scores in the nature type dataset" width="288" />
<p class="caption">(\#fig:unnamed-chunk-29)7TK scores in the nature type dataset</p>
</div>

Then I can combine these two variables into a composite variable called
`slitasje`


```r
naturetypes_wide$slitasje <- apply(naturetypes_wide[,c("var_7TK", "var_7SE")], 1, max, na.rm=T)
```

When both variables are NA, we get -Inf. There were nine cases of this
(in 2023). Removing these now.


```r
naturetypes_wide <- naturetypes_wide[naturetypes_wide$slitasje>=0,]
```


```r
temp <- naturetypes_wide %>%
  group_by(slitasje) %>%
  summarise(sum = n())

ggplot(temp, aes(x = factor(slitasje),
                 y = sum))+
  geom_bar(stat="identity",
           fill="grey",
           colour = "black")+
  theme_bw(base_size = 12)+
  labs(x = "slitasje score",
       y = "Number of localities")
```

<div class="figure">
<img src="slitasje_files/figure-html/slitasje-naturetype-1.png" alt="Slitasje scores." width="288" />
<p class="caption">(\#fig:slitasje-naturetype)Slitasje scores.</p>
</div>

It appears most localities are in good condition.

I would also like to know how often 7TK was defining of the
slitasje-indicator, and how often it was 7SE. I can do this by taking
the difference


```r
diff <- naturetypes_wide$var_7SE - 
        naturetypes_wide$var_7TK

diff <- ifelse(diff == 0, "7TK and 7SE",
               ifelse(diff <0, "7TK", "7SE"))

diff_tbl <- as.data.frame(table(diff))

ggplot(diff_tbl, aes(x = diff, y = Freq))+
  geom_bar(stat = "identity",
           colour = "black",
           fill = "grey")+
  theme_bw(base_size = 12)+
  labs(x = "Defining variable",
       y = "Number of localities")
```

<div class="figure">
<img src="slitasje_files/figure-html/unnamed-chunk-32-1.png" alt="Counting the number of cases where 7TK or 7SE ws defining of the slitasje indicator score." width="288" />
<p class="caption">(\#fig:unnamed-chunk-32)Counting the number of cases where 7TK or 7SE ws defining of the slitasje indicator score.</p>
</div>

Looks like 7SE is more likely to be in a detrimental state.

Now I will copy these slitasje-values into the sf object.


```r
naturetypes$slitasje <- naturetypes_wide$slitasje[match(naturetypes$identifikasjon_lokalid, naturetypes_wide$identifikasjon_lokalid)]
#nrow(naturetypes[is.na(naturetypes$slitasje),])  # 13 cases
naturetypes <- naturetypes[!is.na(naturetypes$slitasje),]
```

#### GRUK

This variable is also recorded in
[GRUK](https://www.nina.no/Naturmangfold/Trua-natur/%C3%85pen-grunnlendt-kalkmark).
The nature type data set I'm working on here includes this data already
(presently only 2021 included). GRUK also records a related variable:
`% cover in 5m radii circles`, which is much more detailed. This data is
not published. In any case it is better to use the harmonized data set
in our case.

#### ANO {#ANO-import}

Arealrepresentativ Naturovervåking (ANO) consist of 1000 systematically
placed locations each with 18 sample points. In each sample point a
circle of 250 m2 is visualised, and the main ecosystem is recorded.
Depending on the main ecosystem, certain NiN variables are also
recorded. 7SE is recorded for våtmark, but not semi-natural areas or
naturally open areas. 7TK is recorded in våtmark and naturally open
areas only.

| Variable | Våtmark | Naturlig åpne områder | Semi-naturlige områder |
|----------|---------|-----------------------|------------------------|
| 7SE      | X       | \-                    | \-                     |
| 7TK      | X       | X                     | \-                     |

: Table showing which main ecosystems the two NiN variables 7SE and 7TK
is recorded in withing the ANO dataset.

It would be very nice to have 7SE recorded for naturally open areas.
This variable is very relevant here.

I think I will only use våtmark here since my approach will be to the
'worst value' of the variable 7SE and 7TK (see below). I think not
having 7SE for naturally open areas will underestimate the degree of
degredation in these areas.


> *ANO could harmonise better with the Naturetype data set if it included
> 7SE and 7TK for Naturally open and Semi natural ecosystem.*



```r
ano <- sf::st_read(paste0(pData, "Naturovervaking_eksport.gdb"),
                   layer = "ANO_SurveyPoint") %>%
  dplyr::filter(hovedoekosystem_punkt == "vaatmark")
#> Reading layer `ANO_SurveyPoint' from data source 
#>   `/data/P-Prosjekter2/41201785_okologisk_tilstand_2022_2023/data/Naturovervaking_eksport.gdb' 
#>   using driver `OpenFileGDB'
#> Simple feature collection with 8974 features and 71 fields
#> Geometry type: POINT
#> Dimension:     XY
#> Bounding box:  xmin: -51950 ymin: 6467050 xmax: 1094950 ymax: 7923950
#> Projected CRS: ETRS89 / UTM zone 33N
```


```r
table(ano$aar)
#> 
#> 2019 2021 
#>  130  558
```

This data set only contains data from year 2019 and 2021. We need to
update this data set later. It is not clear why there is no data from
2020.

Each point/row here is 250 square meters. The data also contains
information about how big a proportion of this area is made up of the
dominant main ecosystem. However, there are
130
NA's here, which is 19% of the data.

It appears the proportion of each circle that is made up of the dominant
ecosystem was only recorded after year 2019. In fact, the main ecosystem
was not recorded at all in 2019:

```r
# Hard coding name change
#unique(ano$hovedtype_250m2)[3]
ano$hovedtype_250m2[ano$hovedtype_250m2==unique(ano$hovedtype_250m2)[3]] <- "Aapen jordvassmyr"
```



```r
table(ano$hovedtype_250m2, ano$aar)
#>                             
#>                              2019 2021
#>   Aapen jordvassmyr             0  416
#>   Boreal hei                    0    1
#>   Fjellhei leside og tundra     0    3
#>   Grøftet torvmark              0    5
#>   Helofytt-ferskvannssump       0    3
#>   Kaldkilde                     0    2
#>   Myr- og sumpskogsmark         0   51
#>   Nedbørsmyr                    0   53
#>   Rasmark                       0    1
#>   Semi-naturlig myr             0    7
#>   Semi-naturlig våteng          0    2
#>   Skogsmark                     0    2
#>   Strandsumpskogsmark           0    2
#>   Våtsnøleie og snøleiekilde    0    6
```

I can remove the NA's, and thus the 2019 data.

> *All of 2019 ANO data is excluded because of missing information*


```r
ano <- ano[!is.na(ano$andel_hovedoekosystem_punkt),]
```

Let's look at the variation in the recorded proportion of ecosystem
cover


```r
par(mar=c(5,6,4,2))
plot(ano$andel_hovedoekosystem_punkt[order(ano$andel_hovedoekosystem_punkt)],
     ylab="Percentage of the 250 m2 area\ncovered by the main ecosystem")
```

<div class="figure">
<img src="slitasje_files/figure-html/unnamed-chunk-39-1.png" alt="Distribution of the ANO variable andel_hovedoekosystem_punkt for wetland localities." width="672" />
<p class="caption">(\#fig:unnamed-chunk-39)Distribution of the ANO variable andel_hovedoekosystem_punkt for wetland localities.</p>
</div>

The zero in there is an obvious mistake.


```r
ano <- ano[ano$andel_hovedoekosystem_punkt>20,]
```

Here's another plot of the distribution of the same variable:


```r
ggplot(ano, aes(x = andel_hovedoekosystem_punkt))+
         geom_histogram(fill = "grey",
                        colour="black",
                        binwidth = 1)+
  theme_bw(base_size = 12)+
  xlab("Percentage cover of the Våtmark main ecosystem\n in the 250m2 circle")+
  scale_x_continuous(limits = c(0,101),
                     breaks = seq(0,100,10))
```

<div class="figure">
<img src="slitasje_files/figure-html/unnamed-chunk-41-1.png" alt="Percentage cover of the Våtmark main ecosystem in the 250m2 circle" width="672" />
<p class="caption">(\#fig:unnamed-chunk-41)Percentage cover of the Våtmark main ecosystem in the 250m2 circle</p>
</div>

We can see that people tend to record the variable in steps of 5%, and
that most sample points are 100% belonging to the same main ecosystem.

We want to use area weighting in this indicator, so we can use this
percentage cover data to calculate the area. Note that both data sets
use m^2^ as area units.


```r
ano$area <- (ano$andel_hovedoekosystem_punkt/100)*250
```

Let's now look at the distribution of the variables. First I need to
separate the variable name from the values themselves. Now the data
looks like this:


```r
ano$bv_7se[1:6]
#> [1] "7SE_0" "7SE_0" "7SE_0" "7SE_0" "7SE_0" "7SE_0"
```

So I create a new variable prefixed var\_:


```r
ano$var_7SE <- as.numeric(sub(pattern = "7SE_",
                 replacement = "",
                 x = ano$bv_7se))
#> Warning: NAs introduced by coercion
```

The NA's is the case of blank cells. The field app should not allow
users leaving this field blank. I will need to remove these rows. There
are fourteen cases:


```r
nrow(ano[is.na(ano$var_7SE),])
#> [1] 14
```


```r
ano <- ano[!is.na(ano$var_7SE),]
```

Same with the other variable 7TK


```r
ano$var_7TK <- as.numeric(sub(pattern = "7TK_",
                 replacement = "",
                 x = ano$bv_7tk))
```

No NA's this time.


> *The ANO field app should not allow user to leave blank cells. This
> resulted in the exclusion of data.*



```r
par(mfrow=c(1,2))
barplot(table(ano$var_7TK), xlab="7TK scores")
barplot(table(ano$var_7SE), xlab="7SE scores")
```

<div class="figure">
<img src="slitasje_files/figure-html/unnamed-chunk-48-1.png" alt="Distribution of 7TK and 7SE scores in the ANO data" width="672" />
<p class="caption">(\#fig:unnamed-chunk-48)Distribution of 7TK and 7SE scores in the ANO data</p>
</div>

Combining these two variables into the indicator, same as for the nature
type data.


```r
temp <- as.data.frame(ano)
temp$slitasje <- apply(temp[,c("var_7TK", "var_7SE")], 1, max, na.rm=T)
ano$slitasje <- temp$slitasje
```


```r
barplot(table(ano$slitasje), xlab="Sliatsje scores", ylab = "Number of localities")
```

<div class="figure">
<img src="slitasje_files/figure-html/unnamed-chunk-50-1.png" alt="Distribution of slitasje scores in the ANO data" width="576" />
<p class="caption">(\#fig:unnamed-chunk-50)Distribution of slitasje scores in the ANO data</p>
</div>

##### Combine Naturtype data and ANO {#combine-nt-ano}

We need to combine the nature type data set with the ANO data set. I
will add a column `origin` to show where the data comes from. I will
also add a column with the main ecosystem.


```r
ano$origin <- "ANO"
naturetypes$origin <- "Nature type mapping"
ano$hovedøkosystem <- "Våtmark"
ano$kartleggingsår <- ano$aar
```

Fix class


```r
naturetypes$kartleggingsår <- as.numeric(naturetypes$kartleggingsår)
naturetypes$area <- units::drop_units(naturetypes$area)
```

I use `dplyr::select` to reduce the number of columns to keep things a
bit more tidy.


```r
slitasje_data <- dplyr::bind_rows(select(ano,
                                  GlobalID,
                                  origin,
                                  kartleggingsår,
                                  hovedøkosystem,
                                  area,
                                  slitasje,
                                  SHAPE), 
                           select(naturetypes,
                                  identifikasjon_lokalid,
                                  origin,
                                  hovedøkosystem,
                                  kartleggingsår,
                                  area,
                                  slitasje,
                                  SHAPE))

unique(st_geometry_type(slitasje_data))
#> [1] POINT        MULTIPOLYGON
#> 18 Levels: GEOMETRY POINT LINESTRING POLYGON ... TRIANGLE
```

###### Points to polygons {#ANO-points-to-poly}

The ANO data is point data, and the nature type data is *multipolygon*.
Because later we might want to save this as a shape file, we cannot have
a mixed class type. I will therefore convert the points to polygons. I
use the area column to calculate a radii that gives that area.


```r
slitasje_data_points <- slitasje_data %>%
  mutate(g_type = st_geometry_type(.)) %>%
  filter(g_type =="POINT") %>%
  st_buffer(sqrt(slitasje_data$area/pi))
```

Checking now that the new polygons have the area corresponding to the
proportion of the point that was part of the same main ecosystem:


```r
slitasje_data_points$area2 <- st_area(slitasje_data_points)
plot(slitasje_data_points$area, slitasje_data_points$area2,
     xlab = "Target area",
     ylab = "Area of the new polygons")
```

<div class="figure">
<img src="slitasje_files/figure-html/new-area-1.png" alt="Checking that the area of the new polygons fall in line with the proportion of each point which is part of the main ecosystem." width="672" />
<p class="caption">(\#fig:new-area)Checking that the area of the new polygons fall in line with the proportion of each point which is part of the main ecosystem.</p>
</div>

The area calculation seems to have worked fine. Checking that the new
data set contains **only polygons**.


```r
slitasje_data_polygons <- slitasje_data %>%
  mutate(g_type = st_geometry_type(.)) %>%
  filter(g_type !="POINT")

slitasje_data <- bind_rows(slitasje_data_points, slitasje_data_polygons)

unique(st_geometry_type(slitasje_data))
#> [1] POLYGON      MULTIPOLYGON
#> 18 Levels: GEOMETRY POINT LINESTRING POLYGON ... TRIANGLE
```

Ok.

#### Distribution of Slitasje scores


```r
temp <- as.data.frame(table(slitasje_data$slitasje))
ggplot(temp, aes(x = Var1,
                 y = Freq))+
  geom_bar(stat="identity",
           fill="grey",
           colour = "black")+
  theme_bw(base_size = 12)+
  labs(x = "slitasje score",
       y = "Number of localities")
```

<div class="figure">
<img src="slitasje_files/figure-html/unnamed-chunk-56-1.png" alt="Slitasje scores (ANO Naturetype (and GRUK) data combined). The score for a locality equals the highest (worst) score of the related variables 7TK, 7SE, PRSL and PRTK." width="672" />
<p class="caption">(\#fig:unnamed-chunk-56)Slitasje scores (ANO Naturetype (and GRUK) data combined). The score for a locality equals the highest (worst) score of the related variables 7TK, 7SE, PRSL and PRTK.</p>
</div>

Let's see the proportion of data points (not area) origination from each
data set


```r
temp <- as.data.frame(table(slitasje_data$origin))

ggplot(temp, aes(x = Var1,
                 y = Freq))+
  geom_bar(stat="identity",
           fill="grey",
           colour = "black")+
  theme_bw(base_size = 12)+
  labs(x = "Data origin",
       y = "Number of localities")
```

<div class="figure">
<img src="slitasje_files/figure-html/unnamed-chunk-57-1.png" alt="Barplot show the contribution (number of localities) of different data sets to the slitasje indicator." width="384" />
<p class="caption">(\#fig:unnamed-chunk-57)Barplot show the contribution (number of localities) of different data sets to the slitasje indicator.</p>
</div>

So the ANO data is not very important here, but it can become more
important in the future so good to have them included in the workflow.

#### Outline of Norway and regions

The GIS layers are used to crop out marine areas, and to define
accounting areas, respectively.


```r
outline <- sf::read_sf("data/outlineOfNorway_EPSG25833.shp")
```


```r
regions <- sf::read_sf("data/regions.shp", options = "ENCODING=UTF8")
unique(regions$region)
#> [1] "Nord-Norge" "Midt-Norge" "Østlandet"  "Vestlandet"
#> [5] "Sørlandet"
```

### Scaled indicator values {#scale-slitasje-ind}

I can scale the indicator for each polygon, or I can chose to aggregate
them first. If the scaled value is representative and precise at the
polygon level, then I could scale at that level. I think they are.

However, the combined surveyed area is a very small fraction of the
total area of Norway, so that only producing indicator values for the
mapped areas leaves the indicator without much value for regional
assessments. When we do regional assessments and calcualte regional
indicator values, we cannot simply do an area weighting of the polygons
in each region. This is because we don't want to assume that the
polygons are representative far outside of the mapped area. But perhaps
we can assume them to be representative inside *homogeneous ecological
areas,* or *Homoegeneous Impact Areas* (HIAs). That's where the
infrastructure index comes in. Here's the plan:

1.  normalise the indicators at the polygon level.

2.  take a simplified infrastructure index (vector data set with HIAs)
    and extract the corresponding indicator values that intersect with a
    given HIA, and extrapolate the area weighted mean of those values to
    the entire HIA withing a given geographical region. Errors are
    calculated from bootstrapping.

3.  Take the new area weighted indicator values for the HIAs and match
    them with ecosystem occurrences of the same HIA (possibly using
    randomly sampled points from the available ecosystem occurrences).
    The errors are the same as for the HIAs.

4.  calculate an indicator value for a region (accounting area) by doing
    a weighted average based of the relative area of ecosystem
    occurrences. Errors should be carried somehow, perhaps via weighted
    resampling.

#### Scaled variable {#scaled-slitasje-variable}

The variable is ordinal, not continuous. See fig. \@ref(fig:eight-step).
I could create another variable which was more like original range
scale. Although not perfect, I will use the median value for each
category. I.e. when the variable is recorded as 2 (meaning from 1/16th
to 1/2), this is converted to 31.25%, i.e. in the middle between the two
end points of the category.


```r
slitasje_data$slitasje_percentage <- slitasje_data$slitasje

slitasje_data$slitasje_percentage[slitasje_data$slitasje_percentage == 1] <- ((1/16)/2)*100
slitasje_data$slitasje_percentage[slitasje_data$slitasje_percentage == 2] <- (((1/2)/2)+(1/16))*100
slitasje_data$slitasje_percentage[slitasje_data$slitasje_percentage == 3] <- (3/4)*100
table(slitasje_data$slitasje_percentage)
#> 
#>     0 3.125 31.25    75 
#> 19337  6466  1069   153
```


```r
ggplot(slitasje_data, aes(x = slitasje,
                          y = slitasje_percentage))+
  geom_point(size=6)+
  geom_line()+
  theme_bw(base_size = 16)
```

<div class="figure">
<img src="slitasje_files/figure-html/continuous-scale-1.png" alt="Showing the conversion from ordinal to (pseudo)continous cale for the slitasje variable" width="480" />
<p class="caption">(\#fig:continuous-scale)Showing the conversion from ordinal to (pseudo)continous cale for the slitasje variable</p>
</div>

I will use the same reference levels/values for all of Norway:


```r
upper <- 0
lower <- 100
threshold <- 10
```

This implies that it is impossible to detect or measure a state when it
is in its most degraded form (100% disturbed). This is a problem with
the original data resolution. But I will compensate somewhat for this by
using a non-linear transformation.

Also, the threshold value is set quite conservativly, and should be
discussed.

I need to do a little trick and reverse the upper and lower reference
values for the normalisation to work. This is a bug which can be fixed
inside eaTools.


```r
eaTools::ea_normalise(data = slitasje_data,
                      vector = "slitasje_percentage",
                      upper_reference_level = lower,
                      lower_reference_level = upper,
                      break_point = threshold,
                      plot=T,
                      reverse = T
                      )
```

<div class="figure">
<img src="slitasje_files/figure-html/slitasje-normalise-1.png" alt="Performing a non-linear break-point type normalisation of the slitasje variable." width="480" />
<p class="caption">(\#fig:slitasje-normalise)Performing a non-linear break-point type normalisation of the slitasje variable.</p>
</div>

This normalisation seems reasonable to me. I can save it as indicator
values. There is no point yet making this a time series, and I will
assign all the indicator value to the average year of the data.


```r
mean(slitasje_data$kartleggingsår)
#> [1] 2019.85
```

Assigning the indicator to year 2020.


```r
slitasje_data$i_2020 <- eaTools::ea_normalise(data = slitasje_data,
                      vector = "slitasje_percentage",
                      upper_reference_level = lower,
                      lower_reference_level = upper,
                      break_point = threshold,
                      reverse = T
                      )
```

### Homogeneous impact areas {#HIA}

I want to use the [Homogeneous Impact Areas](#HIA) (HIA) to define
smaller regions into which I can extrapolate the indicator values. This
data is generated by discretizing the Norwegian Infrastructure Index. I
refer to the ordinal values of the four HIA classes as their *Human
Impact Factor* (HIF). This is just to keep the approach separate from
the Norwegian Infrastructure Index.


```r
HIA <- readRDS(paste0(pData, "infrastrukturindeks/homogeneous_impact_areas.rds"))
```

I want to check that HIF is in fact a good predictor for *slitasje*.

I also want to split these four HIA classes based on their region. To do
this I need the two layers to have the same CRS.


```r
st_crs(HIA) == st_crs(regions)
#> [1] TRUE
```

Since the two layers are completely overlapping, we can get the
intersections


```r
HIA_regions <- eaTools::ea_homogeneous_area(HIA,
                             regions,
                             keep1 = "infrastructureIndex",
                             keep2 = "region")
saveRDS(HIA_regions, "P:/41201785_okologisk_tilstand_2022_2023/data/cache/HIA_regions.rds")
```



Create a new column by crossing region and HIF


```r
HIA_regions <- HIA_regions %>%
  mutate(region_HIF = paste(region, infrastructureIndex))
```

#### Validate

I now have 20 unique areas (for each main ecosystem) that I will, given
there is data, extrapolate indicator values over.

###### Subset ETs

I will subset the `sliatsje_data` in the three ecosystems. Note that
only for open wetland do we have good ecosystem delineation maps to base
a spatial averaging on.


```r
wetlands <- slitasje_data[slitasje_data$hovedøkosystem == "Våtmark",]
seminat <- slitasje_data[slitasje_data$hovedøkosystem == "Semi-naturlig mark",]
natOpen <- slitasje_data[slitasje_data$hovedøkosystem == "Naturlig åpne områder under skoggrensa",]
```

Creating some summary statistics.


```r
wetland_stats <- ea_spread(indicator_data = wetlands,
          indicator = i_2020,
          regions = HIA_regions,
          groups = region_HIF,
          summarise = TRUE)

seminat_stats <- ea_spread(indicator_data = seminat,
          indicator = i_2020,
          regions = HIA_regions,
          groups = region_HIF,
          summarise = TRUE)

natOpen_stats <- ea_spread(indicator_data = natOpen,
          indicator = i_2020,
          regions = HIA_regions,
          groups = region_HIF,
          summarise = TRUE)

wetland_stats <- wetland_stats %>%
  add_column(eco = "wetland")

seminat_stats <- seminat_stats %>%
  add_column(eco = "semi-natural")

natOpen_stats <- natOpen_stats %>%
  add_column(eco = "Naturally-open")

all_stats <- rbind(wetland_stats,
                   seminat_stats,
                   natOpen_stats)
all_stats <- all_stats %>%
  separate(region_HIF,
           into = c("region", "HIF"),
           sep = " ")
saveRDS(all_stats, "P:/41201785_okologisk_tilstand_2022_2023/data/cache/all_stats.rds")
```




```r
ggarrange(
ggplot(all_stats, aes(x = region, y = n, group = HIF, fill = HIF))+
  geom_bar(position = "dodge", stat = "identity")+
  theme_bw(base_size = 30)+
  coord_flip()+
  facet_wrap(.~eco),
ggplot(all_stats, aes(x = region, y = w_mean, group = HIF, fill = HIF))+
  geom_bar(position = "dodge", stat = "identity")+
  theme_bw(base_size = 30)+
  coord_flip()+
  facet_wrap(.~eco),
ggplot(all_stats, aes(x = region, y = sd, group = HIF, fill = HIF))+
  geom_bar(position = "dodge", stat = "identity")+
  theme_bw(base_size = 30)+
  coord_flip()+
  facet_wrap(.~eco),
ncol = 1)
```

<img src="slitasje_files/figure-html/dense-stats-1.png" width="1152" />

This rather dense figure needs to be looked at carefully. In the top row
we see that the sample size (number of polygons) varies between
ecosystems. For naturally open ecosystems many polygons are from high
infrastructure areas, not surprisingly, and there are few points for the
lowest impact class (zero such polygons in *Sørlandet* for example). We
may therefore not be able to extrapolate indicator values for Naturally
open areas in in *Sørlandet* with low levels of infrastructure. 

We can also from the middle row see the association between the indicator
values (area weighted means) and the modified infrastructure index
(HIF). We should then not put too much weight on the bars were there is
little data (low n) and/or high standard error (sd, bottom row). For
example, with Naturally open ecosystems, 

Midt-Norge has the overall lowest errors, and there we also see the kind of relationship between
the indicator and the pressure that we want to see (middle row). The
pattern is repeated for all regions except Østlandet, but there we also
see that HIF class 3 has very little data, and a high sd, and this could
explain the discrepancy (but it doesn't support the general relationship
either).

In semi-natural areas and wetlands, we have very little data from HIF
class 3, and the sd's are very big. The indicator-pressure relationship
(middle row) looks the most messy for wetlands, but if ignoring HIF=3,
the relationship looks much better.


```r
DT::datatable(all_stats)
```

<div class="figure">

```{=html}
<div id="htmlwidget-21d7a59acb3192f224b0" style="width:100%;height:auto;" class="datatables html-widget"></div>
<script type="application/json" data-for="htmlwidget-21d7a59acb3192f224b0">{"x":{"filter":"none","vertical":false,"data":[["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57"],["Midt-Norge","Midt-Norge","Midt-Norge","Midt-Norge","Nord-Norge","Nord-Norge","Nord-Norge","Nord-Norge","Sørlandet","Sørlandet","Sørlandet","Vestlandet","Vestlandet","Vestlandet","Østlandet","Østlandet","Østlandet","Østlandet","Midt-Norge","Midt-Norge","Midt-Norge","Midt-Norge","Nord-Norge","Nord-Norge","Nord-Norge","Nord-Norge","Sørlandet","Sørlandet","Sørlandet","Sørlandet","Vestlandet","Vestlandet","Vestlandet","Vestlandet","Østlandet","Østlandet","Østlandet","Østlandet","Midt-Norge","Midt-Norge","Midt-Norge","Midt-Norge","Nord-Norge","Nord-Norge","Nord-Norge","Nord-Norge","Sørlandet","Sørlandet","Sørlandet","Vestlandet","Vestlandet","Vestlandet","Vestlandet","Østlandet","Østlandet","Østlandet","Østlandet"],["0","1","2","3","0","1","2","3","0","1","2","0","1","2","0","1","2","3","0","1","2","3","0","1","2","3","0","1","2","3","0","1","2","3","0","1","2","3","0","1","2","3","0","1","2","3","1","2","3","0","1","2","3","0","1","2","3"],[16209610.2496514,45211964.8453548,19001431.5479795,314264.320728865,2710516.30566649,28057586.3793119,11482738.8832706,74446.5055558359,682238.653932593,991130.005807994,639258.572024811,2061446.80986481,4113698.9600472,707027.318611489,360597.287192951,3648871.44361387,4840740.70355411,241299.262720714,44948060.4008877,96856583.9899553,58789668.5481242,934269.305415592,11176508.8484102,33165644.3405374,12492611.5090584,77338.3649934132,9801191.45542132,49074389.5673002,18985092.9403347,274888.843731315,46162298.3757948,139055884.807505,62652791.9416189,1207662.7515494,22154422.1541261,68413277.4075446,40894218.1413964,405932.011477834,37699.1660658609,646597.514736184,3304543.25624028,446486.861662487,1094972.34031724,5999683.45294895,5479983.27905379,5708.07357701473,91550.2052620611,651452.54491182,327258.116450034,10672.1948234461,149794.998156462,397484.430971355,39714.0997798119,7249.39994638925,496314.001076419,4333929.96598427,722559.569129946],[805,2193,1093,30,428,1523,656,10,79,135,41,241,527,160,95,363,266,10,737,2256,2081,67,335,967,645,9,123,678,593,49,414,1821,1710,116,228,864,1114,62,54,186,870,146,192,1142,982,2,22,246,150,14,78,190,20,8,120,874,162],[0.872093050799493,0.873271534924672,0.85546619631609,0.937380058752728,0.918592906669058,0.874614926379827,0.846198546107781,0.938921918548296,0.92786819040074,0.9483538959046,0.864009695445257,0.994907642007468,0.950445182523243,0.901920185670037,0.909232836966662,0.930443139234207,0.842920376356852,0.950568260791274,0.948172739050822,0.91742453225015,0.887598775015146,0.914710213638131,0.932396019365782,0.900305645306018,0.871915149122071,0.918656562711873,0.980544702892717,0.941952064567868,0.918111623268704,0.852610216643323,0.958267750996937,0.925421804986654,0.930472229599312,0.930804951001526,0.862327505264176,0.844934652526433,0.825240525002589,0.712653103937267,0.975116911486412,0.953686421493984,0.905755360357062,0.889014496816697,0.918889587842996,0.88046295847182,0.867024263545306,0.305555555555556,0.921482028431549,0.778725846288571,0.726054904477386,0.983058498854173,0.986997482315042,0.904637769237159,0.520928622658911,0.867898816179853,0.909756054150719,0.876533527801648,0.8864885770581],[0.951751207729469,0.898974641536201,0.886163210328352,0.891203703703704,0.930425752855659,0.894096082293719,0.88672933604336,0.8875,0.964398734177215,0.929269547325103,0.90210027100271,0.981990548639926,0.960981973434535,0.921440972222222,0.986184210526316,0.933444291398837,0.890664160401002,0.8875,0.970676918438112,0.94956350965327,0.920300736825244,0.946828358208955,0.974979270315091,0.952286567850167,0.951647286821705,0.881172839506173,0.99390243902439,0.978398475909538,0.953766160764474,0.825396825396825,0.970779656468062,0.955797333577399,0.955640838206628,0.936302681992337,0.929915935672515,0.879726080246914,0.855326152004788,0.806227598566308,0.986111111111111,0.924283154121864,0.923738825031929,0.931411719939117,0.9765625,0.933206849581631,0.923667684996606,0.305555555555556,0.931818181818182,0.798949864498645,0.736111111111111,0.973214285714286,0.949964387464387,0.925365497076023,0.855555555555556,0.953125,0.880439814814815,0.85173531655225,0.795524691358025],[0.00457283178475555,0.003768091090335,0.00527357022851347,0.032121223049415,0.00672619730759783,0.00421217286621883,0.00593726092175379,0.0297561824051545,0.00864916373140018,0.0135651815044588,0.0256352303004485,0.00587892462220306,0.00592765234509322,0.0141939378740475,0.0051451853630316,0.00764804859738178,0.0118533513842229,0.0283317538146108,0.00321581664577187,0.00229656772801088,0.00299658136809545,0.0104507737923793,0.00391754710067107,0.00392187797826285,0.00442234058166537,0.0744264520806323,0.00292880847531171,0.00273082441346138,0.00410381082399992,0.0356646571957463,0.00469959781614147,0.00255334335464343,0.00257082859793937,0.0112744261776116,0.00898487566342122,0.00621492692493641,0.00616298636119361,0.0321962790615114,0.0068514340508301,0.0121310834925019,0.00565461164276092,0.00934422794592941,0.00474003502795946,0.00486999110730789,0.00499017947842723,0,0.0192900005821471,0.0170009371454834,0.0235496918169475,0.0180923815418698,0.0173343614852224,0.0109609778691968,0.0428859909987562,0.0295052042954801,0.0194095444188372,0.00868069225901886,0.019537691298524],["wetland","wetland","wetland","wetland","wetland","wetland","wetland","wetland","wetland","wetland","wetland","wetland","wetland","wetland","wetland","wetland","wetland","wetland","semi-natural","semi-natural","semi-natural","semi-natural","semi-natural","semi-natural","semi-natural","semi-natural","semi-natural","semi-natural","semi-natural","semi-natural","semi-natural","semi-natural","semi-natural","semi-natural","semi-natural","semi-natural","semi-natural","semi-natural","Naturally-open","Naturally-open","Naturally-open","Naturally-open","Naturally-open","Naturally-open","Naturally-open","Naturally-open","Naturally-open","Naturally-open","Naturally-open","Naturally-open","Naturally-open","Naturally-open","Naturally-open","Naturally-open","Naturally-open","Naturally-open","Naturally-open"]],"container":"<table class=\"display\">\n  <thead>\n    <tr>\n      <th> <\/th>\n      <th>region<\/th>\n      <th>HIF<\/th>\n      <th>total_area<\/th>\n      <th>n<\/th>\n      <th>w_mean<\/th>\n      <th>mean<\/th>\n      <th>sd<\/th>\n      <th>eco<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"columnDefs":[{"className":"dt-right","targets":[3,4,5,6,7]},{"orderable":false,"targets":0}],"order":[],"autoWidth":false,"orderClasses":false}},"evals":[],"jsHooks":[]}</script>
```

<p class="caption">(\#fig:unnamed-chunk-72)Summary statistics for the slitasje indicator.</p>
</div>

In addition to looking at the area weighted means and its relationship
with the pressure indicator (HIF), we can do the same at the polygon
level. Because the indicator is pseudo-continuous, boxplots for example
become useless, so I will present a relative frequency plot.


```r
corrCheck <- st_intersection(slitasje_data, HIA_regions)
saveRDS(corrCheck, "P:/41201785_okologisk_tilstand_2022_2023/data/cache/corrCheck.rds")
```




```r
ggplot(corrCheck, aes(x = factor(infrastructureIndex), fill = factor(i_2020)))+
  geom_bar(position="fill")+
  theme_bw(base_size = 12)+
  guides(fill = guide_legend("Sliatsje indicator"))+
  ylab("Fraction of data points")+
  xlab("HIF")+
  facet_grid(hovedøkosystem~region)
```

<div class="figure">
<img src="slitasje_files/figure-html/slitasje-precentageplot-1.png" alt="Relative frequency plot (conditioned on region and main ecosystem) showing the distribution of polygons with different indicator values." width="1152" />
<p class="caption">(\#fig:slitasje-precentageplot)Relative frequency plot (conditioned on region and main ecosystem) showing the distribution of polygons with different indicator values.</p>
</div>

The figure above I think supports the indicator-pressure relationship
and justifies using the HIA+region intersections as local reference
areas. Especially when down-weighting the importance of those
groups/categories that have very little data.

We can also calculate *Kendall tau b* coefficients, although I'm not
complete sure this is valid when we have ordinal data with only four
levels, since there will be a lot of ties.


```r
corrCheck_grouped <- as.data.frame(corrCheck) %>%
  group_by(hovedøkosystem, region) %>%
  summarise(cor = cor(i_2020, infrastructureIndex, method = "kendall"))
#> `summarise()` has grouped output by 'hovedøkosystem'. You
#> can override using the `.groups` argument.
```


```r
ggplot(corrCheck_grouped, aes(x = hovedøkosystem, 
                      y = cor))+
  geom_bar(stat = "identity")+
  facet_wrap(.~region)+
  coord_flip()
```

<div class="figure">
<img src="slitasje_files/figure-html/unnamed-chunk-76-1.png" alt="Pearson correlations between the indicator values at the polygons level and the HIF." width="672" />
<p class="caption">(\#fig:unnamed-chunk-76)Pearson correlations between the indicator values at the polygons level and the HIF.</p>
</div>


```r
corrCheck_eco <- corrCheck_grouped %>%
  group_by(hovedøkosystem) %>%
  summarise(cor = mean(cor))
corrCheck_reg <- corrCheck_grouped %>%
  group_by(region) %>%
  summarise(cor = mean(cor))

ggarrange(
ggplot(corrCheck_eco, aes(x = hovedøkosystem, 
                      y = cor))+
  geom_bar(stat = "identity")+
  coord_flip(),
ggplot(corrCheck_reg, aes(x = region, 
                      y = cor))+
  geom_bar(stat = "identity")+
  coord_flip(),
ncol=1
)
```

<div class="figure">
<img src="slitasje_files/figure-html/unnamed-chunk-77-1.png" alt="Pearson correlations between indicator values and the HIF." width="672" />
<p class="caption">(\#fig:unnamed-chunk-77)Pearson correlations between indicator values and the HIF.</p>
</div>

From the figures above it appears that the relationship is quite week in
general. However, the sheer number of data points suggest that group
differences will be very reliable. *Naturlig åpne områder* has the
lowest correlation between the indicator and the homogeneous area
classes, and of the five regions, *Nord-Norge* has the lowest
correlation.

#### Looking at the HIA

Here is a view of the data zooming in on Trondheim


```r
myBB <- st_bbox(c(xmin=260520.12, xmax = 278587.56,
                ymin = 7032142.5, ymax = 7045245.27),
                crs = st_crs(HIA_regions))
```

Cropping the raster to the bbox


```r
HIA_trd <- sf::st_crop(HIA_regions, myBB)
#> Warning: attribute variables are assumed to be spatially
#> constant throughout all geometries
```

Get map of major roads, for context


```r
hw_utm <- readRDS("data/cache/highways_trondheim.rds")
```


```r
(HIA_trd <- tm_shape(HIA_trd)+
  tm_polygons(col = "infrastructureIndex",
    title="Infrastructure index\n(modified 4-step scale)",
    palette = "-viridis",
    style="cat")+
  tm_layout(legend.outside = T)+
  tm_shape(hw_utm)+
  tm_lines(col="red")+
  tm_shape(outline)+
  tm_borders(col = "black", lwd=2))
```

<div class="figure">
<img src="slitasje_files/figure-html/unnamed-chunk-81-1.png" alt="A closer look at the HIA designation over Trondheim" width="672" />
<p class="caption">(\#fig:unnamed-chunk-81)A closer look at the HIA designation over Trondheim</p>
</div>

Let's calculate the areas of these polygons and compare the HIF in the
five regions.


```r
HIA_regions$area <- sf::st_area(HIA_regions)
```


```r
temp <- as.data.frame(HIA_regions) %>%
  group_by(region, infrastructureIndex) %>%
  summarise(area = mean(area))
#> `summarise()` has grouped output by 'region'. You can
#> override using the `.groups` argument.

ggplot(temp, aes(x = region, y = area, fill = factor(infrastructureIndex)))+
  geom_bar(position = "stack", stat = "identity")+
  guides(fill = guide_legend("HIF"))
```

<div class="figure">
<img src="slitasje_files/figure-html/HIF-region-1.png" alt="Stacked barplot showing the distribution of human impact factor across five regions in Norway." width="672" />
<p class="caption">(\#fig:HIF-region)Stacked barplot showing the distribution of human impact factor across five regions in Norway.</p>
</div>

The figure above shows that Nord-Norge for example, has a lot of
relatively untouched areas, and that Østlandet has the highest
proportion of impacted areas. This is expected.

### Aggregate and spread (extrapolate) {#spread-slitasje}

I now want to find the mean indicator value for each HIA (i.e. to
aggregate) and to spread these out spatially to the entire HIA within
each region (i.e. to extrapolate).

I want to add a threshold so that we don't end up over extrapolating
based on too few data points. From Fig. \@ref(fig:dense-stats) I
conclude that we need at least 70 data points for the sd to stabilize. I
will conservatively round this up to 100 data points.


```r
wetlands_slitasje_extr <- ea_spread(indicator_data = wetlands,
                         indicator = i_2020,
                         regions = HIA_regions,
                         groups = region_HIF,
                         threshold = 100)

seminat_slitasje_extr <- ea_spread(indicator_data = seminat,
                         indicator = i_2020,
                         regions = HIA_regions,
                         groups = region_HIF,
                         threshold = 100)

natOpen_slitasje_extr <- ea_spread(indicator_data = natOpen,
                         indicator = i_2020,
                         regions = HIA_regions,
                         groups = region_HIF,
                         threshold = 100)
#saveRDS(wetlands_slitasje_extr, "P:/41201785_okologisk_tilstand_2022_2023/data/cache/wetlands_slitasje_extr.rds")
#saveRDS(seminat_slitasje_extr, "P:/41201785_okologisk_tilstand_2022_2023/data/cache/seminat_slitasje_extr.rds")
#saveRDS(natOpen_slitasje_extr, "P:/41201785_okologisk_tilstand_2022_2023/data/cache/natOpen_slitasje_extr.rds")
```



It's easier to see what's happening if we zoom in a bit. Lets get a
boundary box around Trondheim.


```r
myBB <- st_bbox(c(xmin=260520.12, xmax = 278587.56,
                ymin = 7032142.5, ymax = 7045245.27),
                crs = st_crs(wetlands_slitasje_extr))
```

Cropping the data to the bbox


```r
wetlands_slitasje_extr_trd <- sf::st_crop(wetlands_slitasje_extr, myBB)
seminat_slitasje_extr_trd <- sf::st_crop(seminat_slitasje_extr, myBB)
natOpen_slitasje_extr_trd <- sf::st_crop(natOpen_slitasje_extr, myBB)
```


```r
myCol <- "RdYlGn"
tmap_arrange(
tm_shape(wetlands_slitasje_extr_trd)+
  tm_polygons(col = "w_mean",
    title="Slitasje indicator",
    palette = myCol,
    style="cont",
    breaks = c(0,1))+
  tm_layout(legend.outside = T)+
  tm_shape(hw_utm)+
  tm_lines(col="blue")+
  tm_layout(title = "Wetland"),

tm_shape(seminat_slitasje_extr_trd)+
  tm_polygons(col = "w_mean",
    title="Slitasje indicator",
    palette = myCol,
    style="cont",
    breaks = c(0,1))+
  tm_layout(legend.outside = T)+
  tm_shape(hw_utm)+
  tm_lines(col="blue")+
  tm_layout(title = "Semi-natural areas"),

tm_shape(natOpen_slitasje_extr_trd)+
  tm_polygons(col = "w_mean",
    title="Slitasje indicator",
    palette = myCol,
    style="cont",
    breaks = c(0,1))+
  tm_layout(legend.outside = T)+
  tm_shape(hw_utm)+
  tm_lines(col="blue")+
  tm_layout(title = "Naturally open areas"),
HIA_trd)
```

<div class="figure">
<img src="slitasje_files/figure-html/unnamed-chunk-87-1.png" alt="Slitasje indicator extrapolated over Trondheim" width="672" />
<p class="caption">(\#fig:unnamed-chunk-87)Slitasje indicator extrapolated over Trondheim</p>
</div>

There is some, but very little variation, both between the ecosystems
and between the four HIF classes in the modified infrastructure index.
Note however, that for wetland and semi-natural areas we did not
extrapolate values for the most urban areas, and that for naturally open
areas we did not extrapolate to the least affected areas.


> *The maps above are easy to misunderstand, and they should therefor be
> communicated with caution. They should be considered as temporary
> files or as by-products.*


Now, there are multiple way to proceed. We have

-   indicator maps (vector data), and we have

-   total HIA areas, and we have the

-   extrapolated indicator maps (HIA maps with aggregated indicator
    values and errors, also vector data).

-   We also have, for wetlands, an ecosystem type (ET) map.

Option 1:

1.  crop (i.e. intersect) the extrapolated indicator maps to ecosystem
    delineation maps, and then;

2.  aggregate these for each region or accounting area.

Step 1 above requires an st_interactions on two very large vector data
sets with millions of polygons. This should be avoided.

Option 2:

1.  rasterize the extrapolated indicator map, using the ET map as a
    template, and

2.  mask it using the perfectly aligned ET map.

This might be faster.

Option 3:

1.  Draw *n* random point samples from the ET map, and

2.  extract indicator values at those points (from the extrapolated
    indicator map (a stars object)).

This is perhaps even faster again. I will try the last option, even
though it will not provide spatially explicit indicator values for the
entire ecosystem delineation, like option 2 does. Perhaps I will revisit
option 2 later.

### Ecosystem map

Importing the wetland map.

This is a quite heavy operation and should be done on a server.


```r
mireET <- sf::st_read("/data/R/Kladd/Myr/Myrmodell.gdb")
```

This doesn't take that long.


```r
mireET <- st_transform(mireET, 25833)
```

This take about 10 min. Not sure I need it.


```r
mireET <- st_make_valid(mireET)
```

This takes a long!! time, and should be AVOIDED.


```r
wetlands_slitasje_extr_cropped <- sf::st_intersection(wetlands_slitasje_extr, mireET)
```

Instead I will draw some random point samples.


```r
wetland_points <- st_sample(mireET, 10000)
```

And intersect this with the extrapolated indicator values.


```r
wetland_points_match <- st_intersection(wetlands_slitasje_extr, wetland_points)
```

And extract the values


```r
wetland_points_extracted <- st_intersection(wetlands_slitasje_extr, wetland_points)
```

If we went for option 2, we could instead do something like this, and

create an empty grid over Norway, 50 x 50 m resolution

<!--# This we should perhaps do once, in a separate misc chapter, and make available for all chapters -->


```r
grd = st_as_stars(st_bbox(wetlands_slitasje_extr), dx = 50, dy = 50, values = NA_real_)
```

and then rasterize the indicator


```r
wetlands_slitasje_extr_rast <- st_rasterize(wetlands_slitasje_extr, grd)
```

To get a perfect alignment with the ET map, we should change `grd` with
the ET raster map.

Then we can use starts filtering with `[ .. ]` to mask out the areas
that do not belong to the ET.

### Aggregate to region

We need to aggreate the ET occurence and their indicator values, to a
regional delineation. This functionality will be developed in `eaTools`.
We need to produce distributions for the indicator valeus for each ET
occurrence (or groups of them) and resample the distributions wiht an
area weighting.

### Uncertainty

The calculations of indicator uncertainty is done with bootstrapping, as
is described in eaTools.

## Eksport files (final product)

According to the workflow specifications, I will export the indicator
map at its highest resolution, for use in various web interfaces etc.
For the finest resolution indicator map I will not include columns for
uncertainty (because this will only be estimated at the aggregated
level), or reference levels (because there is no spatial variation).

But I will also export a map of the indicator where we extrapolate the
indicator values to the homogeneous areas. This map should be
interpreted with caution, since they seem to provide explicit indicator
values for areas where there is no data. This map is mainly for
aggregation purposes. I will mark this map with the prefix
*homogeneous-areas*. I can also export this same mappen after masking it
with the ET map, and this output must come with the same discalimers.

Finally I will export a map of the five accounting areas with
wall-to-wall indicator value and errors. This map can also contain data
covering other ETs. Otherwise the maps would not we visually
interpretative.

### Slitasje in wetlands

Prepare export


```r
# keep col names short and standardized
exp_wetland <- ...
```


```r
exp_wetland_HIAextrapolated <- …
```


```r
exp_wetland_AAextrapolated <- …
```

Write to file


```r
st_write(exp_wetland, "indicators/indicatorMaps/slitasje/wetland_slitasje.shp",
         append = F)

st_write(exp_wetlandHIAextrapolated, 
         "indicators/indicatorMaps/extrapolated_to_homogeneous_areas/slitasje/homogeneous_areas_wetland_slitasje.shp",
         append = F)

st_write(exp_wetland, "indicators/indicatorMaps/extrapolated_to_accounting_areas/slitasje/accounting_areas_wetland_slitasje.shp",
         append = F)
```
