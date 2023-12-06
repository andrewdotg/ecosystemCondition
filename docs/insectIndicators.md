# Insect indicators

<br />

_Author and date:_

Jens Åström
Marie Davey 

2023-12-05


<br />


<!-- Load all you dependencies here -->







<!-- Fill in which ecosystem the indicator belongs to, as well as the ecosystem characteristic it should be linked to. It's OK to use some Norwegian here -->



```{=html}
<div class="tabwid"><style>.cl-809c7056{table-layout:auto;}.cl-808f7630{font-family:'DejaVu Sans';font-size:11pt;font-weight:bold;font-style:normal;text-decoration:none;color:rgba(0, 0, 0, 1.00);background-color:transparent;}.cl-808f7644{font-family:'DejaVu Sans';font-size:11pt;font-weight:normal;font-style:normal;text-decoration:none;color:rgba(0, 0, 0, 1.00);background-color:transparent;}.cl-809595d8{margin:0;text-align:left;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);padding-bottom:5pt;padding-top:5pt;padding-left:5pt;padding-right:5pt;line-height: 1;background-color:transparent;}.cl-8095bd1a{background-color:rgba(173, 216, 230, 1.00);vertical-align: middle;border-bottom: 1.5pt solid rgba(102, 102, 102, 1.00);border-top: 1.5pt solid rgba(102, 102, 102, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-8095bd2e{background-color:transparent;vertical-align: middle;border-bottom: 0.75pt solid rgba(102, 102, 102, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-8095bd38{background-color:transparent;vertical-align: middle;border-bottom: 0.75pt solid rgba(102, 102, 102, 1.00);border-top: 0.75pt solid rgba(102, 102, 102, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-8095bd39{background-color:transparent;vertical-align: middle;border-bottom: 1.5pt solid rgba(102, 102, 102, 1.00);border-top: 0.75pt solid rgba(102, 102, 102, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}</style><table data-quarto-disable-processing='true' class='cl-809c7056'><thead><tr style="overflow-wrap:break-word;"><th class="cl-8095bd1a"><p class="cl-809595d8"><span class="cl-808f7630">Ecosystem</span></p></th><th class="cl-8095bd1a"><p class="cl-809595d8"><span class="cl-808f7630">Økologisk egenskap</span></p></th><th class="cl-8095bd1a"><p class="cl-809595d8"><span class="cl-808f7630">ECT class</span></p></th></tr></thead><tbody><tr style="overflow-wrap:break-word;"><td class="cl-8095bd2e"><p class="cl-809595d8"><span class="cl-808f7644">Semi-naturlig mark</span></p></td><td class="cl-8095bd2e"><p class="cl-809595d8"><span class="cl-808f7644">Biologisk mangfold</span></p></td><td class="cl-8095bd2e"><p class="cl-809595d8"><span class="cl-808f7644">Functional state characteristics</span></p></td></tr><tr style="overflow-wrap:break-word;"><td class="cl-8095bd38"><p class="cl-809595d8"><span class="cl-808f7644">Semi-naturlig mark</span></p></td><td class="cl-8095bd38"><p class="cl-809595d8"><span class="cl-808f7644">Funksjonelle grupper innen trofiske nivåer</span></p></td><td class="cl-8095bd38"><p class="cl-809595d8"><span class="cl-808f7644">Functional state characteristics</span></p></td></tr><tr style="overflow-wrap:break-word;"><td class="cl-8095bd39"><p class="cl-809595d8"><span class="cl-808f7644">Semi-naturlig mark</span></p></td><td class="cl-8095bd39"><p class="cl-809595d8"><span class="cl-808f7644">Funksjonelt viktige arter og biofysiske strukturer</span></p></td><td class="cl-8095bd39"><p class="cl-809595d8"><span class="cl-808f7644">Functional state characteristics</span></p></td></tr></tbody></table></div>
```

<!-- Don't remove these three html lines -->
<br />
<br />
<hr />


## Introduction
We here show how to calculate a set of indicators for terrestrial insects in Norway. Two of them are adapted from earlier work on the Nature Index for Norway and use data from the Norwegian monitoring program on bumblebees and butterflies (**NMBB**). The others are developed during 2023, and use data from the Norwegian insect monitoring program (**NorIns**). 

This workflow is shortened by putting most of the underlying code in separate R-packages, which are freely available through Github. The relevant packages are `bombLepiSurv` https://github.com/jenast/bombLepiSurv for the bumblebee and butterfly indicators, and `Norimon` https://github.com/jenast/Norimon for the rest of the indicators.

For the indicators from the NMBB program, community reference values has been elicited from experts, and is explained further below. For the indicators from the NorIns program, this is significantly harder to do, because of the size of the communities, lack of historical timeseries and changes in sampling and identification techniques. We therefore currently lack reference values for many of these indicators.

Below is a list of the indicators calculated in this document, and their state of development. Some details is further expanded on below.




|Dataset |Indicator                                        |Norwegian type                                     |ECT |Current geographical scope                         |Indicator data |Reference values |
|:-------|:------------------------------------------------|:--------------------------------------------------|:---|:--------------------------------------------------|:--------------|:----------------|
|NMBB    |Bumblebees in semi-natural grasslands            |Funksjonelt viktige arter og biofysiske stukturer  |B2  |Sørlandet, Østfold-Vestfold, Vestlandet, Trøndelag |Present        |Present          |
|NMBB    |Butterflies in semi-natural grasslands           |Biologisk mangfold                                 |B1  |Sørlandet, Østfold-Vestfold, Vestlandet, Trøndelag |Present        |Present          |
|NorIns  |Biomass of flying insects                        |Funksjonelt viktige arter og biofysiske stukturer  |B2  |Sørlandet, Østlandet, Trøndelag, Nord-Norge        |Present        |Lacking          |
|NorIns  |Species richness of flying insects               |Biologisk mangfold                                 |B1  |Sørlandet, Østlandet, Trøndelag, Nord-Norge        |Present        |Lacking          |
|NorIns  |Species richness of pollinating insects          |Biologisk mangfold                                 |B1  |Sørlandet, Østlandet, Trøndelag, Nord-Norge        |Present        |Lacking          |
|NorIns  |Species richness of dung associated insects      |Biologisk mangfold                                 |B1  |Sørlandet, Østlandet, Trøndelag, Nord-Norge        |Present        |Lacking          |
|NorIns  |Quotent of Apocrita vs Symphyta species richness |Funksjonelt viktige arter og biofysiske strukturer |B2  |Sørlandet, Østlandet, Trøndelag, Nord-Norge        |Present        |Lacking          |
|NorIns  |Number of alien species                          |Biologisk mangfold                                 |B1  |Sørlandet, Østlandet, Trøndelag, Nord-Norge        |Present        |Lacking          |
|NorIns  |Intraspesific genetic variation                  |Biologisk mangfold                                 |B1  |Sørlandet, Østlandet, Trøndelag, Nord-Norge        |Present        |Lacking          |
Many of these indicators are self-explanatory and don't require much justification. **Bumblebees in semi-natural grasslands** and **Butterflies in semi-natural grasslands** are functionally important pollinators, and are as a community dependent on a varied herbaceous flora. They therefore both represent key functionality, as well as indicators of habitat quality. **Biomass of flying insects** represent a key functional characteristic in ecosystem functioning as food for insectivores, and as a response to habitat quality and management. **Species richness of flying insects** represents the total breadth of the insect community, and **Species richness of pollinating insects** complements the butterfly and bumblebee indicators in taxonomic breadth and spatial resolution.
**Species richness of dung associated insects** represent a key functional group in decomposition, and function as an indicator of grazing intensity and diversity. **Quotent of Apocrita vs Symphyta species richness** tries to go beyond simple amounts, and capture compositional changes in the insect community. Apocrita covers predatory and parasitic wasps, while Symphyta is plant-feeding wasps. A relative decrease in predatory/parasitic wasps could indicate a degradation in insect prey communities, and a decrease in the potential for natural pest control. This indicator is optionally given as just the species richness of Apocrita. **Number of alien species** takes into account the number of alien species found in a region and optionally, the frequency of sampling events they are observed in. This is based on the alien species list from the Norwegian Biodiversity Information Center, which lists known alien species and an increasing list of door-knocker species. Note that due to large historical knowledge gaps of insect species distributions, there could potentially be many more alien species in Norway, which are not picked up on this alien species list. Lastly, **Intraspecific genetic variation** captures biodiversity that until now has been hidden, due to lack of practical technologies to measure it. The need to conserve genetic diversity is identified in Norwegian law, and decreases in intraspecific diversity could signal population decreases, and a decreased potential to adapt to environmental changes, before whole species are lost to an area. 


