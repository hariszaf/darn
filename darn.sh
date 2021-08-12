#!/usr/bin/env bash

#---------------------------------------------------------------------------------------------------
#
# This is the Dark mAtteR iNvestigator tool.
# DARN uses a COI reference tree of life to assign your sequences to the 3 domains of life
# Its purpose is not to provide you with certain taxonomic assignment but to give an overview 
# of the species present. 
#
# Maintainer: Haris Zafeiropoulos
# e-mail: haris-zaf@hcmr.gr
#---------------------------------------------------------------------------------------------------


usage() {
   echo ""
   echo "

██████╗  █████╗ ██████╗ ███╗   ██╗
██╔══██╗██╔══██╗██╔══██╗████╗  ██║
██║  ██║███████║██████╔╝██╔██╗ ██║
██║  ██║██╔══██║██╔══██╗██║╚██╗██║
██████╔╝██║  ██║██║  ██║██║ ╚████║
╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝

   "
   echo "Description: This is the Dark mAtteR iNvestigator tool.
	DARN uses a COI reference tree of life to assign your sequences to the 3 domains of life.
	Its purpose is not to provide you with certain taxonomic assignment but to give an overview of the species present.
	"
   echo "Usage: bash $0 -s sequence_sample"
   echo -e "\t -s \t Path to the input sequence file. This file needs to be in .fasta format"
   echo -e "\t -t \t Number of threads to be used in the PaPaRa step."
   echo -e "\t -h \t How to use DARN"
   echo -e "\n"
   echo -e "Example:"
   echo -e "./darn -s my_query_file.fasta -o /home/user_1/Desktop"
   exit 1 # Exit script after printing help
}


while getopts ":s:t:o:" o; do
   case "${o}" in
      s)
         sample=${OPTARG}
         ;;
      t)
         threads=${OPTARG}
         ;;
      o)
         orientation=${OPTARG}
         ;;
      *)
         usage
         ;;
   esac
done

shift $((OPTIND-1))

# Check if string is null, i.e that has zero length
if [ -z "${sample}" ]; then
    echo "DARN needs a .fasta sample as input."
    usage
fi

if [ -z "${threads}" ]; then
    threads=1
fi

