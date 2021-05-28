# Dark mAtteR iNvesigator (DARN) <br/> understanding the unknown unknowns 

On this page, we present the Krona plots returned by DARN 
regarding the analyses implemented 
for its corresponding publication. 

A series of samples were investigated to establish the presence of bacterial and non-bacterial 
dark matter on COI data, in an attempt to represent the various feautures thay may affect 
such studies.  

In the sections to follow, we present all the Krona plots of each case in a single plot, meaning that for 
all the different tests of a single case, all Kronas are embeded on a single plot and you may compare them 
by clicking on the up-left box where are listed. 


## Marine samples 

Both bulk and eDNA marine samples were analysed. 
For a thorough description of the samples you may see the DARN manuscript 
and the corresponding supplementary files.


### Ireland

> Primer set: jgHCO2198 - jgLCO1490 and LoboF1 - LoboR1

A dataset of 57 marine, surface water eDNA samples (PRJEB45030) were analysed in 2 ways: 

* using [QIIME2](https://qiime2.org/) and [DADA2](https://benjjneb.github.io/dada2/index.html) and
* through [PEMA](http://pema.hcmr.gr/), using the Swarm clustering algorithm option with *d* = 10 

The ASVs returned in both cases, were used as input to run DARN. 


<iframe
  src="https://htmlpreview.github.io/?https://github.com/hariszaf/darn/blob/gh-pages/kronas/irish_marine/irish_marine_samples.html"
  style="width:200%; height:900px;"
></iframe>




### Honduras

> Primer set: mlCOIintF - jgHCO2198


Reef and mangrove data from Honduras were also analyzed in 2 ways:
* using the [DnoisE](https://github.com/adriantich/DnoisE) and 
* PEMA (again using the Swarm clustering algorithn - *d* = 10)


<iframe
  src="https://htmlpreview.github.io/?https://github.com/hariszaf/darn/blob/gh-pages/kronas/tropics_marine/tropics.html"
  style="width:200%; height:900px;"
></iframe>


DARN output is rather similar comparing one bioinformatics pipeline with the other, especially in the case of the reef samples. 

The differences 



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


Unlike the previous Kronas, those presented here represent a **single** sample; not a complete dataset. 

> In all the cases to follow, Krona plots always stand for a single sample.


## Freshwater samples 


<!-- ### Lakes in Canada

3 samples from the study of Bista et al. (2017) were used. 
2 of them of 235bp long and one of 658bp. 
The sequences were analyzed through PEMA. 
`darn` was then implemented both before and after the ASVs inference . 


<iframe
  src="https://htmlpreview.github.io/?https://github.com/hariszaf/darn/blob/gh-pages/kronas/lakes/lakes.html"
  style="width:200%; height:900px;"
></iframe>
 -->
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

