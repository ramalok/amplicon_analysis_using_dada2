#!/bin/bash                                                                                                                                                                                                                                                                        

#SBATCH --job-name=cutadapt                                                                                                                                                                                                                                                        
#SBATCH --output=slurm-%j.out                                                                                                                                                                                                                                                      
#SBATCH --error=slurm-%j.error                                                                                                                                                                                                                                                     
###SBATCH --time=1-00:00:00                                                                                                                                                                                                                                                        
#####SBATCH --cpus-per-task=24                                                                                                                                                                                                                                                     
#SBATCH --ntasks-per-node=1                                                                                                                                                                                                                                                        
###SBATCH --nodes=1                                                                                                                                                                                                                                                                
#SBATCH --mem=50G                                                                                                                                                                                                                                                                  
#SBATCH  --export=ALL                                                                                                                                                                                                                                                              

## Using Cutadapt

module purge
module load cutadapt



### Cutadapt tuned for V4V5 Parada primers (16S)                                                                                                                                                                                                                                   

for i in $(ls *fastq.gz | cut -f 1 -d - | uniq); do cutadapt --discard-untrimmed -g GTGYCAGCMGCCGCGGTAA  -G CCGYCAATTYMTTTRAGTTT  -m 100 -M 350 --match-read-wildcards --pair-filter=both -q 10  -o $i-515yF-926pfR_R1.clipped.fastq.gz -p $i-515yF-926pfR_R2.clipped.fastq.gz $i-\
515yF-926pfR_R1.fastq.gz $i-515yF-926pfR_R2.fastq.gz; done

