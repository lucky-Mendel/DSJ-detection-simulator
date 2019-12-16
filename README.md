# DSJ-detection-simulator
This pipeline is used to simulate SC-RNA data.


# Quick start  
## requirement
All the SC-RNA data which simulated for DSJ-detection are based on Spanki RNA-seq reads simulator, which supports specific RPK (reads per kilo-base) value for each transcript. the dropout event is based brie simulator script with slight change. Thus you need to install Spanki and brie first.
following BRIE tutorial to install is advised.  
[BRIE tutorial](https://github.com/huangyh09/brie/tree/master/simulator)  
follow the brie tutorial and install brie successfully.Then download ```simuDropout_modify.py```script to ```./brie/simulator/``` directory  

## without consideration of dropout event

step1  simulate two original rpk files  
```perl sim_rpk.pl output_file_prefix gene_rpk degree_diff```  
To simulate a differential expression junction related gene,for every two transcript belonging to the same gene in a file,keep  
gene_rpk * gene_length=transcript1_rpk * transcript1_length + transcript2_rpk * transcript2_length  
for A sample, transcript1_rpk/transcript2_rpk value is between degree_diff/2 and degree_diff. Keep the ratio of B inverse to A.

for example  
```perl sim_rpk.pl sim_rpk1 50 8```
This commond outputs two files:sim_rpk1A sim_rpk1B
step2  simulate fastq and bam files   
```
  python Spanki-master/bin/spankisim_transcripts  
  -o output_path 
  -g gencode.v27.primary_assembly.annotation.gtf 
  -f spanki.genome.fasta 
  -t sim_rpk_file -bp 100 -frag 200 -ends 2 -m errorfree
```  
This conmood outputs some files in which junc_coverage.txt is what we need.  
for example  
```
  python Spanki-master/bin/spankisim_transcripts 
  -o ./fastq_file/sim_rpk1A 
  -g gencode.v27.primary_assembly.annotation.gtf 
  -f GRCh38.primary_assembly.genome.spanki.fa 
  -t sim_rpk1A -bp 100 -frag 200 -ends 2 -m errorfree
```  
## take dropout event into consideration  
step1  
  ```perl sim_rpk.pl output_file_prefix gene_rpk degree_diff```  
for example  
  ```perl sim_rpk.pl sim_rpk1 50 8```  

step2  generate a dice format file as input in step3  
  ```awk '{print $2}' rim_rpk_file |paste  - 00.basic_infor/dice_order_four_col >sim_rpk_dice_file```  
for example  
  ```awk '{print $2}' sim_rpk1A |paste - 00.basic_infor/dice_order_four_col >sim_rpk1A_dice```  

step3  simulate dropout event  
```
  python simuDropout_modify.py 
  -a gencode.v27.primary_assembly.annotation.gtf 
  -f GRCh38.primary_assembly.genome.spanki.fa 
  -d sim_rpk_dice_file
  --dropoutRate 0.1 
  -o sim_rpk_dice_output_directory  
  -m errorfree
```  
note: this step will output error message.However, the dropout simulation that we exactly need is output.  
for example  
```
  python simuDropout_modify.py 
  -a gencode.v27.primary_assembly.annotation.gtf 
  -f GRCh38.primary_assembly.genome.spanki.fa 
  -d sim_rpk1A_dice
  --dropoutRate 0.1 
  -o sim_rpk1A_dropout  
  -m errorfree
```  

step4  
```
  python Spanki-master/bin/spankisim_transcripts 
  -o output_directory
  -g gencode.v27.primary_assembly.annotation.gtf 
  -f spanki.genome.fasta 
  -t sim_rpk_file -bp 100 -frag 200 -ends 2 -m errorfree
```  
for example  
```
  python Spanki-master/bin/spankisim_transcripts 
  -o ./fastq_file/sim_rpk1A 
  -g gencode.v27.primary_assembly.annotation.gtf 
  -f GRCh38.primary_assembly.genome.spanki.fa 
  -t sim_rpk1A -bp 100 -frag 200 -ends 2 -m errorfree
```  
