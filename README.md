# DSJ-detection-simulator
This pipeline is used to simulate SC-RNA data.

##without consideration of dropout event

step1
```perl sim_rpk.pl output_file_prefix gene_rpk degree_diff```
for example  
```perl sim_rpk.pl sim_rpk1 50 8```

step2
```python Spanki-master/bin/spankisim_transcripts  
  -o output_path 
  -g gencode.v27.primary_assembly.annotation.gtf 
  -f spanki.genome.fasta 
  -t sim_rpk_file -bp 100 -frag 200 -ends 2 -m errorfree
```  
for example  
```python Spanki-master/bin/spankisim_transcripts 
  -o ./fastq_file/sim_rpk1A 
  -g gencode.v27.primary_assembly.annotation.gtf 
  -f GRCh38.primary_assembly.genome.spanki.fa 
  -t sim_rpk1A -bp 100 -frag 200 -ends 2 -m errorfree
```  
##take dropout event into consideration  
step1  
  ```perl sim_rpk.pl output_file_prefix gene_rpk degree_diff```  
for example  
  ```perl sim_rpk.pl sim_rpk1 50 8```  

step2
  ```awk '{print $2}' rim_rpk_file |paste  - 00.basic_infor/dice_order_four_col >sim_rpk_dice_file```  
for example  
  ```awk '{print $2}' sim_rpk1A |paste - 00.basic_infor/dice_order_four_col >sim_rpk1A_dice```  

step3
```python simuDropout_modify.py 
  -a gencode.v27.primary_assembly.annotation.gtf 
  -f GRCh38.primary_assembly.genome.spanki.fa 
  -d sim_rpk_dice_file
  --dropoutRate 0.1 
  -o sim_rpk_dice_output_directory  
  -m errorfree
```  
for example  
```python simuDropout_modify.py 
  -a gencode.v27.primary_assembly.annotation.gtf 
  -f GRCh38.primary_assembly.genome.spanki.fa 
  -d sim_rpk1A_dice
  --dropoutRate 0.1 
  -o sim_rpk1A_dropout  
  -m errorfree
```  

step4
```python Spanki-master/bin/spankisim_transcripts 
  -o output_directory
  -g gencode.v27.primary_assembly.annotation.gtf 
  -f spanki.genome.fasta 
  -t sim_rpk_file -bp 100 -frag 200 -ends 2 -m errorfree
```  
for example  
```python Spanki-master/bin/spankisim_transcripts 
  -o ./fastq_file/sim_rpk1A 
  -g gencode.v27.primary_assembly.annotation.gtf 
  -f GRCh38.primary_assembly.genome.spanki.fa 
  -t sim_rpk1A -bp 100 -frag 200 -ends 2 -m errorfree
```  
