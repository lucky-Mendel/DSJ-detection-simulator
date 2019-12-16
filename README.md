# DSJ-detection-simulator
This pipeline is used to simulate SC-RNA data.


# Quick start  
## Requirement
All the SC-RNA data which simulated for DSJ-detection are based on Spanki RNA-seq reads simulator, which supports specific RPK (reads per kilo-base) value for each transcript. The dropout event is based brie simulator script with slight change.Thus,you need to install Spanki and brie first.

Following BRIE tutorial to install is advised.  

[BRIE tutorial](https://github.com/huangyh09/brie/tree/master/simulator)  
follow the brie tutorial and install brie successfully.Then download ```simuDropout_modify.py```script to ```./brie/simulator/``` directory  

## Without consideration of dropout event

Step1  simulate two original rpk files  
```perl sim_rpk.pl output_file_prefix gene_rpk degree_diff```  
To simulate a differential expression junction related gene,for every two transcript belonging to the same gene in a file,keep **gene_rpk * gene_length=transcript1_rpk * transcript1_length + transcript2_rpk * transcript2_length**  
For A sample, transcript1_rpk/transcript2_rpk value is between degree_diff/2 and degree_diff. Keep the ratio of B inverse to A.

Example  
```perl sim_rpk.pl sim_rpk1 50 8```
This commond outputs two files:sim_rpk1A sim_rpk1B
Step2  simulate fastq and bam files   
```
  python Spanki-master/bin/spankisim_transcripts  
  -o output_path 
  -g gencode.v27.primary_assembly.annotation.gtf 
  -f spanki.genome.fasta 
  -t sim_rpk_file -bp 100 -frag 200 -ends 2 -m errorfree
```  
This conmood outputs some files in which junc_coverage.txt is what we need.  
Example  
```
  python Spanki-master/bin/spankisim_transcripts 
  -o ./fastq_file/sim_rpk1A 
  -g gencode.v27.primary_assembly.annotation.gtf 
  -f GRCh38.primary_assembly.genome.spanki.fa 
  -t sim_rpk1A -bp 100 -frag 200 -ends 2 -m errorfree
```  
## Take dropout event into consideration  
Step1  
  ```perl sim_rpk.pl output_file_prefix gene_rpk degree_diff```  
Example  
  ```perl sim_rpk.pl sim_rpk1 50 8```  

Step2  generate a dice format file as input in step3  
  ```awk '{print $2}' rim_rpk_file |paste  - 00.basic_infor/dice_order_four_col >sim_rpk_dice_file```  
Example  
  ```awk '{print $2}' sim_rpk1A |paste - 00.basic_infor/dice_order_four_col >sim_rpk1A_dice```  

Step3  simulate dropout event  
```
  python simuDropout_modify.py 
  -a gencode.v27.primary_assembly.annotation.gtf 
  -f GRCh38.primary_assembly.genome.spanki.fa 
  -d sim_rpk_dice_file
  --dropoutRate 0.1 
  -o sim_rpk_dice_output_directory  
  -m errorfree
```  
**NOTE**: This step will output error message.However, the dropout simulation that we exactly need has been outputed.  
Example  
```
  python simuDropout_modify.py 
  -a gencode.v27.primary_assembly.annotation.gtf 
  -f GRCh38.primary_assembly.genome.spanki.fa 
  -d sim_rpk1A_dice
  --dropoutRate 0.1 
  -o sim_rpk1A_dropout  
  -m errorfree
```  

Step4  
```
  python Spanki-master/bin/spankisim_transcripts 
  -o output_directory
  -g gencode.v27.primary_assembly.annotation.gtf 
  -f spanki.genome.fasta 
  -t sim_rpk_file -bp 100 -frag 200 -ends 2 -m errorfree
```  
Example  
```
  python Spanki-master/bin/spankisim_transcripts 
  -o ./fastq_file/sim_rpk1A 
  -g gencode.v27.primary_assembly.annotation.gtf 
  -f GRCh38.primary_assembly.genome.spanki.fa 
  -t sim_rpk1A -bp 100 -frag 200 -ends 2 -m errorfree
```  
