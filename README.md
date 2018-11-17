  ## Analysis of amplicons using dada2 (https://benjjneb.github.io/dada2/) implemented to work in slurm clusters

### Things to consider:

> 1) What is the length of your reads?
> 2) Were reads generated in a way that all are in the same direction? (i.e. do you have reads in the 5-3 and 3-5 direction in your fastq?)
> 3) Reads from different MiSeq runs should be processed separately (i.e. different runs likely have different error profiles)
> 4) QC parameters tend to differ between runs, so this needs to be adjusted
> 5) If you want to merge different dada2 runs, use the same quality thresholds during sequence QC in each of them (at least trimming length)
> 6) Primers should be removed before dada2 analyses (with e.g. https://cutadapt.readthedocs.io/en/stable/ or similar)
 
 
 
 ### Steps

> 1) Generate your dada r code for each MiSeq run and run it in your cluster
> 2) Merge relevant runs
