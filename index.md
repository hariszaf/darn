# Dark mAtteR iNvesigator (DARN) <br/> understanding the unknown unknowns 

This site may be considered as supplementary material for the 
DARN publication, including all the Krona plots discussed. 


A series of samples were investigated to establish the presence of bacterial and non-bacterial 
dark matter on COI data. 
To this end, marine, estuarine and samples from lakes were gathered. 
In the case of marine samples, both bulk and eDNA samples were collected. 

In the sections to follow, we present all the Krona plots of each case in a single plot, meaning that for 
all the different tests of a single case, all Kronas are embeded on a single plot and you may compare them 
by clicking on the up-left box where are listed. 


## Marine samples 

Both bulk and eDNA marine samples were analysed. 
For a thorough description of the samples you may see the DARN manuscript 
and the corresponding supplementary files.


### Ireland

Samples were analysed in 2 ways;
through [PEMA](http://pema.hcmr.gr/) ([Zafeiropoulos et al. 2020](https://doi.org/10.1093/gigascience/giaa022))
and also through [DADA2](https://benjjneb.github.io/dada2/index.html).

> Primer set: jgHCO2198 - jgLCO1490 and LoboF1 - LoboR1

The results in both cases are rather similar. 

<iframe
  src="https://htmlpreview.github.io/?https://github.com/hariszaf/darn/blob/gh-pages/kronas/irish_marine/irish_marine_samples.html"
  style="width:200%; height:900px;"
></iframe>


We need to mention here that these Kronas are from all the samples used in the study, not just from a single one. 

### Kenya & Honduras


Reef and mangrove data from these two samples were also analyzed in 2 ways; again through PEMA and DADA2
to investigate how much our approach can be affected by bioinformatics analysis. 
As assumed, our approach is robust as long as paramaters tuning in the bioinformatics analysis of the raw data
are not too distinct. 

> Primer set: mlCOIintF - jgHCO2198


<iframe
  src="https://htmlpreview.github.io/?https://github.com/hariszaf/darn/blob/gh-pages/kronas/tropics_marine/tropics.html"
  style="width:200%; height:900px;"
></iframe>


We need to mention here that these Kronas are from all the samples used in the study, not just from a single one. 

### Bulk Vs eDNA samples

Using samples from the same study ([Obst et al. 2020](https://doi.org/10.3389/fmars.2020.572680))
we compared the dark matter in bulk and environmental samples. 

We also tested how our results change, when we set another *d* parameter value, meaning 
increasing or decreasing the number of ASVs returned from the same sample. 

Finally, we compared how the dark matter changes when our samples have been preserved. 


> Primer set: mlCOIintF - jgHCO2198

The following Krona plots are coming from samples that 

* ARMS sample on EtOH using pre clustered sequences 
* ARMS sample on EtOH using ASVs after running Swarm v2 with *d*=2
* ARMS sample on EtOH using ASVs after running Swarm v2 with *d*=10 
* ARMS sample on DMSO using pre clustered sequences 
* ARMS sample on DMSO using ASVs after running Swarm v2 with *d*=2
* ARMS sample on DMSO using ASVs after running Swarm v2 with *d*=10  
* Sediment sample using pre clustered sequences
* Sediment sample using ASVs after running Swarm v2 with *d*=2
* Sediment sample using ASVs after running Swarm v2 with *d*=10


<iframe
  src="https://htmlpreview.github.io/?https://github.com/hariszaf/darn/blob/gh-pages/kronas/marine_arms/arms_bulk.html"
  style="width:200%; height:900px;"
></iframe>


Unlike with the previous Kronas, those presented here represent a single sample. 
In all the cases to follow, Krona plots always stand for a single sample.


## Freshwater samples 


### Lakes in Canada

3 samples from the study of Bista et al. (2017) were used. 
2 of them of 235bp long and one of 658bp. 
The sequences were analyzed through PEMA. 
`darn` was then implemented both before and after the ASVs inference . 


<iframe
  src="https://htmlpreview.github.io/?https://github.com/hariszaf/darn/blob/gh-pages/kronas/lakes/lakes.html"
  style="width:200%; height:900px;"
></iframe>

As already mentioned, each Krona represents a single sample. 

### Lakes in Norway

Here are the first two of them. 

We know only that are coming from some vikings for the time being. We add more once we know! :) 

> Primer set: fwhF2 - EPTDr2

<iframe
  src="https://htmlpreview.github.io/?https://github.com/hariszaf/darn/blob/gh-pages/kronas/norway_lakes/norway_lakes.html"
  style="width:200%; height:900px;"
></iframe> 

As already mentioned, each Krona represents a single sample. 


### Norway river sample

Last but not least, one riverine sample was analysed through PEMA and then used to run DARN. 

> Primer set: BF3 - BR2

<iframe
  src="https://htmlpreview.github.io/?https://github.com/hariszaf/darn/blob/gh-pages/kronas/river/river.html"
  style="width:200%; height:900px;"
></iframe>

As already mentioned, each Krona represents a single sample. 

