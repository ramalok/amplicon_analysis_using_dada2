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

module purge
module load cutadapt


for i in $(ls *fastq.gz | cut -f 1 -d - | uniq); do cutadapt --discard-untrimmed  -g CCAGCASCYGCGGTAATTCC  -G ACTTTCGTTCTTGATYRR  -m 100 -M 350 --match-read-wildcards --pair-filter=both -q 10  -o $i-MSEukBalz_R1.clipped.fastq.gz -p $i-MSEukBalz_R2.clipped.fastq.gz $i-MSEukBalz_R1.fastq.gz $i-MSEukBalz_R2.fastq.gz; done


### Cutadapt tuned for V4 primers 18S

## Adapted for Balzano primers
# 18S: V4F and V4RB( Balzano_et_al_2015).
# V4F: (5’-CCA GCA SCY GCG GTA ATT CC-3’)
# V4RB: (5’-ACT TTC GTT CTT GAT YRR-3’)


