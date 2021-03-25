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


# Sample name
sampleName=${nameFile::-6}

# Run EPA-ng
/home/tools/epa/bin/epa-ng -t /home/docs/magicTree.bestTree -s /home/docs/magic_tree_aln.fasta -m GTR+FO+G4m -q papara.fasta

# Run gappa to build krona input
/home/tools/gappa/bin/gappa examine assign --file-prefix darn_assign_exhaustive_$sampleName\_ --jplace-path epa_result.jplace --taxon-file docs/TAXONOMY_ALL --per-query-results --krona
mv darn_assign_exhaustive_* /mnt
rm darn_assign_*
/home/tools/gappa/bin/gappa examine assign --file-prefix darn_gappa_assign_$sampleName\_ --jplace-path epa_result.jplace --taxon-file docs/TAXONOMY_ALL --per-query-results --best-hit --krona

# Build Krona plot - using the likelihood values
ktImportText darn_gappa_assign_$sampleName\_krona.profile -o darn_$sampleName.krona_plot.html

# Run parsing script
cp *_per_query.tsv darn_gappa_assign_per_query.tsv
python3 parse_per_query.py
rm darn_gappa_assign_per_query.tsv

mv darn_pres_abs.profile darn_pres_abs_$sampleName\_krona.profile.tmp

awk '$1="1.0"' darn_pres_abs_$sampleName\_krona.profile.tmp > darn_pres_abs_$sampleName\_krona.profile.tmp2

# # Build Krona plot
sed 's/ /\t/g' darn_pres_abs_marine_part_krona.profile.tmp2 > darn_pres_abs_marine_part_krona.profile
ktImportText darn_pres_abs_$sampleName\_krona.profile -o darn_$sampleName\_pres_abs.krona_plot.html
rm darn_pres_abs_marine_part_krona.profile.tmp*


# Move krona plots and important files to mount directory
mv epa_result.jplace /mnt
mv *.html /mnt
# mv darn_gappa_assign_* /mnt
# mv darn_assignments_per_domain.json /mnt
mv darn_* /mnt


echo "DARN has been completed. You may dive into the dark matter.."