## About the underlying data
The data used here comes from the ongoing monitoring programs "Norwegian insect monitoring" ([NorIns](https://www.nina.no/Naturmangfold/Insekter/Overv%C3%A5king-av-insekter)) and "Norwegian monitoring of bumblebees and butterflies" ([NMBB](https://www.nina.no/V%C3%A5re-fagomr%C3%A5der/Milj%C3%B8overv%C3%A5king-p%C3%A5-land/Humler-og-dagsommerfugler)). Both programs are initiated and financed by the Environmental agency, with the aim to produce continuous area representative time-series of insect community data. The **NorIns** program use malaise and window traps to sample a broad community of insect species, which are identified through metabarcoding of DNA. The **NMBB** program use sweep netting along transect walks where the species are identified manually in the field. More information is available in the links above.

### Representativity in time and space
The **NorIns** program started in 2020 with monitoring in semi-natural land and forests in the south-eastern region of Norway (Østlandet), with the long-term ambition to cover the entire country. In 2021, the program was expanded to semi-natural land in central Norway (Trøndelag), in 2022 to semi-natural land in south-western Norway (Sørlandet), and in 2023 to semi-natural land in northern Norway (Nord-Norge), with a possible expansion to western Norway (Vestlandet) in 2024. So far, forest habitats are only monitored in south-eastern Norway.

The monitoring program is designed to produce estimates with a spatial resolution of these 5 large regions. Finer resolution could be evaluated in the future, although it is unlikely to be feasible without more intense sampling. The program uses a staggered sampling scheme where we visit different locations each year, and return to each location every 5 years. This sampling scheme, coupled with the strong yearly variation in insect abundances makes it reasonable to use a temporal resolution of 5 years. The indicator values from **NorIns** are therefore calculated on 5 year long rolling windows. 

The **NMBB** program started in 2009 in a subset of south-eastern Norway (counties of Vestfold and Østfold), and was expanded to central Norway (Trøndelag) in 2010, south-western Norway in 2013, and to western Norway (Vestland and Møre og Romsdal fylke) in 2022. The spatial resolution aligns with these (as of now) 4 regions, and it is not recommended to downscale the predictions due to the limited number of sampling locations in each region. Since the same locations are visited each year, yearly estimates of the condition could be calculated, but should be interpreted by caution due to natural yearly variability.

Both programs are designed to be area representative, within their respective habitat types and regions. Both use stratified randomized selection of localities. The **NorIns** program selects localities by random draws within habitat strata, and the **NMBB** by a predefined continuous network of survey squares, within which individual transects are then manually placed. In both programs, some subjective decisions are made in the definition of habitat criteria and in discarding unpractical survey locations.


### Original units
The original units from **NorIns** include number of species, total biomass as wet weight, and inter-specific genetic diversity (unit to be determined). For the **NMBB** program, original units are number of individuals of each species within a transect, although only presences in transects (as presence frequencies) are used for the indicator calculations.


### Temporal coverage
2009-present for the **NMBB** data, and 2020-present for the **NorIns** data.


## Ecosystem characteristic
### Norwegian standard
Three of the indicators are tied to the *Økologisk egenskap* (Ecological characteristic) of **Funksjonelt viktige arter og biofysiske stukturer** (Funktionally important species and structures), and the other six to **Biologisk mangfold** (Biodiversity).

### UN standard
Six of the indicators are tied to the UN standard (ECT-classes) **B1 Compositional state characteristics**, and the two remaining to **B2 Structural state characteristics**.


## Collinearities with other indicators
None measured so far, but it is reasonable to assume that some of these indicators will share some causal factors, and therefore correlate to some degree. They might also correlate to other indicators as well, not described here.

## Reference condition and values
The reference condition is meant to be one with minimal negative human impact, but this has a special interpretation for semi-natural land. These habitats are formed and maintained through human activities. Thus, "minimal negative human impact" is replaced by a state of "good maintenance", here understood as resembling the traditional agricultural maintenance regime, existing for several hundred years up until the late 1800s. This is characterized by extensive grazing, meadows and lays, crop rotation with legumes to bind nitrogen in addition to fertilization from manure, relatively small field sizes and abundant field margins, and a lack of artificial fertilization and mechanized tilling. 


### Reference condition
Assessing the current state of insect communities is a complicated task, due to their taxonomic and functional breadth and high temporal and spatial variability. Still, even more challenging is establishing reference values, when the reference states are extinct or prohibitively difficult to measure empirically. We currently lack reference values for all indicators from the **NorIns** program, except for the alien species indicators where the reference value is zero by definition. It is unlikely that this can be solved by "simply" surveying a state in a reference area, since intact reference areas of sufficient size and numbers likely no longer exist. The question of how to handle these reference values is currently unresolved, and we present these indicator value calculations with made up reference values as placeholders in the code.

For the **NMBB** indicators, the communities are small enough and well-known enough to identify reference communities by expert opinion. These communities specify the expected rate of observing each species. The current rates of observation are then compared to the expected rates. The calculations are further explained below.


### Reference values, thresholds for defining _good ecological condition_, minimum and/or maximum values
<!-- Text here -->
The specific reference communities for the **NMBB** indicators won't be spelled out here, see instead the scripts below. We have not specified a value for _good ecological condition_ as of yet, since we lack a straightforward empirical basis to do so. By default then, the values is set to 0.6 , following the general framework.

## Uncertainties
The uncertainties for the indicator values is calculated by bootstrapping the values for each locality within a year. This takes the variability between the localities into account. For the **NorIns** indicators, these uncertainties are given as standard deviation, as well as confidence intervals. The uncertainties for the **NMBB** indicators are constituted by a distribution of discrete values, and therefore we only provide confidence intervals and not a standard deviation. 

## References

* French, C. M., Bertola, L. D., Carnaval, A. C., Economo, E. P., Kass, J. M., Lohman, D. J., … Hickerson, M. J. 2023, juli 17. Global determinants of insect mitochondrial genetic diversity. bioRxiv. bioRxiv. https://doi.org/10.1101/2022.02.09.479762

* Miraldo, A., Li, S., Borregaard, M. K., Flórez-Rodríguez, A., Gopalakrishnan, S., Rizvanovic, M., … Nogués-Bravo, D. 2016. An Anthropocene map of genetic diversity. Science 353(6307): 1532–1535. https://doi.org/10.1126/science.aaf4381

* Rohde, K. 1992. Latitudinal Gradients in Species Diversity: The Search for the Primary Cause. Oikos 65(3): 514. https://doi.org/10.2307/3545569

* Theodoridis, S., Fordham, D. A., Brown, S. C., Li, S., Rahbek, C., & Nogues-Bravo, D. 2020. Evolutionary history and past climate change shape the distribution of genetic diversity in terrestrial mammals. Nature Communications 11(1): 2557. https://doi.org/10.1038/s41467-020-16449-5

* Åström, Jens; Birkemoe, Tone; Brandsegg, Hege; Dahle, Sondre; Davey, Marie Louise; Ekrem, Torbjørn; Fossøy, Frode; Hanssen, Oddvar; Laugsand, Arne Endre; Majaneva, Markus; Staverløkk, Arnstein; Sverdrup-Thygeson, Anne; Ødegaard, Frode.
Insektovervåking på Østlandet, Sørlandet og i Trøndelag. Rapport fra feltsesong 2022. Trondheim: Norsk institutt for naturforskning (NINA) 2023 (ISBN 978‐82‐426‐5037‐5) 99 s. NINA rapport(2241)

* Åström, Sandra Charlotte Helene; Åström, Jens; Bøhn, Kristoffer; Gjershaug, Jan Ove; Staverløkk, Arnstein; Dahle, Sondre; Ødegaard, Frode. Nasjonal overvåking av dagsommerfugler og humler i Norge. Oppsummering av aktiviteten i 2022. Trondheim: Norsk institutt for naturforskning (NINA) 2023 (ISBN 978-82-426-5009-2) 54 s. NINA rapport(2214)

* Öberg, S., Gjershaug, J. O., Diserud, O. & Ødegaard, F. 2011. Videreutvikling av metodikk for 
arealrepresentativ overvåking av dagsommerfugler og humler. Naturindeks for Norge. – NINA 
Rapport 663. 


## Analyses

### Calculation principles for NorIns indicators
The indicators from the Norwegian insect monitoring are calculated with functions in the `Norimon` R-package [link](https://github.com/NINAnor/Norimon). This methodology is meant to facilitate the calculation of a broad variety of insect indicators using data from **NorIns**.

**Main steps of workflow:**

1. Fetch data of biomass or community diversity from a centralized database. Diversity data can be filtered on several taxonomic levels, but biomass is only available for whole samples.
2. Bootstrap observations and calculate mean and uncertainty of point estimates.
3. Compare observations to reference points.
4. Display and plot the results

<img src="images/NorIns_flow_chart.png" width="400pt" />

Most of the ecology comes into step 1, in choosing what data to use to describe a quality. This can be a custom selection of species, or a set of higher taxa such as specific genuses, families or even order. The goal is to choose a set of taxa that represent specific qualities of the community that can indicate the ecological status of the ecosystem. In addition to the selection of taxa, we have to decide on the level of spatial and temporal aggregation, e.g. if we should aggregate the data spatially on the region scale, habitat scale or locality scale, and if we should aggregate it temporally on yearly or even the individual sample occasions within years. For the ecological indicators, we will aggregate the raw observation values to the year locality scale, where the data summarize all catches in a locality in a year.

The second step is to get an estimate of the uncertainty of the data, were we use the bootstrap method. This method is also flexible, as we could bootstrap the samples on different sampling levels (e.g. samples within localities, localities within a region, or regions within country). When working with raw data on the year locality level, the most granular bootstrap would be to summarize the variables to the yearly, habitat, and regional level, for example expressing the mean values of insect biomass in semi-natural land and forests in Østlandet in 2021, with uncertainty. 

Ecological knowledge also comes into step 3, comparing the values to a reference state. Here we have several options. We could for example use a single defined value as the reference state. But we can also use a point in time as a reference point (e.g. the start of a time series).

Taken together, this framework is meant to facilitate the calculation of an arbitrary set of insect indicators, based on the combination of choices in data to fetch, aggregation level, and reference comparison. We showcase the framework by working through an example with pollinators. 

In the example we start with connecting to the database, in order to fetch the data.


```r
connect_to_insect_db()
```



For convenience, the pollinator families can be retrieved by the `get_pollinators()` function.


```r
pollinators <- get_pollinators()

pollinators_fam <- pollinators %>%
  select(family_latin) %>%
  pull()
```



|family_norwegian          |family_latin |
|:-------------------------|:------------|
|Gravebier                 |Andrenidae   |
|Langtungbebier            |Apidae       |
|Korttungebier             |Colletidae   |
|Markbier                  |Halictidae   |
|Buksamlerbier             |Megachilidae |
|Blomsterbier              |Melittidae   |
|Blomfluer                 |Syrphidae    |
|Smygere                   |Hesperiidae  |
|Glansvinger               |Lycaenidae   |
|Nymfevinger               |Nymphalidae  |
|Svalestjerter             |Papilionidae |
|Hvitvinger                |Pieridae     |
|Metallmerker (uoffisiell) |Riodinidae   |
<br/>
We then fetch the community data for these families through the `get_observations` function. We additionally subset the habitat type that we are interested in, here semi-natural land. The result is a tibble of the aggregated number of species, shannon diversity, and the mean number of genetic variants per species. The default aggregation level is "year_locality", meaning the total observations for a locality within a year. 

Note that the output currently contains some experimental values, awaiting a more robust methodology. "Shannon diversity" doesn't really make sense without counts or amounts, etc. This will be replaced by measurements of genetic diversity that are based on published peer-reviewed methodology (French et al. 2023), in the (hopefully near) future.


```r

poll_loc_year <- get_observations(subset_families = pollinators_fam,
                                  subset_habitat = "Semi-nat")
```


```r
poll_loc_year %>% 
  slice(1:5) %>% 
kableExtra::kbl()
```

<table>
 <thead>
  <tr>
   <th style="text-align:right;"> year </th>
   <th style="text-align:left;"> locality </th>
   <th style="text-align:left;"> habitat_type </th>
   <th style="text-align:left;"> region_name </th>
   <th style="text-align:right;"> no_species </th>
   <th style="text-align:right;"> shannon_div </th>
   <th style="text-align:right;"> mean_no_asv_per_species </th>
   <th style="text-align:right;"> GDE_by_asv </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;"> 2020 </td>
   <td style="text-align:left;"> Semi-nat_01 </td>
   <td style="text-align:left;"> Semi-nat </td>
   <td style="text-align:left;"> Østlandet </td>
   <td style="text-align:right;"> 98 </td>
   <td style="text-align:right;"> 49.47 </td>
   <td style="text-align:right;"> 2.68 </td>
   <td style="text-align:right;"> 0.50 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2020 </td>
   <td style="text-align:left;"> Semi-nat_02 </td>
   <td style="text-align:left;"> Semi-nat </td>
   <td style="text-align:left;"> Østlandet </td>
   <td style="text-align:right;"> 34 </td>
   <td style="text-align:right;"> 28.64 </td>
   <td style="text-align:right;"> 1.44 </td>
   <td style="text-align:right;"> 0.84 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2020 </td>
   <td style="text-align:left;"> Semi-nat_03 </td>
   <td style="text-align:left;"> Semi-nat </td>
   <td style="text-align:left;"> Østlandet </td>
   <td style="text-align:right;"> 40 </td>
   <td style="text-align:right;"> 34.07 </td>
   <td style="text-align:right;"> 1.57 </td>
   <td style="text-align:right;"> 0.85 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2020 </td>
   <td style="text-align:left;"> Semi-nat_04 </td>
   <td style="text-align:left;"> Semi-nat </td>
   <td style="text-align:left;"> Østlandet </td>
   <td style="text-align:right;"> 56 </td>
   <td style="text-align:right;"> 42.90 </td>
   <td style="text-align:right;"> 1.89 </td>
   <td style="text-align:right;"> 0.77 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2020 </td>
   <td style="text-align:left;"> Semi-nat_05 </td>
   <td style="text-align:left;"> Semi-nat </td>
   <td style="text-align:left;"> Østlandet </td>
   <td style="text-align:right;"> 78 </td>
   <td style="text-align:right;"> 52.19 </td>
   <td style="text-align:right;"> 1.90 </td>
   <td style="text-align:right;"> 0.67 </td>
  </tr>
</tbody>
</table>

#### Bootstrap observations
The localities in the NorIns program are (semi-)randomly selected and can be viewed as samples of a larger population. Individually, they represent a single measurement of an insect community in a habitat type in a region. To get the sampling uncertainty for this representation, we can bootstrap the values by this simple process: we choose a random set of localities within a year and region (with replacement) and calculate the average value. We then repeat this process a large number of times to get a bootstrap sample of values, which can be used to express the uncertainty in the dataset.

We typically have 10 localities for a given habitat type and region each year, which is not very much to base our uncertainty estimates on. But bootstrapping works fairly well on small samples and has the advantage that is doesn't make assumptions of the statistical distribution of the errors. We will use this level to showcase the functionality and to visualize some variation between years. However, since the sampling scheme of the monitoring program semi-randomly selects 10 new localities for each of the 5 years the rotating scheme, each years estimate will include some randomness that is caused by variability between localities. This means that the values between individual years might appear more random than the underlying overall trend. To get robust estimates that averages over this variability, we will summarize the actual indicator values to 5 year periods, further described below.

When **NorIns** is fully scaled up, it will have 50 localities for each covered habitat type in every country region, with 10 localities every year, in a rotating survey scheme over 5 years. Since the program is rolled out sequentially starting in 2020, for semi-natural land it currently covers 4/5 of the country, with varying amounts of localities within each region. The map below displays the localities surveyed so far. 


```r
semi_loc <- get_localities(dataset = "NasIns",
                           habitat_type = "Semi-nat")
```



```r
norway_regions <- get_map()
```



```r
tm_shape(norway_regions) +
  tm_polygons("region") +
  tm_shape(semi_loc) +
  tm_symbols(col = "red",
             shape = 22,
             size = 0.8)
```

<img src="insectIndicators_files/figure-html/location_map-1.png" width="672" />

The bootstrap routine is implemented in the function `bootstrap_value()`, which takes a community (from `get_observation`) or weight dataset (from `get_biomass`) as its first input. It also needs to know what measurement in the dataset to bootstrap, and what, if any, grouping structure to aggregate the results on. In this example, we bootstrap the number of pollinator species, and aggregate the results on the year and regional scale.


```r

poll_richness_boot <- bootstrap_value(poll_loc_year,
                                      value = no_species,
                                      groups = c("year",
                                                 "region_name"),
                                      rolling_year_window = FALSE
                                      )
```

This creates an object of type `boot_stat`. Calling it prints a simple summary of the bootstrap values.

```r
poll_richness_boot
#> # A tibble: 6 × 6
#>    year region_name no_species boot_sd boot_lower2.5
#>   <int> <chr>            <dbl>   <dbl>         <dbl>
#> 1  2020 Østlandet         59.9    6.00          48.3
#> 2  2021 Trøndelag         41.8    3.11          34.8
#> 3  2021 Østlandet         53.3    6.09          41  
#> 4  2022 Sørlandet         29.6    5.90          18.4
#> 5  2022 Trøndelag         34.8    2.57          29.8
#> 6  2022 Østlandet         35.9    2.85          30.2
#> # ℹ 1 more variable: boot_upper97.5 <dbl>
```

But the `boot_stat` object also stores the individual bootstrap values for later computation. By default, we use 999 bootstrap samples, which here results in 999 samples * 6 groups = 5994 rows of bootstrap values.


```r
poll_richness_boot[2]
#> $bootstrap_values
#> # A tibble: 5,994 × 3
#> # Groups:   year, region_name [6]
#>     year region_name boot_values
#>    <int> <chr>             <dbl>
#>  1  2020 Østlandet          63.5
#>  2  2020 Østlandet          50.5
#>  3  2020 Østlandet          49.9
#>  4  2020 Østlandet          65.8
#>  5  2020 Østlandet          62.2
#>  6  2020 Østlandet          53.6
#>  7  2020 Østlandet          61.6
#>  8  2020 Østlandet          62.7
#>  9  2020 Østlandet          68.8
#> 10  2020 Østlandet          64.3
#> # ℹ 5,984 more rows
```

#### Comparing bootstrap values to a reference point
Setting aside the practical difficulties in establishing robust reference values, the next step in the methodology is to compare the observed values (with bootstrapped uncertainty) to a chosen reference value. This can be made in several ways. Most simply, if we have a single numeric value as a reference value, we can simply subtract that from the observed values. For example, if we observe 13 species of pollinators in 2022 at a location, and the reference point is 10, the 2022 value has increased by 13 - 10 = 3 species. Such subtractions should be made on the set of bootstrapped values, followed by new summary statistics being calculated, preserving the uncertainty from the bootstrap. The `boot_stat` object class has its own subtraction method `-` do to just that. In this example, we set the reference value arbitrarily to 30 species.


```r
poll_richness_boot
#> # A tibble: 6 × 6
#>    year region_name no_species boot_sd boot_lower2.5
#>   <int> <chr>            <dbl>   <dbl>         <dbl>
#> 1  2020 Østlandet         59.9    6.00          48.3
#> 2  2021 Trøndelag         41.8    3.11          34.8
#> 3  2021 Østlandet         53.3    6.09          41  
#> 4  2022 Sørlandet         29.6    5.90          18.4
#> 5  2022 Trøndelag         34.8    2.57          29.8
#> 6  2022 Østlandet         35.9    2.85          30.2
#> # ℹ 1 more variable: boot_upper97.5 <dbl>
```


```r
diff_poll_richness_boot <- poll_richness_boot - 30
```


```r
diff_poll_richness_boot
#> # A tibble: 6 × 6
#>    year region_name no_species boot_sd boot_lower2.5
#>   <int> <chr>            <dbl>   <dbl>         <dbl>
#> 1  2020 Østlandet       29.9      6.00        18.3  
#> 2  2021 Trøndelag       11.8      3.11         4.8  
#> 3  2021 Østlandet       23.3      6.09        11    
#> 4  2022 Sørlandet       -0.412    5.90       -11.6  
#> 5  2022 Trøndelag        4.76     2.57        -0.200
#> 6  2022 Østlandet        5.90     2.85         0.200
#> # ℹ 1 more variable: boot_upper97.5 <dbl>
```

Alternatively, we could use a reference point in the time series itself. Say for example that we want to use the values for species richness of pollinators in semi-natural land i Østlandet 2020 as a reference point. We can then calculate the difference (the contrast) between this level and all the other levels. We do this by the function `boot_contrast()`

**NB! This functionality is in development. It currently works for single rows as reference points, but needs updating to allow for referencing several values simultaneously, e.g using the start values for all regions and habitat types as their own reference points.**



```r

diff_poll_richness_boot2 <- poll_richness_boot %>%
  boot_contrast(year == 2020 & region_name == 'Østlandet')
```


```r
diff_poll_richness_boot2
#> # A tibble: 6 × 6
#>    year region_name no_species boot_sd boot_lower2.5
#>   <int> <chr>            <dbl>   <dbl>         <dbl>
#> 1  2020 Østlandet         0       0              0  
#> 2  2021 Trøndelag       -18.1     6.76         -31.6
#> 3  2021 Østlandet        -6.59    8.42         -23.3
#> 4  2022 Sørlandet       -30.3     8.42         -46.2
#> 5  2022 Trøndelag       -25.1     6.42         -37.4
#> 6  2022 Østlandet       -24.0     6.67         -37.2
#> # ℹ 1 more variable: boot_upper97.5 <dbl>
```

#### Normalizing the values
After the comparison to a reference value, we need to normalize the indicator values so that they lie between 0 and 1. This can be done in several ways (se e.g. [eaTools](https://github.com/NINAnor/eaTools)). The simplest case is to use a linear scaling, with a natural zero, which e.g. can be done by dividing the indicator values by the highest value state. A `boot_stat` class has a `/` function that divides each bootstrap value by a given value, truncates the highest values to 1, and recalculates the summary values. We can similarly divide by a predefined reference state. Here, we exemplify the method by dividing the value by 30.



```r
diff_poll_richness_boot3 <- poll_richness_boot / 30
```


```r
diff_poll_richness_boot3
#> # A tibble: 6 × 6
#>    year region_name no_species boot_sd boot_lower2.5
#>   <int> <chr>            <dbl>   <dbl>         <dbl>
#> 1  2020 Østlandet        1     0               1    
#> 2  2021 Trøndelag        1.00  0.00190         1    
#> 3  2021 Østlandet        1     0               1    
#> 4  2022 Sørlandet        0.913 0.116           0.613
#> 5  2022 Trøndelag        0.999 0.00651         0.993
#> 6  2022 Østlandet        0.999 0.00485         1    
#> # ℹ 1 more variable: boot_upper97.5 <dbl>
```

#### Display and plot bootstrap values
The boot_stat class also has its own plot function. It tries to plot a comparison of the bootstrap distributions over years, for each group. For example, if we plot the object `diff_poll_richness_boot`, we can look at the yearly differences in beetles species richness in the two geographic regions: (Note that we have only 1 year of data from Sørlandet so far)


```r
plot(diff_poll_richness_boot)
```

<img src="insectIndicators_files/figure-html/poll_richness_boot-1.png" width="672" />

In the cases where we have used a single row as a reference point, this shows up as a sharp spike at 0.


```r
plot(diff_poll_richness_boot2)
```

<img src="insectIndicators_files/figure-html/diff_beetle_richness_boot2-1.png" width="672" />


#### Time-series plots
The default plots are good for showing the uncertainty distributions, but can be a bit difficult to track the time series trends this way. We can instad use the `ts_plot` function for a simple time-series plot.


```r
ts_plot(poll_richness_boot)
#> Warning: The `<scale>` argument of `guides()` cannot be `FALSE`. Use
#> "none" instead as of ggplot2 3.3.4.
#> ℹ The deprecated feature was likely used in the Norimon
#>   package.
#>   Please report the issue to the authors.
#> This warning is displayed once every 8 hours.
#> Call `lifecycle::last_lifecycle_warnings()` to see where
#> this warning was generated.
```

<img src="insectIndicators_files/figure-html/unnamed-chunk-22-1.png" width="672" />


#### Map plots
In addition to these plots, we can also display the values geographically. The `map_plot()` function takes a `boot_stat` object and plots the values according to its region names.


```r
map_plot(poll_richness_boot)
```

<img src="insectIndicators_files/figure-html/map_plot_cutout-1.png" width="672" />

By default, it only shows the regions with data, but this can be overridden manually:

```r
map_plot(poll_richness_boot,
         whole_country = TRUE)
```

<img src="insectIndicators_files/figure-html/map_plot_whole-1.png" width="672" />
We can also choose a different palette, for example from the NinaR package, and visualize the uncertainty by setting the transparency of the colors from the bootstrap standard deviations. Most of these functions can be piped as well:


```r
diff_poll_richness_boot %>%
map_plot(palette = "orange-green",
         whole_country = FALSE,
         alpha_from_sd = TRUE)
```

<img src="insectIndicators_files/figure-html/diff_beetle_richness_boot_map-1.png" width="672" />

More plotting options are available, see the `Norimon` indicator workflow vignette.


#### 5 year rolling window summaries
As described above, to take the staggered 5 year survey scheme into account and to average over random yearly variation, it makes sense to summarize the state over a whole 5 year period. This does not need to adhere to predefined periods, since any 5 year long period will result in a complete data set. We can therefore calculate 5 year long summaries in rolling windows, where each focal year is surrounded by +- 2 years. The bootstrap_value does this by default, if we don't specify `rolling_year_average = FALSE`



```r
poll_richness_boot_5_year <- bootstrap_value(poll_loc_year,
                                      value = no_species,
                                      groups = c("year",
                                                 "region_name"),
                                      rolling_year_window = TRUE
                                      )
```
Since we are only on the third year in the survey scheme however, the rolling windows are too large to show any differences between years. This will change, starting with the 2023 year data.



```r
plot(poll_richness_boot_5_year)
```

<img src="insectIndicators_files/figure-html/unnamed-chunk-24-1.png" width="672" />

The averaging over 5-years also shows up in the time-series plots. Note the very wide confidence intervals of the Sørlandet region, with only 1-year worth of data.


```r
ts_plot(poll_richness_boot_5_year)
```

<img src="insectIndicators_files/figure-html/unnamed-chunk-25-1.png" width="672" />


This concludes the tour of the `Norimon` functionality.

### Calculation principles for NBBM indicators
These indicators were developed for the Nature Index of Norway, back in 2010 by Ola Diserud and Sandra Öberg (Öberg et. al 2011), and are calculated routinely on a yearly basis (see Åström et. al 2022 for the latest report). 

These indicators summarize the state of a bumblebee or butterfly community by estimating the difference from a reference community. Formally, the community indicator (CI) is expressed as the relative change of the community from a state of reference (SR), were the change is calculated by a state of change (SC). 


$$CI = \frac{SR-SC}{SR}$$
The state of reference (SR) represents a community of species which can be expected to be observed in a given habitat type and region. It is calculated by assigning each species to class of expected commonality: common (C), sporadic (S) and rare (R) species. This classification is done by expert opinion, informed by known present and past species distributions. Note that this state of reference only contains a subset of highlighted species, making up a historical reference community. Potential observations of "new" species therefore don't inform the indicator value at all. Common species are expected to be observed in at least 5 % of the surveyed transects in a habitat type and region. Sporadic species similarly are defined as having a presence below 5 % but above 1 %. Rare species are seen in no more than 1 % of the transects, and lastly, species not seen in any transect are assumed as lost (L) for the purpose of this calculation. 
  
Each commonality class gets its own weight, so that common species inform the reference state more than sporadic species, followed by rare species. The state of reference (SR) is thus a value where each species adds to the state according to its commonality. Formally, it is defined as:

$$SR = n_C * w_{C, SR} + n_S * w_{S, SR} + n_R * w_{R, SR} = \sum_{i = (C, S, R)} n_i * w_{i, SR}, $$
where $n_i$ is the number of species in a commonality class (C, S, R), and the weights $[w_{C, SR}, w_{S, SR}, w_{R, SR}]$ specify their respective contribution to the reference state (SR). The weights used are $[w_{C, SR}, w_{S, SR}, w_{R, SR}] = [1.0, 0.75, 0.50]$, i.e. a sporadic species has 75 % the weight of a common species, and a rare species has 50 % the weight of a common species. 


The state of change (SC) is calculated as
 $$SC = n_{CS} * w_{CS} + n_{CR} * w_{CR} + n_{CL} * w_{CL} + n_{SR} * w_{SR} + n_{SL} * w_{SL} + n_{RL} * w_{RL}, $$ 
where $n_{CS}$ is the number of expected common species (C) that is observed sporadically (S), and $w_{CS}$ is the weight of this change. Similarly, $n_{CR}$ is the number of expected common species that is observed rarely, $n_{RL}$ is the number of rare species that is lost, and so on. Potential increases in observation rates do not inform the indicator. Changes for common species are weighted more heavily than changes for less common species, and larger decreases are weighted more heavily than smaller decreases, such that $[w_{CS}, w_{CR}, w_{CL}, w_{SR}, w_{SL}, w_{RL}]= [0.50, 0.75, 1.00, 0.50, 0.75, 0.50]$.

The indicator values are estimated with uncertainty, by bootstrapping the set of localities within a region, and calculating the indicator for each of 9999 such samples.

#### Calculation example
These calculations with bootstrap sampling are implemented in the R-package `bombLepiSurv` ([Bombus and Lepidoptera Survey](https://github.com/jenast/bombLepiSurv)). We briefly show this functionality with bumblebees in semi-natural lands as an example.

We connect to the internal database with a convenience function.

```r
bombLepiSurv::humlesommerfConnect()
```




We can fetch all observations of bumblebees in semi-natural land with the `getAllData` function. Species names are here shown in Norwegian.


```r
allBombusGrassland2022 <- getAllData(type = "bumblebees",
                                     habitat = "gressmark",
                                     year = 2022,
                                     language = "norsk")
```

A summary of the records is most easily plotted by `surveyBarPlot`:


```r
surveyBarplot(allBombusGrassland2022)
```

<img src="insectIndicators_files/figure-html/unnamed-chunk-29-1.png" width="672" />

Note that for calculating the indicator values, we only consider the transects that were surveyed for the standard 3 times per year, to cover the phenology of the entire season without bias. Data of these complete survey rounds can be fetched from the database by the function `getComplData`, which fetches data from one habitat type and region at a time. 


```r
bombus_trond_2022 <- getComplData(type = "Humler",
                                  region_short = "Trond",
                                  habitat = "Gressmark",
                                  year = 2022)
```

The observed relative to the expected occurrences can be visualized through the `plotArt` function. This requires a reference community, which can be fetched through the `getExpValues` function.



```r
exp_bombus_trond <- getExpValues(type = "Humler",
                                 region_short = "Trond",
                                 habitat = "Gressmark")
```



Species in green bars are species that are expected to be common, who need to reach the green areas in the plot not to decrease the indicator value (from 1). Similarly with the blue (sporadic species), and red (rare species). We see in this case that _Bombus soroeensis_ is expected to be a sporadic species, but that it was only observed rarely. 



```r
plotArt(bombus_trond_2022,
        exp_bombus_trond)
```

<img src="insectIndicators_files/figure-html/unnamed-chunk-32-1.png" width="672" />

The actual calculation and bootstrapping of the indicator is done in the function `calcInd`. This function calls the `getComplData` and `getExpectedValues` functions internally. It also requires the weights for the commonality classes in the reference community (SR), and the weights for the changes in state (CS). This is fetched internally via the functions `getAmountWeights` and `getDiffWeights`, respectively. Here the classes are coded in Norwegian (v = common, m = sporadic, s = rare).


```r
getDiffWeights()
#>      v    m   s
#> v 0.00 0.00 0.0
#> m 0.50 0.00 0.0
#> s 0.75 0.50 0.0
#> t 1.00 0.75 0.5
```


```r
getAmountWeights()
#>   v    m   s
#> 1 1 0.75 0.5
```

Lastly, we specify the number of samples for the bootstrap. To speed up, only 999 samples are used here.



```r
nIter = 999
```


```r
hInd2022TrondGress <- calcInd(type = "Humler",
                              region_short = "Trond",
                              habitat = "Gressmark",
                              year = 2022,
                              nIter = nIter,
                              save.draws = T)
```

The result is an object of class "comm_index" (community index). It comes with some (still rudimentary) print and plotting functions, showing the point estimate and the limits of a 95% confidence interval. Due to the limited number of species and the fixed "weights" of each species and state of change, the indicator calculation returns a distribution of discrete values. Therefore it can happen that the 95% and the 90% confidence intervals are the same, as in this case.


```r
hInd2022TrondGress
#> $`Community indicator estimates, with percentiles`
#>           2.5%             5% Point estimate            95% 
#>      0.5416667      0.5625000      0.7083333      0.7500000 
#>          97.5% 
#>      0.7500000
```


```r
plot(hInd2022TrondGress)
```

<img src="insectIndicators_files/figure-html/unnamed-chunk-38-1.png" width="672" />

Plotting functions for a series of indicator values is shown below in the indicator calculations. This concludes the tour of the `bombLepiSurv` package.


### Data sets
There are a few different ways to access the data required for these indicators. Both the NMBB and the NorIns project store their data in an internal database at NINA. They both also export most of their data to GBIF, but those exports need to be restructured before they can be processed in the following scripts.


#### NorIns data
The `Norimon` package has convenience functions to fetch data from the database. This database is currently not available outside NINA, but we will implement a solution for this in the future. Either we will make the database externally available, or we will provide an alternative route to the data from the GBIF export. For now, we will fetch the data through the `Norimon` functions.


#### NMBB data
The data for the bumblebee and butterfly indicators can similarly be accessed through the R-package `bombLepiSurv`. 


#### Regions
<!-- In case you need to map the indicator value to regions, you can do that here. Remove this chapter if not relevant. -->
We here show how to import a shape file with the regional delineation. The indicators associated with the NorIns project can be attributed to the 5 country regions of Norway. Currently however, the data program only covers 4 of the 5 regions.


```r
connect_to_insect_db()
norway_regions <- Norimon::get_map()

```




```r
norway_reg_NorIns <- norway_regions %>% 
  filter(region != "Vestlandet") %>% 
  select(region) %>% 
  group_by(region) %>% 
  summarize(geom = st_union(geom))
```


```r
tm_shape(norway_reg_NorIns) + 
  tm_polygons(col = "region") 
```

<img src="insectIndicators_files/figure-html/unnamed-chunk-42-1.png" width="672" />

The indicators from the NMBB program are similarly connected to regions, with the exception that the south-east region only covers the old counties of Vestfold and Østfold, and that Nord-Norge isn't covered yet.


```r
bombLepiSurv::humlesommerfConnect()
```




```r
nbbm_norway_regions <- bombLepiSurv::get_map()
```


```r

norway_reg_NBBM <- nbbm_norway_regions %>% 
  filter(region %in% c("Øst", "Sørlandet", "Trøndelag", "Vestlandet")) %>% 
  select(region) %>% 
  group_by(region) %>% 
  summarize(geom = st_union(geom))
```


```r
tm_shape(norway_reg_NBBM) + 
  tm_polygons(col = "region") 
```

<img src="insectIndicators_files/figure-html/unnamed-chunk-47-1.png" width="672" />


### Calculation of NorIns indicators
Here we calculate the indicators in abbreviated form, following the general framework outlined above.

#### Biomass of flying insects in semi-natural land

```r
connect_to_insect_db()
```



Fetch the data.

```r
biomass_sn <- get_biomass(subset_year = 2020:2022,
                          subset_region = NULL,
                          subset_habitat = "Semi-nat")
```


Calculate the indicator values for each region and year.

```r
biomass_sn_boot <- bootstrap_value(df = biomass_sn,
                                   value = avg_wet_weight,
                                   groups = c("year",
                                              "region_name")
                                   )
```

Compare values to a reference state. The reference state is here set uniformly for all regions. Alternatively, we could calculate the indicator values for each region separately, compare to individual reference states, and then put it all together again.

To exemplify, we here use a single "made-up" value as a reference state and normalize the values at the same time, using the `/` function.


```r
biomass_ref <- 50
  
biomass_sn_diff <- biomass_sn_boot / biomass_ref
```

Plot the results and display uncertainty.

```r
biomass_sn_diff
#> # A tibble: 9 × 6
#>    year region_name avg_wet_weight boot_sd boot_lower2.5
#>   <int> <chr>                <dbl>   <dbl>         <dbl>
#> 1  2020 Sørlandet            0.469  0.0640         0.346
#> 2  2020 Trøndelag            0.748  0.0734         0.591
#> 3  2020 Østlandet            0.757  0.0528         0.652
#> 4  2021 Sørlandet            0.467  0.0630         0.350
#> 5  2021 Trøndelag            0.746  0.0695         0.610
#> 6  2021 Østlandet            0.757  0.0521         0.658
#> 7  2022 Sørlandet            0.467  0.0644         0.346
#> 8  2022 Trøndelag            0.747  0.0717         0.618
#> 9  2022 Østlandet            0.757  0.0521         0.653
#> # ℹ 1 more variable: boot_upper97.5 <dbl>
```


```r
plot(biomass_sn_diff)
```

<img src="insectIndicators_files/figure-html/biomass_diff-1.png" width="672" />

Prepare export format.


```r
biomass_sn_to_exp <- biomass_sn_boot$bootstrap_summary

biomass_sn_to_exp <- biomass_sn_to_exp %>% 
  mutate(reference_high = NA,
         reference_low = 0,
         thr = 0.6,
         i = NA) %>% 
  select(year,
         region = region_name,
         v = boot_value,
         sd = boot_sd,
         reference_high,
         reference_low,
         thr,
         i
         )

biomass_sn_to_exp <- norway_reg_NorIns  %>% 
  inner_join(biomass_sn_to_exp,
            by = c("region" = "region"),
            multiple = "all")

insect_biomass_semi_nat <- biomass_sn_to_exp
```

#### Species richness of flying insects in semi-natural land

Fetch the data.


```r
richness_sn <- get_observations(subset_year = 2020:2022,
                                subset_region = NULL,
                                subset_habitat = "Semi-nat")
```


Calculate the indicator values for each region and year.

```r
richness_sn_boot <- bootstrap_value(df = richness_sn,
                                   value = no_species,
                                   groups = c("year",
                                              "region_name")
                                   )
```

Compare to arbitrary reference value and normalize.

```r
richness_ref <- 4000
  
richness_sn_diff <- richness_sn_boot / richness_ref
```

Plot the results and display uncertainty.

```r
richness_sn_diff
#> # A tibble: 9 × 6
#>    year region_name no_species boot_sd boot_lower2.5
#>   <int> <chr>            <dbl>   <dbl>         <dbl>
#> 1  2020 Sørlandet        0.545  0.0647         0.423
#> 2  2020 Trøndelag        0.664  0.0275         0.606
#> 3  2020 Østlandet        0.706  0.0357         0.637
#> 4  2021 Sørlandet        0.548  0.0630         0.428
#> 5  2021 Trøndelag        0.663  0.0274         0.607
#> 6  2021 Østlandet        0.704  0.0334         0.637
#> 7  2022 Sørlandet        0.548  0.0638         0.425
#> 8  2022 Trøndelag        0.664  0.0275         0.607
#> 9  2022 Østlandet        0.704  0.0366         0.633
#> # ℹ 1 more variable: boot_upper97.5 <dbl>
```


```r
plot(richness_sn_diff,
     limit = c(0, 1))
```

<img src="insectIndicators_files/figure-html/unnamed-chunk-59-1.png" width="672" />


```r
map_plot(richness_sn_diff,
         whole_country = T,
         limit = c(0, 1))
```

<img src="insectIndicators_files/figure-html/richness-1.png" width="672" />
   
Prepare export format.


```r
richness_sn_to_exp <- richness_sn_boot$bootstrap_summary

richness_sn_to_exp <- richness_sn_to_exp %>% 
  mutate(reference_high = NA,
         reference_low = 0,
         thr = 0.6,
         i = NA) %>% 
  select(year,
         region = region_name,
         v = boot_value,
         sd = boot_sd,
         reference_high,
         reference_low,
         thr,
         i
         )

richness_sn_to_exp <- norway_reg_NorIns %>% 
  inner_join(richness_sn_to_exp,
            by = c("region" = "region"),
            multiple = "all")

insect_richness_semi_nat <- richness_sn_to_exp
```


#### Species richness of pollinators in semi-natural land

Fetch the data.

```r
pollinator_fam <- get_pollinators() %>% 
  select(family_latin) %>% 
  pull()
  
```


```r
pollinators_sn <- get_observations(subset_year = 2020:2022,
                                   subset_families = pollinator_fam,
                                   subset_habitat = "Semi-nat")
```


Calculate the indicator values for each region and year.

```r
pollinators_sn_boot <- bootstrap_value(df = pollinators_sn,
                                       value = no_species,
                                       groups = c("year",
                                                  "region_name")
                                       )
```
Compare to arbitrary reference value and normalize.

```r
pollinators_ref <- 50
  
pollinators_sn_diff <- pollinators_sn_boot / pollinators_ref
```

Plot the results and display uncertainty.

```r
pollinators_sn_diff
#> # A tibble: 9 × 6
#>    year region_name no_species boot_sd boot_lower2.5
#>   <int> <chr>            <dbl>   <dbl>         <dbl>
#> 1  2020 Sørlandet        0.593  0.115          0.38 
#> 2  2020 Trøndelag        0.765  0.0440         0.677
#> 3  2020 Østlandet        0.971  0.0409         0.867
#> 4  2021 Sørlandet        0.593  0.115          0.374
#> 5  2021 Trøndelag        0.767  0.0436         0.681
#> 6  2021 Østlandet        0.971  0.0410         0.864
#> 7  2022 Sørlandet        0.589  0.114          0.366
#> 8  2022 Trøndelag        0.765  0.0449         0.674
#> 9  2022 Østlandet        0.972  0.0413         0.852
#> # ℹ 1 more variable: boot_upper97.5 <dbl>
```


```r
plot(pollinators_sn_diff,
     limit = c(0, 1))
```

<img src="insectIndicators_files/figure-html/unnamed-chunk-66-1.png" width="672" />

Prepare export format.


```r
pollinators_sn_to_exp <- pollinators_sn_boot$bootstrap_summary

pollinators_sn_to_exp <- pollinators_sn_to_exp %>% 
  mutate(reference_high = NA,
         reference_low = 0,
         thr = 0.6,
         i = NA) %>% 
  select(year,
         region = region_name,
         v = boot_value,
         sd = boot_sd,
         reference_high,
         reference_low,
         thr,
         i
         )

pollinators_sn_to_exp <- norway_reg_NorIns %>% 
  inner_join(pollinators_sn_to_exp,
            by = c("region" = "region"),
            multiple = "all")

insect_pollinators_semi_nat <- pollinators_sn_to_exp
```

#### Species richness of dung associated insects
We here note all observations of a set of species, known to be associated with dung. This species list can be expanded after a further taxonomic review. Here we take all observed species in the house fly/stable fly family Muscidae, together with a selection of 70 beetle species known to be associated with dung.


```r
muscidae_species <- tbl(con,
                    Id(schema = "views",
                       table = "observed_muscidae_species")) %>% 
  pull()

coleoptera_dung_species <- tbl(con,
                    Id(schema = "lookup",
                       table = "coleoptera_dung_species")) %>% 
  select(species_latin) %>% 
  pull()

dung_species <- c(coleoptera_dung_species, muscidae_species)
```


```r
dung_sn <- get_observations(subset_year = 2020:2022,
                            subset_species = dung_species,
                            subset_habitat = "Semi-nat")
```


Calculate the indicator values for each region and year.

```r
dung_sn_boot <- bootstrap_value(df = dung_sn,
                                       value = no_species,
                                       groups = c("year",
                                                  "region_name")
                                       )
```
Compare to arbitrary reference value and normalize.


```r
dung_ref <- 100
  
dung_sn_diff <- dung_sn_boot / dung_ref
```

Plot the results and display uncertainty.

```r
dung_sn_diff
#> # A tibble: 9 × 6
#>    year region_name no_species boot_sd boot_lower2.5
#>   <int> <chr>            <dbl>   <dbl>         <dbl>
#> 1  2020 Sørlandet        0.608  0.0613         0.493
#> 2  2020 Trøndelag        0.832  0.0317         0.764
#> 3  2020 Østlandet        0.762  0.0324         0.697
#> 4  2021 Sørlandet        0.605  0.0633         0.492
#> 5  2021 Trøndelag        0.833  0.0329         0.758
#> 6  2021 Østlandet        0.763  0.0331         0.697
#> 7  2022 Sørlandet        0.608  0.0618         0.494
#> 8  2022 Trøndelag        0.832  0.0327         0.759
#> 9  2022 Østlandet        0.760  0.0332         0.694
#> # ℹ 1 more variable: boot_upper97.5 <dbl>
```


```r
plot(dung_sn_diff,
     limit = c(0, 1))
```

<img src="insectIndicators_files/figure-html/unnamed-chunk-73-1.png" width="672" />

Prepare export format.


```r
dung_sn_to_exp <- dung_sn_boot$bootstrap_summary

dung_sn_to_exp <- dung_sn_to_exp %>% 
  mutate(reference_high = NA,
         reference_low = 0,
         thr = 0.6,
         i = NA) %>% 
  select(year,
         region = region_name,
         v = boot_value,
         sd = boot_sd,
         reference_high,
         reference_low,
         thr,
         i
         )

dung_sn_to_exp <- norway_reg_NorIns  %>% 
  inner_join(dung_sn_to_exp,
            by = c("region" = "region"),
            multiple = "all")

insect_dung_assoc_semi_nat <- dung_sn_to_exp
```


#### Relationship between Symphyta and Parasitica in semi-natural land
Parasitica and Symphyta wasps are here defined as a set of families. 


```r
symphyta_fam <- c("Argidae", "Cephidae", "Cimbicidae", 
                  "Diprionidae", "Orussidae", "Pamphiliidae", 
                  "Pergidae", "Siricidae", "Anaxyelidae",
                  "Tenthredinidae", "Xiphydriidae", "Xyelidae") 

symphyta_sn <- get_observations(subset_year = 2020:2022,
                                subset_families = symphyta_fam,
                                subset_habitat = "Semi-nat")

symphyta_sn
#> # A tibble: 60 × 8
#>     year locality    habitat_type region_name no_species
#>    <int> <chr>       <chr>        <chr>            <int>
#>  1  2020 Semi-nat_01 Semi-nat     Østlandet           38
#>  2  2020 Semi-nat_02 Semi-nat     Østlandet           16
#>  3  2020 Semi-nat_03 Semi-nat     Østlandet           13
#>  4  2020 Semi-nat_04 Semi-nat     Østlandet           39
#>  5  2020 Semi-nat_05 Semi-nat     Østlandet           65
#>  6  2020 Semi-nat_06 Semi-nat     Østlandet           22
#>  7  2020 Semi-nat_07 Semi-nat     Østlandet           36
#>  8  2020 Semi-nat_08 Semi-nat     Østlandet           46
#>  9  2020 Semi-nat_09 Semi-nat     Østlandet           21
#> 10  2020 Semi-nat_10 Semi-nat     Østlandet           68
#> # ℹ 50 more rows
#> # ℹ 3 more variables: shannon_div <dbl>,
#> #   mean_no_asv_per_species <dbl>, GDE_by_asv <dbl>
```


```r
parasitica_fam <- c("Braconidae", "Ichneumonidae", "Chalcididae", 
                    "Eulophidae", "Pteromalidae", "Aphelinidae", 
                    "Scelionidae", "Eupelmidae", "Encyrtidae", 
                    "Mymaridae", "Diapriidae", "Bethylidae", 
                    "Evaniidae", "Ceraphronidae", "Torymidae", 
                    "Dryinidae", "Eucharitidae", "Mymarommatidae", 
                    "Orussidae", "Megaspilidae", "Stephanidae", 
                    "Trigonalidae", "Platygastridae", "Aulacidae", 
                    "Gasteruptiidae", "Rhopalosomatidae", "Larridae", 
                    "Agaonidae", "Pompilidae", "Bradynobaenidae"
                    )

parasitica_sn <- get_observations(subset_year = 2020:2022,
                                subset_families = parasitica_fam,
                                subset_habitat = "Semi-nat")

parasitica_sn
#> # A tibble: 60 × 8
#>     year locality    habitat_type region_name no_species
#>    <int> <chr>       <chr>        <chr>            <int>
#>  1  2020 Semi-nat_01 Semi-nat     Østlandet          480
#>  2  2020 Semi-nat_02 Semi-nat     Østlandet          112
#>  3  2020 Semi-nat_03 Semi-nat     Østlandet          119
#>  4  2020 Semi-nat_04 Semi-nat     Østlandet          369
#>  5  2020 Semi-nat_05 Semi-nat     Østlandet          642
#>  6  2020 Semi-nat_06 Semi-nat     Østlandet          190
#>  7  2020 Semi-nat_07 Semi-nat     Østlandet          253
#>  8  2020 Semi-nat_08 Semi-nat     Østlandet          323
#>  9  2020 Semi-nat_09 Semi-nat     Østlandet          216
#> 10  2020 Semi-nat_10 Semi-nat     Østlandet          531
#> # ℹ 50 more rows
#> # ℹ 3 more variables: shannon_div <dbl>,
#> #   mean_no_asv_per_species <dbl>, GDE_by_asv <dbl>
```

Divide the richness of Parasitica by Symphyta. [Could make a function for this later on.]


```r
par_sym <- symphyta_sn %>% 
  full_join(parasitica_sn,
       by = c("year" ="year",
              "locality" = "locality",
              "habitat_type" = "habitat_type",
              "region_name" = "region_name"),
       suffix = c("_sym", "_par")
       ) %>% 
  mutate(par_per_sym_richn = no_species_par / no_species_sym)
```

Bootstrap the fraction of Parasitica to Symphyta.


```r
par_sym_sn_boot <- bootstrap_value(par_sym,
                                value = par_per_sym_richn,
                                groups = c("year", 
                                           "region_name"))
```

Compare to arbitrary reference value and normalize.


```r
par_sym_ref <- 40
  
par_sym_sn_diff <- par_sym_sn_boot / par_sym_ref
```

Plot the results and display uncertainty.

```r
par_sym_sn_diff
#> # A tibble: 9 × 6
#>    year region_name par_per_sym_richn boot_sd boot_lower2.5
#>   <int> <chr>                   <dbl>   <dbl>         <dbl>
#> 1  2020 Sørlandet               0.817  0.170          0.528
#> 2  2020 Trøndelag               0.732  0.0769         0.591
#> 3  2020 Østlandet               0.446  0.0415         0.369
#> 4  2021 Sørlandet               0.818  0.166          0.523
#> 5  2021 Trøndelag               0.730  0.0802         0.591
#> 6  2021 Østlandet               0.447  0.0400         0.371
#> 7  2022 Sørlandet               0.824  0.166          0.534
#> 8  2022 Trøndelag               0.737  0.0776         0.596
#> 9  2022 Østlandet               0.451  0.0431         0.371
#> # ℹ 1 more variable: boot_upper97.5 <dbl>
```


```r
plot(par_sym_sn_diff)
```

<img src="insectIndicators_files/figure-html/unnamed-chunk-81-1.png" width="672" />

Prepare export format.


```r
par_sym_sn_exp <- par_sym_sn_boot$bootstrap_summary

par_sym_sn_exp <- par_sym_sn_exp %>% 
  mutate(reference_high = NA,
         reference_low = 0,
         thr = 0.6,
         i = NA) %>% 
  select(year,
         region = region_name,
         v = boot_value,
         sd = boot_sd,
         reference_high,
         reference_low,
         thr,
         i
         )

par_sym_sn_exp <- norway_reg_NorIns %>% 
  inner_join(par_sym_sn_exp,
            by = c("region" = "region"),
            multiple = "all")

insect_par_sym_semi_nat <- par_sym_sn_exp
```

**Also calculate and export only parasitica values**
Could also do similar with symphyta, if needed.


```r
par_sn_boot <- bootstrap_value(par_sym,
                                value = no_species_par,
                                groups = c("year", 
                                           "region_name"))
```


```r
par_sn_exp <- par_sn_boot$bootstrap_summary

par_sn_exp <- par_sn_exp %>% 
  mutate(reference_high = NA,
         reference_low = 0,
         thr = 0.6,
         i = NA) %>% 
  select(year,
         region = region_name,
         v = boot_value,
         sd = boot_sd,
         reference_high,
         reference_low,
         thr,
         i
         )

par_sn_exp <- norway_reg_NorIns %>% 
  inner_join(par_sn_exp,
            by = c("region" = "region"),
            multiple = "all")

insect_par_semi_nat <- par_sn_exp
```


#### Number of alien species in semi-natural land
Here we measure the prevalence of alien species in the trap catches. We present two options for calculating the indicator, as it is not clear at this point which of them is superior.

**The simplest** approach is to just sum up the number of alien species present in a region, i.e. the species richness of alien species. This can be related to the total species richness of the community, and expressed as the proportion of alien species in the community. The reference state of alien species is zero by definition, since we don't want any alien species. The value for good ecological condition could be set at a low (but arbitrary) proportion of alien species in the community. This is done for the indicator of alien plant species, where the value for good ecological condition is set to 0.05 (< 5 % of the plant community should be alien). For a hyper-diverse community such as insects, this is probably too high a value. In a community of say 20 000 insect species, 5 % would mean 1 000 alien species, which is hard to see as a good condition. It is not clear to us at present what level to set here, but we exemplify the calculations with a good condition set to 0.1 % (< 20 species in a 20 000 species community). It is also likely that the species richness of the entire community will increase, perhaps substantially, with increased sampling. It is not clear if the number of detected native and alien species will increase at the same rate, so it may be that the proportion of alien species will change, perhaps substantially, with increased sampling effort. It may be difficult therefore to interpret this frequency of alien insect species.

In addition, this approach will not take into account the spread of the species, a measure that is especially relevant for rare but increasing species. A species found only once will count as much as a species found in every locality. **To take the prevalence of the species into account**, we can measure the proportion of localities each alien species is observed in. These proportions could then be summed together for at total score of alien species. Here, a species found in all localities will count much more than a species only found once. 

For each alien species, the observation frequency is calculated as the number of localities the species is observed in, divided by the total amount of localities in a geographical region and time period. $$p_i = \frac{1}{N} \sum_{i=1, j=1}^{N}{obs_{ij}},$$ where $obs_ij$ is an observation of species $i$ in locality $j$, and $N$ is the total number of possible observations (localities in the region and time period).
These proportions are combined into a common score for all alien species simply by summing them together; $$alien~score =\sum_{i=1}^{S}{~p_{i}},$$ where $p_i$ is the observation frequency of species $i$, and $S$ is the set of all observed alien species. If all alien species are present in all localities, the indicator value simply becomes $S$. If the species is not present in all localities, it's influence on the indicator is weighted down linearly with it presence frequency. The uncertainty of both types of indicators is calculated by bootstrapping the set of localities within a temporal and spatial scope, similarly to the other indicators.

**Fetch the species list.**

The alien species observations are stored in a materialized view for convenience. This is simply a list of observations of the alien species of categories LO, PH, HI, or SE, together with the year localities and locality samplings they were observed in. For the purposes of this calculation, we will only consider observations aggregated to the year localities level (and not the prevalence of alien species within locality and season). So the first thing to do is to fetch this list, and aggregate it to the year locality level. This summary is based on the 2023 of the alien species evaluation, and we only consider species that are identified by metabarcoding with identification confidence "Moderate" or "High" (not Low or Poor). In addition, we filter out the forest sites.


```r
alien_obs <- tbl(con,
                 Id(schema = "views",
                    table = "alien_obs")) %>% 
  filter(identification_confidence %in% c("MODERATE", "HIGH"),
         grepl("Semi-nat", locality))
```



```r
no_alien_obs_ls <- alien_obs %>% 
  summarize(as.integer(n_distinct(ls_id))) %>% 
  pull()

no_alien_obs_yl <- alien_obs %>% 
  summarize(as.integer(n_distinct(yl_id))) %>% 
  pull()

no_alien_spec <- alien_obs %>% 
  summarize(as.integer(n_distinct(species_latin_fixed))) %>% 
  pull()

no_alien_cat <- alien_obs %>% 
  summarize(as.integer(n_distinct(risikokategori_2023))) %>% 
  pull()
```

We can have quick look at some statistics of the data. We see that the project thus far has identified 15 alien species, representing 3 risk-categories, and that the observations area spread across (all) 60 semi-natural localities.

To continue, we aggregate the presences of alien species to locality years, meaning recording in how many localities each alien species were detected at least once.  
 

```r
alien_obs_yl <- alien_obs %>% 
  group_by(yl_id,
           locality,
           year,
           region_name,
           risikokategori_2023,
           species_latin_fixed) %>% 
  summarize(present = sum(present) > 0,
            na.rm = TRUE,
            .groups = "drop") %>% 
  arrange(locality, species_latin_fixed) %>% 
  collect(na.rm = TRUE)
#> Warning: Missing values are always removed in SQL aggregation
#> functions.
#> Use `na.rm = TRUE` to silence this warning
#> This warning is displayed once every 8 hours.
```


```r
alien_obs_yl
#> # A tibble: 900 × 8
#>    yl_id      locality  year region_name risikokategori_2023
#>    <chr>      <chr>    <int> <chr>       <chr>              
#>  1 a3f86975-… Semi-na…  2020 Østlandet   LO                 
#>  2 a3f86975-… Semi-na…  2020 Østlandet   PH                 
#>  3 a3f86975-… Semi-na…  2020 Østlandet   LO                 
#>  4 a3f86975-… Semi-na…  2020 Østlandet   LO                 
#>  5 a3f86975-… Semi-na…  2020 Østlandet   PH                 
#>  6 a3f86975-… Semi-na…  2020 Østlandet   LO                 
#>  7 a3f86975-… Semi-na…  2020 Østlandet   LO                 
#>  8 a3f86975-… Semi-na…  2020 Østlandet   LO                 
#>  9 a3f86975-… Semi-na…  2020 Østlandet   LO                 
#> 10 a3f86975-… Semi-na…  2020 Østlandet   SE                 
#> # ℹ 890 more rows
#> # ℹ 3 more variables: species_latin_fixed <chr>,
#> #   present <lgl>, na.rm <lgl>
```

Next step is to bootstrap the alien observations to get the uncertainty measurement. This has to be done in a slightly different way than for the aggregated diversity or biomass values that we have used for the other indicators. Here we have a set of alien species presences for a locality, and when we bootstrap the localities, all these presences should go together, as they represent a coherent community. So we first have to take bootstrap samples of sets of localities (with replacement). Then we calculate the presence (or presence frequency) of each alien species $p_i$, before we can summarize all of these into the indicator value $H_{alien}$. This is implemented in a separate function `bootstrap_alien_obs` in the `Norimon` package, were we can optionally either sum the species numbers, or sum the species presence frequencies. Note that for all alien species $i$ recorded in at least one locality, we have recorded the presences and absences in all localities $j$. This is needed for his function to work. This function is more computer intensive than the bootstrap of already aggregated values, so we employ parallelization through the `parallel` package internally.

**We first calculate the indicator based on the the number of alien species** 


```r
alien_sn_boot <- bootstrap_alien_obs(alien_obs_yl,
                                     groups = c("year",
                                                "region_name"),
                                     rolling_year_window = TRUE,
                                     only_no_spec = TRUE)
```


```r
plot(alien_sn_boot)
```

<img src="insectIndicators_files/figure-html/unnamed-chunk-90-1.png" width="672" />

The jagged lines in the density plot comes from the discrete values of number of species. Østlandet has the most alien species, followed by Sørlandet, and lastly Trøndelag. Trøndelag has a fewer total number of species, but similar amount of alien species in each locality, leading to a very narrow confidence band from the bootstrap.


```r
ts_plot(alien_sn_boot)
```

<img src="insectIndicators_files/figure-html/unnamed-chunk-91-1.png" width="672" />

As explained above, these values could be expressed as a proportion of the the total species richness. Since the total species richness is different for the different regions, we (currently) have to do this separately for each region. 


```r
alien_obs_yl_sor <- alien_obs_yl %>% 
  filter(region_name == "Sørlandet")

alien_obs_yl_ost <- alien_obs_yl %>% 
  filter(region_name == "Østlandet")

alien_obs_yl_trond <- alien_obs_yl %>% 
  filter(region_name == "Trøndelag")
```
 

```r
alien_sn_sor_boot <- bootstrap_alien_obs(alien_obs_yl_sor,
                                     groups = c("year",
                                                "region_name"),
                                     rolling_year_window = TRUE,
                                     only_no_spec = TRUE)
alien_sn_ost_boot <- bootstrap_alien_obs(alien_obs_yl_ost,
                                     groups = c("year",
                                                "region_name"),
                                     rolling_year_window = TRUE,
                                     only_no_spec = TRUE)
alien_sn_trond_boot <- bootstrap_alien_obs(alien_obs_yl_trond,
                                     groups = c("year",
                                                "region_name"),
                                     rolling_year_window = TRUE,
                                     only_no_spec = TRUE)
```

Next, we fetch a record of the species richness found so far, in each region.


```r
region_richn <- get_observations(agg_level = "region_habitat")
```

```r
region_richn
#> # A tibble: 4 × 6
#>   habitat_type region_name no_species shannon_div
#>   <chr>        <chr>            <int>       <dbl>
#> 1 Forest       Østlandet        13726       4924.
#> 2 Semi-nat     Sørlandet         6679       3204.
#> 3 Semi-nat     Trøndelag        10063       3359.
#> 4 Semi-nat     Østlandet        15515       5716.
#> # ℹ 2 more variables: mean_no_asv_per_species <dbl>,
#> #   GDE_by_asv <dbl>
```



```r
region_richn_sor <- region_richn %>% 
  filter(region_name == "Sørlandet",
         habitat_type == "Semi-nat") %>% 
  select(no_species) %>% 
  pull() %>% 
  as.numeric()

region_richn_ost <- region_richn %>% 
  filter(region_name == "Østlandet",
         habitat_type == "Semi-nat") %>% 
  select(no_species) %>% 
  pull() %>% 
  as.numeric()

region_richn_trond <- region_richn %>% 
  filter(region_name == "Trøndelag",
         habitat_type == "Semi-nat") %>% 
  select(no_species) %>% 
  pull() %>% 
  as.numeric()

```
Next, we scale each indicator to the total number of observed species.


```r
alien_sn_sor_prop <- alien_sn_sor_boot / region_richn_sor
alien_sn_ost_prop <- alien_sn_ost_boot / region_richn_ost
alien_sn_trond_prop <- alien_sn_trond_boot / region_richn_trond
```

We could scale these values with a reference value of 0, and a breaking point of 0.001. eaTools has a function for that, but for this to work, we currently can only operate on the aggregate values of the indicator (not the bootstrap samples).


```r
alien_sn_prop <- alien_sn_sor_prop[[1]] %>% 
  rbind(alien_sn_ost_prop[[1]]) %>% 
  rbind(alien_sn_trond_prop[[1]]) %>% 
  select(year,
         region = region_name,
         alien_score = boot_value,
         boot_sd)
```

```r
alien_sn_prop_sf <- norway_reg_NorIns  %>% 
  inner_join(alien_sn_prop,
            by = c("region" = "region"),
            multiple = "all")
```


```r
alien_sn_prop_sf$alien_score_scaled <- eaTools::ea_normalise(alien_sn_prop_sf, 
                                              vector = "alien_score", 
                                              upper_reference_level = 0.01,
                                              lower_reference_level = 0,
                                              break_point = 0.001, 
                                              reverse = TRUE,
                                              plot = FALSE)
```

This calculation is then an sf-object that can be exported.


```r

alien_sn_exp <- alien_sn_prop_sf %>% 
  mutate(reference_high = 0.01,
         reference_low = 0,
         thr = 0.001) %>% 
  select(year,
         region,
         v = alien_score,
         sd = boot_sd,
         reference_high,
         reference_low,
         thr,
         i = alien_score_scaled
         )



insect_alien_prop_semi_nat <- alien_sn_exp
```


**Secondly, we calculate the indicator based on the distribution of the alien species**

We call this alien_H, since the calculation resembles Hill numbers from calculations of Shannon information.
 

```r
alien_H_boot <- bootstrap_alien_obs(alien_obs_yl,
                                    groups = c("year",
                                               "region_name"),
                                    rolling_year_window = TRUE,
                                    only_no_spec = FALSE)
```

```r
alien_H_boot
#> # A tibble: 9 × 6
#>    year region_name alien_score boot_sd boot_lower2.5
#>   <int> <chr>             <dbl>   <dbl>         <dbl>
#> 1  2020 Sørlandet         0.904   0.242         0.4  
#> 2  2020 Trøndelag         0.691   0.161         0.4  
#> 3  2020 Østlandet         0.929   0.153         0.633
#> 4  2021 Sørlandet         0.911   0.241         0.5  
#> 5  2021 Trøndelag         0.692   0.160         0.4  
#> 6  2021 Østlandet         0.934   0.152         0.633
#> 7  2022 Sørlandet         0.913   0.250         0.5  
#> 8  2022 Trøndelag         0.708   0.159         0.4  
#> 9  2022 Østlandet         0.932   0.156         0.633
#> # ℹ 1 more variable: boot_upper97.5 <dbl>
```


```r
plot(alien_H_boot)
```

<img src="insectIndicators_files/figure-html/unnamed-chunk-104-1.png" width="672" />
<br/>
Interstingly, by this calculation method, the different regions have much more similar values. Specifically, the southern region has comparable values to the eastern region, while Trøndelag has lower values. This indicates that region Østlandet has markedly higher number of alien species than the Southern region, but with generally more limited distribution. While in comparison, the alien species in the south are more frequently distributed throughout the sampling localities.


```r
ts_plot(alien_H_boot)
```

<img src="insectIndicators_files/figure-html/unnamed-chunk-105-1.png" width="672" />

This indicator also has a natural reference value, with zero presences of alien species, meaning an alien score of 0. We could scale this indicator similarly as with the indicator based on the pure number of alien species. Similar to that case, there is no upper limit to how many alien species there can be, but we set a high enough value, and use a breaking point for the scaling, this upper end point has limited influence.

We don't have enough experience to determine an appropriate breakpoint for the scaling at this point, or an upper value, but exemplify the calculation with some subjective values


```r

alien_H_boot_sf <- alien_H_boot[[1]] %>% 
  select(year,
         region = region_name,
         alien_score = boot_value,
         boot_sd)

alien_H_boot_sf <- norway_reg_NorIns  %>% 
  inner_join(alien_H_boot_sf,
            by = c("region" = "region"),
            multiple = "all")


alien_H_boot_sf$alien_score_scaled <- eaTools::ea_normalise(alien_H_boot_sf,
                                                            vector = "alien_score", 
                                                            upper_reference_level = 10,
                                                            lower_reference_level = 0,
                                                            break_point = 2, 
                                                            reverse = TRUE,
                                                            plot = FALSE)
```

This is then ready for export.

```r
alien_H_sn_exp <- alien_H_boot_sf %>% 
  mutate(reference_high = 10,
         reference_low = 0,
         thr = 2) %>% 
  select(year,
         region,
         v = alien_score,
         sd = boot_sd,
         reference_high,
         reference_low,
         thr,
         i = alien_score_scaled
         )



insect_alien_H_semi_nat <- alien_H_sn_exp
```


#### Genetic diversity of flying insects in semi-natural land
The genetic diversity (GD) of a species is a measurement of the differences between DNA variants within the same species, here calculated on the COI region of the mitochondrial DNA. It is a different measurement in principle than the total number of species in a community, and the number of distinct DNA variants in a community. It is an empirical question whether these measurement correlate on the global or local scale. For instance, Miraldo et al. (2016) found global patterns of decreasing GD near the poles, coinciding with global patterns of species richness. These patterns may share causes, such as higher mutation rates and shorter generation times in warmer climates (Rohde K. 1992). However, it is not clear if and how these patterns are distributed within a smaller region, such as within Norway. Spatial and temporal trends in genetic diversity may indicate pressures on species with reduced effective population sizes, before the complete loss of a species.

Following e.g. Miranda et al. (2016), we define GD as the average number of nucleotide differences per nucleotide site across all pairwise sequence comparisons within a species. Mathematically this can be expressed as: $$\hat{\prod}_s = \frac{1}{(\frac{n}{2})} \sum_{i=1}^{n-1}\sum_{j=i+1}^{n}\frac{k_{ij}}{m_{ij}},$$ where $s$ is a single species, $k_{ij}$ is the number of different nucleotides between sequence $i$ and sequence $j$, $m_{ij}$ is the number of shared base pairs between sequence $i$ and $j$, and $(\frac{n}{2})$ represents the number of pairwise comparisons made (Theodoridis et al 2020). Following French et al. (2023), we here considered only species that where found at least 3 separate times, to make sure we had enough samples to observe any intraspecific diversity.

These species-specific measurements can be combined into single community measurements in several ways. Firstly, we can simply take the average GD of a community of species (GDM), or $$GDM = \frac{1}{S}\sum_{s=1}^{S}\hat{\prod}_s, $$ where $S$ is the total number of species, and $s$ is each species (Theodoridis et al. 2020). The mean genetic diversity of a community is a natural starting point, but can - analogous to species richness -, hide important patterns in the relative contributions from individual species. In short, the distributions of GD might be skewed, so that a few species carries the most influence on the measurement. Therefore, French et al. (2023) has developed a genetic evenness measurement (GDE), that is analogous to Shannon's entropy for communities on the species level. This is defined as $$\frac{exp(\sum_{i=0}^{N} - \hat{\prod}_i ln(\hat{\prod}_i))}{N},$$ where the denominator $N$ is the number of species in the community, and $\hat{\prod}_i$ is the GD calculated above for a single species. The numerator is the Hill number of the Shannon entropy. This results in a measurement that can be compared across communities of different species richness.

We have calculated both the GDM and GDE, but here show only the results of the GDM. The calculated GDE values showed a strong relationship with the number of species in the samples. This could indicate a possible error in the calculation routines, or a more fundamental problem, which needs to be checked before going forward with this measurement. Alternatively, the calculation is correct, but then the values are superfluous, since they give essentially the same information as the total richness, already calculated as a separate indicator.

Therefore, we here present only the GDM as an indicator. Note that this is a relatively new measures, and this is the first time it is calculated for large insect communities in Norway. We need further experience with these measurements to tease out potential pro's and con's in the Norwegian setting. The raw-data on the DNA-sequences is as of yet not publicly available, and the calculations of GDM and GDE is not shown in detail. 



```r
gdm <- readRDS("data/GDM_year_locality.rds")
```

The `gdm` contains the mean genetic diversity for the species found in every year locality combination. This is calculated after first filtering on species that is found at least 3 times.

The `gdm` object contains the year_locality_ids as a key, which we can join to the relevant metadata, e.g. through the alien observation object used above.



```r
gdm_sn <- alien_obs_yl  %>% 
  ungroup() %>% 
  select(yl_id, locality, year, region_name) %>% 
  distinct() %>% 
  inner_join(gdm, by = c("yl_id"= "year_locality_id"))

gdm_sn
#> # A tibble: 60 × 5
#>    yl_id                  locality  year region_name     GDM
#>    <chr>                  <chr>    <int> <chr>         <dbl>
#>  1 a3f86975-b0c2-4200-98… Semi-na…  2020 Østlandet   0.00723
#>  2 11b4435f-8cc9-4ba2-9d… Semi-na…  2020 Østlandet   0.00947
#>  3 0b2956ca-3449-47b8-b9… Semi-na…  2020 Østlandet   0.00883
#>  4 f0412a3b-7864-472d-a8… Semi-na…  2020 Østlandet   0.00618
#>  5 b462682b-d037-43fd-b1… Semi-na…  2020 Østlandet   0.00973
#>  6 c76f63db-56a2-47c4-b2… Semi-na…  2020 Østlandet   0.00950
#>  7 0256d2aa-07f1-45ce-a3… Semi-na…  2020 Østlandet   0.00613
#>  8 271cb773-e404-46a7-a7… Semi-na…  2020 Østlandet   0.00999
#>  9 9768a7ca-0bc8-43bf-94… Semi-na…  2020 Østlandet   0.0111 
#> 10 6a19c4e6-8226-432c-94… Semi-na…  2020 Østlandet   0.00840
#> # ℹ 50 more rows
```

Since these calculations are so novel, it can be worth spending some time exploring how the mean genetic diversity relates to other richness measurement at the locality level. Remember that globally, the species richness and genetic mean diversity show a general positive correlation (Miraldo et al. 2016). 


```r
richness_sn <- get_observations(agg_level = "year_locality",
                                subset_habitat = "Semi-nat")
```


```r
richness_gdm_join <- richness_sn %>% 
  inner_join(gdm_sn,
             by = c("locality" = "locality",
                    "year" = "year",
                    "region_name" = "region_name"))
```


```r
ggplot(richness_gdm_join) +
  geom_point(aes(x = no_species,
                 y = GDM,
                 color = region_name)) +
  geom_smooth(aes(x = no_species,
                 y = GDM,
                 color = region_name),
              method = lm) +
  NinaR::scale_color_nina(name = "Region") +
  xlab("Antall arter")
#> `geom_smooth()` using formula = 'y ~ x'
```

<img src="insectIndicators_files/figure-html/unnamed-chunk-112-1.png" width="672" />
<br/>
Interestingly, and perhaps reassuringly, the number of species doesn't seem to be clearly related to the average genetic diversity. We can look at the mean number of ASVs as well.


```r
ggplot(richness_gdm_join) +
  geom_point(aes(x = mean_no_asv_per_species,
                 y = GDM,
                 color = region_name)) +
  geom_smooth(aes(x = mean_no_asv_per_species,
                 y = GDM,
                 color = region_name),
              method = lm) +
  NinaR::scale_color_nina(name = "Region") +
  xlab("Antall genetiske varianter per art")
#> `geom_smooth()` using formula = 'y ~ x'
```

<img src="insectIndicators_files/figure-html/unnamed-chunk-113-1.png" width="672" />
<br/>
Here we see a positive relationship in Trøndelag (although uncertain), but not the other regions.


```r
ggplot(richness_gdm_join) +
  geom_point(aes(x = no_species,
                 y = mean_no_asv_per_species,
                 color = region_name)) +
  geom_smooth(aes(x = no_species,
                 y = mean_no_asv_per_species,
                 color = region_name),
              method = lm) +
  NinaR::scale_color_nina(name = "Region") +
  xlab("Antall arter") +
  ylab("Antall genetiske varianter per art")
#> `geom_smooth()` using formula = 'y ~ x'
```

<img src="insectIndicators_files/figure-html/unnamed-chunk-114-1.png" width="672" />
<br/>
While, for comparison, the number of ASVs (genetic variants) and the number of species per locality show more clear relationships. This was just a quick look at the genetic aspect of biodiversity, and we would require further analysis to interpret them robustly. In the meantime, we continue with the calculation example of the indicators. We bootstrap the mean genetic diversity like with the other indicators. 


```r
gdm_sn_boot <- bootstrap_value(df = gdm_sn,
                                   value = GDM,
                                   groups = c("year",
                                              "region_name")
                                   )
gdm_sn_boot
#> # A tibble: 9 × 6
#>    year region_name     GDM  boot_sd boot_lower2.5
#>   <int> <chr>         <dbl>    <dbl>         <dbl>
#> 1  2020 Sørlandet   0.00890 0.000601       0.00789
#> 2  2020 Trøndelag   0.00843 0.000373       0.00769
#> 3  2020 Østlandet   0.00882 0.000256       0.00830
#> 4  2021 Sørlandet   0.00890 0.000554       0.00796
#> 5  2021 Trøndelag   0.00842 0.000367       0.00769
#> 6  2021 Østlandet   0.00881 0.000267       0.00827
#> 7  2022 Sørlandet   0.00891 0.000577       0.00794
#> 8  2022 Trøndelag   0.00841 0.000359       0.00771
#> 9  2022 Østlandet   0.00883 0.000264       0.00829
#> # ℹ 1 more variable: boot_upper97.5 <dbl>
```



```r
plot(gdm_sn_boot)
```

<img src="insectIndicators_files/figure-html/unnamed-chunk-116-1.png" width="672" />

So far, Trøndelag seem to have lower genetic diversity than Sørlandet and Østlandet.


```r
ts_plot(gdm_sn_boot)
```

<img src="insectIndicators_files/figure-html/unnamed-chunk-117-1.png" width="672" />

Although, as with the other indicators, we see variation between years. This can be seen if we do not bootstrap on a rolling 5 year window.
 

```r
gdm_sn_yearly_boot <- bootstrap_value(df = gdm_sn,
                                      value = GDM,
                                      groups = c("year",
                                                 "region_name"),
                                      rolling_year_window = FALSE
                                   )
```



```r
ts_plot(gdm_sn_yearly_boot)
```

<img src="insectIndicators_files/figure-html/unnamed-chunk-119-1.png" width="672" />

Compare to arbitrary reference value and normalize.

```r
gdm_sn_ref <- 0.02
  
gdm_sn_diff <- gdm_sn_boot / gdm_sn_ref
```

Plot the results and display uncertainty.

```r
gdm_sn_diff
#> # A tibble: 9 × 6
#>    year region_name   GDM boot_sd boot_lower2.5
#>   <int> <chr>       <dbl>   <dbl>         <dbl>
#> 1  2020 Sørlandet   0.445  0.0300         0.395
#> 2  2020 Trøndelag   0.422  0.0186         0.385
#> 3  2020 Østlandet   0.441  0.0128         0.415
#> 4  2021 Sørlandet   0.445  0.0277         0.398
#> 5  2021 Trøndelag   0.421  0.0183         0.385
#> 6  2021 Østlandet   0.441  0.0134         0.414
#> 7  2022 Sørlandet   0.445  0.0289         0.397
#> 8  2022 Trøndelag   0.420  0.0179         0.385
#> 9  2022 Østlandet   0.441  0.0132         0.415
#> # ℹ 1 more variable: boot_upper97.5 <dbl>
```


```r
plot(gdm_sn_diff,
     limit = c(0, 1))
```

<img src="insectIndicators_files/figure-html/unnamed-chunk-122-1.png" width="672" />

Prepare export format.


```r
gdm_sn_to_exp <- gdm_sn_boot$bootstrap_summary

gdm_sn_to_exp <- gdm_sn_to_exp %>% 
  mutate(reference_high = NA,
         reference_low = 0,
         thr = 0.6,
         i = NA) %>% 
  select(year,
         region = region_name,
         v = boot_value,
         sd = boot_sd,
         reference_high,
         reference_low,
         thr,
         i
         )

gdm_sn_to_exp <- norway_reg_NorIns %>% 
  inner_join(gdm_sn_to_exp,
            by = c("region" = "region"),
            multiple = "all")

insect_genetic_div_semi_nat <- gdm_sn_to_exp
```

### Calculation of NBBM indicators

### Bumblebees in open landscapes

```r
require(bombLepiSurv)
humlesommerfConnect(host = "ninradardata01.nina.no")

```





```r
allBombusGressmark2022 <- getAllData(type = "bumblebees",
                          habitat = "gressmark",
                          year = 2022,
                          language = "norsk")


surveyBarplot(allBombusGressmark2022)
```

<div class="figure">
<img src="insectIndicators_files/figure-html/bombusGressBarplot-1.png" alt="Bumblebees in grasslands 2022" width="672" />
<p class="caption">(\#fig:bombusGressBarplot)Bumblebees in grasslands 2022</p>
</div>



```r
nIter = 999

hInd2022TrondGress <- calcInd(type = "Humler",
                              region_short = "Trond",
                              habitat = "Gressmark",
                              year = 2022,
                              nIter = nIter,
                              save.draws = T)
```


```r
hInd2022SorGress <- calcInd(type = "Humler",
                              region_short = "Sor",
                              habitat = "Gressmark",
                              year = 2022,
                              nIter = nIter,
                              save.draws = T)
```


```r
hInd2022OstGress <- calcInd(type = "Humler",
                              region_short = "Ost",
                              habitat = "Gressmark",
                              year = 2022,
                              nIter = nIter,
                              save.draws = T)
```



```r
hInd2022VestGress <- calcInd(type = "Humler",
                              region_short = "Vest",
                              habitat = "Gressmark",
                              year = 2022,
                              nIter = nIter,
                              save.draws = T)
```


### Butterflies in open landscapes


```r
nIter = 999

sInd2022TrondGress <- calcInd(type = "Sommerfugl",
                              region_short = "Trond",
                              habitat = "Gressmark",
                              year = 2022,
                              nIter = nIter,
                              save.draws = T)
```


```r
sInd2022SorGress <- calcInd(type = "Sommerfugl",
                              region_short = "Sor",
                              habitat = "Gressmark",
                              year = 2022,
                              nIter = nIter,
                              save.draws = T)
```


```r
sInd2022OstGress <- calcInd(type = "Sommerfugl",
                              region_short = "Ost",
                              habitat = "Gressmark",
                              year = 2022,
                              nIter = nIter,
                              save.draws = T)
```



```r
sInd2022VestGress <- calcInd(type = "Sommerfugl",
                              region_short = "Vest",
                              habitat = "Gressmark",
                              year = 2022,
                              nIter = nIter,
                              save.draws = T)
```

The calculations for earlier years are already present as datasets in the R-package and can be fetched individually with `data("dataset")`. Once this is done, we can plot the timeseries of values using the function `indPlot`.



Once loaded, the yearly datasets can be organized through the convenience function `collectIndData`, and plotted with `indPlot`.


```r
hGressIndVals <- collectIndData(taxa = "bumblebees", 
                                habitat = "gressmark",
                                years = 2009:2022)

indPlot(input = hGressIndVals,
        confLevel = "95%",
        lineWidth = 1,
        dodge = 0.5,
        pointSize = 4) +
  ggtitle("Indicator values for bumblebees in semi-natural landscapes") +
  scale_x_continuous(breaks = 2009:2022)
```

<img src="insectIndicators_files/figure-html/bombusGressIndPlot-1.png" width="672" />




```r
sGressIndVals <- collectIndData(taxa = "butterflies", 
                                habitat = "gressmark",
                                years = 2009:2022)

indPlot(input = sGressIndVals,
        confLevel = "95%",
        lineWidth = 1,
        dodge = 0.5,
        pointSize = 4) +
  ggtitle("Indicator values for butterflies in semi-natural landscapes") +
  scale_x_continuous(breaks = 2009:2022)
```

<img src="insectIndicators_files/figure-html/lepiGressIndPlot-1.png" width="672" />



## Prepare export
We here fetch the indicator regions as an sf and join the calculated indicator values. 


```r
norway_reg_NBBM <- bombLepiSurv::get_map() %>% 
  filter(region %in% c("Sør", "Vestlandet", "Øst", "Trøndelag")) %>% 
  select(region) %>% 
  group_by(region) %>% 
  summarize(geom = st_union(geom))
```



```r

hGressIndVals_to_exp <- hGressIndVals %>% 
  mutate(reference_high = 1,
         reference_low = 0,
         thr = 0.6,
         v = NA) %>% 
  select(year = Year,
         region = Region,
         i = Indicator_value,
         ind_sd = NULL,
         ind_lower2.5 = lower95,
         ind_upper97.5 = upper95)

hGressIndVals_to_exp <- norway_reg_NBBM  %>% 
  inner_join(hGressIndVals_to_exp,
            by = c("region" = "region"),
            multiple = "all")

insect_bumblebees_semi_nat <- hGressIndVals_to_exp
```



```r

sGressIndVals_to_exp <- sGressIndVals %>% 
  mutate(reference_high = 1,
         reference_low = 0,
         thr = 0.6,
         v = NA) %>% 
  select(year = Year,
         region = Region,
         i = Indicator_value,
         ind_sd = NULL,
         ind_lower2.5 = lower95,
         ind_upper97.5 = upper95)

sGressIndVals_to_exp <- norway_reg_NBBM  %>% 
  inner_join(sGressIndVals_to_exp,
            by = c("region" = "region"),
            multiple = "all")

insect_butterflies_semi_nat <- sGressIndVals_to_exp
```

### Eksport file (final product)
<!-- Export final file. Ideally a georeferenced shape or raster with indicators values (raw and normalised), reference values and errors. -->


```r
to_export <- ls()[grepl("insect_", ls())] %>% 
  as.list
 
```


```r

write_indicators <- function(x,
                             out_dir = "indicators/indicatorMaps",
                             suffix = ".shp"){
  
  system(paste0("mkdir -p ", out_dir, "/", x))
  
  write_sf(get(x[1]),
           dsn = paste0(out_dir,"/", x, "/", x, suffix))
  
}

lapply(to_export, write_indicators)
```



