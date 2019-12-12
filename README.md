# DSJ-detection-simulator
This pipeline is used to simulate SC-RNA data 
without consideration of dropout event
step1:
perl sim_rpk.pl output_file_prefix gene_rpk degree_diff
step2
python Spanki-master/bin/spankisim_transcripts 
-o output_path 
-g gencode.v27.primary_assembly.annotation.gtf 
-f spanki.genome.fasta 
-t sim_rpk_file -bp 100 -frag 200 -ends 2 -m errorfree

python Spanki-master/bin/spankisim_transcripts 
-o ./fastq_file/sim_rpk1A 
-g gencode.v27.primary_assembly.annotation.gtf 
-f GRCh38.primary_assembly.genome.spanki.fa 
-t sim_rpk1A -bp 100 -frag 200 -ends 2 -m errorfree
