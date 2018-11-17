  ## Analysis of amplicons using dada2 (https://benjjneb.github.io/dada2/) implemented to work in slurm clusters

### Things to consider:

> 1) What is the lenght of your reads?
> 2) Where reads generated in a way all are in the same direction? (i.e. re reads in the 5-3 and 3-5 direction in your fastq?)
> 3) Reads from different runs should be processed separately
> 4) If you want to merge reads from different runs later on, use the same sequence quality thresholds (at least trimming length)
> 5) Primers should be removed before dada2 analyses (with e.g. https://cutadapt.readthedocs.io/en/stable/)
 
 
 
 ### Steps

> 1) Generate your dada r code for each MiSeq run and run it in your cluster
> 2) Merge relevant runs
