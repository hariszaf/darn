<img src="https://raw.githubusercontent.com/hariszaf/darn/main/figures/darn_logo.png" width="200" height="200">

# DARN - Dark mAtteR iNvestigator

This is the Dark mAtteR iNvestigator tool (DARN).

DARN uses a COI reference tree of life to assign your sequences to the 3 domains of life.

Its purpose is not to provide you with certain taxonomic assignment but to give an overview of the species present. 

## Methodology

To build DARN we had to build a COI-oriented tree of life. Here is the approach we followed. 

<img src="https://raw.githubusercontent.com/hariszaf/darn/main/figures/darn_workflow.png" width="700" height="950">


## Output

Once you run DARN against your sample, you will get a Krona interactive plot, in `.html` format as the one here:

<img src="https://raw.githubusercontent.com/hariszaf/darn/main/figures/darn_krona.png" width="800" height="500">

You will also get the a `.newick` and a `.jplace` file with the assignments on the tree as well as the `.profile` that was used to get the Krona plot. 

You may have a look on the DARN output over [here](https://github.com/hariszaf/darn/tree/main/analysis).



## How to run 

You may get DARN as a Docker image by running: 

```
docker pull hariszaf/darn
```

and then run it by mounting a directory on your physical maching to the container 

```
docker run --rm -it -v /path_to_your_sample/:/mnt darn
```

and once the shell is on you just need to run:

```
./darn.sh -s /mnt/your_sample.fasta -t <number_of_threads_available>
```

In case, you are working on Singularity, you follow the following steps


```
singularity pull shub://hariszaf/darn
```

and like in the Docker case, you need to open a shell mounting the directory where your sample is located

```
singularity run -B /<path_to_your_sample/:/mnt /<path_to>/darn.sif
```

and once shell appears:

```
./darn.sh -s /mnt/your_sample.fasta -t <number_of_threads_available>
```

**In both cases, the output of DARN will be returned in the path you mount!**


## Licences
DARN makes use of the following software:
* [PaPaRa](https://cme.h-its.org/exelixis/web/software/papara/index.html) and EPA-ng algorithms. 
* [EPA-ng](https://github.com/Pbdas/epa-ng)
* [gappa](https://github.com/lczech/gappa/)
* [krona](https://github.com/marbl/Krona/wiki)

Their corresponding licenses apply. 


