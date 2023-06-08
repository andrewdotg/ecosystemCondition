# Functional plant indicators, wetland ecosystems (Moisture, Light, pH, Nitrogen) {#Functional-plant-indicators-wetland}

<br />

_Author and date:_
Joachim Töpper

May 2023

<br />

<!-- Load all you dependencies here -->







|Ecosystem |Økologisk.egenskap |ECT.class                       |
|:---------|:------------------|:-------------------------------|
|våtmark   |Primærproduksjon   |Functional state characteristic |
|våtmark   |Abiotiske forhold  |Functional state characteristic |



<!-- Don't remove these three html lines -->
<br />
<br />
<hr />

## Introduction
Functional plant indicators can be used to describe the functional signature of plant communities by calculating community-weighted means of plant indicator values for plant communities (Diekmann 2003). The functional signature of plant communities may be indicative of ecosystem identity, depending on which functional plant indicator we look at (cf. Töpper et al. 2018). For instance, using an indicator for moisture one would find a functional signature with higher moisture values for plant communities in mires compared to e.g. grasslands or forests. Deviations in the functional signature of such an indicator beyond a certain range of indicator values (as there of course is natural variation of functional signatures within an ecosystem type) may be related to a reduction in ecological condition. Here, we combine functional plant indicator data with field sampled plant community data from the Norwegian nature monitoring program ANO (Tingstad et al. 2019) for wetland ecosystems. We calculate the functional signature of plant communities in the monitored sites with respect to light, moisture, pH and nitrogen. These functional signatures are then compared to reference distributions of functional signature, separately for each wetland ecosystem type, calculated from 'generalized species lists' underlying the Norwegian categorization system for eco-diversity (Halvorsen et al. 2020). These plant functional condition indicators are developed following the principles and technical protocol of the IBECA framework (Jakobsson et al. 2021, Töpper & Jakobsson 2021). Note that deviations from the reference may occur in both directions, e.g. the moisture signature from the testing data may be higher or lower than in the reference. Deviations in these two directions indicate very different environmental phenomena and thus have to be treated separately. Therefore, we develop two condition indicators for each functional plant indicator, a lower one and an upper one (see further down for more details).

## About the underlying data
In the 'functional plant indicator' project for wetlands, we use three sets of data for building indicators for ecological condition:

- as test data we use plant community data from the ANO monitoring scheme (cf. Tingstad et al. 2019)
- as reference data we use generalized species lists from the Norwegian categorization system for eco-diversity (NiN) (cf. Halvorsen et al. 2020)
- Swedish plant indicator data for light, moisture, pH, and nitrogen from Tyler et al. (2021)

