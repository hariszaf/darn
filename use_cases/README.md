# Investigating environmental samples

In this directory we keep all the samples and their analysis used for the publication of the `DARN` tool. 

A series of e-DNA samples and a few bulk ones, were tested from various aquatic environmets. 

Different primer sets were also used in the different samples. This way, amplicons of different length 
were retrieved and analysed in the `DARN` framework. 

The structure of each subdirectory under `use_cases` is as in the following example:

In `marine` we have 3 samples. A subdirectory has been built for each of those.
In the `ERR3460466` you will find:
* a folder with the raw data called `mydata`. 
* the `parameteres.tsv` with the parameters set used for the bioinformartics analysis that PEMA requires
* a folder with the PEMA output called `arms_coi` 


All these are related to the pre-`DARN` analysis and we need that to get the input files for `DARN`. 
For each sample, we ran `DARN` with 3 different cases: 
* `arms_MDSO_pre_clustered.fasta` is the sequences that we get from the sample after the pre-processing steps
* `arms_MDSO_clustered_d_2.fasta` is the set of sequences retrieved as ASVs after running the Swarm v2 algorithm with *d* = 2
* `arms_MDSO_clustered_d_10.fasta` is the set of sequences retrieved as ASVs after running the Swarm v2 algorithm with *d* = 10

Parameter *d* is essential for the Swarm algorithm and you may find more about that [here](https://github.com/torognes/swarm#common-misconceptions).

Then `DARN` was performed and build the `intermediate` and the `final_outcome` directories. 
It is the latter where you may find the Krona plots that we are interested in to get an overview of the sample under study. 


> The `_pres_abs.krona_plot.html` are those files that we are the most interested in. 


