Here is an example case. 

The `marine_part.fasta` is the input file for `darn`.

The two directories `intermediate` and `final_outcome` is what `darn` returns. 

In the latter, for each sample you run, you will find:

* 2 Krona plots:
    * using the likelihood values of the best hits of the queries and 
    * using a binary (presence - absence) notion

* a .json file with all the qurey assignments per domain (Bacteria, Archaea, Eukaryota)

* and 4 .fasta files:
   * one with a "_QueryXX" as suffix, where "XX" is a serial number
   * one for each domain, with the sequences that have been assigned to each (always using the best hit assignments)
