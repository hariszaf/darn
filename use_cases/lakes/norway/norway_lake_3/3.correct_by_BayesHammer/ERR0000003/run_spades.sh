set -e
true
/home/tools/SPAdes/SPAdes-3.14.0/bin/spades-hammer /mnt/analysis/norway_lake_3/3.correct_by_BayesHammer/ERR0000003/corrected/configs/config.info
/home/tools/OBI/OBI-env/bin/python /home/tools/SPAdes/SPAdes-3.14.0/share/spades/spades_pipeline/scripts/compress_all.py --input_file /mnt/analysis/norway_lake_3/3.correct_by_BayesHammer/ERR0000003/corrected/corrected.yaml --ext_python_modules_home /home/tools/SPAdes/SPAdes-3.14.0/share/spades --max_threads 20 --output_dir /mnt/analysis/norway_lake_3/3.correct_by_BayesHammer/ERR0000003/corrected
true
/home/tools/OBI/OBI-env/bin/python /home/tools/SPAdes/SPAdes-3.14.0/share/spades/spades_pipeline/scripts/breaking_scaffolds_script.py --result_scaffolds_filename /mnt/analysis/norway_lake_3/3.correct_by_BayesHammer/ERR0000003/scaffolds.fasta --misc_dir /mnt/analysis/norway_lake_3/3.correct_by_BayesHammer/ERR0000003/misc --threshold_for_breaking_scaffolds 3
true
