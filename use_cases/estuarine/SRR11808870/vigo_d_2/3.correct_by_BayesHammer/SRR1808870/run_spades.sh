set -e
true
/home/tools/SPAdes/SPAdes-3.14.0/bin/spades-hammer /mnt/analysis/vigo_d_2/3.correct_by_BayesHammer/SRR1808870/corrected/configs/config.info
/home/tools/OBI/OBI-env/bin/python /home/tools/SPAdes/SPAdes-3.14.0/share/spades/spades_pipeline/scripts/compress_all.py --input_file /mnt/analysis/vigo_d_2/3.correct_by_BayesHammer/SRR1808870/corrected/corrected.yaml --ext_python_modules_home /home/tools/SPAdes/SPAdes-3.14.0/share/spades --max_threads 20 --output_dir /mnt/analysis/vigo_d_2/3.correct_by_BayesHammer/SRR1808870/corrected
true
/home/tools/OBI/OBI-env/bin/python /home/tools/SPAdes/SPAdes-3.14.0/share/spades/spades_pipeline/scripts/breaking_scaffolds_script.py --result_scaffolds_filename /mnt/analysis/vigo_d_2/3.correct_by_BayesHammer/SRR1808870/scaffolds.fasta --misc_dir /mnt/analysis/vigo_d_2/3.correct_by_BayesHammer/SRR1808870/misc --threshold_for_breaking_scaffolds 3
true
