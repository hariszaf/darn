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


while getopts ":s:t:" o; do
   case "${o}" in
      s)
         sample=${OPTARG}
         ;;
	   t)
         threads=${OPTARG}
         ;;
     *)
         usage
         ;;
   esac
done
shift $((OPTIND-1))

if [ -z "${sample}" ]; then
    echo "One or more mandatory parameters were not set."
    usage
fi

if [ -z "${threads}" ]; then
    threads=1
fi

nameFile=${sample##*/}


#---------------------------------------------------------------------------------------------------

# Parameters were set. Ready to run DARN.

#---------------------------------------------------------------------------------------------------

# Sample name
sampleName=${nameFile::-6}

# Keep the headers of the seqs in a file
awk -v n=1 '{if($x~/>/) {print $0 "_Query" n; n++}else{print $0}}' $sample > darn_$sampleName.fasta
cp darn_$sampleName.fasta query.fasta

# To relabel the Otus on the multiline fasta
awk -v n=1 '{if($x~/>/){sub(/>.*/, ">Query" n); print; n++}else{print $0}}' $sample > labeled_$nameFile

# To convert single line fasta to multi line
sed '/^>/!s/.\{80\}/&\n/g' labeled_$nameFile > multiline_labeled_$nameFile

sed -i '/^[[:space:]]*$/d' multiline_labeled_$name_file

# Run PaPaRa
/home/tools/papara_nt-2.5/papara \
	-t /home/docs/magicTree.bestTree \
	-s /home/docs/magic_tree_aln.phy \
	-n papara \
	-q multiline_labeled_$nameFile \
	-r \
	-j $threads

# Remove ref seqs
tail -23234 papara_alignment.papara > papara.phy

sed -i '1d' papara.phy
awk '{print ">"$0}' papara.phy > tmp

sed 's/ \{1,\}/ /g ; s/ /\n/' tmp > tmp2
sed '/^>/!s/.\{80\}/&\n/g' tmp2 > papara.fasta

rm tmp tmp2


# Run EPA-ng
/home/tools/epa/bin/epa-ng -t /home/docs/magicTree.bestTree -s /home/docs/magic_tree_aln.fasta -m GTR+FO+G4m -q papara.fasta

# Run gappa to build krona input
# IMPORTANT HINT! Darn will build Krona plots based on the BEST HITS assignments; both based on the likelihood values and in a binary way. 
# However, it will also return the likelihoods of the exhaustive likelihood values to allow user a thorough overview of its queries
/home/tools/gappa/bin/gappa examine assign \
   --file-prefix darn_assign_exhaustive_$sampleName\_ \
   --jplace-path epa_result.jplace \
   --taxon-file docs/TAXONOMY_ALL \
   --per-query-results \
   --krona

/home/tools/gappa/bin/gappa examine assign \
   --file-prefix darn_best_hit_$sampleName\_ \
   --jplace-path epa_result.jplace \
   --taxon-file docs/TAXONOMY_ALL \
   --per-query-results \
   --best-hit \
   --krona


# Remove non query sequences from the output of gappa assign
sed 's/^Archaea.*//g ; s/^Bacteria.*//g ; s/^Eukaryota.*//g ; /^$/d ' darn_best_hit_$sampleName\_per_query.tsv > tmp 
rm darn_best_hit_$sampleName\_per_query.tsv
mv tmp darn_best_hit_$sampleName\_per_query.tsv

sed 's/^Archaea.*//g ; s/^Bacteria.*//g ; s/^Eukaryota.*//g ; /^$/d ' darn_assign_exhaustive_$sampleName\_per_query.tsv > tmp
rm darn_assign_exhaustive_$sampleName\_per_query.tsv
mv tmp darn_assign_exhaustive_$sampleName\_per_query.tsv

# Run parsing script; this step uses the gappa output to get the 
cp darn_best_hit_$sampleName\_per_query.tsv darn_gappa_assign_per_query.tsv
python3 parse_per_query.py
rm darn_gappa_assign_per_query.tsv

# Build Krona input (profile) for binary 
cp darn_processed.profile darn_pres_abs_$sampleName\_krona.profile.tmp
awk '$1="1.0"' darn_pres_abs_$sampleName\_krona.profile.tmp > darn_pres_abs_$sampleName\_krona.profile.tmp2
sed 's/ /\t/g' darn_pres_abs_marine_part_krona.profile.tmp2 > darn_pres_abs_$sampleName\_krona.profile
mv darn_processed.profile darn_likelihood_$sampleName\_krona.profile

# Build Krona plots
ktImportText darn_pres_abs_$sampleName\_krona.profile -o darn_$sampleName\_pres_abs.krona_plot.html
ktImportText darn_likelihood_$sampleName\_krona.profile -o darn_$sampleName\_likelihood.krona_plot.html

# Move krona plots and important files to mount directory
rm darn_pres_abs_$sampleName\_krona.profile.tmp* 
rm query.fasta
mv epa_result.jplace darn_$sampleName\_epa_result.jplace
mv darn_* /mnt

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
mv /mnt/darn_pres_abs* /mnt/intermediate/best_hits
mv /mnt/*epa_result.jplace /mnt/intermediate

# Rename output files to follow the sample notion
cd /mnt
mv darn_eukaryota_assignments.fasta darn_$sampleName\_eukaryota_assignments.fasta
mv darn_bacteria_assignments.fasta darn_$sampleName\_bacteria_assignments.fasta
mv darn_archaea_assignments.fasta darn_$sampleName\_archaea_assignments.fasta
mv darn_assignments_per_domain.json darn_$sampleName\_assignments_per_domain.json

# And move the interesting part to the final outcome directory!
mkdir -p final_outcome
mv /mnt/*.html /mnt/final_outcome
mv /mnt/*.json /mnt/final_outcome
mv /mnt/darn_*.fasta  /mnt/final_outcome

echo "DARN has been completed. You may dive into the dark matter.."
