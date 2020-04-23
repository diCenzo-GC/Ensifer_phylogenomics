#!/usr/bin/env Rscript

setwd('Pangenome_calculation/Pangenome_overlap/')
library(data.table)

Pangenome_table <- read.table('../../Output_files/pangenomeSummaryTable.txt', header = T, sep = '\t')

tdt <- function(inpdt){
    transposed <- t(inpdt[,-1]);
    colnames(transposed) <- inpdt[[1]];
    transposed <- data.table(transposed, keep.rownames=T);
    setnames(transposed, 1, names(inpdt)[1]);
    return(transposed);
}

Transposed_right <- tdt(Pangenome_table)
write.table(Transposed_right, 'Transposed_right.txt', sep = '\t', row.names = F )
quit("no")

