set -e
true
/home/tools/SPAdes/SPAdes-3.14.0/bin/spades-hammer /mnt/analysis/bista_235bp_239/3.correct_by_BayesHammer/ERR1308239/corrected/configs/config.info
/home/tools/OBI/OBI-env/bin/python /home/tools/SPAdes/SPAdes-3.14.0/share/spades/spades_pipeline/scripts/compress_all.py --input_file /mnt/analysis/bista_235bp_239/3.correct_by_BayesHammer/ERR1308239/corrected/corrected.yaml --ext_python_modules_home /home/tools/SPAdes/SPAdes-3.14.0/share/spades --max_threads 20 --output_dir /mnt/analysis/bista_235bp_239/3.correct_by_BayesHammer/ERR1308239/corrected
true
/home/tools/OBI/OBI-env/bin/python /home/tools/SPAdes/SPAdes-3.14.0/share/spades/spades_pipeline/scripts/breaking_scaffolds_script.py --result_scaffolds_filename /mnt/analysis/bista_235bp_239/3.correct_by_BayesHammer/ERR1308239/scaffolds.fasta --misc_dir /mnt/analysis/bista_235bp_239/3.correct_by_BayesHammer/ERR1308239/misc --threshold_for_breaking_scaffolds 3
true