(1) ANO monitoring data:
ANO stands for 'areal-representativ naturovervåking', i.e. 'area representative nature monitoring'. 1000 sites are randomly distributed across mainland Norway and visited within a 5-year cycle. Each ANO site spans a 500 x 500 m grid cell, and the data collection at each ANO site includes up to 12 evenly distributed vegetation analyses in 1 x 1 m plots (up to 12, because some of these evenly distributed points may be in water or otherwise inaccessible). For the vegetation analyses, the cover of each vascular plant species in the plot is recorded. Every vegetation analysis is accompanied by an assessment of the ecosystem the plot lies in, including ecosystem type and some additional variables related to ecosystem-specific drivers of state. In the wetland-analysis in this document, we only use the plots which were classified as one of the wetland ecosystem types in the Norwegian categorization system for eco-diversity (NiN).
In the analysis in this document, we use the data available on Miljødirektoratets kartkatalog (https://kartkatalog.miljodirektoratet.no/Dataset/Details/2054), which comprises data from the first three ANO-years, 2019-2021, and a total of 8887 plots in 498 sites.

(2) NiN reference data:
The generalized species lists underlying the ecosystem categorization in NiN represent expert-compiled species lists based on empirical evidence from the literature and expert knowledge of the systems and their species. In these lists, every species is assigned an abundance value on a 6-step scale, with each step representing a range for the 'expected combination of frequency and cover' of occurrence (1: < 1/32, 2: 1/32 - 1/8 , 3: 1/8 - 3/8, 4: 3/8 - 4/5, 5: 3/8 - 4/5 + dominance, 6: > 4/5). For the purpose of this project, these steps are simplified to maximum 'expected combination of frequency and cover', whereby steps 4 & 5 are assigned 0.6 and 0.8, respectively, in order to distinguish between them.

(3) The Swedish plant indicator set published by Tyler et al. (2021) contains a large collection of plant indicators based on the Swedish flora, which is well representative of the Norwegian flora as well. From this set, we decided to include indicator data for light, moisture, pH, and nitrogen for wetlands as these are thought to be subject to potential change due to shrub/tree encroachment, drainage, and pollution.


### Representativity in time and space
For wetlands, the ANO data contain 1351 plots in 330 sites, in principle distributed randomly across the country. As wetlands occur more often in certain regions of Norway than in others, the amount of plots and sites is not equal among Norway's five regions. The 1351 plots are distributed across regions in the following way:

- Northern Norway: 416
- Central Norway:  362
- Eastern Norway:  295
- Western Norway:  151
- Southern Norway: 127

### Temporal coverage
The evaluation data cover the first three years, 2019-2021, of the first 5-year-cycle in the ANO monitoring scheme. Thus there is no actual time series to these data, and the indicator evaluation does therefore not include any temporal analyses.


## Collinearities with other indicators
<!-- Text here -->

## Reference state and values
### Reference state
The reference state is defined via the functional signature of the generalized species lists in NiN (see also Töpper et al. 2018). By bootstrapping the species lists (see details further below) and calculating community-weighted means of functional plant indicators for every re-sampled community, we describe the reference state as a distribution of indicator values for each respective plant functional indicator. These distributions are calculated for ecosystem sub-types ("grunntyper" or "kartleggingsenheter" at a 1:5000 mapping scale) within the main wetland types in NiN. A more extensive discussion on the use of reference communities can be found in Jakobsson et al. (2020).


### Reference values, thresholds for defining _good ecological condition_, minimum and/or maximum values
In this analysis, we derive scaling values from statistical (here, non-parametric) distributions (see Jakobsson et al. 2010). For each ecosystem sub-type and plant functional indicator, the reference value is defined as the median value of the indicator value distribution. As in most cases the distributions naturally are two-sided (but see the Heat-requirement indicator in the mountain assessment for an example of a one-sided functional plant indicator, Fremstad et al. 2022), and deviation from the optimal state thus may occur in both direction (e.g. indicating too low or too high pH), we need to define two threshold values for good ecological condition as well as both a minimum and maximum value. In line with previous assessments of ecological condition for Norwegian forests and mountains, we define a lower and an upper threshold value via the 95% confidence interval of the reference distribution, i.e. its 0.025 and 0.975 quantiles. The minimum and maximum values are given by the minimum and maximum of the possible indicator values for each respective plant functional indicator. For details on the scaling principles in IBECA, please see Töpper & Jakobsson (2021).


## Uncertainties
We can calculate a mean indicator value (after scaling) for every region (or any other delimited area of interest) as well as its corresponding standard error and standard deviation as a measure of spatial uncertainty for a geographical area.


## References
Diekmann, M. 2003. Species indicator values as an important tool in applied plant ecology - a review. Basic and Applied Ecology 4: 493-506, doi:10.1078/1439-1791-00185

Framstad, E., Kolstad, A. L., Nybø, S., Töpper, J. & Vandvik, V. 2022. The condition of forest and mountain ecosystems in Norway. Assessment by the IBECA method. NINA Report 2100. Norwegian Institute for Nature Research.

Halvorsen, R., Skarpaas, O., Bryn, A., Bratli, H., Erikstad, L., Simensen, T., & Lieungh, E. (2020). Towards a systematics of ecodiversity: The EcoSyst framework. Global Ecology and Biogeography, 29(11), 1887-1906. doi:10.1111/geb.13164

Jakobsson, S., Töpper, J.P., Evju, M., Framstad, E., Lyngstad, A., Pedersen, B., Sickel, H., Sverdrup-Thygeson, A., Vandvik. V., Velle, L.G., Aarrestad, P.A. & Nybø, S. 2020. Setting reference levels and limits for good ecological condition in terrestrial ecosystems. Insights from a case study based on the IBECA approach. Ecological Indicators 116: 106492.

Jakobsson, S., Evju, M., Framstad, E., Imbert, A., Lyngstad, A., Sickel, H., Sverdrup-Thygeson, A., Töpper, J., Vandvik, V., Velle, L.G., Aarrestad, P.A. & Nybø, S. 2021. An index-based assessment of ecological condition and its links to international frameworks. Ecological Indicators 124: 107252.

Tingstad, L., Evju, M., Sickel, H., & Töpper, J. 2019. Utvikling av nasjonal arealrepresentativ naturovervåking (ANO). Forslag til gjennomføring, protokoller og kostnadsvurderinger med utgangspunkt i erfaringer fra uttesting i Trøndelag. NINA Rapport 1642.

Töpper, J. & Jakobsson, S. 2021. The Index-Based Ecological Condition Assessment (IBECA) - Technical protocol, version 1.0. NINA Report 1967. Norwegian Institute for Nature Research.

Töpper, J., Velle, L.G. & Vandvik, V. 2018. Developing a method for assessment of ecological state based on indicator values after Ellenberg and Grime (revised edition). NINA Report 1529b. Norwegian Institute for Nature Research.

Tyler, T., Herbertsson, L., Olofsson, J., & Olsson, P. A. 2021. Ecological indicator and traits values for Swedish vascular plants. Ecological In-dicators, 120. doi:10.1016/j.ecolind.2020.106923


## Analyses
### Data sets

ANO data



Plant indicators from Tyler et al. (2021)


Generalized species lists NiN


#### Data handling
- Checking for errors
- Checking species nomenclature in the different species lists to make species and indicator data possible to merge
- Merging indicator data with monitoring data and indicator data with reference data
(not shown here, but documented in the code)


leaving us with the monitoring data including plant indicators (ANO.sp.ind) and the reference data including plant indicators (NiN.wetland.cov)


```r
head(ANO.sp.ind)
#>      Species art_dekning
#> 1 Abies alba           0
#> 2 Abies alba           0
#> 3 Abies alba           0
#> 4 Abies alba           0
#> 5 Abies alba           0
#> 6 Abies alba           0
#>                           ParentGlobalID Light Moisture
#> 1 {CB1796B9-01F5-4109-B44E-4582CA855F93}     2        5
#> 2 {AB9ED5C2-E906-4C73-B543-EC6CB28B39D5}     2        5
#> 3 {32A9B462-5483-4D47-ADAF-78F11AF201AA}     2        5
#> 4 {004C000D-459B-4244-96F4-4FF8B06454D4}     2        5
#> 5 {B7DD61EE-A113-4486-A4B8-D50ACAAC648B}     2        5
#> 6 {0431743B-F268-4819-98F7-FFB7006E55BA}     2        5
#>   Soil_reaction_pH Nitrogen
#> 1                5        5
#> 2                5        5
#> 3                5        5
#> 4                5        5
#> 5                5        5
#> 6                5        5
head(NiN.wetland.cov)
#>                        sp V3-C1a V3-C1b V3-C1c V3-C1d
#> 1    Abietinella abietina      0      0      0      0
#> 2        Acer platanoides      0      0      0      0
#> 3    Achillea millefolium      0      0      0      0
#> 4       Achillea ptarmica      0      0      0      0
#> 5         Acinos arvensis      0      0      0      0
#> 6 Aconitum septentrionale      0      0      0      0
#>   V3-C1e V1-C1a V1-C1b V1-C1c V1-C1d V1-C1e V1-C2a V1-C2b
#> 1      0      0      0      0      0      0      0      0
#> 2      0      0      0      0      0      0      0      0
#> 3      0      0      0      0      0      0      0      0
#> 4      0      0      0      0      0      0      0      0
#> 5      0      0      0      0      0      0      0      0
#> 6      0      0      0      0      0      0      0      0
#>   V1-C2c V1-C2d V1-C3a V1-C3b V1-C3c V1-C3d V1-C4a V1-C4b
#> 1      0      0      0      0      0      0      0      0
#> 2      0      0      0      0      0      0      0      0
#> 3      0      0      0      0      0      0      0      0
#> 4      0      0      0      0      0      0      0      0
#> 5      0      0      0      0      0      0      0      0
#> 6      0      0      0      0      0      0      0      0
#>   V1-C4c V1-C4d V1-C4e V1-C4f V1-C4g V1-C4h V3-C2 V1-C5
#> 1      0      0      0      0      0      0     0     0
#> 2      0      0      0      0      0      0     0     0
#> 3      0      0      0      0      0      0     0     0
#> 4      0      0      0      0      0      0     0     0
#> 5      0      0      0      0      0      0     0     0
#> 6      0      0      0      0      0      0     0     0
#>   V1-C6a V1-C6b V1-C7a V1-C7b V1-C8a V1-C8b V2-C1a V2-C1b
#> 1      0      0      0      0      0      0      0      0
#> 2      0      0      0      0      0      0      0      0
#> 3      0      0      0      0      0      0      0      0
#> 4      0      0      0      0      0      0      0      0
#> 5      0      0      0      0      0      0      0      0
#> 6      0      0      0      0      0      0      0      0
#>   V2-C2a V2-C2b V2-C3a V2-C3b V4-C2 V4-C3 V8-C1 V8-C2 V8-C3
#> 1      0      0      0      0     0     0     0     0     0
#> 2      0      0      0      0     0     0     0     0     0
#> 3      0      0      0      0     0     0     0     0     0
#> 4      0      0      0      0     0     0     0     0     0
#> 5      0      0      0      0     0     0     0     0     0
#> 6      0      0      0      0     0     0     0     0     0
#>   Light Moisture Soil_reaction_pH Nitrogen
#> 1    NA       NA               NA       NA
#> 2     4        4                6        5
#> 3     6        2                5        5
#> 4     5        6                4        4
#> 5     7        1                7        3
#> 6     4        5                7        7
```
For each ecosystem type with a NiN species list, we can calculate a community weighted mean (CWM) for the relevant functional plant indicators.
For wetland ecosystem we are testing "Light", "Moisture", "Soil_reaction_pH", and "Nitrogen". In order to get distributions of CWMs rather than one single value (for comparison with the empirical testing data) the NiN lists can be bootstrapped.

##### bootstrap function for frequency abundance
- function to calculate community weighted means of selected indicator values (ind)
- for species lists (sp) with given abundances in percent (or on a scale from 0 to 1) in one or more 'sites' (abun)
- with a given number of iterations (iter),
- with species given a certain minimum abundance occurring in all bootstraps (obl), and
- with a given re-sampling ratio of the original species list (rat)
- in every bootstrap iteration the abundance of the sampled species can be randomly changed by a limited amount if wished by introducing a re-sampling of abundance values from adjacent abundance steps with a certain probability (var.abun)



Running the bootstraps


```r
colnames(NiN.wetland)
# 1st column is the species
# 2nd-46th column is the abundances of sp in different ecosystem types
# 47th-50th column is the indicator values of the respective species
# we choose 1000 iterations
# species with abundance 1 (i.e. a max of 100%, must be included in each sample)
# each sample re-samples 1/3 of the number of species
# the abundance of the re-sampled species may vary (see bootstrap function for details)
wetland.ref.cov <- indBoot.freq(sp=NiN.wetland.cov[,1],abun=NiN.wetland.cov[,2:46],ind=NiN.wetland.cov[,47:50],
                          iter=1000,obl=1,rat=1/3,var.abun=T)

# fixing NaNs
for (i in 1:length(wetland.ref.cov) ) {
  for (j in 1:ncol(wetland.ref.cov[[i]]) ) {
    v <- wetland.ref.cov[[i]][,j]
    v[is.nan(v)] <- NA
    wetland.ref.cov[[i]][,j] <- v
  }
}
```




```r
head(wetland.ref.cov[[1]])
#>   V3-C1a   V3-C1b   V3-C1c   V3-C1d   V3-C1e   V1-C1a
#> 1     NA 5.537118 5.519421 4.516616 5.198992 5.615385
#> 2     NA 5.545455 5.303867 5.500000 4.984615 4.857143
#> 3     NA 6.588832 5.376543 5.904977 4.833333 5.972973
#> 4     NA 6.308017 5.042328 5.298507 5.245614 4.526066
#> 5     NA 5.761421 5.333333 5.822622 5.010862 5.758621
#> 6     NA 5.300000 5.672269 5.250000 5.076159 6.250000
#>     V1-C1b   V1-C1c   V1-C1d   V1-C1e   V1-C2a   V1-C2b
#> 1 5.665025 5.040943 5.444206 5.284579 4.516291 5.500000
#> 2 5.025050 5.823529 5.087358 5.187335 5.649860 6.029586
#> 3 6.312500 5.710956 5.576603 5.154487 5.781485 6.008580
#> 4 5.564772 5.372824 5.022936 5.016098 6.454976 4.520129
#> 5 5.471328 6.035370 5.608986 4.988055 6.576869 5.655134
#> 6 5.390782 4.984520 4.877800 4.603080 4.896975 6.073020
#>     V1-C2c   V1-C2d   V1-C3a   V1-C3b   V1-C3c   V1-C3d
#> 1 4.727120 5.234536 6.242694 5.292952 5.109108 5.214753
#> 2 5.256491 5.175023 6.561584 5.814873 6.167920 5.461832
#> 3 5.631367 5.672697 4.837065 5.289557 5.324456 4.809302
#> 4 5.417409 5.424689 6.581006 4.581459 5.104036 5.271104
#> 5 5.715929 5.782609 5.982505 5.684211 5.732940 5.369686
#> 6 4.876417 4.808176 5.975198 5.335248 5.198312 5.698343
#>     V1-C4a   V1-C4b   V1-C4c   V1-C4d   V1-C4e   V1-C4f
#> 1 5.674512 6.100610 5.916846 6.220841 6.673210 5.481481
#> 2 6.421354 5.719110 5.691259 5.397706 5.611799 6.233498
#> 3 5.486574 6.149593 5.485597 5.446296 6.174157 5.806962
#> 4 5.870466 5.936061 5.465432 6.407635 6.280048 5.459891
#> 5 6.063272 5.979097 5.489074 5.492537 6.101709 5.664537
#> 6 6.338515 6.172363 5.180462 5.120773 6.634538 6.200617
#>     V1-C4g   V1-C4h    V3-C2    V1-C5   V1-C6a   V1-C6b
#> 1 6.092386 6.057186 4.996385 4.830956 5.077866 4.628153
#> 2 5.801220 4.922374 4.764331 4.679059 4.695021 4.988584
#> 3 5.435173 5.481737 4.781609 4.649430 4.883855 4.942087
#> 4 5.944277 6.204067 5.198690 4.653085 4.924060 4.614800
#> 5 5.183016 6.196417 5.224044 4.577465 4.993554 4.574797
#> 6 5.994172 5.525847 4.768879 4.756207 4.760917 4.516348
#>     V1-C7a   V1-C7b   V1-C8a   V1-C8b   V2-C1a   V2-C1b
#> 1 4.544482 4.371762 5.047897 4.633618 4.287703 4.045110
#> 2 4.492043 4.409722 5.018118 4.484203 4.110429 4.326881
#> 3 4.759162 5.117394 5.100655 4.734568 4.365521 4.210180
#> 4 5.099964 4.587847 4.609169 4.303894 3.932933 4.168017
#> 5 4.574026 4.980466 4.306452 5.038488 4.954111 4.247664
#> 6 4.996280 4.733447 5.742741 4.772339 4.612745 4.427966
#>     V2-C2a   V2-C2b   V2-C3a   V2-C3b    V4-C2    V4-C3
#> 1 4.471163 4.109362 4.081429 3.454026 4.647626 5.152364
#> 2 4.275137 3.836049 4.134050 4.055677 4.804082 5.327044
#> 3 4.328051 3.587933 4.015032 4.045385 4.727341 5.645874
#> 4 4.623957 3.827967 4.588215 4.065883 4.913506 4.729878
#> 5 4.558872 4.484615 3.762264 3.839943 5.491614 4.388280
#> 6 3.874477 3.611697 4.451854 4.808479 4.920083 4.641156
#>      V8-C1    V8-C2    V8-C3
#> 1 3.830428 4.969906 4.509828
#> 2 4.554674 4.690696 4.581641
#> 3 4.714435 4.460696 4.545655
#> 4 4.507944 4.876977 4.733694
#> 5 4.871125 4.796040 4.844728
#> 6 4.293290 4.564882 4.709910
```

This results in an R-list with a slot for every selected indicator, and in every slot there's a data frame with as many columns as there are NiN species lists and as many rows as there were iterations in the bootstrap.
Next, we need to derive scaling values from these bootstrap-lists (the columns) for every mapping unit in NiN. Here, we define things in the following way:

- Median = reference values
- 0.025 and 0.975 quantiles = lower and upper limit values
- min and max of the respective indicator's scale = min/max values


```
#>   V3-C1a   V3-C1b   V3-C1c   V3-C1d   V3-C1e   V1-C1a
#> 1     NA 5.537118 5.519421 4.516616 5.198992 5.615385
#> 2     NA 5.545455 5.303867 5.500000 4.984615 4.857143
#> 3     NA 6.588832 5.376543 5.904977 4.833333 5.972973
#> 4     NA 6.308017 5.042328 5.298507 5.245614 4.526066
#> 5     NA 5.761421 5.333333 5.822622 5.010862 5.758621
#> 6     NA 5.300000 5.672269 5.250000 5.076159 6.250000
#>     V1-C1b   V1-C1c   V1-C1d   V1-C1e   V1-C2a   V1-C2b
#> 1 5.665025 5.040943 5.444206 5.284579 4.516291 5.500000
#> 2 5.025050 5.823529 5.087358 5.187335 5.649860 6.029586
#> 3 6.312500 5.710956 5.576603 5.154487 5.781485 6.008580
#> 4 5.564772 5.372824 5.022936 5.016098 6.454976 4.520129
#> 5 5.471328 6.035370 5.608986 4.988055 6.576869 5.655134
#> 6 5.390782 4.984520 4.877800 4.603080 4.896975 6.073020
#>     V1-C2c   V1-C2d   V1-C3a   V1-C3b   V1-C3c   V1-C3d
#> 1 4.727120 5.234536 6.242694 5.292952 5.109108 5.214753
#> 2 5.256491 5.175023 6.561584 5.814873 6.167920 5.461832
#> 3 5.631367 5.672697 4.837065 5.289557 5.324456 4.809302
#> 4 5.417409 5.424689 6.581006 4.581459 5.104036 5.271104
#> 5 5.715929 5.782609 5.982505 5.684211 5.732940 5.369686
#> 6 4.876417 4.808176 5.975198 5.335248 5.198312 5.698343
#>     V1-C4a   V1-C4b   V1-C4c   V1-C4d   V1-C4e   V1-C4f
#> 1 5.674512 6.100610 5.916846 6.220841 6.673210 5.481481
#> 2 6.421354 5.719110 5.691259 5.397706 5.611799 6.233498
#> 3 5.486574 6.149593 5.485597 5.446296 6.174157 5.806962
#> 4 5.870466 5.936061 5.465432 6.407635 6.280048 5.459891
#> 5 6.063272 5.979097 5.489074 5.492537 6.101709 5.664537
#> 6 6.338515 6.172363 5.180462 5.120773 6.634538 6.200617
#>     V1-C4g   V1-C4h    V3-C2    V1-C5   V1-C6a   V1-C6b
#> 1 6.092386 6.057186 4.996385 4.830956 5.077866 4.628153
#> 2 5.801220 4.922374 4.764331 4.679059 4.695021 4.988584
#> 3 5.435173 5.481737 4.781609 4.649430 4.883855 4.942087
#> 4 5.944277 6.204067 5.198690 4.653085 4.924060 4.614800
#> 5 5.183016 6.196417 5.224044 4.577465 4.993554 4.574797
#> 6 5.994172 5.525847 4.768879 4.756207 4.760917 4.516348
#>     V1-C7a   V1-C7b   V1-C8a   V1-C8b   V2-C1a   V2-C1b
#> 1 4.544482 4.371762 5.047897 4.633618 4.287703 4.045110
#> 2 4.492043 4.409722 5.018118 4.484203 4.110429 4.326881
#> 3 4.759162 5.117394 5.100655 4.734568 4.365521 4.210180
#> 4 5.099964 4.587847 4.609169 4.303894 3.932933 4.168017
#> 5 4.574026 4.980466 4.306452 5.038488 4.954111 4.247664
#> 6 4.996280 4.733447 5.742741 4.772339 4.612745 4.427966
#>     V2-C2a   V2-C2b   V2-C3a   V2-C3b    V4-C2    V4-C3
#> 1 4.471163 4.109362 4.081429 3.454026 4.647626 5.152364
#> 2 4.275137 3.836049 4.134050 4.055677 4.804082 5.327044
#> 3 4.328051 3.587933 4.015032 4.045385 4.727341 5.645874
#> 4 4.623957 3.827967 4.588215 4.065883 4.913506 4.729878
#> 5 4.558872 4.484615 3.762264 3.839943 5.491614 4.388280
#> 6 3.874477 3.611697 4.451854 4.808479 4.920083 4.641156
#>      V8-C1    V8-C2    V8-C3
#> 1 3.830428 4.969906 4.509828
#> 2 4.554674 4.690696 4.581641
#> 3 4.714435 4.460696 4.545655
#> 4 4.507944 4.876977 4.733694
#> 5 4.871125 4.796040 4.844728
#> 6 4.293290 4.564882 4.709910
#>  [1] V3-C1a V3-C1b V3-C1c V3-C1d V3-C1e V1-C1a V1-C1b V1-C1c
#>  [9] V1-C1d V1-C1e V1-C2a V1-C2b V1-C2c V1-C2d V1-C3a V1-C3b
#> [17] V1-C3c V1-C3d V1-C4a V1-C4b V1-C4c V1-C4d V1-C4e V1-C4f
#> [25] V1-C4g V1-C4h V3-C2  V1-C5  V1-C6a V1-C6b V1-C7a V1-C7b
#> [33] V1-C8a V1-C8b V2-C1a V2-C1b V2-C2a V2-C2b V2-C3a V2-C3b
#> [41] V4-C2  V4-C3  V8-C1  V8-C2  V8-C3 
#> <0 rows> (or 0-length row.names)
#>  [1] "V3-C1" "V1-C1" "V1-C2" "V1-C3" "V1-C4" "V3-C2" "V1-C5"
#>  [8] "V1-C6" "V1-C7" "V1-C8" "V2-C1" "V2-C2" "V2-C3" "V4-C2"
#> [15] "V4-C3" "V8-C1" "V8-C2" "V8-C3"
#>  [1] "V3-C1a" "V3-C1b" "V3-C1c" "V3-C1d" "V3-C1e" "V1-C1a"
#>  [7] "V1-C1b" "V1-C1c" "V1-C1d" "V1-C1e" "V1-C2a" "V1-C2b"
#> [13] "V1-C2c" "V1-C2d" "V1-C3a" "V1-C3b" "V1-C3c" "V1-C3d"
#> [19] "V1-C4a" "V1-C4b" "V1-C4c" "V1-C4d" "V1-C4e" "V1-C4f"
#> [25] "V1-C4g" "V1-C4h" "V3-C2"  "V1-C5"  "V1-C6a" "V1-C6b"
#> [31] "V1-C7a" "V1-C7b" "V1-C8a" "V1-C8b" "V2-C1a" "V2-C1b"
#> [37] "V2-C2a" "V2-C2b" "V2-C3a" "V2-C3b" "V4-C2"  "V4-C3" 
#> [43] "V8-C1"  "V8-C2"  "V8-C3"
#>  [1] "V3-C1" "V1-C1" "V1-C2" "V1-C3" "V1-C4" "V1-C6" "V1-C7"
#>  [8] "V1-C8" "V2-C1" "V2-C2" "V2-C3"
#> [1] 1 2 3 4 5
#>          V1       V2       V3       V4       V5       V6
#> 1  4.650288 4.966443 5.242167 4.730467 5.450611 6.287387
#> 2  4.412518 4.678375 4.983052 5.024660 5.705182 6.515412
#> 3  4.181051 4.885976 5.575828 5.959727 7.108910 7.929956
#> 4  4.265677 4.970310 5.728271 6.072307 6.944127 7.598114
#> 5  4.026841 4.715468 5.326302 6.041072 7.262666 8.132334
#> 6  4.331418 4.760871 5.131781 6.519606 7.245583 7.905369
#> 7  4.379654 4.687800 4.977008 6.665973 7.502367 8.189600
#> 8  4.676349 5.342796 6.777778 4.473684 6.424165 8.467209
#> 9  4.735842 5.388481 6.835764 4.805905 6.985401 9.142989
#> 10 4.684189 5.548379 6.753948 5.703439 7.826415 9.337017
#> 11 4.644572 5.484308 6.487499 6.503395 8.213247 9.445956
#> 12 4.552329 5.686564 6.494601 6.530966 8.109657 9.294677
#> 13 4.219840 4.779976 5.423544 5.518264 7.313205 9.248771
#> 14 4.166529 4.692662 5.433001 5.869488 7.241861 8.685496
#> 15 4.206007 4.887366 5.758946 5.712864 7.085127 8.097239
#> 16 3.657798 4.231589 4.953344 4.851244 5.751619 8.797058
#> 17 3.446326 4.238208 4.940917 5.141012 6.474238 8.285018
#> 18 3.242379 4.121921 4.738912 5.556370 6.814557 8.218944
#>          V7       V8       V9      V10      V11      V12
#> 1  1.655954 2.069755 2.814447 1.798326 2.101967 2.488591
#> 2  1.858930 2.328319 2.983125 1.707630 2.083033 2.676179
#> 3  3.022003 3.802753 4.769512 2.638866 3.345274 4.191821
#> 4  3.495213 4.389075 5.344473 2.841443 3.687148 5.207416
#> 5  3.322124 4.182404 4.879182 3.634319 4.453431 5.308846
#> 6  4.279028 4.750092 5.202615 4.680611 5.400094 6.103431
#> 7  4.502166 4.913133 5.280336 5.067941 5.752526 6.270266
#> 8  1.082218 1.951116 3.292487 1.006211 1.544669 2.200000
#> 9  1.304445 1.971098 4.000000 1.049953 1.613392 2.539114
#> 10 1.623551 2.737952 4.376870 1.202420 1.908494 3.136698
#> 11 2.307563 3.592224 4.848489 1.360667 2.344593 3.836578
#> 12 2.929122 4.566270 5.959868 1.712485 2.626977 3.948144
#> 13 2.201466 3.168781 4.330514 2.067017 2.802510 3.660364
#> 14 2.663268 3.405840 4.365503 2.368457 3.072115 3.880840
#> 15 3.267379 4.278356 5.369703 2.553046 3.524687 4.784577
#> 16 2.388756 2.849982 4.133991 2.482721 3.078022 4.157467
#> 17 2.926638 3.625899 4.478642 3.222495 4.096205 5.004499
#> 18 3.325443 4.107336 4.837873 3.954204 4.890875 5.899529
#>      NiN
#> 1  V3-C2
#> 2  V1-C5
#> 3  V4-C2
#> 4  V4-C3
#> 5  V8-C1
#> 6  V8-C2
#> 7  V8-C3
#> 8  V3-C1
#> 9  V1-C1
#> 10 V1-C2
#> 11 V1-C3
#> 12 V1-C4
#> 13 V1-C6
#> 14 V1-C7
#> 15 V1-C8
#> 16 V2-C1
#> 17 V2-C2
#> 18 V2-C3
#>      V1   V2   V3   V4   V5   V6   V7   V8   V9  V10  V11
#> 1  4.65 4.97 5.24 4.73 5.45 6.29 1.66 2.07 2.81 1.80 2.10
#> 2  4.41 4.68 4.98 5.02 5.71 6.52 1.86 2.33 2.98 1.71 2.08
#> 3  4.18 4.89 5.58 5.96 7.11 7.93 3.02 3.80 4.77 2.64 3.35
#> 4  4.27 4.97 5.73 6.07 6.94 7.60 3.50 4.39 5.34 2.84 3.69
#> 5  4.03 4.72 5.33 6.04 7.26 8.13 3.32 4.18 4.88 3.63 4.45
#> 6  4.33 4.76 5.13 6.52 7.25 7.91 4.28 4.75 5.20 4.68 5.40
#> 7  4.38 4.69 4.98 6.67 7.50 8.19 4.50 4.91 5.28 5.07 5.75
#> 8  4.68 5.34 6.78 4.47 6.42 8.47 1.08 1.95 3.29 1.01 1.54
#> 9  4.74 5.39 6.84 4.81 6.99 9.14 1.30 1.97 4.00 1.05 1.61
#> 10 4.68 5.55 6.75 5.70 7.83 9.34 1.62 2.74 4.38 1.20 1.91
#> 11 4.64 5.48 6.49 6.50 8.21 9.45 2.31 3.59 4.85 1.36 2.34
#> 12 4.55 5.69 6.49 6.53 8.11 9.29 2.93 4.57 5.96 1.71 2.63
#> 13 4.22 4.78 5.42 5.52 7.31 9.25 2.20 3.17 4.33 2.07 2.80
#> 14 4.17 4.69 5.43 5.87 7.24 8.69 2.66 3.41 4.37 2.37 3.07
#> 15 4.21 4.89 5.76 5.71 7.09 8.10 3.27 4.28 5.37 2.55 3.52
#> 16 3.66 4.23 4.95 4.85 5.75 8.80 2.39 2.85 4.13 2.48 3.08
#> 17 3.45 4.24 4.94 5.14 6.47 8.29 2.93 3.63 4.48 3.22 4.10
#> 18 3.24 4.12 4.74 5.56 6.81 8.22 3.33 4.11 4.84 3.95 4.89
#>     V12
#> 1  2.49
#> 2  2.68
#> 3  4.19
#> 4  5.21
#> 5  5.31
#> 6  6.10
#> 7  6.27
#> 8  2.20
#> 9  2.54
#> 10 3.14
#> 11 3.84
#> 12 3.95
#> 13 3.66
#> 14 3.88
#> 15 4.78
#> 16 4.16
#> 17 5.00
#> 18 5.90
#>    Light_q2.5      Light_q50      Light_q97.5   
#>  Min.   :3.242   Min.   :4.122   Min.   :4.739  
#>  1st Qu.:4.170   1st Qu.:4.689   1st Qu.:5.020  
#>  Median :4.299   Median :4.833   Median :5.428  
#>  Mean   :4.249   Mean   :4.893   Mean   :5.642  
#>  3rd Qu.:4.622   3rd Qu.:5.250   3rd Qu.:6.305  
#>  Max.   :4.736   Max.   :5.687   Max.   :6.836  
#>    Moist_q2.5      Moist_q50      Moist_q97.5   
#>  Min.   :4.474   Min.   :5.451   Min.   :6.287  
#>  1st Qu.:5.054   1st Qu.:6.559   1st Qu.:7.972  
#>  Median :5.708   Median :7.097   Median :8.252  
#>  Mean   :5.649   Mean   :6.970   Mean   :8.310  
#>  3rd Qu.:6.064   3rd Qu.:7.301   3rd Qu.:9.057  
#>  Max.   :6.666   Max.   :8.213   Max.   :9.446  
#>     pH_q2.5          pH_q50         pH_q97.5    
#>  Min.   :1.082   Min.   :1.951   Min.   :2.814  
#>  1st Qu.:1.945   1st Qu.:2.766   1st Qu.:4.183  
#>  Median :2.795   Median :3.609   Median :4.624  
#>  Mean   :2.675   Mean   :3.483   Mean   :4.515  
#>  3rd Qu.:3.308   3rd Qu.:4.254   3rd Qu.:5.122  
#>  Max.   :4.502   Max.   :4.913   Max.   :5.960  
#>  Nitrogen_q2.5    Nitrogen_q50   Nitrogen_q97.5 
#>  Min.   :1.006   Min.   :1.545   Min.   :2.200  
#>  1st Qu.:1.709   1st Qu.:2.163   1st Qu.:3.268  
#>  Median :2.426   Median :3.075   Median :4.053  
#>  Mean   :2.519   Mean   :3.240   Mean   :4.183  
#>  3rd Qu.:3.127   3rd Qu.:3.994   3rd Qu.:5.157  
#>  Max.   :5.068   Max.   :5.753   Max.   :6.270  
#>      NiN           
#>  Length:18         
#>  Class :character  
#>  Mode  :character  
#>                    
#>                    
#> 
#>    Light_q2.5 Light_q50 Light_q97.5 Moist_q2.5 Moist_q50
#> 1    4.650288  4.966443    5.242167   4.730467  5.450611
#> 2    4.412518  4.678375    4.983052   5.024660  5.705182
#> 3    4.181051  4.885976    5.575828   5.959727  7.108910
#> 4    4.265677  4.970310    5.728271   6.072307  6.944127
#> 5    4.026841  4.715468    5.326302   6.041072  7.262666
#> 6    4.331418  4.760871    5.131781   6.519606  7.245583
#> 7    4.379654  4.687800    4.977008   6.665973  7.502367
#> 8    4.676349  5.342796    6.777778   4.473684  6.424165
#> 9    4.735842  5.388481    6.835764   4.805905  6.985401
#> 10   4.684189  5.548379    6.753948   5.703439  7.826415
#> 11   4.644572  5.484308    6.487499   6.503395  8.213247
#> 12   4.552329  5.686564    6.494601   6.530966  8.109657
#> 13   4.219840  4.779976    5.423544   5.518264  7.313205
#> 14   4.166529  4.692662    5.433001   5.869488  7.241861
#> 15   4.206007  4.887366    5.758946   5.712864  7.085127
#> 16   3.657798  4.231589    4.953344   4.851244  5.751619
#> 17   3.446326  4.238208    4.940917   5.141012  6.474238
#> 18   3.242379  4.121921    4.738912   5.556370  6.814557
#>    Moist_q97.5  pH_q2.5   pH_q50 pH_q97.5 Nitrogen_q2.5
#> 1     6.287387 1.655954 2.069755 2.814447      1.798326
#> 2     6.515412 1.858930 2.328319 2.983125      1.707630
#> 3     7.929956 3.022003 3.802753 4.769512      2.638866
#> 4     7.598114 3.495213 4.389075 5.344473      2.841443
#> 5     8.132334 3.322124 4.182404 4.879182      3.634319
#> 6     7.905369 4.279028 4.750092 5.202615      4.680611
#> 7     8.189600 4.502166 4.913133 5.280336      5.067941
#> 8     8.467209 1.082218 1.951116 3.292487      1.006211
#> 9     9.142989 1.304445 1.971098 4.000000      1.049953
#> 10    9.337017 1.623551 2.737952 4.376870      1.202420
#> 11    9.445956 2.307563 3.592224 4.848489      1.360667
#> 12    9.294677 2.929122 4.566270 5.959868      1.712485
#> 13    9.248771 2.201466 3.168781 4.330514      2.067017
#> 14    8.685496 2.663268 3.405840 4.365503      2.368457
#> 15    8.097239 3.267379 4.278356 5.369703      2.553046
#> 16    8.797058 2.388756 2.849982 4.133991      2.482721
#> 17    8.285018 2.926638 3.625899 4.478642      3.222495
#> 18    8.218944 3.325443 4.107336 4.837873      3.954204
#>    Nitrogen_q50 Nitrogen_q97.5    NiN
#> 1      2.101967       2.488591 V3-C-2
#> 2      2.083033       2.676179 V1-C-5
#> 3      3.345274       4.191821 V4-C-2
#> 4      3.687148       5.207416 V4-C-3
#> 5      4.453431       5.308846 V8-C-1
#> 6      5.400094       6.103431 V8-C-2
#> 7      5.752526       6.270266 V8-C-3
#> 8      1.544669       2.200000 V3-C-1
#> 9      1.613392       2.539114 V1-C-1
#> 10     1.908494       3.136698 V1-C-2
#> 11     2.344593       3.836578 V1-C-3
#> 12     2.626977       3.948144 V1-C-4
#> 13     2.802510       3.660364 V1-C-6
#> 14     3.072115       3.880840 V1-C-7
#> 15     3.524687       4.784577 V1-C-8
#> 16     3.078022       4.157467 V2-C-1
#> 17     4.096205       5.004499 V2-C-2
#> 18     4.890875       5.899529 V2-C-3
#>          N1 hoved  grunn county region       Ind       Rv
#> 1   wetland    NA V3-C-2    all    all    Light1 4.966443
#> 2   wetland    NA V3-C-2    all    all    Light2 4.966443
#> 3   wetland    NA V1-C-5    all    all    Light1 4.678375
#> 4   wetland    NA V1-C-5    all    all    Light2 4.678375
#> 5   wetland    NA V4-C-2    all    all    Light1 4.885976
#> 6   wetland    NA V4-C-2    all    all    Light2 4.885976
#> 7   wetland    NA V4-C-3    all    all    Light1 4.970310
#> 8   wetland    NA V4-C-3    all    all    Light2 4.970310
#> 9   wetland    NA V8-C-1    all    all    Light1 4.715468
#> 10  wetland    NA V8-C-1    all    all    Light2 4.715468
#> 11  wetland    NA V8-C-2    all    all    Light1 4.760871
#> 12  wetland    NA V8-C-2    all    all    Light2 4.760871
#> 13  wetland    NA V8-C-3    all    all    Light1 4.687800
#> 14  wetland    NA V8-C-3    all    all    Light2 4.687800
#> 15  wetland    NA V3-C-1    all    all    Light1 5.342796
#> 16  wetland    NA V3-C-1    all    all    Light2 5.342796
#> 17  wetland    NA V1-C-1    all    all    Light1 5.388481
#> 18  wetland    NA V1-C-1    all    all    Light2 5.388481
#> 19  wetland    NA V1-C-2    all    all    Light1 5.548379
#> 20  wetland    NA V1-C-2    all    all    Light2 5.548379
#> 21  wetland    NA V1-C-3    all    all    Light1 5.484308
#> 22  wetland    NA V1-C-3    all    all    Light2 5.484308
#> 23  wetland    NA V1-C-4    all    all    Light1 5.686564
#> 24  wetland    NA V1-C-4    all    all    Light2 5.686564
#> 25  wetland    NA V1-C-6    all    all    Light1 4.779976
#> 26  wetland    NA V1-C-6    all    all    Light2 4.779976
#> 27  wetland    NA V1-C-7    all    all    Light1 4.692662
#> 28  wetland    NA V1-C-7    all    all    Light2 4.692662
#> 29  wetland    NA V1-C-8    all    all    Light1 4.887366
#> 30  wetland    NA V1-C-8    all    all    Light2 4.887366
#> 31  wetland    NA V2-C-1    all    all    Light1 4.231589
#> 32  wetland    NA V2-C-1    all    all    Light2 4.231589
#> 33  wetland    NA V2-C-2    all    all    Light1 4.238208
#> 34  wetland    NA V2-C-2    all    all    Light2 4.238208
#> 35  wetland    NA V2-C-3    all    all    Light1 4.121921
#> 36  wetland    NA V2-C-3    all    all    Light2 4.121921
#> 37  wetland    NA V3-C-2    all    all    Moist1 5.450611
#> 38  wetland    NA V3-C-2    all    all    Moist2 5.450611
#> 39  wetland    NA V1-C-5    all    all    Moist1 5.705182
#> 40  wetland    NA V1-C-5    all    all    Moist2 5.705182
#> 41  wetland    NA V4-C-2    all    all    Moist1 7.108910
#> 42  wetland    NA V4-C-2    all    all    Moist2 7.108910
#> 43  wetland    NA V4-C-3    all    all    Moist1 6.944127
#> 44  wetland    NA V4-C-3    all    all    Moist2 6.944127
#> 45  wetland    NA V8-C-1    all    all    Moist1 7.262666
#> 46  wetland    NA V8-C-1    all    all    Moist2 7.262666
#> 47  wetland    NA V8-C-2    all    all    Moist1 7.245583
#> 48  wetland    NA V8-C-2    all    all    Moist2 7.245583
#> 49  wetland    NA V8-C-3    all    all    Moist1 7.502367
#> 50  wetland    NA V8-C-3    all    all    Moist2 7.502367
#> 51  wetland    NA V3-C-1    all    all    Moist1 6.424165
#> 52  wetland    NA V3-C-1    all    all    Moist2 6.424165
#> 53  wetland    NA V1-C-1    all    all    Moist1 6.985401
#> 54  wetland    NA V1-C-1    all    all    Moist2 6.985401
#> 55  wetland    NA V1-C-2    all    all    Moist1 7.826415
#> 56  wetland    NA V1-C-2    all    all    Moist2 7.826415
#> 57  wetland    NA V1-C-3    all    all    Moist1 8.213247
#> 58  wetland    NA V1-C-3    all    all    Moist2 8.213247
#> 59  wetland    NA V1-C-4    all    all    Moist1 8.109657
#> 60  wetland    NA V1-C-4    all    all    Moist2 8.109657
#> 61  wetland    NA V1-C-6    all    all    Moist1 7.313205
#> 62  wetland    NA V1-C-6    all    all    Moist2 7.313205
#> 63  wetland    NA V1-C-7    all    all    Moist1 7.241861
#> 64  wetland    NA V1-C-7    all    all    Moist2 7.241861
#> 65  wetland    NA V1-C-8    all    all    Moist1 7.085127
#> 66  wetland    NA V1-C-8    all    all    Moist2 7.085127
#> 67  wetland    NA V2-C-1    all    all    Moist1 5.751619
#> 68  wetland    NA V2-C-1    all    all    Moist2 5.751619
#> 69  wetland    NA V2-C-2    all    all    Moist1 6.474238
#> 70  wetland    NA V2-C-2    all    all    Moist2 6.474238
#> 71  wetland    NA V2-C-3    all    all    Moist1 6.814557
#> 72  wetland    NA V2-C-3    all    all    Moist2 6.814557
#> 73  wetland    NA V3-C-2    all    all       pH1 2.069755
#> 74  wetland    NA V3-C-2    all    all       pH2 2.069755
#> 75  wetland    NA V1-C-5    all    all       pH1 2.328319
#> 76  wetland    NA V1-C-5    all    all       pH2 2.328319
#> 77  wetland    NA V4-C-2    all    all       pH1 3.802753
#> 78  wetland    NA V4-C-2    all    all       pH2 3.802753
#> 79  wetland    NA V4-C-3    all    all       pH1 4.389075
#> 80  wetland    NA V4-C-3    all    all       pH2 4.389075
#> 81  wetland    NA V8-C-1    all    all       pH1 4.182404
#> 82  wetland    NA V8-C-1    all    all       pH2 4.182404
#> 83  wetland    NA V8-C-2    all    all       pH1 4.750092
#> 84  wetland    NA V8-C-2    all    all       pH2 4.750092
#> 85  wetland    NA V8-C-3    all    all       pH1 4.913133
#> 86  wetland    NA V8-C-3    all    all       pH2 4.913133
#> 87  wetland    NA V3-C-1    all    all       pH1 1.951116
#> 88  wetland    NA V3-C-1    all    all       pH2 1.951116
#> 89  wetland    NA V1-C-1    all    all       pH1 1.971098
#> 90  wetland    NA V1-C-1    all    all       pH2 1.971098
#> 91  wetland    NA V1-C-2    all    all       pH1 2.737952
#> 92  wetland    NA V1-C-2    all    all       pH2 2.737952
#> 93  wetland    NA V1-C-3    all    all       pH1 3.592224
#> 94  wetland    NA V1-C-3    all    all       pH2 3.592224
#> 95  wetland    NA V1-C-4    all    all       pH1 4.566270
#> 96  wetland    NA V1-C-4    all    all       pH2 4.566270
#> 97  wetland    NA V1-C-6    all    all       pH1 3.168781
#> 98  wetland    NA V1-C-6    all    all       pH2 3.168781
#> 99  wetland    NA V1-C-7    all    all       pH1 3.405840
#> 100 wetland    NA V1-C-7    all    all       pH2 3.405840
#> 101 wetland    NA V1-C-8    all    all       pH1 4.278356
#> 102 wetland    NA V1-C-8    all    all       pH2 4.278356
#> 103 wetland    NA V2-C-1    all    all       pH1 2.849982
#> 104 wetland    NA V2-C-1    all    all       pH2 2.849982
#> 105 wetland    NA V2-C-2    all    all       pH1 3.625899
#> 106 wetland    NA V2-C-2    all    all       pH2 3.625899
#> 107 wetland    NA V2-C-3    all    all       pH1 4.107336
#> 108 wetland    NA V2-C-3    all    all       pH2 4.107336
#> 109 wetland    NA V3-C-2    all    all Nitrogen1 2.101967
#> 110 wetland    NA V3-C-2    all    all Nitrogen2 2.101967
#> 111 wetland    NA V1-C-5    all    all Nitrogen1 2.083033
#> 112 wetland    NA V1-C-5    all    all Nitrogen2 2.083033
#> 113 wetland    NA V4-C-2    all    all Nitrogen1 3.345274
#> 114 wetland    NA V4-C-2    all    all Nitrogen2 3.345274
#> 115 wetland    NA V4-C-3    all    all Nitrogen1 3.687148
#> 116 wetland    NA V4-C-3    all    all Nitrogen2 3.687148
#> 117 wetland    NA V8-C-1    all    all Nitrogen1 4.453431
#> 118 wetland    NA V8-C-1    all    all Nitrogen2 4.453431
#> 119 wetland    NA V8-C-2    all    all Nitrogen1 5.400094
#> 120 wetland    NA V8-C-2    all    all Nitrogen2 5.400094
#> 121 wetland    NA V8-C-3    all    all Nitrogen1 5.752526
#> 122 wetland    NA V8-C-3    all    all Nitrogen2 5.752526
#> 123 wetland    NA V3-C-1    all    all Nitrogen1 1.544669
#> 124 wetland    NA V3-C-1    all    all Nitrogen2 1.544669
#> 125 wetland    NA V1-C-1    all    all Nitrogen1 1.613392
#> 126 wetland    NA V1-C-1    all    all Nitrogen2 1.613392
#> 127 wetland    NA V1-C-2    all    all Nitrogen1 1.908494
#> 128 wetland    NA V1-C-2    all    all Nitrogen2 1.908494
#> 129 wetland    NA V1-C-3    all    all Nitrogen1 2.344593
#> 130 wetland    NA V1-C-3    all    all Nitrogen2 2.344593
#> 131 wetland    NA V1-C-4    all    all Nitrogen1 2.626977
#> 132 wetland    NA V1-C-4    all    all Nitrogen2 2.626977
#> 133 wetland    NA V1-C-6    all    all Nitrogen1 2.802510
#> 134 wetland    NA V1-C-6    all    all Nitrogen2 2.802510
#> 135 wetland    NA V1-C-7    all    all Nitrogen1 3.072115
#> 136 wetland    NA V1-C-7    all    all Nitrogen2 3.072115
#> 137 wetland    NA V1-C-8    all    all Nitrogen1 3.524687
#> 138 wetland    NA V1-C-8    all    all Nitrogen2 3.524687
#> 139 wetland    NA V2-C-1    all    all Nitrogen1 3.078022
#> 140 wetland    NA V2-C-1    all    all Nitrogen2 3.078022
#> 141 wetland    NA V2-C-2    all    all Nitrogen1 4.096205
#> 142 wetland    NA V2-C-2    all    all Nitrogen2 4.096205
#> 143 wetland    NA V2-C-3    all    all Nitrogen1 4.890875
#> 144 wetland    NA V2-C-3    all    all Nitrogen2 4.890875
#>           Gv maxmin
#> 1   4.650288      1
#> 2   5.242167      7
#> 3   4.412518      1
#> 4   4.983052      7
#> 5   4.181051      1
#> 6   5.575828      7
#> 7   4.265677      1
#> 8   5.728271      7
#> 9   4.026841      1
#> 10  5.326302      7
#> 11  4.331418      1
#> 12  5.131781      7
#> 13  4.379654      1
#> 14  4.977008      7
#> 15  4.676349      1
#> 16  6.777778      7
#> 17  4.735842      1
#> 18  6.835764      7
#> 19  4.684189      1
#> 20  6.753948      7
#> 21  4.644572      1
#> 22  6.487499      7
#> 23  4.552329      1
#> 24  6.494601      7
#> 25  4.219840      1
#> 26  5.423544      7
#> 27  4.166529      1
#> 28  5.433001      7
#> 29  4.206007      1
#> 30  5.758946      7
#> 31  3.657798      1
#> 32  4.953344      7
#> 33  3.446326      1
#> 34  4.940917      7
#> 35  3.242379      1
#> 36  4.738912      7
#> 37  4.730467      1
#> 38  6.287387     12
#> 39  5.024660      1
#> 40  6.515412     12
#> 41  5.959727      1
#> 42  7.929956     12
#> 43  6.072307      1
#> 44  7.598114     12
#> 45  6.041072      1
#> 46  8.132334     12
#> 47  6.519606      1
#> 48  7.905369     12
#> 49  6.665973      1
#> 50  8.189600     12
#> 51  4.473684      1
#> 52  8.467209     12
#> 53  4.805905      1
#> 54  9.142989     12
#> 55  5.703439      1
#> 56  9.337017     12
#> 57  6.503395      1
#> 58  9.445956     12
#> 59  6.530966      1
#> 60  9.294677     12
#> 61  5.518264      1
#> 62  9.248771     12
#> 63  5.869488      1
#> 64  8.685496     12
#> 65  5.712864      1
#> 66  8.097239     12
#> 67  4.851244      1
#> 68  8.797058     12
#> 69  5.141012      1
#> 70  8.285018     12
#> 71  5.556370      1
#> 72  8.218944     12
#> 73  1.655954      1
#> 74  2.814447      8
#> 75  1.858930      1
#> 76  2.983125      8
#> 77  3.022003      1
#> 78  4.769512      8
#> 79  3.495213      1
#> 80  5.344473      8
#> 81  3.322124      1
#> 82  4.879182      8
#> 83  4.279028      1
#> 84  5.202615      8
#> 85  4.502166      1
#> 86  5.280336      8
#> 87  1.082218      1
#> 88  3.292487      8
#> 89  1.304445      1
#> 90  4.000000      8
#> 91  1.623551      1
#> 92  4.376870      8
#> 93  2.307563      1
#> 94  4.848489      8
#> 95  2.929122      1
#> 96  5.959868      8
#> 97  2.201466      1
#> 98  4.330514      8
#> 99  2.663268      1
#> 100 4.365503      8
#> 101 3.267379      1
#> 102 5.369703      8
#> 103 2.388756      1
#> 104 4.133991      8
#> 105 2.926638      1
#> 106 4.478642      8
#> 107 3.325443      1
#> 108 4.837873      8
#> 109 1.798326      1
#> 110 2.488591      9
#> 111 1.707630      1
#> 112 2.676179      9
#> 113 2.638866      1
#> 114 4.191821      9
#> 115 2.841443      1
#> 116 5.207416      9
#> 117 3.634319      1
#> 118 5.308846      9
#> 119 4.680611      1
#> 120 6.103431      9
#> 121 5.067941      1
#> 122 6.270266      9
#> 123 1.006211      1
#> 124 2.200000      9
#> 125 1.049953      1
#> 126 2.539114      9
#> 127 1.202420      1
#> 128 3.136698      9
#> 129 1.360667      1
#> 130 3.836578      9
#> 131 1.712485      1
#> 132 3.948144      9
#> 133 2.067017      1
#> 134 3.660364      9
#> 135 2.368457      1
#> 136 3.880840      9
#> 137 2.553046      1
#> 138 4.784577      9
#> 139 2.482721      1
#> 140 4.157467      9
#> 141 3.222495      1
#> 142 5.004499      9
#> 143 3.954204      1
#> 144 5.899529      9
#>       N1               hoved               grunn   
#>  Length:144         Length:144         V1-C-1 : 8  
#>  Class :character   Class :character   V1-C-2 : 8  
#>  Mode  :character   Mode  :character   V1-C-3 : 8  
#>                                        V1-C-4 : 8  
#>                                        V1-C-5 : 8  
#>                                        V1-C-6 : 8  
#>                                        (Other):96  
#>     county             region                 Ind    
#>  Length:144         Length:144         Light1   :18  
#>  Class :character   Class :character   Light2   :18  
#>  Mode  :character   Mode  :character   Moist1   :18  
#>                                        Moist2   :18  
#>                                        Nitrogen1:18  
#>                                        Nitrogen2:18  
#>                                        (Other)  :36  
#>        Rv              Gv            maxmin     
#>  Min.   :1.545   Min.   :1.006   Min.   : 1.00  
#>  1st Qu.:3.391   1st Qu.:3.315   1st Qu.: 1.00  
#>  Median :4.690   Median :4.682   Median : 4.00  
#>  Mean   :4.646   Mean   :4.718   Mean   : 5.00  
#>  3rd Qu.:5.691   3rd Qu.:5.736   3rd Qu.: 8.25  
#>  Max.   :8.213   Max.   :9.446   Max.   :12.00  
#> 
```


```r
head(wetland.ref.cov.val)
#>        N1 hoved  grunn county region    Ind       Rv
#> 1 wetland    NA V3-C-2    all    all Light1 4.966443
#> 2 wetland    NA V3-C-2    all    all Light2 4.966443
#> 3 wetland    NA V1-C-5    all    all Light1 4.678375
#> 4 wetland    NA V1-C-5    all    all Light2 4.678375
#> 5 wetland    NA V4-C-2    all    all Light1 4.885976
#> 6 wetland    NA V4-C-2    all    all Light2 4.885976
#>         Gv maxmin
#> 1 4.650288      1
#> 2 5.242167      7
#> 3 4.412518      1
#> 4 4.983052      7
#> 5 4.181051      1
#> 6 5.575828      7
```

Once test data (ANO) and the scaling values from the reference data (NiN) are in place, we can calculate CWMs of the selected indicators for the ANO community data and scale them against the scaling values from the reference distribution. Note that we scale each ANO plot's CWM against either the lower threshold value and the min value OR the upper threshold value and the max value based on whether the CWM is smaller or higher than the reference value. Since the scaled values for both sides range between 0 and 1, we generate separate lower and upper condition indicators for each functional plant indicator. An ANO plot can only have a scaled value in either the lower or the upper indicator (the other one will be 'NA'), except for the unlikely event that the CWM exactly matches the reference value, in which case both lower and upper indicator will receive a scaled indicator value of 1.

Here is the scaling function

```r

#### scaled values ####
r.s <- 1    # reference value
l.s <- 0.6  # limit value
a.s <- 0    # abscence of indicator, or indicator at maximum

#### function for calculating scaled values for measured value ####

## scaling function including truncation
scal <- function() {
  # place to hold the result
   x <- numeric()
  if (maxmin < ref) {
    # values >= the reference value equal 1
    if (val >= ref) {x <- 1}
    # values < the reference value and >= the limit value can be deducted from the linear relationship between these two
    if (val < ref & val >= lim) {x <- (l.s + (val-lim) * ( (r.s-l.s) / (ref-lim) ) )}
    # values < the limit value and > maxmin can be deducted from the linear relationship between these two
    if (val < lim & val > maxmin) {x <- (a.s + (val-maxmin) * ( (l.s-a.s) / (lim-maxmin) ) )}
    # value equals or lower than maxmin
    if (val <= maxmin) {x <-0}
  } else {
    # values <= the reference value equal 1
    if (val <= ref) {x <- 1}
    # values > the reference value and <= the limit value can be deducted from the linear relationship between these two
    if (val > ref & val <= lim) {x <- ( r.s - ( (r.s - l.s) * (val - ref) / (lim - ref) ) )}
    # values > the limit value and < maxmin can be deducted from the linear relationship between these two
    if (val > lim) {x <- ( l.s - (l.s * (val - lim) / (maxmin - lim) ) )}
    # value equals or larger than maxmin
    if (val >= maxmin) {x <-0}
  }
  return(x)
  
}
```

We then can prepare a list of data frames to hold the results and perform the scaling according to the principles described in NINA report 1967 (Töpper and Jakobsson 2021)



```r

#### calculating scaled and non-truncated values for the indicators based on the dataset ####
for (i in 1:nrow(ANO.wetland) ) {  #
  tryCatch({
    print(i)
    print(paste(ANO.wetland$ano_flate_id[i]))
    print(paste(ANO.wetland$ano_punkt_id[i]))
#    ANO.wetland$Hovedoekosystem_sirkel[i]
#    ANO.wetland$Hovedoekosystem_rute[i]

    # if the ANO.hovedtype exists in the reference
    if (ANO.wetland$hovedtype_rute[i] %in% unique(substr(wetland.ref.cov.val$grunn,1,2)) ) {
      
      # if there is any species present in current ANO point  
      if ( length(ANO.sp.ind[ANO.sp.ind$ParentGlobalID==as.character(ANO.wetland$GlobalID[i]),'Species']) > 0 ) {
        

          
          # Light
          dat <- ANO.sp.ind[ANO.sp.ind$ParentGlobalID==as.character(ANO.wetland$GlobalID[i]),c('art_dekning','Light')]
          results.wetland[['original']][i,'richness'] <- nrow(dat)
          dat <- dat[!is.na(dat$Light),]
          
          if ( nrow(dat)>0 ) {
            
            val <- sum(dat[,'art_dekning'] * dat[,'Light'],na.rm=T) / sum(dat[,'art_dekning'],na.rm=T)
            # lower part of distribution
            ref <- wetland.ref.cov.val[wetland.ref.cov.val$Ind=='Light1' & wetland.ref.cov.val$grunn==as.character(results.wetland[['original']][i,"kartleggingsenhet_1m2"]),'Rv']
            lim <- wetland.ref.cov.val[wetland.ref.cov.val$Ind=='Light1' & wetland.ref.cov.val$grunn==as.character(results.wetland[['original']][i,"kartleggingsenhet_1m2"]),'Gv']
            maxmin <- wetland.ref.cov.val[wetland.ref.cov.val$Ind=='Light1' & wetland.ref.cov.val$grunn==as.character(results.wetland[['original']][i,"kartleggingsenhet_1m2"]),'maxmin']
            # coercing x into results.wetland dataframe
            results.wetland[['scaled']][i,'Light1'] <- scal() 
            results.wetland[['non-truncated']][i,'Light1'] <- scal.2() 
            results.wetland[['original']][i,'Light1'] <- val 
            
            # upper part of distribution
            ref <- wetland.ref.cov.val[wetland.ref.cov.val$Ind=='Light2' & wetland.ref.cov.val$grunn==as.character(results.wetland[['original']][i,"kartleggingsenhet_1m2"]),'Rv']
            lim <- wetland.ref.cov.val[wetland.ref.cov.val$Ind=='Light2' & wetland.ref.cov.val$grunn==as.character(results.wetland[['original']][i,"kartleggingsenhet_1m2"]),'Gv']
            maxmin <- wetland.ref.cov.val[wetland.ref.cov.val$Ind=='Light2' & wetland.ref.cov.val$grunn==as.character(results.wetland[['original']][i,"kartleggingsenhet_1m2"]),'maxmin']
            # coercing x into results.wetland dataframe
            results.wetland[['scaled']][i,'Light2'] <- scal() 
            results.wetland[['non-truncated']][i,'Light2'] <- scal.2() 
            results.wetland[['original']][i,'Light2'] <- val
          }
          
          
          # Moisture
          dat <- ANO.sp.ind[ANO.sp.ind$ParentGlobalID==as.character(ANO.wetland$GlobalID[i]),c('art_dekning','Moisture')]
          results.wetland[['original']][i,'richness'] <- nrow(dat)
          dat <- dat[!is.na(dat$Moisture),]
          
          if ( nrow(dat)>0 ) {
            
            val <- sum(dat[,'art_dekning'] * dat[,'Moisture'],na.rm=T) / sum(dat[,'art_dekning'],na.rm=T)
            # lower part of distribution
            ref <- wetland.ref.cov.val[wetland.ref.cov.val$Ind=='Moist1' & wetland.ref.cov.val$grunn==as.character(results.wetland[['original']][i,"kartleggingsenhet_1m2"]),'Rv']
            lim <- wetland.ref.cov.val[wetland.ref.cov.val$Ind=='Moist1' & wetland.ref.cov.val$grunn==as.character(results.wetland[['original']][i,"kartleggingsenhet_1m2"]),'Gv']
            maxmin <- wetland.ref.cov.val[wetland.ref.cov.val$Ind=='Moist1' & wetland.ref.cov.val$grunn==as.character(results.wetland[['original']][i,"kartleggingsenhet_1m2"]),'maxmin']
            # coercing x into results.wetland dataframe
            results.wetland[['scaled']][i,'Moist1'] <- scal() 
            results.wetland[['non-truncated']][i,'Moist1'] <- scal.2() 
            results.wetland[['original']][i,'Moist1'] <- val 
            
            # upper part of distribution
            ref <- wetland.ref.cov.val[wetland.ref.cov.val$Ind=='Moist2' & wetland.ref.cov.val$grunn==as.character(results.wetland[['original']][i,"kartleggingsenhet_1m2"]),'Rv']
            lim <- wetland.ref.cov.val[wetland.ref.cov.val$Ind=='Moist2' & wetland.ref.cov.val$grunn==as.character(results.wetland[['original']][i,"kartleggingsenhet_1m2"]),'Gv']
            maxmin <- wetland.ref.cov.val[wetland.ref.cov.val$Ind=='Moist2' & wetland.ref.cov.val$grunn==as.character(results.wetland[['original']][i,"kartleggingsenhet_1m2"]),'maxmin']
            # coercing x into results.wetland dataframe
            results.wetland[['scaled']][i,'Moist2'] <- scal() 
            results.wetland[['non-truncated']][i,'Moist2'] <- scal.2() 
            results.wetland[['original']][i,'Moist2'] <- val
          }
          
          
          # Soil_reaction_pH
          dat <- ANO.sp.ind[ANO.sp.ind$ParentGlobalID==as.character(ANO.wetland$GlobalID[i]),c('art_dekning','Soil_reaction_pH')]
          results.wetland[['original']][i,'richness'] <- nrow(dat)
          dat <- dat[!is.na(dat$Soil_reaction_pH),]
          
          if ( nrow(dat)>0 ) {
            
            val <- sum(dat[,'art_dekning'] * dat[,'Soil_reaction_pH'],na.rm=T) / sum(dat[,'art_dekning'],na.rm=T)
            # lower part of distribution
            ref <- wetland.ref.cov.val[wetland.ref.cov.val$Ind=='pH1' & wetland.ref.cov.val$grunn==as.character(results.wetland[['original']][i,"kartleggingsenhet_1m2"]),'Rv']
            lim <- wetland.ref.cov.val[wetland.ref.cov.val$Ind=='pH1' & wetland.ref.cov.val$grunn==as.character(results.wetland[['original']][i,"kartleggingsenhet_1m2"]),'Gv']
            maxmin <- wetland.ref.cov.val[wetland.ref.cov.val$Ind=='pH1' & wetland.ref.cov.val$grunn==as.character(results.wetland[['original']][i,"kartleggingsenhet_1m2"]),'maxmin']
            # coercing x into results.wetland dataframe
            results.wetland[['scaled']][i,'pH1'] <- scal() 
            results.wetland[['non-truncated']][i,'pH1'] <- scal.2() 
            results.wetland[['original']][i,'pH1'] <- val 
            
            # upper part of distribution
            ref <- wetland.ref.cov.val[wetland.ref.cov.val$Ind=='pH2' & wetland.ref.cov.val$grunn==as.character(results.wetland[['original']][i,"kartleggingsenhet_1m2"]),'Rv']
            lim <- wetland.ref.cov.val[wetland.ref.cov.val$Ind=='pH2' & wetland.ref.cov.val$grunn==as.character(results.wetland[['original']][i,"kartleggingsenhet_1m2"]),'Gv']
            maxmin <- wetland.ref.cov.val[wetland.ref.cov.val$Ind=='pH2' & wetland.ref.cov.val$grunn==as.character(results.wetland[['original']][i,"kartleggingsenhet_1m2"]),'maxmin']
            # coercing x into results.wetland dataframe
            results.wetland[['scaled']][i,'pH2'] <- scal() 
            results.wetland[['non-truncated']][i,'pH2'] <- scal.2() 
            results.wetland[['original']][i,'pH2'] <- val
          }
          
          
          # Nitrogen
          dat <- ANO.sp.ind[ANO.sp.ind$ParentGlobalID==as.character(ANO.wetland$GlobalID[i]),c('art_dekning','Nitrogen')]
          results.wetland[['original']][i,'richness'] <- nrow(dat)
          dat <- dat[!is.na(dat$Nitrogen),]
          
          if ( nrow(dat)>0 ) {
            
            val <- sum(dat[,'art_dekning'] * dat[,'Nitrogen'],na.rm=T) / sum(dat[,'art_dekning'],na.rm=T)
            # lower part of distribution
            ref <- wetland.ref.cov.val[wetland.ref.cov.val$Ind=='Nitrogen1' & wetland.ref.cov.val$grunn==as.character(results.wetland[['original']][i,"kartleggingsenhet_1m2"]),'Rv']
            lim <- wetland.ref.cov.val[wetland.ref.cov.val$Ind=='Nitrogen1' & wetland.ref.cov.val$grunn==as.character(results.wetland[['original']][i,"kartleggingsenhet_1m2"]),'Gv']
            maxmin <- wetland.ref.cov.val[wetland.ref.cov.val$Ind=='Nitrogen1' & wetland.ref.cov.val$grunn==as.character(results.wetland[['original']][i,"kartleggingsenhet_1m2"]),'maxmin']
            # coercing x into results.wetland dataframe
            results.wetland[['scaled']][i,'Nitrogen1'] <- scal() 
            results.wetland[['non-truncated']][i,'Nitrogen1'] <- scal.2() 
            results.wetland[['original']][i,'Nitrogen1'] <- val 
            
            # upper part of distribution
            ref <- wetland.ref.cov.val[wetland.ref.cov.val$Ind=='Nitrogen2' & wetland.ref.cov.val$grunn==as.character(results.wetland[['original']][i,"kartleggingsenhet_1m2"]),'Rv']
            lim <- wetland.ref.cov.val[wetland.ref.cov.val$Ind=='Nitrogen2' & wetland.ref.cov.val$grunn==as.character(results.wetland[['original']][i,"kartleggingsenhet_1m2"]),'Gv']
            maxmin <- wetland.ref.cov.val[wetland.ref.cov.val$Ind=='Nitrogen2' & wetland.ref.cov.val$grunn==as.character(results.wetland[['original']][i,"kartleggingsenhet_1m2"]),'maxmin']
            # coercing x into results.wetland dataframe
            results.wetland[['scaled']][i,'Nitrogen2'] <- scal() 
            results.wetland[['non-truncated']][i,'Nitrogen2'] <- scal.2() 
            results.wetland[['original']][i,'Nitrogen2'] <- val
          }
          
        }
      }
      

    
  }, error=function(e){cat("ERROR :",conditionMessage(e), "\n")})
}

# for using both sides of the plant indicators
results.wetland[['2-sided']] <- results.wetland[['non-truncated']]

# remove values >1 for 2-sided indicators
results.wetland[['2-sided']]$Light1[results.wetland[['2-sided']]$Light1>1] <- NA
results.wetland[['2-sided']]$Light2[results.wetland[['2-sided']]$Light2>1] <- NA

results.wetland[['2-sided']]$Moist1[results.wetland[['2-sided']]$Moist1>1] <- NA
results.wetland[['2-sided']]$Moist2[results.wetland[['2-sided']]$Moist2>1] <- NA

results.wetland[['2-sided']]$pH1[results.wetland[['2-sided']]$pH1>1] <- NA
results.wetland[['2-sided']]$pH2[results.wetland[['2-sided']]$pH2>1] <- NA

results.wetland[['2-sided']]$Nitrogen1[results.wetland[['2-sided']]$Nitrogen1>1] <- NA
results.wetland[['2-sided']]$Nitrogen2[results.wetland[['2-sided']]$Nitrogen2>1] <- NA

```




```r
head(results.wetland[['2-sided']])
#>                                 GlobalID
#> 1 {36BAE83E-F412-4C90-8B56-DE6B4225BB17}
#> 2 {662B047A-411B-42F1-8F2F-E24602CBF350}
#> 3 {F003E630-94CD-4FFF-839B-772299BF697A}
#> 4 {F8239C33-99BD-4EEE-85A9-04A10772858D}
#> 5 {95E184F4-9560-4ADC-A7A9-75AD9A97D654}
#> 6 {6C11D423-9559-4C61-9036-C1309E0C6328}
#>      registeringsdato klokkeslett_start ano_flate_id
#> 1 2019-08-16 11:59:59             13:19      ANO0003
#> 2 2019-08-16 11:59:59             15:38      ANO0003
#> 3 2019-08-16 11:59:59             15:07      ANO0003
#> 4 2019-08-16 11:59:59             13:58      ANO0003
#> 5 2019-08-16 11:59:59             12:06      ANO0003
#> 6 2019-08-15 11:59:59             15:43      ANO0003
#>   ano_punkt_id         ssb_id program
#> 1   ANO0003_35 20940006559500     ANO
#> 2   ANO0003_44 20940006559500     ANO
#> 3   ANO0003_64 20940006559500     ANO
#> 4   ANO0003_55 20940006559500     ANO
#> 5   ANO0003_15 20940006559500     ANO
#> 6   ANO0003_51 20940006559500     ANO
#>                                                                   instruks
#> 1 https://nedlasting.miljodirektoratet.no/naturovervaking/ano_instruks.pdf
#> 2 https://nedlasting.miljodirektoratet.no/naturovervaking/ano_instruks.pdf
#> 3 https://nedlasting.miljodirektoratet.no/naturovervaking/ano_instruks.pdf
#> 4 https://nedlasting.miljodirektoratet.no/naturovervaking/ano_instruks.pdf
#> 5 https://nedlasting.miljodirektoratet.no/naturovervaking/ano_instruks.pdf
#> 6 https://nedlasting.miljodirektoratet.no/naturovervaking/ano_instruks.pdf
#>    aar      dataansvarlig_mdir                   dataeier
#> 1 2019 Ole Einar Butli Hårstad Miljødirektoratet, VAL/VMK
#> 2 2019 Ole Einar Butli Hårstad Miljødirektoratet, VAL/VMK
#> 3 2019 Ole Einar Butli Hårstad Miljødirektoratet, VAL/VMK
#> 4 2019 Ole Einar Butli Hårstad Miljødirektoratet, VAL/VMK
#> 5 2019 Ole Einar Butli Hårstad Miljødirektoratet, VAL/VMK
#> 6 2019 Ole Einar Butli Hårstad Miljødirektoratet, VAL/VMK
#>        vaer hovedoekosystem_punkt
#> 1 overskyet              vaatmark
#> 2       sol              vaatmark
#> 3       sol              vaatmark
#> 4       sol              vaatmark
#> 5       sol              vaatmark
#> 6    nedbør              vaatmark
#>   andel_hovedoekosystem_punkt utilgjengelig_punkt
#> 1                          NA                <NA>
#> 2                          NA                <NA>
#> 3                          NA                <NA>
#> 4                          NA                <NA>
#> 5                          NA                <NA>
#> 6                          NA                <NA>
#>   utilgjengelig_begrunnelse  gps noeyaktighet
#> 1                      <NA> <NA>         <NA>
#> 2                      <NA> <NA>         <NA>
#> 3                      <NA> <NA>         <NA>
#> 4                      <NA> <NA>         <NA>
#> 5                      <NA> <NA>         <NA>
#> 6                      <NA> <NA>         <NA>
#>   kommentar_posisjon klokkeslett_karplanter_start
#> 1               <NA>                         <NA>
#> 2               <NA>                         <NA>
#> 3               <NA>                         <NA>
#> 4               <NA>                         <NA>
#> 5               <NA>                         <NA>
#> 6               <NA>                         <NA>
#>   art_alle_registrert karplanter_dekning
#> 1                <NA>               85.1
#> 2                <NA>               81.0
#> 3                <NA>               79.0
#> 4                <NA>               51.1
#> 5                <NA>               71.0
#> 6                <NA>               11.3
#>   klokkeslett_karplanter_slutt karplanter_feltsjikt
#> 1                         <NA>                   NA
#> 2                         <NA>                   NA
#> 3                         <NA>                   NA
#> 4                         <NA>                   NA
#> 5                         <NA>                   NA
#> 6                         <NA>                   NA
#>   moser_dekning torvmoser_dekning lav_dekning stroe_dekning
#> 1            20                20           0            60
#> 2             5                 0           0            45
#> 3            85                75           0            15
#> 4            80                60           0            75
#> 5            80                80           0            23
#> 6            85                85           0             1
#>   jord_grus_stein_berg_dekning stubber_kvister_dekning
#> 1                           NA                      NA
#> 2                           NA                      NA
#> 3                           NA                      NA
#> 4                           NA                      NA
#> 5                           NA                      NA
#> 6                           NA                      NA
#>   alger_fjell_dekning
#> 1                  NA
#> 2                  NA
#> 3                  NA
#> 4                  NA
#> 5                  NA
#> 6                  NA
#>                                 kommentar_ruteanalyse
#> 1                                                <NA>
#> 2                                                <NA>
#> 3                                                <NA>
#> 4 har noen arter som er i V1C2 men bare veldig lokalt
#> 5                                                <NA>
#> 6                                                <NA>
#>   fastmerker kommentar_fastmerker kartleggingsenhet_1m2
#> 1       <NA>                 <NA>                V1-C-5
#> 2       <NA>                 <NA>                V1-C-1
#> 3       <NA>                 <NA>                V1-C-1
#> 4       <NA>                 <NA>                V1-C-1
#> 5       <NA>                 <NA>                V1-C-1
#> 6       <NA>                 <NA>                V1-C-1
#>       hovedtype_1m2                      ke_beskrivelse_1m2
#> 1 Åpen jordvannsmyr svært og temmelig kalkfattige myrkanter
#> 2 Åpen jordvannsmyr svært og temmelig kalkfattige myrflater
#> 3 Åpen jordvannsmyr svært og temmelig kalkfattige myrflater
#> 4 Åpen jordvannsmyr svært og temmelig kalkfattige myrflater
#> 5 Åpen jordvannsmyr svært og temmelig kalkfattige myrflater
#> 6 Åpen jordvannsmyr svært og temmelig kalkfattige myrflater
#>   kartleggingsenhet_250m2 hovedtype_250m2
#> 1                    <NA>            <NA>
#> 2                    <NA>            <NA>
#> 3                    <NA>            <NA>
#> 4                    <NA>            <NA>
#> 5                    <NA>            <NA>
#> 6                    <NA>            <NA>
#>   ke_beskrivelse_250m2 andel_kartleggingsenhet_250m2
#> 1                 <NA>                            NA
#> 2                 <NA>                            NA
#> 3                 <NA>                            NA
#> 4                 <NA>                            NA
#> 5                 <NA>                            NA
#> 6                 <NA>                            NA
#>   groeftingsintensitet bruksintensitet beitetrykk
#> 1                    1               1         NA
#> 2                    1               1         NA
#> 3                    1               1         NA
#> 4                    1               1         NA
#> 5                    1               1         NA
#> 6                    1               1         NA
#>   slatteintensitet tungekjoretoy slitasje forekomst_ntyp
#> 1                1             0        0            nei
#> 2                1             0        0            nei
#> 3                1             0        0            nei
#> 4                1             0        0            nei
#> 5                1             0        0            nei
#> 6                1             0        0            nei
#>   ntyp
#> 1 <NA>
#> 2 <NA>
#> 3 <NA>
#> 4 <NA>
#> 5 <NA>
#> 6 <NA>
#>                                                    kommentar_naturtyperegistering
#> 1                         en del gjengroing med bjørk og einer, noen store furuer
#> 2                                                                            <NA>
#> 3                        40% bærlyngskog T4C5, rute i overgang mellom myr og skog
#> 4                                                   noen store furuer, litt bjørk
#> 5 delvis myr, ganske mye lyng, virker som det gror igjen med bjørk, einer og furu
#> 6                                             rute ligger i en streng i fattigmyr
#>   side_5_note krypende_vier_dekning
#> 1        <NA>                     0
#> 2        <NA>                     0
#> 3        <NA>                     0
#> 4        <NA>                     0
#> 5        <NA>                     0
#> 6        <NA>                     0
#>   ikke_krypende_vier_dekning vedplanter_total_dekning
#> 1                          1                       30
#> 2                          0                        7
#> 3                          0                       45
#> 4                          3                       17
#> 5                          0                       53
#> 6                          0                        5
#>   busker_dekning tresjikt_dekning treslag_registrert
#> 1             12               15               <NA>
#> 2              1                3               <NA>
#> 3             12                8               <NA>
#> 4              8               12               <NA>
#> 5             13                8               <NA>
#> 6              2                0               <NA>
#>   roesslyng_dekning roesslyngblad pa_dekning pa_note
#> 1                NA          <NA>         NA    <NA>
#> 2                NA          <NA>         NA    <NA>
#> 3                NA          <NA>         NA    <NA>
#> 4                NA          <NA>         NA    <NA>
#> 5                NA          <NA>         NA    <NA>
#> 6                NA          <NA>         NA    <NA>
#>   pa_registrert fa_total_dekning fa_registrert
#> 1          <NA>                0          <NA>
#> 2          <NA>                0          <NA>
#> 3          <NA>                0          <NA>
#> 4          <NA>                0          <NA>
#> 5          <NA>                0          <NA>
#> 6          <NA>                0          <NA>
#>        kommentar_250m2_flate klokkeslett_slutt
#> 1          litt nakent berg              13:33
#> 2                       <NA>             15:45
#> 3                       <NA>             15:17
#> 4                       <NA>             14:12
#> 5 en bekk går gjennom flaten             12:19
#> 6                       <NA>             15:50
#>                                                                                             vedlegg_url
#> 1 https://nin-felles-test.miljodirektoratet.no/api/Overvaking/list/36bae83e-f412-4c90-8b56-de6b4225bb17
#> 2 https://nin-felles-test.miljodirektoratet.no/api/Overvaking/list/662b047a-411b-42f1-8f2f-e24602cbf350
#> 3 https://nin-felles-test.miljodirektoratet.no/api/Overvaking/list/f003e630-94cd-4fff-839b-772299bf697a
#> 4 https://nin-felles-test.miljodirektoratet.no/api/Overvaking/list/f8239c33-99bd-4eee-85a9-04a10772858d
#> 5 https://nin-felles-test.miljodirektoratet.no/api/Overvaking/list/95e184f4-9560-4adc-a7a9-75ad9a97d654
#> 6 https://nin-felles-test.miljodirektoratet.no/api/Overvaking/list/6c11d423-9559-4c61-9036-c1309e0c6328
#>                    creator        creationdate
#> 1 chrpot_miljodirektoratet 2019-09-09 10:54:17
#> 2 chrpot_miljodirektoratet 2019-09-09 10:56:19
#> 3 chrpot_miljodirektoratet 2019-09-09 10:57:21
#> 4 chrpot_miljodirektoratet 2019-09-09 10:58:29
#> 5 chrpot_miljodirektoratet 2019-09-09 10:59:26
#> 6 chrpot_miljodirektoratet 2019-09-09 10:59:58
#>                     editor            editdate
#> 1 chrpot_miljodirektoratet 2019-09-09 10:54:17
#> 2 chrpot_miljodirektoratet 2019-09-09 10:56:19
#> 3 chrpot_miljodirektoratet 2019-09-09 10:57:21
#> 4 chrpot_miljodirektoratet 2019-09-09 10:58:29
#> 5 chrpot_miljodirektoratet 2019-09-09 10:59:26
#> 6 chrpot_miljodirektoratet 2019-09-09 10:59:58
#>   hovedtype_rute    Light1    Light2    Moist1    Moist2
#> 1             V1        NA 0.8862960        NA 0.5304041
#> 2             V1 0.5888900        NA        NA 0.9309185
#> 3             V1 0.5834686        NA 0.6960238        NA
#> 4             V1        NA 0.9386198        NA 0.8013800
#> 5             V1 0.7360043        NA 0.6614711        NA
#> 6             V1        NA 0.9581721        NA 0.8824488
#>         pH1       pH2 Nitrogen1 Nitrogen2
#> 1 0.7102018        NA        NA 0.8024127
#> 2        NA 0.9748303        NA 0.6355716
#> 3        NA 0.8994699        NA 0.6743312
#> 4        NA 0.5594912        NA 0.5791890
#> 5 0.9750870        NA        NA 0.8390342
#> 6        NA 0.8547261        NA 0.9476639
```
#### Scaled value analyses

In order to visualize the results we need to rearrange the results-objects from wide to long format (note that there is both a lower and an upper condition indicator for each of the functional plant indicators).


```r
#### plotting scaled values by main ecosystem type ####
## continuing with 2-sided
res.wetland <- results.wetland[['2-sided']]

# make long version of the scaled value part
res.wetland <-
  res.wetland %>% 
  pivot_longer(
    cols = c("Light1","Light2","Moist1","Moist2","pH1","pH2","Nitrogen1","Nitrogen2"),
    names_to = "fp_ind",
    values_to = "scaled_value",
    values_drop_na = FALSE
  )

# add original values as well
res.wetland <- 
  res.wetland %>% add_column(original = results.wetland[['original']] %>% 
                               pivot_longer(
                                 cols =  c("Light1","Light2","Moist1","Moist2","pH1","pH2","Nitrogen1","Nitrogen2"),
                                 names_to = NULL,
                                 values_to = "original",
                                 values_drop_na = FALSE
                               ) %>%
                               pull(original)
  )
```

### Ecosystem sub-types
And we can show the resulting scaled values as Violin plots for each indicator and main ecosystem type 
<img src="functional_plant_indicators_wetland_files/figure-html/unnamed-chunk-20-1.png" width="672" />
The functional signature from the plant communities in wetland ecosystems looks largely good, except for V2 (swamp forests), which show rather low index scores for the lower pH and Nitrogen indicators, i.e. suggesting too acidic conditions and too low nitrogen availability.

We can look at V2 specifically to see if this is the case for all sub-types.


```r
# making the plot for V2 only
ggplot(res.wetland[res.wetland$hovedtype_rute=="V2",], aes(x=factor(kartleggingsenhet_1m2), y=scaled_value, fill=fp_ind)) + 
  geom_hline(yintercept=0.6, linetype="dashed") + 
  geom_violin() +
  #  geom_boxplot(width=0.2, color="grey") +
  geom_point(size=0.7, shape=16, color="grey") +
  facet_wrap(~factor(fp_ind,levels=c("Light1","Moist1","pH1","Nitrogen1","Light2","Moist2","pH2","Nitrogen2")), ncol = 4) + 
  xlab("Main ecosystem type") + 
  ylab("Scaled indicator value") 
#> Warning: Removed 556 rows containing non-finite values
#> (`stat_ydensity()`).
#> Warning: Groups with fewer than two data points have been dropped.
#> Groups with fewer than two data points have been dropped.
#> Warning: Removed 556 rows containing missing values
#> (`geom_point()`).
```

<img src="functional_plant_indicators_wetland_files/figure-html/unnamed-chunk-21-1.png" width="672" />
The deviations towards low pH and low nitrogen are mainly an issue for V2-C1, limestone-poor swamp forests.

### Indicator index maps
We can also show the results as a map, for instance for pH1 (the lower pH indicator), either by directly plotting the data onto the map...

```
#> Reading layer `outlineOfNorway_EPSG25833' from data source 
#>   `/data/scratch/Matt_bookdown__debug/ecosystemCondition/data/outlineOfNorway_EPSG25833.shp' 
#>   using driver `ESRI Shapefile'
#> Simple feature collection with 1 feature and 2 fields
#> Geometry type: MULTIPOLYGON
#> Dimension:     XY
#> Bounding box:  xmin: -113472.7 ymin: 6448359 xmax: 1114618 ymax: 7939917
#> Projected CRS: ETRS89 / UTM zone 33N
#> Reading layer `regions' from data source 
#>   `/data/scratch/Matt_bookdown__debug/ecosystemCondition/data/regions.shp' 
#>   using driver `ESRI Shapefile'
#> Simple feature collection with 5 features and 2 fields
#> Geometry type: POLYGON
#> Dimension:     XY
#> Bounding box:  xmin: -99551.21 ymin: 6426048 xmax: 1121941 ymax: 7962744
#> Projected CRS: ETRS89 / UTM zone 33N
#> [1] "Nord-Norge"      "Midt-Norge"      "Ã\u0098stlandet"
#> [4] "Vestlandet"      "SÃ¸rlandet"
```

<img src="functional_plant_indicators_wetland_files/figure-html/unnamed-chunk-22-1.png" width="672" />
...but here the colors and values of the data points on the map are hard to make out.

### Regions - maps and statistics
Alternatively we can calculate and show the region-wise means and their related standard errors. But note that calculating a simple mean would be inappropriate for these data. This is because:
(i) the scaled data are bound between 0 and 1, and thus follow a beta-distribution rather than a Gaussian one
(ii) the ANO dataset has a nested structure

Therefore, we need to (i) use a beta-model, that (ii) can account for the nested structure of the data.
Here, we apply the following function using either a glmmTMB null-model with a beta-distribution, logit link, and the nesting as a random intercept, or a simple betareg null-model with logit link if the nesting is not extensive enough for a mixed model.

```r
library(betareg)
library(glmmTMB)
#> Warning in checkMatrixPackageVersion(): Package version inconsistency detected.
#> TMB was built with Matrix version 1.5.3
#> Current Matrix version is 1.5.1
#> Please re-install 'TMB' from source using install.packages('TMB', type = 'source') or ask CRAN for a binary version of 'TMB' matching CRAN's 'Matrix' package
#> Warning in checkDepPackageVersion(dep_pkg = "TMB"): Package version inconsistency detected.
#> glmmTMB was built with TMB version 1.9.2
#> Current TMB version is 1.9.4
#> Please re-install glmmTMB from source or restore original 'TMB' package (see '?reinstalling' for more information)

expit <- function(L) exp(L) / (1+exp(L)) # since the beta-models use a logit link, we need to calculate the estimates back to the identity scale

# the function performs a glmmTMB if there's >= 5 random levels in the nesting structure
# if that is not the case, then the function performs a betareg if theres >= 2 observations
# if that is not the case either, then the function returns the value of the single observation with NA standard error

indmean.beta <- function(df) {

  st_geometry(df) <- NULL
  colnames(df) <- c("y","ran")
  
  if ( nrow(df[!is.na(df[,1]),]) >= 2 ) {
    
    if ( length(unique(df[!is.na(df[,1]),2])) >=5 ) {
      
      mod1 <- glmmTMB(y ~ 1 +(1|ran), family=beta_family(), data=df)
      
      return(c(
        expit(summary( mod1 )$coefficients$cond[1]),
        
        expit( summary( mod1 )$coefficients$cond[1] + 
                 summary( mod1 )$coefficients$cond[2] )-
          expit( summary( mod1 )$coefficients$cond[1] ),
        
        nrow(df[!is.na(df$y),]),
        summary( mod1 )$coefficients$cond[1],
        summary( mod1 )$coefficients$cond[2]
      ))
      
    } else {
      
      mod2 <- betareg(y ~ 1, data=df)
      
      return(c(
        expit(summary( mod2 )$coefficients$mean[1]),
        expit( summary( mod2 )$coefficients$mean[1] + 
                 summary( mod2 )$coefficients$mean[2] )-
          expit( summary( mod2 )$coefficients$mean[1] ),
        nrow(df[!is.na(df$y),]),
        summary( mod2 )$coefficients$mean[1],
        summary( mod2 )$coefficients$mean[2]
      ))
      
    }
    
  } else {
    
    return(c(df$y,NA,1,NA,NA))
    
  }

}
```


```r

res.wetland2 = st_join(res.wetland2, regnor, left = TRUE)

regnor <- regnor %>%
  mutate(
    pH1.reg.mean = c(indmean.beta(df=res.wetland2[res.wetland2$region=="Northern Norway",c("pH1","ano_flate_id")])[1],
                                 indmean.beta(df=res.wetland2[res.wetland2$region=="Central Norway",c("pH1","ano_flate_id")])[1],
                                 indmean.beta(df=res.wetland2[res.wetland2$region=="Eastern Norway",c("pH1","ano_flate_id")])[1],
                                 indmean.beta(df=res.wetland2[res.wetland2$region=="Western Norway",c("pH1","ano_flate_id")])[1],
                                 indmean.beta(df=res.wetland2[res.wetland2$region=="Southern Norway",c("pH1","ano_flate_id")])[1]
    ),
    pH1.reg.se = c(indmean.beta(df=res.wetland2[res.wetland2$region=="Northern Norway",c("pH1","ano_flate_id")])[2],
                               indmean.beta(df=res.wetland2[res.wetland2$region=="Central Norway",c("pH1","ano_flate_id")])[2],
                               indmean.beta(df=res.wetland2[res.wetland2$region=="Eastern Norway",c("pH1","ano_flate_id")])[2],
                               indmean.beta(df=res.wetland2[res.wetland2$region=="Western Norway",c("pH1","ano_flate_id")])[2],
                               indmean.beta(df=res.wetland2[res.wetland2$region=="Southern Norway",c("pH1","ano_flate_id")])[2]
    ),
    pH1.reg.n = c(nrow(res.wetland2[res.wetland2$region=="Northern Norway" & !is.na(res.wetland2$pH1),]),
                              nrow(res.wetland2[res.wetland2$region=="Central Norway" & !is.na(res.wetland2$pH1),]),
                              nrow(res.wetland2[res.wetland2$region=="Eastern Norway" & !is.na(res.wetland2$pH1),]),
                              nrow(res.wetland2[res.wetland2$region=="Western Norway" & !is.na(res.wetland2$pH1),]),
                              nrow(res.wetland2[res.wetland2$region=="Southern Norway" & !is.na(res.wetland2$pH1),])
    )
  )


## scaled value maps for pH1 (lower indicator)
# mean
tm_shape(regnor) +
  tm_polygons(col="pH1.reg.mean", title="pH (lower), mean", style="quantile", palette=rev(get_brewer_pal(palette="OrRd", n=5, plot=FALSE))) +
  tm_text("pH1.reg.n",col="black",bg.color="grey")
```

<img src="functional_plant_indicators_wetland_files/figure-html/unnamed-chunk-24-1.png" width="672" />
Mean index value by region for the lower pH indicator (i.e. index shows deviations towards a more acidic environment). Numbers in grey fields show the number of observations in the respective region.


```r
# se
tm_shape(regnor) +
  tm_polygons(col="pH1.reg.se", title="pH (lower), sd", style="quantile", palette=get_brewer_pal(palette="OrRd", n=5, plot=FALSE)) +
  tm_text("pH1.reg.n",col="black",bg.color="grey")
```

<img src="functional_plant_indicators_wetland_files/figure-html/unnamed-chunk-25-1.png" width="672" />
Standard error to the mean index value by region for the lower pH indicator. Numbers in grey fields show the number of observations in the respective region.


### unscaled values vs. reference
We can also compare the unscaled values to the reference distribution in order to identify ecosystem types and functional plant indicators showing a deviation from the expectation. Since pH and nitrogen show some deviation of the lower pH indicator we exemplify this with these indicators for unscaled values.


```r
summary(res.wetland$kartleggingsenhet_1m2)
#>      V1  V1-C-1  V1-C-2  V1-C-3  V1-C-4  V1-C-5  V1-C-6 
#>       8    2144    1224     448     160    2424    1248 
#>  V1-C-7  V1-C-8 V10-C-1 V10-C-3 V11-C-1     V12 V12-C-1 
#>     320      48      40       8      16      16     152 
#> V12-C-2      V2  V2-C-1  V2-C-2  V2-C-3      V3  V3-C-1 
#>       8       8     832     224      32      40     440 
#>  V3-C-2      V4  V4-C-1  V4-C-2  V4-C-4  V6-C-1  V6-C-2 
#>     472       8      32      72       8      64       8 
#>  V6-C-3  V6-C-4  V6-C-5  V6-C-7  V6-C-9  V8-C-1  V8-C-2 
#>      72      40       8       8       8      16       8 
#>  V9-C-1  V9-C-2  V9-C-3 
#>      80      16      16
length(unique(res.wetland$kartleggingsenhet_1m2))
#> [1] 38
# 16 NiN-types to plot
colnames(wetland.ref.cov[['Soil_reaction_pH']])
#>  [1] "V3-C1a" "V3-C1b" "V3-C1c" "V3-C1d" "V3-C1e" "V1-C1a"
#>  [7] "V1-C1b" "V1-C1c" "V1-C1d" "V1-C1e" "V1-C2a" "V1-C2b"
#> [13] "V1-C2c" "V1-C2d" "V1-C3a" "V1-C3b" "V1-C3c" "V1-C3d"
#> [19] "V1-C4a" "V1-C4b" "V1-C4c" "V1-C4d" "V1-C4e" "V1-C4f"
#> [25] "V1-C4g" "V1-C4h" "V3-C2"  "V1-C5"  "V1-C6a" "V1-C6b"
#> [31] "V1-C7a" "V1-C7b" "V1-C8a" "V1-C8b" "V2-C1a" "V2-C1b"
#> [37] "V2-C2a" "V2-C2b" "V2-C3a" "V2-C3b" "V4-C2"  "V4-C3" 
#> [43] "V8-C1"  "V8-C2"  "V8-C3"

### pH
par(mfrow=c(2,4))
## V1s
# V1-C-1
plot(density( as.matrix(wetland.ref.cov[['Soil_reaction_pH']][,c("V1-C1a","V1-C1b","V1-C1c","V1-C1d","V1-C1e")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='V1-C1',xlab='pH value')
points(density(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V1-C-1",]$original,na.rm=T),
       type="l", col="red")
points(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V1-C-1",]$original,
       rep(0,length(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V1-C-1",]$original)),
       col="red")

# V1-C-2
plot(density( as.matrix(wetland.ref.cov[['Soil_reaction_pH']][,c("V1-C2a","V1-C2b","V1-C2c","V1-C2d")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='V1-C2',xlab='pH value')
points(density(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V1-C-2",]$original,na.rm=T),
       type="l", col="red")
points(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V1-C-2",]$original,
       rep(0,length(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V1-C-2",]$original)),
       col="red")

# V1-C-3
plot(density( as.matrix(wetland.ref.cov[['Soil_reaction_pH']][,c("V1-C3a","V1-C3b","V1-C3c","V1-C3d")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='V1-C3',xlab='pH value')
points(density(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V1-C-3",]$original,na.rm=T),
       type="l", col="red")
points(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V1-C-3",]$original,
       rep(0,length(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V1-C-3",]$original)),
       col="red")

# V1-C-4
plot(density( as.matrix(wetland.ref.cov[['Soil_reaction_pH']][,c("V1-C4a","V1-C4b","V1-C4c","V1-C4d","V1-C4e","V1-C4f","V1-C4g","V1-C4h")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='V1-C4',xlab='pH value')
points(density(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V1-C-4",]$original,na.rm=T),
       type="l", col="red")
points(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V1-C-4",]$original,
       rep(0,length(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V1-C-4",]$original)),
       col="red")

# V1-C-5
plot(density( as.matrix(wetland.ref.cov[['Soil_reaction_pH']][,c("V1-C5")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='V1-C5',xlab='pH value')
points(density(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V1-C-5",]$original,na.rm=T),
       type="l", col="red")
points(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V1-C-5",]$original,
       rep(0,length(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V1-C-5",]$original)),
       col="red")

# V1-C-6
plot(density( as.matrix(wetland.ref.cov[['Soil_reaction_pH']][,c("V1-C6a","V1-C6b")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='V1-C6',xlab='pH value')
points(density(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V1-C-6",]$original,na.rm=T),
       type="l", col="red")
points(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V1-C-6",]$original,
       rep(0,length(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V1-C-6",]$original)),
       col="red")

# V1-C-7
plot(density( as.matrix(wetland.ref.cov[['Soil_reaction_pH']][,c("V1-C7a","V1-C7b")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='V1-C7',xlab='pH value')
points(density(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V1-C-7",]$original,na.rm=T),
       type="l", col="red")
points(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V1-C-7",]$original,
       rep(0,length(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V1-C-7",]$original)),
       col="red")

# V1-C-8
plot(density( as.matrix(wetland.ref.cov[['Soil_reaction_pH']][,c("V1-C8a","V1-C8b")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='V1-C8',xlab='pH value')
points(density(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V1-C-8",]$original,na.rm=T),
       type="l", col="red")
points(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V1-C-8",]$original,
       rep(0,length(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V1-C-8",]$original)),
       col="red")
```

<img src="functional_plant_indicators_wetland_files/figure-html/unnamed-chunk-26-1.png" width="672" />

```r

par(mfrow=c(2,4))
## V2s
# V2-C-1
plot(density( as.matrix(wetland.ref.cov[['Soil_reaction_pH']][,c("V2-C1a","V2-C1b")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='V2-C1',xlab='pH value')
points(density(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V2-C-1",]$original,na.rm=T),
       type="l", col="red")
points(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V2-C-1",]$original,
       rep(0,length(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V2-C-1",]$original)),
       col="red")

# V2-C-2
plot(density( as.matrix(wetland.ref.cov[['Soil_reaction_pH']][,c("V2-C2a","V2-C2b")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='V2-C2',xlab='pH value')
points(density(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V2-C-2",]$original,na.rm=T),
       type="l", col="red")
points(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V2-C-2",]$original,
       rep(0,length(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V2-C-2",]$original)),
       col="red")

# V2-C-3
plot(density( as.matrix(wetland.ref.cov[['Soil_reaction_pH']][,c("V2-C3a","V2-C3b")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='V2-C3',xlab='pH value')
points(density(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V2-C-3",]$original,na.rm=T),
       type="l", col="red")
points(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V2-C-3",]$original,
       rep(0,length(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V2-C-3",]$original)),
       col="red")

## V3s
# V3-C-1
plot(density( as.matrix(wetland.ref.cov[['Soil_reaction_pH']][,c("V3-C1a","V3-C1b","V3-C1c","V3-C1d","V3-C1e")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='V3-C1',xlab='pH value')
points(density(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V3-C-1",]$original,na.rm=T),
       type="l", col="red")
points(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V3-C-1",]$original,
       rep(0,length(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V3-C-1",]$original)),
       col="red")

# V3-C-2
plot(density( as.matrix(wetland.ref.cov[['Soil_reaction_pH']][,c("V3-C2")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='V3-C2',xlab='pH value')
points(density(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V3-C-2",]$original,na.rm=T),
       type="l", col="red")
points(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V3-C-2",]$original,
       rep(0,length(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V3-C-2",]$original)),
       col="red")

## V4s
# V4-C-2
plot(density( as.matrix(wetland.ref.cov[['Soil_reaction_pH']][,c("V4-C2")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='V4-C2',xlab='pH value')
points(density(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V4-C-2",]$original,na.rm=T),
       type="l", col="red")
points(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V4-C-2",]$original,
       rep(0,length(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V4-C-2",]$original)),
       col="red")


## V8s
# V8-C-1
plot(density( as.matrix(wetland.ref.cov[['Soil_reaction_pH']][,c("V8-C1")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='V8-C1',xlab='pH value')
#points(density(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V8-C-1",]$original,na.rm=T),
#       type="l", col="red")
points(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V8-C-1",]$original,
       rep(0,length(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V8-C-1",]$original)),
       col="red")

# V8-C-2
plot(density( as.matrix(wetland.ref.cov[['Soil_reaction_pH']][,c("V8-C2")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='V8-C2',xlab='pH value')
#points(density(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V8-C-2",]$original,na.rm=T),
#       type="l", col="red")
points(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V8-C-2",]$original,
       rep(0,length(res.wetland[res.wetland$fp_ind=="pH1" & res.wetland$fp_ind=="pH1" & res.wetland$kartleggingsenhet_1m2=="V8-C-2",]$original)),
       col="red")
legend("topleft", legend=c("reference","field data"), pch=c(NA,1), lty=1, col=c("black","red"))
```

<img src="functional_plant_indicators_wetland_files/figure-html/unnamed-chunk-26-2.png" width="672" />

```r




### Nitrogen
par(mfrow=c(2,4))
## V1s
# V1-C-1
plot(density( as.matrix(wetland.ref.cov[['Nitrogen']][,c("V1-C1a","V1-C1b","V1-C1c","V1-C1d","V1-C1e")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='V1-C1',xlab='Nitrogen value')
points(density(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V1-C-1",]$original,na.rm=T),
       type="l", col="red")
points(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V1-C-1",]$original,
       rep(0,length(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V1-C-1",]$original)),
       col="red")

# V1-C-2
plot(density( as.matrix(wetland.ref.cov[['Nitrogen']][,c("V1-C2a","V1-C2b","V1-C2c","V1-C2d")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='V1-C2',xlab='Nitrogen value')
points(density(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V1-C-2",]$original,na.rm=T),
       type="l", col="red")
points(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V1-C-2",]$original,
       rep(0,length(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V1-C-2",]$original)),
       col="red")

# V1-C-3
plot(density( as.matrix(wetland.ref.cov[['Nitrogen']][,c("V1-C3a","V1-C3b","V1-C3c","V1-C3d")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='V1-C3',xlab='Nitrogen value')
points(density(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V1-C-3",]$original,na.rm=T),
       type="l", col="red")
points(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V1-C-3",]$original,
       rep(0,length(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V1-C-3",]$original)),
       col="red")

# V1-C-4
plot(density( as.matrix(wetland.ref.cov[['Nitrogen']][,c("V1-C4a","V1-C4b","V1-C4c","V1-C4d","V1-C4e","V1-C4f","V1-C4g","V1-C4h")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='V1-C4',xlab='Nitrogen value')
points(density(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V1-C-4",]$original,na.rm=T),
       type="l", col="red")
points(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V1-C-4",]$original,
       rep(0,length(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V1-C-4",]$original)),
       col="red")

# V1-C-5
plot(density( as.matrix(wetland.ref.cov[['Nitrogen']][,c("V1-C5")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='V1-C5',xlab='Nitrogen value')
points(density(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V1-C-5",]$original,na.rm=T),
       type="l", col="red")
points(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V1-C-5",]$original,
       rep(0,length(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V1-C-5",]$original)),
       col="red")

# V1-C-6
plot(density( as.matrix(wetland.ref.cov[['Nitrogen']][,c("V1-C6a","V1-C6b")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='V1-C6',xlab='Nitrogen value')
points(density(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V1-C-6",]$original,na.rm=T),
       type="l", col="red")
points(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V1-C-6",]$original,
       rep(0,length(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V1-C-6",]$original)),
       col="red")

# V1-C-7
plot(density( as.matrix(wetland.ref.cov[['Nitrogen']][,c("V1-C7a","V1-C7b")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='V1-C7',xlab='Nitrogen value')
points(density(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V1-C-7",]$original,na.rm=T),
       type="l", col="red")
points(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V1-C-7",]$original,
       rep(0,length(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V1-C-7",]$original)),
       col="red")

# V1-C-8
plot(density( as.matrix(wetland.ref.cov[['Nitrogen']][,c("V1-C8a","V1-C8b")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='V1-C8',xlab='Nitrogen value')
points(density(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V1-C-8",]$original,na.rm=T),
       type="l", col="red")
points(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V1-C-8",]$original,
       rep(0,length(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V1-C-8",]$original)),
       col="red")
```

<img src="functional_plant_indicators_wetland_files/figure-html/unnamed-chunk-26-3.png" width="672" />

```r

par(mfrow=c(2,4))
## V2s
# V2-C-1
plot(density( as.matrix(wetland.ref.cov[['Nitrogen']][,c("V2-C1a","V2-C1b")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='V2-C1',xlab='Nitrogen value')
points(density(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V2-C-1",]$original,na.rm=T),
       type="l", col="red")
points(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V2-C-1",]$original,
       rep(0,length(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V2-C-1",]$original)),
       col="red")

# V2-C-2
plot(density( as.matrix(wetland.ref.cov[['Nitrogen']][,c("V2-C2a","V2-C2b")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='V2-C2',xlab='Nitrogen value')
points(density(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V2-C-2",]$original,na.rm=T),
       type="l", col="red")
points(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V2-C-2",]$original,
       rep(0,length(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V2-C-2",]$original)),
       col="red")

# V2-C-3
plot(density( as.matrix(wetland.ref.cov[['Nitrogen']][,c("V2-C3a","V2-C3b")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='V2-C3',xlab='Nitrogen value')
points(density(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V2-C-3",]$original,na.rm=T),
       type="l", col="red")
points(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V2-C-3",]$original,
       rep(0,length(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V2-C-3",]$original)),
       col="red")

## V3s
# V3-C-1
plot(density( as.matrix(wetland.ref.cov[['Nitrogen']][,c("V3-C1a","V3-C1b","V3-C1c","V3-C1d","V3-C1e")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='V3-C1',xlab='Nitrogen value')
points(density(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V3-C-1",]$original,na.rm=T),
       type="l", col="red")
points(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V3-C-1",]$original,
       rep(0,length(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V3-C-1",]$original)),
       col="red")

# V3-C-2
plot(density( as.matrix(wetland.ref.cov[['Nitrogen']][,c("V3-C2")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='V3-C2',xlab='Nitrogen value')
points(density(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V3-C-2",]$original,na.rm=T),
       type="l", col="red")
points(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V3-C-2",]$original,
       rep(0,length(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V3-C-2",]$original)),
       col="red")

## V4s
# V4-C-2
plot(density( as.matrix(wetland.ref.cov[['Nitrogen']][,c("V4-C2")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='V4-C2',xlab='Nitrogen value')
points(density(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V4-C-2",]$original,na.rm=T),
       type="l", col="red")
points(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V4-C-2",]$original,
       rep(0,length(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V4-C-2",]$original)),
       col="red")

## V8s
# V8-C-1
plot(density( as.matrix(wetland.ref.cov[['Nitrogen']][,c("V8-C1")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='V8-C1',xlab='Nitrogen value')
#points(density(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V8-C-1",]$original,na.rm=T),
#       type="l", col="red")
points(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V8-C-1",]$original,
       rep(0,length(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V8-C-1",]$original)),
       col="red")

# V8-C-2
plot(density( as.matrix(wetland.ref.cov[['Nitrogen']][,c("V8-C2")]) ,na.rm=T),
     xlim=c(1,7), type="l", main='V8-C2',xlab='Nitrogen value')
#points(density(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V8-C-2",]$original,na.rm=T),
#       type="l", col="red")
points(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V8-C-2",]$original,
       rep(0,length(res.wetland[res.wetland$fp_ind=="Nitrogen1" & res.wetland$fp_ind=="Nitrogen1" & res.wetland$kartleggingsenhet_1m2=="V8-C-2",]$original)),
       col="red")

legend("topleft", legend=c("reference","field data"), pch=c(NA,1), lty=1, col=c("black","red"))
```

<img src="functional_plant_indicators_wetland_files/figure-html/unnamed-chunk-26-4.png" width="672" />
THe figure shows that deviations mainly occur in V2-C1, which represents limestone-poor swamp forests. According to the functional signature from the plant community composition many of the occurrences of this ecosystem type are too acidic and may have too low availability of nitrogen. 

### Eksport file (final product)
<!-- Export final file. Ideally a georeferenced shape or raster wit indicators values (raw and normalised), reference values and errors. -->




