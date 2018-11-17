## Rscript 

## load dada2
library(dada2); packageVersion("dada2")

setwd(my/working/directoy) ## Set your working directory

getwd()  # check working directory

## NB
## Fastq files gzipped and with primers removed
## Primers can be removed using Cutadapt e.g.
## Before running the script, put your *R1.fastq.gz in pathF and your *R2.fastq.gz in pathR

## Define path

pathF <- file.path(getwd(), "pathF")
pathR <- file.path(getwd(), "pathR")


## Define filtered path

filtpathF <- file.path(pathF, "filtered") # Filtered forward files go into the pathF/filtered/ subdirectory
filtpathR <- file.path(pathR, "filtered") # ...

## sort names
fastqFs <- sort(list.files(pathF, pattern="fastq.gz"))
fastqRs <- sort(list.files(pathR, pattern="fastq.gz"))

if(length(fastqFs) != length(fastqRs)) stop("Forward and reverse files do not match.")



#### Quality Check  ## Testing Phase
#### Plotting steps need to be done interactively

##fullPathF <- list.files(pathF, pattern="fastq.gz", full.names = TRUE)
##fullPathR <- list.files(pathR, pattern="fastq.gz", full.names = TRUE)

##plot_qualsF<-plotQualityProfile(fullPathF)
##plot_qualsR<- plotQualityProfile(fullPathR)

##ggsave("qualplotF.pdf", plot_qualsF, device="pdf")
##ggsave("qualplotR.pdf", plot_qualsR, device="pdf")

### end plot



### Filter by quality

# Filtering: THESE PARAMETERS ARENT OPTIMAL FOR ALL DATASETS: i.e. you need to adjust these parameters according to your dataset
  filterAndTrim(fwd=file.path(pathF, fastqFs), filt=file.path(filtpathF, fastqFs),
              rev=file.path(pathR, fastqRs), filt.rev=file.path(filtpathR, fastqRs),
###              truncLen=c(240,190), maxEE=c(5,6), truncQ=2, maxN=0, rm.phix=TRUE,¬ 
###              truncLen=c(240,200), maxEE=c(2,4), truncQ=2, maxN=0, rm.phix=TRUE,  
              truncLen=c(220,200), maxEE=c(2,4), truncQ=2, maxN=0, rm.phix=TRUE, 
###              truncLen=c(240,180), maxEE=c(12,20), truncQ=2, maxN=0, rm.phix=TRUE,
              compress=TRUE, verbose=TRUE, multithread=TRUE)


## Infer sequence variants

## File parsing

filtpathF <- file.path(getwd(), "pathF","filtered")
filtpathR <- file.path(getwd(), "pathR","filtered")


filtFs <- list.files(filtpathF, pattern="fastq.gz", full.names = TRUE)
filtRs <- list.files(filtpathR, pattern="fastq.gz", full.names = TRUE)

## Important: adjust characters that need to act as delimiters

sample.names <- sapply(strsplit(basename(filtFs), "_R1.c"), `[`, 1) # Fix according to filename
sample.namesR <- sapply(strsplit(basename(filtRs), "_R2.c"), `[`, 1) # Fix according to filename
if(!identical(sample.names, sample.namesR)) stop("Forward and reverse files do not match.")
names(filtFs) <- sample.names
names(filtRs) <- sample.names
set.seed(100)


# Learn forward error rates

errF <- learnErrors(filtFs, nread=1e6, multithread=TRUE)
# Learn reverse error rates
errR <- learnErrors(filtRs, nread=1e6, multithread=TRUE)
# Sample inference and merger of paired-end reads
mergers <- vector("list", length(sample.names))
names(mergers) <- sample.names
for(sam in sample.names) {
  cat("Processing:", sam, "\n")
  derepF <- derepFastq(filtFs[[sam]])
  ddF <- dada(derepF, err=errF, multithread=TRUE)
  derepR <- derepFastq(filtRs[[sam]])
  ddR <- dada(derepR, err=errR, multithread=TRUE)
  merger <- mergePairs(ddF, derepF, ddR, derepR)
  mergers[[sam]] <- merger
}
rm(derepF); rm(derepR)


# Construct sequence table and remove chimeras
seqtab <- makeSequenceTable(mergers)


### Save the resulting table. This "raw" table will be used if you are later merging datasets

saveRDS(seqtab, file.path(getwd(),"seqtab.rds"))

str(seqtab)


# Read table (if necessary)

## st1 <- readRDS(file.path(getwd(),"seqtab.rds"))


# Remove chimeras
seqtab_nochim <- removeBimeraDenovo(seqtab, method="consensus", multithread=TRUE)


dim(seqtab_nochim)

pdf(file.path(getwd(),"seqlen.pdf"))
plot(table(nchar(getSequences(seqtab_nochim))))
dev.off()


# Assign taxonomy

tax <- assignTaxonomy(seqtab_nochim, "/pathTO/silva_nr_v132_train_set.fa.gz", multithread=TRUE)
tax_add <- addSpecies(tax, "/pathTO/silva_species_assignment_v132.fa.gz")

str(tax)


# Write to disk

saveRDS(seqtab_nochim, file.path(getwd(),"seqtab_final.rds"))
saveRDS(tax, file.path(getwd(),"tax_final.rds"))
saveRDS(tax_add, file.path(getwd(),"tax_add_final.rds"))


## Check taxa
taxa.print <- tax # Removing sequence rownames for display only
rownames(taxa.print) <- NULL
head(taxa.print)

### Use another script to merge runs and generate tables