# Keep the complete name of the file
nameFile=${sample##*/}

# Remove the .fasta suffix
sampleName=${nameFile::-6}


#---------------------------------------------------------------------------------------------------

# Parameters were set. Ready to run DARN.

#---------------------------------------------------------------------------------------------------

###########################
#   Prepare your sample   #
###########################

# If darn has been used again in the same directory, the epa log output must be removed if has not changed
cd /mnt
[[ -f epa_info.log ]] && rm epa_info.log

# Keep the headers of the seqs in a file
awk -v n=1 '{if($x~/>/) {printf "%s\t%s\n",$0,"Query"n;n++} else {print $0}}' $sample > darn.fasta.tmp
cat darn.fasta.tmp | tr -d '\r' > darn.fasta.tmp.2
sed 's/\t/_/' darn.fasta.tmp.2 > darn_$sampleName.fasta
rm darn.fasta.tmp*

# To relabel the Otus on the multiline fasta
awk -v n=1 '{if($x~/>/){sub(/>.*/, ">Query" n); print; n++} else {print $0}}' $sample > labeled_$nameFile

# To convert single line fasta to multi line
sed '/^>/!s/.\{80\}/&\n/g' labeled_$nameFile > multiline_labeled_$nameFile

# Remove blank spaces
sed -i '/^[[:space:]]*$/d' multiline_labeled_$nameFile


# Make sure the sequences of the .fasta file are with capital letters
awk '{if ($0 ~ />/ ){print $0} else {print toupper($0)}}' multiline_labeled_$nameFile  > caps_multiline_labeled_$nameFile
mv caps_multiline_labeled_$nameFile multiline_labeled_$nameFile


# Make sure about having the correct orientation
if [[ $orientation != 0 ]] ; then

   printf "\n >>> STEP 0: Orientation of the input sequences using the --orient module of the VSEARCH tool (Torbjørn, et al. 2016), \n based on the consensus sequences used to build the reference COI phylogenetic tree that DARN makes use of. \n"
   
   vsearch --orient multiline_labeled_$nameFile --db /home/docs/oriented_consensus_seqs.fasta --fastaout darn_oriented_$nameFile

   printf "\n STEP 0 has been completed. \n" 

else
   cp multiline_labeled_$nameFile darn_oriented_$nameFile
fi


# Single line copy to run with python parse script
awk '{if(NR==1) {print $0} else {if($0 ~ /^>/) {print "\n"$0} else {printf $0}}}' darn_oriented_$nameFile > oriented_input.fasta

# Keep header - darn id pairs
grep ">"  darn_$sampleName.fasta > id_pairs ; sed 's/>//g' id_pairs > PINK ; mv PINK id_pairs


################################
#    query MSA and placement   #
################################

# Run PaPaRa
printf "\n >>> STEP 1: alignment of input reads to the MSA built from the consensus COI sequences, \n using the PaPaRa software (S.A. Berger, A. Stamatakis 2012).\n"
/home/tools/papara_nt-2.5/papara \
	-t /home/docs/magicTree.bestTree \
	-s /home/docs/magic_tree_aln.phy \
	-n papara \
	-q darn_oriented_$nameFile \
	-r \
	-j $threads

printf "\n <<< STEP 1 has been completed.\n"

# Remove ref seqs from the query MSA
/home/tools/epa/bin/epa-ng --split /home/docs/magic_tree_aln.phy papara_alignment.papara


# Run EPA-ng - remember the model we use is the one used for building the reference tree
printf "\n >>> STEP 2: placement of the input reads on the reference COI phylogenetic tree of DARN, \n using the EPA-ng algorithm (Barbera et al. 2018). \n"
/home/tools/epa/bin/epa-ng -t /home/docs/magicTree.bestTree -s /home/docs/magic_tree_aln.fasta -m GTR+F+R10 -q query.fasta 
printf "\n <<< STEP 2 has been completed. \n"

# Run gappa to build krona input
printf "\n >>> STEP 3: Build assignment profiles per input query, \n using the examine assign of the gappa package (Czech et al. 2020). \n"
/home/tools/gappa/bin/gappa examine assign \
   --file-prefix darn_assign_exhaustive_$sampleName\_ \
   --jplace-path epa_result.jplace \
   --taxon-file /home/docs/TAXONOMY_ALL \
   --per-query-results \
   --krona

/home/tools/gappa/bin/gappa examine assign \
   --file-prefix darn_best_hit_$sampleName\_ \
   --jplace-path epa_result.jplace \
   --taxon-file /home/docs/TAXONOMY_ALL \
   --per-query-results \
   --best-hit \
   --krona
printf "\n <<< STEP 3 has been completed. \n"

# Remove non query sequences from the output of gappa assign
sed 's/^Archaea.*//g ; s/^Bacteria.*//g ; s/^Eukaryota.*//g ; /^$/d ' darn_best_hit_$sampleName\_per_query.tsv > tmp 
rm darn_best_hit_$sampleName\_per_query.tsv
mv tmp darn_best_hit_$sampleName\_per_query.tsv

sed 's/^Archaea.*//g ; s/^Bacteria.*//g ; s/^Eukaryota.*//g ; /^$/d ' darn_assign_exhaustive_$sampleName\_per_query.tsv > tmp
rm darn_assign_exhaustive_$sampleName\_per_query.tsv
mv tmp darn_assign_exhaustive_$sampleName\_per_query.tsv

# Run parsing script; this step uses the gappa output to get the 
printf "\n >>> STEP 4: Parse the profiles returned to build Krona-specific profiles. \n"
cp darn_best_hit_$sampleName\_per_query.tsv darn_gappa_assign_per_query.tsv
python3 /home/parse_per_query.py
rm darn_gappa_assign_per_query.tsv
printf "\n <<< STEP 4 has been completed.\n"

# Build Krona input (profile) for binary 
mv darn_processed_lwr.profile darn_likelihood_$sampleName\_krona.profile
mv darn_processed_counts.profile darn_counts_$sampleName\_krona.profile

# Build Krona plots
printf "\n >>> STEP5: Build Krona plots using the ktImportText command of KronaTools (Ondov et al. 2011)."
ktImportText darn_counts_$sampleName\_krona.profile -o darn_$sampleName\_pres_abs.krona_plot.html
ktImportText darn_likelihood_$sampleName\_krona.profile -o darn_$sampleName\_likelihood.krona_plot.html
printf "\n <<< STEP 5 has been completed. \n"

###########################
#    Build darn output    #
###########################

printf "\n >>> STEP 6: Build DARN output \n"

# Move krona plots and important files to mount directory
rm query.fasta
mv epa_result.jplace darn_$sampleName\_epa_result.jplace


# Build a directory to move the exhaustive files 
cd /mnt
mkdir -p intermediate
cd /mnt/intermediate
mkdir -p gappa_exhaustive
mv /mnt/darn_assign_exhaustive* /mnt/intermediate/gappa_exhaustive

# Likewise, for the best hits
mkdir -p best_hits
mv /mnt/darn_best_hit* /mnt/intermediate/best_hits
mv /mnt/darn_likelihood* /mnt/intermediate/best_hits
mv /mnt/darn_counts* /mnt/intermediate/best_hits
mv /mnt/*epa_result.jplace /mnt/intermediate

# Rename output files to follow the sample notion
cd /mnt
[[ -f darn_eukaryota_assignments.fasta ]] && mv darn_eukaryota_assignments.fasta darn_$sampleName\_eukaryota_assignments.fasta
[[ -f darn_bacteria_assignments.fasta ]] && mv darn_bacteria_assignments.fasta darn_$sampleName\_bacteria_assignments.fasta
[[ -f darn_archaea_assignments.fasta ]] && mv darn_archaea_assignments.fasta darn_$sampleName\_archaea_assignments.fasta
[[ -f darn_distant_assignments.fasta ]] && mv darn_distant_assignments.fasta darn_$sampleName\_distant_assignments.fasta

[[ -f darn_assignments_per_domain.json ]] && mv darn_assignments_per_domain.json darn_$sampleName\_assignments_per_domain.json


# And move the interesting part to the final outcome directory!
mkdir -p final_outcome
mv *.html /mnt/final_outcome
mv *.json /mnt/final_outcome
mv darn_*.fasta  /mnt/final_outcome
rm oriented* id_pairs

# Remove the rest
cd /mnt
rm epa_info.log papara* multiline* labeled_* reference.fasta

printf "\n <<< STEP 6 has been completed \n"

printf "\n DARN has been completed! Thanks for using DARN! \n"