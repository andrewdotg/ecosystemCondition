# Nature types - Part 2 {#naturtype2}

**On the application of the naturetype dataset - Part 2 - Representativity **

<br />




Author: Anders L. Kolstad

Date: 2022-10-11

<br />


This chapter continues with the cleaned dataset exported at the end of the previous chapter:

```r
dat <- readRDS("/data/P-Prosjekter2/41201785_okologisk_tilstand_2022_2023/data/Mdir_Naturtyper_cleanedALK.rds")
```

## Naturetypes, condition variables, and their linkage to NiN main types
Only a subset of nature types are mapped. How well do these mapped units/areas represent the range of nature types that is included for each main ecosystem group? And what condition variables do we have available for each of these?

### Nature types
Lets extract the unique nature types, their associated main ecosystem, and the year when these nature types were mapped. 

We will only include our target ecosystems, and we will exclude *Hule eiker*.

```r
target <- c("Semi-naturlig mark",
            "Våtmark",
            "Naturlig åpne områder under skoggrensa")
dat <- dat[dat$hovedøkosystem %in% target,]
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
<div id="htmlwidget-386d6d0ca283958ce5c0" style="width:100%;height:auto;" class="datatables html-widget"></div>
<script type="application/json" data-for="htmlwidget-386d6d0ca283958ce5c0">{"x":{"filter":"none","vertical":false,"data":[["1","2","3","5","6","7","8","9","10","11","12","13","14","15","16","18","20","21","23","24","25","27","28","29","30","31","34","35","36","37","38","39","40","41","42","43","44","46","47","48","49","50","51","54","56","57","58","60","61","62","64","65","66"],["Slåttemark","Naturbeitemark","Kystlynghei","Slåttemyr","Boreal hei","Semi-naturlig eng","Strandeng","Hagemark","Semi-naturlig våteng","Sørlig slåttemyr","Semi-naturlig myr","Åpen flomfastmark","Svært tørkeutsatt sørlig kalkberg","Flommyr, myrkant og myrskogsmark","Isinnfrysingsmark","Eng-aktig sterkt endret fastmark","Høgereligende og nordlig nedbørsmyr","Åpen myrflate i boreonemoral til nordboreal sone","Semi-naturlig strandeng","Lauveng","Kalkrik helofyttsump","Kalkrik åpen jordvannsmyr i boreonemoral til nordboreal sone","Sørlig nedbørsmyr","Rik åpen sørlig jordvannsmyr","Rik åpen jordvannsmyr i mellomboreal sone","Fossepåvirket berg","Aktiv skredmark","Silt og leirskred","Nakent tørkeutsatt kalkberg","Terrengdekkende myr","Sørlig kaldkilde","Kystnedbørsmyr","Åpen grunnlendt kalkrik mark i boreonemoral sone","Kaldkilde under skoggrensa","Øyblandingsmyr","Atlantisk høymyr","Rik åpen jordvannsmyr i nordboreal og lavalpin sone","Sanddynemark","Fuglefjell-eng og fugletopp","Platåhøymyr","Fosseberg","Eksentrisk høymyr","Åpen grunnlendt kalkrik mark i sørboreal sone","Sørlig etablert sanddynemark","Sentrisk høgmyr","Tørt kalkrikt berg i kontinentale områder","Fosse-eng","Sørlig strandeng","Øvre sandstrand uten pionervegetasjon","Kanthøymyr","Palsmyr","Konsentrisk høymyr","Åpen myrflate i lavalpin sone"],["2018, 2019, 2020, 2021","2018, 2019, 2020, 2021","2018, 2019, 2020, 2021","2018, 2019, 2020, 2021","2018, 2019, 2020, 2021","2018, 2019, 2020, 2021","2018, 2019, 2020, 2021","2018, 2019, 2020, 2021","2018, 2019, 2020, 2021","2019, 2020, 2021","2019, 2020, 2021","2018, 2019, 2020, 2021","2019, 2020, 2021","2018","2018, 2019, 2020, 2021","2018, 2019, 2020, 2021","2019, 2020, 2021","2018","2018, 2019, 2020, 2021","2019, 2020","2019, 2020, 2021","2018","2019, 2020, 2021","2018, 2019, 2020, 2021","2019, 2020, 2021","2019, 2020, 2021","2019, 2020, 2021","2019, 2020, 2021","2018, 2019, 2020, 2021","2019, 2020, 2021","2018, 2019, 2020, 2021","2018","2018, 2019, 2020, 2021","2018","2019, 2020, 2021","2019, 2020, 2021","2018, 2019, 2020, 2021","2018, 2019, 2020, 2021","2019, 2020, 2021","2019, 2020, 2021","2021","2019, 2020, 2021","2019, 2020, 2021","2018, 2019, 2020, 2021","2018","2019","2019, 2020","2018","2019, 2020, 2021","2019, 2020, 2021","2021","2019, 2020","2018"],["Semi-naturlig mark","Semi-naturlig mark","Semi-naturlig mark","Våtmark","Semi-naturlig mark","Semi-naturlig mark","Naturlig åpne områder under skoggrensa","Semi-naturlig mark","Våtmark","Våtmark","Våtmark","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Våtmark","Naturlig åpne områder under skoggrensa","Semi-naturlig mark","Våtmark","Våtmark","Semi-naturlig mark","Semi-naturlig mark","Våtmark","Våtmark","Våtmark","Våtmark","Våtmark","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Våtmark","Våtmark","Våtmark","Naturlig åpne områder under skoggrensa","Våtmark","Våtmark","Våtmark","Våtmark","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Våtmark","Naturlig åpne områder under skoggrensa","Våtmark","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Våtmark","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Våtmark","Våtmark","Våtmark","Våtmark"]],"container":"<table class=\"display\">\n  <thead>\n    <tr>\n      <th> <\/th>\n      <th>Nature_type<\/th>\n      <th>Year<\/th>\n      <th>Ecosystem<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"order":[],"autoWidth":false,"orderClasses":false,"columnDefs":[{"orderable":false,"targets":0}]}},"evals":[],"jsHooks":[]}</script>
```

