#!/bin/bash                                                                                                                                                                          

## SLURM chunk
#SBATCH --job-name=dada2                                                                                                                                                             
#SBATCH --output=slurm-%j.out                                                                                                                                                        
#SBATCH --error=slurm-%j.error                                                                                                                                                       
###SBATCH --time=1-00:00:00                                                                                                                                                          
#SBATCH --cpus-per-task=48                                                                                                                                                           
#SBATCH --ntasks-per-node=1                                                                                                                                                          
###SBATCH --nodes=1                                                                                                                                                                  
#SBATCH --mem=200G                                                                                                                                                                   
#SBATCH  --export=ALL                                                                                                                                                                

## Load R as module
module load R/R-3.5.0

## Run your R script in batch mode
R CMD BATCH dada2_script.r dada2.out
