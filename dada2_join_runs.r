##Rscript
## load dada2
library(dada2); packageVersion("dada2")


# Merge multiple runs 

## Load datasets
st1 <- readRDS("/pathTO/seqtab_run1.rds")  # Load Run1
st2 <- readRDS("/pathTO/seqtab_run2.rds")  # Load Run2
st3 <- readRDS("/pathTO/seqtab_run3.rds")  # Load Run3

## Join runs
st.all <- mergeSequenceTables(st3, st1, st2) # Merge in the order the table needs to be merged

## Merging order
## 1. st3, 2. st1, 3. st2


# #Remove chimeras for ALL datasets
seqtab <- removeBimeraDenovo(st.all, method="consensus", multithread=TRUE)


## Assign taxonomy

tax <- assignTaxonomy(seqtab, "/pathTO/silva_nr_v132_train_set.fa.gz", multithread=TRUE)


saveRDS(seqtab, "MyMergedDADA2run_seqtab.rds")
saveRDS(tax, "MyMergedDADA2run_tax.rds")

## Generate ASV table

write.csv(cbind(t(seqtab), tax), "MyMergedDADA2run_seqtab.csv", quote=FALSE)

##DONE