<p class="caption">(\#fig:unnamed-chunk-9)List of nature types showing the years when that nature type was mapped.</p>
</div>

The way to do this I think is to look at each nature type in turn and map the NiN main types and sub-types that they cover. At the same time I can extract the NiN variables and values to see how they distribute over the NiN main types.


### NiN variables


```r
#Exclude non-relevant types
dat2 <- dat[dat$naturtype %!in% excl_nt,]

# Melt
dat2L <- tidyr::separate_rows(dat2, ninbeskrivelsesvariabler, sep=",")

# Split the code and the value into separate columns
dat2L <- tidyr::separate(dat2L, 
                              col = ninbeskrivelsesvariabler,
                              into = c("NiN_variable_code", "NiN_variable_value"),
                              sep = "_",
                              remove=F
                              )
#> Warning: Expected 2 pieces. Missing pieces filled with `NA`
#> in 1 rows [280973].
# One NA produced here, but I check it, and it's fine.

# Convert values to numeric. This causes some NA's which I will go through below
dat2L$NiN_variable_value <- as.numeric(dat2L$NiN_variable_value)
#> Warning: NAs introduced by coercion
```

Here are all the Nin variable codes:

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
When I now go through the variable codes separately I will also judge if these NA's are real, or if they for example should be coded as zeros or something.

#### 1AG-A (sjiktdekningsvariabler)
These are different variables describing the cover in different vegetation strata and/or species

* 1AG-A-0 = Total tre canopy cover
* 1AG-B = Total shrub cover
* 1AG-C = Total field layer cover
* 1AG-A-E = 'Overstandere'
* 1AG-A-G = 'gjenveksttrær'


#### 1AR-C-L (Andel vedvekster i fletsjiktet)
A condition variable in some mire nature types

#### 3TO (Torvmarksformer)
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


#### 4DL (Coarse dead wood)
4DL-SS-0 and 4DL-S-0 has to do with the total amount of coarse woody debris/logs. It was only recorded for one nature type in 2018, and then as a a biodiversity variable, and not a state variable. Biodiversity variables were only recorded when condition was better than *very poor*. This bias means we cannot use these variables.


```r
exclude <- c(exclude,
             "4DL-SS-0",
             "4DL-S-0")
```

> Biodiversity variables were only recorded when condition was better than *very poor*. This bias means we cannot use these variables.


#### 4TG (old trees)

These three variables are used as biodiveristy variables in  2018 (exclude).

```r
exclude <- c(exclude,
             "4TG-BL",
             "4TG-EL",
             "4TG-GF")
```


#### 4TL (trees with fire scars)
These five variables are used together with 4TG as biodiversity variables in 2018.

```r
exclude <- c(exclude,
             "4TL-BS",
             "4TL-HE",
             "4TL-HL",
             "4TL-RB",
             "4TL-SB")
```

#### 5AB and 5BY (arealbruksklasser og byggningstyper)
These area land use types and building types, respectively, and the values are not numeric, but categorical, and represents presence or absence of these land uses or objects. These are not suited for automatically determining ecosystem condition as this is done subjectively in the field.

```r
exclude <- c(exclude,
             "5AB-0",
             "5AB-DO-TT",
             "5BY-0"
             )
```

#### 6SE and 6SO (Bioclimatical sections and sones)
Not relevant here as condition variables.

```r
exclude <- c(exclude,
             "6SE",
             "6SO")
```

#### 7FA (fremmedartsinnslag)
Should not have been allowed the value X, so Ok to exclude these.
7FA also has potentially an issue related to how the NiN-app as build which doesn't allow for registering alien species that are not on the *fremmedartsliste*.  

#### 7GR-GI
7GR-GI (grøftingsintensitet) should not have the value X either, so OK to exclude these NA's. But we keep the variable, even though its clearly a pressure indikator, we might want to use it as a surrogate for mire hydrology.

#### 7JB-KU (Kystlyngheias utviklingsfaser)

* BY = byggefase
* DE = degenereringsfase
* MO = moden fase
* PI = pionerfase

This variable is used as in the biodiversity assessment, and can therefore not be used in the condition assessment because localities with *very poor* conditions have not been mapped/assessed.

```r
exclude <- c(exclude, 
             "7JB-KU-BY", 
             "7JB-KU-DE", 
             "7JB-KU-MO", 
             "7JB-KU-PI")
```

I will nonetheless explore this variable a bit more.
NiN defines the possible values for these as numeric between 0 and 4 (shifted to become 1-5 in the dataset), but there are 544 cases where it has been given then value *X*.

```r
temp <- dat2L[dat2L$ninbeskrivelsesvariabler == "7JB-KU-BY_X" |
                     dat2L$ninbeskrivelsesvariabler == "7JB-KU-DE_X" |
                dat2L$ninbeskrivelsesvariabler == "7JB-KU-MO_X" |
                     dat2L$ninbeskrivelsesvariabler == "7JB-KU-PI_X",]
table(temp$kartleggingsår, temp$naturtype)
#>       
#>        Kystlynghei
#>   2018         437
#>   2019          27
#>   2020           9
#>   2021          64
```

The reason could be that this variable is used in the biodiversity assessment, which is not performed if the condition is *very poor*.

```r
table(temp$tilstand)
#> 
#>  Dårlig     God Moderat 
#>      96      57     384
```
That is not the case: If the condition is scored as low, the variable does not even appear in the data set for that locality.

We can also make a note that a big proportion of the total number of localities of *Kystlynghei* had very poor condition, and therefore this variable 7JB-KU was not recorded in a large proportion of the localities.

```r
KU <- dat2[dat2$naturtype=="Kystlynghei",]
barplot(table(KU$tilstand))
```

<div class="figure">
<img src="naturtype2_files/figure-html/unnamed-chunk-22-1.png" alt="The distribution of condition scores for Kystlynghei." width="672" />
<p class="caption">(\#fig:unnamed-chunk-22)The distribution of condition scores for Kystlynghei.</p>
</div>

Each *kystlynghei* locality should have values for all four parameters (7BA-BY/DE/MO/PI), but if we look at some cases in more detail, to understand why some of these values have been set as X (probably means they were left blank), for example like this:

```r
#View(dat2L[dat2L$NiN_variable_code == "7JB-KU-BY" & is.na(dat2L$NiN_variable_value),])
#View(dat2L[dat2L$identifikasjon_lokalid =="NINFP1810002975",]) # None of the 7JB-KU variables have values
#View(dat2L[dat2L$identifikasjon_lokalid =="NINFP2110057689",]) # Two of the 7JB-KU variables have values
```
 ... we can see that sometimes <4 but >0 of the variables/phases has been given a score, but sometimes none have. This makes it problematic to set these NA's to be zeros. When we also consider the fact that there is an obvious bias in that only localities with poor condition or better have these variables assessed in the first place, I will exclude all of these variables and treat them as *not suited*.

#### 7JB-BA (Aktuell bruksintensitet)
A common condition variable in semi-natural nature types. It's a borderline pressure indicator, but I will keep it in the data set for now at least.

Overview of cases where the value is set as *X*.

```r
temp <- dat2L[dat2L$ninbeskrivelsesvariabler == "7JB-BA_X",]
table(temp$kartleggingsår, temp$naturtype)
#>       
#>        Hagemark Semi-naturlig eng Semi-naturlig strandeng
#>   2018        0                 0                       0
#>   2021        1                 1                       1
#>       
#>        Strandeng
#>   2018        27
#>   2021         0
```
These are just a few cases, mostly from 2018. OK to treat as NA.

#### 7JB-BT (Beitetrykk)
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

#### 7JB-GJ (Gjødsling)
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

This variable is used as a condition indicator, but this could be questioned. Firstly, it is a pressure indicator. Secondly, many semi-natural areas where fertilized, also in the reference condition. The people that made the meadows would probably not agree that a productive field/meadow has poor condition. This condition variable is therefor more directly tuned towards the maintenance of biodiversity.


#### 7JB-HT (Høsting av tresjiktet)
Used for *Lauveng* in 2019 and 2020.

```r
temp <- dat2L[dat2L$NiN_variable_code == "7JB-HT-ST" | 
               dat2L$NiN_variable_code == "7JB-HT-SL" ,]
table(temp$kartleggingsår, temp$naturtype)
#>       
#>        Lauveng
#>   2019      14
#>   2020       6
```
This is so marginal that I will exclude these already now.

```r
exclude <- c(exclude,
             "7JB-HT-SL",
             "7JB-HT-ST")
```

#### 7RA-BH and 7RA-SJ (rask suksesjon i boreal hei og i i semi-naturlig og sterkt endret jordbruksmark inkludert våteng)
Condition variables.
There are some very few cases where 7RA-SJ has the value X. It should be numeric 1-4, so the value X is a mistake here I think. We can exclude these (i.e. allow them to be NA's).

#### 7SD-0 and 7SD- NS (Natur- og normalskogsdynamikk)
7SD-NS and 7SD-0 was also only used for only one nature type (which is not forest), and then only for wooded localities of *Flommyr, myrkant og myrskogsmark*. *X* therefore means *not relevant*, and we can also exclude the parameters from the dataset all together.


```r
exclude <- c(exclude, 
             "7SD-0",     
             "7SD-NS")
```

#### 7TK and 7SE (kjørespor & slitasje)
7TK (kjørespor) and 7SE (slitasje) are not allowed the value X, but it happened on some rare occasions (24) anyhow. It's fine to treat these as NA's.

#### 7VR-RI (Reguleringsintensitet)
This variable is defined as numeric between 1-5. There is, however, quite a few cases where it is X.

```r
temp <- dat2L[dat2L$ninbeskrivelsesvariabler == "7VR-RI_X",]
table(temp$kartleggingsår, temp$naturtype)
#>       
#>        Åpen flomfastmark
#>   2019                96
#>   2021                11
```
I cannot explain these, but in any case, this variable is not a good indicator for condition as it rather represents a pressure/driver. So OK to treat as NA's.

#### LKMs and MdirPR-variables
These variables include LKM's (lokal kompleks miljøvariabel) which are nonrelevant to us here. We can also exclude some of the PR- variables, which are the NEAs own variables (not NiN). 

* LKMKI
    + Kalk (lime)
    + Exclude
* LKMSP
    + Slåttemarkspreg
    + Exclude
* PRAK
    + Antall NiN-kartleggingsenheter
    + Used in the biodiversity assessment
    + Exclude
* PRAM
    + Menneskeskapte objekter
    + Related to 5BY and 5AB
    + Exclude (see 5BY and 5AB)
* PRH
    + This is perhaps a mistake and should be PRHA or PRHT
    + Exclude
* PRHA
    + Habitat spesifikke arter
    + Used in the biodiversity assessment
    + Exclude
* PRHT
    + Høsting av tresjiktet
    + Include
* PRKA
    + Kalkindikatorer
    + Used in the biodiversity assessment
    + Exclude
* PRKU
    + Kystlyngheias utviklingsfaser
    + Related to 7JB-KU
    + Used in the biodiversity assessment
    + Exclude
* PRMY
    + Myrstruktur
    + Used in the biodiversity assessment
    + Exclude
* PRRL-CR/DD/EN/NT/VU
    + Red list categories
    + Used in the biodiversity assessment
    + Exclude
* PRSE-KA
    + Strukturer, elementer og torvmarksformer (in 2018)
    + See PRSE-PA
* PRSE-PA
    + Strukturer, elementer og torvmarksformer
    + Used in the biodiversity assessment
    + Exclude
* PRSE-SH
    + Strukturer, elementer og torvmarksformer (in 2018)
    + See PRSE-PA
* PRSL
    + Slitasje
    + Rlated to 7SE
    + Include
* PRTK
    + Spor av tunge kjøretøyer
    + Related to 7TK
    + Include
* PRTO
    + Torvuttak
    + Include
* PRVS
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


### Subset

```r
dat2L2 <- dat2L[!is.na(dat2L$NiN_variable_value),]
dat2L2 <- dat2L2[dat2L2$NiN_variable_code %!in% exclude,]
length(unique(dat2L2$NiN_variable_code))
#> [1] 20
```
Now we are down to 20 possible condition variables.

I will also now exclude nature types that were only mapped in 2018 and/or 2019 and not after that. These nature types will not only not get more data in the future, but also they were mapped in a time when the methodology was quite unstable. 


```r
ntypDF2 <- ntypDF[ntypDF$Year != "2018" &
                  ntypDF$Year != "2019" & 
                  ntypDF$Year != "2018, 2019"# no types were mappend in 2018 & 2019 only
                  ,]
```

### Fill inn ntypDF2 
Next I want to expand ntypDF2 to include the NiN main types covered by the different nature types. I cannot use the field data for this, because there are so many mistakes in the data. I need to look at the definition of each nature type and get the NiN code from there. I could also extract the NiN sub types (grunntyper), but it would become too messy. Therefor I will create a second column with a textual/categorical description of the degree of themaic coverage.

I will look at the definitions of the nature type in the first and last year when that type was mapped, but not for the years in between.

#### Add NiN main type and degree of representativity

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

#### Add NiN variables


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
#> 3             1AG-A-0                 34
#> 16            1AG-A-0                314
#> 28            1AG-A-0                  1
#> 69            1AG-A-E               1383
#> 79            1AG-A-E                 10
#> 144           1AG-A-G                690
```

Add a column for the total number of localities for each nature type and get the percentage of localities where each NiN has been recorded.

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

This data set contains the nature types that were only mapped in 2018 or 2019, and which we removed from ntypDF2:

```r
ntyp_vars_wide$Nature_type[ntyp_vars_wide$Nature_type %!in% ntypDF2$Nature_type]
#> [1] Åpen myrflate i boreonemoral til nordboreal sone            
#> [2] Åpen myrflate i lavalpin sone                               
#> [3] Flommyr, myrkant og myrskogsmark                            
#> [4] Kaldkilde under skoggrensa                                  
#> [5] Kalkrik åpen jordvannsmyr i boreonemoral til nordboreal sone
#> [6] Kystnedbørsmyr                                              
#> [7] Sentrisk høgmyr                                             
#> [8] Sørlig strandeng                                            
#> [9] Tørt kalkrikt berg i kontinentale områder                   
#> 53 Levels: Aktiv skredmark ... Tørt kalkrikt berg i kontinentale områder
```

So we should remove them also here.

```r
ntyp_vars_wide <- ntyp_vars_wide[ntyp_vars_wide$Nature_type %in% ntypDF2$Nature_type]
```

Combine datasets

```r
ntyp_fill <- cbind(ntypDF2, ntyp_vars_wide[,-1][match(ntypDF2$Nature_type, ntyp_vars_wide$Nature_type)])
```


#### Add number of location and total area mapped

```r
dat2$km2 <- units::drop_units(dat2$area/10^6)

num <- as.data.frame(dat2) %>%
  group_by(naturtype)%>%
  summarise(km2 = sum(km2),
            numberOfLocalities = n())

ntyp_fill <- cbind(ntyp_fill, num[,-1][match(ntyp_fill$Nature_type, num$naturtype),])
```



## Plots


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
<img src="naturtype2_files/figure-html/unnamed-chunk-43-1.png" alt="The total mapped area for nature types associated with three selected main ecosystems" width="672" />
<p class="caption">(\#fig:unnamed-chunk-43)The total mapped area for nature types associated with three selected main ecosystems</p>
</div>



### Area per NiN main type conditioned on ecosystem and adding empty main types
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
ntyp_fill2 <- ntyp_fill %>%
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
  mutate(NiN_mainType = fct_reorder(NiN_mainType, km2)) %>%
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
<img src="naturtype2_files/figure-html/unnamed-chunk-50-1.png" alt="The areas mapped for each NiN main type, and the degree of spatial representativity (or coverage) of the mapping units (nature types). V6 Våtsnøleie og snøleiekilde is not included." width="672" />
<p class="caption">(\#fig:unnamed-chunk-50)The areas mapped for each NiN main type, and the degree of spatial representativity (or coverage) of the mapping units (nature types). V6 Våtsnøleie og snøleiekilde is not included.</p>
</div>

From the figure above I take that *Naturlig åpne områder* is very poorly represented in general, and that there are many NiN main types that are completely missing from the dataset. The three most common types, however, have complete thematic coverage (if excluding the year 2018 and including all sub-types). I will need to investigate if there are some NiN variables for the nature types mapping T18 Åpen flomfastmark, T12 Strandeng and T21 Sanddynemark which we can use.

For *Semi-naturlig mark* we have quite good thematic coverage for the three main types. The other three types probably makes up a considerably smaller area, but note that T33 has some coverage, and is classes as *all (-2018)*. Of the three main ecosystems, semi-naturlig mark dominates clearly. I will need to look for NiN variables associated with the mapping units for these main NiN types. I can also possibly explore the distribution of the mapped polygons in environmental space and compare it against AR5 as a reference, but I'm not sure how good AR5 is for anything whihc is not cropland.

For *Våtmark* we have good thematic coverage for V3 nedbørsmyr and V9 semi-naturlig myr, but for V1 åpen jordvassmyr only calcareous localities are mapped and assessed. A question is then whether, for a given NiN variable, that calcareous localities can be representative for all mires (poor and rich) or if this will intruduce too much bias in one way or another. 


### For each NiN main type, the proportion mapped with each NiN variable


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
<img src="naturtype2_files/figure-html/unnamed-chunk-52-1.png" alt="Barplot showing the proportion area for which each NiN variable is recorded. The total mapped area for each main ecosystem (the facets) is shown as a dashed red line. The three most dominant NiN main types for each ecosystem is given a uniqe colour, and all the remaining are grouped as 'other'." width="672" />
<p class="caption">(\#fig:unnamed-chunk-52)Barplot showing the proportion area for which each NiN variable is recorded. The total mapped area for each main ecosystem (the facets) is shown as a dashed red line. The three most dominant NiN main types for each ecosystem is given a uniqe colour, and all the remaining are grouped as 'other'.</p>
</div>

## Tentative conclusions and the way forward
This figure, in combination with the above, points to he most obvious NiN variable candidates. 

7SE and 7TK are good candidates for *Naturlig åpne områder*. 7JA-BT is probably more appropriately classed as a pressure indicator. Same with 7VR-RI with is recorded for all T18 localities. 
7FA has potentially an issue related to how the NiN-app as build which doesn't allow for registering alien species that are not on the *fremmedartsliste*.  

The same two variables (7SE and 7TK) are the best candidates also for *Semi-natural areas*. 7JB-BT is a pressure variable (*beitetrykk*). 7RA-SJ/BH are related to *gjengoing* which will be covered by another indicator informed from remote sensing (LiDAR), and we therefor don't need to describe this with a field-based indicator as well.

For *Våtmark*, 7GR-Gi is the most common variables, but this is a pressure variable (*grøfting*). But, perhaps it could be used as a surrogate indicator. I think this is justifiable, especially since the relationship between the pressure (grøfting) and the condition (hydrology) is so well known. 7SE and 7TK+PRTK are other candidates. PRTO is only relevant for V3, but covers a relatively large area.

Next, I will focus in *Våtmark*-variables, since here we can use a new ecosystem delineation map as a reference to evaluate the environamlental and spatial bias in the dataset. This is not currently possible for the other two ecosystems.  

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
<div id="htmlwidget-09f8d99b6545f28b8ddb" style="width:100%;height:auto;" class="datatables html-widget"></div>
<script type="application/json" data-for="htmlwidget-09f8d99b6545f28b8ddb">{"x":{"filter":"none","vertical":false,"data":[["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45"],["Slåttemark","Naturbeitemark","Kystlynghei","Slåttemyr","Boreal hei","Semi-naturlig eng","Strandeng","Hagemark","Semi-naturlig våteng","Sørlig slåttemyr","Semi-naturlig myr","Åpen flomfastmark","Svært tørkeutsatt sørlig kalkberg","Isinnfrysingsmark","Eng-aktig sterkt endret fastmark","Høgereligende og nordlig nedbørsmyr","Semi-naturlig strandeng","Lauveng","Kalkrik helofyttsump","Sørlig nedbørsmyr","Rik åpen sørlig jordvannsmyr","Rik åpen jordvannsmyr i mellomboreal sone","Fossepåvirket berg","Aktiv skredmark","Silt og leirskred","Nakent tørkeutsatt kalkberg","Terrengdekkende myr","Sørlig kaldkilde","Åpen grunnlendt kalkrik mark i boreonemoral sone","Øyblandingsmyr","Atlantisk høymyr","Rik åpen jordvannsmyr i nordboreal og lavalpin sone","Sanddynemark","Fuglefjell-eng og fugletopp","Platåhøymyr","Fosseberg","Eksentrisk høymyr","Åpen grunnlendt kalkrik mark i sørboreal sone","Sørlig etablert sanddynemark","Fosse-eng","Øvre sandstrand uten pionervegetasjon","Kanthøymyr","Palsmyr","Konsentrisk høymyr",null],["2018, 2019, 2020, 2021","2018, 2019, 2020, 2021","2018, 2019, 2020, 2021","2018, 2019, 2020, 2021","2018, 2019, 2020, 2021","2018, 2019, 2020, 2021","2018, 2019, 2020, 2021","2018, 2019, 2020, 2021","2018, 2019, 2020, 2021","2019, 2020, 2021","2019, 2020, 2021","2018, 2019, 2020, 2021","2019, 2020, 2021","2018, 2019, 2020, 2021","2018, 2019, 2020, 2021","2019, 2020, 2021","2018, 2019, 2020, 2021","2019, 2020","2019, 2020, 2021","2019, 2020, 2021","2018, 2019, 2020, 2021","2019, 2020, 2021","2019, 2020, 2021","2019, 2020, 2021","2019, 2020, 2021","2018, 2019, 2020, 2021","2019, 2020, 2021","2018, 2019, 2020, 2021","2018, 2019, 2020, 2021","2019, 2020, 2021","2019, 2020, 2021","2018, 2019, 2020, 2021","2018, 2019, 2020, 2021","2019, 2020, 2021","2019, 2020, 2021","2021","2019, 2020, 2021","2019, 2020, 2021","2018, 2019, 2020, 2021","2019, 2020","2019, 2020, 2021","2019, 2020, 2021","2021","2019, 2020",null],["Semi-naturlig mark","Semi-naturlig mark","Semi-naturlig mark","Våtmark","Semi-naturlig mark","Semi-naturlig mark","Naturlig åpne områder under skoggrensa","Semi-naturlig mark","Våtmark","Våtmark","Våtmark","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Semi-naturlig mark","Våtmark","Semi-naturlig mark","Semi-naturlig mark","Våtmark","Våtmark","Våtmark","Våtmark","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Våtmark","Våtmark","Naturlig åpne områder under skoggrensa","Våtmark","Våtmark","Våtmark","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Våtmark","Naturlig åpne områder under skoggrensa","Våtmark","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Våtmark","Våtmark","Våtmark","Semi-naturlig mark"],["T32","T32","T34","V9","T31","T32","T12","T32","V10","V9","V9","T18","T1","T20","T41","V3","T33","T32","L4","V3","V1","V1","T1","T17","T17","T1","V3","V4","T2","V1","V3","V1","T21","T8","V3","T1","V3","T2","T21","T15","T29","V3","V3","V3","T40"],["all (if including sub-types)","all (if including sub-types)","all","all (if including sub-types)","all","all (if including sub-types)","all (-2018)","all (if including sub-types)","all (-2018)","all (if including sub-types)","all (if including sub-types)","all","calcareous and dry","all","all","all (if including sub-types)","all (-2018)","all (if including sub-types)","calcareous","all (if including sub-types)","calcareous","calcareous","extra wet","all (if including sub-types)","all (if including sub-types)","calcareous and dry","all (if including sub-types)","southern","calcareous","partial","all (if including sub-types)","calcareous","all (if including sub-types)","all","all (if including sub-types)","extra wet","all (if including sub-types)","calcareous","all (if including sub-types)","all","sandy and vegetated","all (if including sub-types)","all (if including sub-types)","all (if including sub-types)","Not mapped"],[null,0,null,null,null,null,null,18.5,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,8.5,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],[null,null,null,null,null,null,null,81.4,null,null,null,null,null,null,null,null,null,100,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],[null,null,null,100,null,null,null,null,null,100,100,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],[null,null,null,100,null,null,null,null,null,100,100,null,null,null,null,null,null,null,100,null,null,null,null,null,null,null,null,null,99.7,null,null,null,null,null,null,null,null,100,null,null,null,null,null,null,null],[null,0,null,null,null,null,null,18.4,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],[null,null,null,42.9,null,null,null,null,null,39.1,36.4,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],[99.8,99.9,99.9,7,100,99.9,99.9,99.9,99.8,null,null,65.9,100,null,100,null,98.8,100,100,null,100,100,null,null,null,100,null,null,99.7,null,null,5.6,100,null,null,null,null,100,100,null,100,null,null,null,null],[null,null,null,99.8,null,null,null,null,null,100,100,null,null,null,null,99.7,null,null,100,100,98.9,100,null,null,null,null,100,98.4,null,100,100,94.4,null,null,100,null,100,null,null,null,null,100,100,100,null],[99.9,100,null,null,null,99.9,2.5,100,100,null,null,null,null,null,100,null,98.6,100,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],[null,null,100,null,100,null,null,null,null,null,null,88.1,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,98.9,100,null,null,null,null,100,100,100,null,null,null,null],[98.5,99.7,null,null,null,99.2,null,99.8,99.7,null,null,null,null,null,99.3,null,null,100,null,null,null,null,null,null,null,null,null,null,null,null,null,null,98.9,null,null,null,null,null,100,null,100,null,null,null,null],[null,null,0,null,100,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],[99.9,100,100,null,null,99.9,1.8,99.9,100,null,null,null,null,null,99.3,null,98.5,100,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],[null,null,46.8,7,32.2,null,99.8,null,null,null,null,88.3,100,88.9,99.6,99.7,16.8,null,null,100,100,100,100,null,null,100,100,9.6,99.5,100,100,100,100,100,100,null,100,100,100,100,100,100,100,100,null],[null,null,52.7,100,67.7,null,99.9,null,null,100,100,88.2,null,88.9,null,null,null,null,100,null,17.2,null,null,100,100,14.4,null,null,99.5,null,null,5.6,100,null,null,null,null,100,100,100,100,null,null,null,null],[null,null,null,null,null,null,null,null,null,null,null,92.7,null,null,null,null,null,null,null,null,null,null,100,null,null,null,null,null,null,null,null,null,null,null,null,100,null,null,null,100,null,null,null,null,null],[null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,100,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],[null,null,null,93,null,null,null,null,null,100,100,null,null,null,null,null,82.2,null,100,null,null,null,null,null,null,null,null,90.4,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],[null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,99.7,null,null,null,100,82.8,100,null,null,null,null,100,null,null,100,100,94.4,null,null,100,null,100,null,null,null,null,100,100,100,null],[null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,99.7,null,null,null,100,null,null,null,null,null,null,100,null,null,null,100,null,null,null,100,null,100,null,null,null,null,100,null,100,null],[6.51584984635486,101.157651296768,292.557561273423,8.27830107117764,246.548913168032,24.1378829753629,3.91436662946879,12.7470244867466,4.78652942499085,0.849630753543558,6.96108525449375,9.36280193293499,0.071410719661491,0.0172138593255082,1.08675716726274,10.207169261258,2.96586845672123,0.0261538296666823,1.80578507215338,10.1804888804028,3.98667212063541,6.35196862448222,0.0239538364559004,0.403836633998744,0.0206596222076445,1.15246880725175,8.05259984558393,0.0513355806964453,0.586466434293955,0.634348890980364,1.83310286127818,0.211277539917457,1.86117337890082,0.248655085415105,1.94164206032561,0.00792215845906082,3.38289475080095,0.131233493150285,0.235053981613827,0.00237313203080123,0.0165918400637099,0.0634907575625052,0.0493092192310363,0.148078327467059,0],[1531,9208,6058,546,4610,3230,1302,1700,961,133,690,1483,59,9,546,299,865,10,241,701,746,782,19,153,34,291,254,125,399,54,80,54,263,20,46,11,75,100,51,3,19,13,6,4,null]],"container":"<table class=\"display\">\n  <thead>\n    <tr>\n      <th> <\/th>\n      <th>Nature_type<\/th>\n      <th>Year<\/th>\n      <th>Ecosystem<\/th>\n      <th>NiN_mainType<\/th>\n      <th>NiN_mainTypeCoverage<\/th>\n      <th>1AG-A-0<\/th>\n      <th>1AG-A-E<\/th>\n      <th>1AG-A-G<\/th>\n      <th>1AG-B<\/th>\n      <th>1AG-C<\/th>\n      <th>1AR-C-L<\/th>\n      <th>7FA<\/th>\n      <th>7GR-GI<\/th>\n      <th>7JB-BA<\/th>\n      <th>7JB-BT<\/th>\n      <th>7JB-GJ<\/th>\n      <th>7RA-BH<\/th>\n      <th>7RA-SJ<\/th>\n      <th>7SE<\/th>\n      <th>7TK<\/th>\n      <th>7VR-RI<\/th>\n      <th>PRHT<\/th>\n      <th>PRSL<\/th>\n      <th>PRTK<\/th>\n      <th>PRTO<\/th>\n      <th>km2<\/th>\n      <th>numberOfLocalities<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"scrollX":true,"scrollY":true,"pageLength":10,"columnDefs":[{"className":"dt-right","targets":[6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27]},{"orderable":false,"targets":0}],"order":[],"autoWidth":false,"orderClasses":false}},"evals":[],"jsHooks":[]}</script>
```

<p class="caption">(\#fig:unnamed-chunk-53)List of 45 nature types additionam data, including the proportion of localities for which there is data for each of the NiN variables.</p>
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
<div id="htmlwidget-a52785cc86204aa430c3" style="width:100%;height:auto;" class="datatables html-widget"></div>
<script type="application/json" data-for="htmlwidget-a52785cc86204aa430c3">{"x":{"filter":"none","vertical":false,"data":[["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59","60","61","62","63","64","65","66","67","68","69","70","71","72","73","74","75","76","77","78","79","80","81","82","83","84","85","86","87","88","89","90","91","92","93","94","95"],["1AG-A-0","1AG-A-0","1AG-A-E","1AG-A-G","1AG-B","1AG-B","1AG-B","1AG-C","1AR-C-L","7FA","7FA","7FA","7FA","7FA","7FA","7FA","7FA","7FA","7FA","7FA","7FA","7FA","7FA","7FA","7GR-GI","7GR-GI","7GR-GI","7GR-GI","7GR-GI","7JB-BA","7JB-BA","7JB-BA","7JB-BA","7JB-BA","7JB-BT","7JB-BT","7JB-BT","7JB-BT","7JB-BT","7JB-BT","7JB-BT","7JB-GJ","7JB-GJ","7JB-GJ","7JB-GJ","7JB-GJ","7RA-BH","7RA-SJ","7RA-SJ","7RA-SJ","7RA-SJ","7RA-SJ","7RA-SJ","7SE","7SE","7SE","7SE","7SE","7SE","7SE","7SE","7SE","7SE","7SE","7SE","7SE","7SE","7SE","7SE","7SE","7TK","7TK","7TK","7TK","7TK","7TK","7TK","7TK","7TK","7TK","7TK","7TK","7TK","7TK","7VR-RI","7VR-RI","7VR-RI","PRHT","PRSL","PRSL","PRSL","PRSL","PRTK","PRTK","PRTO"],["Naturlig åpne områder under skoggrensa","Semi-naturlig mark","Semi-naturlig mark","Våtmark","Naturlig åpne områder under skoggrensa","Våtmark","Våtmark","Semi-naturlig mark","Våtmark","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Semi-naturlig mark","Semi-naturlig mark","Semi-naturlig mark","Semi-naturlig mark","Semi-naturlig mark","Våtmark","Våtmark","Våtmark","Våtmark","Våtmark","Våtmark","Våtmark","Våtmark","Våtmark","Naturlig åpne områder under skoggrensa","Semi-naturlig mark","Semi-naturlig mark","Semi-naturlig mark","Våtmark","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Semi-naturlig mark","Semi-naturlig mark","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Semi-naturlig mark","Semi-naturlig mark","Våtmark","Semi-naturlig mark","Naturlig åpne områder under skoggrensa","Semi-naturlig mark","Semi-naturlig mark","Semi-naturlig mark","Semi-naturlig mark","Våtmark","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Semi-naturlig mark","Semi-naturlig mark","Semi-naturlig mark","Semi-naturlig mark","Våtmark","Våtmark","Våtmark","Våtmark","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Semi-naturlig mark","Semi-naturlig mark","Våtmark","Våtmark","Våtmark","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Naturlig åpne områder under skoggrensa","Semi-naturlig mark","Semi-naturlig mark","Våtmark","Våtmark","Våtmark","Våtmark","Våtmark","Våtmark"],["T2","T32","T32","V9","T2","L4","V9","T32","V9","T1","T12","T18","T2","T21","T29","T31","T32","T33","T34","T41","L4","V1","V10","V9","L4","V1","V3","V4","V9","T12","T32","T33","T41","V10","T15","T18","T21","T29","T8","T31","T34","T21","T29","T32","T41","V10","T31","T12","T32","T33","T34","T41","V10","T1","T12","T15","T18","T2","T20","T21","T29","T8","T31","T33","T34","T41","V1","V3","V4","V9","T1","T12","T15","T17","T18","T2","T20","T21","T29","T31","T34","L4","V1","V9","T1","T15","T18","T32","T33","L4","V4","V9","V1","V3","V3"],[0.586466434293955,12.7470244867466,12.7731783164133,16.089017079215,0.71769992744424,1.80578507215338,16.089017079215,12.7470244867466,16.089017079215,1.22387952691324,3.91436662946879,9.36280193293499,0.71769992744424,2.09622736051465,0.0165918400637099,246.548913168032,144.584562434899,2.96586845672123,292.557561273423,1.08675716726274,1.80578507215338,10.5499182850351,4.78652942499085,8.27830107117764,1.80578507215338,11.1842671760155,35.8587759639101,0.0513355806964453,16.089017079215,3.91436662946879,144.584562434899,2.96586845672123,1.08675716726274,4.78652942499085,0.00237313203080123,9.36280193293499,2.09622736051465,0.0165918400637099,0.248655085415105,246.548913168032,292.557561273423,2.09622736051465,0.0165918400637099,144.584562434899,1.08675716726274,4.78652942499085,246.548913168032,3.91436662946879,144.584562434899,2.96586845672123,292.557561273423,1.08675716726274,4.78652942499085,1.24783336336914,3.91436662946879,0.00237313203080123,9.36280193293499,0.71769992744424,0.0172138593255082,2.09622736051465,0.0165918400637099,0.248655085415105,246.548913168032,2.96586845672123,292.557561273423,1.08675716726274,11.1842671760155,35.8587759639101,0.0513355806964453,8.27830107117764,1.15246880725175,3.91436662946879,0.00237313203080123,0.424496256206389,9.36280193293499,0.71769992744424,0.0172138593255082,2.09622736051465,0.0165918400637099,246.548913168032,292.557561273423,1.80578507215338,4.19794966055287,16.089017079215,0.0318759949149613,0.00237313203080123,9.36280193293499,0.0261538296666823,2.96586845672123,1.80578507215338,0.0513355806964453,16.089017079215,11.1842671760155,35.8587759639101,35.809466744679]],"container":"<table class=\"display\">\n  <thead>\n    <tr>\n      <th> <\/th>\n      <th>NiN_code<\/th>\n      <th>Ecosystem<\/th>\n      <th>NiN_mainType<\/th>\n      <th>km2<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"scrollX":true,"scrollY":true,"pageLength":10,"columnDefs":[{"className":"dt-right","targets":4},{"orderable":false,"targets":0}],"order":[],"autoWidth":false,"orderClasses":false}},"evals":[],"jsHooks":[]}</script>
```

<p class="caption">(\#fig:unnamed-chunk-54)List of unique combinatios of NiN variable codes and naturetypes with the summed area for which we have this data.</p>
</div>
